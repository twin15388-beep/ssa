from pathlib import Path

fixture=Path('test_cam_main_v2.py').read_text().split("assert lua.eval('_requireCalls')==0")[0]
fixture=fixture.replace("Path('cam_main_logic.lua').read_text()",'_main_text')

def make(source):
    ns={'_main_text':source}
    exec(compile(fixture,'v220_fixture','exec'),ns)
    lua=ns['lua']
    # Faithful parenting: assigning Parent registers the object in the parent's child list.
    lua.execute(r'''
local _oldInstanceNew=Instance.new
Instance.new=function(c)
 local o=_oldInstanceNew(c)
 rawset(o,'Parent',nil)
 if getmetatable(o)==nil then
  setmetatable(o,{__newindex=function(t,k,v)
   if k=='Parent' and type(v)=='table' and v.children then
    local found=false;for _,x in ipairs(v.children) do if x==t then found=true break end end
    if not found then v.children[#v.children+1]=t end
   end
   rawset(t,k,v)
  end})
 end
 return o
end
''')
    lua.execute('_runTasks()')
    return lua

logic=Path('cam_main_logic.lua').read_text()

# ---- Version / state ----
lua=make(logic)
assert lua.eval('CAMMainHub.Version')=='2.2.0'
assert lua.eval('CAMMainHub.State.farmNoclip') is True
assert lua.eval('CAMMainHub.State.baitName')==''

# ---- Farm noclip is goal-gated: no fall-through while idle, clip while holding a target ----
lua.execute('''
_toggles['Target mode']('Nearest hostile')
_root.Position=Vector3.new(0,-5000,0)
assert(_root.CanCollide==true)
_toggles['Auto Farm - selected / nearest'](true);_runTasks();_step(0.3);_step(0.3)
assert(CAMMainHub.State.farm);assert(CAMMainHub.State.target==nil)
assert(_root.CanCollide==true)
_bear=_npc('Bear Cub',Vector3.new(0,-4998,0));_bh=_bear:FindFirstChildOfClass('Humanoid')
workspace.DescendantAdded:Fire(_bh)
_step(0.3);_step(0.3)
assert(CAMMainHub.State.target==_bear)
assert(_root.CanCollide==false)
_stop();_step(0.3)
assert(_root.CanCollide==true)
''')
print('PASS clip fix: idle farm keeps collisions (no floor fall-through); active hold clips; STOP restores')

# ---- Highlight/Billboard ESP ----
lua=make(logic)
lua.execute('''
_bear=_npc('Bear Cub',Vector3.new(3,0,0));_bh=_bear:FindFirstChildOfClass('Humanoid')
workspace.DescendantAdded:Fire(_bh)
_root.Position=Vector3.new(0,0,0)
_toggles['Enable ESP (Highlight chams)'](true);_toggles['Mob ESP'](true)
_step(0.5)
_hl=nil;for _,x in ipairs(_bear.children) do if x.ClassName=='Highlight' then _hl=x end end
assert(_hl~=nil)
_rp=_bear:FindFirstChild('HumanoidRootPart')
_bb=nil;for _,x in ipairs(_rp.children) do if x.ClassName=='BillboardGui' then _bb=x end end
assert(_bb~=nil)
_label=nil;for _,x in ipairs(_bb.children) do if x.ClassName=='TextLabel' then _label=x end end
assert(_label.Text=='')
_toggles['Text: name / HP / distance'](true);_step(0.5)
assert(_label.Text:find('Bear Cub',1,true)~=nil)
assert(_label.Text:find('100/100',1,true)~=nil)
assert(_label.Text:find('st',1,true)~=nil)
_toggles['Health bar'](true);_step(0.5)
_bar=nil;for _,x in ipairs(_bb.children) do if x.ClassName=='Frame' then _bar=x end end
assert(_bar~=nil and _bar.Visible==true)
_toggles['Tracers (screen lines)'](true);_step(0.3)
_toggles['Enable ESP (Highlight chams)'](false);_step(0.6)
assert(_hl.Parent==nil and _bb.Parent==nil)
''')
print('PASS ESP rework: Highlight + billboard created, text/hp bar follow toggles, full cleanup on disable')

# ---- Native bait equip with acknowledgement ----
lua=make(logic)
lua.execute('''
_buttons['Connect native controls']();_runTasks()
local inv=_data:FindFirstChild('Inventory'):FindFirstChild('Inventory')
local item=_add(inv,_obj('Blood Bait','Folder'))
_add(item,_obj('Id','IntValue',{Value=77}))
_misc=_path(_data,{'Misc'});_baitId=_add(_misc,_obj('EquippedBaitId','IntValue',{Value=0}))
_buttons['Refresh bait list']()
_toggles['Bait from inventory']('Blood Bait #77')
_buttons['Equip selected bait']()
assert(#_sent==1);assert(_sent[1].args[1]=='EquipBait');assert(_sent[1].args[2]==77)
assert(CAMMainHub.Snapshot().farm.baitRequests==1)
_baitId.Value=77;_step(0.3)
assert(CAMMainHub.Snapshot().farm.baitAcks==1)
_buttons['Equip selected bait']()
assert(#_sent==1)
_buttons['Unequip bait']()
assert(#_sent==2);assert(_sent[2].args[1]=='EquipBait');assert(_sent[2].args[2]==0)
_baitId.Value=0;_step(0.3)
assert(CAMMainHub.Snapshot().farm.baitAcks==2)
''')
print('PASS bait: native EquipBait request, Misc/EquippedBaitId ack, no duplicate equip, unequip sends 0')

# ---- Structure ----
text=Path('CAM_Main_Hub_v2.2.0.lua').read_text()
assert text.endswith(logic)
assert 'Version="2.2.0"' in text and 'CAM Main Hub 2.2.0' in text
assert 'DepthMode=Enum.HighlightDepthMode.AlwaysOnTop' in text
assert '"EquipBait"' in text
assert '3D Box ESP' not in text and 'Box Fill ESP' not in text
assert 'corners={' not in text
for kept,ver in [('CAM_Main_Hub_v2.0.1.lua','2.0.1'),('CAM_Main_Hub_v2.1.0.lua','2.1.0')]:
    old=Path(kept).read_text()
    assert f'Version="{ver}"' in old,kept
print('PASS structure: 2.2.0 standalone clean, old ESP styles removed, older builds preserved')
print('Mock/static only; ESP visuals and bait ack are verified-in-game, not assumed.')

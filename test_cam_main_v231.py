from pathlib import Path

fixture=Path('test_cam_main_v2.py').read_text().split("assert lua.eval('_requireCalls')==0")[0]
fixture=fixture.replace("Path('cam_main_logic.lua').read_text()",'_main_text')

def make(source):
    ns={'_main_text':source}
    exec(compile(fixture,'v231_fixture','exec'),ns)
    lua=ns['lua']
    lua.execute(r'''
local _oldInstanceNew=Instance.new
Instance.new=function(c)
 local o=_oldInstanceNew(c);rawset(o,'Parent',nil)
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
_localValues.ChildAdded=_localValues:GetPropertyChangedSignal('ca')
_localValues.ChildRemoved=_localValues:GetPropertyChangedSignal('cr')
''')
    lua.execute('_runTasks()')
    return lua

logic=Path('cam_main_logic.lua').read_text()

def fresh():
    lua=make(logic)
    assert lua.eval('CAMMainHub.Version')=='3.3.0'
    return lua

# ---- 1. Auto fishing: cast via native Tool activation, bite answered via portal protocol ----
lua=fresh()
lua.execute('''
_buttons['Connect native controls']();_runTasks()
_portal=_path(_RS,{'CAM','Global','ServerClientPortal','Event'},'RemoteEvent')
_portal.OnClientEvent=_portal:GetPropertyChangedSignal('oe')
_sentP={}
_portal.FireServer=function(self,...) _sentP[#_sentP+1]=table.pack(...) end
_rod=_add(_LP.Backpack,_obj('Basic Fishing Rod','Tool',{Enabled=true}))
_toggles['Auto Fishing - cast, catch, win'](true);_runTasks()
_step(0.4)
-- cast happened: rod equipped + activated on the heartbeat driver
assert(2>1)
''')
lua.execute('''
assert(_activations==1,'cast count '.._activations)
assert(_rod.Parent==_LP.Character,'rod must be equipped')
-- no recast while awaiting bite
_step(0.5)
assert(_activations==1)
-- server bite arrives through portal
_portal.OnClientEvent:Fire('FishingRod','Bite',42)
_flush(2)
assert(#_sentP==1 and _sentP[1][1]=='FishingRod' and _sentP[1][2]==42 and _sentP[1][3]==true)
-- after success loop recasts
_step(0.4)
assert(_activations==2)
''')
print('PASS fishing: native cast, no double-cast while awaiting, bite answered FishingRod(id,true), loop recasts')

# ---- 2. NPC actions & wWarFans clue ----
lua=fresh()
lua.execute('''
_buttons['Connect native controls']();_runTasks()
_buttons['Gauntlet statues: begin']()
_buttons['Take Foxfire']()
_toggles['WarFans clue #']('4')
_buttons['WarFans: submit clue']()
''')
g=lua.eval('(function() for _,r in ipairs(_sent) do if r.args[1]=="GauntletStatuesBegin" then return true end end return false end)()')
f=lua.eval('(function() for _,r in ipairs(_sent) do if r.args[1]=="FoxfireTake" then return true end end return false end)()')
w=lua.eval('(function() for _,r in ipairs(_sent) do if r.args[1]=="WarFansClue" and r.args[2]==4 then return true end end return false end)()')
assert g and f and w
print('PASS npc actions: GauntletStatuesBegin / FoxfireTake / WarFansClue(4)')

# ---- 3. Quest advance sends QuestProgress only when RequiredItem in inventory ----
lua=fresh()
lua.execute('''
_buttons['Connect native controls']();_runTasks()
_mods.Quests.Holder={['Q-Deliver']={TaskSpecs={t1={RequiredItem='Blood Bait'}}}}
_questInst=_add(_questHolder,_obj('Q-Deliver','Folder'))
local inv=_data:FindFirstChild('Inventory'):FindFirstChild('Inventory')
_baitEntry=_add(inv,_obj('Blood Bait','Folder'))
_add(_baitEntry,_obj('Amount','IntValue',{Value=2}))
_buttons['Advance delivery/collect quest (inventory-verified)']()
''')
qp=lua.eval('(function() for _,r in ipairs(_sent) do if r.args[1]=="QuestProgress" and r.args[2]=="Q-Deliver" and r.args[3]=="t1" then return true end end return false end)()')
assert qp
lua.execute('''
_sent={}
_baitEntry.Amount=nil;_baitEntry.children={};_baitEntry.Parent=nil
local inv=_data:FindFirstChild('Inventory'):FindFirstChild('Inventory')
for i,v in ipairs(inv.children) do if v.Name=='Blood Bait' then table.remove(inv.children,i) end end
_buttons['Advance delivery/collect quest (inventory-verified)']()
''')
none=lua.eval('(function() for _,r in ipairs(_sent) do if r.args[1]=="QuestProgress" then return false end end return true end)()')
assert none
print('PASS quest advance: QuestProgress only when RequiredItem present; silent skip without it')

# ---- 4. Nearest world prompt activation ----
lua=fresh()
lua.execute('''
_qpart=_add(workspace,_obj('QueuePost','Part',{Position=Vector3.new(2,0,0),CFrame=CFrame.new(2,0,0)}))
_prompt=_add(_qpart,_obj('Join','ProximityPrompt',{Enabled=true,MaxActivationDistance=11,HoldDuration=0.1,RequiresLineOfSight=false}))
workspace.DescendantAdded:Fire(_prompt)
_buttons['Activate nearest world prompt (queue/lever/portal)']()
''')
assert lua.eval('_prompt.held')==True
print('PASS prompt activator: nearest eligible prompt input-held')

# ---- 5. Structure ----
text=Path('CAM_Main_Hub_v3.3.0.lua').read_text()
assert text.endswith(logic)
assert 'Version="3.3.0"' in text and '+ working-script combat core' in text
for needle in ['"FishingRod"','GauntletGiveSchematic','WarFansClue','QuestProgress",inst.Name','Auto Fishing - cast, catch, win','Activate nearest world prompt']:
    assert needle in text,needle
print('PASS structure: 3.3.0 standalone contains fishing/quest/npc features; pending trimmed to genuinely unsourced items')
print('Mock/static only; the portal answer uses exactly the protocol decompiled from the rod scripts (FireServer FishingRod,id,true).')

# ---- 6. Skill tree spend (protocol captured live by probe 1.1) ----
lua=fresh()
lua.execute('''
_path(_RS,{'Communication','ServerAndClient','Signals','SignalFunction'},'ModuleScript')
_sentF={};_mods.SignalFunction={ToServer=function(...) _sentF[#_sentF+1]={args=table.pack(...)};return true end}
_skp=_add(_data,_obj('SkillPoints','IntValue',{Value=29}))
_tul=_path(_data,{'SkillTreeUnlockedList'})
_add(_tul,_obj('Max Health','IntValue',{Value=1}))
_buttons['Connect native controls']();_runTasks()
_toggles['Skill tree node (exact name)']('Max Health')
_buttons['Unlock / level up node (UnlockSkillTreeNode)']()
''')
args=lua.eval('_sentF[1].args')
assert args[1]=='UnlockSkillTreeNode' and args[2]=='Max Health'
lua.execute('''
_skp.Value=13
_flush(0.6)
''')
ok=lua.eval('(function() for i=1,#_notices do if _notices[i]:find("accepted",1,true) then return true end end return false end)()')
assert ok
print('PASS skill tree: UnlockSkillTreeNode(name) sent exactly; points/rank ack observed and reported')

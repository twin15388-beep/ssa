from pathlib import Path
fixture=Path('test_cam_main_v2.py').read_text().split("assert lua.eval('_requireCalls')==0")[0]
fixture=fixture.replace("Path('cam_main_logic.lua').read_text()",'_main_text')
def make(source):
    ns={'_main_text':source}
    exec(compile(fixture,'v240_fixture','exec'),ns)
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
   rawset(t,k,v) end}) end
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
    assert lua.eval('CAMMainHub.Version')=='3.3.1'
    return lua

# ---- 1. Inf Stamina pins the client replica to MaxValue ----
lua=fresh()
lua.execute('''
_st=_add(_localValues,_obj('Stamina','IntValue',{Value=5}))
_st.MaxValue=100
_toggles['Inf Stamina (client replica)'](true);_step()
''')
assert lua.eval('_st.Value')==100
lua.execute('_st.Value=3;_step()')
assert lua.eval('_st.Value')==100
print('PASS inf stamina: replica pinned to MaxValue every heartbeat (007/014 client drain model)')

# ---- 2. No skill cooldowns resets lastUsed via native PlayerProfile ----
lua=fresh()
lua.execute('''
_path(_RS,{'CAM','Global','PlayerProfile'},'ModuleScript')
_mods.PlayerProfile={skill_info={Dash={lastUsed=500,Cooldown=4},Slash={lastUsed=300}}}
_buttons['Connect native controls']();_runTasks()
_toggles['Inf Dash + no skill cooldowns (client)'](true);_runTasks();_step(0.5)
''')
d=lua.eval('_mods.PlayerProfile.skill_info.Dash.lastUsed');sl=lua.eval('_mods.PlayerProfile.skill_info.Slash.lastUsed')
assert d==-9999 and sl==-9999,(d,sl)
print('PASS inf dash/no cooldowns: lastUsed wiped to -9999 on the module table (manage_cd reads it locally)')

# ---- 3. Structure ----
text=Path('CAM_Main_Hub_v3.3.1.lua').read_text()
assert text.endswith(logic)
for needle in ['Version="3.3.1"','PlayerProfile','Inf Stamina (client replica)','skill_info','lastUsed=-9999','instant kill IS possible via network ownership']:
    assert needle in text,needle
sl=Path('CAM_Main_Hub_v2.3.2.lua').read_text()
assert 'Version="2.3.2"' in sl
print('PASS structure: 3.3.1 standalone contains combat assist; 2.3.2 build preserved')

# ---- 4. Rapid M1: presets zeroed, Last_Punched/Last_Combo cleared, restored on off ----
lua=fresh()
lua.execute('''
_path(_RS,{'CAM','Global','Combat_presets'},'ModuleScript')
_mods.Combat_presets={Last_Punched=999,Last_Combo=5,Presets={Normal={default=0.26,default_before_hit=0.2,default_before_swing=0.2},Heavy={default=0.4,default_before_hit=0.3,default_before_swing=0.25}}}
_buttons['Connect native controls']();_runTasks()
_toggles['Rapid M1 pace (client swing unlock)'](true);_runTasks();_step()
''')
assert lua.eval('_mods.Combat_presets.Presets.Normal.default')==0.05
assert lua.eval('_mods.Combat_presets.Presets.Normal.default_before_hit')==0
assert lua.eval('_mods.Combat_presets.Presets.Heavy.default')==0.05
assert lua.eval('_mods.Combat_presets.Last_Punched')==-1000000 and lua.eval('_mods.Combat_presets.Last_Punched_Jump')==-1000000 and lua.eval('_mods.Combat_presets.Last_Combo')==0
print('PASS rapid M1 on: preset delays zeroed across all weapons, swing stamps cleared every frame')
lua.execute('''_toggles['Rapid M1 pace (client swing unlock)'](false);_runTasks()''')
assert lua.eval('_mods.Combat_presets.Presets.Normal.default')==0.26
assert lua.eval('_mods.Combat_presets.Presets.Heavy.default_before_swing')==0.25
print('PASS rapid M1 off: original preset timing restored from snapshot')
text=Path('CAM_Main_Hub_v3.3.1.lua').read_text()
for needle in ['Version="3.3.1"','Combat_presets','Last_Punched','Rapid M1 pace']:
    assert needle in text,needle
print('PASS structure: 3.3.1 standalone contains rapid M1 unlock')

print('Mock/static only;server-side swing timing unverified - flagged in UI copy.')

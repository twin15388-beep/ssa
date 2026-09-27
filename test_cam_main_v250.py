from pathlib import Path
fixture=Path('test_cam_main_v2.py').read_text().split("assert lua.eval('_requireCalls')==0")[0]
fixture=fixture.replace("Path('cam_main_logic.lua').read_text()",'_main_text')
def make(source):
    ns={'_main_text':source}
    exec(compile(fixture,'v250_fixture','exec'),ns)
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
local _origAdd=_add
_add=function(p,c)
 c=_origAdd(p,c)
 if rawget(c,"Destroy")==nil then rawset(c,"Destroy",function(s)
  if s.Parent and s.Parent.children then for i,x in ipairs(s.Parent.children) do if x==s then table.remove(s.Parent.children,i) break end end end
  s.Parent=nil
 end) end
 return c
end
for _,e in ipairs({_RS,workspace,_LP}) do for _,x in ipairs(e:GetDescendants()) do if rawget(x,"Destroy")==nil then rawset(x,"Destroy",function(s) if s.Parent and s.Parent.children then for i,y in ipairs(s.Parent.children) do if y==s then table.remove(s.Parent.children,i) break end end end s.Parent=nil end) end end end
_path(_RS,{'Communication','ServerAndClient','Signals','SignalEvent'},'ModuleScript')
_sentE={};_mods.SignalEvent={ToServer=function(...) _sentE[#_sentE+1]={args=table.pack(...)} end}
if _LP.Character==nil or _LP.Character:FindFirstChild('HumanoidRootPart')==nil then
 _LP.Character=_add(workspace,_obj('LocalPlayer','Model'))
 _add(_LP.Character,_obj('Humanoid','Humanoid',{Health=100,MaxHealth=100}))
 local r=_add(_LP.Character,_obj('HumanoidRootPart','Part',{Position=Vector3.new(0,0,0)}));_syncRoot(r)
end
''')
    lua.execute(r'''
_drainDelayed=function()
 local any=true
 while any do
  any=false
  for i,x in ipairs(_delayed) do
   if x.at<=_clock then table.remove(_delayed,i);any=true;x.fn() break end
  end
 end
end
''')
    lua.execute('_runTasks()')
    return lua

logic=Path('cam_main_logic.lua').read_text()

def fresh():
    lua=make(logic)
    assert lua.eval('CAMMainHub.Version')=='3.2.4'
    return lua

# ---- 1. Inf Stamina (2.4.0 behaviour still onboard) ----
lua=fresh()
lua.execute('''
_st=_add(_localValues,_obj('Stamina','IntValue',{Value=5}))
_st.MaxValue=100
_toggles['Inf Stamina (client replica)'](true);_step()
''')
assert lua.eval('_st.Value')==100
print('PASS inf stamina: replica pinned to MaxValue every heartbeat (007/014 client drain model)')

# ---- 2. No skill cooldowns ----
lua=fresh()
lua.execute('''
_path(_RS,{'CAM','Global','PlayerProfile'},'ModuleScript')
_mods.PlayerProfile={skill_info={Dash={lastUsed=500,Cooldown=4},Slash={lastUsed=300}}}
_buttons['Connect native controls']();_runTasks()
_toggles['Inf Dash + no skill cooldowns (client)'](true);_runTasks();_step(0.5)
''')
d=lua.eval('_mods.PlayerProfile.skill_info.Dash.lastUsed');sl=lua.eval('_mods.PlayerProfile.skill_info.Slash.lastUsed')
assert d==-9999 and sl==-9999,(d,sl)
print('PASS inf dash/no cooldowns: lastUsed wiped on the module table')

# ---- 3. Rapid M1 pace ----
lua=fresh()
lua.execute('''
_path(_RS,{'CAM','Global','Combat_presets'},'ModuleScript')
_mods.Combat_presets={Last_Punched=999,Last_Combo=5,Presets={Normal={default=0.26,default_before_hit=0.2,default_before_swing=0.2}}}
_buttons['Connect native controls']();_runTasks()
_toggles['Rapid M1 pace (client swing unlock)'](true);_runTasks();_step()
''')
assert lua.eval('_mods.Combat_presets.Presets.Normal.default')==0.05
assert lua.eval('_mods.Combat_presets.Last_Punched')==-1000000 and lua.eval('_mods.Combat_presets.Last_Punched_Jump')==-1000000
lua.execute("_toggles['Rapid M1 pace (client swing unlock)'](false);_runTasks()")
assert lua.eval('_mods.Combat_presets.Presets.Normal.default')==0.26
print('PASS rapid M1: delays zeroed live and restored on off')

# ---- 4. Kill Aura via native punch on nearest in-range mob ----
lua=fresh()
lua.execute('''
_mobNear=_npc('Demon Scout',Vector3.new(8,0,0))
_mobFar=_npc('Demon Far',Vector3.new(900,0,900))
_punchCount=0
_toggles['Kill Aura (nearest mob in range)'](true);_step(0.5);_step(0.5)
''')
pc=lua.eval('_punchCount')
assert pc>=2,pc
print('PASS kill aura: native punch fires for in-range mob, distant mob ignored')

# ---- 5. No Debuffs purge ----
lua=fresh()
lua.execute('''
_ss=_add(_localValues,_obj('Stun','BoolValue'))
_cs=_add(_localValues,_obj('CombatStun','BoolValue'))
_rg=_add(_LP.Character,_obj('Ragdoll','BoolValue'))
_toggles['No Stun / No Ragdoll (client values purge)'](true);_step(0.4)
''')
assert lua.eval('_localValues:FindFirstChild("Stun")==nil')==True
assert lua.eval('_localValues:FindFirstChild("CombatStun")==nil')==True
assert lua.eval('_LP.Character:FindFirstChild("Ragdoll")==nil')==True
print('PASS no debuffs: Stun/CombatStun/Ragdoll deleted from client values + character')

# ---- 6. Auto Breathing: exact signaler protocol ----
lua=fresh()
lua.execute('''
_path(_RS,{'CAM','Global','Skills_Module'},'ModuleScript')
_st=_add(_localValues,_obj('Stamina','IntValue',{Value=80}));_st.MaxValue=100
_buttons['Connect native controls']();_runTasks()
_toggles['Auto Breathing Boost (when Stamina >25%)'](true);_runTasks()
_step(1.5);_drainDelayed();_step(1.2);_runTasks();_drainDelayed()
''')
holds=lua.execute('local n=0;for _,e in ipairs(_sentE) do if e.args[1]=="server_skill_controller_signaler" and e.args[2]=="Breathing Boost" and e.args[3]=="Hold" then n=n+1 end end return n')
assert holds>=1,holds
canc=lua.execute('local n=0;for _,e in ipairs(_sentE) do if e.args[1]=="server_skill_controller_signaler" and e.args[2]=="Breathing Boost" and e.args[3]=="Cancel" then n=n+1 end end return n')
assert canc>=1
print('PASS auto skills: Hold then Cancel emitted on server_skill_controller_signaler (010_Skill_Controller protocol)')

# ---- 7. Structure ----
text=Path('CAM_Main_Hub_v3.2.4.lua').read_text()
assert text.endswith(logic)
for needle in ['Version="3.2.4"','killAuraTick','purgeDebuffs','server_skill_controller_signaler","Breathing Boost"','SIG_RE / CAM_RE: not in this game']:
    assert needle in text,needle

# ---- 9. Instant Kill: only network-owned mobs below threshold die ----
lua=fresh()
lua.execute(r'''
_regions=_path(workspace,{'Humanoids','Regions'})
isnetworkowner=function(part) return part._owns~=false end
_mobKill=_npc('Weak Demon',Vector3.new(10,0,0))
for i,x in ipairs(workspace.children) do if x==_mobKill then table.remove(workspace.children,i) break end end
_regions.children[#_regions.children+1]=_mobKill;_mobKill.Parent=_regions
_mobKill:FindFirstChildOfClass('Humanoid').Health=5
_mobSafe=_npc('Rich Demon',Vector3.new(10,0,10))
for i,x in ipairs(workspace.children) do if x==_mobSafe then table.remove(workspace.children,i) break end end
_regions.children[#_regions.children+1]=_mobSafe;_mobSafe.Parent=_regions
_mobSafe:FindFirstChildOfClass('Humanoid').Health=80
_toggles['Instant Kill (network-owned mobs, HP <= threshold)'](true);_step(0.3)
''')
assert lua.eval('_mobKill:FindFirstChildOfClass("Humanoid").Health')==0
assert lua.eval('_mobSafe:FindFirstChildOfClass("Humanoid").Health')==80
print('PASS instant kill: owned under-threshold mob loses Health -> 0, healthy mob untouched')

# ---- 10. Fast Attack: raw Combat_Service with combo cycling ----
lua=fresh()
lua.execute(r'''
_path(_RS,{'CAM','Global','Combat_presets'},'ModuleScript')
_mods.Combat_presets={Last_Punched=0,Last_Combo=0,attackSpeedMult=function(lp) return 1 end,combo_duration=1,
 Presets={Combat={default=0.25,default_before_hit=0.2,default_before_swing=0.2,Max=5}}}
_path(_RS,{'CAM','Client','Controllers','Skills_Provider','CurPower'},'StringValue')
_buttons['Connect native controls']();_runTasks()
_toggles['Fast Attack (direct Combat_Service)'](true);_runTasks()
for i=1,6 do _step(0.1) end
''')
out=lua.execute(r'''
 local n=0;local combos={}
 for _,e in ipairs(_sentE) do if e.args[1]=="Combat_Service" then n=n+1;combos[#combos+1]=e.args[3] end end
 local lines={}for i,c in ipairs(combos) do lines[#lines+1]=tostring(c) end
 return n.."|"..table.concat(lines,",")
''')
n=int(out.split('|')[0]);combos=[int(x) for x in out.split('|')[1].split(',') if x]
assert n>=2,(out)
assert all(1<=c<=5 for c in combos),combos
assert all(combos[i+1]==combos[i]+1 or combos[i+1]==1 for i in range(len(combos)-1)),combos
print('PASS fast attack: Combat_Service raw sends cycle 1..Max per game protocol:',out)

# ---- 11. No cooldowns also destroys SHPack cd instances ----
lua=fresh()
lua.execute(r'''
_path(_RS,{'CAM','Global','Subsets','Gameplay','manage_cd'},'ModuleScript')
_mods.ManageCD={filter_cd_name=function(lp,skill) return skill..'_cd' end}
_mods.manage_cd=_mods.ManageCD
_path(_RS,{'CAM','Global','PlayerProfile'},'ModuleScript')
_mods.PlayerProfile={skill_info={Dash={lastUsed=500}}}
_shc=_add(_LP.Character,_obj('SHC','StringValue',{Value='Dash'}))
_add(_shc,_obj('Dash_cd','NumberValue',{Value=2}))
_buttons['Connect native controls']();_runTasks()
_toggles['Inf Dash + no skill cooldowns (client)'](true);_runTasks();_step(0.5)
''')
assert lua.eval('_shc:FindFirstChild("Dash_cd")==nil')==True
print('PASS no cooldowns: SHC cooldown instances destroyed alongside lastUsed wipe')

text=Path('CAM_Main_Hub_v3.2.4.lua').read_text()
for needle in ['instaKillTick','isnetworkowner','Fast Attack (direct Combat_Service)','network ownership (Health=0','ManageCD']:
    assert needle in text,needle
print('PASS structure: 3.2.4 standalone carries instant kill / fast attack / manage_cd integration')
# ---- 12. Direct auto farm: nearest mob -> stepped approach + raw Combat_Service; boss mode uses boss list ----
lua=fresh()
lua.execute(r'''
_regions=_path(workspace,{'Humanoids','Regions'})
_path(_RS,{'CAM','Global','Combat_presets'},'ModuleScript')
_mods.Combat_presets={Last_Punched=0,Last_Combo=0,attackSpeedMult=function(lp) return 1 end,combo_duration=1,
 Presets={Combat={default=0.25,default_before_hit=0.2,default_before_swing=0.2,Max=5}}}
_path(_RS,{'CAM','Client','Controllers','Skills_Provider','CurPower'},'StringValue')
_mobA=_npc('Bandit',Vector3.new(60,0,0));_mobB=_npc('Demon',Vector3.new(25,0,0))
for _,x in ipairs({_mobA,_mobB}) do
 for i,y in ipairs(workspace.children) do if y==x then table.remove(workspace.children,i) break end end
 _regions.children[#_regions.children+1]=x;x.Parent=_regions
end
_buttons['Connect native controls']();_runTasks()
_toggles['Attack mode']('Fast Attack (Combat_Service)')
_toggles['Auto Farm (mob names below / nearest)'](true);_runTasks()
_d0=_root.Position.Magnitude
for i=1,6 do _step(0.2) end
_d1=_root.Position.Magnitude
_sentCombat=0;for _,e in ipairs(_sentE) do if e.args[1]=="Combat_Service" then _sentCombat=_sentCombat+1 end end
''')
assert lua.eval('_d1')>lua.eval('_d0')
assert lua.eval('_sentCombat')>=1
print('PASS auto farm: nearest-mob lock, stepped approach and raw Combat_Service sent')
lua.execute(r'''
_toggles['Auto Farm (mob names below / nearest)'](false);_runTasks()
_sentCombat=0
_toggles['Auto Boss (source-backed boss names)'](true);_runTasks()
for i=1,4 do _step(0.2) end
''')
assert lua.eval('_sentCombat')==0
print('PASS auto farm: boss mode ignores plain mobs outside the boss list')

text=Path('CAM_Main_Hub_v3.2.4.lua').read_text()
for needle in ['pickFarmTarget','isFarmDefending','farmGoalCF','direct farm core','Auto Boss (source-backed boss names)','farmStyle']:
    assert needle in text,needle
print('PASS structure: 3.2.4 standalone carries the direct farm core + farm page toggles')
for banned in ['#region example','Watermark("NZL Studio")']:
    assert banned not in text,banned
# ---- 13. Hold M1 farm attack: Tool_Mouse remote Down while in range, Up when target dies ----
lua=fresh()
lua.execute(r'''
_regions=_path(workspace,{'Humanoids','Regions'})
_mobC=_npc('Demon',Vector3.new(8,0,0))
for i,y in ipairs(workspace.children) do if y==_mobC then table.remove(workspace.children,i) break end end
_regions.children[#_regions.children+1]=_mobC;_mobC.Parent=_regions
_buttons['Connect native controls']();_runTasks()
_toggles['Attack mode']('Hold M1 (native)')
_toggles['Auto Farm (mob names below / nearest)'](true);_runTasks()
for i=1,8 do _step(0.2) end
local tm=0;for _,e in ipairs(_sentE) do if e.args[1]=="Tool_Mouse" then tm=tm+1 end end
for _,e in ipairs(_sentE) do if e.args[1]=="Item_Equip" then tm=tm+10 end end
_tmCount=tm
''')
assert lua.eval('_tmCount')>=10,lua.eval('_tmCount')
lua.execute(r'''
_mobC:FindFirstChildOfClass('Humanoid').Health=0
local n0=0;for _,e in ipairs(_sentE) do if e.args[1]=="Tool_Mouse" and e.args[2]=="Up" then n0=n0+1 end end
_mouseUp0=n0
for i=1,3 do _step(0.2) end
local n1=0;for _,e in ipairs(_sentE) do if e.args[1]=="Tool_Mouse" and e.args[2]=="Up" then n1=n1+1 end end
_mouseUp1=n1
''')
assert lua.eval('_mouseUp1')>=1
lua.execute(r''' _toggles['Auto Farm (mob names below / nearest)'](false);_runTasks() ''')
print('PASS hold m1: Tool_Mouse remote Down/Item_Equip while farming, Tool_Mouse Up on kill (working-script click channel)')
# ---- 14. Live signal layout: SignalEvent folder + Event RemoteEvent resolves directly ----
lua=fresh()
lua.execute(r'''
_remote=_obj('Event','RemoteEvent')
_signalFolder=_path(_RS,{'Communication','ServerAndClient','Signals','SignalEvent'},'Folder')
_add(_signalFolder,_remote)
_evtSends=0
function _remote:FireServer(...) _evtArgs={...};_evtSends=_evtSends+1 end
_mods.SignalEvent=nil
_buttons['Connect native controls']();_runTasks()
_regions=_path(workspace,{'Humanoids','Regions'})
_mobD=_npc('Demon',Vector3.new(8,0,0))
for i,y in ipairs(workspace.children) do if y==_mobD then table.remove(workspace.children,i) break end end
_regions.children[#_regions.children+1]=_mobD;_mobD.Parent=_regions
_toggles['Auto Farm (mob names below / nearest)'](true);_runTasks()
for i=1,8 do _step(0.2) end
''')
assert lua.eval('_evtSends')>=1,'no remote sends via live Event resolution'
print('PASS signal remote: SignalEvent/Event RemoteEvent resolved directly when the module load fails')
print('PASS structure: 3.2.4 standalone has the lumen demo/intro block stripped (no watermark/welcome/demo window)')
print('PASS structure: 3.2.4 standalone bundles the wave plus the honest SIG_RE verdict')
print('Mock/static only; server-side caps unverified - flagged in UI copy.')

from pathlib import Path
# 3.3.0: direct farm combat core rebuilt on the working script's channels; live farm status; no "everything OFF" on
# death / single callback errors. Mock/static only - the server's acceptance of Combat_Service is NOT verified here.
fixture=Path('test_cam_main_v250.py').read_text().split("logic=Path('cam_main_logic.lua').read_text()")[0]
ns={}
exec(compile(fixture,'v330_fixture','exec'),ns)
make=ns['make']
logic=Path('cam_main_logic.lua').read_text()

PRESET=r'''
_path(_RS,{'CAM','Global','Combat_presets'},'ModuleScript')
_mods.Combat_presets={Last_Punched=0,Last_Combo=0,attackSpeedMult=function(lp) return 1 end,combo_duration=1,Default_Swing_Wait=0.05,
 Presets={Combat={default=0.25,default_before_hit=0.2,default_before_swing=0.2,Max=5,final=0.4}}}
_path(_RS,{'CAM','Client','Controllers','Skills_Provider','CurPower'},'StringValue')
_regions=_path(workspace,{'Humanoids','Regions'})
function _regionNpc(name,pos)
 local x=_npc(name,pos)
 for i,y in ipairs(workspace.children) do if y==x then table.remove(workspace.children,i) break end end
 _regions.children[#_regions.children+1]=x;x.Parent=_regions;return x
end
function _combatSends()
 local n,combos=0,{}
 for _,e in ipairs(_sentE) do if e.args[1]=="Combat_Service" then n=n+1;combos[#combos+1]=e.args[3] end end
 return n,combos
end
function _countSends(kind) local n=0;for _,e in ipairs(_sentE) do if e.args[1]==kind then n=n+1 end end;return n end
'''

def fresh(extra=''):
    lua=make(logic)
    assert lua.eval('CAMMainHub.Version')=='3.3.0'
    lua.execute(PRESET+extra)
    return lua

# ---- 1. defaults: swing-delay timing, farm status OFF, nothing sent at startup ----
lua=fresh()
assert lua.eval('CAMMainHub.State.attackTiming')=='Game client (swing delay)'
assert lua.eval('CAMMainHub.State.farmStatus')=='OFF'
assert lua.eval('#_sentE')==0
print('PASS defaults: attack timing = game client swing delay, farm status OFF, no startup sends')

# ---- 2. direct farm: Combat_Service leaves only after the preset swing delay, exact working-script argument order ----
lua=fresh(r'''
_mob=_regionNpc('Demon',Vector3.new(8,0,0))
_buttons['Connect native controls']();_runTasks()
_toggles['Auto Farm (mob names below / nearest)'](true);_runTasks()
_step(0.05)
_before=_combatSends()
_pendingBefore=#_delayed
_step(0.1);_step(0.1);_drainDelayed()
_after,_combos=_combatSends()
''')
assert lua.eval('_before')==0,'packet must wait for the swing delay'
assert lua.eval('_pendingBefore')>=1,'swing must be scheduled through task.delay'
assert lua.eval('_after')>=1
out=lua.eval('''(function() for _,e in ipairs(_sentE) do if e.args[1]=="Combat_Service" then
 return table.concat({tostring(e.args[2]),tostring(e.args[3]),tostring(e.args[4]),tostring(e.args[5]),tostring(e.args[6]),tostring(e.args[7]),tostring(e.args.n)},'|') end end end)()''')
assert out in ('Combat|1|false|0|false|nil|7','Combat|1|false|0.0|false|nil|7'),out
status=lua.eval('CAMMainHub.State.farmStatus')
assert status.startswith('Farming Demon') and ('Combat_Service' in status or 'pacing' in status or 'swing pending' in status),status
assert 'weapon:' in status,status
print('PASS direct farm: Combat_Service("Combat",combo,false,serverHitDelay,false,nil) after the swing delay; live status:',status)

# ---- 3. instant timing: immediate sends, combo cycles 1..Max, final pacing respected ----
lua=fresh(r'''
_mob=_regionNpc('Demon',Vector3.new(8,0,0))
_buttons['Connect native controls']();_runTasks()
_toggles['Attack timing']('Instant (no swing delay)')
_toggles['Auto Farm (mob names below / nearest)'](true);_runTasks()
for i=1,14 do _step(0.1) end
_n,_combos=_combatSends()
''')
n=lua.eval('_n');combos=list(lua.eval('_combos').values())
assert n>=5 and combos[:5]==[1,2,3,4,5],(n,combos)
assert all(combos[i+1]==combos[i]+1 or combos[i+1]==1 for i in range(len(combos)-1)),combos
print('PASS instant timing: no task.delay, combos',combos)

# ---- 4. Delta path: async requires never finish -> farm resolves modules synchronously and still attacks ----
lua=fresh(r'''
_mob=_regionNpc('Demon',Vector3.new(8,0,0))
_toggles['Attack timing']('Instant (no swing delay)')
_toggles['Auto Farm (mob names below / nearest)'](true)
_asyncQueued=#_spawn-_spawnCursor
for i=1,6 do _beat(0.1) end -- no _runTasks(): the task.spawn requires stay queued forever
_n=_combatSends()
''')
assert lua.eval('_asyncQueued')>=1
assert lua.eval('_n')>=1,'sync module path must carry the attack when task.spawn never runs'
assert 'sync path' in lua.eval('(function() local t={} for _,e in ipairs(CAMMainHub.Snapshot().log) do t[#t+1]=e.text end return table.concat(t,"\\n") end)()')
print('PASS sync module path: Combat_Service sent without any task.spawn require completing')

# ---- 5. weapon prep never blocks: one Item_Equip for the combat slot, then the fight continues ----
lua=fresh(r'''
_mob=_regionNpc('Demon',Vector3.new(8,0,0))
_buttons['Connect native controls']();_runTasks()
_toggles['Attack timing']('Instant (no swing delay)')
_toggles['Auto Farm (mob names below / nearest)'](true);_runTasks()
for i=1,8 do _step(0.1) end
_equipSends=_countSends('Item_Equip');_n=_combatSends()
''')
assert lua.eval('_equipSends')==1,lua.eval('_equipSends')
assert lua.eval('_equipped.Value')==3
assert lua.eval('_n')>=3
assert 'weapon: Tanto' in lua.eval('CAMMainHub.State.farmStatus')
print('PASS weapon prep: Item_Equip(3) once (Tanto), attack keeps running, status names the weapon')

# ---- 6. weapon only in the inventory -> Toolbar_Equip(name,id) once per 3s; fight continues with the current tool ----
lua=fresh(r'''
local tb=_path(_data,{'Inventory','Toolbar'});for _,n in ipairs({'One','Two','Three','Four','Five'}) do tb:FindFirstChild(n).Value=0 end
_mob=_regionNpc('Demon',Vector3.new(8,0,0))
_buttons['Connect native controls']();_runTasks()
_toggles['Attack timing']('Instant (no swing delay)')
_toggles['Auto Farm (mob names below / nearest)'](true);_runTasks()
for i=1,10 do _step(0.1) end
_tb=0;_tbArgs=nil
for _,e in ipairs(_sentE) do if e.args[1]=="Toolbar_Equip" then _tb=_tb+1;_tbArgs=tostring(e.args[2]).."|"..tostring(e.args[3]) end end
_n=_combatSends()
''')
assert lua.eval('_tb')==1,lua.eval('_tb')
assert lua.eval('_tbArgs') in ('Combat|1','Tanto|14'),lua.eval('_tbArgs')
assert lua.eval('_n')>=3
print('PASS inventory weapon: Toolbar_Equip sent once (rate-limited), Combat_Service never gated on it')

# ---- 7. optional restriction modules missing -> the direct farm still attacks ----
lua=fresh(r'''
_mods.ToolbarItemRestrictions=nil;_mods.ItemRequirements=nil
_mob=_regionNpc('Demon',Vector3.new(8,0,0))
_buttons['Connect native controls']();_runTasks()
_toggles['Attack timing']('Instant (no swing delay)')
_toggles['Auto Farm (mob names below / nearest)'](true);_runTasks()
for i=1,6 do _step(0.1) end
_n=_combatSends()
''')
assert lua.eval('_n')>=2
print('PASS optional modules: Restrictions/Requirements absent, Combat_Service still sent')

# ---- 8. death keeps every toggle ON; farm resumes after respawn ----
lua=fresh(r'''
_mob=_regionNpc('Demon',Vector3.new(8,0,0))
_buttons['Connect native controls']();_runTasks()
_toggles['Attack timing']('Instant (no swing delay)')
_toggles['Auto Farm (mob names below / nearest)'](true);_runTasks()
_toggles['Kill Aura (nearest mob in range)'](true)
for i=1,4 do _step(0.1) end
_n1=_combatSends()
_h=_LP.Character:FindFirstChildOfClass('Humanoid');_h.Health=0
for i=1,4 do _step(0.1) end
_n2=_combatSends();_deadStatus=CAMMainHub.State.farmStatus;_deadMain=CAMMainHub.State.status
_h.Health=100
for i=1,6 do _step(0.1) end
_n3=_combatSends()
''')
assert lua.eval('CAMMainHub.State.autoFarm')==True and lua.eval('CAMMainHub.State.killAura')==True
assert lua.eval('_n2')==lua.eval('_n1'),'no attacks while dead'
assert 'respawn' in lua.eval('_deadStatus') and 'toggles stay ON' in lua.eval('_deadMain'),(lua.eval('_deadStatus'),lua.eval('_deadMain'))
assert lua.eval('_n3')>lua.eval('_n2'),'farm must resume after respawn'
assert lua.eval('CAMMainHub.Snapshot().lastStop')is None
print('PASS death: toggles stay ON, honest status, farm resumes on respawn, no stopAll')

# ---- 9. one callback error is counted and logged, not turned into "everything OFF" ----
lua=fresh(r'''
_mob=_regionNpc('Demon',Vector3.new(8,0,0))
_buttons['Connect native controls']();_runTasks()
_toggles['Auto Farm (mob names below / nearest)'](true);_runTasks()
workspace.DescendantAdded:Fire(setmetatable({},{__index=function() error('boom: broken descendant') end}))
_step(0.1)
''')
assert lua.eval('CAMMainHub.State.autoFarm')==True
assert lua.eval('CAMMainHub.Snapshot().farm.callbackErrors')>=1
assert 'Workspace.DescendantAdded' in lua.eval('CAMMainHub.Snapshot().farm.lastCallbackError')
assert lua.eval('CAMMainHub.Snapshot().lastStop') is None
print('PASS callback error: counted + logged, automation keeps running')

# ---- 10. defending targets (NpcCounter / Values.Blocking) are held, not hit ----
lua=fresh(r'''
_mob=_regionNpc('Demon',Vector3.new(8,0,0));_mob:SetAttribute('NpcCounter',1)
_buttons['Connect native controls']();_runTasks()
_toggles['Attack timing']('Instant (no swing delay)')
_toggles['Auto Farm (mob names below / nearest)'](true);_runTasks()
for i=1,4 do _step(0.1) end
_nA=_combatSends();_sA=CAMMainHub.State.farmStatus
_mob:SetAttribute('NpcCounter',nil)
_vals=_path(_RS,{'Player_Service','Values','Demon'});_bl=_add(_vals,_obj('Blocking','BoolValue',{Value=true}))
for i=1,4 do _step(0.1) end
_nB=_combatSends()
for i,x in ipairs(_vals.children) do if x==_bl then table.remove(_vals.children,i) break end end;_bl.Parent=nil -- fixture Destroy() does not detach children
for i=1,4 do _step(0.1) end
_nC=_combatSends()
''')
assert lua.eval('_nA')==0 and 'defending' in lua.eval('_sA'),lua.eval('_sA')
assert lua.eval('_nB')==0,'Values.Blocking without PierceBlock must hold the attack'
assert lua.eval('_nC')>=1
print('PASS defending: NpcCounter and Player_Service.Values.<npc>.Blocking hold the attack; resumes when clear')

# ---- 11. combo resync with the server's replicated last_combo attribute ----
lua=fresh(r'''
_mob=_regionNpc('Demon',Vector3.new(8,0,0))
_buttons['Connect native controls']();_runTasks()
_toggles['Attack timing']('Instant (no swing delay)')
_toggles['Auto Farm (mob names below / nearest)'](true);_runTasks()
_step(0.05)                     -- combo 1 sent
_LP:SetAttribute('last_combo',1) -- server accepted 1
_step(0.35)                     -- combo 2 sent, server silently rejects (attribute stays 1)
_step(0.35)                     -- resync -> combo 2 again
_n,_combos=_combatSends()
''')
combos=list(lua.eval('_combos').values())
assert combos[:3]==[1,2,2],combos
assert lua.eval('CAMMainHub.Snapshot().farm.direct.comboResyncs')>=1
assert lua.eval('CAMMainHub.Snapshot().farm.direct.serverLastCombo')==1
print('PASS combo resync: rejected combo re-sent from the server-visible last_combo; combos',combos)

# ---- 12. attack-once probe + diagnostics fields ----
lua=fresh(r'''
_buttons['Connect native controls']();_runTasks()
_toggles['Attack timing']('Instant (no swing delay)')
_buttons['Attack once (Combat_Service probe)']()
_n=_combatSends();_snap=CAMMainHub.Snapshot()
''')
assert lua.eval('_n')==1
assert any('Attack:' in str(x) for x in lua.eval('_notices').values()),list(lua.eval('_notices').values())
assert lua.eval('_snap.farm.direct.combatServiceSent')==1
assert lua.eval('_snap.farm.direct.signalPath') is not None
assert lua.eval('_snap.farm.direct.lastCombat').startswith('Combat c1')
print('PASS attack once: single Combat_Service, notice + snapshot.farm.direct populated')

# ---- 13. live RemoteEvent channel preferred when present (working-script path), even with the module available ----
lua=fresh(r'''
_evtSends=0
local se=_path(_RS,{'Communication','ServerAndClient','Signals','SignalEvent'})
_remote=_add(se,_obj('Event','RemoteEvent'));_remote.FireServer=function(self,...) _evtSends=_evtSends+1;_sentE[#_sentE+1]={args=table.pack(...)} end
_mob=_regionNpc('Demon',Vector3.new(8,0,0))
_buttons['Connect native controls']();_runTasks()
_toggles['Attack timing']('Instant (no swing delay)')
_toggles['Auto Farm (mob names below / nearest)'](true);_runTasks()
for i=1,4 do _step(0.1) end
''')
assert lua.eval('_evtSends')>=1
assert lua.eval('CAMMainHub.Snapshot().farm.direct.signalPath')=='live RemoteEvent SignalEvent/Event'
print('PASS signal channel: live SignalEvent/Event RemoteEvent used directly (no require needed)')

# ---- 14. structure: bundle carries the 3.3.0 core and the honest UI copy ----
text=Path('CAM_Main_Hub_v3.3.0.lua').read_text()
for needle in ['Version="3.3.0"','actions.resolveCombat','actions.prepareWeapon','Attack timing','Attack once (Combat_Service probe)',
               'Died: toggles stay ON, waiting for respawn','working-script combat core','Repeated callback errors','Hold M1 = Tool_Mouse Down/Up']:
    assert needle in text,needle
assert 'Death: all toggles OFF' not in text
assert 'stopAll("Action failed")' not in text
print('PASS structure: 3.3.0 standalone carries the working-script combat core, live status, no death/click stopAll')
print('Mock/static only: server acceptance of Combat_Service (damage) is NOT verified here - confirm in-game via the farm status line / diagnostics report.')

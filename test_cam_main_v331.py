from pathlib import Path
# 3.3.1: reach-aware defaults/status from the shared hitbox maths; classic path (Auto M1 / classic farm / Auto Level /
# Kill Aura) can use the working-script Combat_Service channel. Mock/static only - server acceptance is not verified here.
fixture=Path('test_cam_main_v330.py').read_text().split("# ---- 1. defaults")[0]
ns={}
exec(compile(fixture,'v331_fixture','exec'),ns)
fresh=ns['fresh']

# ---- 1. defaults ----
lua=fresh()
assert lua.eval('CAMMainHub.Version')=='3.3.1'
assert lua.eval('CAMMainHub.State.farmDist')==4 and lua.eval('CAMMainHub.State.farmHeight')==5
assert lua.eval('CAMMainHub.State.inputMode')=='Combat_Service (direct)'
assert lua.eval('#_sentE')==0
print('PASS defaults: Distance 4 / height 5 (inside the 9-stud server box), classic backend = Combat_Service (direct)')

# ---- 2. classic Auto M1 (no movement) on the direct backend: Combat_Service to the selected target, no punch / native input ----
lua=fresh(r'''
_bear=_npc('Bear Cub',Vector3.new(3,0,0));_bh=_bear:FindFirstChildOfClass('Humanoid')
workspace.DescendantAdded:Fire(_bh)
_toggles['Target mode']('Nearest hostile')
_buttons['Connect native controls']();_runTasks()
_toggles['Attack timing']('Instant (no swing delay)')
_toggles['Auto M1 (no movement)'](true);_runTasks()
for i=1,8 do _step(0.2) end
_n,_combos=_combatSends()
''')
assert lua.eval('CAMMainHub.State.target~=nil')==True  # nearest hostile (fixture Bandit at 3 studs or the bear)
assert lua.eval('_n')>=3,lua.eval('_n')
assert lua.eval('_punchCount')==0 and lua.eval('#_native')==0
assert lua.eval('CAMMainHub.State.attack')==True
assert lua.eval('CAMMainHub.Snapshot().farm.backend')=='Combat_Service (direct)'
print('PASS classic Auto M1: Combat_Service packets to the locked target, no getsenv punch / VirtualPress; combos',list(lua.eval('_combos').values())[:5])

# ---- 3. legacy backend still selectable: native input path, no Combat_Service ----
lua=fresh(r'''
_bear=_npc('Bear Cub',Vector3.new(3,0,0));_bh=_bear:FindFirstChildOfClass('Humanoid')
workspace.DescendantAdded:Fire(_bh)
_toggles['Target mode']('Nearest hostile')
_toggles['M1 input backend']('Native input only')
_buttons['Connect native controls']();_runTasks()
_toggles['Auto M1 (no movement)'](true);_runTasks()
for i=1,6 do _step(0.2) end
_n=_combatSends()
''')
assert lua.eval('_n')==0
assert lua.eval('#_native')>=1
print('PASS legacy backend: Native input only keeps the old path (no Combat_Service)')

# ---- 4. reach hint: target root beyond the box -> status says so, packets still go out (server decides) ----
lua=fresh(r'''
_mob=_regionNpc('Demon',Vector3.new(20,0,0))
_buttons['Connect native controls']();_runTasks()
_toggles['Attack timing']('Instant (no swing delay)')
_toggles['Distance'](9)
_toggles['Auto Farm (mob names below / nearest)'](true);_runTasks()
for i=1,12 do _step(0.1) end
_n=_combatSends();_s=CAMMainHub.State.farmStatus;_reach=CAMMainHub.Snapshot().farm.direct.hitboxReach
''')
assert lua.eval('_n')>=1
assert abs(lua.eval('_reach')-4.5)<1e-6,lua.eval('_reach')
assert 'hitbox reach~5.0' in lua.eval('_s'),lua.eval('_s')
print('PASS reach hint:',lua.eval('_s'))

# ---- 5. default distance 4 -> no reach warning ----
lua=fresh(r'''
_mob=_regionNpc('Demon',Vector3.new(20,0,0))
_buttons['Connect native controls']();_runTasks()
_toggles['Attack timing']('Instant (no swing delay)')
_toggles['Auto Farm (mob names below / nearest)'](true);_runTasks()
for i=1,12 do _step(0.1) end
_s=CAMMainHub.State.farmStatus
''')
assert 'hitbox reach' not in lua.eval('_s'),lua.eval('_s')
print('PASS default distance: inside reach, no warning:',lua.eval('_s'))

# ---- 6. kill aura on the direct backend ----
lua=fresh(r'''
_mob=_npc('Demon',Vector3.new(3,0,0));_mh=_mob:FindFirstChildOfClass('Humanoid');workspace.DescendantAdded:Fire(_mh)
_buttons['Connect native controls']();_runTasks()
_toggles['Attack timing']('Instant (no swing delay)')
_toggles['Kill Aura (nearest mob in range)'](true);_runTasks()
for i=1,6 do _step(0.2) end
_n=_combatSends()
''')
assert lua.eval('_n')>=2,lua.eval('_n')
assert lua.eval('_punchCount')==0
print('PASS kill aura: direct backend sends Combat_Service instead of punch/press')

# ---- 7. structure ----
text=Path('CAM_Main_Hub_v3.3.1.lua').read_text()
for needle in ['Version="3.3.1"','combatReach','Combat_Service (direct)','hitbox reach~','Get_Players_For_Combat','farmDist=4,farmHeight=5']:
    assert needle in text,needle
print('PASS structure: 3.3.1 standalone carries reach maths + direct classic backend')
print('Mock/static only: hitbox reach is computed from the decompiled shared module; real hits still need the in-game status line.')

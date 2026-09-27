from pathlib import Path

fixture=Path('test_cam_main_v2.py').read_text().split("assert lua.eval('_requireCalls')==0")[0]
fixture=fixture.replace("Path('cam_main_logic.lua').read_text()",'_main_text')

def make(source):
    ns={'_main_text':source}
    exec(compile(fixture,'v210_fixture','exec'),ns)
    lua=ns['lua'];lua.execute('_runTasks()')
    return lua

logic=Path('cam_main_logic.lua').read_text()

# ---- Defaults / version ----
lua=make(logic)
assert lua.eval('CAMMainHub.Version')>='2.1.0'
assert lua.eval('CAMMainHub.State.farmNoclip') is True
assert lua.eval('CAMMainHub.State.autoPotion') is False
assert lua.eval('CAMMainHub.State.potionHp')==35
assert lua.eval('CAMMainHub.State.autoLevel==false and CAMMainHub.State.farm==false')

# ---- Auto noclip while farming; manual Noclip unchanged; collisions restored ----
lua.execute('''
_bear=_npc('Bear Cub',Vector3.new(3,0,0));_bh=_bear:FindFirstChildOfClass('Humanoid')
workspace.DescendantAdded:Fire(_bh)
_root.Position=Vector3.new(0,0,0)
_toggles['Target mode']('Selected mob');_toggles['Selected mob']('Bear Cub')
assert(_root.CanCollide==true)
_toggles['Auto Farm - selected / nearest'](true);_runTasks();_step(0.3);_step(0.1)
assert(CAMMainHub.State.farm);assert(_root.CanCollide==false)
_toggles['Noclip while farming/travelling (auto)'](false);_step(0.3)
assert(_root.CanCollide==true)
_toggles['Noclip while farming/travelling (auto)'](true);_step(0.3)
assert(_root.CanCollide==false)
_stop();_step(0.3)
assert(_root.CanCollide==true)
_toggles['Noclip'](true);_step(0.3)
assert(_root.CanCollide==false)
_toggles['Noclip'](false);_step(0.3);_step(0.1)
assert(_root.CanCollide==true)
''')
print('PASS auto-noclip: on during farm by default, restores on disable/STOP, manual Noclip still independent')

# ---- Auto Potion: native equip + Tool_Mouse; farm yields the toolbar; ack by HP ----
lua=make(logic)
lua.execute('''
_bear=_npc('Bear Cub',Vector3.new(3,0,0));_bh=_bear:FindFirstChildOfClass('Humanoid')
workspace.DescendantAdded:Fire(_bh)
_root.Position=Vector3.new(0,0,0)
local inv=_data:FindFirstChild('Inventory'):FindFirstChild('Inventory')
local item=_add(inv,_obj('Health Potion','Folder'))
_add(item,_obj('Id','IntValue',{Value=99}))
_itemsById[99]=item
_data:FindFirstChild('Inventory'):FindFirstChild('Toolbar'):FindFirstChild('Four').Value=99
_hum.MaxHealth=100;_hum.Health=30
_toggles['Target mode']('Selected mob');_toggles['Selected mob']('Bear Cub')
_toggles['Auto Farm - selected / nearest'](true)
_toggles['Auto Potion - consumes toolbar potion at low HP'](true)
_runTasks()
_before=_punchCount
_step(0.3)
assert(_equipped.Value==4)
assert(#_sent==1);assert(_sent[1].args[1]=='Tool_Mouse');assert(_sent[1].args[2]=='Down')
assert(CAMMainHub.Snapshot().farm.potionRequests==1)
assert(_punchCount==_before)
_step(0.3)
assert(#_sent==2);assert(_sent[2].args[1]=='Tool_Mouse');assert(_sent[2].args[2]=='Up')
assert(_punchCount==_before)
_hum.Health=70;_step(0.3)
assert(CAMMainHub.Snapshot().farm.potionAcks==1)
_step(1.2);_step(1.2)
assert(_equipped.Value==3)
assert(_punchCount>_before)
''')
print('PASS auto potion: native slot-equip + Tool_Mouse Down/Up, farm holds during drink, HP ack, weapon re-equipped after')

# ---- Auto Potion failures: cooldown, slot restore when idle, pause after 3 silent uses ----
lua=make(logic)
lua.execute('''
local inv=_data:FindFirstChild('Inventory'):FindFirstChild('Inventory')
local item=_add(inv,_obj('Health Potion','Folder'))
_add(item,_obj('Id','IntValue',{Value=99}))
_itemsById[99]=item
_data:FindFirstChild('Inventory'):FindFirstChild('Toolbar'):FindFirstChild('Four').Value=99
_hum.MaxHealth=100;_hum.Health=30
_toggles['Auto Potion - consumes toolbar potion at low HP'](true);_runTasks()
function _failCycle()
 _step(0.3);assert(_equipped.Value==4)
 _step(0.3)
 _step(2);_step(2);_step(2)
 assert(_equipped.Value==0)
end
_failCycle()
assert(CAMMainHub.Snapshot().farm.potionFailures==1)
_step(8.1);_failCycle()
assert(CAMMainHub.Snapshot().farm.potionFailures==2)
_step(8.1);_failCycle()
assert(CAMMainHub.Snapshot().farm.potionFailures==3)
assert(CAMMainHub.Snapshot().farm.potionRequests==3)
assert(CAMMainHub.Snapshot().state.autoPotion==false)
''')
print('PASS auto potion guarded: repeated silence -> cooldown, previous slot restored, feature pauses itself instead of spamming')

# ---- Structure / preservation ----
assert 'farmNoclip=true' in logic and '"Tool_Mouse"' in logic
current=Path(sorted(Path('.').glob('CAM_Main_Hub_v2.*.lua'))[-1]).read_text()
assert current.endswith(logic)
assert 'getgenv().CAMMainLumen' in current and 'getgenv().CAMDebugLumen' not in current
assert 'mouse1click' not in current
for kept,ver in [('CAM_Main_Hub_v2.0.1.lua','2.0.1'),('CAM_Main_Hub_v2.1.0.lua','2.1.0')]:
    old=Path(kept).read_text()
    assert f'Version="{ver}"' in old,kept
print('PASS structure: newest standalone ends with current logic, older builds preserved')
print('Mock/static tests only; Auto Potion server acceptance is verified in-game by HP/amount ack, not assumed.')

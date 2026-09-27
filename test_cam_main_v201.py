from pathlib import Path

fixture=Path('test_cam_main_v2.py').read_text().split("assert lua.eval('_requireCalls')==0")[0]
fixture=fixture.replace("Path('cam_main_logic.lua').read_text()",'_main_text')

def make(source):
    ns={'_main_text':source}
    exec(compile(fixture,'v201_fixture','exec'),ns)
    lua=ns['lua'];lua.execute('_runTasks()')
    lua.execute(r'''
function _detach(o)
 local parent=o.Parent
 if type(parent)=='table' and parent.children then
  for i,x in ipairs(parent.children) do if x==o then table.remove(parent.children,i);break end end
 end
 o.Parent=nil
end
function _removeEvent(o) workspace.DescendantRemoving:Fire(o) end
function _hasIndexed(name)
 for _,row in ipairs(CAMMainHub.Snapshot().farm.loadedHumanoids) do if row.name==name then return true end end
 return false
end
function _callbackErrors()
 local count=0;for _,entry in ipairs(CAMMainHub.Snapshot().log) do if entry.kind=='callback error' then count=count+1 end end;return count
end
''')
    return lua

old=make(Path('cam_main_v2_0_before_hotfix.lua').read_text())
old.execute('CAMMainHub.State.autoLevel=true;_removed=_obj("Humanoid","Humanoid");_removed.Parent=nil;_removeEvent(_removed)')
assert old.eval('CAMMainHub.State.autoLevel') is False
assert old.eval('_callbackErrors()')==1
assert 'table index is nil' in old.eval('CAMMainHub.Snapshot().log[#CAMMainHub.Snapshot().log-1].text')
print('REPRODUCED on unpatched v2.0: parentless Humanoid removal -> callback error -> Auto Level OFF')

logic=Path('cam_main_logic.lua').read_text()
lua=make(logic)
assert lua.eval('CAMMainHub.Version')>='2.0.1'
lua.execute('CAMMainHub.State.autoLevel=true;_removed=_obj("Humanoid","Humanoid");_removed.Parent=nil;_removeEvent(_removed);_removeEvent(_removed);_removeEvent(nil)')
assert lua.eval('CAMMainHub.State.autoLevel') is True
assert lua.eval('_callbackErrors()')==0
# Known NPC removed after Parent disappears: clear index/target, preserve automation.
lua.execute('''
_bear=_npc('Bear Cub',Vector3.new(3,0,0));_bearHum=_bear:FindFirstChildOfClass('Humanoid')
workspace.DescendantAdded:Fire(_bearHum)
CAMMainHub.State.target=_bear
assert(_hasIndexed('Bear Cub'))
_detach(_bearHum);_removeEvent(_bearHum)
assert(not _hasIndexed('Bear Cub'));assert(CAMMainHub.State.target==nil)
assert(CAMMainHub.State.autoLevel);assert(_callbackErrors()==0)
_removeEvent(_bearHum)
''')
# Replacement race: an old Humanoid's delayed callback cannot erase the replacement.
lua.execute('''
_replacement=_add(_bear,_obj('Humanoid','Humanoid',{Health=90,MaxHealth=100}));workspace.DescendantAdded:Fire(_replacement)
_older=_replacement;_new=_add(_bear,_obj('Humanoid','Humanoid',{Health=80,MaxHealth=100}));workspace.DescendantAdded:Fire(_new)
CAMMainHub.State.target=_bear
_detach(_older);_removeEvent(_older)
assert(_hasIndexed('Bear Cub'));assert(CAMMainHub.State.target==_bear);assert(CAMMainHub.State.autoLevel)
''')
# Model-first then Humanoid removal and the inverse order both remain safe.
lua.execute('''
_removeEvent(_bear);_detach(_new);_removeEvent(_new);_removeEvent(_bear)
assert(not _hasIndexed('Bear Cub'));assert(CAMMainHub.State.target==nil);assert(CAMMainHub.State.autoLevel)
_unparented=_obj('Humanoid','Humanoid');_unparented.Parent=nil;workspace.DescendantAdded:Fire(_unparented)
assert(_callbackErrors()==0)
''')
# A real farm movement hold is released when its target disappears, without global STOP.
lua.execute('''
_stop();_toggles['Target mode']('Selected mob');_toggles['Selected mob']('Bear Cub')
_bear2=_npc('Bear Cub',Vector3.new(3,0,0));_h2=_bear2:FindFirstChildOfClass('Humanoid');workspace.DescendantAdded:Fire(_h2)
_root.Position=Vector3.new(0,0,0)
_toggles['Auto Farm - selected / nearest'](true);_runTasks();_step(0.3);_step(0.1)
assert(CAMMainHub.State.target==_bear2);assert(_hum.AutoRotate==false)
_detach(_h2);_removeEvent(_h2)
assert(CAMMainHub.State.farm);assert(CAMMainHub.State.target==nil);assert(_hum.AutoRotate==true);assert(_callbackErrors()==0)
''')
# Snapshot logs must not mutate after capture (v1.7 runtimeBefore previously shared C.logs).
lua.execute('''
_frozen=CAMMainHub.Snapshot();_n=#_frozen.log
_buttons['Connect native controls']()
assert(#_frozen.log==_n);assert(#CAMMainHub.Snapshot().log>_n)
_frozen.log[1].text='modified outside snapshot'
assert(CAMMainHub.Snapshot().log[1].text~='modified outside snapshot')
''')
# STOP guard still works and keeps its diagnostic context independently from live status.
lua.execute('''
_hum.Health=10;_step(0.3)
assert(not CAMMainHub.State.farm)
local stop=CAMMainHub.Snapshot().lastStop
assert(stop.reason=='Low HP: stopped, no automatic restart');assert(stop.farmWasOn==true);assert(stop.hp==10)
CAMMainHub.State.status='Later UI message'
assert(CAMMainHub.Snapshot().lastStop.reason==stop.reason)
''')
# Unexpected callback errors still stop automation; the fix is not an error swallow.
lua.execute('''
_hum.Health=100;CAMMainHub.State.autoLevel=true
_bad=_obj('Bad','Folder');function _bad:IsA() error('test unexpected failure') end
_removeEvent(_bad)
assert(not CAMMainHub.State.autoLevel);assert(_callbackErrors()==1)
local log=CAMMainHub.Snapshot().log
assert(string.find(log[#log-1].text,'Workspace.DescendantRemoving',1,true))
''')
preserved=Path('CAM_Main_Hub_v2.0.1.lua').read_text()
assert 'C.humanoids[o.Parent]=nil' not in preserved
assert 'Version="2.0.1"' in preserved
assert 'getgenv().CAMMainLumen' in preserved and 'getgenv().CAMDebugLumen' not in preserved
print('PASS v2.0.1: unknown/detached/duplicate removals; cached-owner cleanup; replacement race; both destruction orders; target/hover cleanup without STOP; frozen snapshot log; lastStop context; low-HP and unexpected-error guards preserved.')
print('Mock regression reproduces reported bug; live Roblox hotfix not yet verified.')

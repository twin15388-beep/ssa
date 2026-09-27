from pathlib import Path
# Reuse the mock Roblox/Lumen environment, but exercise the new polling loop.
harness=Path('test_main_hub.py').read_text().split("lua.execute(Path('dh_main_logic.lua')")[0]
exec(compile(harness,'mock_environment','exec'))
lua.execute(r'''
_remote({'ArczisCombat','Remotes','CombatEvent'})
_LP.attrs.MaxStamina=100
_created={}
local oldNew=Instance.new
Instance.new=function(c) local o=oldNew(c);_created[#_created+1]=o;return o end
local npc=_add(workspace,_obj('NPCQuest2','Model'))
local rp=_add(npc,_obj('HumanoidRootPart','Part',{Position=Vector3.new(6,0,0)}))
_qprompt=_add(rp,_obj('QuestPrompt','ProximityPrompt',{Enabled=true,HoldDuration=0,MaxActivationDistance=12}))
''')
lua.execute(Path('dh_main_v1_1_logic.lua').read_text())
lua.execute(r'''
_spawn[1]()
task.wait=function() coroutine.yield() end
_loop=coroutine.create(_spawn[2]);assert(coroutine.resume(_loop))
function _tick(n)
 for i=1,n or 1 do
  _clock=_clock+0.2
  local ok,err=coroutine.resume(_loop)
  assert(ok,err)
 end
end
''')
assert len(lua.globals()._sent)==0
lua.execute('_toggles["AUTO FARM NPC + HOVER"](true); _tick(5)')
assert lua.eval('NZLMainHub.State.autoFarm')
assert lua.globals()._activations>0
assert lua.eval('NZLMainHub.State.target == _hunter')
# Recovery stops native attacks and the hover destination rises.
lua.execute('_LP.attrs.Stamina=10')
a=lua.globals()._activations
lua.execute('_tick(10)')
assert lua.globals()._activations==a
assert 'Stamina recovery' in lua.eval('NZLMainHub.State.status')
lua.execute('_run.Heartbeat:Fire(0.1)')
assert lua.eval('_LP.Character:FindFirstChild("HumanoidRootPart").CFrame.Position.Y')>0
assert lua.eval('_LP.Character:FindFirstChild("HumanoidRootPart").CanCollide') is False
assert lua.eval('(function() for _,o in ipairs(_created) do if o.Name=="NZL_HoverHold" and o.Parent then return true end end return false end)()')
lua.execute('_LP.attrs.Stamina=50; _tick(5)')
assert lua.globals()._activations>a
# Server NoStamina is observed even when the attribute is stale/high.
lua.execute('_remote({"ArczisCombat","Remotes","CombatEvent"}).OnClientEvent:Fire("NoStamina")')
a=lua.globals()._activations
lua.execute('_tick(3)')
assert lua.globals()._activations==a
lua.execute('_tick(12)')
assert lua.globals()._activations>a
# Health guard waits until the higher resume threshold, not merely above low HP.
lua.execute('_LP.Character:FindFirstChild("Humanoid").Health=20; _tick(1)')
a=lua.globals()._activations
lua.execute('_LP.Character:FindFirstChild("Humanoid").Health=40; _tick(5)')
assert lua.globals()._activations==a
lua.execute('_LP.Character:FindFirstChild("Humanoid").Health=70; _tick(5)')
assert lua.globals()._activations>a
# Skip NPC with unchanged HP instead of attacking forever.
lua.execute('_tick(110)')
assert lua.eval('NZLMainHub.State.target == nil')
# Turning farm off destroys hold objects and restores collision without manual noclip.
lua.execute('_toggles["AUTO FARM NPC + HOVER"](false)')
assert lua.eval('_LP.Character:FindFirstChild("HumanoidRootPart").CanCollide') is True
assert lua.eval('(function() for _,o in ipairs(_created) do if o.Name=="NZL_HoverHold" and o.Parent then return false end end return true end)()')
# A quest loop must not fabricate acceptance before the native dialogue.
lua.execute('_toggles["AUTO QUEST + NPC FARM"](true); _tick(1)')
assert lua.eval('NZLMainHub.State.autoFarm') is False
assert lua.eval('_qprompt.held')
n=len(lua.globals()._sent)
lua.execute('_remote({"HunterQuestRemotes","HunterQuestRemote"}).OnClientEvent:Fire("MissionChoice","Choose","Quest")')
lua.execute('_flush(0.5)')
assert len(lua.globals()._sent)==n+1
assert lua.eval('_sent[#_sent].args[1]')=='ChooseKill'
# After server tracker confirms hunt, farm becomes active. Clear previous blacklist by time.
lua.execute('_flush(35); _LP.attrs.QuestActive=true; _remote({"HunterQuestRemotes","HunterQuestRemote"}).OnClientEvent:Fire("Tracker",true,0,3,false); _tick(5)')
assert lua.eval('NZLMainHub.State.target == _hunter')
a=lua.globals()._activations
assert a>0
# Turn-in mode suppresses attacks even though QuestActive remains true.
lua.execute('_remote({"HunterQuestRemotes","HunterQuestRemote"}).OnClientEvent:Fire("Tracker",true,3,3,true); _tick(10)')
assert lua.globals()._activations==a
assert 'Returning' in lua.eval('NZLMainHub.State.status')
# Completion event returns to requesting the next quest, without a made-up claim-reward remote.
lua.execute('_LP.attrs.QuestActive=false; _remote({"HunterQuestRemotes","HunterQuestRemote"}).OnClientEvent:Fire("Tracker",false,3,3,false); _tick(5); _remote({"HunterQuestRemotes","HunterQuestRemote"}).OnClientEvent:Fire("MissionChoice","Next","Quest"); _flush(1)')
assert lua.eval('_sent[#_sent].args[1]')=='ChooseKill'
# STOP invalidates queued quest acceptance and clears automation/hover.
lua.execute('_flush(6); _remote({"HunterQuestRemotes","HunterQuestRemote"}).OnClientEvent:Fire("MissionChoice","Next","Quest"); _buttons["STOP ALL (End)"]()')
n=len(lua.globals()._sent)
lua.execute('_flush(1); _tick(2)')
assert len(lua.globals()._sent)==n
assert lua.eval('NZLMainHub.State.autoQuest') is False
assert lua.eval('NZLMainHub.State.autoFarm') is False
lua.execute('_buttons["Unload hub"]()')
print('PASS: default-off, NPC farm, hover hold/cleanup, stamina hysteresis, server NoStamina recovery, health recovery, stale-target skip, confirmed hunt states, turn-in attack pause, quest repeat, STOP token cancellation.')
print('Mock integration only; no claim of live Roblox or server acceptance.')

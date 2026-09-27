from pathlib import Path
# Reuse the prior project's plain-Lua Roblox/UI fixture, not its gameplay tests.
fixture=Path('test_main_hub.py').read_text().split("lua.execute(Path('dh_main_logic.lua').read_text())")[0]
exec(compile(fixture,'fixture','exec'))
lua.execute(r'''
math.atan2=math.atan2 or function(y,x) return math.atan(y,x) end
Vector2.new=function(x,y) return {X=x,Y=y} end
_spawn={};_delayed={};_sent={};_native={};_requireCalls=0;_clipboard=nil
game.PlaceId=136406881576517;game.PlaceVersion=5354
local rawObj=_obj
local function extend(o)
 function o:IsDescendantOf(parent)
  local p=self.Parent
  while type(p)=='table' do if p==parent then return true end;p=p.Parent end
  return false
 end
 local oldIsA=o.IsA
 function o:IsA(c) return oldIsA(self,c) or c=='ValueBase' and (self.ClassName=='StringValue' or self.ClassName=='IntValue') end
 function o:Move(v) self.lastVector=v end
 function o:GetBoundingBox() local p=self:FindFirstChild('HumanoidRootPart') or self:FindFirstChildWhichIsA('BasePart',true);return p.CFrame,Vector3.new(4,6,3) end
 function o:FindFirstChildWhichIsA(c,recursive) for _,x in ipairs(recursive and self:GetDescendants() or self.children) do if x:IsA(c) then return x end end end
 o.Size=o.Size or Vector3.new(2,2,2)
 return o
end
function _obj(n,c,p) return extend(rawObj(n,c,p)) end
local services={}
local previous=game.GetService
function game:GetService(n) return services[n] or previous(self,n) end
local rs=game:GetService('ReplicatedStorage');_RS=rs
for _,o in ipairs(workspace:GetDescendants()) do extend(o) end
extend(workspace);extend(_LP);for _,o in ipairs(_LP:GetDescendants()) do extend(o) end
for _,o in ipairs(rs:GetDescendants()) do extend(o) end
Instance.new=function(c) return _obj(c,c) end
local function sig() return rawObj('dummy','Folder').Activated end
_LP.CharacterAdded=sig();_LP.CharacterRemoving=sig();_teamSignal=sig()
function _LP:GetPropertyChangedSignal() return _teamSignal end
services.CollectionService={HasTag=function(self,o,t) return o.tags and o.tags[t] or false end}
_input=game:GetService('UserInputService');function _input:GetFocusedTextBox() return _focus end
workspace.Gravity=196.2
function workspace:Raycast() return nil end
local oldCF=CFrame.new
CFrame.new=function(x,y,z)
 local cf=oldCF(x,y,z);cf.Rotation=cf;cf.LookVector=Vector3.new(0,0,-1);cf.RightVector=Vector3.new(1,0,0)
 function cf:PointToWorldSpace(v) return self.Position+v end
 return cf
end
CFrame.lookAt=function(p) return CFrame.new(p) end
workspace.CurrentCamera={CFrame=CFrame.new(0,0,0),ViewportSize={X=1280,Y=720},WorldToViewportPoint=function(self,v) return {X=640+v.X*10,Y=360-v.Y*10,Z=50} end}
_hum=_LP.Character:FindFirstChildOfClass('Humanoid');_root=_LP.Character:FindFirstChild('HumanoidRootPart')
_root.CFrame=CFrame.new(0,0,0);_root.AssemblyLinearVelocity=Vector3.zero
_hum.JumpPower=50;_hum.JumpHeight=7.2;_hum.UseJumpPower=true;_hum.AutoRotate=true
_hunter:FindFirstChild('HumanoidRootPart').CFrame=CFrame.new(3,0,0)
function _path(root,path,cls)
 local o=root
 for i,n in ipairs(path) do local x=o:FindFirstChild(n);if not x then x=_add(o,_obj(n,i==#path and (cls or 'Folder') or 'Folder')) end;o=x end
 return o
end
_held={};_nativeInput={IsDown=function(a) return _held[a]==true end,
 VirtualPress=function(a) _held[a]=true;_native[#_native+1]={'down',a} end,
 VirtualRelease=function(a) _held[a]=nil;_native[#_native+1]={'up',a} end}
_runSettings={Shift_lock=1};_runSettings.SetShiftLock=function(v) _runSettings.Shift_lock=v end
_questAllowed=true
_mods={
 InputHandler=_nativeInput,Run_Handler=_runSettings,RecommendedQuest={Get=function() return {Name='Defeat Hunter',Npc='Guide',Position=Vector3.new(10,1,10)} end},
 Quests={CanAddQuest=function() return _questAllowed,'not eligible' end},BossHunts={},
 SignalEvent={ToServer=function(...) _sent[#_sent+1]={args=table.pack(...)} end}}
for _,p in ipairs({{'CAM','Client','Components','Client','InputHandler'},{'CAM','Client','Modules','GamePlay','Run_Handler'},
 {'CAM','Client','Modules','RecommendedQuest'},{'CAM','Global','Subsets','Gameplay','Quests'},
 {'CAM','Global','Subsets','Gameplay','Quests','BossHunts'},{'Communication','ServerAndClient','Signals','SignalEvent'}}) do _path(rs,p,'ModuleScript') end
require=function(o) _requireCalls=_requireCalls+1;return _mods[o.Name] end
task.cancel=function() end
local base=_path(rs,{'Player_Service','Data','LocalPlayer'});_add(base,_obj('slotEquipped','IntValue',{Value=1}))
_data=_path(base,{'slots','Slot1'});_add(_data,_obj('Race','StringValue',{Value='Slayer'}));_path(_data,{'Quests','Holder'})
_hunts=_path(rs,{'BossHunts'});_hunt=_add(_hunts,_obj('id-1','Configuration',{attrs={Quest='Hunt One',Boss='Rengu',Side='Crow',ExpiresAt=10000}}))
local config=_add(_LP,_obj('Items_Config','Folder'));_add(config,_obj('Equipped','IntValue',{Value=0}))
-- Another player's same-name character must never be chosen.
_enemyPlayer=_add(workspace,_obj('Hunter','Model'))
_add(_enemyPlayer,_obj('Humanoid','Humanoid',{Health=100,MaxHealth=100}));_add(_enemyPlayer,_obj('HumanoidRootPart','Part',{Position=Vector3.new(1,0,0),CFrame=CFrame.new(1,0,0)}))
local players=game:GetService('Players');local orig=players.GetPlayerFromCharacter
function players:GetPlayerFromCharacter(o) if o==_enemyPlayer then return {Name='OtherPlayer'} end;return orig(self,o) end
function _beat(dt) _clock=_clock+dt;_run.Heartbeat:Fire(dt) end
''')
lua.execute(Path('portable_json.lua').read_text()+'\n'+Path('cam_boss_names.lua').read_text()+'\n'+Path('cam_main_logic.lua').read_text())
assert lua.eval('_requireCalls')==0
assert len(lua.globals()._sent)==0 and len(lua.globals()._native)==0
assert lua.eval('CAMMainHub.State.farm') is False
assert lua.eval('CAMMainHub.State.esp') is False
lua.execute('_spawn[1](); _beat(1)')
assert lua.eval('CAMMainHub.State.status')=='Ready - automation OFF', lua.eval('CAMMainHub.State.status')
# Native controls are explicit and fail closed before connection.
lua.execute('_buttons["Refresh loaded targets"](); _toggles["Exact NPC name"]("Hunter"); _buttons["M1 once"]()')
assert len(lua.globals()._native)==0
lua.execute('_toggles["Auto Farm selected NPC (MoveTo + M1)"](true); _beat(0.3)')
assert lua.eval('_hum.lastMove==nil')
assert 'InputHandler unavailable' in lua.eval('CAMMainHub.State.status')
lua.execute('')
lua.execute('_buttons["Connect native controls"](); for i=2,#_spawn do _spawn[i]() end')
assert lua.eval('_requireCalls')==6
lua.execute('_buttons["M1 once"](); _flush(1); _buttons["M1 once"]()')
assert lua.eval('CAMMainHub.State.target==_hunter')
assert lua.eval('_native[#_native][1]')=='down'
assert lua.eval('_native[#_native][2]')=='Combat'
assert len(lua.globals()._sent)==0
# STOP releases owned input and invalidates delayed release tickets.
lua.execute('; _flush(1)')
assert lua.eval('next(_held)==nil')
# Physical input is not acquired/released by the hub.
lua.execute('_held.Combat=true; _buttons["M1 once"](); ')
assert lua.eval('_held.Combat') is True
lua.execute('_held.Combat=nil')
# Skill selected explicitly. Every STOP clears both UI and internal selected slots.
lua.execute('_toggles["Use skill input slot 2"](true); _buttons["Selected skill input once"]()')
assert lua.eval('_native[#_native][2]')=='Skills_2nd'
lua.execute('')
assert lua.eval('next(CAMMainHub.State.skillSlots)==nil')
# Menus / chat pause both walking and held inputs.
lua.execute('_toggles["Auto Farm selected NPC (MoveTo + M1)"](true); _focus={}; _beat(0.3)')
assert lua.eval('next(_held)==nil')
lua.execute('_focus=nil; _beat(0.3)')
assert lua.eval('CAMMainHub.State.farm') is True
# Known hunt payload; no retry spam; race and eligibility checked.
lua.execute('; _buttons["Refresh hunts + write names to log"](); _toggles["Live hunt ID"]("id-1"); _buttons["Claim selected hunt once"]()')
assert len(lua.globals()._sent)==1
assert lua.eval('_sent[1].args[1]')=='BossHuntsRequest'
assert lua.eval('_sent[1].args[2].action')=='Claim'
assert lua.eval('_sent[1].args[2].id')=='id-1'
lua.execute('_buttons["Claim selected hunt once"]()');assert len(lua.globals()._sent)==1
lua.execute('; _questAllowed=false; _buttons["Claim selected hunt once"]()');assert len(lua.globals()._sent)==1
lua.execute('_questAllowed=true; _data:FindFirstChild("Race").Value="Demon"; _buttons["Claim selected hunt once"]()');assert len(lua.globals()._sent)==1
lua.execute('_data:FindFirstChild("Race").Value="Slayer"')
# Movement overrides and rollback; fly helper instances are cleaned up.
lua.execute('_toggles["Speed override"](true); _toggles["High Jump"](true); _toggles["Noclip"](true); _toggles["Disable Shift Lock (native setting)"](true); _beat(0.3)')
assert lua.eval('_hum.WalkSpeed')==26
assert lua.eval('_root.CanCollide') is False
assert lua.eval('_runSettings.Shift_lock')==0
lua.execute('_toggles["Fly (WASD / Space / LeftCtrl)"](true); _beat(0.3)')
assert lua.eval('_hum.PlatformStand') is True
lua.execute('')
assert lua.eval('_hum.WalkSpeed')==16
assert lua.eval('_hum.JumpPower')==50
assert lua.eval('_hum.JumpHeight')==7.2
assert lua.eval('_root.CanCollide') is True
assert lua.eval('_hum.PlatformStand') is False
assert lua.eval('_hum.AutoRotate') is True
assert lua.eval('_runSettings.Shift_lock')==1
# Low-HP stop, death/respawn, and Team change all leave features off.
lua.execute('_toggles["Auto M1 (no movement)"](true); _hum.Health=20; _beat(0.3)')
assert lua.eval('CAMMainHub.State.attack') is False
assert 'Low HP' in lua.eval('CAMMainHub.State.status')
lua.execute('_hum.Health=100; _toggles["Auto M1 (no movement)"](true); _hum.Health=0; _beat(0.3)')
assert lua.eval('CAMMainHub.State.attack') is False
lua.execute('_hum.Health=100; _toggles["Auto Skills (selected input slots)"](true); _LP.CharacterAdded:Fire(_LP.Character)')
assert lua.eval('CAMMainHub.State.skills') is False
lua.execute('_toggles["Auto M1 (no movement)"](true); _teamSignal:Fire()')
assert lua.eval('CAMMainHub.State.attack') is False
# Native prompt: range, locked chest rejection, delay and restore.
lua.execute(r'''
local chests=_add(workspace,_obj('Chests','Folder'))
_chest=_add(chests,_obj('TestChest','Model',{attrs={ChestState='Locked'}}))
local base=_add(_chest,_obj('Base','Part',{Position=Vector3.new(2,0,0),CFrame=CFrame.new(2,0,0)}))
_prompt=_add(base,_obj('Open','ProximityPrompt',{Enabled=true,HoldDuration=1,MaxActivationDistance=8,RequiresLineOfSight=true}))
workspace.DescendantAdded:Fire(_chest);workspace.DescendantAdded:Fire(_prompt)
_toggles['Auto Chest - unlocked prompts only'](true);_beat(0.3)
''')
assert lua.eval('_prompt.held') is None
lua.execute('_chest.attrs.ChestState="Open"; _toggles["Instant ProximityPrompt (local hold duration)"](true); _beat(0.3)')
assert lua.eval('_prompt.held') is True
assert lua.eval('_prompt.HoldDuration')==0
lua.execute('')
assert lua.eval('_prompt.held') is False
assert lua.eval('_prompt.HoldDuration')==1
# Out-of-range prompt cannot be activated by auto loot/chest.
lua.execute('_prompt.Parent.Position=Vector3.new(100,0,0); _toggles["Auto Chest - unlocked prompts only"](true); _beat(0.3)')
assert lua.eval('_prompt.held') is False
lua.execute('; _prompt.Parent.Position=Vector3.new(2,0,0)')
# ESP: basic styles, 3D and tracer render; clearing works without gameplay requests.
lua.execute('_buttons["Enable basic mob / boss ESP"](); _toggles["3D Box ESP"](true); _toggles["Tracer ESP"](true); _beat(0.3)')
assert lua.eval('CAMMainHub.State.esp') is True, lua.eval('CAMMainHub.State.status')
lua.execute('')
# Wrong place must not enable movement or gameplay, even though visual tools remain.
lua.execute('game.PlaceId=123; _toggles["Fly (WASD / Space / LeftCtrl)"](true); _buttons["Claim selected hunt once"]()')
assert lua.eval('CAMMainHub.State.fly') is False
assert len(lua.globals()._sent)==1
lua.execute('game.PlaceId=136406881576517; _buttons["COPY diagnostic report"]()')
assert lua.eval('type(_clipboard)')=='string'
# No swallowed runtime errors in the tested callbacks.
logs=lua.eval('CAMMainHub.Snapshot().log')
for i in range(1,len(logs)+1):
    assert logs[i]['kind'] not in ('callback error','button error'), logs[i]['text']
lua.execute('_buttons["Unload hub"]()')
assert lua.eval('CAMMainHub==nil')
assert lua.eval('Lumen.unloaded')
print('PASS: no startup require/actions; guarded native inputs; player exclusion; STOP/cancel; skill resets; hunt payload/race/dedup; movement rollback; fly; death/respawn; prompt lock/range/restore; ESP render; wrong-place guard; export; unload.')
print('Mock tests only. No Roblox runtime validation.')
source=Path('cam_main_logic.lua').read_text()
for forbidden in ('FireServer(', 'InvokeServer(', 'HttpGet(', 'loadstring(', 'hookfunction(', 'hookmetamethod(', 'PurchaseFromShop', '122287678911982'):
    assert forbidden not in source, forbidden
assert 'signal.ToServer("BossHuntsRequest",{action="Claim",id=S.huntId})' in source
standalone=Path('CAM_Main_Hub_v1.0.lua').read_text()
assert standalone.endswith(source)
assert '-- Universal Game Debug' not in standalone
assert 'HttpGet(' not in standalone
print('PASS: assembled logic matches; no old-game routes, arbitrary combat remotes, downloads or purchase calls.')

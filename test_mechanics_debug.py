from pathlib import Path
import json
setup=r'''
_clock=0;os.clock=function() return _clock end
local jobs={};local cancelled={}
local function resume(co)
 if cancelled[co] or coroutine.status(co)=='dead' then return end
 local ok,delay=coroutine.resume(co);if not ok then error(delay) end
 if coroutine.status(co)~='dead' then jobs[co]=_clock+(tonumber(delay) or 0.001) end
end
task.spawn=function(fn) local co=coroutine.create(fn);resume(co);return co end
task.wait=function(dt) return coroutine.yield(dt or 0.001) end
task.cancel=function(co) cancelled[co]=true;jobs[co]=nil end
task.delay=function(dt,fn) return task.spawn(function() task.wait(dt);fn() end) end
function _advance(dt)
 local target=_clock+dt;local count=0
 while true do
  local best,when=nil,math.huge
  for co,at in pairs(jobs) do if at<when then best=co;when=at end end
  if not best or when>target then break end
  jobs[best]=nil;_clock=when;resume(best);count=count+1;assert(count<60000,'scheduler loop')
 end
 _clock=target
end
function _signal()
 local signal={cons={}}
 function signal:Connect(fn) local c={fn=fn,active=true};function c:Disconnect() self.active=false end;self.cons[#self.cons+1]=c;return c end
 function signal:Fire(...) for _,c in ipairs(self.cons) do if c.active then c.fn(...) end end end
 return signal
end
local vm={};vm.__index=function(v,k) if k=='Magnitude' then return math.sqrt(v.X*v.X+v.Y*v.Y+v.Z*v.Z) end end
vm.__sub=function(a,b) return Vector3.new(a.X-b.X,a.Y-b.Y,a.Z-b.Z) end
Vector3={new=function(x,y,z) return setmetatable({X=x,Y=y,Z=z},vm) end}
local rs=game:FindFirstChild('ReplicatedStorage');_RS=rs
local players=game:GetService('Players');_LP=players.LocalPlayer
local oldObject=_object
function _extend(o)
 local original=o.IsA
 function o:IsA(c) return original(self,c) or c=='ValueBase' and (self.ClassName=='IntValue' or self.ClassName=='NumberValue' or self.ClassName=='StringValue' or self.ClassName=='DoubleConstrainedValue') or c=='GuiObject' and (self.ClassName=='TextLabel' or self.ClassName=='TextButton' or self.ClassName=='Frame') end
 function o:GetAttributes() return self.attrs or {} end
 function o:GetAttribute(k) return (self.attrs or {})[k] end
 function o:IsDescendantOf(parent) local p=self.Parent;while p do if p==parent then return true end;p=p.Parent end;return false end
 function o:GetFullName() if self.Parent then return self.Parent:GetFullName()..'.'..self.Name end;return self.Name end
 o.AncestryChanged=o.AncestryChanged or _signal()
 if o:IsA('Humanoid') then o.HealthChanged=o.HealthChanged or _signal();o.Died=o.Died or _signal() end
 return o
end
function _object(...) return _extend(oldObject(...)) end
function _fix(o,parent) _extend(o);o.Parent=parent;for _,c in ipairs(o:GetChildren()) do _fix(c,o) end end
_fix(rs,nil);_fix(workspace,nil);_fix(_LP,game:FindFirstChild('Players'));_fix(_LP.Character,workspace)
local oldAdd=_addPath
function _addPath(p) local r=oldAdd(p);_fix(rs,nil);return r end
function _add(p,o) p.children[#p.children+1]=o;o.Parent=p;return o end
function _value(p,n,v,cls) return _add(p,_object(n,cls or 'IntValue',nil,{Value=v})) end
function players:GetPlayerFromCharacter(c) if c==_LP.Character then return _LP end;if c==_other then return {Name='Other'} end end
game.PlaceId=136406881576517;game.PlaceVersion=5354
local dataRoot=_addPath('ReplicatedStorage.Player_Service.Data.Player');dataRoot.ClassName='Folder'
_value(dataRoot,'slotEquipped',1)
_data=_addPath('ReplicatedStorage.Player_Service.Data.Player.slots.Slot1');_data.ClassName='Configuration'
local exp=_add(_data,_object('Exp','Configuration'));_value(exp,'Goal',480);_value(exp,'Current',384)
_value(_data,'Wen',347);_value(_data,'Race','Human','StringValue');_add(_data,_object('Quests','Configuration'))
local vals=_addPath('ReplicatedStorage.Player_Service.Values.Player');vals.ClassName='Folder'
_stamina=_value(vals,'Stamina',125,'DoubleConstrainedValue');_stamina.MaxValue=125;_stamina.MinValue=0
local config=_add(_LP,_object('Items_Config','Configuration'));_value(config,'Equipped',3)
_value(_LP,'MenuDestination','','StringValue')
_hum=_add(_LP.Character,_object('Humanoid','Humanoid',nil,{Health=123,MaxHealth=123,WalkSpeed=16}))
_root=_add(_LP.Character,_object('HumanoidRootPart','Part',nil,{Position=Vector3.new(0,0,0)}))
local root=_add(workspace,_object('Humanoids','Folder'))
_mob=_add(root,_object('Bandit','Model'));_npcHum=_add(_mob,_object('Humanoid','Humanoid',nil,{Health=100,MaxHealth=100}));_add(_mob,_object('HumanoidRootPart','Part',nil,{Position=Vector3.new(3,0,0)}))
_animator=_add(_npcHum,_object('Animator','Animator'));_animator.AnimationPlayed=_signal()
_other=_add(root,_object('OtherPlayer','Model'));_add(_other,_object('Humanoid','Humanoid',nil,{Health=100,MaxHealth=100}));_add(_other,_object('HumanoidRootPart','Part',nil,{Position=Vector3.new(2,0,0)}))
_portal=_addPath('ReplicatedStorage.Communication.CnC.NotEnoughStamina');_portal.ClassName='BindableEvent';_portal.Event=_signal()
_addPath('ReplicatedStorage.CAM.Global.StaminaRules').Source='return {Cost=12,Regen=5}'
_addPath('ReplicatedStorage.CAM.Global.FishingRules').Source='return {Bite=1}'
_addPath('ReplicatedStorage.Ouwland.Content.Windy Peak.Npcs.Krue').Source='DO_NOT_REPEAT_KNOWN_CONTENT'
_addPath('ReplicatedStorage.Assets.HugeAsset.Scripts.Private').Source='ASSET_SHOULD_NOT_APPEAR'
_addPath('ReplicatedStorage.Packages.Engine').Source='PACKAGE_SHOULD_NOT_APPEAR'
local pg=_LP:FindFirstChild('PlayerGui');local chat=_add(pg,_object('Chat','Frame',nil,{Visible=true}));_add(chat,_object('Conversation','TextLabel',nil,{Text='PRIVATE_CHAT',Visible=true}))
local shop=_add(pg,_object('FishingShop','Frame',nil,{Visible=true}));_add(shop,_object('Price','TextLabel',nil,{Text='Bait: 5 Wen',Visible=true}));_add(shop,_object('Input','TextBox',nil,{Text='PRIVATE_TYPED_TEXT',Visible=true}))
_state={autoLevel=true,farm=false,status='Farm',questStage='Farm',questName='Defeat The Bandit Boss',questProgress='0/1'}
_mainLog={}
CAMMainHub={Version='2.0',State=_state,Snapshot=function() return {state=table.clone(_state),farm={level=8,backend='Live Combat.punch',requests=10},log=table.clone(_mainLog)} end,Stop=function() error('Main must not be stopped') end}
function _scenario()
 task.delay(5,function() _state.autoLevel=false;_state.status='Low HP: stopped, no automatic restart';_state.questStage='OFF';_mainLog[#_mainLog+1]={time='00:00:05',kind='stop',text=_state.status} end)
 task.delay(10,function() _stamina.Value=40;_portal.Event:Fire(50) end)
 task.delay(12,function() _animator.AnimationPlayed:Fire({Name='Attack',Animation={AnimationId='rbxassetid://123'},Length=0.5,Speed=1}) end)
 task.delay(15,function() _addPath('ReplicatedStorage.CAM.Client.FishingLateClient').Source='return {Late=true}' end)
 task.delay(20,function() _npcHum.Health=0;_npcHum.HealthChanged:Fire(0);_npcHum.Died:Fire();_mob.Parent=nil;_mob.AncestryChanged:Fire() end)
end
isnetworkowner=function() return true end
Enum.KeyCode.RightShift='RightShift'
'''
source=Path('test_oneclick_debug.py').read_text().split('lua=make()')[0]
source=source.replace("lua.execute(Path('portable_json.lua').read_text()+'\\n'+logic)","lua.execute(mechanics_setup);lua.execute(Path('portable_json.lua').read_text()+'\\n'+logic)")
ns={'mechanics_setup':setup}
exec(compile(source,'fixture','exec'),ns)
ns['logic']=Path('mechanics_debug_logic.lua').read_text();ns['paths']=[]

def make(mode='normal'):
    return ns['make'](mode)

lua=make()
assert len(lua.globals()._writes)==0
lua.execute('_scenario();_buttons["START 90s + COLLECT + SAVE + COPY"]();_advance(120)')
assert len(lua.globals()._writes)==1, str(list(lua.globals()._notices.values()))
text=lua.globals()._writes[1]['text'];r=json.loads(text)
assert r['format']=='CAM Mechanics Recorder OneClick 1.7',r.keys()
assert 'error' not in r,r.get('error')
assert r['recording']['durationActual']>=90
assert len(r['sourcePasses'])==2
scripts=[s for p in r['sourcePasses'] for s in p.get('scripts',[])]
assert any(s['path'].endswith('StaminaRules') and s.get('source') for s in scripts)
assert any(s['path'].endswith('FishingLateClient') and s.get('source') for s in scripts)
assert any(x['reason']=='AutoLevel transitioned ON -> OFF' and x['after']['status'].startswith('Low HP') for x in r['recording']['mainTransitions'])
assert any(x.get('path')=='Values/Stamina' and x.get('value')==40 for x in r['recording']['events'])
assert any(x['kind']=='NotEnoughStamina' for x in r['recording']['events'])
assert any(x['kind']=='npcAnimation' for x in r['recording']['events'])
assert any(x['kind']=='npcHealth' and x['health']==0 for x in r['recording']['events'])
assert any(x['kind']=='npcNoLongerInWorkspace' for x in r['recording']['events'])
assert not any(x.get('name')=='OtherPlayer' for row in r['recording']['samples'] for x in row.get('npcs',[]) if isinstance(x,dict))
assert 'DO_NOT_REPEAT_KNOWN_CONTENT' not in text and 'PRIVATE_CHAT' not in text and 'PRIVATE_TYPED_TEXT' not in text
assert 'ASSET_SHOULD_NOT_APPEAR' not in text and 'PACKAGE_SHOULD_NOT_APPEAR' not in text
assert any('Krue' in x['path'] for x in r['sourcePasses'][0]['discovery']['knownReferences'])
assert lua.globals()._copies[1]==text
assert lua.eval('_requires')==0 and lua.eval('_remoteCalls')==0
before=len(r['recording']['events'])
lua.execute('_npcHum.HealthChanged:Fire(7);_advance(2);_buttons["Save + copy last report again"]()')
r2=json.loads(lua.globals()._writes[2]['text'])
assert len(r2['recording']['events'])==before,'Recorder callbacks leaked after completion'
# Early finish produces an explicitly incomplete report and no late pass.
lua=make();lua.execute('_buttons["START 90s + COLLECT + SAVE + COPY"]();_advance(2);_buttons["FINISH NOW - save partial recording"]();_advance(3)')
r=json.loads(lua.globals()._writes[1]['text']);assert r['recording']['finishedEarly'] and r['stats']['incomplete']
assert len(r['sourcePasses'])==1
# Portable JSON on native encoder failure still includes the recording.
lua=make();lua.execute('game:GetService("HttpService").JSONEncode=function() error("invalid UTF8") end;_buttons["START 90s + COLLECT + SAVE + COPY"]();_advance(130)')
r=json.loads(lua.globals()._writes[1]['text']);assert r['_jsonExport']['serializer']=='portable-json-v1'
assert r['recording']['samples']
# Copy failure does not prevent saving; file failure does not prevent copying.
for mode in ['copyfail','savefail']:
    lua=make(mode);lua.execute('_buttons["START 90s + COLLECT + SAVE + COPY"]();_advance(120)')
    assert len(lua.globals()._writes)==(0 if mode=='savefail' else 1)
    assert len(lua.globals()._copies)==(0 if mode=='copyfail' else 1)
# Unload disconnects passive observation without touching the main.
lua=make();lua.execute('_buttons["START 90s + COLLECT + SAVE + COPY"]();_advance(1);_buttons["Unload debug"]();_advance(120)')
assert len(lua.globals()._writes)==0
assert lua.eval('_state.autoLevel') is True
# Discovery count limits and deferred-source manifest remain visible, rather than dropping scripts silently.
lua=make();lua.execute("local folder=_addPath('ReplicatedStorage.CAM.ExtraFishing');folder.ClassName='Folder';for i=1,360 do _add(folder,_object('Fishing'..i,'ModuleScript',nil,{Source='return '..i})) end;_buttons['START 90s + COLLECT + SAVE + COPY']();_advance(120)")
r=json.loads(lua.globals()._writes[1]['text'])
assert r['sourcePasses'][0]['discovery']['selectionLimitReached']
assert r['sourcePasses'][0]['discovery']['deferred'] and r['stats']['incomplete']
assert r['sourcePasses'][0]['stats']['sourcesCollected']<=350
assert r['sourcePasses'][1]['stats']['sourcesCollected']<=80
# Hanging decompilers are time-bounded; observation/export still finishes with explicit partial flags.
lua=make();lua.execute("local folder=_addPath('ReplicatedStorage.CAM.ExtraFishing');folder.ClassName='Folder';for i=1,40 do _add(folder,_object('FishingSlow'..i,'ModuleScript')) end")
# The collector captures the decompile function at startup, so install a delayed wrapper before startup for this case.
old_setup=ns['mechanics_setup']
ns['mechanics_setup']=old_setup+"\ndecompile=function(o) task.wait(10);return 'return {}' end\nlocal folder=_addPath('ReplicatedStorage.CAM.ExtraFishing');folder.ClassName='Folder';for i=1,40 do _add(folder,_object('FishingSlow'..i,'ModuleScript')) end"
lua=make();lua.execute("_buttons['START 90s + COLLECT + SAVE + COPY']();_advance(130)")
ns['mechanics_setup']=old_setup
r=json.loads(lua.globals()._writes[1]['text'])
assert r['stats']['incomplete'] and r['sourcePasses'][0]['stats']['sourceDeadlineSkipped']>0
assert r['sourcePasses'][0]['stats']['sourceTimeouts']>0
assert r['recording']['durationActual']>=90
# Real embedded-library bootstrap must not unload either main singleton.
standalone=Path('CAM_Debug_Mechanics_v1.7.lua').read_text()
bootstrap=standalone.split('--#region bootstrap',1)[1].split('local Lumen = { }',1)[0]
lua.execute("_mainUnloaded=false;CAMMainLumen={Unload=function() _mainUnloaded=true end};_G.Lumen={Unload=function() _mainUnloaded=true end}")
lua.execute(bootstrap)
assert not lua.eval('_mainUnloaded')
text=Path('CAM_Debug_Mechanics_v1.7.lua').read_text()
assert text.endswith(ns['logic'])
assert 'getgenv().Lumen' not in text and 'getgenv().CAMDebugLumen' in text
assert 'HttpGet(' not in text and 'hookmetamethod(' not in text and ':FireServer(' not in text and ':InvokeServer(' not in text
print('PASS: 90s passive recording; auto-level ON->OFF reason; stamina/cost event; NPC HP/removal/animation; late scripts; known-reference reuse; GUI privacy; excluded assets/packages/players; same file+clipboard JSON; partial finish; portable JSON; save/copy failures; no require/remotes; unload cleanup and main isolation. Mock-only, not live executor verification.')

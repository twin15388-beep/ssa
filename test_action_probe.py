from pathlib import Path
from lupa import LuaRuntime

PRELUDE=r'''
math.atan2=math.atan2 or function(y,x) return math.atan(y,x) end
function mkSignal()
 local s={_f={}}
 function s:Connect(fn) local c={fn=fn};s._f[#s._f+1]=c;function c:Disconnect() c.fn=nil end;return c end
 function s:Fire(...) for _,c in ipairs(s._f) do if c.fn then c.fn(...) end end end
 return s
end
local ANC={TextButton={'GuiButton'},ImageButton={'GuiButton'},IntValue={'ValueBase'},StringValue={'ValueBase'},NumberValue={'ValueBase'},LocalScript={'LuaSourceContainer'},ModuleScript={'LuaSourceContainer'}}
function obj(name,class,props)
 local o={Name=name,ClassName=class,children={},DescendantAdded=mkSignal()}
 if class=='TextButton' or class=='ImageButton' then o.Activated=mkSignal() end
 function o:IsA(c)
  if c==self.ClassName then return true end
  for _,a in ipairs(ANC[self.ClassName] or {}) do if a==c then return true end end
  return false
 end
 function o:FindFirstChild(n) for _,x in ipairs(self.children) do if x.Name==n then return x end end end
 function o:GetChildren() return self.children end
 function o:GetDescendants() local t={};local function w(p) for _,c in ipairs(p.children) do t[#t+1]=c;w(c) end end;w(self);return t end
 function o:GetFullName()
  local parts={self.Name};local p=self.Parent
  while type(p)=='table' and p~=game do parts[#parts+1]=p.Name;p=p.Parent end
  local s='';for i=#parts,1,-1 do s=s..(s~='' and '.' or '')..parts[i] end;return s
 end
 function o:IsDescendantOf(p) local a=self.Parent;while type(a)=='table' do if a==p then return true end;a=a.Parent end;return false end
 if props then for k,v in pairs(props) do o[k]=v end end
 return o
end
function _add(p,c)
 p.children[#p.children+1]=c;c.Parent=p
 if type(c.Name)=='string' and c.Name:match('^[%a_][%w_]*$') and p[c.Name]==nil then p[c.Name]=c end
 local a=p;while type(a)=='table' and a.DescendantAdded do a.DescendantAdded:Fire(c);a=a.Parent end
 return c
end
_services={}
game=obj('game','DataModel')
game.PlaceId=136406881576517;game.PlaceVersion=5400
function game:GetService(n) return _services[n] end
RS=_add(game,obj('ReplicatedStorage','Folder'));_services.ReplicatedStorage=RS
_players=_add(game,obj('Players','Folder'));_services.Players=_players
LP=_add(_players,obj('LocalPlayer','Player'));_players.LocalPlayer=LP
_run=obj('RunService','Folder');_run.Heartbeat=mkSignal();_services.RunService=_run
_services.HttpService={JSONEncode=function() error('no http in mock') end}
function _beat(dt) _clock=(_clock or 0)+dt;_run.Heartbeat:Fire(dt) end
_gui=_add(LP,obj('PlayerGui','Folder'))
_config=_add(LP,obj('Items_Config','Folder'))
_add(_config,obj('Equipped','IntValue',{Value=0}))
_scripts=_add(LP,obj('PlayerScripts','Folder'))
_svc=_add(RS,obj('Player_Service','Folder'))
_dataRoot=_add(_add(_svc,obj('Data','Folder')),obj('LocalPlayer','Folder'))
_add(_dataRoot,obj('slotEquipped','IntValue',{Value=1}))
_data=_add(_add(_dataRoot,obj('slots','Folder')),obj('Slot1','Folder'))
_exp=_add(_data,obj('Exp','Folder'));_goal=_add(_exp,obj('Goal','IntValue',{Value=480}))
_values=_add(_add(_svc,obj('Values','Folder')),obj('LocalPlayer','Folder'))
_comm=_add(RS,obj('Communication','Folder'))
_sig=_add(_add(_add(_comm,obj('ServerAndClient','Folder')),obj('Signals','Folder')),obj('SignalEvent','ModuleScript'))
_evMod=_add(_comm,obj('EffectsEvent','ModuleScript'))
_gameCalls={};_hooks={}
_signalsT={ToServer=function(a,b) _gameCalls[#_gameCalls+1]={a,b};return 'ok',7 end}
_tick={};function _tick:Connect(fn) self._f=fn;return {Disconnect=function() self._f=nil end} end
function _tick:fire(...) if self._f then self._f(...) end end
_effectsT={ToAllInRange=function() end,Tick=_tick}
_mods={[_sig]=_signalsT,[_evMod]=_effectsT}
require=function(m) local r=_mods[m];if r==nil then error('no module') end;return r end
function _call(f,...) if _hooks[f] then return _hooks[f](...) end;return f(...) end
hookfunction=function(f,h) _hooks[f]=h;return f end
restorefunction=function(f) _hooks[f]=nil end
decompile=function(d) if d.Name:find('FishingRod',1,true) then return nil,'failed to decompile: NYI' end;return 'print("src for '..d.Name..'")' end
_written={};writefile=function(n,t) _written[n]=t;return true end
_nm=nil;getnamecallmethod=function() return _nm end
_namecallHook=nil;hookmetamethod=function(o,name,f) if o==game and name=='__namecall' then _namecallHook=f;return function(self,...) return 'origRet' end end;return f end
newcclosure=function(f) return f end
_remote=_add(_comm,obj('BuyRemote','RemoteEvent'))
_clipboard=nil;setclipboard=function(t) _clipboard=t end
task={spawn=function(f) f() end,delay=function(_,f) f() end,wait=function() end}
_buttons={};_notes={}
function _mkSection()
 return {
  Label=function(self,t) local l={text=t};function l:SetText(s) l.text=s end;return l end,
  Button=function(self,d) _buttons[d.Name]=d.Callback;return {} end,
  Toggle=function(self,d) local o={};function o:Set(v,s) o.Value=v end;function o:Refresh(x) end;return o end,
 }
end
Lumen={State={Screen=obj('CAM Probe','ScreenGui')},Folder='',Unload=function(self) self.unloaded=true end}
function Lumen:Notification(d) _notes[#_notes+1]=d.Description end
function Lumen:Window(o) return {Page=function() return {Section=function(_,so) return _mkSection() end} end} end
getgenv=function() return _G end
typeof=function(v) if type(v)=='table' and v.IsA then return 'Instance' end;return type(v) end
UDim2={new=function() return {} end,fromOffset=function() return {} end,fromScale=function() return {} end}
Enum=setmetatable({},{__index=function(_,k) return setmetatable({},{__index=function() return k end}) end})
'''

def make(hook=True, prelude_extra=''):
    lua=LuaRuntime(unpack_returned_tuples=True)
    extra=PRELUDE if hook else PRELUDE.replace('hookfunction=function(f,h) _hooks[f]=h;return f end','hookfunction=nil').replace('restorefunction=function(f) _hooks[f]=nil end','restorefunction=nil')
    lua.execute(extra+'\n_env={}\n'+prelude_extra)
    lua.execute(Path('portable_json.lua').read_text()+'\n'+Path('action_probe_logic.lua').read_text())
    return lua

lua=make()
assert lua.eval('CAMActionProbe.Version')=='1.1'
# ATTACH taps with hookfunction available: C2S hooked, S2C subscribed, UI watched.
lua.execute('''
_extBtn=_add(_gui,obj('Unlock','TextButton'))
_origServer=_signalsT.ToServer
_buttons['1) ATTACH taps (signals / buttons / data watchers)']()
assert(CAMActionProbe.Stats().taps==3)
_buttons['1) ATTACH taps (signals / buttons / data watchers)']()
assert(CAMActionProbe.Stats().taps==3)
_extBtn.Activated:Fire()
assert(#CAMActionProbe.T.buttons==0)
''')
# Scenario marker then record.
lua.execute('''
_buttons['Skill tree: unlock ONE node now']()
assert(CAMActionProbe.T.scenario:find('Skill tree',1,true)~=nil)
_buttons['2) START recording (then perform the action)']()
_nm='FireServer';_namecallHook(_remote,'PurchaseFromShop','Worm',1)
assert(CAMActionProbe.T.signals[1].dir=='C2S.remote')
assert(CAMActionProbe.T.signals[1].mod:find('BuyRemote',1,true)~=nil)
''')
# Localized-ref call (pre-captured function) is recorded through hookfunction, result preserved.
r=lua.eval('''(function()
local a,b=_call(_origServer,'UnlockSkill','Double Jump')
assert(a=='ok' and b==7)
return #CAMActionProbe.T.signals
end)()''')
assert r==2
row=lua.eval('CAMActionProbe.T.signals[2]')
assert row['dir']=='C2S' and row['fn']=='ToServer'
args=row['args']
assert args[1]=='UnlockSkill' and args[2]=='Double Jump',list(args.values()) if hasattr(args,'values') else args
# S2C event recorded.
lua.execute('_tick:fire(123)')
sigs=lua.eval('#CAMActionProbe.T.signals')
assert sigs==3
assert lua.eval('CAMActionProbe.T.signals[3].dir')=='S2C'
# UI buttons: pre-existing + newly added recorded; own probe button filtered.
lua.execute('''
_extBtn.Activated:Fire()
_newBtn=_add(_gui,obj('LearnNode','TextButton'))
_newBtn.Activated:Fire()
_own=_add(Lumen.State.Screen,obj('START recording','TextButton'))
_own.Activated:Fire()
''')
assert lua.eval('#CAMActionProbe.T.buttons')==2
# Data delta.
lua.execute('_goal.Value=500;_beat(0.5)')
assert lua.eval('''(function()
 for _,d in ipairs(CAMActionProbe.T.deltas) do if d.path:find('Goal',1,true) and d.new=='500' then return true end end
 return false
end)()''') is True
# Targeted scan: keyword match only; decompile failure recorded without source.
lua.execute('''
_add(_scripts,obj('SkillTreeUnlocker','LocalScript'))
_add(_scripts,obj('FishingRod','LocalScript'))
_add(_scripts,obj('UnrelatedThing','LocalScript'))
_buttons['Scan keyword scripts + decompile (one click)']()
local n=0;local withSource=0;local withError=0
for _,row in pairs(CAMActionProbe.T.sources) do
 n=n+1
 if row.source then withSource=withSource+1 end
 if row.error then withError=withError+1 end
end
assert(n==2 and withSource==1 and withError==1)
''')
# Export.
lua.execute("_buttons['STOP recording + SAVE + COPY report']()")
names=list(lua.globals()._written.keys())
assert len(names)==1 and names[0].startswith('CAM_ActionProbe_')
written=lua.eval('_written['+next(iter(names)).__repr__().replace("'",'"')+']')
clip=lua.eval('_clipboard')
assert written==clip
for needle in ['CAM ActionProbe 1.1','UnlockSkill','BuyRemote','SkillTreeUnlocker','Skill tree']:
    assert needle in written,needle
assert lua.eval('CAMActionProbe.T.recording') is False
# Unload: hooked call no longer records; env cleared.
before=lua.eval('#CAMActionProbe.T.signals')
lua.execute('CAMActionProbe.Stop()')
lua.execute("_call(_origServer,'Ping');_tick:fire(1);_extBtn.Activated:Fire()")
assert lua.eval('CAMActionProbe==nil')
print('PASS probe (hookfunction): C2S+C2S-ret/S2C/UI/deltas/scan/export/restore-on-unload')

# Fallback environment WITHOUT hookfunction: table wrap records and restores identity.
lua2=make(hook=False)
lua2.execute('''
_origServer=_signalsT.ToServer
_buttons['1) ATTACH taps (signals / buttons / data watchers)']()
assert(CAMActionProbe.Stats().taps==3)
_wrappedField=_signalsT.ToServer
assert(_wrappedField~=_origServer)
_buttons['2) START recording (then perform the action)']()
local a=_signalsT.ToServer('Buy','Worm')
assert(a=='ok')
assert(#CAMActionProbe.T.signals==1)
CAMActionProbe.Stop()
assert(_signalsT.ToServer==_origServer)
''')
print('PASS probe (table wrap): records via module field, restores original on unload')
print('Mock only; real tap coverage in Roblox depends on executor hookfunction support.')

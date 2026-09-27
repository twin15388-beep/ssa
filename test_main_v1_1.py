from pathlib import Path
from lupa import LuaRuntime
lua=LuaRuntime(unpack_returned_tuples=True)
lua.execute(r'''
_buttons={};_toggles={};_confirms={};_notices={};_sent={};_delayed={};_spawn={};_signals={};_clock=10;_activations=0
os.clock=function() return _clock end
function getgenv() return _G end
function typeof(x) return type(x)=='table' and (x.__type or (x.ClassName and 'Instance')) or type(x) end
function table.pack(...) return {n=select('#',...),...} end
function table.clone(x) local t={} for k,v in pairs(x) do t[k]=v end return t end
local vm={}
vm.__index=function(v,k) if k=='Magnitude' then return math.sqrt(v.X*v.X+v.Y*v.Y+v.Z*v.Z) elseif k=='Unit' then local n=math.sqrt(v.X*v.X+v.Y*v.Y+v.Z*v.Z);return Vector3.new(v.X/n,v.Y/n,v.Z/n) end return rawget(vm,k) end
vm.__add=function(a,b) return Vector3.new(a.X+b.X,a.Y+b.Y,a.Z+b.Z) end
vm.__sub=function(a,b) return Vector3.new(a.X-b.X,a.Y-b.Y,a.Z-b.Z) end
vm.__mul=function(a,b) return Vector3.new(a.X*b,a.Y*b,a.Z*b) end
Vector3={new=function(x,y,z) return setmetatable({X=x,Y=y,Z=z,__type='Vector3'},vm) end};Vector3.zero=Vector3.new(0,0,0)
Vector2={new=function() return {} end}
CFrame={new=function(x,y,z) return {Position=type(x)=='table' and x or Vector3.new(x or 0,y or 0,z or 0)} end,lookAt=function(p) return {Position=p} end}
Color3={new=function(...) return {} end,fromRGB=function(...) return {} end}
UDim2={new=function() return {} end,fromOffset=function() return {} end,fromScale=function() return {} end}
Enum=setmetatable({}, {__index=function(t,k) local e=setmetatable({}, {__index=function(x,n) rawset(x,n,k..'.'..n);return x[n] end});rawset(t,k,e);return e end})
TweenInfo={new=function(...) return {} end}
RaycastParams={new=function() return {} end}
local function signal()
 local s={items={}}
 function s:Connect(fn) local c={connected=true,fn=fn};function c:Disconnect() self.connected=false end self.items[#self.items+1]=c;return c end
 function s:Fire(...) for _,c in ipairs(self.items) do if c.connected then c.fn(...) end end end
 _signals[#_signals+1]=s;return s
end
local function obj(name,class,props)
 local o=props or {};o.Name=name;o.ClassName=class;o.children=o.children or {};o.attrs=o.attrs or {};o.Parent=o.Parent or true
 function o:IsA(c) return self.ClassName==c or c=='BasePart' and self.ClassName=='Part' or c=='GuiObject' and (self.ClassName=='Frame' or self.ClassName=='TextButton') end
 function o:FindFirstChild(n) for _,x in ipairs(self.children) do if x.Name==n then return x end end end
 function o:WaitForChild(n) return self:FindFirstChild(n) end
 function o:GetChildren() return self.children end
 function o:GetDescendants() local list={} local function walk(p) for _,ch in ipairs(p.children) do list[#list+1]=ch;walk(ch) end end walk(self);return list end
 function o:FindFirstChildOfClass(c) for _,x in ipairs(self.children) do if x:IsA(c) then return x end end end
 function o:FindFirstChildWhichIsA(c,recursive) for _,x in ipairs(recursive and self:GetDescendants() or self.children) do if x:IsA(c) then return x end end end
 function o:GetAttribute(k) return self.attrs[k] end
 function o:SetAttribute(k,v) self.attrs[k]=v end
 function o:GetAttributes() return self.attrs end
 function o:GetFullName() return self.Name end
 function o:GetPropertyChangedSignal() return signal() end
 function o:Destroy() self.Parent=nil end
 function o:Activate() _activations=_activations+1 end
 function o:InputHoldBegin() self.held=true end
 function o:InputHoldEnd() self.held=false end
 function o:MoveTo(p) self.lastMove=p end
 function o:ChangeState() end
 function o:EquipTool(t) t.Parent=self.Parent end
 function o:UnequipTools() end
 o.Activated=signal()
 return o
end
function _add(parent,child) parent.children[#parent.children+1]=child;child.Parent=parent;return child end
_obj=obj
Instance={new=function(c) return obj(c,c) end}
local character=obj('LocalCharacter','Model')
local hum=_add(character,obj('Humanoid','Humanoid',{Health=100,MaxHealth=100,WalkSpeed=16,PlatformStand=false}))
local root=_add(character,obj('HumanoidRootPart','Part',{Position=Vector3.zero,CFrame=CFrame.new(0,0,0),CanCollide=true}))
_add(character,obj('Fists','Tool',{Enabled=true}))
local hunter=obj('Hunter','Model')
_add(hunter,obj('Humanoid','Humanoid',{Health=100,MaxHealth=100}))
_add(hunter,obj('HumanoidRootPart','Part',{Position=Vector3.new(3,0,0),CFrame=CFrame.new(3,0,0)}))
_hunter=hunter
local lp=obj('LocalPlayer','Player',{Character=character,Team={Name='Vampires'},attrs={Years=200,Stamina=100,Mana=200,BloodThirst=100},CharacterRemoving=signal()})
_add(lp,obj('Backpack','Backpack'));_add(lp,obj('PlayerGui','PlayerGui'));lp.Backpack=lp:FindFirstChild('Backpack')
_LP=lp
workspace=obj('Workspace','Workspace',{DescendantAdded=signal(),DescendantRemoving=signal()})
_add(workspace,character);_add(workspace,hunter)
function workspace:GetServerTimeNow() return _clock end
local quest2=_add(workspace,obj('Quest2','Model'))
_paper=_add(quest2,obj('Paper','Part',{Position=Vector3.new(2,0,0),attrs={Quest2Enabled=true,Quest2Range=11,Quest2MinLevel=5,Quest2OfferId='offer1'}}))
local rs=obj('ReplicatedStorage','ReplicatedStorage')
function _remote(path)
 local o=rs
 for i,name in ipairs(path) do
  local child=o:FindFirstChild(name)
  if not child then
   child=_add(o,obj(name,i==#path and 'RemoteEvent' or 'Folder'))
   if i==#path then
    child.OnClientEvent=signal()
    function child:FireServer(...) _sent[#_sent+1]={remote=self.Name,args=table.pack(...)} end
   end
  end
  o=child
 end
 return o
end
for _,name in ipairs({'BreakNeck','BloodDrink','HeartRipping','Infect','Hypnosis','WitchLifeDrain','WitchBreakNeck','WitchHeartRipping','WitchPetrification','WitchPainInfliction','WitchInvisible','Strength','Incendia'}) do _remote({'Network','Combat',name..'Request'}) end
for _,name in ipairs({'HumanSideQuestRemote','ShopRemote','BroomRemote','CeilingSleepRemote','VampiricTrackerRemote','WitchPainInflictionRemote','StrengthRemote'}) do _remote({'Funções','Eventos',name}) end
_remote({'ArczisCombat','Remotes','BlockEvent'});_remote({'QuestRemotes','QuestRemote'});_remote({'HunterQuestRemotes','HunterQuestRemote'});_remote({'Quest2Remotes','Quest2Remote'})
local function json(v,seen)
 local t=type(v)
 if t=='string' then return string.format('%q',v):gsub('\\\n','\\n') end
 if t=='boolean' or t=='number' then return tostring(v) end
 if t~='table' then return 'null' end
 seen=seen or {};if seen[v] then return '"<cycle>"' end;seen[v]=true
 local a={}
 for k,x in pairs(v) do a[#a+1]=json(tostring(k))..':'..json(x,seen) end
 seen[v]=nil;return '{'..table.concat(a,',')..'}'
end
local players={LocalPlayer=lp,GetPlayers=function() return {lp} end,GetPlayerFromCharacter=function(self,c) if c==character then return lp end end}
local input={InputBegan=signal(),JumpRequest=signal(),GetFocusedTextBox=function() return nil end,IsKeyDown=function() return false end,KeyboardEnabled=true}
local run={Heartbeat=signal()};_run=run
local tween={Create=function(self,r,info,p) local t={Completed=signal()};function t:Play() end;function t:Cancel() self.Completed:Fire() end;return t end}
local services={Players=players,ReplicatedStorage=rs,RunService=run,UserInputService=input,TweenService=tween,HttpService={JSONEncode=function(self,v) return json(v) end}}
game={PlaceId=122287678911982,PlaceVersion=2812,GetService=function(self,n) return services[n] end}
task={spawn=function(fn) _spawn[#_spawn+1]=fn end,wait=function() end,delay=function(delay,fn) _delayed[#_delayed+1]={at=_clock+delay,fn=fn} end}
function _flush(delay)
 _clock=_clock+(delay or 1)
 local old=_delayed;_delayed={}
 for _,x in ipairs(old) do if x.at<=_clock then x.fn() else _delayed[#_delayed+1]=x end end
end
function setclipboard(s) _clipboard=s end
Lumen={State={Screen=obj('Screen','ScreenGui')},Unload=function(self) self.unloaded=true end,Notification=function(self,d) _notices[#_notices+1]=d.Description end}
local section={}
function section:Label(text) return {SetText=function(self,s) self.text=s end} end
function section:Button(d) _buttons[d.Name]=d.Callback;_confirms[d.Name]=d.Confirm;return {} end
function section:Toggle(d)
 _toggles[d.Name]=d.Callback
 local o={};function o:Set(v,silent) self.Value=v;if not silent and d.Callback then d.Callback(v) end end;function o:Refresh(x) self.items=x end
 return o
end
section.Slider=section.Toggle;section.Dropdown=section.Toggle;section.Textbox=section.Toggle
function Lumen:Window() return {Page=function() return {Section=function() return section end} end} end
''')
lua.execute(Path('dh_main_v1_1_logic.lua').read_text())
assert len(lua.globals()._sent)==0, 'startup must not send gameplay requests'
assert lua.eval('NZLMainHub.State.autoM1') is False
assert lua.eval('NZLMainHub.State.autoSkill') is False
# Run the initial world indexing task only, not the perpetual UI loop.
lua.execute('_spawn[1]()')
lua.execute('_buttons["Select nearest valid target"]()')
assert lua.eval('NZLMainHub.State.target == _hunter')
lua.execute('_buttons["M1 once"]()')
assert lua.globals()._activations==1
assert len(lua.globals()._sent)==0, 'M1 should activate native tool, not inject combat remote'
lua.execute('_buttons["Cast selected on current target"]()')
assert lua.eval('_sent[1].remote')=='BloodDrinkRequest'
assert lua.eval('_sent[1].args[1]')=='Begin'
lua.execute('_flush(0.1)')
assert lua.eval('_sent[2].args[1]')=='Bite'
assert lua.eval('_sent[2].args[2] == _hunter')
# STOP invalidates pending ability sequence.
lua.execute('_flush(10); _buttons["Cast selected on current target"](); _buttons["STOP ALL (End)"](); _flush(1)')
assert len(lua.globals()._sent)==3
# Proper Quest2 payload, then spam suppression.
lua.execute('_buttons["Accept nearest Quest2 offer"]()')
assert lua.eval('_sent[#_sent].remote')=='Quest2Remote'
assert lua.eval('_sent[#_sent].args[1]')=='Accept'
assert lua.eval('_sent[#_sent].args[2] == _paper')
assert lua.eval('_sent[#_sent].args[3]')=='offer1'
n=len(lua.globals()._sent)
lua.execute('_buttons["Accept nearest Quest2 offer"]()')
assert len(lua.globals()._sent)==n
# Restore original local WalkSpeed and collision on STOP.
lua.execute('_toggles["WalkSpeed override"](true); _toggles["Noclip"](true); _run.Heartbeat:Fire(0.2)')
assert lua.eval('_LP.Character:FindFirstChild("Humanoid").WalkSpeed')==28
assert lua.eval('_LP.Character:FindFirstChild("HumanoidRootPart").CanCollide') is False
lua.execute('_buttons["STOP ALL (End)"]()')
assert lua.eval('_LP.Character:FindFirstChild("Humanoid").WalkSpeed')==16
assert lua.eval('_LP.Character:FindFirstChild("HumanoidRootPart").CanCollide') is True
# Stop block even immediately after start, without hitting same-route throttle.
lua.execute('_buttons["Block ON"](); _buttons["STOP ALL (End)"]()')
assert lua.eval('_sent[#_sent].remote')=='BlockEvent'
assert lua.eval('_sent[#_sent].args[1]') is False
assert lua.eval('_confirms["BUY selected (spends game currency)"]') is True
n=len(lua.globals()._sent)
lua.execute('_buttons["BUY selected (spends game currency)"]()')
assert len(lua.globals()._sent)==n, 'must reject unavailable shop card'
lua.execute('_buttons["COPY diagnostic report"]()')
assert 'NZL Main Hub' in lua.globals()._clipboard
# Wrong place protection is also present in the send wrapper.
lua.execute('game.PlaceId=1; _buttons["Quest: choose kill"]()')
assert len(lua.globals()._sent)==n
lua.execute('game.PlaceId=122287678911982; _buttons["Unload hub"]()')
assert lua.eval('NZLMainHub == nil')
assert lua.eval('Lumen.unloaded')
assert lua.eval('(function() for _,s in ipairs(_signals) do for _,c in ipairs(s.items) do if c.connected then return false end end end return true end)()')
print('PASS: startup sends no gameplay requests; target filters; native M1; vampire payload; STOP cancels pending action; Quest2 payload/throttle; movement restore; block release; confirmed purchase guard; diagnostics; wrong-place guard; unload disconnects.')
print('Roblox/executor integration and native Lumen UI are NOT runtime-tested here.')

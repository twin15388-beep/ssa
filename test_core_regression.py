from pathlib import Path
from lupa import LuaRuntime
lua = LuaRuntime(unpack_returned_tuples=True)
lua.execute(r'''
_G._buttons = {}
_G._changes = {}
_G._exports = {}
_G._notices = {}
function typeof(v) if type(v)=='table' and v.ClassName then return 'Instance' end return type(v) end
function table.clone(t) local n={} for k,v in pairs(t) do n[k]=v end return n end
function getgenv() return _G end
function setclipboard(s) _exports[#_exports+1]=s end
function writefile(n,s) _exports[#_exports+1]=s end
function decompile(obj) return '-- mock decompiled '..obj.Name end
local function signal() return {Connect=function(self,fn) return {Disconnect=function() end} end} end
local function object(name,class,children,extra)
 local obj=extra or {}; obj.Name=name; obj.ClassName=class; obj.children=children or {}
 function obj:GetChildren() return self.children end
 function obj:GetFullName() return 'game.'..self.Name end
 function obj:IsA(c) return self.ClassName==c or c=='LuaSourceContainer' and (self.ClassName=='ModuleScript' or self.ClassName=='LocalScript' or self.ClassName=='Script') end
 function obj:FindFirstChild(n) for _,ch in ipairs(self.children) do if ch.Name==n then return ch end end end
 function obj:GetAttributes() return {test=true} end
 function obj:FindFirstChildOfClass(c) for _,ch in ipairs(self.children) do if ch.ClassName==c then return ch end end end
 return obj
end
local function json(v)
 if type(v)=='string' then return string.format('%q',v):gsub('\\\n','\\n') end
 if type(v)=='number' or type(v)=='boolean' then return tostring(v) end
 if type(v)~='table' then return 'null' end
 local parts={}
 if #v>0 then for _,x in ipairs(v) do parts[#parts+1]=json(x) end return '['..table.concat(parts,',')..']' end
 for k,x in pairs(v) do parts[#parts+1]=json(tostring(k))..':'..json(x) end
 return '{'..table.concat(parts,',')..'}'
end
_object = object
local localScripts = object('PlayerScripts', 'PlayerScripts', {object('ClientFeature', 'LocalScript')})
local localGui = object('PlayerGui','PlayerGui', {object('UiController','LocalScript')})
local character = object('LocalCharacter','Model', {object('Dash','LocalScript')})
local player=object('Player','Player', {localScripts,localGui,object('Backpack','Backpack')}, {Character=character})
workspace=object('Workspace','Workspace',{object('NPC','Model',{object('Humanoid','Humanoid',nil,{Health=100})})})
local module=object('Module','ModuleScript',nil,{Source='return {}'})
local localScript=object('Client','LocalScript')
local replicated=object('ReplicatedStorage','ReplicatedStorage',{object('Event','RemoteEvent'),module,localScript,object('Prompt','ProximityPrompt')})
local services={Players={LocalPlayer=player},HttpService={JSONEncode=function(self,v) return json(v) end},LogService={GetLogHistory=function() return {} end,MessageOut=signal()},CollectionService={GetTags=function() return {} end},ScriptContext={Error=signal()}}
game={PlaceId=1,GameId=2,PlaceVersion=3,IsLoaded=function() return true end,GetService=function(self,n) return services[n] end,GetChildren=function() return {replicated,workspace} end}
local roots={replicated,workspace,object('CorePackages','CorePackages',{object('Internal','ModuleScript',nil,{Source='PRIVATE_ENGINE_TEXT'})}), object('Players','Players',{player})}
function game:FindFirstChild(n) for _,x in ipairs(roots) do if x.Name==n then return x end end end
task={spawn=function(fn) fn() return {} end,wait=function() end,cancel=function() end}
Enum={KeyCode={RightControl={}}}
UDim2={fromOffset=function() return {} end}
Lumen={State={Screen={}},Unload=function() end,Notification=function(self,d) _notices[#_notices+1]=d.Description end}
local section={}
function section:Label(text) return {SetText=function(self,text) self.text=text end} end
function section:Button(d) _buttons[d.Name]=d.Callback end
function section:Toggle(d) _changes[d.Name]=d.Callback return {Set=function(self,v,silent) if not silent and d.Callback then d.Callback(v) end end} end
section.Slider=section.Toggle
section.Textbox=section.Toggle
section.Dropdown=section.Toggle
function Lumen:Window(d) return {Page=function() return {Section=function() return section end} end} end
''')

lua.execute(Path('core_debug_logic.lua').read_text())
import json

def run(code):
    lua.execute(code + '; _buttons["COPY REPORT"]()')
    exports = lua.globals()._exports
    return json.loads(exports[len(exports)])

r = run('_buttons["Scan game (manual settings)"]()')
assert r['stats']['completed'] and r['stats']['sourcesCollected']==0
assert not any('CorePackages' in x['path'] for x in r['nodes'])
assert r['settings']['maxSources'] == 250
r = run('_buttons["ReplicatedStorage + decompile"]()')
assert r['section'] == 'Scripts' and r['settings']['profile']=='replicated'
assert r['stats']['sourcesCollected'] == 2
assert len(r['roots'])==1 and r['roots'][0]['name']=='ReplicatedStorage'
assert r['settings']['sources'] and r['settings']['decompile']
assert r['stats']['sourceFailures']==0 and not r['stats']['incomplete']
assert r['stats']['sourceUniqueTexts']==2
r = run('_buttons["Local client scripts + decompile"]()')
assert r['settings']['profile']=='clients'
assert r['stats']['sourcesCollected']==3
assert not any('CorePackages' in x['path'] for x in r['records'])
assert {x['name'] for x in r['roots']}=={'PlayerScripts','PlayerGui','LocalCharacter','Backpack'}
r = run('_changes["Saved scan"]("ReplicatedStorage")')
assert r['settings']['profile']=='replicated' and r['stats']['sourcesCollected']==2
r = run('_changes["Saved scan"]("Latest")')
assert r['settings']['profile']=='clients'
# Synthetic oversized source exercises source truncation and incomplete reporting.
lua.execute('table.insert(game:FindFirstChild("ReplicatedStorage").children, _object("Big", "ModuleScript", nil, {Source=string.rep("a", 170000)}))')
r = run('_buttons["ReplicatedStorage + decompile"]()')
assert r['stats']['sourceTruncatedCount']==1 and r['stats']['sourceIncomplete'] and r['stats']['incomplete']
assert len(next(x['source'] for x in r['records'] if x['path'].endswith('.Big'))) == 160000
# Limit and empty filter are captured in export, not silently lost.
r = run('_changes["Max source scripts"](1); _buttons["Scan game (manual settings)"]()')
assert r['settings']['maxSources']==1 and r['stats']['sourceCountLimitSkipped']>0
r = run('_changes["Export path filter"]("NO_MATCH")')
assert len(r['records'])==0
lua.execute('_buttons["Unload collector"]()')
print('PASS: allowlist excludes CorePackages; both presets; UI presets; settings in export; cached profiles; source truncation; limits; export filter; unload.')
print('Mock tests only, not a Roblox runtime test.')

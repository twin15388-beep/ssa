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
local player=object('Player','Player')
workspace=object('Workspace','Workspace',{object('NPC','Model',{object('Humanoid','Humanoid',nil,{Health=100})})})
local module=object('Module','ModuleScript',nil,{Source='return {}'})
local localScript=object('Client','LocalScript')
local replicated=object('ReplicatedStorage','ReplicatedStorage',{object('Event','RemoteEvent'),module,localScript,object('Prompt','ProximityPrompt')})
local services={Players={LocalPlayer=player},HttpService={JSONEncode=function(self,v) return json(v) end},LogService={GetLogHistory=function() return {} end,MessageOut=signal()},CollectionService={GetTags=function() return {} end},ScriptContext={Error=signal()}}
game={PlaceId=1,GameId=2,PlaceVersion=3,IsLoaded=function() return true end,GetService=function(self,n) return services[n] end,GetChildren=function() return {replicated,workspace} end}
task={spawn=function(fn) fn() return {} end,wait=function() end,cancel=function() end}
Enum={KeyCode={RightControl={}}}
UDim2={fromOffset=function() return {} end}
Lumen={State={Screen={}},Unload=function() end,Notification=function(self,d) _notices[#_notices+1]=d.Description end}
local section={}
function section:Label(text) return {SetText=function(self,text) self.text=text end} end
function section:Button(d) _buttons[d.Name]=d.Callback end
function section:Toggle(d) _changes[d.Name]=d.Callback end
section.Slider=section.Toggle
section.Textbox=section.Toggle
section.Dropdown=section.Toggle
function Lumen:Window(d) return {Page=function() return {Section=function() return section end} end} end
''')
lua.execute(Path('collector.lua').read_text())
lua.execute('_buttons["Scan game"](); _buttons["COPY REPORT"]()')
import json
report = json.loads(lua.globals()._exports[1])
assert len(report['remotes']) == 1, report
assert len(report['scripts']) == 2
assert report['stats']['completed']
assert report['stats']['sourcesCollected'] == 0
lua.execute('_changes["Read available source"](true); _changes["Try executor decompile fallback"](true); _buttons["Scan game"](); _buttons["COPY REPORT"]()')
report = json.loads(lua.globals()._exports[2])
assert report['stats']['sourcesCollected'] == 2
assert report['scripts'][0]['source'] == 'return {}'
assert 'decompile' in report['scripts'][1]['sourceStatus']
lua.execute('_changes["Section"]("Remotes"); _changes["Export path filter"]("missing"); _buttons["COPY REPORT"]()')
report = json.loads(lua.globals()._exports[3])
assert len(report['records']) == 0
lua.execute('_buttons["Unload collector"]()')
print('Mock tests passed: scan, script metadata, opt-in source/decompile, filtered export, unload.')
print('This is not a Roblox runtime test.')

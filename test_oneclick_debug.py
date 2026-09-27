from pathlib import Path
import json,re
fixture=Path('test_collector_v1_1.py').read_text().split("lua.execute(Path('collector_v1_1.lua')")[0]
logic=Path('oneclick_debug_logic.lua').read_text()
paths=re.findall(r'"([^"]+)"',logic.split('local focusPaths = {',1)[1].split('\n    }',1)[0])
def make(mode='normal'):
    ns={};exec(compile(fixture,'fixture','exec'),ns);lua=ns['lua']
    lua.execute(r'''
_requires=0;_remoteCalls=0;_writes={};_copies={};_manualShown=0;_mode='normal'
function require() _requires=_requires+1;error('forbidden') end
function identifyexecutor() return 'TestExecutor','1.0' end
function setclipboard(text) if _mode=='copyfail' or _mode=='bothfail' then error('clipboard denied') end;_copies[#_copies+1]=text end
function writefile(name,text) if _mode=='savefail' or _mode=='bothfail' then error('write denied') end;_writes[#_writes+1]={name=name,text=text} end
CAMMainHub={Version='1.0',Snapshot=function() return {status='No active input listener',state={attack=true},modules={Input='ready'}} end}
local old=_object
function _object(n,c,ch,e)
 local o=old(n,c,ch,e)
 function o:GetAttribute(k) return nil end
 function o:GetDescendants() local list={};local function walk(p) for _,v in ipairs(p:GetChildren()) do list[#list+1]=v;walk(v) end end;walk(self);return list end
 return o
end
local rs=game:FindFirstChild('ReplicatedStorage')
function _addPath(path)
 local current=rs;local names={};for n in path:gmatch('[^%.]+') do names[#names+1]=n end
 for i=2,#names do local o=current:FindFirstChild(names[i]);if not o then o=_object(names[i],i==#names and 'ModuleScript' or 'Folder',nil,i==#names and {Source='return {} -- '..path} or nil);current.children[#current.children+1]=o end;current=o end
 return current
end
local original=game.GetService
function game:GetService(n)
 if n=='ReplicatedStorage' then return rs end
 if n=='UserInputService' then return {KeyboardEnabled=true,TouchEnabled=false,GetPlatform=function() return 'Windows' end} end
 return original(self,n)
end
local lp=game:GetService('Players').LocalPlayer
function lp:GetAttribute() return nil end
function lp.Character:GetAttributes() return {} end
function getloadedmodules() return {rs:FindFirstChild('Module')} end
local signal={Connect=function() return {} end}
Instance={new=function(c) if c=='TextBox' then _manualShown=_manualShown+1 end;return {MouseButton1Click=signal,Destroy=function() end} end}
UDim2.fromScale=function() return {} end;UDim2.new=function() return {} end
Color3={new=function() return {} end,fromRGB=function() return {} end}
Enum.Font={Code='Code'};Enum.TextXAlignment={Left='Left'};Enum.TextYAlignment={Top='Top'}
''')
    for p in paths:lua.globals()._addPath(p)
    lua.globals()._addPath('ReplicatedStorage.CAM.Client.Components.Layout.Toolbar')
    lua.execute("_mode='"+mode+"'")
    lua.execute(Path('portable_json.lua').read_text()+'\n'+logic)
    assert len(lua.globals()._writes)==0 and len(lua.globals()._copies)==0
    return lua
lua=make()
standalone=Path('CAM_Debug_OneClick_v1.5.lua').read_text()
bootstrap=standalone.split('--#region bootstrap',1)[1].split('local Lumen = { }',1)[0]
lua.execute('_oldUiUnloaded=false;_G.Lumen={Unload=function() _oldUiUnloaded=true end}')
lua.execute(bootstrap)
assert lua.eval('_oldUiUnloaded') is False
assert 'getgenv().Lumen' not in standalone
assert standalone.endswith(logic)
lua.execute('_buttons["COLLECT + SAVE + COPY"]()')
assert len(lua.globals()._writes)==1 and len(lua.globals()._copies)==1
r=json.loads(lua.globals()._writes[1]['text'])
assert r['format']=='CAM Focused Debug OneClick 1.5'
assert r['settings']['requestedRootPaths']==paths
assert r['stats']['completed'] and not r['stats']['incomplete'],r['stats']
assert r['stats']['sourcesCollected']==13,r['stats']
assert r['runtimeBefore']['executor']['name']=='TestExecutor'
assert r['runtimeBefore']['device']['platform']=='Windows'
assert r['runtimeBefore']['mainHub']['report']['modules']['Input']=='ready'
assert not r['runtimeBefore']['errors'],r['runtimeBefore']['errors']
assert r['focusDiscovery']['paths']==['game.Toolbar']
assert lua.globals()._copies[1]==lua.globals()._writes[1]['text']
assert lua.eval('_requires')==0
lua.execute('_buttons["Export cached result again"]()');assert len(lua.globals()._writes)==2
# Missing roots are explicit; remaining report still delivered by the same click.
lua.execute("local rs=game:FindFirstChild('ReplicatedStorage');for i,o in ipairs(rs.children) do if o.Name=='Regions' then table.remove(rs.children,i);break end end;CAMMainHub=nil")
lua.execute('_buttons["COLLECT + SAVE + COPY"]()')
r=json.loads(lua.globals()._writes[3]['text'])
assert r['stats']['incomplete'] and r['stats']['missingRequestedRoots']==1
assert r['runtimeBefore']['mainHub']['present'] is False
assert r['settings']['missingRequestedRoots']==['ReplicatedStorage.Regions']
# Native JSON failure uses the already-tested portable fallback, automatically.
lua.execute('game:GetService("HttpService").JSONEncode=function() error("Can not convert to JSON") end; _buttons["COLLECT + SAVE + COPY"]()')
r=json.loads(lua.globals()._writes[4]['text']);assert r['_jsonExport']['serializer']=='portable-json-v1'
# Each output channel is independent; both failures open manual fallback.
for mode,files,copies,manual in [('savefail',0,1,0),('copyfail',1,0,0),('bothfail',0,0,1)]:
    l=make(mode);l.execute('_buttons["COLLECT + SAVE + COPY"]()')
    assert len(l.globals()._writes)==files,mode
    assert len(l.globals()._copies)==copies,mode
    assert l.eval('_manualShown')==manual,mode
    assert l.eval('_requires')==0
# No scanner UI presets to confuse the one-button workflow.
assert 'CORE dependencies + decompile' not in logic
assert 'scan("core")' in logic
for word in ('FireServer(', 'InvokeServer(', 'VirtualPress(', 'ToServer(', 'HttpGet(', 'hookfunction('):assert word not in logic,word
lua.execute('_buttons["Unload debug"]()')
print('PASS: one-click focused sources + discovered toolbar + executor/device + main snapshot + runtime state -> identical saved/copied JSON; missing roots; no-main case; native JSON failure; independent output failure/manual fallback; no startup scan or module execution.')
print('Mock tests; not a live Roblox test.')

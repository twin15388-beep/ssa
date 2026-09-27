from pathlib import Path
import json,re
ns={}
exec(compile(Path('test_oneclick_debug.py').read_text().split('lua=make()')[0],'fixture','exec'),ns)
logic=Path('world_content_debug_logic.lua').read_text()
ns['logic']=logic
ns['paths']=re.findall(r'"([^"]+)"',logic.split('local focusPaths = {',1)[1].split('\n    }',1)[0])
lua=ns['make']()
lua.globals()._addPath('ReplicatedStorage.Ouwland.Content.Bamboo Grove')
lua.globals()._addPath('ReplicatedStorage.Ouwland.Content.Bamboo Grove.Npcs.Tom')
lua.execute('_buttons["COLLECT + SAVE + COPY"]()')
r=json.loads(lua.globals()._writes[1]['text'])
assert r['format']=='CAM World Content Debug OneClick 1.6'
assert r['stats']['sourcesCollected']==3,r['stats']
assert r['focusDiscovery']['paths']==['game.Content']
assert not r['stats']['incomplete']
assert r['settings']['requestedRootPaths']==['ReplicatedStorage.CAM.Global.gameSettings']
assert r['runtimeBefore']['executor']['name']=='TestExecutor'
assert 'experience' in r['runtimeBefore']['localState']
assert lua.globals()._writes[1]['text']==lua.globals()._copies[1]
assert lua.eval('_requires')==0
# A missing world folder never looks like a complete collection.
lua.execute("local rs=game:FindFirstChild('ReplicatedStorage');for i,o in ipairs(rs.children) do if o.Name=='Ouwland' then table.remove(rs.children,i);break end end;_buttons['COLLECT + SAVE + COPY']()")
r=json.loads(lua.globals()._writes[2]['text'])
assert r['stats']['incomplete'] and r['stats']['sourceIncomplete']
assert r['focusDiscovery']['requiredRootMissing']
assert r['focusDiscovery']['errors']
# Same one-click save/copy under native JSONEncode failure.
lua.execute('game:GetService("HttpService").JSONEncode=function() error("bad UTF8") end;_buttons["COLLECT + SAVE + COPY"]()')
r=json.loads(lua.globals()._writes[3]['text'])
assert r['_jsonExport']['serializer']=='portable-json-v1'
text=Path('CAM_Debug_WorldContent_v1.6.lua').read_text()
assert text.endswith(logic)
assert 'getgenv().Lumen' not in text
assert 'HttpGet(' not in text
print('PASS: actual dynamic world Content + gameSettings only; no repeat of 82 sources; one-click file+clipboard; progression snapshot; missing-Content flag; JSON fallback; isolated UI; no module execution. Mock tests only.')

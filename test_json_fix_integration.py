from pathlib import Path
import json
h=Path('test_collector_v1_1.py').read_text().split("lua.execute(Path('collector_v1_1.lua')")[0]
exec(compile(h,'mock_env','exec'))
lua.execute(Path('portable_json.lua').read_text()+'\n_G.PortableJSON=PortableJSON')
lua.execute(r'''
local h=game:GetService('HttpService');local base=h.JSONEncode
h.JSONEncode=function(self,value)
 if _forceNativeFail and type(value)=='table' then error("Can't convert to JSON") end
 return base(self,value)
end
local rs=game:FindFirstChild('ReplicatedStorage')
rs.children[#rs.children+1]=_object('Bad_'..string.char(255)..'_Name','Folder')
''')
lua.execute(Path('json_fix_logic.lua').read_text())
lua.execute('_buttons["Game overview (no source)"](); _forceNativeFail=true; _buttons["COPY REPORT"]()')
r=json.loads(lua.globals()._exports[1])
assert r['settings']['profile']=='overview'
assert r['_jsonExport']['normalizationCount']>=2
assert any(x['field']=='nodes' for x in r['_jsonExport']['nativeFailedFields'])
assert any('nodes' in x['path'] for x in r['_jsonExport']['issues'])
assert any(x['name']=='Bad_�_Name' for x in r['nodes'])
lua.execute('_buttons["Save report (.json)"]()')
s=json.loads(lua.globals()._exports[2])
assert s['stats']['nodes']==r['stats']['nodes']
lua.execute('_forceNativeFail=false; _buttons["Local client scripts + decompile"](); _forceNativeFail=true; _buttons["COPY ALL SCANS"]()')
b=json.loads(lua.globals()._exports[3])
assert b['reportCount']==2 and b['_jsonExport']['normalizationCount']>0
assert {x['settings']['profile'] for x in b['reports']}=={'overview','clients'}
# Cancel while fallback probes native fields; cached scans must remain usable afterwards.
n=len(lua.globals()._exports)
lua.execute('''
local done=false
task.wait=function() if not done then done=true;_buttons['Cancel (keep partial report)']() end end
_buttons['COPY ALL SCANS']()
task.wait=function() end
''')
assert len(lua.globals()._exports)==n
lua.execute('_buttons["COPY ALL SCANS"]()')
b=json.loads(lua.globals()._exports[n+1])
assert b['reportCount']==2
lua.execute('_buttons["Unload collector"]()')
print('PASS: native Cant-convert failure -> valid overview copy/save; offending field and UTF-8 issue paths; bundle fallback; cancel export without losing scans; retry succeeds.')

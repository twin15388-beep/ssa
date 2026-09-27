from pathlib import Path
import json,re
h=Path('test_collector_v1_1.py').read_text().split("lua.execute(Path('collector_v1_1.lua')")[0]
exec(compile(h,'mock_env','exec'))
s=Path('core_debug_logic.lua').read_text()
block=s.split('local focusPaths = {',1)[1].split('\n    }',1)[0]
paths=re.findall(r'"([^"]+)"',block)
assert len(paths)==25
lua.execute('''
function _addPath(path)
 local current=game:FindFirstChild('ReplicatedStorage')
 local names={}
 for name in path:gmatch('[^%.]+') do names[#names+1]=name end
 for i=2,#names do
  local name=names[i]
  local obj=current:FindFirstChild(name)
  if not obj then
   obj=_object(name,i==#names and 'ModuleScript' or 'Folder',nil,i==#names and {Source='return {} -- '..path} or nil)
   current.children[#current.children+1]=obj
  end
  current=obj
 end
end
''')
for p in paths:lua.globals()._addPath(p)
lua.execute(s)
lua.execute('_buttons["CORE dependencies + decompile"](); _buttons["COPY REPORT"]()')
r=json.loads(lua.globals()._exports[1])
assert r['settings']['profile']=='core'
assert r['settings']['maxSources']==500
assert r['settings']['requestedRootPaths']==paths
assert len(r['settings']['missingRequestedRoots'])==0
assert r['stats']['missingRequestedRoots']==0
assert r['stats']['sourcesCollected']==25
assert not r['stats']['incomplete']
assert len(r['roots'])==25
assert not any(x['path'].endswith('.Module') or x['path'].endswith('.Client') for x in r['records'])
# Delete just one requested module and verify explicit incomplete/missing reporting.
lua.execute('local rs=game:FindFirstChild("ReplicatedStorage"); local a=rs:FindFirstChild("CAM"):FindFirstChild("Global"); for i,x in ipairs(a.children) do if x.Name=="Checker" then table.remove(a.children,i);break end end')
lua.execute('_buttons["CORE dependencies + decompile"](); _buttons["COPY REPORT"]()')
r=json.loads(lua.globals()._exports[2])
assert r['stats']['sourcesCollected']==24
assert r['stats']['missingRequestedRoots']==1
assert r['settings']['missingRequestedRoots']==['ReplicatedStorage.CAM.Global.Checker']
assert r['stats']['sourceIncomplete'] and r['stats']['incomplete']
lua.execute('_buttons["Game overview (no source)"](); _buttons["COPY ALL SCANS"]()')
r=json.loads(lua.globals()._exports[3])
assert {x['settings']['profile'] for x in r['reports']}=={'core','overview'}
assert r['reportCount']==2
print('PASS: 25 known explicit roots; 500-source preset; no unrelated replicated assets; missing-root reporting; bundle includes core and overview.')

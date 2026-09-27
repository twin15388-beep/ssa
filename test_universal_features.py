from pathlib import Path
import json
harness=Path('test_collector_v1_1.py').read_text().split("lua.execute(Path('collector_v1_1.lua')")[0]
exec(compile(harness,'mock_env','exec'))
lua.execute(r'''
function decompile(o)
    if o.Name=='ErrorStub' then return "-- Decompiled with mock.\n\n-- Error: :5: Expected identifier when parsing expression, got 'local'" end
    if o.Name=='WarningWithCode' then return "-- Error: diagnostic example\nreturn {}" end
    if o.Name=='BlockError' then return "--[[\nError: failed to decompile\n]]" end
    return '-- mock ' .. o.Name .. '\nreturn {}'
end
local rs=game:FindFirstChild('ReplicatedStorage')
for _,name in ipairs({'ErrorStub','WarningWithCode','BlockError'}) do table.insert(rs.children,_object(name,'ModuleScript')) end
''')
lua.execute(Path('universal_debug_logic.lua').read_text())
lua.execute('_buttons["COPY ALL SCANS"]()')
assert len(lua.globals()._exports)==0

def capture(button):
    lua.execute(f'_buttons[{json.dumps(button)}]()')
    ex=lua.globals()._exports
    return json.loads(ex[len(ex)])

lua.execute('_changes["Read available source"](true); _changes["Try executor decompile fallback"](true); _buttons["Game overview (no source)"]()')
r=capture('COPY REPORT')
assert r['settings']['profile']=='overview'
assert not r['settings']['sources'] and r['stats']['sourcesCollected']==0
assert r['game']['placeId']==1  # no place restriction
lua.execute('_changes["Max source scripts"](500); _buttons["ReplicatedStorage + decompile"]()')
r=capture('COPY REPORT')
assert r['settings']['maxSources']==500
assert r['stats']['sourceDiagnosticErrors']==2
assert r['stats']['sourceFailures']==2
assert r['stats']['sourcesCollected']==3
assert r['stats']['sourceWarnings']==1
assert r['stats']['incomplete']
error=next(x for x in r['records'] if x['path'].endswith('ErrorStub'))
assert 'source' not in error
assert 'Expected identifier' in error['decompilerDiagnostic']
assert error['sourceErrorKind']=='decompiler_diagnostic_only'
warning=next(x for x in r['records'] if x['path'].endswith('WarningWithCode'))
assert warning['source'].endswith('return {}') and warning['sourceWarning']
lua.execute('_buttons["Local client scripts + decompile"](); _changes["Export path filter"]("NONEXISTENT")')
r=capture('COPY ALL SCANS')
assert r['exportType']=='bundle' and r['reportCount']==3
assert {x['settings']['profile'] for x in r['reports']}=={'overview','replicated','clients'}
assert all('nodes' in x for x in r['reports'])
assert any(x['stats']['sourceDiagnosticErrors']==2 for x in r['reports'])
r2=capture('Save ALL scans (.json)')
assert r2['reportCount']==3
lua.execute('_buttons["Unload collector"]()')
print('PASS: arbitrary PlaceId; source-free overview; configured source limit; diagnostic-only failure classification; mixed-code warnings retained; one valid JSON bundle; all scans saved; filters do not hide bundle content.')
print('Mock checks only, not a Roblox runtime test.')

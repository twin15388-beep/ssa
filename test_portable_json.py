from pathlib import Path
import json
from lupa import LuaRuntime
lua=LuaRuntime(unpack_returned_tuples=True)
lua.execute(Path('portable_json.lua').read_text()+'\n_G.PortableJSON=PortableJSON')
lua.execute(r'''
function typeof(v) return type(v) end
_test={greeting='Привет 🌍',controls='a\0\1\t\r\n"\\z',invalid=string.char(255,192,128)..'x',infinite=math.huge,nan=0/0}
_test.cycle=_test
_test.shared={x=7};_test.sharedAgain=_test.shared
_test.mixed={[1]='number-key',['1']='string-key'}
_test.func=function() end
_test.array={1,true,'ok'}
_test.deep={};local p=_test.deep;for i=1,70 do p.child={};p=p.child end
''')
text,info=lua.eval('PortableJSON(_test,{error="native rejected input",fields={{field="nodes",error="bad encoding"}}})')
r=json.loads(text)
assert r['greeting']=='Привет 🌍'
assert r['controls']=='a\0\1\t\r\n"\\z'
assert r['invalid']=='���x'
assert r['infinite'] is None and r['nan'] is None and r['cycle'] is None
assert r['shared']==r['sharedAgain']=={'x':7}
assert set(r['mixed'].values())=={'number-key','string-key'}
assert r['array']==[1,True,'ok']
assert r['_jsonExport']['changedValues']
kinds={x['kind'] for x in r['_jsonExport']['issues']}
assert {'invalid_utf8','cycle','non_finite_number','depth_limit','unsupported_value','key_collision'}<=kinds
assert 'native rejected' in r['_jsonExport']['nativeError']
# The exact uploaded core source strings must survive portable serialization.
d=json.loads(Path('new_game_analysis/core_report.json').read_text())
def to_lua(x):
    if isinstance(x,dict):
        t=lua.table()
        for k,v in x.items():t[k]=to_lua(v)
        return t
    if isinstance(x,list):return lua.table_from([to_lua(v) for v in x])
    return x
encoded,meta=lua.globals().PortableJSON(to_lua(d),None,None)
out=json.loads(encoded)
assert out['_jsonExport']['normalizationCount']==0
assert len(out['records'])==87
for a,b in zip(d['records'],out['records']):
    assert a['path']==b['path'] and a.get('source')==b.get('source')
assert out['game']==d['game']
# Cancellation is checked through the supplied callback and not swallowed by the encoder.
lua.execute('_cancel=function() error("cancelled") end')
result=lua.eval('function() local ok,e=pcall(PortableJSON,{a=1},nil,_cancel); return ok,tostring(e) end')()
assert result[0] is False and 'cancelled' in result[1]
print('PASS: valid Unicode/control characters; malformed UTF-8 repair; NaN/Inf; cycles; shared data; depth; unsupported values; colliding keys; cancellation; exact preservation of all 87 uploaded source strings.')

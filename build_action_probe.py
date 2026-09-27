from pathlib import Path
import re
root=Path(__file__).parent
old=(root/'Debug_JSON_Fix_v1.4.lua').read_text()
# Standalone UI library slice only, like the other CAM builders.
lib=old[old.index('local Lumen = (function()'):old.index('-- Portable fallback exporter.')]
assert lib.rstrip().endswith('end)()'),lib[-200:]
lib=re.sub(r'\n\tLOAD:.*?\n\tSTRUCTURE:', '\n\tSTRUCTURE:',lib,flags=re.S)
lib=lib.replace('getgenv().Lumen','getgenv().CAMProbeLumen')
lib=lib.replace('Lumen.LibraryName = "NZL Studio"','Lumen.LibraryName = "CAM Probe"')
VERSION='1.1'
header=f'''-- CAM ACTION PROBE {VERSION} | targeted action recorder for feature research.
-- Passive: records game signals/UI/data while YOU perform one action by hand.
-- No gameplay requests, purchases or stat edits from this tool; STOP restores wraps.
-- Run AFTER unloading other CAM tools. RightShift: menu.
'''
text=header+lib+(root/'portable_json.lua').read_text()+'\n'+(root/'action_probe_logic.lua').read_text()
(root/f'CAM_Debug_ActionProbe_v{VERSION}.lua').write_text(text)
print('Built',len(text.encode()),'bytes')
from lupa import LuaRuntime
lua=LuaRuntime(unpack_returned_tuples=True)
f,e=lua.eval('function(s) local f,e=load(s); return f~=nil,e end')(text)
assert f,e
print('Standalone syntax PASS')

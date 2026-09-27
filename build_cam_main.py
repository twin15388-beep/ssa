from pathlib import Path
import re,json
root=Path(__file__).parent
lib=(root/'uploads'/'Текстовый документ (5).txt').read_text()
lib=lib.replace('\r\n','\n')
assert 'function Lumen:Window(data)' in lib and 'createwindow' not in lib.lower()[:0]
assert lib.rstrip().endswith('return Lumen')
lib=lib[:lib.rindex('return Lumen')]
# strip the embedded NZL demo/app block (watermark, keybind list, welcome toast, demo window)
i=lib.rindex('--#region example')
lib=lib[:i].rstrip()+'\n'
assert 'Watermark("NZL Studio"' not in lib
src=(root/'new_game_analysis/core_sources/036_BossHunts.lua').read_text()
bosses=set(re.findall(r'Code = "([^"]+)"',src))
report=json.loads((root/'new_game_analysis/overview_received.json').read_text())
for n in report['nodes']:
    if n['class']=='Model' and n['path'].startswith('ReplicatedStorage.Assets.Npcs.Bosses.') and n['path'].count('.')==4:
        bosses.add(n['name'])
VERSION='3.2.4'
header=f'''-- CAM MAIN HUB {VERSION} | New CAM game, NOT the old NZL game.
-- Place 136406881576517; catalog baseline 5354, removal bug captured on game version 5400.
-- Standalone: embedded Lumen UI, no loadstring/HTTP downloads.
-- All automation OFF. RightControl: menu. Unload: settings. Unload restores local edits.
-- Auto Level / Auto Farm connect native modules on explicit enable. Above position default.
-- Native actions/server acceptance are not live-tested here. Read the feature matrix.
'''
boss_code='local CAM_BOSS_NAMES = {\n'+''.join('    ['+json.dumps(x)+']=true,\n' for x in sorted(bosses))+'}\n'
(root/'cam_boss_names.lua').write_text(boss_code)
lib=lib.replace('getgenv().Lumen','getgenv().CAMMainLumen')
lib=lib.replace('Lumen.LibraryName = "NZL Studio"','Lumen.LibraryName = "CAM Main"')
lib=lib.replace('Lumen.LibraryName = "Lumen"','Lumen.LibraryName = "CAM Main"')
lib=lib.replace('Name = "NZL Studio",','Name = Lumen.LibraryName,')
text=header+lib+(root/'portable_json.lua').read_text()+'\n'+boss_code+(root/'cam_catalog.lua').read_text()+(root/'cam_main_logic.lua').read_text()
(root/f'CAM_Main_Hub_v{VERSION}.lua').write_text(text)
print('Built',len(text.encode()),'bytes;',len(bosses),'source-backed boss names')
from lupa import LuaRuntime
lua=LuaRuntime(unpack_returned_tuples=True)
f,e=lua.eval('function(s) local f,e=load(s); return f~=nil,e end')(text)
assert f,e
print('Standalone syntax PASS')

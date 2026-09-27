from pathlib import Path
import json,re
root=Path(__file__).parent
s=(root/'json_fix_logic.lua').read_text()
paths=[
'ReplicatedStorage.CAM.Client.Modules.GamePlay.Dialogue',
'ReplicatedStorage.Regions',
'ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests',
'ReplicatedStorage.QuestStates',
'ReplicatedStorage.CAM.Client.Modules.RecommendedQuest',
'ReplicatedStorage.CAM.Global.Subsets.Gameplay.ToolbarItemRestrictions',
'ReplicatedStorage.CAM.Global.Collectibles.ItemRequirements',
'ReplicatedStorage.CAM.Client.Modules.GamePlay.Dash_Handler',
'ReplicatedStorage.CAM.Global.Shop',
'ReplicatedStorage.CAM.Client.Components.Client.InputHandler',
'ReplicatedStorage.CAM.Client.Controllers.Skills_Provider',
'ReplicatedStorage.CAM.Client.Controllers.Skill_Controller',
]
a=s.index('    local focusPaths = {');b=s.index('    local function collectRoots',a)
s=s[:a]+'    local focusPaths = {\n'+''.join('        '+json.dumps(p)+',\n' for p in paths)+'    }\n'+s[b:]
old='''        elseif profile == "replicated" then
            add(service("ReplicatedStorage"))'''
new='''            for _,object in ipairs(state.extraFocusRoots or {}) do add(object) end
        elseif profile == "replicated" then
            add(service("ReplicatedStorage"))'''
assert old in s;s=s.replace(old,new,1)
s=s.replace('Universal Game Debug 1.4 (safe JSON fallback).','CAM OneClick Focused Debug 1.5.')
s=s.replace('notify((report.stats.incomplete and "Partial report" or "Report ready") .. ": " .. profile .. ". Open Export -> COPY REPORT.")','notify((report.stats.incomplete and "Partial scan" or "Scan ready") .. "; preparing automatic export...")')
s=s[:s.index('    Lumen.Folder = "nzl_game_debug"')]+(root/'oneclick_diagnostic_addon.lua').read_text()
(root/'oneclick_debug_logic.lua').write_text(s)
old=(root/'Debug_JSON_Fix_v1.4.lua').read_text()
lib=old[old.index('local Lumen = (function()'):old.index('-- Portable fallback exporter.')]
lib=re.sub(r'\n\tLOAD:.*?\n\tSTRUCTURE:','\n\tSTRUCTURE:',lib,flags=re.S)
# Isolate the UI singleton: loading debug must not unload CAM Main before its snapshot.
lib=lib.replace("getgenv().Lumen", "getgenv().CAMDebugLumen")
header='''-- CAM ONE CLICK DEBUG 1.5
-- Run the entire file. Press COLLECT + SAVE + COPY once.
-- Focused source collection + read-only runtime snapshot; no game module execution.
-- Automatically saves CAM_Debug_OneClick_*.json and attempts clipboard copy.
-- Keep CAM Main loaded for its diagnostic snapshot; automation should be stopped.
-- No attacks, remotes, hooks or HTTP upload. UTF-8-safe fallback exporter included.
'''
text=header+lib+(root/'portable_json.lua').read_text()+'\n'+s
(root/'CAM_Debug_OneClick_v1.5.lua').write_text(text)
print('Built',len(text.encode()),'bytes;',len(paths),'fixed roots + up to 30 runtime-discovered UI/client roots')
from lupa import LuaRuntime
lua=LuaRuntime(unpack_returned_tuples=True)
ok,err=lua.eval('function(s) local f,e=load(s);return f~=nil,e end')(text)
assert ok,err
print('Standalone syntax PASS')

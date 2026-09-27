from pathlib import Path
import re
root=Path(__file__).parent
s=(root/'oneclick_debug_logic.lua').read_text()
a=s.index('    local focusPaths = {');b=s.index('    local function collectRoots',a)
s=s[:a]+'''    local focusPaths = {
        "ReplicatedStorage.CAM.Global.gameSettings",
    }
'''+s[b:]
a=s.index('    local function discoverFocusedRoots()');b=s.index('    local function deliverText(text)',a)
s=s[:a]+'''    local function discoverFocusedRoots()
        local RS=game:GetService("ReplicatedStorage")
        local roots,diagnostics={},{paths={},errors={},kind="place Content folders (same lookup as Regions.find)"}
        -- Regions.find() searches direct RS Folder children with a Content child.
        -- Collect their actual data modules instead of re-reading the Regions loader.
        for _,folder in ipairs(RS:GetChildren()) do
            if folder:IsA("Folder") then
                local content=folder:FindFirstChild("Content")
                if content then
                    roots[#roots+1]=content
                    diagnostics.paths[#diagnostics.paths+1]=path(content)
                end
            end
        end
        diagnostics.requiredRootMissing=#roots==0
        if #roots==0 then diagnostics.errors[#diagnostics.errors+1]="No place Folder/Content is currently replicated" end
        return roots,diagnostics
    end
'''+s[b:]
s=s.replace('CAM Focused Debug OneClick 1.5','CAM World Content Debug OneClick 1.6')
s=s.replace('Missing quest/dialogue/region sources + passive diagnosis of non-working CAM Main','World Content data: quest definitions, NPC spawns, dialogue functions + passive local state')
s=s.replace('CAM_Debug_OneClick_','CAM_Debug_WorldContent_')
s=s.replace('CAM OneClick Focused Debug 1.5.','CAM World Content Debug 1.6.')
s=s.replace('CAM Debug | ONE CLICK','CAM Debug | WORLD CONTENT')
s=s.replace('Version="1.5"','Version="1.6"')
s=s.replace('everything needed for the main fix','quest definitions / NPC spawns')
s=s.replace('One click: focused sources + runtime + save + clipboard','One click: World Content + progression + save + clipboard')
s=s.replace('Dialogue, Regions, quest definitions and input/toolbar dependencies.','Collects actual place/Content data modules, not the 82 previous sources.')
s=s.replace('state.extraFocusRoots,state.focusDiscovery=discoverFocusedRoots()','state.extraFocusRoots,state.focusDiscovery=discoverFocusedRoots()')
s=s.replace('if report.focusDiscovery.limitReached then report.stats.incomplete=true;report.stats.focusDiscoveryIncomplete=true end','''if report.focusDiscovery.limitReached or report.focusDiscovery.requiredRootMissing then
                    report.stats.incomplete=true;report.stats.focusDiscoveryIncomplete=true
                    report.stats.sourceIncomplete=true
                end''')
needle='''                quests=compactTree(d and d:FindFirstChild("Quests"),350,5),'''
assert needle in s
s=s.replace(needle,needle+'''
                experience=compactTree(d and d:FindFirstChild("Exp"),30,3),
                race=compactTree(d and d:FindFirstChild("Race"),3,0),
                wen=compactTree(d and d:FindFirstChild("Wen"),3,0),
                powers=compactTree(d and d:FindFirstChild("Powers"),30,2),
                skillTree=compactTree(d and d:FindFirstChild("SkillTreeUnlockedList"),150,3),''')
(root/'world_content_debug_logic.lua').write_text(s)
base=(root/'CAM_Debug_OneClick_v1.5.lua').read_text()
prefix=base[:base.index('-- CAM OneClick Focused Debug 1.5.')]
prefix=prefix.replace('CAM ONE CLICK DEBUG 1.5','CAM WORLD CONTENT DEBUG 1.6').replace('CAM_Debug_OneClick_','CAM_Debug_WorldContent_')
text=prefix+s
(root/'CAM_Debug_WorldContent_v1.6.lua').write_text(text)
print('Built',len(text.encode()),'bytes')
from lupa import LuaRuntime
lua=LuaRuntime(unpack_returned_tuples=True)
ok,err=lua.eval('function(s) local f,e=load(s);return f~=nil,e end')(text)
assert ok,err
print('Syntax PASS')

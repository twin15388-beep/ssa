from pathlib import Path
import json,re
root=Path(__file__).parent
known={}
for name in ['core_sources','oneclick_sources','world_sources']:
    for row in json.loads((root/'new_game_analysis'/name/'manifest.json').read_text()):
        p=re.sub(r'^Players\.[^.]+\.', 'Players.<local>.',row['path'])
        known[p]=name+'/'+Path(row['file']).name
# Reference most recent World Content and native snapshots only; no unknown-version legacy text is assumed identical.
known_code='local CAM_KNOWN_MECHANICS_SOURCES = {\n'+''.join('['+json.dumps(p)+']='+json.dumps(v)+',\n' for p,v in sorted(known.items()))+'}\n'
(root/'cam_known_mechanics_sources.lua').write_text(known_code)
s=(root/'oneclick_debug_logic.lua').read_text()
s=s.replace('CAM OneClick Focused Debug 1.5.','CAM Mechanics Recorder OneClick 1.7.')
a=s.index('    local focusPaths = {');b=s.index('    local function collectRoots',a)
s=s[:a]+'    local focusPaths = {}\n'+s[b:]
s=s.replace('if profile == "core" then cfg.maxSources = 500 end','-- Source count is preset per mechanics pass, never user-configured.')
s=s.replace('local deadline = os.clock() + 5','local deadline = math.min(os.clock() + 5, state.sourceDeadline or math.huge)')
s=s.replace('    local function boundedSource(obj, useDecompile)\n', '''    local function boundedSource(obj, useDecompile)
        if state.sourceDeadline and os.clock()>=state.sourceDeadline then return nil,"source time budget exhausted" end
''')
s=s.replace('local childrenOk, children = pcall(function() return obj:GetChildren() end)', '''local childrenOk, children = true, {}
                        -- Roots are individually selected scripts. Never descend into their asset/UI trees here.''')
s=s.replace('sourceEligible = 0, sourceUniqueTexts = 0','sourceEligible = 0, sourceUniqueTexts = 0, sourceDeadlineSkipped = 0')
s=s.replace('elseif report.stats.sourceBytes >= MAX_SOURCE_BYTES then','''elseif state.sourceDeadline and os.clock()>=state.sourceDeadline then
                        target.record.sourceStatus="source time budget exhausted"
                        report.stats.sourceDeadlineSkipped=report.stats.sourceDeadlineSkipped+1
                    elseif report.stats.sourceBytes >= MAX_SOURCE_BYTES then''')
s=s.replace('or report.stats.sourceBytesLimitSkipped > 0 or report.stats.sourceFailures > 0','or report.stats.sourceBytesLimitSkipped > 0 or report.stats.sourceDeadlineSkipped > 0 or report.stats.sourceFailures > 0')
s=s.replace('if state.sourceTask then pcall(task.cancel, state.sourceTask) end\n    end','if state.sourceTask then pcall(task.cancel, state.sourceTask) end\n        if state.recorder and state.recorder.stop then state.recorder.stop() end\n    end',1)
s=s.replace('CAM Main v1.0 was not found in this executor environment','CAM Main was not found in this executor environment')
needle='                quests=compactTree(d and d:FindFirstChild("Quests"),350,5),'
s=s.replace(needle,needle+'''
                experience=compactTree(d and d:FindFirstChild("Exp"),30,3),
                race=compactTree(d and d:FindFirstChild("Race"),3,0),
                wen=compactTree(d and d:FindFirstChild("Wen"),3,0),
                powers=compactTree(d and d:FindFirstChild("Powers"),60,3),
                skillTree=compactTree(d and d:FindFirstChild("SkillTreeUnlockedList"),150,3),
                playerAttributes=LP:GetAttributes(),
                worldAttributes=workspace:GetAttributes(),''')
a=s.index('    local function discoverFocusedRoots()');b=s.index('    local function deliverText(text)',a)
s=s[:a]+(root/'mechanics_discovery.lua').read_text()+s[b:]
s=s.replace('CAM_Debug_OneClick_', 'CAM_Debug_Mechanics_')
a=s.index('    local function collectOneClick()')
s=s[:a]+(root/'mechanics_recording.lua').read_text()
s=known_code+s
(root/'mechanics_debug_logic.lua').write_text(s)
base=(root/'CAM_Debug_OneClick_v1.5.lua').read_text()
prefix=base[:base.index('-- CAM OneClick Focused Debug 1.5.')]
prefix=re.sub(r'^-- CAM ONE CLICK DEBUG 1.5.*?(?=local Lumen)', '''-- CAM MECHANICS RECORDER 1.7
-- One button: 90s passive recording + prioritized source collection + automatic JSON save/copy.
-- Keep CAM Main loaded; do not STOP it just to run this recorder. Its automation is not modified.
-- Repeat inside relevant modes; no automatic teleport persistence. No remote hooks/calls or stat writes.
-- Client-visible evidence only; no claim of server kill, infinite stamina or restored missing server scripts.
''',prefix,flags=re.S)
text=prefix+s
(root/'CAM_Debug_Mechanics_v1.7.lua').write_text(text)
print('Built',len(text.encode()),'bytes;',len(known),'known source references')
from lupa import LuaRuntime
lua=LuaRuntime(unpack_returned_tuples=True)
ok,err=lua.eval('function(s) local f,e=load(s);return f~=nil,e end')(text)
assert ok,err
print('Standalone syntax PASS')

from pathlib import Path
import json
paths=[
'ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent',
'ReplicatedStorage.Communication.ServerAndClient.Signals.SignalFunction',
'ReplicatedStorage.CAM.Global.Checker',
'ReplicatedStorage.CAM.Global.Combat_presets',
'ReplicatedStorage.CAM.Global.Utility',
'ReplicatedStorage.CAM.Global.Character_info_provider',
'ReplicatedStorage.CAM.Global.Collectibles.Items',
'ReplicatedStorage.CAM.Global.Skills_Module',
'ReplicatedStorage.CAM.Global.PlayerStatResolver',
'ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests',
'ReplicatedStorage.CAM.Global.Subsets.Gameplay.ManuelCancel',
'ReplicatedStorage.CAM.Client.Modules.RecommendedQuest',
'ReplicatedStorage.CAM.Client.Modules.GamePlay.Run_Handler',
'ReplicatedStorage.CAM.Client.Components.Client.InputHandler',
'ReplicatedStorage.CAM.Client.Components.Client.StaminaComponent',
'ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent',
'ReplicatedStorage.CAM.Client.Components.ProximityPrompt.ProximityPromptChooser',
'ReplicatedStorage.CAM.Client.Controllers.Skills_Provider',
'ReplicatedStorage.CAM.Client.Controllers.Skill_Controller',
'ReplicatedStorage.CAM.Client.Controllers.Platform_Handler',
'ReplicatedStorage.CAM.Client.Controllers.ChestController',
'ReplicatedStorage.CAM.Client.Controllers.LootDropController',
'ReplicatedStorage.CAM.Global.SkillService.Stats',
'ReplicatedStorage.CAM.Global.SkillService.GetMasteryStatus',
'ReplicatedStorage.CAM.Global.SkillService.SkillTreeholder',
]
s=Path('universal_debug_logic.lua').read_text()
def rep(a,b):
 global s
 assert a in s,a[:120]
 s=s.replace(a,b)
rep('Universal Game Debug 1.2.','Universal Game Debug 1.3 (focused core profile).')
rep('''    local function collectRoots(profile)
        local roots, used = {}, {}''','''    local focusPaths = {
'''+''.join('        '+json.dumps(x,ensure_ascii=False)+',\n' for x in paths)+'''    }
    local function collectRoots(profile)
        local roots, used, missing = {}, {}, {}''')
rep('''        if profile == "replicated" then
            add(service("ReplicatedStorage"))''','''        if profile == "core" then
            for _, fullPath in ipairs(focusPaths) do
                local obj = game
                local first = true
                for name in fullPath:gmatch("[^%.]+") do
                    if first then obj = service(name); first = false
                    else obj = obj and obj:FindFirstChild(name) end
                    if not obj then break end
                end
                if obj then add(obj) else missing[#missing + 1] = fullPath end
            end
        elseif profile == "replicated" then
            add(service("ReplicatedStorage"))''')
rep('''        return roots
    end
    local function scan''','''        return roots, missing
    end
    local function scan''')
rep('''profile == "replicated" or profile == "clients" or profile == "overview"''','''profile == "replicated" or profile == "clients" or profile == "overview" or profile == "core"''')
rep('''        local roots = collectRoots(profile)''','''        local roots, missingRoots = collectRoots(profile)''')
rep('''        if profile == "replicated" or profile == "clients" then''','''        if profile == "replicated" or profile == "clients" or profile == "core" then
            if profile == "core" then cfg.maxSources = 500 end''')
rep('''            settings.profile = profile''','''            settings.profile = profile
            if profile == "core" then
                settings.requestedRootPaths = table.clone(focusPaths)
                settings.missingRequestedRoots = table.clone(missingRoots)
            end''')
rep('''format = "NZL Game Debug 1.2"''','''format = "NZL Game Debug 1.3"''')
rep('''            report.stats.sourceIncomplete = settings.sources and (report.stats.sourceCountLimitSkipped > 0''','''            report.stats.missingRequestedRoots = #missingRoots
            report.stats.sourceIncomplete = settings.sources and (#missingRoots > 0 or report.stats.sourceCountLimitSkipped > 0''')
rep('''{ "overview", "replicated", "clients", "game" }''','''{ "core", "overview", "replicated", "clients", "game" }''')
rep('''NZL Game Debug Bundle 1.2''','''NZL Game Debug Bundle 1.3''')
rep('''Name = "Universal Game Debug", Version = "1.2"''','''Name = "Game Debug | core modules", Version = "1.3"''')
rep('''    controls:Button({ Name = "Game overview (no source)"''','''    controls:Button({ Name = "CORE dependencies + decompile", Callback = function() scan("core") end })
    controls:Label("CORE: 25 CAM / Communication roots, 500 scripts.")
    controls:Button({ Name = "Game overview (no source)"''')
rep('''{ "Latest", "Overview", "ReplicatedStorage", "Local client", "Game" }''','''{ "Latest", "Core", "Overview", "ReplicatedStorage", "Local client", "Game" }''')
rep('''({ Overview = "overview", ReplicatedStorage''','''({ Core = "core", Overview = "overview", ReplicatedStorage''')
rep('''Any game: Overview -> ReplicatedStorage -> Local client -> Export / COPY ALL SCANS. RightControl: menu.''','''New game: CORE dependencies -> Game overview -> Export / Save ALL scans. RightControl: menu.''')
Path('core_debug_logic.lua').write_text(s)
old=Path('Universal_Game_Debug.lua').read_text()
lib=old[old.index('local Lumen = (function()'):old.index('-- Universal Game Debug 1.2.')]
header='''-- GAME DEBUG 1.3 | Focused core dependencies for the supplied new-game dump.
-- Read-only: no gameplay remotes, no require of discovered modules, no HTTP uploads.
-- CORE scans 25 explicit CAM/Communication roots and their descendants, not all assets.
-- Then run Game overview (no source), Export -> Save ALL scans (.json).
-- Other universal scan profiles remain available. RightControl opens/closes the menu.
'''
Path('Debug_New_Game_Core.lua').write_text(header+lib+s)
print('Focused root count:',len(paths),'standalone bytes:',Path('Debug_New_Game_Core.lua').stat().st_size)
# Validate that the requested paths were actually present in the uploaded metadata.
r=json.loads(Path('new_game_analysis/report_1.json').read_text())['records']
index={x['path']:x for x in r}
for p in paths:print('KNOWN' if p in index else 'NOT IN METADATA',p)

from pathlib import Path
s=Path('collector.lua').read_text()
def replace(a,b):
 global s
 assert a in s,a[:120]
 s=s.replace(a,b)
replace('Game Debug Collector 1.0.', 'Game Debug Collector 1.1.')
replace('maxSources = 50 }','maxSources = 250 }')
replace('    local statusLabel, countLabel, lastExport','''    local statusLabel, countLabel, lastExport, exportSelector, exportFilterBox
    local sourceToggle, decompileToggle, sourceFilterBox, sourceCountSlider
    local exportKind, exportFilter = "Full report", ""
    local lastProfile = "game"
    local savedReports = {}''')
replace('''    local function scan()
        if state.busy then notify("Scan already running") return end
        state.busy, state.cancel = true, false
''','''    local function collectRoots(profile)
        local roots, used = {}, {}
        local function add(obj)
            if obj and not used[obj] then used[obj] = true roots[#roots + 1] = obj end
        end
        local function service(name)
            -- Do not enumerate internal engine services or create services just for a scan.
            return game:FindFirstChild(name)
        end
        if profile == "replicated" then
            add(service("ReplicatedStorage"))
        elseif profile == "clients" then
            -- Prefer actual local-player scripts over a second copy in StarterPlayer.
            local ps = LP:FindFirstChild("PlayerScripts")
            if ps then add(ps)
            else
                local sp = service("StarterPlayer")
                add(sp and sp:FindFirstChild("StarterPlayerScripts"))
            end
            add(LP:FindFirstChild("PlayerGui"))
            add(LP.Character)
            add(LP:FindFirstChild("Backpack"))
            add(service("ReplicatedFirst"))
        else
            -- Allowlist excludes CorePackages, CoreGui, Script Context and internal services.
            for _, name in ipairs({ "ReplicatedStorage", "ReplicatedFirst", "StarterPlayer", "StarterGui",
                "StarterPack", "Workspace", "Players", "Lighting", "SoundService", "Teams" }) do
                add(service(name))
            end
        end
        return roots
    end
    local function scan(profile)
        if state.busy then notify("Scan already running") return end
        profile = (profile == "replicated" or profile == "clients") and profile or "game"
        local roots = collectRoots(profile)
        if #roots == 0 then notify("No client-visible roots for this profile") return end
        if profile ~= "game" then
            -- Explicit source buttons opt in; no saved config silently enables extraction.
            cfg.sources, cfg.decompile, cfg.sourceFilter, cfg.maxSources = true, true, "", 250
            if sourceToggle then sourceToggle:Set(true, true) end
            if decompileToggle then decompileToggle:Set(true, true) end
            if sourceFilterBox then sourceFilterBox:Set("", true) end
            if sourceCountSlider then sourceCountSlider:Set(250, true) end
            exportKind, exportFilter = "Scripts", ""
            if exportSelector then exportSelector:Set(exportKind, true) end
            if exportFilterBox then exportFilterBox:Set("", true) end
            notify("Source preset: " .. profile .. ". Up to 250 scripts; no modules are executed.")
        end
        lastProfile = profile
        state.busy, state.cancel = true, false
''')
replace('''            local settings = captureSettings()
            local report = {''','''            local settings = captureSettings()
            settings.profile = profile
            settings.excluded = { "CorePackages", "CoreGui", "RobloxReplicatedStorage", "engine-internal services", "collector UI" }
            settings.maxSourceBytes = MAX_SOURCE_BYTES
            settings.maxBytesPerSource = 160000
            settings.attemptTimeoutSeconds = 5
            local report = {''')
replace('format = "NZL Game Debug 1.0"','format = "NZL Game Debug 1.1"')
replace('''                models = {}, classCounts = {}, errors = {}, stats = {}, logs = {},''','''                models = {}, classCounts = {}, errors = {},
                stats = { sourceAttempts = 0, sourceCountLimitSkipped = 0, sourceBytesLimitSkipped = 0,
                    sourceFailures = 0, sourceTimeouts = 0, sourcesCancelled = 0, sourceTruncatedCount = 0,
                    sourceEligible = 0, sourceUniqueTexts = 0 }, logs = {},''')
replace('''            local targets, metadataBytes = {}, 0''','''            local targets, metadataBytes, sourceTexts = {}, 0, {}''')
replace('''                for _, root in ipairs(game:GetChildren()) do
                    -- CoreGui may include unrelated private UI; deliberately excluded.
                    if root.ClassName ~= "CoreGui" then
                        queue[#queue + 1] = { object = root, parent = 0, depth = 0 }
                        report.roots[#report.roots + 1] = { name = root.Name, class = root.ClassName }
                    end
                end''','''                for _, root in ipairs(roots) do
                    queue[#queue + 1] = { object = root, parent = 0, depth = 0 }
                    report.roots[#report.roots + 1] = { name = root.Name, class = root.ClassName, path = path(root) }
                end''')
replace('''                                if #targets < settings.maxSources then targets[#targets + 1] = { object = obj, record = record }
                                else record.sourceStatus = "source count limit" end''','''                                report.stats.sourceEligible = report.stats.sourceEligible + 1
                                if #targets < settings.maxSources then
                                    record.sourceStatus = "pending"
                                    targets[#targets + 1] = { object = obj, record = record }
                                else
                                    record.sourceStatus = "source count limit"
                                    report.stats.sourceCountLimitSkipped = report.stats.sourceCountLimitSkipped + 1
                                end''')
replace('''                    if state.cancel or not state.alive then target.record.sourceStatus = "cancelled"
                    elseif report.stats.sourceBytes >= MAX_SOURCE_BYTES then target.record.sourceStatus = "total source size limit"
                    else
                        status(''','''                    if state.cancel or not state.alive then
                        target.record.sourceStatus = "cancelled"
                        report.stats.sourcesCancelled = report.stats.sourcesCancelled + 1
                    elseif report.stats.sourceBytes >= MAX_SOURCE_BYTES then
                        target.record.sourceStatus = "total source size limit"
                        report.stats.sourceBytesLimitSkipped = report.stats.sourceBytesLimitSkipped + 1
                    else
                        report.stats.sourceAttempts = report.stats.sourceAttempts + 1
                        status(''')
replace('''                        if source then
                            local maxBytes''','''                        if source then
                            if not sourceTexts[source] then
                                sourceTexts[source] = true
                                report.stats.sourceUniqueTexts = report.stats.sourceUniqueTexts + 1
                            end
                            local maxBytes''')
replace('''                            target.record.sourceTruncated = #source > maxBytes''','''                            target.record.sourceTruncated = #source > maxBytes
                            if target.record.sourceTruncated then report.stats.sourceTruncatedCount = report.stats.sourceTruncatedCount + 1 end''')
replace('''                        else target.record.sourceStatus = failure or "unavailable" end''','''                        else
                            target.record.sourceStatus = failure or "unavailable"
                            if state.cancel or not state.alive then
                                report.stats.sourcesCancelled = report.stats.sourcesCancelled + 1
                            else
                                report.stats.sourceFailures = report.stats.sourceFailures + 1
                                if tostring(failure):find("timeout", 1, true) then report.stats.sourceTimeouts = report.stats.sourceTimeouts + 1 end
                            end
                            if settings.decompile and type(decompiler) ~= "function" then
                                target.record.sourceStatus = target.record.sourceStatus .. "; decompile API unavailable"
                            end
                        end''')
replace('''            report.stats.incomplete = not report.stats.completed or report.stats.queueLimitReached == true or report.stats.metadataLimitReached == true
            report.logs = table.clone(state.logs)
            state.busy = false''','''            report.stats.nodes, report.stats.remotes, report.stats.scripts = #report.nodes, #report.remotes, #report.scripts
            report.stats.treeIncomplete = not report.stats.completed or report.stats.queueLimitReached == true or report.stats.metadataLimitReached == true
            report.stats.sourcesPending = 0
            for _, record in ipairs(report.scripts) do
                if record.sourceStatus == "pending" then report.stats.sourcesPending = report.stats.sourcesPending + 1 end
            end
            report.stats.sourceIncomplete = settings.sources and (report.stats.sourceCountLimitSkipped > 0
                or report.stats.sourceBytesLimitSkipped > 0 or report.stats.sourceFailures > 0
                or report.stats.sourcesCancelled > 0 or report.stats.sourceTruncatedCount > 0 or report.stats.sourcesPending > 0) or false
            report.stats.incomplete = report.stats.treeIncomplete or report.stats.sourceIncomplete
            report.logs = table.clone(state.logs)
            savedReports[profile] = report
            state.busy = false''')
replace('''                notify("Report ready. Open Export. Limits/errors are listed in the report.")''','''                notify((report.stats.incomplete and "Partial report" or "Report ready") .. ": " .. profile .. ". Open Export -> COPY REPORT.")''')
replace('''    local exportKind, exportFilter = "Full report", ""
    local function selectReport()''','''    local function selectReport()''')
replace('''        if exportKind == "Logs" then return { format = r.format, logs = r.logs } end''','''        if exportKind == "Logs" then return { format = r.format, createdUTC = r.createdUTC, game = r.game, settings = r.settings, stats = r.stats, logs = r.logs } end''')
replace('''        return { format = r.format, game = r.game, stats = r.stats, limitations = r.limitations, section = exportKind, filter = exportFilter, records = records }''','''        return { format = r.format, createdUTC = r.createdUTC, game = r.game, stats = r.stats, settings = r.settings,
            capabilities = r.capabilities, roots = r.roots, errors = r.errors, limitations = r.limitations,
            section = exportKind, filter = exportFilter, records = records }''')
replace('''local filename = "GameDebug_" .. game.PlaceId .. "_" .. os.date("!%Y%m%d_%H%M%S") .. "_" .. exportKind:gsub("%W", "_") .. ".json"''','''local filename = "GameDebug_" .. game.PlaceId .. "_" .. (state.report.settings.profile or "game") .. "_" .. os.date("!%Y%m%d_%H%M%S") .. "_" .. exportKind:gsub("%W", "_") .. ".json"''')
replace('Version = "1.0", Footer', 'Version = "1.1", Footer')
replace('''    controls:Button({ Name = "Scan game", Callback = scan })''','''    controls:Button({ Name = "Scan game (manual settings)", Callback = function() scan("game") end })
    controls:Button({ Name = "ReplicatedStorage + decompile", Callback = function() scan("replicated") end })
    controls:Button({ Name = "Local client scripts + decompile", Callback = function() scan("clients") end })''')
replace('''    controls:Button({ Name = "Cancel (keep partial report)", Callback = function() state.cancel = true status("Cancelling...") end })''','''    controls:Button({ Name = "Cancel (keep partial report)", Callback = function()
        if not state.busy then notify("No scan is running") return end
        state.cancel = true status("Cancelling...")
    end })''')
replace('''    controls:Label("CoreGui and collector UI are excluded.")''','''    controls:Label("CorePackages / CoreGui / engine roots excluded.")
    controls:Label("Source presets reset filter and use 250 scripts.")''')
replace('''    sourceSec:Toggle({ Name = "Read available source"''','''    sourceToggle = sourceSec:Toggle({ Name = "Read available source"''')
replace('''    sourceSec:Toggle({ Name = "Try executor decompile fallback"''','''    decompileToggle = sourceSec:Toggle({ Name = "Try executor decompile fallback"''')
replace('''    sourceSec:Textbox({ Name = "Source path contains (optional)"''','''    sourceFilterBox = sourceSec:Textbox({ Name = "Source path contains (optional)"''')
replace('''    sourceSec:Slider({ Name = "Max source scripts", Min = 1, Max = 250, Default = 50''','''    sourceCountSlider = sourceSec:Slider({ Name = "Max source scripts", Min = 1, Max = 500, Default = 250''')
replace('''    exportSec:Dropdown({ Name = "Section"''','''    exportSelector = exportSec:Dropdown({ Name = "Section"''')
replace('''    exportSec:Textbox({ Name = "Export path filter"''','''    exportFilterBox = exportSec:Textbox({ Name = "Export path filter"''')
replace('''    exportSec:Label("Filter applies to sections, not Full / Logs.")''','''    exportSec:Label("Filter applies to sections, not Full / Logs.")
    exportSec:Dropdown({ Name = "Saved scan", Items = { "Latest", "ReplicatedStorage", "Local client", "Game" }, Default = "Latest", Flag = "dbg_saved_scan", Callback = function(v)
        if state.busy then notify("Wait for scan to finish") return end
        local key = ({ ReplicatedStorage = "replicated", ["Local client"] = "clients", Game = "game", Latest = lastProfile })[v]
        local r = savedReports[key]
        if not r then notify("No saved scan for " .. tostring(v)) return end
        state.report = r
        notify("Selected report: " .. r.settings.profile)
    end })''')
replace('''    notes:Label("Reports stay local. No upload is performed.")''','''    notes:Label("Presets select Scripts export automatically.")
    notes:Label("Latest scan per profile is kept in memory.")
    notes:Label("Reports stay local. No upload is performed.")''')
replace('''    notify("Ready. Scan game -> Export -> COPY REPORT. Menu: RightControl.")''','''    notify("Ready. Choose a source preset -> Export -> COPY REPORT. Menu: RightControl.")''')
Path('collector_v1_1.lua').write_text(s)
old=Path('Game_Debug_Collector.lua').read_text()
lib=old[:old.index('-- Game Debug Collector 1.0.')]
lib=lib.replace('GAME DEBUG COLLECTOR 1.0','GAME DEBUG COLLECTOR 1.1').replace('-- RightControl: show/hide. Scan -> Export -> COPY REPORT.', '-- RightControl: show/hide. Source preset -> Export -> COPY REPORT.\n-- Game roots only: CorePackages / CoreGui / internal engine services excluded.')
Path('Game_Debug_Collector_v1.1.lua').write_text(lib+s)
print('Written standalone v1.1:',len((lib+s).encode()),'bytes')

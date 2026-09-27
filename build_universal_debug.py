from pathlib import Path
s=Path('collector_v1_1.lua').read_text()
def rep(a,b):
 global s
 assert a in s,a[:100]
 s=s.replace(a,b)
rep('Game Debug Collector 1.1.','Universal Game Debug 1.2.')
rep('''        local function service(name)
            -- Do not enumerate internal engine services or create services just for a scan.
            return game:FindFirstChild(name)
        end''','''        local function service(name)
            -- Only allowlisted public game services; tolerate a renamed service instance.
            local ok, found = pcall(function() return game:GetService(name) end)
            return (ok and found) or game:FindFirstChild(name)
        end''')
rep('''profile = (profile == "replicated" or profile == "clients") and profile or "game"''','''profile = (profile == "replicated" or profile == "clients" or profile == "overview") and profile or "game"''')
rep('''        if profile ~= "game" then''','''        if profile == "replicated" or profile == "clients" then''')
rep('''cfg.sources, cfg.decompile, cfg.sourceFilter, cfg.maxSources = true, true, "", 250''','''cfg.sources, cfg.decompile, cfg.sourceFilter = true, true, ""''')
rep('''sourceCountSlider:Set(250, true)''','''sourceCountSlider:Set(cfg.maxSources, true)''')
rep('''            notify("Source preset: " .. profile .. ". Up to 250 scripts; no modules are executed.")
        end''','''            notify("Source preset: " .. profile .. ". Up to " .. cfg.maxSources .. " scripts; no modules are executed.")
        elseif profile == "overview" then
            exportKind, exportFilter = "Full report", ""
            if exportSelector then exportSelector:Set(exportKind, true) end
            if exportFilterBox then exportFilterBox:Set("", true) end
        end''')
rep('''            settings.profile = profile''','''            settings.profile = profile
            if profile == "overview" then settings.sources, settings.decompile, settings.sourceFilter = false, false, "" end''')
rep('''format = "NZL Game Debug 1.1"''','''format = "NZL Game Debug 1.2"''')
rep('''sourceFailures = 0, sourceTimeouts = 0, sourcesCancelled = 0, sourceTruncatedCount = 0,''','''sourceFailures = 0, sourceTimeouts = 0, sourceDiagnosticErrors = 0, sourceWarnings = 0,
                    sourcesCancelled = 0, sourceTruncatedCount = 0,''')
rep('''    local function captureSettings()''','''    local function inspectDecompiled(text)
        -- Heuristic only: an error-only comment stub is not a recovered script.
        -- An error marker alongside code is retained as a warning, not discarded.
        local hasCode, diagnostic, blockEnd = false, nil, nil
        for line in (text .. "\\n"):gmatch("([^\\n]*)\\n") do
            local t = line:match("^%s*(.-)%s*$") or ""
            local comment = false
            if blockEnd then
                comment = true
                local pos = t:find(blockEnd, 1, true)
                if pos then
                    local tail = t:sub(pos + #blockEnd)
                    blockEnd = nil
                    if tail:match("%S") and not tail:match("^%s*%-%-") then hasCode = true end
                end
            elseif t:sub(1,2) == "--" then
                comment = true
                local eq = t:match("^%-%-%[(=*)%[")
                if eq ~= nil then
                    local close = "]" .. eq .. "]"
                    local pos = t:find(close, 5 + #eq, true)
                    if not pos then blockEnd = close
                    else
                        local tail = t:sub(pos + #close)
                        if tail:match("%S") and not tail:match("^%s*%-%-") then hasCode = true end
                    end
                end
            elseif t ~= "" then hasCode = true end
            if comment then
                local body = t:gsub("^%-%-%s*", ""):lower()
                if body:match("^error%s*:") or body:find("decompilation failed",1,true)
                    or body:find("failed to decompile",1,true) then diagnostic = diagnostic or str(t,1000) end
            end
        end
        if diagnostic then return not hasCode, diagnostic end
        return false, nil
    end
    local function captureSettings()''')
rep('''                        if source then
                            if not sourceTexts[source] then''','''                        if source and method == "decompile (unverified output)" then
                            local errorOnly, diagnostic = inspectDecompiled(source)
                            if errorOnly then
                                target.record.decompilerDiagnostic = prefix(source,4000)
                                target.record.decompilerDiagnosticTruncated = #source > 4000
                                target.record.sourceErrorKind = "decompiler_diagnostic_only"
                                report.stats.sourceDiagnosticErrors = report.stats.sourceDiagnosticErrors + 1
                                failure = "decompiler returned error text instead of source"
                                source = nil
                            elseif diagnostic then
                                target.record.sourceWarning = diagnostic
                                report.stats.sourceWarnings = report.stats.sourceWarnings + 1
                            end
                        end
                        if source then
                            if not sourceTexts[source] then''')
# Bundle all cached scans as a single valid JSON, avoiding concatenation of JSON objects.
rep('''    local function copy()
        local text = encodeReport()''','''    local function encodeBundle()
        if state.busy then notify("Wait for scan completion or cancel first") return end
        local reports = {}
        for _, key in ipairs({ "overview", "replicated", "clients", "game" }) do
            if savedReports[key] then reports[#reports + 1] = savedReports[key] end
        end
        if #reports == 0 then notify("Run at least one scan first") return end
        local ok, text = pcall(function()
            return Http:JSONEncode({ format = "NZL Game Debug Bundle 1.2", exportType = "bundle",
                createdUTC = os.date("!%Y-%m-%dT%H:%M:%SZ"), reportCount = #reports,
                reports = reports, logsAtExport = table.clone(state.logs),
                note = "Full cached scans, ignoring export filters. Client-visible data only; review before sharing." })
        end)
        if not ok then notify("Bundle JSON error: " .. str(text,150)) return end
        return text
    end
    local function copy(bundle)
        local text = bundle and encodeBundle() or encodeReport()''')
# No fallback to a single report if bundle encoding failed.
rep('''        local text = bundle and encodeBundle() or encodeReport()''','''        local text
        if bundle then text = encodeBundle() else text = encodeReport() end''')
rep('''    local function save()
        local text = encodeReport()''','''    local function save(bundle)
        local text
        if bundle then text = encodeBundle() else text = encodeReport() end''')
rep('''        local filename = "GameDebug_" .. game.PlaceId .. "_" .. (state.report.settings.profile or "game") .. "_" .. os.date("!%Y%m%d_%H%M%S") .. "_" .. exportKind:gsub("%W", "_") .. ".json"''','''        local label = bundle and "ALL_SCANS" or ((state.report.settings.profile or "game") .. "_" .. exportKind:gsub("%W", "_"))
        local filename = "GameDebug_" .. game.PlaceId .. "_" .. label .. "_" .. os.date("!%Y%m%d_%H%M%S") .. ".json"''')
rep('''Name = "Game Debug Collector", Version = "1.1", Footer = "Read-only | client-visible data"''','''Name = "Universal Game Debug", Version = "1.2", Footer = "Place " .. tostring(game.PlaceId) .. " | client-visible only"''')
rep('''    controls:Button({ Name = "Scan game (manual settings)"''','''    controls:Button({ Name = "Game overview (no source)", Callback = function() scan("overview") end })
    controls:Button({ Name = "Scan game (manual settings)"''')
rep('''Source presets reset filter and use 250 scripts.''','''Presets reset filter; Max source scripts is respected.''')
rep('''Items = { "Latest", "ReplicatedStorage", "Local client", "Game" }''','''Items = { "Latest", "Overview", "ReplicatedStorage", "Local client", "Game" }''')
rep('''({ ReplicatedStorage = "replicated", ["Local client"] = "clients", Game = "game", Latest = lastProfile })''','''({ Overview = "overview", ReplicatedStorage = "replicated", ["Local client"] = "clients", Game = "game", Latest = lastProfile })''')
rep('''exportSec:Button({ Name = "COPY REPORT", Callback = copy })''','''exportSec:Button({ Name = "COPY REPORT", Callback = function() copy(false) end })''')
rep('''exportSec:Button({ Name = "Save report (.json)", Callback = save })''','''exportSec:Button({ Name = "Save report (.json)", Callback = function() save(false) end })''')
rep('''    local notes = exports:Section({ Name = "important", Side = 2 })''','''    local bundleSec = exports:Section({ Name = "all scans in ONE JSON", Side = 2 })
    bundleSec:Button({ Name = "COPY ALL SCANS", Callback = function() copy(true) end })
    bundleSec:Button({ Name = "Save ALL scans (.json)", Callback = function() save(true) end })
    bundleSec:Label("Combines completed/partial cached scans.")
    bundleSec:Label("Ignores Section and Export path filter.")
    local notes = exports:Section({ Name = "important", Side = 2 })''')
rep('''    notes:Label("Use stats/errors to check partial results.")''','''    notes:Label("Error-only decompiler stubs are marked failed.")
    notes:Label("Text is not syntax-checked or executed.")
    notes:Label("Use stats/errors to check partial results.")''')
rep('''Ready. Choose a source preset -> Export -> COPY REPORT. Menu: RightControl.''','''Any game: Overview -> ReplicatedStorage -> Local client -> Export / COPY ALL SCANS. RightControl: menu.''')
Path('universal_debug_logic.lua').write_text(s)
old=Path('Game_Debug_Collector_v1.1.lua').read_text()
lib=old[old.index('local Lumen = (function()'):old.index('-- Game Debug Collector 1.1.')]
header='''-- UNIVERSAL GAME DEBUG 1.2 | Standalone Lumen UI
-- No PlaceId restriction, game-specific remotes, hooks, or network uploads.
-- Read-only client inspection; source extraction is opt-in.
-- Server-only source is unavailable; decompilation is not guaranteed deobfuscation.
-- Scan: Overview -> ReplicatedStorage -> Local client. Export: COPY ALL SCANS.
'''
Path('Universal_Game_Debug.lua').write_text(header+lib+s)
print('Created',Path('Universal_Game_Debug.lua').stat().st_size,'bytes')

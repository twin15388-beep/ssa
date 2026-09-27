-- Universal Game Debug 1.4 (safe JSON fallback). Read-only inspection; no remote calls or require().
local function RunCollector(Lumen)
    local env = (getgenv and getgenv()) or _G
    if env.NZLGameDebug and env.NZLGameDebug.Stop then
        pcall(env.NZLGameDebug.Stop)
    end
    local Players = game:GetService("Players")
    local Http = game:GetService("HttpService")
    local Logs = game:GetService("LogService")
    local Tags = game:GetService("CollectionService")
    local LP = Players.LocalPlayer
    assert(LP, "Run on the client (LocalScript / client executor)")

    local cfg = { maxNodes = 20000, sources = false, decompile = false, sourceFilter = "", maxSources = 250 }
    local state = { alive = true, busy = false, exporting = false, cancelExport = false, cancel = false, logs = {}, report = nil, connections = {}, sourceTask = nil }
    local clipboard = setclipboard or toclipboard or (Clipboard and Clipboard.set)
    local decompiler = decompile
    local fileWriter = writefile
    local MAX_TEXT = 12000000
    local MAX_SOURCE_BYTES = 4000000
    local statusLabel, countLabel, lastExport, exportSelector, exportFilterBox, savedSelector, reportLabel
    local sourceToggle, decompileToggle, sourceFilterBox, sourceCountSlider
    local exportKind, exportFilter = "Full report", ""
    local lastProfile = "game"
    local savedReports = {}
    local function prefix(s, n)
        if #s <= n then return s end
        -- Avoid splitting a UTF-8 codepoint at byte-limited boundaries.
        while n > 0 do
            local b = s:byte(n + 1)
            if not b or b < 128 or b >= 192 then break end
            n = n - 1
        end
        return s:sub(1, n)
    end
    local function str(x, limit)
        local s = tostring(x)
        local n = limit or 1500
        if #s > n then return prefix(s, n) .. " ... [truncated]" end
        return s
    end
    local function path(obj)
        local ok, result = pcall(function() return obj:GetFullName() end)
        return ok and result or "<unavailable>"
    end
    local function value(x)
        local t = typeof(x)
        if t == "Instance" then return { type = t, path = path(x) } end
        if t == "number" then
            if x ~= x or x == math.huge or x == -math.huge then return tostring(x) end
            return x
        end
        if t == "boolean" then return x end
        if t == "string" then return str(x, 2000) end
        return str(x)
    end
    local function notify(text)
        if state.alive then
            pcall(function() Lumen:Notification({ Name = "Game Debug", Description = text, Duration = 5 }) end)
        end
    end
    local function status(text)
        if state.alive and statusLabel then pcall(function() statusLabel:SetText(text) end) end
    end
    local function pushLog(message, kind, origin)
        if not state.alive then return end
        state.logs[#state.logs + 1] = { time = os.date("!%Y-%m-%dT%H:%M:%SZ"), kind = str(kind), origin = origin, message = str(message, 3000) }
        if #state.logs > 200 then table.remove(state.logs, 1) end
    end
    pcall(function()
        local history = Logs:GetLogHistory()
        for i = math.max(1, #history - 99), #history do
            local item = history[i]
            state.logs[#state.logs + 1] = { time = tostring(item.timestamp), kind = tostring(item.messageType), origin = "history", message = str(item.message, 3000) }
        end
    end)
    state.connections[#state.connections + 1] = Logs.MessageOut:Connect(function(message, kind)
        pushLog(message, kind, "MessageOut")
    end)
    pcall(function()
        state.connections[#state.connections + 1] = game:GetService("ScriptContext").Error:Connect(function(message, stack, scriptObject)
            pushLog(str(message, 2000) .. "\n" .. str(stack, 4000) .. "\nScript: " .. (scriptObject and path(scriptObject) or "unknown"), "Error", "ScriptContext")
        end)
    end)

    local function stop()
        state.alive, state.cancel = false, true
        for _, connection in ipairs(state.connections) do pcall(function() connection:Disconnect() end) end
        if state.sourceTask then pcall(task.cancel, state.sourceTask) end
    end
    env.NZLGameDebug = { Stop = stop }
    local originalUnload = Lumen.Unload
    function Lumen:Unload()
        stop()
        return originalUnload(self)
    end

    local function properties(obj, keys)
        local out = {}
        for _, key in ipairs(keys) do
            local ok, result = pcall(function() return obj[key] end)
            if ok and result ~= nil then out[key] = value(result) end
        end
        return out
    end
    local function boundedSource(obj, useDecompile)
        local finished, result, failure = false, nil, nil
        local active = true
        local thread = task.spawn(function()
            local ok, source = pcall(function()
                if useDecompile then return decompiler(obj) end
                return obj.Source
            end)
            if not active then return end
            if ok and type(source) == "string" and source ~= "" then result = source
            else failure = ok and "empty source" or str(source, 500) end
            finished = true
        end)
        state.sourceTask = thread
        local deadline = os.clock() + 5
        while not finished and state.alive and not state.cancel and os.clock() < deadline do task.wait(0.05) end
        active = false
        if not finished then
            pcall(task.cancel, thread)
            failure = state.cancel and "cancelled" or "timeout (5s; cancellation is best-effort)"
        end
        state.sourceTask = nil
        return result, failure
    end
    local function inspectDecompiled(text)
        -- Heuristic only: an error-only comment stub is not a recovered script.
        -- An error marker alongside code is retained as a warning, not discarded.
        local hasCode, diagnostic, blockEnd = false, nil, nil
        for line in (text .. "\n"):gmatch("([^\n]*)\n") do
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
    local function captureSettings()
        return { maxNodes = cfg.maxNodes, sources = cfg.sources, decompile = cfg.decompile,
            sourceFilter = cfg.sourceFilter, maxSources = cfg.maxSources }
    end
    local focusPaths = {
        "ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent",
        "ReplicatedStorage.Communication.ServerAndClient.Signals.SignalFunction",
        "ReplicatedStorage.CAM.Global.Checker",
        "ReplicatedStorage.CAM.Global.Combat_presets",
        "ReplicatedStorage.CAM.Global.Utility",
        "ReplicatedStorage.CAM.Global.Character_info_provider",
        "ReplicatedStorage.CAM.Global.Collectibles.Items",
        "ReplicatedStorage.CAM.Global.Skills_Module",
        "ReplicatedStorage.CAM.Global.PlayerStatResolver",
        "ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests",
        "ReplicatedStorage.CAM.Global.Subsets.Gameplay.ManuelCancel",
        "ReplicatedStorage.CAM.Client.Modules.RecommendedQuest",
        "ReplicatedStorage.CAM.Client.Modules.GamePlay.Run_Handler",
        "ReplicatedStorage.CAM.Client.Components.Client.InputHandler",
        "ReplicatedStorage.CAM.Client.Components.Client.StaminaComponent",
        "ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent",
        "ReplicatedStorage.CAM.Client.Components.ProximityPrompt.ProximityPromptChooser",
        "ReplicatedStorage.CAM.Client.Controllers.Skills_Provider",
        "ReplicatedStorage.CAM.Client.Controllers.Skill_Controller",
        "ReplicatedStorage.CAM.Client.Controllers.Platform_Handler",
        "ReplicatedStorage.CAM.Client.Controllers.ChestController",
        "ReplicatedStorage.CAM.Client.Controllers.LootDropController",
        "ReplicatedStorage.CAM.Global.SkillService.Stats",
        "ReplicatedStorage.CAM.Global.SkillService.GetMasteryStatus",
        "ReplicatedStorage.CAM.Global.SkillService.SkillTreeholder",
    }
    local function collectRoots(profile)
        local roots, used, missing = {}, {}, {}
        local function add(obj)
            if obj and not used[obj] then used[obj] = true roots[#roots + 1] = obj end
        end
        local function service(name)
            -- Only allowlisted public game services; tolerate a renamed service instance.
            local found = game:FindFirstChild(name)
            if found then return found end
            local ok, serviceObject = pcall(function() return game:GetService(name) end)
            return ok and serviceObject or nil
        end
        if profile == "core" then
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
        return roots, missing
    end
    local function scan(profile)
        if state.busy or state.exporting then notify("Wait for the current scan/export") return end
        profile = (profile == "replicated" or profile == "clients" or profile == "overview" or profile == "core") and profile or "game"
        local roots, missingRoots = collectRoots(profile)
        if #roots == 0 then notify("No client-visible roots for this profile") return end
        if profile == "replicated" or profile == "clients" or profile == "core" then
            if profile == "core" then cfg.maxSources = 500 end
            -- Explicit source buttons opt in; no saved config silently enables extraction.
            cfg.sources, cfg.decompile, cfg.sourceFilter = true, true, ""
            if sourceToggle then sourceToggle:Set(true, true) end
            if decompileToggle then decompileToggle:Set(true, true) end
            if sourceFilterBox then sourceFilterBox:Set("", true) end
            if sourceCountSlider then sourceCountSlider:Set(cfg.maxSources, true) end
            exportKind, exportFilter = "Scripts", ""
            if exportSelector then exportSelector:Set(exportKind, true) end
            if exportFilterBox then exportFilterBox:Set("", true) end
            notify("Source preset: " .. profile .. ". Up to " .. cfg.maxSources .. " scripts; no modules are executed.")
        elseif profile == "overview" then
            exportKind, exportFilter = "Full report", ""
            if exportSelector then exportSelector:Set(exportKind, true) end
            if exportFilterBox then exportFilterBox:Set("", true) end
        end
        lastProfile = profile
        if savedSelector then savedSelector:Set("Latest", true) end
        state.busy, state.cancel = true, false
        task.spawn(function()
            local started = os.clock()
            local settings = captureSettings()
            settings.profile = profile
            if profile == "core" then
                settings.requestedRootPaths = table.clone(focusPaths)
                settings.missingRequestedRoots = table.clone(missingRoots)
            end
            if profile == "overview" then settings.sources, settings.decompile, settings.sourceFilter = false, false, "" end
            settings.excluded = { "CorePackages", "CoreGui", "RobloxReplicatedStorage", "engine-internal services", "collector UI" }
            settings.maxSourceBytes = MAX_SOURCE_BYTES
            settings.maxBytesPerSource = 160000
            settings.attemptTimeoutSeconds = 5
            local report = {
                format = "NZL Game Debug 1.4", createdUTC = os.date("!%Y-%m-%dT%H:%M:%SZ"),
                scope = "Client-visible instances only. No require(), remote calls, HTTP upload or interception.",
                limitations = {
                    "Server-only scripts, ServerStorage and ServerScriptService contents are not replicated.",
                    "StreamingEnabled, permissions and scan limits can make this report incomplete.",
                    "Remote metadata does not reveal arguments, server handlers or protocol semantics.",
                    "Decompiler output is not original source or guaranteed deobfuscation; output may be invalid.",
                    "Paths are descriptive; names containing dots or duplicate names can be ambiguous. Use node IDs.",
                    "Logs and source may contain private data. Review before sharing."
                },
                game = { placeId = game.PlaceId, universeId = game.GameId, placeVersion = game.PlaceVersion,
                    loaded = game:IsLoaded(), workspace = properties(workspace, { "StreamingEnabled", "Gravity", "DistributedGameTime" }) },
                capabilities = { clipboard = type(clipboard) == "function", writefile = type(fileWriter) == "function", decompile = type(decompiler) == "function" },
                settings = settings, roots = {}, nodes = {}, remotes = {}, scripts = {}, interactives = {},
                models = {}, classCounts = {}, errors = {},
                stats = { sourceAttempts = 0, sourceCountLimitSkipped = 0, sourceBytesLimitSkipped = 0,
                    sourceFailures = 0, sourceTimeouts = 0, sourceDiagnosticErrors = 0, sourceWarnings = 0,
                    sourcesCancelled = 0, sourceTruncatedCount = 0,
                    sourceEligible = 0, sourceUniqueTexts = 0 }, logs = {},
            }
            state.report = report
            local targets, metadataBytes, sourceTexts = {}, 0, {}
            local ok, err = xpcall(function()
                local queue, head, seen = {}, 1, {}
                for _, root in ipairs(roots) do
                    queue[#queue + 1] = { object = root, parent = 0, depth = 0 }
                    report.roots[#report.roots + 1] = { name = root.Name, class = root.ClassName, path = path(root) }
                end
                while head <= #queue and #report.nodes < settings.maxNodes and metadataBytes < MAX_TEXT and not state.cancel and state.alive do
                    local entry = queue[head]
                    queue[head] = false
                    head = head + 1
                    local obj = entry.object
                    local isOwn = obj == Lumen.State.Screen
                    if not seen[obj] and not isOwn then
                        seen[obj] = true
                        local nodeId = #report.nodes + 1
                        local node = { id = nodeId, parent = entry.parent, depth = entry.depth, name = str(obj.Name, 300), class = obj.ClassName, path = str(path(obj), 1800) }
                        local attrOk, attrs = pcall(function() return obj:GetAttributes() end)
                        if attrOk and next(attrs) then
                            node.attributes = {}
                            local count = 0
                            for key, v in pairs(attrs) do
                                count = count + 1
                                if count > 40 then node.attributesTruncated = true break end
                                node.attributes[str(key, 150)] = value(v)
                            end
                        end
                        local tagOk, tags = pcall(function() return Tags:GetTags(obj) end)
                        if tagOk and #tags > 0 then node.tags = {} for i = 1, math.min(#tags, 40) do node.tags[i] = str(tags[i], 150) end end
                        if obj:IsA("ValueBase") then node.properties = properties(obj, { "Value" }) end
                        if obj:IsA("BasePart") then
                            node.properties = properties(obj, { "Position", "Size", "Anchored", "CanCollide", "Transparency" })
                        elseif obj:IsA("Humanoid") then
                            node.properties = properties(obj, { "Health", "MaxHealth", "WalkSpeed", "RigType" })
                        elseif obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                            node.properties = properties(obj, { "Text", "Visible" })
                        elseif obj:IsA("Animation") then node.properties = properties(obj, { "AnimationId" })
                        elseif obj:IsA("Sound") then node.properties = properties(obj, { "SoundId", "Volume", "IsPlaying" }) end
                        report.nodes[#report.nodes + 1] = node
                        report.classCounts[node.class] = (report.classCounts[node.class] or 0) + 1
                        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") or obj:IsA("UnreliableRemoteEvent") or obj:IsA("BindableEvent") or obj:IsA("BindableFunction") then
                            report.remotes[#report.remotes + 1] = { id = nodeId, class = node.class, path = node.path }
                        end
                        if obj:IsA("LuaSourceContainer") then
                            local record = { id = nodeId, class = node.class, path = node.path,
                                properties = properties(obj, { "Disabled", "Enabled", "RunContext" }), sourceStatus = "not requested" }
                            report.scripts[#report.scripts + 1] = record
                            local matches = settings.sourceFilter == "" or node.path:lower():find(settings.sourceFilter:lower(), 1, true)
                            if settings.sources and matches and (obj:IsA("ModuleScript") or obj:IsA("LocalScript") or tostring(record.properties.RunContext) == "Enum.RunContext.Client") then
                                report.stats.sourceEligible = report.stats.sourceEligible + 1
                                if #targets < settings.maxSources then
                                    record.sourceStatus = "pending"
                                    targets[#targets + 1] = { object = obj, record = record }
                                else
                                    record.sourceStatus = "source count limit"
                                    report.stats.sourceCountLimitSkipped = report.stats.sourceCountLimitSkipped + 1
                                end
                            elseif settings.sources then record.sourceStatus = "outside filter or not a client/module script" end
                        end
                        if obj:IsA("ProximityPrompt") or obj:IsA("ClickDetector") or obj:IsA("Tool") or obj:IsA("TouchTransmitter") then
                            report.interactives[#report.interactives + 1] = { id = nodeId, class = node.class, path = node.path,
                                properties = properties(obj, { "Enabled", "ActionText", "ObjectText", "MaxActivationDistance", "HoldDuration", "RequiresHandle", "ToolTip" }) }
                        end
                        if obj:IsA("Model") then
                            report.models[#report.models + 1] = { id = nodeId, path = node.path,
                                humanoid = obj:FindFirstChildOfClass("Humanoid") ~= nil,
                                properties = properties(obj, { "PrimaryPart", "WorldPivot" }) }
                        end
                        local encodedOk, encoded = pcall(function() return Http:JSONEncode(node) end)
                        metadataBytes = metadataBytes + (encodedOk and #encoded or 2000)
                        local childrenOk, children = pcall(function() return obj:GetChildren() end)
                        if childrenOk then
                            for _, child in ipairs(children) do
                                -- Queue is bounded as well as the output.
                                if #queue >= settings.maxNodes then report.stats.queueLimitReached = true break end
                                queue[#queue + 1] = { object = child, parent = nodeId, depth = entry.depth + 1 }
                            end
                        elseif #report.errors < 100 then report.errors[#report.errors + 1] = node.path .. ": " .. str(children, 400) end
                    end
                    if head % 100 == 0 then
                        status("Scanning: " .. #report.nodes .. " objects | " .. #report.remotes .. " remotes")
                        task.wait()
                    end
                end
                report.stats.metadataLimitReached = metadataBytes >= MAX_TEXT
                report.stats.cancelled = state.cancel or not state.alive
                report.stats.nodes = #report.nodes
                report.stats.remotes = #report.remotes
                report.stats.scripts = #report.scripts
                report.stats.sourceBytes = 0
                report.stats.sourcesCollected = 0
                for i, target in ipairs(targets) do
                    if state.cancel or not state.alive then
                        target.record.sourceStatus = "cancelled"
                        report.stats.sourcesCancelled = report.stats.sourcesCancelled + 1
                    elseif report.stats.sourceBytes >= MAX_SOURCE_BYTES then
                        target.record.sourceStatus = "total source size limit"
                        report.stats.sourceBytesLimitSkipped = report.stats.sourceBytesLimitSkipped + 1
                    else
                        report.stats.sourceAttempts = report.stats.sourceAttempts + 1
                        status("Source " .. i .. "/" .. #targets .. ": " .. str(target.object.Name, 40))
                        local source, failure = boundedSource(target.object, false)
                        local method = "Source property"
                        if not source and settings.decompile and type(decompiler) == "function" and not state.cancel and state.alive then
                            method = "decompile (unverified output)"
                            source, failure = boundedSource(target.object, true)
                        end
                        if source and method == "decompile (unverified output)" then
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
                            if not sourceTexts[source] then
                                sourceTexts[source] = true
                                report.stats.sourceUniqueTexts = report.stats.sourceUniqueTexts + 1
                            end
                            local maxBytes = math.min(160000, MAX_SOURCE_BYTES - report.stats.sourceBytes)
                            target.record.source = prefix(source, maxBytes)
                            target.record.sourceTruncated = #source > maxBytes
                            if target.record.sourceTruncated then report.stats.sourceTruncatedCount = report.stats.sourceTruncatedCount + 1 end
                            target.record.sourceStatus = method
                            report.stats.sourceBytes = report.stats.sourceBytes + #target.record.source
                            report.stats.sourcesCollected = report.stats.sourcesCollected + 1
                        else
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
                        end
                    end
                    task.wait()
                end
            end, function(e) return debug.traceback(tostring(e), 2) end)
            if not ok then report.errors[#report.errors + 1] = str(err, 4000) end
            report.stats.cancelled = state.cancel or not state.alive
            report.stats.durationSeconds = math.floor((os.clock() - started) * 100) / 100
            report.stats.completed = ok and not report.stats.cancelled
            report.stats.nodes, report.stats.remotes, report.stats.scripts = #report.nodes, #report.remotes, #report.scripts
            report.stats.treeIncomplete = not report.stats.completed or report.stats.queueLimitReached == true or report.stats.metadataLimitReached == true
            report.stats.sourcesPending = 0
            for _, record in ipairs(report.scripts) do
                if record.sourceStatus == "pending" then report.stats.sourcesPending = report.stats.sourcesPending + 1 end
            end
            report.stats.missingRequestedRoots = #missingRoots
            report.stats.sourceIncomplete = settings.sources and (#missingRoots > 0 or report.stats.sourceCountLimitSkipped > 0
                or report.stats.sourceBytesLimitSkipped > 0 or report.stats.sourceFailures > 0
                or report.stats.sourcesCancelled > 0 or report.stats.sourceTruncatedCount > 0 or report.stats.sourcesPending > 0) or false
            report.stats.incomplete = report.stats.treeIncomplete or report.stats.sourceIncomplete
            report.logs = table.clone(state.logs)
            savedReports[profile] = report
            state.busy = false
            if state.alive then
                if reportLabel then reportLabel:SetText("Active report: " .. profile) end
                status((report.stats.cancelled and "Cancelled: " or (ok and "Done: " or "Partial report: ")) .. #report.nodes .. " objects")
                countLabel:SetText(#report.remotes .. " remotes | " .. #report.scripts .. " scripts | " .. (report.stats.sourcesCollected or 0) .. " sources")
                notify((report.stats.incomplete and "Partial report" or "Report ready") .. ": " .. profile .. ". Open Export -> COPY REPORT.")
            end
        end)
    end

    local function selectReport()
        if not state.report then notify("Run Scan first") return end
        if state.busy or state.exporting then notify("Wait for scan/export completion, or press Cancel") return end
        local r = state.report
        r.logs = table.clone(state.logs)
        if exportKind == "Full report" then return r end
        if exportKind == "Logs" then return { format = r.format, createdUTC = r.createdUTC, game = r.game, settings = r.settings, stats = r.stats, logs = r.logs } end
        local key = ({ Remotes = "remotes", Scripts = "scripts", Interactives = "interactives", Models = "models", Tree = "nodes" })[exportKind]
        local records = {}
        for _, item in ipairs(r[key] or {}) do
            if exportFilter == "" or (item.path or ""):lower():find(exportFilter:lower(), 1, true) then records[#records + 1] = item end
        end
        return { format = r.format, createdUTC = r.createdUTC, game = r.game, stats = r.stats, settings = r.settings,
            capabilities = r.capabilities, roots = r.roots, errors = r.errors, limitations = r.limitations,
            section = exportKind, filter = exportFilter, records = records }
    end
    local function encodeSafe(report)
        if state.exporting then notify("Export already running") return end
        state.exporting, state.cancelExport = true, false
        status("Encoding report...")
        local ok, text, info = pcall(function()
            local success, result = pcall(function() return Http:JSONEncode(report) end)
            if success and type(result)=="string" and result~="" then return result end
            local details = { error = str(result or "Native encoder returned no text",1000), fields = {} }
            -- First identify failing top-level fields; never discard them silently.
            for key, v in pairs(report) do
                if not state.alive or state.cancelExport then error("Export cancelled; cached scan retained",0) end
                local fieldOK, fieldError = pcall(function() return Http:JSONEncode(v) end)
                if not fieldOK then details.fields[#details.fields+1] = { field = tostring(key), error = str(fieldError,500) } end
                task.wait()
            end
            status("Native JSON failed; using portable export...")
            return PortableJSON(report, details, function(count, bytes)
                if not state.alive or state.cancelExport then error("Export cancelled; cached scan retained",0) end
                status("Exporting: " .. count .. " values / " .. math.floor(bytes/1024) .. " KB")
                task.wait()
            end)
        end)
        state.exporting = false
        if not ok then
            status("Export stopped; report remains in memory")
            notify("Export error: " .. str(text,180))
            return
        end
        state.lastSerialization = info
        lastExport = text
        status("Export ready: " .. #text .. " bytes")
        if info then
            notify("Portable JSON ready. Normalized values: " .. info.normalizationCount .. ". Details: _jsonExport.")
        end
        return text
    end
    local function encodeReport()
        local report = selectReport()
        if not report then return end
        return encodeSafe(report)
    end
    local manualFrame
    local function manualCopy(text)
        if manualFrame then manualFrame:Destroy() end
        local frame = Instance.new("Frame")
        manualFrame = frame
        frame.Size = UDim2.fromScale(0.82, 0.76)
        frame.Position = UDim2.fromScale(0.09, 0.12)
        frame.BackgroundColor3 = Color3.fromRGB(24, 26, 33)
        frame.ZIndex = 300
        frame.Parent = Lumen.State.Screen
        local header = Instance.new("TextLabel")
        header.Size = UDim2.new(1, -10, 0, 38)
        header.Position = UDim2.fromOffset(5, 0)
        header.BackgroundTransparency = 1
        header.TextColor3 = Color3.new(1, 1, 1)
        header.TextSize = 14
        header.ZIndex = 301
        header.Parent = frame
        local box = Instance.new("TextBox")
        box.Size = UDim2.new(1, -20, 1, -90)
        box.Position = UDim2.fromOffset(10, 40)
        box.MultiLine = true
        box.ClearTextOnFocus = false
        box.TextEditable = true
        box.TextWrapped = false
        box.Font = Enum.Font.Code
        box.TextSize = 12
        box.TextColor3 = Color3.fromRGB(215, 225, 235)
        box.BackgroundColor3 = Color3.fromRGB(15, 17, 22)
        box.TextXAlignment = Enum.TextXAlignment.Left
        box.TextYAlignment = Enum.TextYAlignment.Top
        box.ZIndex = 301
        box.Parent = frame
        local page, pageSize = 1, 30000
        local chunks, first = {}, 1
        while first <= #text do
            local last = math.min(#text, first + pageSize - 1)
            while last < #text do
                local b = text:byte(last + 1)
                if b < 128 or b >= 192 then break end
                last = last - 1
            end
            chunks[#chunks + 1] = text:sub(first, last)
            first = last + 1
        end
        if #chunks == 0 then chunks[1] = "" end
        local pages = #chunks
        local function render()
            -- UTF-8-safe, byte-exact chunks; concatenate in order.
            box.Text = chunks[page]
            header.Text = "Manual copy: page " .. page .. "/" .. pages .. " | Ctrl+A, Ctrl+C (join pages in order)"
        end
        local function button(title, x, callback)
            local b = Instance.new("TextButton")
            b.Size = UDim2.fromOffset(100, 30)
            b.Position = UDim2.new(0, x, 1, -38)
            b.Text = title
            b.ZIndex = 302
            b.Parent = frame
            b.MouseButton1Click:Connect(callback)
        end
        button("Previous", 10, function() page = math.max(1, page - 1) render() end)
        button("Next", 120, function() page = math.min(pages, page + 1) render() end)
        button("Select all", 230, function() box:CaptureFocus() box.CursorPosition = #box.Text + 1 box.SelectionStart = 1 end)
        button("Close", 340, function() frame:Destroy() manualFrame = nil end)
        render()
    end
    local function encodeBundle()
        if state.busy or state.exporting then notify("Wait for scan/export completion or cancel first") return end
        local reports = {}
        for _, key in ipairs({ "core", "overview", "replicated", "clients", "game" }) do
            if savedReports[key] then reports[#reports + 1] = savedReports[key] end
        end
        if #reports == 0 then notify("Run at least one scan first") return end
        return encodeSafe({ format = "NZL Game Debug Bundle 1.4", exportType = "bundle",
            createdUTC = os.date("!%Y-%m-%dT%H:%M:%SZ"), reportCount = #reports,
            reports = reports, logsAtExport = table.clone(state.logs),
            note = "Full cached scans, ignoring export filters. Client-visible data only; review before sharing." })
    end
    local function copy(bundle)
        local text
        if bundle then text = encodeBundle() else text = encodeReport() end
        if not text then return end
        if type(clipboard) == "function" then
            local ok, err = pcall(clipboard, text)
            if ok then notify("Sent to clipboard: " .. #text .. " bytes") return end
            notify("Clipboard failed: " .. str(err, 120))
        else notify("No clipboard API. Use manual copy / save file.") end
        manualCopy(text)
    end
    local function save(bundle)
        local text
        if bundle then text = encodeBundle() else text = encodeReport() end
        if not text then return end
        if type(fileWriter) ~= "function" then notify("writefile unavailable. Use Copy / manual copy.") return end
        local label = bundle and "ALL_SCANS" or ((state.report.settings.profile or "game") .. "_" .. exportKind:gsub("%W", "_"))
        local filename = "GameDebug_" .. game.PlaceId .. "_" .. label .. "_" .. os.date("!%Y%m%d_%H%M%S") .. ".json"
        local ok, err = pcall(fileWriter, filename, text)
        notify(ok and ("Saved: " .. filename) or ("Save failed: " .. str(err, 180)))
    end

    Lumen.Folder = "nzl_game_debug"
    Lumen.ConfigFolder = Lumen.Folder .. "/configs"
    Lumen.ThemeFolder = Lumen.Folder .. "/themes"
    local window = Lumen:Window({ Name = "Game Debug | core modules", Version = "1.4 / JSON fix", Footer = "Place " .. tostring(game.PlaceId) .. " | client-visible only", Keybind = Enum.KeyCode.RightControl, Size = UDim2.fromOffset(800, 570), SettingsPage = false })
    local page = window:Page({ Name = "scan", Columns = 2, Group = "debug" })
    local controls = page:Section({ Name = "collector", Side = 1 })
    statusLabel = controls:Label("Ready. Press Scan game.")
    countLabel = controls:Label("No report yet")
    controls:Button({ Name = "CORE dependencies + decompile", Callback = function() scan("core") end })
    controls:Label("CORE: 25 CAM / Communication roots, 500 scripts.")
    controls:Button({ Name = "Game overview (no source)", Callback = function() scan("overview") end })
    controls:Button({ Name = "Scan game (manual settings)", Callback = function() scan("game") end })
    controls:Button({ Name = "ReplicatedStorage + decompile", Callback = function() scan("replicated") end })
    controls:Button({ Name = "Local client scripts + decompile", Callback = function() scan("clients") end })
    controls:Button({ Name = "Cancel (keep partial report)", Callback = function()
        if state.exporting then state.cancelExport=true;notify("Cancelling export; cached scan retained") return end
        if not state.busy then notify("No scan is running") return end
        state.cancel = true status("Cancelling...")
    end })
    controls:Slider({ Name = "Object limit", Min = 1000, Max = 60000, Default = 20000, Decimals = 0, Flag = "dbg_limit", Callback = function(v) cfg.maxNodes = math.floor(v) end })
    controls:Label("CorePackages / CoreGui / engine roots excluded.")
    controls:Label("Presets reset filter; Max source scripts is respected.")
    controls:Label("No remote calls, hooks or module execution.")
    local sourceSec = page:Section({ Name = "source / decompiler (optional)", Side = 2 })
    sourceToggle = sourceSec:Toggle({ Name = "Read available source", Default = false, Flag = "dbg_source", Callback = function(v) cfg.sources = v end })
    decompileToggle = sourceSec:Toggle({ Name = "Try executor decompile fallback", Default = false, Flag = "dbg_decompile", Callback = function(v)
        cfg.decompile = v
        if v then notify("Also enable Read available source. Decompile is not deobfuscation; output is unverified.") end
    end })
    sourceFilterBox = sourceSec:Textbox({ Name = "Source path contains (optional)", Default = "", Flag = "dbg_source_filter", Callback = function(v) cfg.sourceFilter = tostring(v) end })
    sourceCountSlider = sourceSec:Slider({ Name = "Max source scripts", Min = 1, Max = 500, Default = 250, Decimals = 0, Flag = "dbg_source_count", Callback = function(v) cfg.maxSources = math.floor(v) end })
    sourceSec:Label("Source budget: 4 MB total / 160 KB per script.")
    sourceSec:Label("5s timeout per attempt (best-effort).")
    sourceSec:Label("Server source is not available from client.")
    local exports = window:Page({ Name = "export", Columns = 2, Group = "debug" })
    local exportSec = exports:Section({ Name = "copy / save", Side = 1 })
    exportSelector = exportSec:Dropdown({ Name = "Section", Items = { "Full report", "Remotes", "Scripts", "Interactives", "Models", "Tree", "Logs" }, Default = "Full report", Flag = "dbg_section", Callback = function(v) exportKind = v end })
    exportFilterBox = exportSec:Textbox({ Name = "Export path filter", Default = "", Flag = "dbg_export_filter", Callback = function(v) exportFilter = tostring(v) end })
    exportSec:Label("Filter applies to sections, not Full / Logs.")
    reportLabel = exportSec:Label("Active report: none")
    savedSelector = exportSec:Dropdown({ Name = "Saved scan", Items = { "Latest", "Core", "Overview", "ReplicatedStorage", "Local client", "Game" }, Default = "Latest", Flag = "dbg_saved_scan", Callback = function(v)
        if state.busy or state.exporting then notify("Wait for scan/export to finish") return end
        local key = ({ Core = "core", Overview = "overview", ReplicatedStorage = "replicated", ["Local client"] = "clients", Game = "game", Latest = lastProfile })[v]
        local r = savedReports[key]
        if not r then notify("No saved scan for " .. tostring(v)) return end
        state.report = r
        if reportLabel then reportLabel:SetText("Active report: " .. r.settings.profile) end
        notify("Selected report: " .. r.settings.profile)
    end })
    exportSec:Button({ Name = "COPY REPORT", Callback = function() copy(false) end })
    exportSec:Button({ Name = "Save report (.json)", Callback = function() save(false) end })
    exportSec:Button({ Name = "Manual copy / view", Callback = function() local text = encodeReport() if text then manualCopy(text) end end })
    exportSec:Button({ Name = "Clear captured logs", Callback = function() state.logs = {} notify("Captured log buffer cleared") end })
    local bundleSec = exports:Section({ Name = "all scans in ONE JSON", Side = 2 })
    bundleSec:Button({ Name = "COPY ALL SCANS", Callback = function() copy(true) end })
    bundleSec:Button({ Name = "Save ALL scans (.json)", Callback = function() save(true) end })
    bundleSec:Label("Combines completed/partial cached scans.")
    bundleSec:Label("Ignores Section and Export path filter.")
    local notes = exports:Section({ Name = "important", Side = 2 })
    notes:Label("Presets select Scripts export automatically.")
    notes:Label("Latest scan per profile is kept in memory.")
    notes:Label("Reports stay local. No upload is performed.")
    notes:Label("Review source/logs/text before sharing.")
    notes:Label("Clipboard & writefile depend on executor.")
    notes:Label("Studio: manual copy; usually no decompiler.")
    notes:Label("Remotes: names, classes, paths, attributes.")
    notes:Label("Remote arguments / handlers are NOT captured.")
    notes:Label("Missing objects may be unstreamed or private.")
    notes:Label("Error-only decompiler stubs are marked failed.")
    notes:Label("Text is not syntax-checked or executed.")
    notes:Label("JSON failure: portable fallback keeps the report.")
    notes:Label("Normalization details: _jsonExport issue paths.")
    notes:Label("Large overview: prefer Save report (.json).")
    notes:Label("Use stats/errors to check partial results.")
    notes:Button({ Name = "Unload collector", Callback = function() Lumen:Unload() end })
    -- Do not autoload prior settings: source extraction must be explicitly enabled.
    notify("JSON fix ready. Scan Game overview -> Export / Save report. CORE does not need repeating if already exported.")
end
RunCollector(Lumen)

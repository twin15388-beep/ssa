-- Game Debug Collector 1.0. Read-only inspection; no remote calls or require().
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

    local cfg = { maxNodes = 20000, sources = false, decompile = false, sourceFilter = "", maxSources = 50 }
    local state = { alive = true, busy = false, cancel = false, logs = {}, report = nil, connections = {}, sourceTask = nil }
    local clipboard = setclipboard or toclipboard or (Clipboard and Clipboard.set)
    local decompiler = decompile
    local fileWriter = writefile
    local MAX_TEXT = 12000000
    local MAX_SOURCE_BYTES = 4000000
    local statusLabel, countLabel, lastExport
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
    local function captureSettings()
        return { maxNodes = cfg.maxNodes, sources = cfg.sources, decompile = cfg.decompile,
            sourceFilter = cfg.sourceFilter, maxSources = cfg.maxSources }
    end
    local function scan()
        if state.busy then notify("Scan already running") return end
        state.busy, state.cancel = true, false
        task.spawn(function()
            local started = os.clock()
            local settings = captureSettings()
            local report = {
                format = "NZL Game Debug 1.0", createdUTC = os.date("!%Y-%m-%dT%H:%M:%SZ"),
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
                models = {}, classCounts = {}, errors = {}, stats = {}, logs = {},
            }
            state.report = report
            local targets, metadataBytes = {}, 0
            local ok, err = xpcall(function()
                local queue, head, seen = {}, 1, {}
                for _, root in ipairs(game:GetChildren()) do
                    -- CoreGui may include unrelated private UI; deliberately excluded.
                    if root.ClassName ~= "CoreGui" then
                        queue[#queue + 1] = { object = root, parent = 0, depth = 0 }
                        report.roots[#report.roots + 1] = { name = root.Name, class = root.ClassName }
                    end
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
                                if #targets < settings.maxSources then targets[#targets + 1] = { object = obj, record = record }
                                else record.sourceStatus = "source count limit" end
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
                    if state.cancel or not state.alive then target.record.sourceStatus = "cancelled"
                    elseif report.stats.sourceBytes >= MAX_SOURCE_BYTES then target.record.sourceStatus = "total source size limit"
                    else
                        status("Source " .. i .. "/" .. #targets .. ": " .. str(target.object.Name, 40))
                        local source, failure = boundedSource(target.object, false)
                        local method = "Source property"
                        if not source and settings.decompile and type(decompiler) == "function" and not state.cancel and state.alive then
                            method = "decompile (unverified output)"
                            source, failure = boundedSource(target.object, true)
                        end
                        if source then
                            local maxBytes = math.min(160000, MAX_SOURCE_BYTES - report.stats.sourceBytes)
                            target.record.source = prefix(source, maxBytes)
                            target.record.sourceTruncated = #source > maxBytes
                            target.record.sourceStatus = method
                            report.stats.sourceBytes = report.stats.sourceBytes + #target.record.source
                            report.stats.sourcesCollected = report.stats.sourcesCollected + 1
                        else target.record.sourceStatus = failure or "unavailable" end
                    end
                    task.wait()
                end
            end, function(e) return debug.traceback(tostring(e), 2) end)
            if not ok then report.errors[#report.errors + 1] = str(err, 4000) end
            report.stats.cancelled = state.cancel or not state.alive
            report.stats.durationSeconds = math.floor((os.clock() - started) * 100) / 100
            report.stats.completed = ok and not report.stats.cancelled
            report.stats.incomplete = not report.stats.completed or report.stats.queueLimitReached == true or report.stats.metadataLimitReached == true
            report.logs = table.clone(state.logs)
            state.busy = false
            if state.alive then
                status((report.stats.cancelled and "Cancelled: " or (ok and "Done: " or "Partial report: ")) .. #report.nodes .. " objects")
                countLabel:SetText(#report.remotes .. " remotes | " .. #report.scripts .. " scripts | " .. (report.stats.sourcesCollected or 0) .. " sources")
                notify("Report ready. Open Export. Limits/errors are listed in the report.")
            end
        end)
    end

    local exportKind, exportFilter = "Full report", ""
    local function selectReport()
        if not state.report then notify("Run Scan first") return end
        if state.busy then notify("Wait for scan completion, or press Cancel") return end
        local r = state.report
        r.logs = table.clone(state.logs)
        if exportKind == "Full report" then return r end
        if exportKind == "Logs" then return { format = r.format, logs = r.logs } end
        local key = ({ Remotes = "remotes", Scripts = "scripts", Interactives = "interactives", Models = "models", Tree = "nodes" })[exportKind]
        local records = {}
        for _, item in ipairs(r[key] or {}) do
            if exportFilter == "" or (item.path or ""):lower():find(exportFilter:lower(), 1, true) then records[#records + 1] = item end
        end
        return { format = r.format, game = r.game, stats = r.stats, limitations = r.limitations, section = exportKind, filter = exportFilter, records = records }
    end
    local function encodeReport()
        local report = selectReport()
        if not report then return end
        -- One JSON object, newline separated fields for easier manual review.
        local ok, text = pcall(function()
            local keys, lines = {}, { "{" }
            for key in pairs(report) do keys[#keys + 1] = key end
            table.sort(keys)
            for i, key in ipairs(keys) do
                lines[#lines + 1] = Http:JSONEncode(key) .. ": " .. Http:JSONEncode(report[key]) .. (i < #keys and "," or "")
            end
            lines[#lines + 1] = "}"
            return table.concat(lines, "\n")
        end)
        if not ok then notify("JSON error: " .. str(text, 160)) return end
        lastExport = text
        return text
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
    local function copy()
        local text = encodeReport()
        if not text then return end
        if type(clipboard) == "function" then
            local ok, err = pcall(clipboard, text)
            if ok then notify("Sent to clipboard: " .. #text .. " bytes") return end
            notify("Clipboard failed: " .. str(err, 120))
        else notify("No clipboard API. Use manual copy / save file.") end
        manualCopy(text)
    end
    local function save()
        local text = encodeReport()
        if not text then return end
        if type(fileWriter) ~= "function" then notify("writefile unavailable. Use Copy / manual copy.") return end
        local filename = "GameDebug_" .. game.PlaceId .. "_" .. os.date("!%Y%m%d_%H%M%S") .. "_" .. exportKind:gsub("%W", "_") .. ".json"
        local ok, err = pcall(fileWriter, filename, text)
        notify(ok and ("Saved: " .. filename) or ("Save failed: " .. str(err, 180)))
    end

    Lumen.Folder = "nzl_game_debug"
    Lumen.ConfigFolder = Lumen.Folder .. "/configs"
    Lumen.ThemeFolder = Lumen.Folder .. "/themes"
    local window = Lumen:Window({ Name = "Game Debug Collector", Version = "1.0", Footer = "Read-only | client-visible data", Keybind = Enum.KeyCode.RightControl, Size = UDim2.fromOffset(800, 570), SettingsPage = false })
    local page = window:Page({ Name = "scan", Columns = 2, Group = "debug" })
    local controls = page:Section({ Name = "collector", Side = 1 })
    statusLabel = controls:Label("Ready. Press Scan game.")
    countLabel = controls:Label("No report yet")
    controls:Button({ Name = "Scan game", Callback = scan })
    controls:Button({ Name = "Cancel (keep partial report)", Callback = function() state.cancel = true status("Cancelling...") end })
    controls:Slider({ Name = "Object limit", Min = 1000, Max = 60000, Default = 20000, Decimals = 0, Flag = "dbg_limit", Callback = function(v) cfg.maxNodes = math.floor(v) end })
    controls:Label("CoreGui and collector UI are excluded.")
    controls:Label("No remote calls, hooks or module execution.")
    local sourceSec = page:Section({ Name = "source / decompiler (optional)", Side = 2 })
    sourceSec:Toggle({ Name = "Read available source", Default = false, Flag = "dbg_source", Callback = function(v) cfg.sources = v end })
    sourceSec:Toggle({ Name = "Try executor decompile fallback", Default = false, Flag = "dbg_decompile", Callback = function(v)
        cfg.decompile = v
        if v then notify("Also enable Read available source. Decompile is not deobfuscation; output is unverified.") end
    end })
    sourceSec:Textbox({ Name = "Source path contains (optional)", Default = "", Flag = "dbg_source_filter", Callback = function(v) cfg.sourceFilter = tostring(v) end })
    sourceSec:Slider({ Name = "Max source scripts", Min = 1, Max = 250, Default = 50, Decimals = 0, Flag = "dbg_source_count", Callback = function(v) cfg.maxSources = math.floor(v) end })
    sourceSec:Label("Source budget: 4 MB total / 160 KB per script.")
    sourceSec:Label("5s timeout per attempt (best-effort).")
    sourceSec:Label("Server source is not available from client.")
    local exports = window:Page({ Name = "export", Columns = 2, Group = "debug" })
    local exportSec = exports:Section({ Name = "copy / save", Side = 1 })
    exportSec:Dropdown({ Name = "Section", Items = { "Full report", "Remotes", "Scripts", "Interactives", "Models", "Tree", "Logs" }, Default = "Full report", Flag = "dbg_section", Callback = function(v) exportKind = v end })
    exportSec:Textbox({ Name = "Export path filter", Default = "", Flag = "dbg_export_filter", Callback = function(v) exportFilter = tostring(v) end })
    exportSec:Label("Filter applies to sections, not Full / Logs.")
    exportSec:Button({ Name = "COPY REPORT", Callback = copy })
    exportSec:Button({ Name = "Save report (.json)", Callback = save })
    exportSec:Button({ Name = "Manual copy / view", Callback = function() local text = encodeReport() if text then manualCopy(text) end end })
    exportSec:Button({ Name = "Clear captured logs", Callback = function() state.logs = {} notify("Captured log buffer cleared") end })
    local notes = exports:Section({ Name = "important", Side = 2 })
    notes:Label("Reports stay local. No upload is performed.")
    notes:Label("Review source/logs/text before sharing.")
    notes:Label("Clipboard & writefile depend on executor.")
    notes:Label("Studio: manual copy; usually no decompiler.")
    notes:Label("Remotes: names, classes, paths, attributes.")
    notes:Label("Remote arguments / handlers are NOT captured.")
    notes:Label("Missing objects may be unstreamed or private.")
    notes:Label("Use stats/errors to check partial results.")
    notes:Button({ Name = "Unload collector", Callback = function() Lumen:Unload() end })
    -- Do not autoload prior settings: source extraction must be explicitly enabled.
    notify("Ready. Scan game -> Export -> COPY REPORT. Menu: RightControl.")
end
RunCollector(Lumen)

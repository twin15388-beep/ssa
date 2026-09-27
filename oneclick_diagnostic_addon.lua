    -- Passive runtime snapshot; never require or invoke a gameplay module here.
    local function resolveNames(root,names)
        for _,name in ipairs(names) do root=root and root:FindFirstChild(name);if not root then break end end
        return root
    end
    local function runtimeSnapshot()
        local r={collectedUTC=os.date("!%Y-%m-%dT%H:%M:%SZ"),errors={},
            note="Passive observation only. Module presence does not establish active listeners; no M1, skills, equip, quest or remote requests were performed."}
        local function attempt(key,fn)
            local ok,result=pcall(fn)
            if ok then r[key]=result else r.errors[#r.errors+1]={section=key,error=str(result,1200)} end
        end
        attempt("executor",function()
            local fn=identifyexecutor or getexecutorname
            if type(fn)~="function" then return {name="unknown",reason="Identification API unavailable"} end
            local name,version=fn();return {name=str(name,200),version=version and str(version,100) or nil}
        end)
        attempt("device",function()
            local input=game:GetService("UserInputService")
            local d=properties(input,{"KeyboardEnabled","TouchEnabled","GamepadEnabled","MouseEnabled"})
            local ok,p=pcall(function() return input:GetPlatform() end);d.platform=ok and tostring(p) or "unavailable"
            return d
        end)
        attempt("mainHub",function()
            local hub=env.CAMMainHub
            if type(hub)~="table" then return {present=false,note="CAM Main v1.0 was not found in this executor environment"} end
            if type(hub.Snapshot)=="function" then
                -- This is our own hub's bounded, read-only snapshot, not a discovered game module.
                return {present=true,version=hub.Version,report=hub.Snapshot()}
            end
            return {present=true,version=hub.Version,note="Snapshot API unavailable"}
        end)
        local function compactTree(root,limit,depthLimit)
            if not root then return {missing=true} end
            local result={path=path(root),nodes={},incomplete=false}
            local queue={{o=root,depth=0,parent=0}};local head=1
            while head<=#queue and #result.nodes<limit do
                if not state.alive then error("Collector unloaded") end
                local entry=queue[head];head=head+1;local o=entry.o
                local node={name=str(o.Name,200),class=o.ClassName,parent=entry.parent,depth=entry.depth}
                local ok,a=pcall(function() return o:GetAttributes() end)
                if ok then node.attributes={};for k,v in pairs(a) do node.attributes[str(k,200)]=value(v) end end
                node.properties=properties(o,{"Value","Health","MaxHealth","WalkSpeed","JumpPower","JumpHeight","Position","Enabled","Disabled"})
                result.nodes[#result.nodes+1]=node;local id=#result.nodes
                local success,children=pcall(function() return o:GetChildren() end)
                if success then
                    if entry.depth<depthLimit then
                        for _,child in ipairs(children) do
                            if #queue<limit then queue[#queue+1]={o=child,depth=entry.depth+1,parent=id} else result.incomplete=true end
                        end
                    elseif #children>0 then result.incomplete=true end
                end
            end
            if head<=#queue then result.incomplete=true end
            return result
        end
        local RS=game:GetService("ReplicatedStorage")
        attempt("localState",function()
            local dataRoot=resolveNames(RS,{"Player_Service","Data",LP.Name})
            local slot=dataRoot and dataRoot:FindFirstChild("slotEquipped")
            local d=slot and resolveNames(dataRoot,{"slots","Slot"..tostring(slot.Value)})
            local c=LP.Character;local h=c and c:FindFirstChildOfClass("Humanoid")
            return {
                character=c and path(c) or "missing",humanoid=h and properties(h,{"Health","MaxHealth","WalkSpeed","PlatformStand","Sit","MoveDirection"}) or {},
                characterAttributes=c and c:GetAttributes() or {},
                menuDestination=compactTree(LP:FindFirstChild("MenuDestination"),3,0),
                equipped=compactTree(LP:FindFirstChild("Items_Config"),20,2),
                values=compactTree(resolveNames(RS,{"Player_Service","Values",LP.Name}),300,3),
                toolbar=compactTree(d and resolveNames(d,{"Inventory","Toolbar"}),40,2),
                inventory=compactTree(d and resolveNames(d,{"Inventory","Inventory"}),800,3),
                quests=compactTree(d and d:FindFirstChild("Quests"),350,5),
                skillState=compactTree(c and c:FindFirstChild("SHC"),10,1),
                serverSkillState=compactTree(c and c:FindFirstChild("SHCS"),10,1),
                pendingDialogue=LP:GetAttribute("PendingDialogue"),
                dialogueVisibility=compactTree(resolveNames(RS,{"CAM","Client","Components","Layout","Visibility","Dialogue"}),3,0),
                skillVisibility=compactTree(resolveNames(RS,{"CAM","Client","Components","Layout","Visibility","HUD","Skills"}),3,0),
            }
        end)
        attempt("loadedModules",function()
            if type(getloadedmodules)~="function" then return {available=false} end
            local list=getloadedmodules();local out={available=true,paths={},incomplete=false}
            for _,m in ipairs(list) do
                local p=path(m)
                if p:find("ReplicatedStorage.CAM",1,true) or p:find("ReplicatedStorage.Regions",1,true) or p:find("PlayerScripts",1,true) then
                    if #out.paths<1200 then out.paths[#out.paths+1]=str(p,1200) else out.incomplete=true end
                end
            end
            table.sort(out.paths);return out
        end)
        return r
    end
    local function discoverFocusedRoots()
        local RS=game:GetService("ReplicatedStorage")
        local found={};local diagnostics={paths={},errors={}}
        local containers={resolveNames(RS,{"CAM","Client","Components","Layout"}),LP:FindFirstChild("PlayerScripts")}
        for _,root in pairs(containers) do
            local ok,list=pcall(function() return root:GetDescendants() end)
            if ok then
                for _,o in ipairs(list) do
                    if o:IsA("ModuleScript") or o:IsA("LocalScript") then
                        local n=o.Name:lower()
                        if n:find("toolbar",1,true) or n=="skills" or n=="skillholder" or n=="skillsholder" or n=="layout" or n=="combat" then
                            if #found<30 then found[#found+1]=o;diagnostics.paths[#diagnostics.paths+1]=path(o) else diagnostics.limitReached=true end
                        end
                    end
                end
            else diagnostics.errors[#diagnostics.errors+1]=str(list,1000) end
        end
        return found,diagnostics
    end
    local function deliverText(text)
        local filename="CAM_Debug_OneClick_"..tostring(game.PlaceId).."_"..os.date("!%Y%m%d_%H%M%S")..".json"
        local saved,copied=false,false
        if type(fileWriter)=="function" then
            local ok,err=pcall(fileWriter,filename,text);saved=ok
            if not ok then pushLog("Save failed: "..str(err,500),"Warning","export") end
        end
        if type(clipboard)=="function" then
            local ok,err=pcall(clipboard,text);copied=ok
            if not ok then pushLog("Clipboard failed: "..str(err,500),"Warning","export") end
        end
        if saved then status("SAVED: "..filename);notify("Saved JSON in executor workspace. "..(copied and "Also sent to clipboard." or "Clipboard unavailable."))
        elseif copied then status("COPIED: paste into a text file and send it");notify("JSON sent to clipboard; file saving unavailable.")
        else status("Export APIs unavailable - manual copy");manualCopy(text);notify("Copy all pages in order, not just the first page.") end
        state.oneClickDelivery={filename=saved and filename or nil,saved=saved,copied=copied,bytes=#text}
        if saved then countLabel:SetText("Send file: "..filename) end
    end
    local function collectOneClick()
        if state.oneClickRunning or state.busy or state.exporting then notify("Collection/export already running") return end
        state.oneClickRunning=true
        task.spawn(function()
            local ok,err=pcall(function()
                cfg.maxNodes=15000;cfg.maxSources=500
                state.beforeDiagnostic=runtimeSnapshot()
                state.extraFocusRoots,state.focusDiscovery=discoverFocusedRoots()
                scan("core")
                while state.busy and state.alive do task.wait(0.1) end
                if not state.alive then return end
                local report=state.report
                if not report then error("No report was produced") end
                report.format="CAM Focused Debug OneClick 1.5"
                report.purpose="Missing quest/dialogue/region sources + passive diagnosis of non-working CAM Main"
                report.runtimeBefore=state.beforeDiagnostic
                report.runtimeAfter=runtimeSnapshot()
                report.focusDiscovery=state.focusDiscovery
                report.logs=table.clone(state.logs)
                if report.focusDiscovery.limitReached then report.stats.incomplete=true;report.stats.focusDiscoveryIncomplete=true end
                local text=encodeSafe(report)
                if text and state.alive then deliverText(text) end
            end)
            state.oneClickRunning=false
            if not ok and state.alive then status("Collection failed; retry or send screenshot");notify("Debug error: "..str(err,220)) end
        end)
    end
    Lumen.Folder="cam_oneclick_debug"
    Lumen.ConfigFolder=Lumen.Folder.."/configs";Lumen.ThemeFolder=Lumen.Folder.."/themes"
    local window=Lumen:Window({Name="CAM Debug | ONE CLICK",Version="1.5",Footer="Read-only | no gameplay actions | RightShift menu",Keybind=Enum.KeyCode.RightShift,Size=UDim2.fromOffset(790,440),SettingsPage=false})
    local p=window:Page({Name="collect",Columns=1,Group="debug"})
    local sec=p:Section({Name="everything needed for the main fix",Side=1})
    statusLabel=sec:Label("Ready. Leave CAM Main loaded, but stop its automation.")
    countLabel=sec:Label("One click: focused sources + runtime + save + clipboard")
    sec:Button({Name="COLLECT + SAVE + COPY",Callback=collectOneClick})
    sec:Label("Dialogue, Regions, quest definitions and input/toolbar dependencies.")
    sec:Label("Includes executor/device, local state, logs and CAM Main snapshot.")
    sec:Label("No attacks, require(), remote calls, hooks or HTTP upload.")
    sec:Label("Missing sources/timeouts are reported; not silently treated as success.")
    sec:Label("Send CAM_Debug_OneClick_*.json from your executor workspace.")
    sec:Button({Name="Cancel scan (export partial result)",Callback=function()
        state.cancel=true
        if state.exporting then state.cancelExport=true end
        if state.sourceTask then pcall(task.cancel,state.sourceTask) end
    end})
    sec:Button({Name="Export cached result again",Callback=function()
        if state.busy or state.exporting or state.oneClickRunning then notify("Wait for collection") return end
        if not state.report then notify("Collect first") return end
        local text=encodeSafe(state.report);if text then deliverText(text) end
    end})
    sec:Button({Name="Unload debug",Callback=function() Lumen:Unload() end})
    notify("Press COLLECT + SAVE + COPY once. Keep the main hub loaded for diagnostics.")
end
RunCollector(Lumen)

    -- Passive recorder. No outgoing remote hooks, synthetic input, stat writes or game require().
    local function recordMechanics()
        local RS=game:GetService("ReplicatedStorage")
        local rec={durationRequested=90,intervalSeconds=0.5,startedUTC=os.date("!%Y-%m-%dT%H:%M:%SZ"),events={},samples={},uiSnapshots={},mainTransitions={},mainLogs={},errors={},limits={},
            note="Client observations only: HP change/removal is not proof of server kill, loot, EXP, attribution or infinite stamina."}
        local start=os.clock();local lastMap,lastMain,seenLogs={},{},{};local watched={};local connections={};local running=true
        local npcIds,nextNpcId={},0
        local lastSlow=-100;local lastSample=-100;local lastUI=-100;local ticks=0;local lastTick=start
        local function time() return math.floor((os.clock()-start)*1000)/1000 end
        local function errorRow(where,err) if #rec.errors<50 then rec.errors[#rec.errors+1]={time=time(),where=where,error=str(err,700)} else rec.limits.errors=true end end
        local function emit(kind,record)
            if #rec.events>=6000 then rec.limits.events=true;return end
            record.kind=kind;record.time=time();rec.events[#rec.events+1]=record
        end
        local function attrs(o)
            local result={};if not o then return result end
            local ok,a=pcall(function() return o:GetAttributes() end)
            if ok then local n=0;for k,v in pairs(a) do n=n+1;if n>40 then rec.limits.attributes=true;break end;result[str(k,100)]=value(v) end end
            return result
        end
        local function xyz(p)
            if not p then return nil end
            local ok,v=pcall(function() return p.Position end)
            if ok and v then return {x=v.X,y=v.Y,z=v.Z} end
        end
        local function watchSignal(signal,fn)
            if not signal then return end
            local ok,c=pcall(function() return signal:Connect(function(...)
                if not running or not state.alive then return end
                local success,err=pcall(fn,...);if not success then errorRow("event",err) end
            end) end)
            if ok then connections[#connections+1]=c end
        end
        local function localData()
            local root=resolveNames(RS,{"Player_Service","Data",LP.Name});local slot=root and root:FindFirstChild("slotEquipped")
            return slot and resolveNames(root,{"slots","Slot"..tostring(slot.Value)})
        end
        local function addValues(map,root,label,limit,depthLimit)
            if not root then map[label.."/@missing"]=true;return end
            local q={{o=root,depth=0,key=label}};local head=1;local count=0
            while head<=#q and count<limit do
                local entry=q[head];head=head+1;count=count+1;local o=entry.o
                if o:IsA("ValueBase") then
                    local ok,v=pcall(function() return o.Value end)
                    if ok then map[entry.key]=value(v) end
                    for _,key in ipairs({"MinValue","MaxValue"}) do local ok,v=pcall(function() return o[key] end);if ok and v~=nil then map[entry.key.."/"..key]=value(v) end end
                end
                if entry.depth<depthLimit then
                    for _,child in ipairs(o:GetChildren()) do
                        local lower=child.Name:lower()
                        local roster=label:sub(1,5)=="Mode/" and (lower=="players" or lower=="playerdata" or lower=="members" or lower=="roster")
                        if not roster then
                            if #q<limit then q[#q+1]={o=child,depth=entry.depth+1,key=entry.key.."/"..child.Name} else rec.limits[label]=true end
                        end
                    end
                elseif #o:GetChildren()>0 then rec.limits[label.."Depth"]=true end
            end
            if head<=#q then rec.limits[label]=true end
        end
        local function mainSample()
            local hub=env.CAMMainHub
            if type(hub)~="table" then return {present=false} end
            local report=type(hub.Snapshot)=="function" and hub.Snapshot() or {}
            local s=report.state or hub.State or {};local f=report.farm or {}
            local m={present=true,version=hub.Version,status=s.status,autoLevel=s.autoLevel,farm=s.farm,attack=s.attack,
                questStage=s.questStage,questName=s.questName,questProgress=s.questProgress,equipment=s.equipment,
                hpStop=s.healthStop,noDamageTimeout=s.noDamageTimeout,backend=f.backend,level=f.level,
                requests=f.requests,comboAcks=f.comboAcks,damageObservations=f.damageObservations,target=report.target}
            for _,entry in ipairs(report.log or {}) do
                local key=tostring(entry.time).."|"..tostring(entry.kind).."|"..tostring(entry.text)
                if not seenLogs[key] then
                    seenLogs[key]=true
                    if #rec.mainLogs<500 then rec.mainLogs[#rec.mainLogs+1]={observedAt=time(),time=entry.time,kind=entry.kind,text=entry.text} else rec.limits.mainLogs=true end
                end
            end
            if m.status~=lastMain.status or m.autoLevel~=lastMain.autoLevel or m.questStage~=lastMain.questStage or m.present~=lastMain.present then
                if #rec.mainTransitions<350 then
                    local why=lastMain.autoLevel==true and m.autoLevel==false and "AutoLevel transitioned ON -> OFF" or "Main state changed"
                    rec.mainTransitions[#rec.mainTransitions+1]={time=time(),reason=why,before=lastMain,after=m}
                else rec.limits.mainTransitions=true end
            end
            lastMain=m;return m
        end
        local function guiSnapshot()
            local root=LP:FindFirstChild("PlayerGui");local rows={};if not root then return rows end
            local queue={{o=root,visible=true}};local head=1;local walked=0
            while head<=#queue and walked<6000 do
                local e=queue[head];head=head+1;walked=walked+1;local o=e.o;local p=path(o);local lower=p:lower()
                local own=lower:find("cam_main",1,true) or lower:find("cam_debug",1,true) or o==Lumen.State.Screen
                local private=lower:find("chat",1,true) or lower:find("playerlist",1,true) or o:IsA("TextBox")
                if not own and not private then
                    local visible=e.visible
                    if o:IsA("GuiObject") then visible=visible and o.Visible elseif o:IsA("ScreenGui") then visible=visible and o.Enabled end
                    local groups=mechanismGroups(p)
                    if visible and #groups>0 and (o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("Frame") or o:IsA("ImageButton")) then
                        if #rows<180 then rows[#rows+1]={path=p,class=o.ClassName,groups=groups,properties=properties(o,{"Text","Visible","Position","Size","AbsolutePosition","AbsoluteSize"})}
                        else rec.limits.uiRows=true end
                    end
                    for _,child in ipairs(o:GetChildren()) do if #queue<6000 then queue[#queue+1]={o=child,visible=visible} else rec.limits.uiWalk=true end end
                end
            end
            if head<=#queue then rec.limits.uiWalk=true end
            return rows
        end
        local function npcSample()
            local root=workspace:FindFirstChild("Humanoids")
            if not root then return {missingRoot=true,note="Workspace.Humanoids is unavailable; no full map scan performed"} end
            local c=LP.Character;local myRoot=c and c:FindFirstChild("HumanoidRootPart")
            local q={root};local head=1;local candidates={}
            while head<=#q and head<=4000 do
                local o=q[head];head=head+1
                if o:IsA("Humanoid") then
                    local model=o.Parent
                    if model and model~=c and not Players:GetPlayerFromCharacter(model) then
                        local p=model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart
                        local distance=myRoot and p and (myRoot.Position-p.Position).Magnitude or math.huge
                        if distance<200 then candidates[#candidates+1]={model=model,h=o,p=p,distance=distance} end
                    end
                elseif o:IsA("Folder") or o:IsA("Model") or o==root then
                    for _,child in ipairs(o:GetChildren()) do if #q<4000 then q[#q+1]=child else rec.limits.npcWalk=true end end
                end
            end
            if head<=#q then rec.limits.npcWalk=true end
            table.sort(candidates,function(a,b) return a.distance<b.distance end)
            local rows={}
            for i=1,math.min(12,#candidates) do
                local n=candidates[i];local model,h,p=n.model,n.h,n.p
                local owner="unavailable";local fn=isnetworkowner or env.isnetworkowner
                if type(fn)=="function" and p then local ok,v=pcall(fn,p);if ok then owner=v and "local client" or "not local client" end end
                if not npcIds[model] then nextNpcId=nextNpcId+1;npcIds[model]=nextNpcId end
                local row={id=npcIds[model],path=path(model),name=model.Name,distance=n.distance,position=xyz(p),health=h.Health,maxHealth=h.MaxHealth,attributes=attrs(model),ownership=owner,
                    root=properties(p or model,{"Anchored","AssemblyLinearVelocity"}),humanoid=properties(h,{"PlatformStand","Sit","BreakJointsOnDeath"})}
                rows[#rows+1]=row
                if watched[model] then watched[model].health=row.health end
                if not watched[model] and rec.npcWatchCount~=nil and rec.npcWatchCount>=50 then rec.limits.npcWatches=true
                elseif not watched[model] then
                    watched[model]={health=row.health};rec.npcWatchCount=(rec.npcWatchCount or 0)+1
                    watchSignal(h.HealthChanged,function(hp) watched[model].health=hp;emit("npcHealth",{id=row.id,path=path(model),health=hp,position=xyz(p)}) end)
                    watchSignal(h.Died,function() emit("npcDiedEvent",{id=row.id,path=path(model),note="Client event, not confirmation of server reward"}) end)
                    watchSignal(model.AncestryChanged,function()
                        if not model:IsDescendantOf(workspace) then emit("npcNoLongerInWorkspace",{id=row.id,path=row.path,lastObservedHealth=watched[model].health,note="Not proof of death or reward"}) end
                    end)
                    local animator=h:FindFirstChildOfClass("Animator")
                    if animator then watchSignal(animator.AnimationPlayed,function(track)
                        local anim=track.Animation
                        emit("npcAnimation",{id=row.id,path=path(model),name=track.Name,animationId=anim and anim.AnimationId or nil,length=track.Length,speed=track.Speed})
                    end) end
                end
            end
            return rows
        end
        local function tick()
            local now=os.clock();ticks=ticks+1
            if now-lastTick>2 then emit("samplingGap",{seconds=now-lastTick}) end;lastTick=now
            local d=localData();local c=LP.Character;local h=c and c:FindFirstChildOfClass("Humanoid");local root=c and c:FindFirstChild("HumanoidRootPart")
            local map={}
            addValues(map,resolveNames(RS,{"Player_Service","Values",LP.Name}),"Values",350,4)
            addValues(map,LP:FindFirstChild("Items_Config"),"Equipped",30,2)
            addValues(map,LP:FindFirstChild("MenuDestination"),"Menu",3,0)
            for _,name in ipairs({"Exp","Wen","Race","Quests","Powers","SkillTreeUnlockedList"}) do addValues(map,d and d:FindFirstChild(name),name,name=="Quests" and 220 or 100,6) end
            addValues(map,c and c:FindFirstChild("SHC"),"SHC",20,2);addValues(map,c and c:FindFirstChild("SHCS"),"SHCS",20,2)
            addValues(map,resolveNames(RS,{"CAM","Client","Controllers","Skills_Provider","CurPower"}),"CurPower",3,0)
            local modeRoots=0
            for _,container in ipairs({RS,LP}) do
                for _,child in ipairs(container:GetChildren()) do
                    local n=child.Name:lower()
                    if (child:IsA("Folder") or child:IsA("Configuration") or child:IsA("ValueBase")) and
                        (n:find("minigame",1,true) or n:find("gamestate",1,true) or n:find("round",1,true) or n:find("queue",1,true) or n:find("wave",1,true)) then
                        modeRoots=modeRoots+1
                        if modeRoots<=6 then addValues(map,child,"Mode/"..container.Name.."/"..child.Name,80,3) else rec.limits.modeRoots=true end
                    end
                end
            end
            if h then map["Character/Health"]=h.Health;map["Character/MaxHealth"]=h.MaxHealth;map["Character/WalkSpeed"]=h.WalkSpeed end
            for label,obj in pairs({Player=LP,Character=c,World=workspace,Replicated=RS}) do for k,v in pairs(attrs(obj)) do map[label.."/@"..k]=v end end
            for k,v in pairs(map) do if type(v)=="table" then local ok,s=pcall(function() return Http:JSONEncode(v) end);map[k]=ok and s or tostring(v) end end
            for k,v in pairs(map) do if lastMap[k]~=v then emit(lastMap[k]==nil and "initialOrAddedValue" or "valueChanged",{path=k,value=v,previous=lastMap[k]}) end end
            for k,v in pairs(lastMap) do if map[k]==nil then emit("valueRemoved",{path=k,previous=v}) end end
            lastMap=map
            if now-lastSample>=1 then
                lastSample=now
                local ok,main=pcall(mainSample);if not ok then errorRow("mainSnapshot",main);main={error=str(main,300)} end
                local row={time=time(),main=main,position=xyz(root),humanoid=h and properties(h,{"Health","MaxHealth","WalkSpeed","PlatformStand","Sit"}) or {},
                    stamina=map["Values/Stamina"],staminaMax=map["Values/Stamina/MaxValue"],exp=map["Exp/Current"],expGoal=map["Exp/Goal"],wen=map.Wen}
                if now-lastSlow>=2 then lastSlow=now;local ok,result=pcall(npcSample);if ok then row.npcs=result else errorRow("NPC sample",result) end end
                if #rec.samples<100 then rec.samples[#rec.samples+1]=row else rec.limits.samples=true end
            end
            if now-lastUI>=15 then lastUI=now;local ok,rows=pcall(guiSnapshot);if ok then rec.uiSnapshots[#rec.uiSnapshots+1]={time=time(),rows=rows} else errorRow("UI snapshot",rows) end end
            state.recordRemaining=math.max(0,math.ceil(90-(now-start)))
            if countLabel then pcall(function() countLabel:SetText("Recording: "..state.recordRemaining.."s left | "..#rec.events.." changes | keep using the game") end) end
        end
        local portal=resolveNames(RS,{"Communication","CnC","NotEnoughStamina"})
        if portal and portal:IsA("BindableEvent") then watchSignal(portal.Event,function(amount) emit("NotEnoughStamina",{amount=value(amount)}) end) end
        local handle={report=rec,done=false}
        local function close()
            if not running then return end
            running=false
            for _,c in ipairs(connections) do pcall(function() c:Disconnect() end) end
            rec.durationActual=time();rec.ticks=ticks;rec.finishedEarly=state.requestFinish==true or not state.alive
            rec.incomplete=rec.finishedEarly or next(rec.limits)~=nil or #rec.errors>0
            handle.done=true
        end
        handle.stop=close
        handle.thread=task.spawn(function()
            local ok,err=pcall(function()
                while running and state.alive and not state.requestFinish and os.clock()-start<90 do
                    local good,e=pcall(tick);if not good then errorRow("tick",e) end
                    task.wait(0.5)
                end
            end)
            if not ok then errorRow("recorder",err) end
            close()
        end)
        return handle
    end
    local function enrichDiscovery(report,discovery)
        report.discovery=discovery
        if discovery.limitReached or discovery.selectionLimitReached or discovery.remoteLimitReached or discovery.referenceLimitReached or #discovery.errors>0 then
            report.stats.incomplete=true;report.stats.discoveryIncomplete=true
        end
        state.scannedPaths=state.scannedPaths or {}
        for _,scriptRecord in ipairs(report.scripts or {}) do state.scannedPaths[scriptRecord.path]=true end
    end
    local function collectOneClick()
        if state.oneClickRunning or state.busy or state.exporting then notify("Collection/export already running") return end
        state.oneClickRunning=true;state.requestFinish=false;state.cancel=false;state.scannedPaths={};state.latePass=false
        task.spawn(function()
            local ok,err=pcall(function()
                local started=os.clock();state.sourceDeadline=started+85
                state.beforeDiagnostic=runtimeSnapshot()
                state.recorder=recordMechanics()
                cfg.maxNodes=500;cfg.maxSources=350
                local passes={}
                local function sourcePass(label)
                    state.extraFocusRoots,state.focusDiscovery=discoverFocusedRoots()
                    if #state.extraFocusRoots==0 then
                        local empty={pass=label,scripts={},stats={sourcesCollected=0,sourceBytes=0,incomplete=false},note="No additional selected source in this pass"}
                        enrichDiscovery(empty,state.focusDiscovery);passes[#passes+1]=empty;return
                    end
                    state.report=nil;scan("core")
                    while state.busy and state.alive do task.wait(0.1) end
                    if not state.report then error("Source scan returned no report") end
                    local r=state.report;r.format="CAM Mechanics Sources 1.7";r.pass=label;enrichDiscovery(r,state.focusDiscovery);passes[#passes+1]=r
                end
                sourcePass("initial")
                while state.alive and not state.recorder.done do task.wait(0.1) end
                if not state.alive then return end
                if not state.requestFinish then
                    state.latePass=true;state.sourceDeadline=os.clock()+25;cfg.maxSources=80
                    sourcePass("late: newly appeared or previously uncollected scripts")
                end
                local report={format="CAM Mechanics Recorder OneClick 1.7",createdUTC=os.date("!%Y-%m-%dT%H:%M:%SZ"),
                    game={placeId=game.PlaceId,universeId=game.GameId,placeVersion=game.PlaceVersion},
                    purpose="Remaining mechanic implementations and intermittent main STOP diagnosis; passive evidence, not bypass testing",
                    runtimeBefore=state.beforeDiagnostic,runtimeAfter=runtimeSnapshot(),recording=state.recorder.report,sourcePasses=passes,
                    stats={durationSeconds=os.clock()-started,sourcesCollected=0,sourceBytes=0,incomplete=state.recorder.report.incomplete},
                    logs=table.clone(state.logs),
                    capabilities={writefile=type(fileWriter)=="function",clipboard=type(clipboard)=="function",decompile=type(decompiler)=="function",
                        getsenv=type(getsenv or env.getsenv)=="function",isnetworkowner=type(isnetworkowner or env.isnetworkowner)=="function"},
                    limitations={"Only client-visible state and replicated source; inaccessible server handlers are not recovered.",
                        "No require, attacks, purchases, remote calls, outgoing interception, stat modification or NPC deletion.",
                        "Recording observes user/main actions; it does not perform the demonstrated actions for you.",
                        "Record separately after entering another mode/place. The collector does not persist across teleport.",
                        "Sources/models/packages and trace fields have documented bounds; incomplete flags describe limits, not full game coverage.",
                        "Known unrelated sources on the same place/version may be referenced rather than copied. Decompilation is unverified.",
                        "Logs and game source can contain private data; review before sharing. No HTTP upload is performed."}}
                for _,pass in ipairs(passes) do
                    report.stats.sourcesCollected=report.stats.sourcesCollected+(pass.stats.sourcesCollected or 0)
                    report.stats.sourceBytes=report.stats.sourceBytes+(pass.stats.sourceBytes or 0)
                    if pass.stats.incomplete then report.stats.incomplete=true end
                end
                state.report=report
                local text=encodeSafe(report);if text and state.alive then deliverText(text) end
            end)
            if state.recorder and not state.recorder.done then state.recorder.stop() end
            state.oneClickRunning=false
            if not ok and state.alive then
                pushLog("Mechanics collection failed: "..str(err,2000),"Error","collector")
                -- Preserve observations even if discovery or source collection failed.
                local partial={format="CAM Mechanics Recorder OneClick 1.7",error=str(err,3000),stats={incomplete=true},
                    runtimeBefore=state.beforeDiagnostic,recording=state.recorder and state.recorder.report,partialSourcePass=state.report,logs=table.clone(state.logs)}
                state.report=partial;local text=encodeSafe(partial);if text then deliverText(text) end
                notify("Partial report saved where possible; collector error is included")
            end
        end)
    end
    Lumen.Folder="cam_mechanics_debug"
    Lumen.ConfigFolder=Lumen.Folder.."/configs";Lumen.ThemeFolder=Lumen.Folder.."/themes"
    local window=Lumen:Window({Name="CAM Debug | MECHANICS + STOP TRACE",Version="1.7",Footer="Passive recording | RightShift menu | no gameplay changes",Keybind=Enum.KeyCode.RightShift,Size=UDim2.fromOffset(860,560),SettingsPage=false})
    local p=window:Page({Name="one click",Columns=1,Group="debug"})
    local sec=p:Section({Name="mechanics / auto-level stop reasons",Side=1})
    statusLabel=sec:Label("Ready. Keep CAM Main loaded. It may continue farming during recording.")
    countLabel=sec:Label("Press once -> act normally for 90 seconds -> automatic JSON save + copy")
    sec:Button({Name="START 90s + COLLECT + SAVE + COPY",Callback=collectOneClick})
    sec:Label("Use the game: farm, run/dash, block, fish or open the relevant menu.")
    sec:Label("Main OFF transitions, HP/stamina/EXP, quests, nearby NPCs and animations.")
    sec:Label("Fishing, training, skills, shops, queues, waves/cards and current-mode scripts.")
    sec:Label("Records available sources initially and checks for newly appeared scripts at the end.")
    sec:Label("No purchases, attacks, require(), hooks, remote requests, stat edits or HTTP upload.")
    sec:Label("Finish can take ~25 more seconds for late sources. Limits/errors are reported.")
    sec:Label("Send CAM_Debug_Mechanics_*.json from your executor workspace.")
    sec:Button({Name="FINISH NOW - save partial recording",Callback=function()
        state.requestFinish=true;state.cancel=true
        if state.sourceTask then pcall(task.cancel,state.sourceTask) end
    end})
    sec:Button({Name="Save + copy last report again",Callback=function()
        if state.busy or state.exporting or state.oneClickRunning then notify("Wait for collection") return end
        if not state.report then notify("Record first") return end
        local text=encodeSafe(state.report);if text then deliverText(text) end
    end})
    sec:Button({Name="Unload debug",Callback=function() Lumen:Unload() end})
    notify("Mechanics recorder ready. Press START once; keep main loaded to capture its STOP reason.")
end
RunCollector(Lumen)

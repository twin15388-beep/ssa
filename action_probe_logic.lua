
do
    -- CAM ActionProbe 1.1 | targeted action recorder for feature research.
    -- Passive recorder: it WATCHES game signals / UI / data while YOU perform one
    -- scripted action by hand. It never fires gameplay requests, buys nothing, edits
    -- no stats, and restores everything it wrapped on STOP.
    local RS=game:GetService("ReplicatedStorage")
    local Players=game:GetService("Players")
    local Run=game:GetService("RunService")
    local Http=game:GetService("HttpService")
    local LP=Players.LocalPlayer
    local Env=(typeof and typeof(getgenv)=="function") and getgenv() or _G
    if Env.CAMActionProbe then pcall(function() Env.CAMActionProbe.Stop() end) end
    local T={scenario="(not set)",recording=false,startedAt=nil,signals={},buttons={},deltas={},sources={},markers={},errors={},taps={},connections={},wrapped={},hooked={},lastMap=nil,elapsed=0,seenFns=setmetatable({},{__mode="k"}),seenButtons=setmetatable({},{__mode="k"}),namecallOn=false}
    local MAX={signals=1500,buttons=600,deltas=2500,nodes=4000,sources=120,sourceBytes=150000,scan=60000,duration=180}
    local SOURCE_ID="CAM ActionProbe 1.1"
    local function clock() return os.clock() end
    local function short(v,n) local s=tostring(v);if #s>(n or 700) then return s:sub(1,(n or 700)-3).."..." end return s end
    -- JSON-safe deep-ish serializer for signal arguments (Instances -> paths).
    local function ser(v,depth)
        local tv=type(v)
        if tv=="number" or tv=="boolean" then return v end
        if tv=="string" then return v end
        if tv=="table" then
            if (depth or 0)>=2 then return "table:"..short(tostring(v),60) end
            local out={};local n=0
            for k,x in pairs(v) do
                n=n+1;if n>8 then out[n]="..." break end
                out[n]={k=ser(k,(depth or 0)+1),v=ser(x,(depth or 0)+1)}
            end
            return out
        end
        if typeof and typeof(v)=="Instance" then local ok,p=pcall(function() return v:GetFullName() end);return ok and ("inst:"..p) or "inst" end
        local ok,s=pcall(tostring,v);return ok and short(s,120) or "unserializable"
    end
    local function serArgs(args)
        local out={}
        for i=1,args.n or #args do out[i]=ser(args[i],0) end
        return out
    end
    local gui
    local statusLabel,countLabel,scanLabel,tapLabel
    local function note(msg)
        if statusLabel then statusLabel:SetText(short(msg,110)) end
        pcall(function() Lumen:Notification({Title="CAM Probe",Description=msg,Duration=4}) end)
    end
    local function recSignal(dir,modName,key,args,res)
        if not T.recording or #T.signals>=MAX.signals then return end
        local row={t=clock(),dir=dir,mod=modName,fn=key,args=serArgs(args)}
        if res then row.ret=serArgs(res) end
        T.signals[#T.signals+1]=row
    end
    -- ---- signal taps (client -> server functions, server -> client event tables) ----
    local hookFn=(type(hookfunction)=="function") and hookfunction or nil
    local restoreFn=(type(restorefunction)=="function") and restorefunction or nil
    local function attachC2S(mod,m,k,orig)
        if T.seenFns[orig] then return end
        T.seenFns[orig]=true
        if hookFn then
            local old
            local ok=pcall(function()
                old=hookFn(orig,function(...)
                    local r=table.pack(old(...))
                    recSignal("C2S",mod:GetFullName(),k,table.pack(...),r)
                    return table.unpack(r,1,r.n)
                end)
            end)
            if ok and old then
                T.hooked[#T.hooked+1]={orig=orig}
                T.taps[#T.taps+1]=mod.Name.."."..k.." (hookfunction)"
                return
            end
        end
        -- fallback: replace the field on the shared module table (misses pre-localized refs)
        local ok=pcall(function()
            m[k]=function(...)
                local r=table.pack(orig(...))
                recSignal("C2S",mod:GetFullName(),k,table.pack(...),r)
                return table.unpack(r,1,r.n)
            end
        end)
        if ok then
            T.wrapped[#T.wrapped+1]={m=m,k=k,orig=orig}
            T.taps[#T.taps+1]=mod.Name.."."..k.." (table wrap)"
        end
    end
    local function attachS2C(mod,k,ev)
        if T.seenFns[ev] then return end
        T.seenFns[ev]=true
        local connect=ev.Connect or ev.connect
        if type(connect)~="function" then return end
        local ok,con=pcall(function()
            return connect(ev,function(...)
                recSignal("S2C",mod:GetFullName(),k,table.pack(...))
            end)
        end)
        if ok and con then T.connections[#T.connections+1]=con;T.taps[#T.taps+1]=mod.Name.."."..k.." (S2C subscribe)" end
    end
    local function attachModule(mod)
        local ok,m=pcall(require,mod)
        if not ok or type(m)~="table" then return end
        for k,v in pairs(m) do
            local tk=type(v)
            if tk=="function" and (k:find("ToServer",1,true) or k=="FireServer" or k=="InvokeServer") then
                local okA,errA=pcall(attachC2S,mod,m,k,v)
                if not okA then T.errors[#T.errors+1]="tap "..mod.Name.."."..k..": "..short(errA,120) end
            elseif tk=="table" and (type(v.Connect)=="function" or type(v.connect)=="function") then
                local okA,errA=pcall(attachS2C,mod,k,v)
                if not okA then T.errors[#T.errors+1]="subscribe "..mod.Name.."."..k..": "..short(errA,120) end
            end
        end
    end
    local function attachAll()
        local comm=RS:FindFirstChild("Communication")
        if comm then for _,d in ipairs(comm:GetDescendants()) do if d:IsA("ModuleScript") then attachModule(d) end end end
        if #T.taps==0 then
            -- generic fallback: any ModuleScript under ReplicatedStorage with ToServer
            for _,d in ipairs(RS:GetDescendants()) do
                if d:IsA("ModuleScript") and d.Name:lower():find("signal",1,true) then attachModule(d) end
            end
        end
        -- raw-remote spy: some actions (shop purchase) fire RemoteEvent/RemoteFunction directly.
        if not T.namecallOn and type(hookmetamethod)=="function" then
            local mt=hookmetamethod
            local ncc=(type(newcclosure)=="function") and newcclosure or function(f) return f end
            local perPath={};local no0
            local ok=pcall(function()
                no0=mt(game,"__namecall",ncc(function(self,...)
                    local nca=table.pack(self,...)
                    local method="?"
                    if type(getnamecallmethod)=="function" then local okM,m=pcall(getnamecallmethod);if okM then method=m end end
                    if T.recording and (method=="FireServer" or method=="InvokeServer") then
                        local path="?";pcall(function() path=self:GetFullName() end)
                        perPath[path]=(perPath[path] or 0)+1
                        if perPath[path]<=80 then
                            local args=table.pack(...);args.n=args.n or #args
                            if method=="InvokeServer" then
                                local r=table.pack(no0(table.unpack(nca,1,nca.n)))
                                recSignal("C2S.remote",path,method,args,r)
                                return table.unpack(r,1,r.n)
                            end
                            recSignal("C2S.remote",path,method,args)
                        end
                    end
                    return no0(table.unpack(nca,1,nca.n))
                end))
            end)
            if ok and no0 then
                T.namecallOn=true;T.namecallHook=mt;T.namecallOrig=no0
                T.taps[#T.taps+1]="__namecall remote spy (hookmetamethod)"
            else
                T.errors[#T.errors+1]="hookmetamethod failed: raw remotes not tapped"
            end
        end
        T.markers[#T.markers+1]={t=clock(),text="ATTACH | taps now: "..#T.taps}
    end
    -- ---- UI button watcher ----
    local ownGui
    local function watchButton(d)
        if not d:IsA("GuiButton") then return end
        if T.seenButtons[d] then return end
        T.seenButtons[d]=true
        local okName,p0=pcall(function() return d:GetFullName() end)
        if okName and p0:find("CAM Probe",1,true) then return end
        if ownGui and pcall(function() return d:IsDescendantOf(ownGui) end) and d:IsDescendantOf(ownGui) then return end
        if #T.connections>4000 then return end
        local ok,con=pcall(function()
            return d.Activated:Connect(function()
                if T.recording and #T.buttons<MAX.buttons then
                    T.buttons[#T.buttons+1]={t=clock(),path=d:GetFullName()}
                end
            end)
        end)
        if ok and con then T.connections[#T.connections+1]=con end
    end
    local function watchUI()
        local pg=LP:FindFirstChild("PlayerGui")
        if not pg then return end
        for _,d in ipairs(pg:GetDescendants()) do watchButton(d) end
        T.connections[#T.connections+1]=pg.DescendantAdded:Connect(function(d) if T.recording then watchButton(d) end end)
    end
    -- ---- data delta watcher ----
    local function flatten(node,path,map,depth,count)
        if depth>6 or count[1]>MAX.nodes then return end
        count[1]=count[1]+1
        map[path]=(node:IsA("ValueBase") and short(node.Value,100)) or ("#"..#node:GetChildren())
        for _,ch in ipairs(node:GetChildren()) do flatten(ch,path.."/"..ch.Name,map,depth+1,count) end
    end
    local function deltaRoots()
        local roots={}
        local svc=RS:FindFirstChild("Player_Service")
        local d=svc and svc:FindFirstChild("Data") and svc.Data:FindFirstChild(LP.Name)
        local v=svc and svc:FindFirstChild("Values") and svc.Values:FindFirstChild(LP.Name)
        local ic=LP:FindFirstChild("Items_Config")
        if d then roots[#roots+1]={d,"Data"} end
        if v then roots[#roots+1]={v,"Values"} end
        if ic then roots[#roots+1]={ic,"Items_Config"} end
        return roots
    end
    local function snapshotData()
        local map={}
        for _,r in ipairs(deltaRoots()) do flatten(r[1],r[2],map,1,{0}) end
        return map
    end
    local function deltaStep()
        if not T.lastMap then return end
        local now=snapshotData()
        for path,new in pairs(now) do
            local old=T.lastMap[path]
            if old~=new then
                if #T.deltas<MAX.deltas then T.deltas[#T.deltas+1]={t=clock(),path=path,old=old,new=new} end
            end
        end
        for path,old in pairs(T.lastMap) do
            if now[path]==nil and #T.deltas<MAX.deltas then T.deltas[#T.deltas+1]={t=clock(),path=path,old=old,new="(removed)"} end
        end
        T.lastMap=now
    end
    -- ---- targeted source dump ----
    local KEYWORDS={"skill","tree","breath","fish","rod","bait","shop","purchase","buy","train","pushup","meditat","queue","dungeon","card","wave","ranked","race","demon","soul","schemat","deliver","parry","vendor","merchant","redeem","spin","crystal"}
    local function isCandidate(d)
        if not (d:IsA("LocalScript") or d:IsA("ModuleScript")) then return false end
        local ok,p=pcall(function() return d:GetFullName() end)
        if not ok then return false end
        p=p:lower()
        if ownGui and p:find("probe",1,true) then return false end
        for _,w in ipairs(KEYWORDS) do if p:find(w,1,true) then return true end end
        return false
    end
    local function scanSources()
        local dec=decompile
        local found,scanned=0,0
        for _,d in ipairs(game:GetDescendants()) do
            scanned=scanned+1;if scanned>MAX.scan or found>=MAX.sources then break end
            if isCandidate(d) then
                local path=d:GetFullName()
                if not T.sources[path] then
                    local row={path=path,class=d.ClassName}
                    if type(dec)=="function" then
                        local ok,src=pcall(dec,d)
                        if ok and type(src)=="string" and #src>0 and not src:find("failed to decompile",1,true) then
                            row.bytes=#src;row.source=short(src,MAX.sourceBytes)
                        else row.error=short(src,160) end
                    else row.error="decompile() unavailable" end
                    T.sources[path]=row;found=found+1
                end
            end
        end
        if scanLabel then scanLabel:SetText("Target scripts dumped: "..found.." (total "..found+0 ..")") end
        return found
    end
    -- ---- report ----
    local function buildReport()
        local sources={}
        for _,row in pairs(T.sources) do sources[#sources+1]=row end
        table.sort(sources,function(a,b) return a.path<b.path end)
        return {
            format=SOURCE_ID,timeUTC=os.date("!%Y-%m-%dT%H:%M:%SZ"),placeId=game.PlaceId,placeVersion=game.PlaceVersion,
            scenario=T.scenario,markers=T.markers,
            stats={signals=#T.signals,buttons=#T.buttons,deltas=#T.deltas,sources=#sources,recordingSec=T.startedAt and (clock()-T.startedAt) or 0},
            taps=T.taps,signals=T.signals,buttons=T.buttons,deltas=T.deltas,sources=sources,errors=T.errors,
            note="Observed client signals / UI / data only: NOT proof of server acceptance. No credentials or webhooks collected.",
        }
    end
    local function exportReport()
        local d=buildReport();local ok,text=pcall(function() return Http:JSONEncode(d) end)
        if not ok then text=PortableJSON(d,{error=tostring(text)}) end
        local name="CAM_ActionProbe_"..os.date("!%Y%m%d_%H%M%S")..".json";local saved,copied=false,false
        if type(writefile)=="function" then saved=pcall(writefile,name,text) end
        local fn=setclipboard or toclipboard or (Clipboard and Clipboard.set)
        if type(fn)=="function" then copied=pcall(fn,text) end
        note((saved and "Saved "..name or "File save unavailable").." | "..(copied and "Clipboard accepted" or "Clipboard unavailable"))
    end
    -- ---- start / stop ----
    local hb,hbAcc=nil,0
    local function stopTap(reason)
        if not T.recording then return end
        T.recording=false
        T.markers[#T.markers+1]={t=clock(),text="recording stopped: "..(reason or "manual")}
        note("Recording stopped ("..(reason or "manual").."). Now export.")
    end
    local function startTap()
        if T.recording then note("Already recording") return end
        T.recording=true;T.startedAt=clock();hbAcc=0
        pcall(function() T.lastMap=snapshotData() end)
        T.markers[#T.markers+1]={t=clock(),text="recording started | scenario: "..T.scenario}
        note("Recording. Perform ONE action now: "..T.scenario)
    end
    hb=Run.Heartbeat:Connect(function(dt)
        if not T.recording then return end
        hbAcc=hbAcc+dt
        if hbAcc>=0.4 then hbAcc=0;local ok,err=pcall(deltaStep);if not ok then T.errors[#T.errors+1]="delta: "..short(err,120);T.lastMap=nil end end
        if T.startedAt and clock()-T.startedAt>MAX.duration then stopTap("auto "..MAX.duration.."s") end
    end)
    -- ---- UI ----
    Lumen.Folder="cam_action_probe";Lumen.ConfigFolder=Lumen.Folder.."/configs";Lumen.ThemeFolder=Lumen.Folder.."/themes"
    local window=Lumen:Window({Name="CAM PROBE | action recorder",Version="1.1",Footer="RightShift menu | passive tap, perform actions yourself",Size=UDim2.fromOffset(860,600),Keybind=Enum.KeyCode.RightShift,SettingsPage=false})
    ownGui=(Lumen.State and (Lumen.State.Screen or Lumen.State.ScreenGui)) or nil
    local page=window:Page({Name="probe",Columns=2,Group="main"})
    local function section(name,side) return page:Section({Name=name,Side=side or 1}) end
    local rs=section("recorder")
    statusLabel=rs:Label("Idle. Scan first, then record one action at a time.")
    local function refreshCounts()
        if countLabel then countLabel:SetText("signals "..#T.signals.." | buttons "..#T.buttons.." | deltas "..#T.deltas.." | sources "..(function() local n=0 for _ in pairs(T.sources) do n=n+1 end return n end)().." | taps "..#T.taps) end
    end
    countLabel=rs:Label("signals 0 | buttons 0 | deltas 0 | sources 0 | taps 0")
    rs:Button({Name="1) ATTACH taps (signals / buttons / data watchers)",Confirm=false,Callback=function()
        local ok,err=pcall(function()
            attachAll();watchUI()
            refreshCounts()
            note(#T.taps>0 and ("Attached "..#T.taps.." taps. Pick a scenario, then START.") or "No signal modules found; still recording UI buttons + data.")
        end)
        if not ok then T.errors[#T.errors+1]="attach: "..short(err,140);note("Attach failed: "..short(err,80)) end
    end})
    rs:Button({Name="2) START recording (then perform the action)",Confirm=false,Callback=startTap})
    rs:Button({Name="3) STOP recording",Confirm=false,Callback=function() stopTap("manual") end})
    rs:Button({Name="Refresh counts",Confirm=false,Callback=refreshCounts})
    rs:Label("Taps attach once; recording can start/stop per action.")
    local ss=section("scenario marker (pick before recording)",2)
    local scenarios={
        {"Skill tree: unlock ONE node now","Open the skill tree UI and unlock one affordable node."},
        {"Breathing trainer: learn one rank now","Talk to the trainer and complete one learn action."},
        {"Fishing: one full cast -> catch now","Equip bait + rod, cast, wait for bite, finish minigame."},
        {"Shop: one cheapest purchase now","Buy the cheapest item and note its name/price."},
        {"Training: one full minigame now","Run one pushups/meditation session to completion."},
        {"Queue/cards: join + one wave now","Join queue; in the minigame run this probe again there."},
        {"Delivery: one full delivery now","Accept and complete one delivery quest."},
        {"Race/Demon: dialog up to final confirm","Open the dialog and steps before the irreversible confirm."},
        {"Parry/block: get hit while blocking","Aggro a weak mob, block right before its hits ~5 times."},
        {"Souls/cache/schematic: collect one each","Collect one of each object type."},
        {"Redeem one code","Redeem any single code from the code UI."},
    }
    for _,row in ipairs(scenarios) do
        ss:Button({Name=row[1],Confirm=false,Callback=function()
            T.scenario=row[1]
            T.markers[#T.markers+1]={t=clock(),text="scenario: "..row[1]}
            note(row[2].." | Then press START recording.")
        end})
    end
    local ds=section("targeted source dump")
    ds:Button({Name="Scan keyword scripts + decompile (one click)",Confirm=false,Callback=function()
        local ok,res=pcall(scanSources)
        if ok then note("Dumped "..res.." candidate scripts into the report") else note("Scan failed: "..short(res,80)) end
        refreshCounts()
    end})
    scanLabel=ds:Label("Keywords: skill/breath/fish/shop/train/queue/card/race/soul/schemat/deliver/parry/...")
    local es=section("export",2)
    es:Button({Name="STOP recording + SAVE + COPY report",Confirm=false,Callback=function()
        stopTap("export");local ok,err=pcall(exportReport);if not ok then note("Export failed: "..short(err,80)) end
        refreshCounts()
    end})
    es:Label("Report: CAM_ActionProbe_<utc>.json in workspace + clipboard, then paste/upload it here.")
    es:Label("Taps/watchers stay attached (pass-through) until Unload.")
    local us=section("unload")
    us:Button({Name="Unload probe (restore everything)",Confirm=false,Callback=function() Env.CAMActionProbe.Stop() end})
    local function unload()
        stopTap("unload")
        if hb then pcall(function() hb:Disconnect() end) end
        for _,con in ipairs(T.connections) do pcall(function() con:Disconnect() end) end
        for _,w in ipairs(T.wrapped) do pcall(function() w.m[w.k]=w.orig end) end
        if restoreFn then for _,h in ipairs(T.hooked) do pcall(restoreFn,h.orig) end end
        if T.namecallOn and T.namecallHook and T.namecallOrig then pcall(T.namecallHook,game,"__namecall",T.namecallOrig);T.namecallOn=false end
        pcall(function() if window then window:Destroy() end end)
        if Env.CAMActionProbe and Env.CAMActionProbe.T==T then Env.CAMActionProbe=nil end
    end
    local oldUnload=Lumen.Unload
    function Lumen:Unload() unload();return oldUnload(self) end
    Env.CAMActionProbe={T=T,Stop=function() Lumen:Unload() end,Version="1.1",
        Stats=function() refreshCounts();return {signals=#T.signals,buttons=#T.buttons,deltas=#T.deltas,taps=#T.taps} end}
    note("CAM ActionProbe 1.0 ready. Order: 1 ATTACH -> scenario -> 2 START -> perform action -> 3 STOP -> export.")
end
return

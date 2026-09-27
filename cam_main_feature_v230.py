from pathlib import Path
p=Path('cam_main_logic.lua');s=p.read_text()
def patch(old,new):
    global s
    assert old in s,'ANCHOR MISS: '+old[:90]
    s=s.replace(old,new,1)

# --- 1. S defaults: v2.3.0 fields ---
patch("""        priority="Combat first",destinationType="Zone",destination="",huntId="",status="Ready - automation OFF",
        skillSlots={},epoch=0}""",
"""        priority="Combat first",destinationType="Zone",destination="",huntId="",status="Ready - automation OFF",
        skillSlots={},epoch=0,
        autoParry=false,parryRange=14,parryHold=0.35,parryCooldown=0.9,
        autoTraining=false,trainingMode="Instant (win signal)",trainDelay=0.5,
        buyName="",buyAmount=1,loadoutName="",loadoutText="",rankedKey=""}""")

# --- 2. C table: v2.3.0 counters/state ---
patch("""        skillIndex=0,seen=setmetatable({}, {__mode="k"}),count=0,indexing=true,visualClock=0}""",
"""        skillIndex=0,seen=setmetatable({}, {__mode="k"}),count=0,indexing=true,visualClock=0,
        parryWatched=setmetatable({}, {__mode="k"}),parryPath="input",parryConfirmed=false,lastParry=0,
        parryAttempts=0,parryBlocked=0,parryPerfect=0,parryUnacked=0,
        blockWatchDone=false,trainWatchDone=false,trainSession=nil,sliderSamples={},trainClicks=0,trainWins=0}""")

# --- 3. label declarations ---
patch("    local statusLabel,targetLabel,resourceLabel,questLabel,nativeLabel,indexLabel",
"    local statusLabel,targetLabel,resourceLabel,questLabel,nativeLabel,indexLabel,parryLabel,trainLabel")

# --- 4. module paths: SignalFunction for Invoke protocols (shop, loadout rename) ---
patch("""        Restrictions={"CAM","Global","Subsets","Gameplay","ToolbarItemRestrictions"},
    }""",
"""        Restrictions={"CAM","Global","Subsets","Gameplay","ToolbarItemRestrictions"},
        SignalF={"Communication","ServerAndClient","Signals","SignalFunction"},
    }""")

# --- 5. stopAll: reset v2.3 watchers ---
patch("""        if clearESP then clearESP() end
        S.status=reason or "Stopped";log("stop",S.status)""",
"""        if clearESP then clearESP() end
        C.parryWatched=setmetatable({},{__mode="k"});C.blockWatchDone=false;C.trainWatchDone=false;C.trainSession=nil;C.sliderSamples={};C.parryUnacked=0
        S.status=reason or "Stopped";log("stop",S.status)""")

# --- 6. core blocks: Auto Parry + Auto Training (insert before add()) ---
patch("""    local function add(o)
        if not live(o) then return end""",
"""    -- v2.3.0 Auto Parry (beta). Protocol facts from server values + decompiled 012_Skill_Controller:
    -- block = native Skills_1st hold; server ack = Values/<player>/Blocking node (value 9),
    -- perfect = the same node with Perfect / PerfectNpc children (server-decided, so this is an honest ack).
    local function watchBlockingValues()
        if C.blockWatchDone then return end
        local vf=values();if not vf then return end
        C.blockWatchDone=true
        connect(vf.ChildAdded,function(o)
            if o.Name=="Blocking" then
                C.parryBlocked=C.parryBlocked+1;C.parryUnacked=0
                if not C.parryConfirmed then C.parryConfirmed=true;C.parryPath="input";log("parry","server ack: Blocking value observed") end
                connect(o.ChildAdded,function(kid)
                    if kid.Name=="Perfect" or kid.Name=="PerfectNpc" then C.parryPerfect=C.parryPerfect+1 end
                end,"Perfect parry watcher")
            end
        end,"Blocking ack watcher")
    end
    local function blockTap(hold)
        hold=hold or S.parryHold
        if C.parryPath=="signal" then
            local signal=C.modules.Signal
            if not (signal and type(signal.ToServer)=="function") then return false end
            pcall(signal.ToServer,"server_skill_controller_signaler","Blocking","Hold",Vector3.new(0,0,0))
            task.delay(hold,function()
                pcall(signal.ToServer,"server_skill_controller_signaler","Blocking","UnHold",Vector3.new(0,0,0))
            end)
            log("parry","block tap via signal channel")
            return true
        end
        return press("Skills_1st",hold)
    end
    local function onHostileAnim(model,track)
        if not S.autoParry or not S.alive then return end
        if track==nil then return end
        local okP,prio=pcall(function() return track.Priority end)
        local okE,actionVal=pcall(function() return Enum.AnimationPriority.Action.Value end)
        if okP and prio~=nil and okE and prio.Value<actionVal then return end
        local now=os.clock()
        if now-C.lastParry<S.parryCooldown then return end
        local _,_,r=char();if not r then return end
        local root=model and model:FindFirstChild("HumanoidRootPart")
        if not live(root) then return end
        if (root.Position-r.Position).Magnitude>S.parryRange then return end
        local vel=root.AssemblyLinearVelocity
        if vel and Vector3.new(vel.x,0,vel.z).Magnitude>3 then return end
        watchBlockingValues()
        C.lastParry=now;C.parryAttempts=C.parryAttempts+1
        local ok=blockTap(S.parryHold)
        if ok then
            C.parryUnacked=C.parryUnacked+1
            if C.parryPath=="input" and C.parryUnacked>=3 and C.parryBlocked==0 then
                C.parryPath="signal";C.parryUnacked=0
                log("parry","input taps without ack; switched to direct signal")
                note("Auto Parry: no server ack from input taps; switched to direct signal")
            elseif C.parryPath=="signal" and C.parryUnacked>=3 and C.parryBlocked==0 then
                flag("autoParry",false)
                log("parry","auto-pause: no ack from input or signal")
                note("Auto Parry: no server ack from either method; paused for safety")
            end
        end
    end
    local function watchParryModel(m)
        if not m or C.parryWatched[m] then return end
        local k=kindOfNPC(m)
        if k~="Mob" and k~="Boss" then return end
        local h=m:FindFirstChildOfClass("Humanoid")
        local a=h and h:FindFirstChildOfClass("Animator")
        if not a or type(a.AnimationPlayed)~="function" then return end
        C.parryWatched[m]=true
        connect(a.AnimationPlayed,function(t) onHostileAnim(m,t) end,"Auto Parry anim watcher")
    end
    -- v2.3.0 Auto Training (beta). From decompiled 137_Client: client-side success reports
    -- training_signaler "StateChanged" then "Stop", true. Instant mode sends exactly that.
    -- Default mode auto-plays the slider UI instead (clicks only inside the target zone).
    local function trainingSignal(action,boolArg)
        local signal=C.modules.Signal
        if not (signal and type(signal.ToServer)=="function") then return false end
        if boolArg~=nil then pcall(signal.ToServer,"training_signaler",action,boolArg==true)
        else pcall(signal.ToServer,"training_signaler",action) end
        log("training",action..(boolArg~=nil and " | win=true" or ""))
        return true
    end
    local function autoPlaySlider(session)
        local pg=LP:FindFirstChildOfClass("PlayerGui");local misc=pg and pg:FindFirstChild("Misc")
        if not misc then return false,"Misc UI not open" end
        local deadline=os.clock()+6
        local clicked=false
        while os.clock()<deadline and C.trainSession==session and S.autoTraining and S.trainingMode~="Instant (win signal)" do
            local knob;local bestArea=1/0
            for _,o in pairs(misc:GetDescendants()) do
                if o:IsA("GuiObject") and o.Visible and o.AbsoluteSize.X<=40 and o.AbsoluteSize.Y<=40 then
                    local id=tostring(o);local pos=o.AbsolutePosition
                    local prev=C.sliderSamples[id]
                    if prev and (math.abs(prev.X-pos.X)>2 or math.abs(prev.Y-pos.Y)>2) then
                        local area=o.AbsoluteSize.X*o.AbsoluteSize.Y
                        if area<bestArea then bestArea=area;knob=o end
                    end
                    C.sliderSamples[id]={X=pos.X,Y=pos.Y}
                end
            end
            if knob then
                local track=knob.Parent
                if track and track:IsA("GuiObject") then
                    local zone
                    for _,o in pairs(track:GetChildren()) do
                        if o:IsA("GuiObject") and o~=knob and o.Visible then
                            local w=o.AbsoluteSize.X
                            if w>track.AbsoluteSize.X*0.08 and w<track.AbsoluteSize.X*0.6 then zone=o;break end
                        end
                    end
                    local zx
                    if zone then zx=zone.AbsolutePosition.X;zw=zone.AbsoluteSize.X
                    else zx=track.AbsolutePosition.X+track.AbsoluteSize.X*0.33;zw=track.AbsoluteSize.X*0.34 end
                    local kx=knob.AbsolutePosition.X+knob.AbsoluteSize.X/2
                    if kx>=zx and kx<=zx+zw then
                        local cy=track.AbsolutePosition.Y+track.AbsoluteSize.Y/2
                        local okClick=pcall(function()
                            local VIM=game:GetService("VirtualInputManager")
                            VIM:SendMouseButtonEvent(kx,cy,0,true,game,0)
                            VIM:SendMouseButtonEvent(kx,cy,0,false,game,0)
                        end)
                        if okClick then clicked=true;C.trainClicks=C.trainClicks+1 end
                    end
                end
            end
            task.wait(0.05)
        end
        return clicked,clicked and nil or "slider UI not recognized in time"
    end
    local function startTrainingSession(trigger)
        if C.trainSession then return end
        local session=os.clock();C.trainSession=session
        log("training","session start: "..tostring(trigger))
        task.spawn(function()
            if S.trainingMode=="Instant (win signal)" then
                task.wait(S.trainDelay or 0.5)
                if C.trainSession~=session or not S.autoTraining then return end
                trainingSignal("StateChanged")
                task.wait(0.35)
                if C.trainSession~=session or not S.autoTraining then return end
                if trainingSignal("Stop",true) then C.trainWins=C.trainWins+1 end
            else
                local ok,why=autoPlaySlider(session)
                if not ok then log("training","slider: "..tostring(why));note("Auto Training slider: "..tostring(why)) end
            end
            task.delay(4,function() if C.trainSession==session then C.trainSession=nil end end)
        end)
    end
    local function watchTrainingValues()
        if C.trainWatchDone then return end
        local vf=values();if not vf then return end
        C.trainWatchDone=true
        connect(vf.ChildAdded,function(o)
            if not S.autoTraining then return end
            if o.Name=="pause_gameplay" or o.Name=="skill_stand_still" or o.Name=="Training" then startTrainingSession(o.Name) end
        end,"Auto Training trigger")
        connect(vf.ChildRemoved,function(o)
            if o.Name=="pause_gameplay" or o.Name=="Training" then C.trainSession=nil end
        end,"Auto Training end")
    end
    -- v2.3.0 manual action helpers (explicit click only; no auto-spend loops)
    local function buyShop(withOre)
        if S.buyName=="" then return false,"Type the exact shop item name first" end
        local sf=C.modules.SignalF
        if not (sf and type(sf.ToServer)=="function") then return false,"Connect native controls first" end
        local amount=math.max(1,math.floor(S.buyAmount or 1))
        local ok,res
        if withOre then ok,res=pcall(sf.ToServer,"PurchaseFromShopWithOre",S.buyName)
        else ok,res=pcall(sf.ToServer,"PurchaseFromShop",S.buyName,amount) end
        log("shop",(withOre and "WithOre " or "")..S.buyName.." x"..tostring(withOre and 1 or amount).." | sent="..tostring(ok).." | "..short(res))
        if ok then return true,"Purchase request sent (server confirmation not observable client-side)" end
        return false,"Rejected: "..short(res)
    end
    local function startMuzanQuest()
        local q=C.modules.Quests;local signal=C.modules.Signal
        if not (signal and type(signal.ToServer)=="function") then return false,"Connect native controls first" end
        if q and type(q.GetPlayerQuestState)=="function" then
            local okQ,st=pcall(q.GetPlayerQuestState,LP,"Muzan Quest")
            if okQ and st=="Doing" then return false,"Muzan Quest already in progress" end
        end
        signal.ToServer("MuzanLairAssign")
        log("muzan","MuzanLairAssign requested")
        return true,"Muzan quest request sent; you must be standing at the lair"
    end
    local function rankedRequest(action)
        if S.rankedKey=="" then return false,"Type the ranked board/mode key first" end
        local signal=C.modules.Signal
        if not (signal and type(signal.ToServer)=="function") then return false,"Connect native controls first" end
        signal.ToServer("RankedRequest",{action=action,key=S.rankedKey})
        log("ranked",action.." | "..S.rankedKey)
        return true,action.." request sent"
    end
    local function loadoutAction(n,text)
        if S.loadoutName=="" then return false,"Type the loadout name first" end
        if n==3 then
            local sf=C.modules.SignalF
            if not (sf and type(sf.ToServer)=="function") then return false,"Connect native controls first" end
            if (text or "")=="" then return false,"Type the new rename text first" end
            local ok,res=pcall(sf.ToServer,"HandleLoadoutActions",S.loadoutName,3,text)
            log("loadout",S.loadoutName.." rename -> "..tostring(res))
            if ok then return true,"Rename requested" end
            return false,"Rejected: "..short(res)
        end
        local signal=C.modules.Signal
        if not (signal and type(signal.ToServer)=="function") then return false,"Connect native controls first" end
        signal.ToServer("HandleLoadoutActions",S.loadoutName,n)
        log("loadout",S.loadoutName.." action "..tostring(n))
        return true,(n==1 and "Save" or "Load").." requested"
    end
    local function add(o)
        if not live(o) then return end""")

# --- 7. hook parry watcher into index add() ---
patch("""            if not C.indexing and not C.seen[m] and S.notifyBoss and k=="Boss" then note("Boss streamed in: "..m.Name) end
            C.seen[m]=true
        end""",
"""            if not C.indexing and not C.seen[m] and S.notifyBoss and k=="Boss" then note("Boss streamed in: "..m.Name) end
            C.seen[m]=true
            watchParryModel(m)
        end""")

# --- 8. Heartbeat: lazy value watchers + parry/training counters UI ---
patch("""    connect(Run.Heartbeat,function(dt)
        local current,h=char()""",
"""    connect(Run.Heartbeat,function(dt)
        if S.autoParry and not C.blockWatchDone then pcall(watchBlockingValues) end
        if S.autoTraining and not C.trainWatchDone then pcall(watchTrainingValues) end
        local current,h=char()""")
patch("""            statusLabel:SetText(short(S.status,95));indexLabel:SetText((C.indexing and "Indexing... " or "Loaded index: ")..n.." objects")""",
"""            statusLabel:SetText(short(S.status,95));indexLabel:SetText((C.indexing and "Indexing... " or "Loaded index: ")..n.." objects")
            if parryLabel and parryLabel.SetText then parryLabel:SetText("Parry: "..C.parryAttempts.." taps / "..C.parryBlocked.." blocks / "..C.parryPerfect.." perfect | method "..C.parryPath..(C.parryConfirmed and " (server-confirmed)" or " (unconfirmed)")) end
            if trainLabel and trainLabel.SetText then trainLabel:SetText("Training: "..C.trainWins.." win signals / "..C.trainClicks.." slider clicks") end""")

# --- 9. NEW UI PAGE inserted before pending ---
patch("""    local pending=section(dp,"NOT IMPLEMENTED - no fake switches",2)
    pending:Label("Not wired yet: delivery/escort quests; queues/cards/waves; breathing & skill-tree spending; training; fishing cast/minigame; purchases & gear scoring; parry; souls/schematics; codes; race change; instant-kill & stamina claims. They ship after targeted evidence, not as fake toggles.")""",
"""    local act=page("v2.3 actions","gameplay")
    local pc=section(act,"auto parry (beta)")
    toggle(pc,"Auto Parry - block hostile attack anims","autoParry",function(v)
        if v then loadNative();watchBlockingValues();for m in pairs(C.humanoids) do watchParryModel(m) end
        else release("Skills_1st") end
    end)
    slider(pc,"Parry range (studs)", "parryRange",4,30)
    slider(pc,"Block hold (s)","parryHold",0.15,1)
    slider(pc,"Parry cooldown (s)","parryCooldown",0.3,3)
    parryLabel=pc:Label("Parry: idle")
    pc:Label("Trigger: Mob/Boss Animator Action anims in range, skipping movers. Ack: Values/Blocking (+Perfect).")
    pc:Label("Calibration: input first; falls back to direct signal, auto-pauses if neither gets server ack.")
    local ts=section(act,"auto training (beta)",2)
    toggle(ts,"Auto Training - complete minigames","autoTraining",function(v)
        if v then loadNative();watchTrainingValues() end
    end)
    ts:Dropdown({Name="Mode",Items={"Instant (win signal)","Default (auto-play slider)"},Default=S.trainingMode,Callback=function(v) S.trainingMode=v end})
    slider(ts,"Instant: delay before StateChanged (s)","trainDelay",0.1,3)
    trainLabel=ts:Label("Training: idle")
    ts:Label("Instant sends the same StateChanged + Stop,true the client itself reports on a win.")
    ts:Label("Default clicks the slider only inside the target zone; skip if the bar is not recognized.")
    local sh=section(act,"manual shop / loadout (explicit clicks only)")
    sh:Textbox({Name="Shop item name (exact)",Placeholder="e.g. Blood Bait",Default=S.buyName,Callback=function(v) S.buyName=v end})
    slider(sh,"Buy amount","buyAmount",1,25)
    button(sh,"Buy item (PurchaseFromShop)",function() loadNative();tell(buyShop(false)) end,true)
    button(sh,"Buy item with ore (WithOre)",function() loadNative();tell(buyShop(true)) end,true)
    sh:Textbox({Name="Loadout name",Placeholder="existing loadout",Default=S.loadoutName,Callback=function(v) S.loadoutName=v end})
    sh:Textbox({Name="Loadout rename text",Placeholder="new name",Default=S.loadoutText,Callback=function(v) S.loadoutText=v end})
    button(sh,"Save loadout (current build)",function() loadNative();tell(loadoutAction(1,nil)) end,true)
    button(sh,"Load loadout",function() loadNative();tell(loadoutAction(2,nil)) end)
    button(sh,"Rename loadout",function() loadNative();tell(loadoutAction(3,S.loadoutText)) end)
    local rq=section(act,"muzan / ranked requests",2)
    button(rq,"Start Muzan Quest (Demon race)",function() loadNative();tell(startMuzanQuest()) end,true)
    rq:Label("Must be standing at the Muzan lair; starts the quest only when not already Doing.")
    rq:Textbox({Name="Ranked key (board/mode)",Placeholder="from ranked UI",Default=S.rankedKey,Callback=function(v) S.rankedKey=v end})
    button(rq,"Ranked: refresh board",function() loadNative();tell(rankedRequest("Board")) end)
    button(rq,"Ranked: claim reward",function() loadNative();tell(rankedRequest("Claim")) end,true)
    sh:Label("Protocols from decompiled sources (072/074/081 PurchaseFromShop, 075 Loadouts). No auto-spend loops by design.")
    local pending=section(dp,"NOT IMPLEMENTED - no fake switches",2)
    pending:Label("Not wired yet: skill-tree spend args (tree UI script absent from dumps), fishing cast/minigame internals, code redeem UI, delivery/escort chain, queue/waves/dungeon request semantics beyond Ranked Board/Claim, souls/schematics, gear scoring, instant-kill & stamina claims. They ship after source evidence - not as fake toggles.")""")

# --- 10. limits label update ---
patch('limits:Label("No purchases / spending / race change; native + server checks still apply.")',
'limits:Label("Manual-click purchases/quests exist; NO repeating auto-spend loops; native + server checks apply.")')

# --- 11. version strings ---
patch('local window=Lumen:Window({Name="CAM MAIN | Quest & Farm",Version="2.2.0 / ESP rework + farm clip fix",Footer="RightCtrl menu | End STOP | No server bypass claims",Size=UDim2.fromOffset(900,660),Keybind=Enum.KeyCode.RightControl,SettingsPage=false})',
'local window=Lumen:Window({Name="CAM MAIN | Quest & Farm",Version="2.3.0 / auto parry + trainer + shop",Footer="RightCtrl menu | End STOP | No server bypass claims",Size=UDim2.fromOffset(900,660),Keybind=Enum.KeyCode.RightControl,SettingsPage=false})')
patch('Env.CAMMainHub={State=S,Stop=function() Lumen:Unload() end,Snapshot=snapshot,Version="2.2.0"}',
'Env.CAMMainHub={State=S,Stop=function() Lumen:Unload() end,Snapshot=snapshot,Version="2.3.0"}')

p.write_text(s)
print('v230 logic patched; size',len(s))

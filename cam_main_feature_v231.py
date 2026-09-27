from pathlib import Path
p=Path('cam_main_logic.lua');s=p.read_text()
def patch(old,new):
    global s
    assert old in s,'ANCHOR MISS: '+old[:90]
    s=s.replace(old,new,1)

# --- S defaults ---
patch("""        buyName="",buyAmount=1,loadoutName="",loadoutText="",rankedKey=""}""",
"""        buyName="",buyAmount=1,loadoutName="",loadoutText="",rankedKey="",
        autoFish=false,fishDelay=1.0,fishNudge=8,wurfansClue="1"}""")

# --- C state ---
patch("""        blockWatchDone=false,trainWatchDone=false,trainSession=nil,sliderSamples={},trainClicks=0,trainWins=0}""",
"""        blockWatchDone=false,trainWatchDone=false,trainSession=nil,sliderSamples={},trainClicks=0,trainWins=0,
        fish={casts=0,bites=0,wins=0,awaitingBite=false,last=0,portalDone=false}}""")

# --- label decl ---
patch("    local statusLabel,targetLabel,resourceLabel,questLabel,nativeLabel,indexLabel,parryLabel,trainLabel",
"    local statusLabel,targetLabel,resourceLabel,questLabel,nativeLabel,indexLabel,parryLabel,trainLabel,fishLabel")

# --- stopAll: keep counters, fish flags reset implicitly via S toggle off (conns die via C.connections) ---

# --- core blocks: auto fishing + quest advance + npc actions + prompt button ---
patch("""    -- v2.3.0 manual action helpers (explicit click only; no auto-spend loops)""",
"""    -- v2.3.1 Auto Fishing. From decompiled 1_584 (client) + 002_ServerClientPortal:
    -- bites arrive via portal Event:FireClient("FishingRod","Bite",id); success answer = FireServer("FishingRod", id, true).
    -- Cast = native Tool activation of a *Fishing Rod; reward/cast validation stays server-side.
    local function fishPortal()
        return at(RS,{"CAM","Global","ServerClientPortal","Event"})
    end
    local function watchFishPortal()
        if C.fish.portalDone then return end
        local portal=fishPortal()
        if not (portal and portal.OnClientEvent) then return end
        C.fish.portalDone=true
        connect(portal.OnClientEvent,function(name,kind,id)
            if name~="FishingRod" or kind~="Bite" then return end
            C.fish.bites=C.fish.bites+1
            if not S.autoFish or not S.alive then return end
            task.delay(S.fishDelay or 1,function()
                if not S.autoFish or not S.alive then return end
                pcall(function() portal:FireServer("FishingRod",id,true) end)
                C.fish.wins=C.fish.wins+1;C.fish.awaitingBite=false
                log("fishing","bite id "..tostring(id).." answered success")
            end)
        end,"Fishing bite watcher")
    end
    local function findRod()
        local packs={LP.Character,LP:FindFirstChild("Backpack")}
        for _,pack in ipairs(packs) do
            if pack then
                for _,t in ipairs(pack:GetChildren()) do
                    if t:IsA("Tool") and t.Name:find("Fishing Rod",1,true) then return t end
                end
            end
        end
        return nil
    end
    local function castRod()
        local rod=findRod()
        if not rod then return false,"No *Fishing Rod tool found in backpack/character" end
        local _,h=char()
        if rod.Parent~=LP.Character and h and type(h.EquipTool)=="function" then pcall(function() h:EquipTool(rod) end) end
        if type(rod.Activate)=="function" then
            local ok,err=pcall(function() rod:Activate() end)
            if not ok then return false,"Tool activation failed: "..short(err) end
        end
        C.fish.casts=C.fish.casts+1;C.fish.last=os.clock();C.fish.awaitingBite=true
        watchFishPortal()
        log("fishing","cast #"..C.fish.casts)
        return true
    end
    -- v2.3.1 quest advance: honest deliver/collect nudge from decompiled 029/030/031:
    -- only QuestProgress(questKey, taskId) for specs whose RequiredItem is in the live inventory; server validates.
    local function advanceQuest()
        local q=C.modules.Quests;local signal=C.modules.Signal
        if not (signal and type(signal.ToServer)=="function") then return false,"Connect native controls first" end
        if type(q)~="table" or type(q.Holder)~="table" then return false,"Quest module specs offline" end
        local d=data();local holder=d and at(d,{"Quests","Holder"})
        local inv=d and at(d,{"Inventory","Inventory"})
        if not (holder and inv) then return false,"Quest/inventory data not streamed" end
        local sent=0
        for _,inst in ipairs(holder:GetChildren()) do
            local spec=q.Holder[inst.Name]
            if type(spec)=="table" and type(spec.TaskSpecs)=="table" then
                for tid,ts in pairs(spec.TaskSpecs) do
                    local need=type(ts)=="table" and ts.RequiredItem or nil
                    if need then
                        local entry=inv:FindFirstChild(need)
                        local amount=entry and (entry:FindFirstChild("Amount"))
                        local have=entry and ((amount and amount.Value) or 1) or 0
                        if have>=1 then
                            signal.ToServer("QuestProgress",inst.Name,tid)
                            sent=sent+1;log("quest","QuestProgress "..inst.Name.." | "..tostring(tid))
                        end
                    end
                end
            end
        end
        if sent==0 then return false,"No deliverable/collect quest has its RequiredItem in your inventory" end
        return true,sent.." QuestProgress nudges sent (server validates proximity/items)"
    end
    -- v2.3.1 NPC actions: parameterless interaction remotes from decompiled oneclick/world actions.
    local function npcAction(name,...)
        local signal=C.modules.Signal
        if not (signal and type(signal.ToServer)=="function") then return false,"Connect native controls first" end
        signal.ToServer(name,...)
        log("npc",name)
        return true,name.." requested (stand near the NPC; server validates)"
    end
    -- v2.3.1 nearest world prompt (queues/levers/portals/join nodes are prompt-driven, no hidden remotes)
    local function activateNearestPrompt()
        local _,_,r=char();if not r then return false,"No character" end
        local best,bd=nil,math.huge
        for p in pairs(C.prompts) do
            if live(p) and p.Enabled then
                local okC,elig=pcall(withinPrompt,p)
                if okC and elig then
                    local pp=part(p.Parent);local d=pp and (pp.Position-r.Position).Magnitude or math.huge
                    if d<bd then best=p;bd=d end
                end
            end
        end
        if not best then return false,"No eligible prompt within range" end
        return startPrompt(best)
    end
    -- v2.3.0 manual action helpers (explicit click only; no auto-spend loops)""")

# --- heartbeat: fishing loop ---
patch("""    connect(Run.Heartbeat,function(dt)
        if S.autoParry and not C.blockWatchDone then pcall(watchBlockingValues) end
        if S.autoTraining and not C.trainWatchDone then pcall(watchTrainingValues) end
        local current,h=char()""",
"""    connect(Run.Heartbeat,function(dt)
        if S.autoParry and not C.blockWatchDone then pcall(watchBlockingValues) end
        if S.autoTraining and not C.trainWatchDone then pcall(watchTrainingValues) end
        if S.autoFish and os.clock()-C.fish.last>0.5 then
            if C.fish.awaitingBite and os.clock()-C.fish.last<=(S.fishNudge or 8) then
            else pcall(function() castRod() end) end
        end
        local current,h=char()""")

# --- counters UI ---
patch("""            if trainLabel and trainLabel.SetText then trainLabel:SetText("Training: "..C.trainWins.." win signals / "..C.trainClicks.." slider clicks") end""",
"""            if trainLabel and trainLabel.SetText then trainLabel:SetText("Training: "..C.trainWins.." win signals / "..C.trainClicks.." slider clicks") end
            if fishLabel and fishLabel.SetText then fishLabel:SetText("Fishing: "..C.fish.casts.." casts / "..C.fish.bites.." bites / "..C.fish.wins.." wins") end""")

# --- UI: extend v2.3 actions page with fishing + quest + npc panel + prompt button ---
patch("""    local pending=section(dp,"NOT IMPLEMENTED - no fake switches",2)""",
"""    local fb=section(act,"v2.3.1 auto fishing / quests / world",1)
    toggle(fb,"Auto Fishing - cast, catch, win","autoFish",function(v)
        if v then loadNative();watchFishPortal() else C.fish.awaitingBite=false end
    end)
    slider(fb,"Answer delay after bite (s)","fishDelay",0.3,3)
    slider(fb,"Recast if no bite (s)","fishNudge",5,30)
    fishLabel=fb:Label("Fishing: idle")
    button(fb,"Cast now (single)",function() loadNative();tell(castRod()) end)
    fb:Label("Needs a *Fishing Rod tool; cast = native Tool activation near water (SwimParts).")
    local qs=section(act,"v2.3.1 quest / prompt helpers",2)
    button(qs,"Advance delivery/collect quest (inventory-verified)",function() loadNative();tell(advanceQuest()) end)
    button(qs,"Activate nearest world prompt (queue/lever/portal)",function() tell(activateNearestPrompt()) end)
    qs:Label("Queues, waves, dungeon joins and trainers are ProximityPrompt-driven: no separate remotes exist in dumps.")
    local npcq=section(act,"v2.3.1 npc interactions (must stand near the NPC)",1)
    button(npcq,"Gauntlet statues: begin",function() loadNative();tell(npcAction("GauntletStatuesBegin")) end)
    button(npcq,"Gauntlet statue: give schematic",function() loadNative();tell(npcAction("GauntletGiveSchematic")) end,true)
    button(npcq,"Wagasa: give schematic",function() loadNative();tell(npcAction("WagasaGiveSchematic")) end,true)
    button(npcq,"Muzan: give bell",function() loadNative();tell(npcAction("MuzanGiveBell")) end,true)
    button(npcq,"Take Foxfire",function() loadNative();tell(npcAction("FoxfireTake")) end)
    button(npcq,"Retsu: tell Foxfire",function() loadNative();tell(npcAction("RetsuTellFoxfire")) end)
    button(npcq,"Isao: take toll",function() loadNative();tell(npcAction("IsaoTakeToll")) end,true)
    button(npcq,"Sofen: pull ledger",function() loadNative();tell(npcAction("SofenPullLedger")) end)
    button(npcq,"Liv: gamble",function() loadNative();tell(npcAction("LivGamble")) end,true)
    button(npcq,"Dismiss crow",function() loadNative();tell(npcAction("CrowDismiss")) end)
    button(npcq,"Cleaver duel",function() loadNative();tell(npcAction("CleaverDuel")) end,true)
    npcq:Dropdown({Name="WarFans clue #",Items={"1","2","3","4"},Default=S.wurfansClue,Callback=function(v) S.wurfansClue=v end})
    button(npcq,"WarFans: submit clue",function() loadNative();tell(npcAction("WarFansClue",tonumber(S.wurfansClue))) end,true)
    local pending=section(dp,"NOT IMPLEMENTED - no fake switches",2)""")

# --- pending text refresh ---
patch("""    pending:Label("Not wired yet: skill-tree spend args (tree UI script absent from dumps), fishing cast/minigame internals, code redeem UI, delivery/escort chain, queue/waves/dungeon request semantics beyond Ranked Board/Claim, souls/schematics, gear scoring, instant-kill & stamina claims. They ship after source evidence - not as fake toggles.")""",
"""    pending:Label("Still not wired: skill-tree spend args (tree UI script absent from every dump), code redeem UI (no code remote exists in dumps), internal queue/wave scoring, gear scoring, instant-kill & infinite-stamina claims (server-side state; no client protocol found - claims rejected). One short probe run can finish the skill-tree case.")""")

# --- version bumps to 2.3.1 ---
patch('Version="2.3.0 / auto parry + trainer + shop"','Version="2.3.1 / + fishing, quest, npc actions"')
patch('Snapshot=snapshot,Version="2.3.0"}','Snapshot=snapshot,Version="2.3.1"}')
assert 'CAM Main Hub 2.3.0' in s;s=s.replace('CAM Main Hub 2.3.0','CAM Main Hub 2.3.1')
assert 'CAM Main 2.3.0 ready' in s;s=s.replace('CAM Main 2.3.0 ready','CAM Main 2.3.1 ready')
p.write_text(s)
print('v231 logic patched; size',len(s))

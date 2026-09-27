from pathlib import Path
s=Path('dh_main_logic.lua').read_text()
def rep(a,b):
 global s
 assert a in s,a[:100]
 s=s.replace(a,b)
rep('Main Hub 1.0','Main Hub 1.1')
rep('''        alive = true, autoM1 = false, autoWalk = false, autoSkill = false,''','''        alive = true, autoM1 = false, autoWalk = false, autoSkill = false,
        autoFarm = false, hover = false, autoQuest = false, executorPrompts = false,
        hoverHeight = 4, hoverBack = 2, hoverSpeed = 40, restHeight = 12,
        staminaLow = 20, staminaResume = 45, healthLow = 25, healthResume = 60,
        stallTimeout = 20, questMode = "Hunter hunt",''')
rep('''collision = setmetatable({}, {__mode = "k"}), stopCount = 0 }''','''collision = setmetatable({}, {__mode = "k"}), stopCount = 0,
        avoid = setmetatable({}, {__mode = "k"}), hunts = {}, questFarming = false }''')
rep('''local stopAll, unload, cancelTravel, stopFly, clearESP''','''local stopAll, unload, cancelTravel, stopFly, clearESP, releaseHover, questStep, syncToggles''')
rep('''    local function isTarget(m)''','''    local function farmActive()
        if S.autoQuest then return C.questFarming==true end
        return S.autoFarm
    end
    local function recovery()
        local _,h=char()
        local st=tonumber(LP:GetAttribute("Stamina"))
        local maxSt=tonumber(LP:GetAttribute("MaxStamina")) or 100
        local low=math.max(15, math.min(S.staminaLow,maxSt))
        local resume=math.max(15, math.min(math.max(S.staminaResume,low+5),maxSt))
        if st and st<low then C.staminaRest=true end
        if C.staminaRest then
            if st and st>=resume and os.clock()>=(C.restUntil or 0) then C.staminaRest=false
            else return true,"Stamina recovery: "..tostring(st or "?").." / "..resume end
        end
        if h and h.MaxHealth>0 then
            local pct=h.Health/h.MaxHealth*100
            if pct<=S.healthLow then C.healthRest=true end
            if C.healthRest then
                local want=math.max(S.healthResume,S.healthLow+5)
                if pct>=want then C.healthRest=false
                else return true,"Health recovery: "..math.floor(pct).."% / "..want.."%" end
            end
        end
        return false
    end
    local function isTarget(m)''')
rep('''        if m:GetAttribute("Invulnerable")==true''','''        if (C.avoid[m] or 0)>os.clock() then return false end
        if m:GetAttribute("Invulnerable")==true''')
rep('''        if player then return S.allowPlayers and player~=LP end''','''        if player then return not (S.autoFarm or S.autoQuest) and S.allowPlayers and player~=LP end''')
rep('''    local function groupMatches(m)
        if Players:GetPlayerFromCharacter(m) then return S.allowPlayers end''','''    local function groupMatches(m)
        if S.autoQuest and C.questFarming then
            if S.questMode=="Human hunt" then return m.Name=="Human" and m:GetAttribute("TargetCity")=="CIDADE2" end
            return m.Name=="Hunter"
        end
        if Players:GetPlayerFromCharacter(m) then return S.allowPlayers end''')
rep('''        if isTarget(S.target) then''','''        if isTarget(S.target) and groupMatches(S.target) then''')
rep('''    local function punch()
        local ok,reason=usable();if not ok then return false,reason end''','''    local function punch()
        local resting,why=recovery();if resting then return false,why end
        local ok,reason=usable();if not ok then return false,reason end''')
# Add the hover controller before regular flight. No platform stand / anchoring / server health edits.
rep('''    local function flightStep()''','''    releaseHover=function()
        if C.hoverVelocity then pcall(function() C.hoverVelocity:Destroy() end) C.hoverVelocity=nil end
        C.hoverRoot=nil;C.hoverActive=false
        if not S.noclip then restoreCollision() end
    end
    local function hoverStep(dt)
        local seeking=S.autoQuest and C.questGoal~=nil
        local hovering=(S.hover or farmActive()) and (not S.autoQuest or C.questFarming)
        if S.fly or C.travel or not (seeking or hovering) then releaseHover() return end
        local good=usable();local _,h,r=char()
        if not good or not h or not r or h.Health<=0 then releaseHover() return end
        local m=hovering and target() or nil
        local p=m and part(m)
        local goal=C.questGoal
        if not seeking then
            if not p then releaseHover() return end
            local resting=recovery()
            local y=resting and math.max(S.restHeight,S.hoverHeight) or S.hoverHeight
            goal=p.Position+Vector3.new(0,y,S.hoverBack)
        end
        if not goal or (goal-r.Position).Magnitude>5000 then releaseHover() return end
        if C.hoverRoot~=r then
            releaseHover()
            local v=Instance.new("BodyVelocity");v.Name="NZL_HoverHold";v.MaxForce=Vector3.new(1e6,1e6,1e6);v.Velocity=Vector3.zero;v.Parent=r
            C.hoverVelocity=v;C.hoverRoot=r
        end
        C.hoverActive=true
        local delta=goal-r.Position
        local step=math.min(delta.Magnitude,S.hoverSpeed*math.min(dt,0.1))
        local pos=delta.Magnitude>0.01 and r.Position+delta.Unit*step or goal
        local to=p and Vector3.new(p.Position.X,pos.Y,p.Position.Z) or nil
        r.CFrame=to and (to-pos).Magnitude>0.01 and CFrame.lookAt(pos,to) or CFrame.new(pos)
        r.AssemblyLinearVelocity=Vector3.zero
    end
    local function flightStep()''')
rep('''        flightStep()
        accumulator''','''        flightStep()
        hoverStep(dt)
        accumulator''')
rep('''        if S.noclip and c then''','''        if (S.noclip or C.hoverActive) and c then''')
# Generalise prompt interaction for an explicitly selected quest NPC.
rep('''    local function usePrompt()
        local p,d=nearestPrompt()
        if not p then return false,"No enabled prompt found" end''','''    local function activatePrompt(p)
        local _,_,r=char();local pt=p and part(p.Parent)
        if not p or not p.Parent or not p.Enabled or not r or not pt then return false,"No enabled prompt found" end
        local d=(r.Position-pt.Position).Magnitude''')
rep('''        p:InputHoldBegin();C.holdingPrompt=p
        task.delay(p.HoldDuration+0.1,function()
            pcall(function() p:InputHoldEnd() end)
            if C.holdingPrompt==p then C.holdingPrompt=nil end
            if S.alive and S.token==token then log("prompt","Input hold ended: "..p.Name) end
        end)
        return true
    end''','''        local helper=S.executorPrompts and type(fireproximityprompt)=="function"
        if not helper then p:InputHoldBegin() end
        C.holdingPrompt=p
        task.delay(p.HoldDuration+0.1,function()
            if helper then
                local _,_,root=char();local point=p.Parent and part(p.Parent)
                if S.alive and S.token==token and p.Enabled and point and root and (point.Position-root.Position).Magnitude<=p.MaxActivationDistance then
                    local ok,why=pcall(fireproximityprompt,p)
                    if not ok then log("prompt error",why) end
                end
            else pcall(function() p:InputHoldEnd() end) end
            if C.holdingPrompt==p then C.holdingPrompt=nil end
            if S.alive and S.token==token then log("prompt","Input hold ended: "..p.Name) end
        end)
        return true
    end
    local function usePrompt() return activatePrompt(nearestPrompt()) end
    local function huntRoute()
        return S.questMode=="Human hunt" and "Quest" or "HunterQuest"
    end
    questStep=function()
        C.questGoal=nil;C.questFarming=false
        if not S.autoQuest then return end
        if LP:GetAttribute("Quest2Active")==true or LP:GetAttribute("HumanSideQuestActive")==true then
            S.status="Auto Quest paused: finish the other active quest";return
        end
        local q=C.hunts[huntRoute()]
        if q and q.active and not q.turnIn then
            C.questFarming=true
            S.status="Hunt "..tostring(q.progress).." / "..tostring(q.required)
            return
        end
        local npc=workspace:FindFirstChild(S.questMode=="Human hunt" and "NPCQuest" or "NPCQuest2",true)
        local p=part(npc);local _,_,root=char()
        if not p or not root then S.status="Auto Quest: NPC is not streamed; move closer manually";return end
        if (p.Position-root.Position).Magnitude>5000 then S.status="Auto Quest: NPC beyond travel limit";return end
        C.questGoal=p.Position+Vector3.new(0,0,5)
        local prompt=npc:FindFirstChild("QuestPrompt",true) or npc:FindFirstChildWhichIsA("ProximityPrompt",true)
        if not prompt then S.status="Auto Quest: no quest prompt on NPC";return end
        S.status=q and q.turnIn and "Returning to NPC for turn-in" or "Approaching NPC / waiting for quest dialogue"
        if os.clock()-(C.lastQuestPrompt or -100)>=5 then
            local ok=activatePrompt(prompt)
            if ok then C.lastQuestPrompt=os.clock() end
        end
    end''')
# Record native hunt tracker. Never infer completion from kill count or force rewards.
rep('''                S.lastReply=remote.Name..": "..table.concat(bits," | ");log("server reply",S.lastReply)''','''                S.lastReply=remote.Name..": "..table.concat(bits," | ");log("server reply",S.lastReply)
                if (remote.Name=="CombatEvent" or remote.Name=="BlockEvent") and args[1]=="NoStamina" then
                    C.staminaRest=true;C.restUntil=os.clock()+2
                end
                local qr=remote.Name=="QuestRemote" and "Quest" or (remote.Name=="HunterQuestRemote" and "HunterQuest" or nil)
                if qr and args[1]=="Tracker" then
                    C.hunts[qr]={active=args[2]==true,progress=args[3],required=args[4],turnIn=args[5]==true}
                    S.target=nil;C.progress=nil
                end
                if qr and args[1]=="MissionChoice" and S.autoQuest and qr==huntRoute() and not questBusy() and os.clock()-(C.lastQuestChoose or -100)>=5 then
                    C.lastQuestChoose=os.clock();local token=S.token
                    task.delay(0.25,function()
                        if S.alive and S.autoQuest and S.token==token and qr==huntRoute() and not questBusy() then send(qr,"ChooseKill") end
                    end)
                end''')
rep('''        for _,p in pairs(routes) do attach(at(RS,p)) end''','''        attach(at(RS,{"ArczisCombat","Remotes","CombatEvent"}))
        for _,p in pairs(routes) do attach(at(RS,p)) end''')
rep('''    local function syncToggles()''','''    syncToggles=function()''')
rep('''{"autoM1","autoWalk","autoSkill","autoPaper","autoOffer","espNPC","espPlayers","noclip","speed","fly","infJump","faceTarget"}''','''{"autoM1","autoWalk","autoSkill","autoFarm","hover","autoQuest","autoPaper","autoOffer","espNPC","espPlayers","noclip","speed","fly","infJump","faceTarget"}''')
rep('''        cancelTravel();stopFly();restoreCollision();restoreSpeed();clearESP();stopPain()''','''        C.questGoal=nil;C.questFarming=false;C.progress=nil
        cancelTravel();stopFly();releaseHover();restoreCollision();restoreSpeed();clearESP();stopPain()''')
rep('''Version="1.0 / dump 2812"''','''Version="1.1 / farm + hover"''')
# UI new dedicated page for automation; preserve existing controls.
rep('''    local powers=page("abilities","main")''','''    local auto=page("auto farm / hover","main")
    local af=sec(auto,"NPC farming")
    toggle(af,"AUTO FARM NPC + HOVER","autoFarm",function(v)
        S.target=nil;C.progress=nil;C.avoid=setmetatable({}, {__mode="k"})
        if v then
            S.fly=false;stopFly();cancelTravel();S.autoWalk=false;S.faceTarget=true
            S.allowPlayers=false;S.autoM1=false
            note("NPC farm armed. Choose group on combat page. Hover is NOT invulnerability.")
        elseif not S.hover and not S.autoQuest then releaseHover() end
        syncToggles()
    end)
    toggle(af,"Hover selected NPC (without auto M1)","hover",function(v)
        if v then S.fly=false;stopFly();cancelTravel();S.autoWalk=false
        elseif not farmActive() then releaseHover() end
        syncToggles()
    end)
    slider(af,"Hover height (studs)","hoverHeight",2,20,4,1)
    slider(af,"Horizontal offset (studs)","hoverBack",0,6,2,1)
    slider(af,"Approach / hover speed","hoverSpeed",10,100,40)
    slider(af,"Recovery height","restHeight",5,30,12)
    slider(af,"Skip no-damage target after (s)","stallTimeout",8,60,20)
    af:Label("High hover can put M1 outside its hitbox.")
    af:Label("Farm never selects players; next NPC is automatic.")
    local regen=sec(auto,"stamina / health recovery",2)
    slider(regen,"Pause below stamina","staminaLow",15,60,20)
    slider(regen,"Resume at stamina","staminaResume",20,100,45)
    slider(regen,"Retreat at HP %","healthLow",5,45,25)
    slider(regen,"Resume at HP %","healthResume",50,95,60)
    regen:Label("Stamina/HP are READ, never forged or refilled.")
    regen:Label("Recovery pauses attacks and raises hover height.")
    regen:Label("Hover does not block server damage.")
    regen:Label("If no regen occurs, recovery keeps waiting.")
    button(regen,"STOP FARM / QUEST / MOVEMENT",function() stopAll("farm stop") end)

    local powers=page("abilities","main")''')
rep('''    local q=sec(quests,"quest state / interaction")''','''    local aq=sec(quests,"auto hunt quest loop")
    aq:Dropdown({Name="Hunt quest",Items={"Hunter hunt","Human hunt"},Default="Hunter hunt",Flag="dh_auto_quest_mode",Callback=function(v)
        S.questMode=v;S.target=nil;C.questFarming=false;C.questGoal=nil;S.token=S.token+1
    end})
    toggle(aq,"AUTO QUEST + NPC FARM","autoQuest",function(v)
        S.token=S.token+1;S.target=nil;C.progress=nil;C.questGoal=nil;C.questFarming=false
        if v then
            S.fly=false;stopFly();cancelTravel();S.autoWalk=false;S.autoM1=false
            S.allowPlayers=false;S.autoPaper=false;S.autoOffer=false;S.faceTarget=true
            note("Hunt loop: NPC dialogue -> ChooseKill -> Tracker -> farm -> return to NPC.")
        elseif not (S.autoFarm or S.hover) then releaseHover() end
        syncToggles()
    end)
    toggle(aq,"Use executor prompt helper","executorPrompts")
    aq:Label("Hunter hunt: NPCQuest2 / Hunter models.")
    aq:Label("Human hunt: NPCQuest / Humans in CIDADE2.")
    aq:Label("Completion comes from SERVER Tracker events.")
    local q=sec(quests,"quest state / interaction")''')
rep('''toggle(farm,"Walk toward current target","autoWalk",function(v) if v then cancelTravel() end end)''','''toggle(farm,"Walk toward current target","autoWalk",function(v)
        if v then
            S.autoFarm=false;S.hover=false;S.autoQuest=false;C.questGoal=nil;C.questFarming=false
            S.token=S.token+1;releaseHover();cancelTravel();syncToggles()
        end
    end)''')
rep('''if not v then restoreCollision() end end)''','''if not v and not C.hoverActive then restoreCollision() end end)''')
rep('''if not v then stopFly() else cancelTravel() end end)''','''if not v then stopFly() else
        S.autoFarm=false;S.hover=false;S.autoQuest=false;C.questGoal=nil;C.questFarming=false
        S.token=S.token+1;releaseHover();cancelTravel();syncToggles()
    end end)''')
rep('''        local _,_,r=char();cancelTravel();S.autoWalk=false''','''        local _,_,r=char();cancelTravel();S.autoWalk=false
        S.autoFarm=false;S.hover=false;S.autoQuest=false;S.token=S.token+1;C.questGoal=nil;C.questFarming=false
        releaseHover();syncToggles()''')
# Main polling: let quest state own target motion; suspend manually enabled combat while waiting for NPC.
rep('''                if S.autoM1 or S.autoWalk or S.autoSkill then
                    local m=target()''','''                if S.autoQuest then questStep() else C.questGoal=nil;C.questFarming=false end
                local farmNow=farmActive()
                local combatAllowed=not S.autoQuest or C.questFarming
                if combatAllowed and (S.autoM1 or S.autoWalk or S.autoSkill or farmNow) then
                    local m=target()''')
rep('''if S.autoWalk and not S.fly and not C.travel then''','''if S.autoWalk and not S.fly and not C.travel and not C.hoverActive then''')
rep('''                        if S.autoM1 then local sent,why=punch();S.status=sent and "M1 activated" or why end
                        if S.autoSkill and tick%5==0 then local sent,why=castVampire(S.vampireSkill);S.status=sent and "Ability requested" or why end''','''                        local resting,restReason=recovery()
                        if resting then
                            S.status=restReason;C.progress=nil
                        else
                            if S.autoM1 or farmNow then
                                local sent,why=punch();S.status=sent and "M1 activated" or why
                                local h=m:FindFirstChildOfClass("Humanoid")
                                if farmNow and h and inRange(m,S.hitRange) then
                                    if not C.progress or C.progress.target~=m or h.Health<C.progress.hp then
                                        C.progress={target=m,hp=h.Health,at=os.clock()}
                                    elseif os.clock()-C.progress.at>S.stallTimeout then
                                        C.avoid[m]=os.clock()+30;S.target=nil;C.progress=nil
                                        S.status="Skipped no-damage NPC for 30s; check hover height"
                                        log("farm",S.status)
                                    end
                                else C.progress=nil end
                            end
                            if S.autoSkill and tick%5==0 then local sent,why=castVampire(S.vampireSkill);S.status=sent and "Ability requested" or why end
                        end''')
rep('''                if S.autoPaper and tick%10==0 then''','''                if S.autoPaper and not S.autoQuest and tick%10==0 then''')
rep('''                    questDetailLabel:SetText(short(LP:GetAttribute("Quest2Title") or LP:GetAttribute("HumanSideQuestStage") or "No Quest2/Human state",45).." | "..tostring(LP:GetAttribute("Quest2Progress") or "-").."/"..tostring(LP:GetAttribute("Quest2Required") or "-"))''','''                    local hunt=C.hunts[huntRoute()]
                    if S.autoQuest and hunt then
                        questDetailLabel:SetText(S.questMode.." | "..tostring(hunt.progress or "-").."/"..tostring(hunt.required or "-")..(hunt.turnIn and " | RETURN TO NPC" or ""))
                    else
                        questDetailLabel:SetText(short(LP:GetAttribute("Quest2Title") or LP:GetAttribute("HumanSideQuestStage") or "No Quest2/Human state",45).." | "..tostring(LP:GetAttribute("Quest2Progress") or "-").."/"..tostring(LP:GetAttribute("Quest2Required") or "-"))
                    end''')
rep('''        if player then return not (S.autoFarm or S.autoQuest)''','''        if player then return not (S.autoFarm or S.autoQuest or S.hover)''')
# Preserve stateful reports with the new hunt/recovery data.
rep('''target=S.target and S.target:GetFullName() or "none",routes=available,state=flags,log=C.logs,''','''target=S.target and S.target:GetFullName() or "none",routes=available,state=flags,log=C.logs,
            hunts=C.hunts,recovery={stamina=C.staminaRest==true,health=C.healthRest==true},''')
Path('dh_main_v1_1_logic.lua').write_text(s)
old=Path('NZL_Main_Hub.lua').read_text();prefix=old[:old.index('-- NZL Main Hub 1.0 | client-side')]
prefix=prefix.replace('NZL MAIN HUB 1.0','NZL MAIN HUB 1.1')
Path('NZL_Main_Hub_v1.1.lua').write_text(prefix+s)
print('Saved new main:',Path('NZL_Main_Hub_v1.1.lua').stat().st_size)

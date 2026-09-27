-- CAM Main Hub 3.2.4 | source-backed client integration for place 136406881576517.
-- No downloaded code, hooks, decompilation, arbitrary remotes, purchases or webhooks.
local function StartCAMHub(Lumen)
    local Env = (getgenv and getgenv()) or _G
    if Env.CAMMainHub and Env.CAMMainHub.Stop then pcall(Env.CAMMainHub.Stop) end
    local Players=game:GetService("Players")
    local RS=game:GetService("ReplicatedStorage")
    local Run=game:GetService("RunService")
    local Input=game:GetService("UserInputService")
    local CS=game:GetService("CollectionService")
    local Http=game:GetService("HttpService")
    local LP=Players.LocalPlayer
    assert(LP,"Client required")
    local S={alive=true, autoLevel=false, farm=false, attack=false, skills=false, autoHunt=false,
        loot=false,chest=false,fly=false,noclip=false,speed=false,jump=false,run=false,shift=false,instant=false,
        esp=false,players=false,mobs=false,bosses=false,npcs=false,chests=false,drops=false,muzan=false,lily=false,levers=false,horses=false,
        box=false,fill=false,box3d=false,names=false,distance=false,health=false,hpbar=false,tracer=false,
        notifyBoss=false,notifyMuzan=false,notifyHunts=false,
        targetName="",targetKind="Mob",searchRange=350,hitRange=7,standOff=4,skillRange=35,
        targetMode="Selected mob",mobCode="KaruVillageBandit",bossCode="Zuko",
        positionMode="Above",farmDistance=2,farmHeight=3,travelMode="Tween",travelSpeed=80,orbitSpeed=1,
        lookMode="Horizontal",inputMode="Auto (live punch / native input)",weapon="Auto combat tool",
        questPolicy="Highest eligible",questStage="OFF",questName="-",questProgress="-",equipment="-",noDamageTimeout=20,
        attackDelay=0.5,skillDelay=3,skillHold=0.2,healthStop=25,farmNoclip=true,autoPotion=false,potionHp=35,potionDelay=6,potionChoice="Auto (strongest heal)",baitName="",
        walkSpeed=26,jumpHeight=12,flySpeed=45,espRange=600,espLimit=40,
        priority="Combat first",destinationType="Zone",destination="",huntId="",status="Ready - automation OFF",
        skillSlots={},epoch=0,
        autoParry=false,parryRange=14,parryHold=0.35,parryCooldown=0.9,
        autoTraining=false,trainingMode="Instant (win signal)",trainDelay=0.5,
        buyName="",buyAmount=1,loadoutName="",loadoutText="",rankedKey="",
        autoFish=false,fishDelay=1.0,fishNudge=8,wurfansClue="1",treeNode="Max Health",
        infStamina=false,noCd=false,fastM1=false,
        killAura=false,killAuraRange=12,noDebuffs=false,infJump=false,
        instaKill=false,instaKillPct=10,fastAttack=false,
        autoFarm=false,autoBoss=false,farmMobText="",farmStyle="Behind",farmDist=6,farmHeight=7,farmNoclip=true,farmSpeed=120,searchRange=300,m1Mode="Fast Attack (Combat_Service)",
        fullbright=false,noFog=false,fpsCapText="",
        autoSkills=false,autoSkillText="Breathing Boost",autoBreath=false}
    local C={connections={},toggles={},logs={},modules={},loading={},loaderTasks={},owned={},tickets={},
        collision=setmetatable({}, {__mode="k"}),holds=setmetatable({}, {__mode="k"}),
        humanoids={},humanoidOwners=setmetatable({}, {__mode="k"}),objects={},prompts={},esp={},cooldowns={},huntSent={},huntSeen={},
        skillIndex=0,seen=setmetatable({}, {__mode="k"}),count=0,indexing=true,visualClock=0,
        parryWatched=setmetatable({}, {__mode="k"}),parryPath="input",parryConfirmed=false,lastParry=0,
        parryAttempts=0,parryBlocked=0,parryPerfect=0,parryUnacked=0,
        blockWatchDone=false,trainWatchDone=false,trainSession=nil,sliderSamples={},trainClicks=0,trainWins=0,
        fish={casts=0,bites=0,wins=0,awaitingBite=false,last=0,portalDone=false},fastM1={},fatk={combo=1,next=0,last=0}}
    local stopAll,clearESP,refreshTargets,refreshDestinations,refreshHunts,endTravel
    local statusLabel,targetLabel,resourceLabel,questLabel,nativeLabel,indexLabel,parryLabel,trainLabel,fishLabel,treeLabel
    local targetDrop,destinationDrop,huntDrop
    local bossNames=CAM_BOSS_NAMES
    local function short(x,n) local s=tostring(x);return #s>(n or 160) and s:sub(1,n or 160).."..." or s end
    local function log(kind,text)
        C.logs[#C.logs+1]={time=os.date("!%H:%M:%S"),kind=kind,text=short(text,1000)}
        if #C.logs>120 then table.remove(C.logs,1) end
    end
    local function note(text)
        log("notice",text)
        if S.alive then pcall(function() Lumen:Notification({Name="CAM Main",Description=short(text,220),Duration=5}) end) end
    end
    local function at(root,path)
        for _,name in ipairs(path) do if not root then return nil end;root=root:FindFirstChild(name) end
        return root
    end
    local function live(o) return o and o.Parent and o:IsDescendantOf(workspace) end
    local function char()
        local c=LP.Character
        return c,c and c:FindFirstChildOfClass("Humanoid"),c and c:FindFirstChild("HumanoidRootPart")
    end
    local function part(o)
        if not o then return nil end
        if o:IsA("BasePart") then return o end
        if o:IsA("Attachment") then return part(o.Parent) end
        if o:IsA("Model") then return o:FindFirstChild("HumanoidRootPart") or o.PrimaryPart or o:FindFirstChildWhichIsA("BasePart",true) end
        return nil
    end
    local function position(o)
        local p=part(o);return p and p.Position
    end
    local function focused() return Input:GetFocusedTextBox()~=nil end
    local function menuOpen()
        local m=LP:FindFirstChild("MenuDestination")
        return m and m:IsA("StringValue") and m.Value~=""
    end
    local function usable()
        if not S.alive or game.PlaceId~=136406881576517 then return false,"Unsupported place (read-only)" end
        local _,h,r=char()
        if not h or not r or h.Health<=0 then return false,"Character unavailable" end
        if focused() or menuOpen() then return false,"Paused: text entry / native menu" end
        return true
    end
    local function flag(key,value)
        S[key]=value
        if C.toggles[key] then C.toggles[key]:Set(value,true) end
    end
    local function connect(signal,fn,label)
        local con=signal:Connect(function(...)
            if not S.alive then return end
            local ok,err=pcall(fn,...)
            if not ok then log("callback error",(label or "Callback")..": "..tostring(err));if stopAll then stopAll("Callback failed; see diagnostics") end end
        end)
        C.connections[#C.connections+1]=con;return con
    end
    local function data()
        local base=at(RS,{"Player_Service","Data",LP.Name})
        if not base then return nil end
        local slot=base:FindFirstChild("slotEquipped")
        return slot and at(base,{"slots","Slot"..tostring(slot.Value)})
    end
    local function values() return at(RS,{"Player_Service","Values",LP.Name}) end
    -- Only these specific live game modules may be required, after an explicit UI click.
    local modulePaths={
        Input={"CAM","Client","Components","Client","InputHandler"},
        Run={"CAM","Client","Modules","GamePlay","Run_Handler"},
        Recommended={"CAM","Client","Modules","RecommendedQuest"},
        Quests={"CAM","Global","Subsets","Gameplay","Quests"},
        HuntRules={"CAM","Global","Subsets","Gameplay","Quests","BossHunts"},
        Signal={"Communication","ServerAndClient","Signals","SignalEvent"},
        Regions={"Regions"},
        Info={"CAM","Global","Character_info_provider"},
        Items={"CAM","Global","Collectibles","Items"},
        Requirements={"CAM","Global","Collectibles","ItemRequirements"},
        Restrictions={"CAM","Global","Subsets","Gameplay","ToolbarItemRestrictions"},
        SignalF={"Communication","ServerAndClient","Signals","SignalFunction"},
        PlayerProfile={"CAM","Global","PlayerProfile"},
        ManageCD={"CAM","Global","Subsets","Gameplay","manage_cd"},
        CombatPresets={"CAM","Global","Combat_presets"},
    }
    local function loadNative()
        if game.PlaceId~=136406881576517 then note("Wrong place; native controls disabled") return end
        local epoch=S.epoch
        for key,path in pairs(modulePaths) do
            if not C.modules[key] and not C.loading[key] then
                local obj=at(RS,path)
                if not obj or not obj:IsA("ModuleScript") then
                    C.loading[key]="missing";log("module",key..": missing")
                else
                    C.loading[key]="loading"
                    local thread=task.spawn(function()
                        local ok,result=pcall(require,obj)
                        if not S.alive or epoch~=S.epoch then return end
                        C.loading[key]=(ok and type(result)=="table") and "ready" or "failed"
                        if ok and type(result)=="table" then C.modules[key]=result else log("module",key..": "..short(result)) end
                    end)
                    C.loaderTasks[key]=thread
                    task.delay(10,function()
                        if S.alive and epoch==S.epoch and C.loading[key]=="loading" then
                            C.loading[key]="timeout";if thread then pcall(task.cancel,thread) end
                            log("module",key..": timeout (10s)")
                        end
                    end)
                end
            end
        end
        -- Live layout fact (working script): Signals/SignalEvent is a FOLDER with the
        -- RemoteEvent child "Event"; requiring the folder fails, so resolve it directly.
        if not C.modules.Signal then
            local evt=at(RS,{"Communication","ServerAndClient","Signals","SignalEvent","Event"})
            if evt and (evt:IsA("RemoteEvent") or evt:IsA("UnreliableRemoteEvent")) then
                C.modules.Signal={ToServer=function(...) return evt:FireServer(...) end}
                C.loading.Signal="ready";log("module","Signal: live RemoteEvent resolved directly")
            end
        end
        local ready,total=0,0
        for key in pairs(modulePaths) do total=total+1;if C.modules[key] then ready=ready+1 end end
        note(ready==total and "Native controls ready. Enabled modes continue automatically." or
            ("Connecting native controls: "..ready.."/"..total.." ready. See dashboard for progress."))
    end
    local function release(action)
        C.tickets[action]=nil
        if C.owned[action] then
            C.owned[action]=nil
            local m=C.modules.Input
            if m and type(m.VirtualRelease)=="function" then pcall(m.VirtualRelease,action) end
        end
    end
    local function releaseAll()
        local actions={};for action in pairs(C.owned) do actions[#actions+1]=action end
        for _,action in ipairs(actions) do release(action) end
    end
    local function press(action,duration)
        local ok,why=usable();if not ok then return false,why end
        local m=C.modules.Input
        if not m or type(m.VirtualPress)~="function" or type(m.VirtualRelease)~="function" or type(m.IsDown)~="function" then return false,"Connect native controls first" end
        if C.owned[action] or m.IsDown(action) then return false,"Input already held" end
        C.count=C.count+1;local ticket=C.count;C.owned[action]=true;C.tickets[action]=ticket
        local success,err=pcall(m.VirtualPress,action)
        if not success then release(action);return false,short(err) end
        if duration then
            task.delay(duration,function() if C.tickets[action]==ticket then release(action) end end)
        end
        log("input",action.." (native checks still apply)")
        return true,"Native input: "..action
    end
    local function restoreMovement()
        for p,value in pairs(C.collision) do if p.Parent then pcall(function() p.CanCollide=value end) end;C.collision[p]=nil end
        if C.speedHum then pcall(function() C.speedHum.WalkSpeed=C.oldSpeed end);C.speedHum=nil end
        if C.jumpHum then pcall(function() C.jumpHum.JumpPower=C.oldJumpPower;C.jumpHum.JumpHeight=C.oldJumpHeight end);C.jumpHum=nil end
    end
    local function endFly()
        if C.flyVelocity then C.flyVelocity:Destroy();C.flyVelocity=nil end
        if C.flyAlign then C.flyAlign:Destroy();C.flyAlign=nil end
        if C.flyAttach then C.flyAttach:Destroy();C.flyAttach=nil end
        if C.flyHum then
            pcall(function() C.flyHum.PlatformStand=C.flyStand;C.flyHum.AutoRotate=C.flyRotate end)
            C.flyHum=nil
        end
        C.flyRoot=nil
    end
    local function restoreShift()
        if C.oldShift~=nil then
            local m=C.modules.Run
            if m and type(m.SetShiftLock)=="function" then pcall(m.SetShiftLock,C.oldShift) end
            C.oldShift=nil
        end
    end
    local function endPrompt()
        local p=C.activePrompt;C.activePrompt=nil
        if p then pcall(function() p:InputHoldEnd() end) end
    end
    local function restorePrompts()
        endPrompt()
        for p,duration in pairs(C.holds) do if p.Parent then pcall(function() p.HoldDuration=duration end) end;C.holds[p]=nil end
    end
    local function stopWalk()
        if C.walking then
            local _,h,r=char();if h and r then h:MoveTo(r.Position);h:Move(Vector3.zero) end
            C.walking=false
        end
        C.walkStart=nil;C.walkPos=nil
    end
    stopAll=function(reason)
        local _,h=char();local v=values();local stamina=v and v:FindFirstChild("Stamina")
        C.lastStop={reason=reason or "Stopped",timeUTC=os.date("!%Y-%m-%dT%H:%M:%SZ"),
            autoLevelWasOn=S.autoLevel,farmWasOn=S.farm,questStage=S.questStage,questName=S.questName,
            hp=h and h.Health or nil,maxHp=h and h.MaxHealth or nil,stamina=stamina and stamina.Value or nil,
            backend=C.inputBackend or "not used"}
        S.epoch=S.epoch+1
        for key in pairs(C.toggles) do flag(key,false) end
        for key,thread in pairs(C.loaderTasks) do
            if C.loading[key]=="loading" then if thread then pcall(task.cancel,thread) end;C.loading[key]=nil end
        end
        pcall(actions.m1Up)
        releaseAll();endFly();stopWalk();if endTravel then endTravel() end;restoreMovement();restorePrompts();restoreShift()
        C.questActive=nil;C.questRoute=nil;C.questSentAt=nil;C.questAttempts=0;C.damageWatch=nil;C.punch=nil;C.equipAttempts=0;C.equipmentWait=nil;S.questStage="OFF"
        S.target=nil;S.skillSlots={};C.flyUp=false;C.flyDown=false;C.cooldowns={};C.huntSent={};C.attackAt=nil;C.skillAt=nil;C.potion=nil;C.potionLock=nil;C.potionNext=nil
        if clearESP then clearESP() end
        C.parryWatched=setmetatable({},{__mode="k"});C.blockWatchDone=false;C.trainWatchDone=false;C.trainSession=nil;C.sliderSamples={};C.parryUnacked=0
        S.status=reason or "Stopped";log("stop",S.status)
    end
    -- Source-derived catalog; no untrusted decompiled source is executed.
    local npcByCode,npcByName,npcAlias,routeByKey={},{},{},{}
    for _,row in ipairs(CAM_CATALOG.npcs) do
        npcByCode[row.code]=row;npcByName[row.name]=row
        for _,alias in ipairs(row.aliases) do
            if npcAlias[alias]==nil then npcAlias[alias]=row elseif npcAlias[alias]~=row then npcAlias[alias]=false end
        end
    end
    for _,row in ipairs(CAM_CATALOG.quests) do routeByKey[row.key]=row end
    local function vec(a) return Vector3.new(a[1],a[2],a[3]) end
    local function level()
        local goal=at(data(),{"Exp","Goal"})
        return goal and math.floor(goal.Value/CAM_CATALOG.expPerLevel) or nil
    end
    local function isPlayer(m) return m==LP.Character or Players:GetPlayerFromCharacter(m)~=nil end
    local function npcDefinition(m)
        if not m or isPlayer(m) then return nil end
        local code=m:GetAttribute("NpcCode")
        local child=m:FindFirstChild("NpcCode")
        if not code and child and child:IsA("ValueBase") then code=child.Value end
        if code~=nil and tostring(code)~="" then return npcByCode[code] end
        return npcByName[m.Name] or npcAlias[m.Name] or nil
    end
    local function kindOfNPC(m)
        if isPlayer(m) then return "Player" end
        if CS:HasTag(m,"GauntletStatue") or CS:HasTag(m,"Dialogue") or CS:HasTag(m,"HiddenNpc") then return "NPC" end
        local row=npcDefinition(m)
        if row then return row.boss and "Boss" or "Mob" end
        return "NPC" -- Unknown humanoids are NOT presumed hostile.
    end
    local function validTarget(m,kind,code)
        if not live(m) or isPlayer(m) then return false end
        local h=m:FindFirstChildOfClass("Humanoid");local row=npcDefinition(m)
        if not row or not h or h.Health<=0 or not part(m) then return false end
        local k=kindOfNPC(m)
        if k~="Mob" and k~="Boss" then return false end
        return (not kind or kind==k) and (not code or code==row.code)
    end
    local function selectedCode()
        if S.autoLevel then return C.questRoute and C.questRoute.code end
        if S.targetMode=="Nearest hostile" then return nil end
        return S.targetMode=="Selected boss" and S.bossCode or S.mobCode
    end
    local function target()
        local _,_,r=char();if not r then return nil end
        local code=selectedCode()
        if not code and S.targetMode~="Nearest hostile" then S.target=nil;return nil end
        if S.autoLevel and not C.questActive then S.target=nil;return nil end
        local kind=not S.autoLevel and (S.targetMode=="Selected boss" and "Boss" or S.targetMode=="Selected mob" and "Mob" or nil) or nil
        if S.target and validTarget(S.target,kind,code) and (part(S.target).Position-r.Position).Magnitude<=S.searchRange then
            return S.target,(part(S.target).Position-r.Position).Magnitude
        end
        local best,dist=nil,S.searchRange
        for m in pairs(C.humanoids) do
            if validTarget(m,kind,code) then
                local d=(part(m).Position-r.Position).Magnitude
                if d<dist then best=m;dist=d end
            end
        end
        S.target=best;return best,dist
    end
    local function face(m)
        if S.lookMode=="Off" then return end
        local _,_,r=char();local p=part(m)
        if r and p then
            local goal=S.lookMode=="Full 3D" and p.Position or Vector3.new(p.Position.X,r.Position.Y,p.Position.Z)
            if (goal-r.Position).Magnitude>0.1 then r.CFrame=CFrame.lookAt(r.Position,goal) end
        end
    end
    local function farmPoint(m)
        local p=part(m);local cf=p.CFrame;local d=S.farmDistance;local y=S.farmHeight
        local offset
        if S.positionMode=="Above" then offset=Vector3.new(0,y,d)
        elseif S.positionMode=="Below" then offset=Vector3.new(0,-y,d)
        elseif S.positionMode=="Behind" then offset=-cf.LookVector*d+Vector3.new(0,y,0)
        elseif S.positionMode=="In front" then offset=cf.LookVector*d+Vector3.new(0,y,0)
        elseif S.positionMode=="Left" then offset=-cf.RightVector*d+Vector3.new(0,y,0)
        elseif S.positionMode=="Right" then offset=cf.RightVector*d+Vector3.new(0,y,0)
        elseif S.positionMode=="Orbit" then local a=os.clock()*S.orbitSpeed;offset=Vector3.new(math.cos(a)*d,y,math.sin(a)*d)
        else local _,_,r=char();local away=r.Position-p.Position;away=Vector3.new(away.X,0,away.Z);offset=(away.Magnitude>0.1 and away.Unit or Vector3.new(0,0,1))*d end
        return p.Position+offset
    end
    local function releaseFarmHold()
        if C.farmVelocity then C.farmVelocity:Destroy();C.farmVelocity=nil end
        if C.farmAttachment then C.farmAttachment:Destroy();C.farmAttachment=nil end
        if C.farmHum then pcall(function() C.farmHum.AutoRotate=C.farmRotate end);C.farmHum=nil end
        C.farmRoot=nil
    end
    endTravel=function()
        C.goal=nil;C.goalTarget=nil;C.moveWatch=nil;C.lastDesired=nil
        releaseFarmHold();stopWalk()
    end
    local function goTo(pos,m)
        C.goal=pos;C.goalTarget=m
    end
    local function farmMove(dt)
        if not C.goal or not (S.autoLevel or S.farm) or S.fly then releaseFarmHold();return end
        local ok=usable();local _,h,r=char()
        if not ok or h.Health/math.max(h.MaxHealth,1)*100<=S.healthStop then endTravel();return end
        if C.goalTarget then
            if not validTarget(C.goalTarget,nil,selectedCode()) then endTravel();return end
            C.goal=farmPoint(C.goalTarget)
        end
        local delta=C.goal-r.Position
        if S.travelMode=="Walk" then
            releaseFarmHold();h:MoveTo(C.goal);C.walking=true
        else
            if C.farmRoot~=r then
                releaseFarmHold();C.farmRoot=r;C.farmHum=h;C.farmRotate=h.AutoRotate;h.AutoRotate=false
                C.farmAttachment=Instance.new("Attachment");C.farmAttachment.Name="CAM_FarmHold";C.farmAttachment.Parent=r
                C.farmVelocity=Instance.new("LinearVelocity");C.farmVelocity.Name="CAM_FarmHold"
                C.farmVelocity.Attachment0=C.farmAttachment;C.farmVelocity.RelativeTo=Enum.ActuatorRelativeTo.World
                C.farmVelocity.MaxForce=100000;C.farmVelocity.VectorVelocity=Vector3.zero;C.farmVelocity.Parent=r
            end
            local step=S.travelMode=="Instant" and delta or delta*(math.min(1,S.travelSpeed*math.min(dt,0.1)/math.max(delta.Magnitude,0.001)))
            local pos=r.Position+step
            r.CFrame=CFrame.new(pos)*r.CFrame.Rotation
            r.AssemblyLinearVelocity=Vector3.zero
        end
        if C.goalTarget then face(C.goalTarget) end
        if delta.Magnitude>12 then
            local now=os.clock()
            if not C.moveWatch then C.moveWatch={time=now,position=r.Position} end
            if now-C.moveWatch.time>=8 then
                if (r.Position-C.moveWatch.position).Magnitude<3 then stopAll("Movement blocked/corrected for 8s; stopped") return end
                C.moveWatch={time=now,position=r.Position}
            end
        else C.moveWatch=nil end
    end
    local toolbarNames={"One","Two","Three","Four","Five"}
    local function ensureEquipment()
        local d=data();local info=C.modules.Info;local items=C.modules.Items;local rules=C.modules.Restrictions;local req=C.modules.Requirements
        local equipped=at(LP,{"Items_Config","Equipped"});local toolbar=at(d,{"Inventory","Toolbar"})
        if not d or not equipped or not toolbar or not info or not items or not rules or not req then return false,"Waiting: equipment data/native modules" end
        local function combatItem(index)
            local slot=toolbar:FindFirstChild(toolbarNames[index] or "")
            if not slot or slot.Value==0 then return nil end
            local item=info.GetItemFromId(LP,slot.Value);local def=item and items[item.Name]
            if not def or not (def.HasCombat or def.CombatPreset or item.Name=="Combat") then return nil end
            local limits=rules.GetCurrentRestrictions(LP,toolbarNames[index])
            if limits.Locked or limits.ActionsDisabled or not req.SatisfiesEquip(d,item.Name) then return nil end
            return item
        end
        local desired
        if S.weapon=="Keep equipped" then desired=equipped.Value
        elseif S.weapon=="Auto combat tool" then
            if combatItem(equipped.Value) then desired=equipped.Value else
                for _,i in ipairs({3,1,2,4,5}) do if combatItem(i) then desired=i;break end end
            end
        else desired=tonumber(S.weapon:match("(%d+)")) end
        local item=desired and combatItem(desired)
        if not item then
            -- working script path: slot empty / weapon lives in Inventory, not on the toolbar -> push it first
            if C.modules.Signal then
                local invRoot=data() and at(data(),{"Inventory","Inventory"})
                if invRoot then
                    for _,it in ipairs(invRoot:GetChildren()) do
                        local def=items[it.Name]
                        if def and (def.HasCombat or def.CombatPreset or it.Name=="Combat") then
                            local id=it:FindFirstChild("Id")
                            local idv=(id and id:IsA("ValueBase")) and id.Value or it:GetAttribute("Id")
                            if idv~=nil then
                                if (C.toolbarEquipAt or 0)>os.clock() then return false,"Pushing weapon to toolbar (Toolbar_Equip)" end
                                C.toolbarEquipAt=os.clock()+1
                                pcall(C.modules.Signal.ToServer,"Toolbar_Equip",it.Name,idv)
                                log("equipment","Toolbar_Equip pushed: "..it.Name)
                                return false,"Pushing weapon to toolbar: "..it.Name
                            end
                        end
                    end
                end
            end
            return false,"No usable combat weapon in selected toolbar slot"
        end
        if equipped.Value~=desired then
            if (C.equipAt or 0)>os.clock() then return false,"Waiting for equipment acknowledgement" end
            C.equipAt=os.clock()+2;C.equipAttempts=(C.equipAttempts or 0)+1
            if C.equipAttempts>3 then stopAll("Equipment rejected 3 times; equip weapon manually") return false,S.status end
            -- working script order: set the slot AND send Item_Equip directly (HUD Changed listener is not relied on)
            equipped.Value=desired
            if C.modules.Signal then pcall(C.modules.Signal.ToServer,"Item_Equip",desired) end
            log("equipment","Selected native toolbar slot "..desired.." / "..item.Name)
            return false,"Preparing weapon: "..item.Name
        end
        local actual=info.Get_equipped_tool(LP)
        if actual and actual.Name==item.Name then C.equipAttempts=0;S.equipment=item.Name;return true end
        if (C.equipAt or 0)>0 and os.clock()-C.equipAt>1.5 then
            log("equipment","equip ack timeout; attacking anyway ("..item.Name..")")
            return true,"Equip ack missing - attacking anyway"
        end
        return false,"Preparing weapon: "..item.Name
    end
    local function baitScan()
        C.baitItems={};local names={}
        local d=data();local inv=d and at(d,{"Inventory","Inventory"})
        if inv then
            for _,item in ipairs(inv:GetChildren()) do
                local id=item:FindFirstChild("Id")
                if id and id:IsA("ValueBase") and item.Name:lower():find("bait",1,true) then
                    local label=item.Name.." #"..tostring(id.Value)
                    names[#names+1]=label;C.baitItems[label]=id.Value
                end
            end
        end
        table.sort(names);return names
    end
    local function equippedBait()
        local d=data();local v=d and at(d,{"Misc","EquippedBaitId"})
        return (v and v:IsA("ValueBase")) and v.Value or 0
    end
    local function baitRequest(id)
        local signal=C.modules.Signal
        if not signal or type(signal.ToServer)~="function" then return false,"Connect native controls first" end
        local ok,err=pcall(signal.ToServer,"EquipBait",id)
        if not ok then return false,short(err) end
        C.baitRequests=(C.baitRequests or 0)+1;C.baitWatch={id=id,deadline=os.clock()+3}
        log("bait","EquipBait "..tostring(id).." requested")
        return true,"Bait request sent; watching Misc/EquippedBaitId"
    end
    local directPotions={["Health Elixir"]=60,["Health Potion"]=25}
    local potionPriority={"Health Elixir","Health Potion","Health Regen Elixir","Health Regen Potion"}
    local function potionSlot()
        local d=data();local info=C.modules.Info;local toolbar=d and at(d,{"Inventory","Toolbar"})
        if not toolbar or not info or type(info.GetItemFromId)~="function" then return nil,"Waiting: inventory data / native modules" end
        local names=S.potionChoice=="Auto (strongest heal)" and potionPriority or {S.potionChoice}
        for _,wanted in ipairs(names) do
            for index=1,5 do
                local slot=toolbar:FindFirstChild(toolbarNames[index])
                if slot and slot.Value~=0 then
                    local item=info.GetItemFromId(LP,slot.Value)
                    if item and item.Name==wanted then return index,wanted end
                end
            end
        end
        return nil,"No selected healing potion on toolbar slots 1-5"
    end
    local function finishPotion(success,observedBy)
        local cycle=C.potion;C.potion=nil
        if not cycle then return end
        if success then
            C.potionAcks=(C.potionAcks or 0)+1;C.potionFailures=0;C.potionLock=os.clock()+1
            log("potion",cycle.name.." acknowledged by "..observedBy)
        else
            C.potionFailures=(C.potionFailures or 0)+1;C.potionNext=os.clock()+S.potionDelay+2;C.potionLock=nil
            if (C.potionFailures or 0)>=3 and S.autoPotion then
                flag("autoPotion",false)
                note("Auto Potion paused: 3 uses without observed healing. Check potion/slot, then re-enable.")
            end
        end
        -- When idle, restore the toolbar slot the player had before the drink.
        -- While farming, ensureEquipment re-equips the weapon itself after the lock expires.
        if not (S.autoLevel or S.farm) and S.alive then
            local eq=at(LP,{"Items_Config","Equipped"})
            if eq and eq.Value==cycle.slot then eq.Value=cycle.previousSlot end
        end
    end
    local function stepPotion(h)
        local cycle=C.potion;if not cycle then return end
        local signal=C.modules.Signal;local info=C.modules.Info;local now=os.clock()
        if cycle.stage=="equip" then
            local tool=info and info.Get_equipped_tool(LP)
            if tool and tool.Name==cycle.name then
                if not signal or type(signal.ToServer)~="function" then log("potion","Signal module unavailable for native click");finishPotion(false);return end
                cycle.before=h.Health
                local d=data();local inv=d and at(d,{"Inventory","Inventory"});local owned=inv and inv:FindFirstChild(cycle.name)
                local amount=owned and owned:FindFirstChild("Amount")
                cycle.amount=amount;cycle.amountBefore=amount and amount.Value
                local _,_,root=char()
                local ok=pcall(signal.ToServer,"Tool_Mouse","Down",root and root.Position)
                if not ok then log("potion","Native click request failed");finishPotion(false);return end
                cycle.stage="release";cycle.at=now+0.15
            elseif now>cycle.deadline then
                log("potion","Potion equip not acknowledged by native toolbar");finishPotion(false)
            end
        elseif cycle.stage=="release" then
            if now>=cycle.at then
                local _,_,root=char()
                pcall(signal.ToServer,"Tool_Mouse","Up",root and root.Position)
                cycle.stage="observe";cycle.deadline=now+4.5
            end
        elseif cycle.stage=="observe" then
            local _,hum=char()
            if hum and hum.Health>cycle.before+1 then finishPotion(true,"HP increase") return end
            if cycle.amount and cycle.amount.Parent and cycle.amountBefore and cycle.amount.Value<cycle.amountBefore then finishPotion(true,"item consumption") return end
            if now>cycle.deadline then log("potion","No healing / consumption observed after native click");finishPotion(false) end
        end
    end
    local function usePotion(h)
        -- Exactly the native toolbar flow: set the potion slot (native Toolbar validates + sends
        -- Item_Equip), wait for the equip ack, then Tool_Mouse Down/Up like a player click.
        if C.potion then stepPotion(h) return C.potion~=nil,"Potion in progress" end
        if (C.potionNext or 0)>os.clock() then return false,"Potion recheck cooldown" end
        if C.combatBusy then return false,"Waiting for native combat call before potion" end
        if h.Health>=h.MaxHealth*S.potionHp/100 then return false,"HP above potion threshold" end
        if directPotions[S.potionChoice] and h.MaxHealth-h.Health<15 then return false,"Deficit too small for a direct potion" end
        local slot,name=potionSlot()
        if not slot then
            if not C.potionTip then C.potionTip=true;log("potion","No selected healing potion on toolbar slots 1-5") end
            return false,"Potion: none on toolbar slots 1-5"
        end
        C.potionTip=nil
        local equipped=at(LP,{"Items_Config","Equipped"})
        if not equipped or not C.modules.Info or not C.modules.Signal then return false,"Connect native controls first" end
        C.potionRequests=(C.potionRequests or 0)+1
        C.potionLock=os.clock()+8
        C.potion={stage="equip",slot=slot,name=name,previousSlot=equipped.Value,deadline=os.clock()+2}
        equipped.Value=slot
        log("potion","Toolbar slot "..slot.." / "..name.." at "..math.floor(h.Health).." HP (native equip + click)")
        stepPotion(h)
        return true,"Potion: native equip + click requested"
    end
    local function findPunch()
        local scriptObject=at(LP,{"PlayerScripts","CU","Combat"})
        if C.punchScript==scriptObject and C.punch then return C.punch end
        C.punch=nil;C.punchScript=nil
        local api=getsenv or Env.getsenv
        if type(api)~="function" or not scriptObject or not scriptObject:IsA("LocalScript") then return nil end
        local ok,e=pcall(api,scriptObject)
        if ok and type(e)=="table" and type(e.punch)=="function" then
            C.punch=e.punch;C.punchScript=scriptObject;return C.punch
        end
        return nil
    end
    local function comboTime()
        local t=at(values(),{"ComboTrackerClient","Time"});return t and t.Value or 0
    end
    local function observeCombo()
        local current=comboTime()
        if C.lastComboObserved==nil then C.lastComboObserved=current;return false end
        if current>C.lastComboObserved then
            C.lastComboObserved=current;C.comboAcks=(C.comboAcks or 0)+1;return true
        end
        return false
    end
    local function attackOnce()
        local ok,why=usable();if not ok then return false,why end
        if C.potion or (C.potionLock or 0)>os.clock() then return false,"Potion in progress" end
        local observedCombo=observeCombo()
        local m,d=target();if not m then return false,"No matching loaded hostile NPC" end
        if d>S.hitRange then return false,"Travelling: target outside M1 range" end
        local ready,msg=ensureEquipment()
        if not ready then
            C.equipmentWait=C.equipmentWait or os.clock()
            if os.clock()-C.equipmentWait>15 then stopAll("Equipment unavailable for 15s: "..msg);return false,S.status end
            return false,msg
        end
        C.equipmentWait=nil
        if C.combatBusy then
            if os.clock()-(C.combatStart or os.clock())>10 then stopAll("Native combat call has not returned for 10s");return false,S.status end
            return false,"Native combat running"
        end
        if (C.attackAt or 0)>os.clock() then return false,C.lastCombatResult or "M1 cooldown" end
        face(m);C.attackAt=os.clock()+S.attackDelay
        C.attackRequests=(C.attackRequests or 0)+1
        local h=m:FindFirstChildOfClass("Humanoid")
        if not C.damageWatch or C.damageWatch.target~=m then C.damageWatch={target=m,hp=h.Health,time=os.clock(),combo=comboTime()} end
        local watch=C.damageWatch
        if h.Health<watch.hp then C.damageEvents=(C.damageEvents or 0)+1;watch.time=os.clock();watch.hp=h.Health end
        if os.clock()-watch.time>S.noDamageTimeout then
            stopAll(comboTime()<=watch.combo and "No native combo / damage: input or equipment unavailable" or "No target HP decrease: reduce height/distance or check target immunity")
            return false,S.status
        end
        local punch=S.inputMode~="Native input only" and findPunch() or nil
        if punch then
            C.combatBusy=true;C.combatStart=os.clock();C.inputBackend="Live Combat.punch";local epoch=S.epoch;local before=comboTime()
            task.spawn(function()
                if not S.alive or epoch~=S.epoch then C.combatBusy=false;return end
                local success,result=pcall(punch);C.combatBusy=false
                if not S.alive or epoch~=S.epoch then return end
                if not success then C.punch=nil;C.lastCombatResult="Native punch error: "..short(result);stopAll(C.lastCombatResult);return end
                if type(result)=="number" then C.attackAt=os.clock()+math.max(S.attackDelay,math.min(result,5)) end
                if comboTime()>before then observeCombo();C.lastCombatResult="Native combo observed; server damage not guaranteed"
                else C.lastCombatResult="Native combat blocked/cooling down; waiting" end
            end)
            return true,C.lastCombatResult or "Native combat requested"
        end
        C.inputBackend="InputHandler (unconfirmed until combo changes)"
        local sent,err=press("Combat",0.12)
        return sent,sent and (observedCombo and "Native combo observed; M1 input repeated" or "M1 input sent; waiting for native combo / target HP") or err
    end
    local function safeDefinition(route)
        local q=C.modules.Quests;local def=q and q.Holder and q.Holder[route.key]
        if not def then return nil,"Quest definitions not loaded (Regions)" end
        if def.Category~="Combat" or def.WenCostOnAccept or def.ItemCostOnAccept or def.NextQuest or def.LogCompletion or def.TaskSpecs or def.NoSave or def.Event then return nil,"Route no longer a free repeatable kill quest" end
        if not def.QuestInstance or def.QuestInstance.Name~=route.title then return nil,"Quest definition changed" end
        local tasks=def.QuestInstance:FindFirstChild("Tasks");local list=tasks and tasks:GetChildren() or {}
        if #list~=1 then return nil,"Quest task structure changed" end
        local code=list[1]:FindFirstChild("Code");local max=list[1]:FindFirstChild("Max")
        if not code or code.Value~=route.code or not max or max.Value~=route.count then return nil,"Quest task contract changed" end
        return def
    end
    local function chooseRoute()
        local lv=level();if not lv then return nil,"Waiting for Exp.Goal" end
        local req=C.modules.Requirements;local q=C.modules.Quests
        if not req or not q or not C.modules.Regions then return nil,"Waiting for Quests / Regions / Requirements modules" end
        local selected,reason=nil,"No source-backed route meets native requirements"
        for _,route in ipairs(CAM_CATALOG.quests) do
            if route.level<=lv and (S.questPolicy~="Mobs only" or not npcByCode[route.code].boss) then
                local def,err=safeDefinition(route)
                if def then
                    local npcReq=C.modules.Regions.NpcRequirements and C.modules.Regions.NpcRequirements[route.npc]
                    if (not def.Requirements or req.Passes(data(),def.Requirements)) and (not npcReq or req.Passes(data(),npcReq)) then
                        if not selected or route.level>selected.level then selected=route end
                    end
                else reason=err end
            end
        end
        return selected,reason
    end
    local function activeRoute()
        local holder=at(data(),{"Quests","Holder"});if not holder then return nil,nil end
        for _,instance in ipairs(holder:GetChildren()) do
            local key=instance:FindFirstChild("QuestString");local route=key and routeByKey[key.Value]
            if not route then for _,r in ipairs(CAM_CATALOG.quests) do if r.title==instance.Name then route=r;break end end end
            if route then return route,instance end
        end
        return nil,nil
    end
    local function taskProgress(instance)
        local tasks=instance and instance:FindFirstChild("Tasks");local done,total=0,0
        if tasks then for _,t in ipairs(tasks:GetChildren()) do
            local v=t:FindFirstChild("Value");local max=t:FindFirstChild("Max")
            if v and max then done=done+math.min(v.Value,max.Value);total=total+max.Value end
        end end
        return done,total
    end
    local function questStep()
        local route,active=activeRoute();local now=os.clock()
        if active then
            if not safeDefinition(route) then endTravel();return false,"Active quest does not match safe route contract" end
            if C.questActive~=active then
                C.questActive=active;C.questRoute=route;C.questAttempts=0;C.questSentAt=nil;C.completeWait=nil
                C.questBaseline={exp=(at(data(),{"Exp","Current"}) or {}).Value,goal=(at(data(),{"Exp","Goal"}) or {}).Value}
                log("quest acknowledged",route.key)
            end
            local done,total=taskProgress(active);S.questProgress=done.."/"..total
            S.questName=route.title
            if total==0 then endTravel();return false,"Waiting for replicated quest tasks" end
            if done>=total then
                endTravel();release("Combat");C.completeWait=C.completeWait or now;S.questStage="Await server completion"
                if now-C.completeWait>15 then stopAll("Quest tasks complete but server has not closed quest; no invented turn-in remote") end
                return false,S.status=="Quest tasks complete but server has not closed quest; no invented turn-in remote" and S.status or "Tasks complete; waiting for server completion/reward"
            end
            C.completeWait=nil;S.questStage="Farm";return true
        end
        if C.questActive then
            log("quest removed","Server holder entry disappeared: "..C.questRoute.title.."; reward not independently proven")
            C.questActive=nil;C.questRoute=nil;C.questSentAt=nil;C.questAttempts=0;C.completeWait=nil;C.questReselectAt=now+1
            S.target=nil;endTravel()
        end
        if (C.questReselectAt or 0)>now then return false,"Quest closed; refreshing level" end
        local chosen,why=chooseRoute()
        if not chosen then endTravel();S.questStage="Waiting";return false,why end
        if not C.questRoute or C.questRoute.key~=chosen.key then C.questRoute=chosen;C.questAttempts=0;C.questSentAt=nil end
        route=C.questRoute;S.questName=route.title;S.questProgress="0/"..route.count
        local _,_,r=char();local npcPos=vec(route.npcPosition);local regions=C.modules.Regions
        if regions and type(regions.GetNpcSpawn)=="function" then
            local ok,pos=pcall(regions.GetNpcSpawn,route.npc)
            if ok and typeof(pos)=="CFrame" then npcPos=pos.Position elseif ok and typeof(pos)=="Vector3" then npcPos=pos end
        end
        if (r.Position-npcPos).Magnitude>12 then
            S.questStage="Travel to NPC";goTo(npcPos+Vector3.new(0,3,4));return false,"Lv "..level()..": travelling to "..route.npc
        end
        endTravel()
        if C.questSentAt then
            S.questStage="Await acceptance"
            if now-C.questSentAt<8 then return false,"AddQuest sent; waiting for Data.Quests.Holder" end
            C.questSentAt=nil
            if C.questAttempts>=3 then stopAll("Quest not acknowledged after 3 requests: "..route.key);return false,S.status end
        end
        local q,signal=C.modules.Quests,C.modules.Signal
        if not signal or type(signal.ToServer)~="function" then return false,"Waiting for native Signal module" end
        local allowed,reason=q.CanAddQuest(route.key)
        if allowed~=true then S.questStage="Cooldown / eligibility";return false,"Native CanAddQuest denied: "..tostring(reason).." (cooldown or active category)" end
        if not safeDefinition(route) then return false,"Quest contract changed before acceptance" end
        C.questAttempts=(C.questAttempts or 0)+1;C.questSentAt=now;S.questStage="Await acceptance"
        signal.ToServer("AddQuest",route.key);log("quest request",route.key)
        return false,"Requested "..route.title.."; waiting for server data"
    end
    local function farmStep()
        local m,dist=target()
        if not m then
            release("Combat");C.damageWatch=nil
            local row=npcByCode[selectedCode()]
            if row and (S.farm or S.autoLevel) then
                local pos=vec(row.position);local regions=C.modules.Regions
                if regions and type(regions.GetNpcSpawn)=="function" then
                    local ok,current=pcall(regions.GetNpcSpawn,row.name)
                    if ok and typeof(current)=="Vector3" then pos=current elseif ok and typeof(current)=="CFrame" then pos=current.Position end
                end
                pos=pos+Vector3.new(0,4,0);goTo(pos)
                local _,_,r=char()
                return false,(r.Position-pos).Magnitude>20 and "Travelling to spawn: "..row.name or "Waiting for spawn / streaming: "..row.name
            end
            endTravel();return false,"No source-whitelisted hostile in range"
        end
        if S.farm or S.autoLevel then goTo(farmPoint(m),m) else endTravel() end
        if S.autoLevel or S.farm or S.attack then
            local sent,msg=attackOnce()
            return sent,(S.autoLevel and (S.questProgress.." | ") or "")..msg
        end
        return true,"Target selected"
    end

    local skillActions={"Skills_1st","Skills_2nd","Skills_3rd","Skills_4th","Skills_5th","Skills_6th","Skills_7th","Skills_8th","Skills_9th","Skills_10th"}
    local function skillOnce()
        local m,d=target();if not m or d>S.skillRange then return false,"No selected target in skill range" end
        if C.skillAt and os.clock()-C.skillAt<S.skillDelay then return false,"Skill pacing" end
        for _=1,10 do
            C.skillIndex=C.skillIndex%10+1
            if S.skillSlots[C.skillIndex] then
                C.skillAt=os.clock();return press(skillActions[C.skillIndex],S.skillHold)
            end
        end
        return false,"Select at least one skill input slot"
    end
    local function classify(o)
        if not live(o) then return nil end
        if not (o:IsA("Model") or o:IsA("BasePart")) then return nil end
        if o.Name=="MuzanLairModel" or o.Name=="Muzan" then return "Muzan" end
        if o:IsA("Model") and o:FindFirstChildOfClass("Humanoid") then return kindOfNPC(o) end
        local par=o.Parent
        local chest=workspace:FindFirstChild("Chests")
        local drops=workspace:FindFirstChild("LootDrops")
        if par==chest or o:GetAttribute("ChestGuid")~=nil then return "Chest" end
        if par==drops or CS:HasTag(o,"LootDrop") then return "Loot" end
        if CS:HasTag(o,"SicklesLever") then return "Lever" end
        if o.Name=="Spider Lily" then return "Spider Lily" end
        if o.Name=="MuzanLairModel" or o.Name=="Muzan" then return "Muzan" end
        if o.Name=="Wild Horse" then return "Wild Horse" end
        if par and par.Name=="Regions" and (par.Parent==workspace:FindFirstChild("Map") or par.Parent==workspace:FindFirstChild("Debree")) then return "Zone" end
        if par==workspace:FindFirstChild("Training") then return "Training" end
        return nil
    end
    local actions={}
    -- v2.3.0 Auto Parry (beta). Protocol facts from server values + decompiled 012_Skill_Controller:
    -- block = native Skills_1st hold; server ack = Values/<player>/Blocking node (value 9),
    -- perfect = the same node with Perfect / PerfectNpc children (server-decided, so this is an honest ack).
    actions.watchBlockingValues=function()
        if C.blockWatchDone then return end
        local vf=values();if not (vf and vf.ChildAdded) then return end
        C.blockWatchDone=true
        connect(vf.ChildAdded,function(o)
            if o.Name=="Blocking" then
                C.parryBlocked=C.parryBlocked+1;C.parryUnacked=0
                if not C.parryConfirmed then C.parryConfirmed=true;C.parryPath="input";log("parry","server ack: Blocking value observed") end
                if o.ChildAdded then connect(o.ChildAdded,function(kid)
                    if kid.Name=="Perfect" or kid.Name=="PerfectNpc" then C.parryPerfect=C.parryPerfect+1 end
                end,"Perfect parry watcher") end
            end
        end,"Blocking ack watcher")
    end
    actions.blockTap=function(hold)
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
    actions.onHostileAnim=function(model,track)
        if not S.autoParry or not S.alive then return end
        if track==nil then return end
        local okP,prio=pcall(function() return track.Priority end)
        local okE,actionVal=pcall(function() return Enum.AnimationPriority.Action.Value end)
        if okP and prio~=nil and prio.Value~=nil and okE and actionVal~=nil and prio.Value<actionVal then return end
        local now=os.clock()
        if now-C.lastParry<S.parryCooldown then return end
        local _,_,r=char();if not r then return end
        local root=model and model:FindFirstChild("HumanoidRootPart")
        if not live(root) then return end
        if (root.Position-r.Position).Magnitude>S.parryRange then return end
        local vel=root.AssemblyLinearVelocity
        if vel and Vector3.new(vel.X,0,vel.Z).Magnitude>3 then return end
        actions.watchBlockingValues()
        C.lastParry=now;C.parryAttempts=C.parryAttempts+1
        local ok=actions.blockTap(S.parryHold)
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
    actions.watchParryModel=function(m)
        if not m or C.parryWatched[m] then return end
        local k=kindOfNPC(m)
        if k~="Mob" and k~="Boss" then return end
        local h=m:FindFirstChildOfClass("Humanoid")
        local a=h and h:FindFirstChildOfClass("Animator")
        if not (a and a.AnimationPlayed) then return end
        C.parryWatched[m]=true
        connect(a.AnimationPlayed,function(t) actions.onHostileAnim(m,t) end,"Auto Parry anim watcher")
    end
    -- v2.3.0 Auto Training (beta). From decompiled 137_Client: client-side success reports
    -- training_signaler "StateChanged" then "Stop", true. Instant mode sends exactly that.
    -- Default mode auto-plays the slider UI instead (clicks only inside the target zone).
    actions.trainingSignal=function(action,boolArg)
        local signal=C.modules.Signal
        if not (signal and type(signal.ToServer)=="function") then return false end
        if boolArg~=nil then pcall(signal.ToServer,"training_signaler",action,boolArg==true)
        else pcall(signal.ToServer,"training_signaler",action) end
        log("training",action..(boolArg~=nil and " | win=true" or ""))
        return true
    end
    actions.autoPlaySlider=function(session)
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
    actions.startTrainingSession=function(trigger)
        if C.trainSession then return end
        local session=os.clock();C.trainSession=session
        log("training","session start: "..tostring(trigger))
        task.spawn(function()
            if S.trainingMode=="Instant (win signal)" then
                task.wait(S.trainDelay or 0.5)
                if C.trainSession~=session or not S.autoTraining then return end
                actions.trainingSignal("StateChanged")
                task.wait(0.35)
                if C.trainSession~=session or not S.autoTraining then return end
                if actions.trainingSignal("Stop",true) then C.trainWins=C.trainWins+1 end
            else
                local okP,res,why=pcall(autoPlaySlider,session)
                if not okP then log("training","slider error: "..tostring(res));note("Auto Training slider error: "..short(res))
                elseif not res then log("training","slider: "..tostring(why));note("Auto Training slider: "..tostring(why)) end
            end
            task.delay(4,function() if C.trainSession==session then C.trainSession=nil end end)
        end)
    end
    actions.watchTrainingValues=function()
        if C.trainWatchDone then return end
        local vf=values();if not (vf and vf.ChildAdded) then return end
        C.trainWatchDone=true
        connect(vf.ChildAdded,function(o)
            if not S.autoTraining then return end
            if o.Name=="pause_gameplay" or o.Name=="skill_stand_still" or o.Name=="Training" then actions.startTrainingSession(o.Name) end
        end,"Auto Training trigger")
        connect(vf.ChildRemoved,function(o)
            if o.Name=="pause_gameplay" or o.Name=="Training" then C.trainSession=nil end
        end,"Auto Training end")
    end
    -- v2.3.1 Auto Fishing. From decompiled 1_584 (client) + 002_ServerClientPortal:
    -- bites arrive via portal Event:FireClient("FishingRod","Bite",id); success answer = FireServer("FishingRod", id, true).
    -- Cast = native Tool activation of a *Fishing Rod; reward/cast validation stays server-side.
    actions.fishPortal=function()
        return at(RS,{"CAM","Global","ServerClientPortal","Event"})
    end
    actions.watchFishPortal=function()
        if C.fish.portalDone then return end
        local portal=actions.fishPortal()
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
    actions.findRod=function()
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
    actions.castRod=function()
        local rod=actions.findRod()
        if not rod then return false,"No *Fishing Rod tool found in backpack/character" end
        local _,h=char()
        if rod.Parent~=LP.Character and h and type(h.EquipTool)=="function" then pcall(function() h:EquipTool(rod) end) end
        if type(rod.Activate)=="function" then
            local ok,err=pcall(function() rod:Activate() end)
            if not ok then return false,"Tool activation failed: "..short(err) end
        end
        C.fish.casts=C.fish.casts+1;C.fish.last=os.clock();C.fish.awaitingBite=true
        actions.watchFishPortal()
        log("fishing","cast #"..C.fish.casts)
        return true
    end
    -- v2.3.0 manual action helpers (explicit click only; no auto-spend loops)    -- v3.1.0 direct farm core, ported from the working script:
    -- workspace.Humanoids.Regions scan -> defending skip (NpcCounter/Blocking) -> getFarmTargetCFrame(stepped) -> raw Combat_Service
    actions.hostileScan=function()
        local h0=workspace:FindFirstChild("Humanoids");local regions=h0 and h0:FindFirstChild("Regions")
        local out={}
        for _,m in ipairs((regions or workspace):GetDescendants()) do
            if type(m)=="table" or type(m)=="userdata" then pcall(function()
                if m:IsA("Model") then
                    local h=m:FindFirstChildOfClass("Humanoid");local r=h and m:FindFirstChild("HumanoidRootPart")
                    if r and h.Health>0 then
                        local isPlayer=false
                        if Players and Players.GetPlayerFromCharacter then local ok,rp=pcall(Players.GetPlayerFromCharacter,Players,m);isPlayer=ok and rp~=nil end
                        if not isPlayer then out[#out+1]={m=m,h=h,r=r} end
                    end
                end
            end) end
        end
        return out
    end
    actions.isFarmDefending=function(m)
        local nc;local okA=pcall(function() nc=m:GetAttribute("NpcCounter") end)
        if okA and (nc==1 or nc==2) then return true end
        local okB,t=pcall(function() return m:FindFirstChild("NpcCounterTriggered") end)
        if okB and t then return true end
        local okC,bl=pcall(function() return m:FindFirstChild("Blocking") end)
        local okD,pb=pcall(function() return m:FindFirstChild("PierceBlock") end)
        return okC and bl~=nil and not (okD and pb~=nil)
    end
    actions.pickFarmTarget=function()
        local ch=LP.Character;local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        local filters={}
        for raw in string.gmatch(","..S.farmMobText..",","([^,]+)") do filters[(raw:gsub("^%s+",""):gsub("%s+$","")):lower()]=true end
        local best,bd
        for _,e in ipairs(actions.hostileScan() or {}) do
            local boss=(type(CAM_BOSS_NAMES)=="table" and CAM_BOSS_NAMES[e.m.Name]==true) or false
            if ((S.autoBoss and boss) or (S.autoFarm and not boss)) then
                local nm=tostring(e.m.Name):lower()
                if next(filters)==nil or filters[nm] then
                    local d=(e.r.Position-hrp.Position).Magnitude
                    if d<=S.searchRange and (bd==nil or d<bd) then best,bd=e,d end
                end
            end
        end
        return best
    end
    actions.farmGoalCF=function(tr)
        local st=S.farmStyle;local off
        if st=="Above" then off=CFrame.new(0,S.farmHeight,0)
        elseif st=="Front" then off=CFrame.new(0,0,-S.farmDist)
        elseif st=="Below" then off=CFrame.new(0,-S.farmHeight,0)
        else off=CFrame.new(0,0,S.farmDist) end
        local desired=(tr.CFrame*off).Position
        local up=Vector3.new(0,1,0)
        if st=="Above" or st=="Below" then up=Vector3.new(0,0,-1) end
        return CFrame.lookAt(desired,tr.Position,up)
    end
    actions.farmTick=function()
        local ch=LP.Character;local hrp=ch and ch:FindFirstChild("HumanoidRootPart");local hum=ch and ch:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health<=0 then C.farmTarget=nil;pcall(actions.m1Up);return false,"No character" end
        local t=actions.pickFarmTarget()
        C.farmTarget=t
        if not t then pcall(actions.m1Up);return false,"No farm target in range" end
        local eqOk,eqMsg=ensureEquipment()
        if not eqOk then pcall(actions.m1Up);return false,eqMsg end
        if S.farmNoclip then pcall(function()
            for _,part in ipairs(ch:GetDescendants()) do
                if part.IsA and part:IsA("BasePart") and part.CanCollide then part.CanCollide=false end
            end
        end) end
        local defending=actions.isFarmDefending(t.m)
        local inRange=(t.r.Position-hrp.Position).Magnitude<=math.max(S.farmDist+8,10)
        if S.m1Mode=="Fast Attack (Combat_Service)" then
            if not defending then pcall(actions.fastAttackTick) end
            pcall(actions.m1Up)
        else
            if not defending and inRange then pcall(actions.m1Down) else pcall(actions.m1Up) end
        end
        local now=os.clock()
        local dt=math.min(math.max(now-(C.moveT or 0),0),0.2)
        C.moveT=now
        local goal=actions.farmGoalCF(t.r)
        local delta=goal.Position-hrp.Position;local d=delta.Magnitude
        pcall(function() hrp.AssemblyLinearVelocity=Vector3.new();hrp.AssemblyAngularVelocity=Vector3.new() end)
        if d<=1 or S.farmSpeed<=0 then
            hrp.CFrame=goal
        else
            -- small steps every heartbeat keep the server sync'd; no big rubber-band jumps
            local step=math.min(d,math.max(S.farmSpeed*dt,S.farmSpeed*0.016))
            local up=(S.farmStyle=="Above" or S.farmStyle=="Below") and Vector3.new(0,0,-1) or Vector3.new(0,1,0)
            hrp.CFrame=CFrame.lookAt(hrp.Position+delta.Unit*step,goal.Position,up)
        end
        -- stall watchdog: if the server still drags us back (walls/colliders), snap to the goal once per second
        if d>2 then
            if not C.stallPos then C.stallPos=hrp.Position;C.stallAt=now
            elseif (hrp.Position-C.stallPos).Magnitude<0.6 and now-C.stallAt>0.75 then
                hrp.CFrame=goal;C.stallPos=hrp.Position;C.stallAt=now;log("farm","movement stall: snapped to target position")
            elseif (hrp.Position-C.stallPos).Magnitude>=0.6 then C.stallPos=hrp.Position;C.stallAt=now end
        else C.stallPos=nil;C.stallAt=nil end
        return true,"Farming "..tostring(t.m.Name)
    end
    -- v2.5.0 instant kill + instant attack: recipes ported from a WORKING third-party script for THIS game
    -- (uploaded by the user): kill via Health=0 on network-owned mobs; attack via raw FireServer Combat_Service
    -- with preset-computed hit delay, combo cycling and combo-duration reset - the game's own client protocol.
    actions.instaKillTick=function()
        local hum=workspace:FindFirstChild("Humanoids");local regions=hum and hum:FindFirstChild("Regions")
        if not regions then return false,"workspace.Humanoids.Regions not found" end
        local chk=rawget(_G,"isnetworkowner")
        if type(chk)~="function" and type(getfenv)=="function" then local ok,f=pcall(getfenv,2);if ok then chk=rawget(f,"isnetworkowner") end end
        if type(chk)~="function" then return false,"isnetworkowner() API missing (executor)" end
        local killed=0
        for _,m in ipairs(regions:GetDescendants()) do
            if type(m)=="table" or type(m)=="userdata" then pcall(function()
                if m:IsA("Model") then
                    local h=m:FindFirstChildOfClass("Humanoid");local rp=h and m:FindFirstChild("HumanoidRootPart")
                    if rp and h.Health>0 and h.MaxHealth>0 and (h.Health/h.MaxHealth*100)<=S.instaKillPct then
                        if not rp.Anchored then
                            local ok,own=pcall(chk,rp)
                            if ok and own==true then
                                h.Health=0;pcall(function() h:ChangeState(Enum.HumanoidStateType.Dead) end);killed=killed+1
                            end
                        end
                    end
                end
            end) end
        end
        return killed
    end
    actions.curPower=function()
        local v=at(RS,{"CAM","Client","Controllers","Skills_Provider","CurPower"})
        return v and v.Value or ""
    end
    actions.m1Down=function()
        if C.m1Held then return true end
        C.m1Held=os.clock()
        local ok=pcall(function()
            local sig=C.modules.Signal;local _,_,root=char()
            if type(sig)=="table" and root then
                -- the game's own click channel (working script: Tool_Mouse Down/Up with the root position)
                sig.ToServer("Tool_Mouse","Down",root.Position)
            elseif type(mouse1press)=="function" then mouse1press()
            else
                local okV,vim=pcall(function() return game:GetService("VirtualInputManager") end)
                if not okV or not vim then error("VirtualInputManager unavailable") end
                vim:SendMouseButtonEvent(0,0,0,true,game,0)
            end
        end)
        if not ok then C.m1Held=nil end
        return ok
    end
    actions.m1Up=function()
        if not C.m1Held then return true end
        C.m1Held=nil
        local ok=pcall(function()
            local sig=C.modules.Signal;local _,_,root=char()
            if type(sig)=="table" and root then
                sig.ToServer("Tool_Mouse","Up",root.Position)
            elseif type(mouse1release)=="function" then mouse1release()
            else
                local okV,vim=pcall(function() return game:GetService("VirtualInputManager") end)
                if okV and vim then vim:SendMouseButtonEvent(0,0,0,false,game,0) end
            end
        end)
        return ok
    end
    actions.fastAttackTick=function()
        local sig=C.modules.Signal;local cp=C.modules.CombatPresets;local ci=C.modules.Info;local items=C.modules.Items
        if type(sig)~="table" or type(cp)~="table" or type(cp.Presets)~="table" then return false,"Native modules not loaded" end
        local combatName;local tool=type(ci)=="table" and type(ci.Get_equipped_tool)=="function" and ci.Get_equipped_tool(LP) or nil
        local eq=tool and type(items)=="table" and items[tool.Name] or nil
        if eq and eq.CombatPreset and eq.CombatPreset~="Combat" then combatName=tool.Name
        else
            for powerName in string.gmatch(actions.curPower() or "","([^,]+)") do
                local pn=powerName:gsub("^%s+",""):gsub("%s+$","")
                if at(RS,{"Assets","Animations",pn.."_Combat_Anims"}) then combatName=pn;break end
            end
        end
        combatName=combatName or "Combat"
        local overrideName;local preset=cp.Presets[combatName]
        if not preset and combatName~="Combat" and type(items)=="table" and items[combatName] then
            local it=items[combatName]
            if it.Breathing~=nil or it.HasCombat or it.CombatPreset~=nil then
                overrideName=combatName;combatName=it.CombatPreset or "Regular Katana";preset=cp.Presets[combatName]
            end
        end
        if not preset then combatName="Combat";overrideName=nil;preset=cp.Presets.Combat end
        if type(preset)~="table" then return false,"No preset for "..tostring(combatName) end
        local okspd,aspd=pcall(type(cp.attackSpeedMult)=="function" and cp.attackSpeedMult or function() return 1 end,LP)
        if not okspd or type(aspd)~="number" or aspd<=0 then aspd=1 end
        if os.clock()-(C.fatk.last or 0)>(cp.combo_duration or 1)/aspd then C.fatk.combo=1 end
        local combo=C.fatk.combo
        local function pick(field,fallback)
            local t=preset[field];local v=type(t)=="table" and t[combo] or nil
            return v or fallback
        end
        local swingDelay=pick("delay_before_swing",preset.default_before_swing or cp.Default_Swing_Wait or 0)
        local hitDelay=pick("delay_before_hit",preset.default_before_hit or swingDelay)
        local serverHitDelay=math.max((hitDelay-swingDelay)/aspd,0)
        local interval=pick("customDelay",preset.default or 0.25)
        local maxc=preset.Max or 5
        if combo==maxc and type(preset.final)=="number" then interval=math.max(interval,preset.final) end
        interval=math.max(interval/aspd,0.12)
        if os.clock()<(C.fatk.next or 0) then return true end
        C.fatk.next=os.clock()+interval*0.92
        pcall(function()
            local anims=at(RS,{"Assets","Animations"})
            local folder=(overrideName and anims and anims:FindFirstChild(overrideName.."_Combat_Anims"))
                or (anims and anims:FindFirstChild((combatName or "Combat").."_Combat_Anims"))
                or (anims and anims:FindFirstChild("Combat_Combat_Anims"))
            local anim=folder and folder:FindFirstChild("Swing_"..combo)
            local _,hum=char();local animator=hum and hum:FindFirstChildOfClass("Animator")
            if anim and animator then
                local track=animator:LoadAnimation(anim)
                track:Play()
                if type(preset.AnimSpeed)=="table" then track:AdjustSpeed((preset.AnimSpeed[combo] or preset.AnimSpeed.Default or 1)*aspd) end
            end
        end)
        pcall(sig.ToServer,"Combat_Service",combatName,combo,false,serverHitDelay,false,overrideName)
        C.fatk.combo=(combo>=maxc) and 1 or (combo+1)
        C.fatk.last=os.clock()
        return true
    end
    -- v2.4.0 combat assist (client-side, honest scope):
    -- stamina drain + regen live client-side (007_Skills_Module, 014_StaminaComponent); stamina server check exists ONLY in BreathingBoost/Hundred-Legged.
    -- skill cooldowns managed client-side via PlayerProfile.skill_info[name].lastUsed (004_manage_cd); dash server (296) runs no cooldown/stamina gate.
    actions.infStaminaTick=function()
        local v=values();local st=v and v:FindFirstChild("Stamina")
        if st and type(st.Value)=="number" then
            local mx=st.MaxValue or ((st.MaxValue==nil) and 100)
            if st.Value<mx then st.Value=mx end
        end
    end
    -- v2.4.1 rapid M1: swing pacing (Presets.Normal.default=.26 etc) + combo stamps live in the global client module Combat_presets
    -- (core 003; gates read Last_Punched/Last_Combo from the SAME table - core 002 Checker line 215).
    actions.fastM1Apply=function()
        local cp=C.modules.CombatPresets
        if type(cp)~="table" then return false,"Native Combat_presets not loaded" end
        C.fastM1.saved=C.fastM1.saved or {}
        if type(cp.Presets)=="table" then
            for name,t in pairs(cp.Presets) do
                if type(t)=="table" then
                    C.fastM1.saved[name]={default=t.default,before_hit=t.default_before_hit,before_swing=t.default_before_swing}
                    if type(t.default)=="number" then t.default=0.05 end
                    if type(t.default_before_hit)=="number" then t.default_before_hit=0 end
                    if type(t.default_before_swing)=="number" then t.default_before_swing=0 end
                end
            end
        end
        return true
    end
    actions.fastM1Restore=function()
        local cp=C.modules.CombatPresets
        if type(cp)~="table" or type(C.fastM1.saved)~="table" then return end
        for name,t in pairs(C.fastM1.saved) do
            local cur=cp.Presets and cp.Presets[name]
            if type(cur)=="table" then
                if t.default~=nil then cur.default=t.default end
                if t.before_hit~=nil then cur.default_before_hit=t.before_hit end
                if t.before_swing~=nil then cur.default_before_swing=t.before_swing end
            end
        end
        C.fastM1.saved={}
    end
    actions.wipeCooldowns=function()
        local pp=C.modules.PlayerProfile
        if type(pp)~="table" or type(pp.skill_info)~="table" then return false,"Native PlayerProfile module not loaded" end
        for _,info in pairs(pp.skill_info) do
            if type(info)=="table" and type(info.lastUsed)=="number" and info.lastUsed>-9000 then info.lastUsed=-9999 end
        end
        local ch=LP.Character;local shc=ch and (ch:FindFirstChild("SHC") or ch:FindFirstChild("SHCS"))
        local mcd=C.modules.ManageCD
        if shc and type(mcd)=="table" and type(mcd.filter_cd_name)=="function" then
            for _,skill in ipairs({"Dash","Double Jump"}) do
                local ok,cdName=pcall(mcd.filter_cd_name,LP,skill)
                local cd=ok and type(cdName)=="string" and shc:FindFirstChild(cdName) or nil
                if cd then local par=cd.Parent;pcall(function() cd:Destroy() end);pcall(function()
                    if par and type(par.children)=="table" then for i,x in ipairs(par.children) do if x==cd then table.remove(par.children,i) break end end end
                end) end
            end
        end
        return true
    end
    -- v2.5.0 wave: kill aura (reuses the native punch pipeline), client-side debuff purge (Stun/CombatStun/Strict_Stun values gate ONLY via client Checker line 175-178), infinite jump, world visuals, fps cap, auto skills / auto breathing via the exact signaler protocol (010_Skill_Controller: Hold+Cancel with Platform_Handler.mousepos).
    actions.killAuraTick=function()
        local ch=LP.Character;local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
        if not hrp then return false,"No character" end
        if os.clock()-(C.auraScanT or 0)>0.75 then
            C.auraScanT=os.clock();C.auraCache={}
            for _,m in ipairs(workspace:GetDescendants()) do
                local mt=type(m)
                if mt=="userdata" or mt=="table" then pcall(function()
                    local h=m:FindFirstChildOfClass("Humanoid");local r=h and m:FindFirstChild("HumanoidRootPart")
                    local isPlayer=false
                    if Players and Players.GetPlayerFromCharacter then local ok,rp=pcall(Players.GetPlayerFromCharacter,Players,m);isPlayer=ok and rp~=nil end
                    if r and h.Health and h.Health>0 and not isPlayer then
                        C.auraCache[#C.auraCache+1]={n=m,r=r,h=h}
                    end
                end) end
            end
        end
        local best,bd
        for _,e in ipairs(C.auraCache or {}) do
            local r,h=e.r,e.h
            if r.Parent and h.Health>0 then
                local d=(r.Position-hrp.Position).Magnitude
                if d<=S.killAuraRange+(type(S.hitRange)=="number" and S.hitRange or 7) and (bd==nil or d<bd) then best,bd=e,d end
            end
        end
        if not best then return false,"No mob in aura range" end
        local punch=(S.inputMode~="Native input only") and findPunch() or nil
        if punch then local ok,err=pcall(punch);if not ok then C.punch=nil;return false,"aura punch err: "..short(err) end
        else press("Combat",0.12) end
        return true,"Aura hit "..tostring(best.n.Name).." @"..math.floor(bd)
    end
    actions.purgeDebuffs=function()
        local purged=0
        local v=values();local ch=LP.Character
        for _,holder in ipairs({v,ch}) do
            if holder then
                for _,n in ipairs({"Stun","CombatStun","Strict_Stun","Ragdoll"}) do
                    local o=holder:FindFirstChild(n)
                    if o then purged=purged+1
                        local p=o.Parent
                        pcall(function() o:Destroy() end)
                        pcall(function()
                            if p and type(p.children)=="table" then for i,x in ipairs(p.children) do if x==o then table.remove(p.children,i) break end end end
                            o.Parent=nil
                        end)
                    end
                end
            end
        end
        return purged
    end
    actions.setLight=function(on)
        local L;pcall(function() L=game:GetService("Lighting") end)
        if type(L)~="table" and type(L)~="userdata" then return end
        if on then
            if not C.lightSaved then C.lightSaved={}for _,f in ipairs({"Brightness","Ambient","OutdoorAmbient","ClockTime","GlobalShadows","FogEnd","FogStart"})do C.lightSaved[f]=pcall(function()return L[f]end)end end
            if S.fullbright then pcall(function()L.Brightness=2;L.Ambient=Color3.fromRGB(178,178,178);L.OutdoorAmbient=Color3.fromRGB(178,178,178);L.ClockTime=12 end) end
            if S.noFog then pcall(function()L.FogEnd=100000;L.GlobalShadows=false end) end
        elseif C.lightSaved then for f,val in pairs(C.lightSaved) do pcall(function()L[f]=val end) end;C.lightSaved=nil end
    end
    actions.autoSkillTick=function()
        if not C.modules.Signal then return false,"Native SignalEvent module not loaded" end
        local now=os.clock()
        if S.autoBreath and now-(C.breathAt or 0)>2.5 then
            C.breathAt=now
            local st=values() and values():FindFirstChild("Stamina")
            if st and st.Value and st.Value>(tonumber(st.MaxValue) or 100)*0.25 then
                pcall(C.modules.Signal.ToServer,"server_skill_controller_signaler","Breathing Boost","Hold",Vector3.new())
                task.delay(0.6,function() pcall(C.modules.Signal.ToServer,"server_skill_controller_signaler","Breathing Boost","Cancel",Vector3.new()) end)
            end
        end
        if S.autoSkills and now-(C.skillCycleAt or 0)>1.4 then
            C.skillCycleAt=now
            for raw in string.gmatch(S.autoSkillText,"([^,]+)") do
                local name=raw:gsub("^%s+",""):gsub("%s+$","")
                if name~="" and name~="Breathing Boost" then
                    local ok,cerr=pcall(C.modules.Signal.ToServer,"server_skill_controller_signaler",name,"Hold",Vector3.new())
                    if not ok then return false,"skill signaler error: "..short(cerr) end
                    task.delay(1.0,function() pcall(C.modules.Signal.ToServer,"server_skill_controller_signaler",name,"Cancel",Vector3.new()) end)
                end
            end
        end
        return true
    end
    -- v2.3.2 skill tree spend (protocol captured live by probe 1.1 on 2026-09-26).
    -- Manual single clicks only: spending real currency never runs in a loop here.
    actions.treeRank=function(name)
        local d=data();if not d then return nil,nil end
        local points=d:FindFirstChild("SkillPoints")
        local rank=d:FindFirstChild("SkillTreeUnlockedList")
        if rank then rank=rank:FindFirstChild(name) end
        return (points and points.Value), (rank and type(rank.Value)=="number" and rank.Value or 0)
    end
    actions.unlockTreeNode=function()
        local name=S.treeNode
        if not name or name=="" then return false,"Type the exact node name first (e.g. Max Health)" end
        local sf=C.modules.SignalF
        if not (sf and type(sf.ToServer)=="function") then return false,"Connect native controls first" end
        local beforePoints,beforeRank=actions.treeRank(name)
        local ok,res=pcall(sf.ToServer,"UnlockSkillTreeNode",name)
        log("tree","UnlockSkillTreeNode "..name.." | sent="..tostring(ok).." | ret="..short(res))
        if not ok then return false,"Rejected: "..short(res) end
        if res==false then return false,"Server refused (no points / previous node missing / maxed)" end
        task.delay(0.4,function()
            local points,rank=actions.treeRank(name)
            if points and beforePoints and points<beforePoints then
                note("Skill tree: accepted. Points "..beforePoints.." -> "..points..(rank and rank~=beforeRank and (", rank "..tostring(beforeRank).." -> "..tostring(rank)) or ""))
            else
                note("Unlock request sent; values unchanged yet (server-side check runs first)")
            end
        end)
        return true,"UnlockSkillTreeNode sent: "..name
    end
    -- v2.3.0 manual action helpers (explicit click only; no auto-spend loops)
    actions.buyShop=function(withOre)
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
    actions.startMuzanQuest=function()
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
    actions.rankedRequest=function(action)
        if S.rankedKey=="" then return false,"Type the ranked board/mode key first" end
        local signal=C.modules.Signal
        if not (signal and type(signal.ToServer)=="function") then return false,"Connect native controls first" end
        signal.ToServer("RankedRequest",{action=action,key=S.rankedKey})
        log("ranked",action.." | "..S.rankedKey)
        return true,action.." request sent"
    end
    actions.loadoutAction=function(n,text)
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
        if not live(o) then return end
        local owner=o.Parent
        if o:IsA("Humanoid") and owner and owner:IsA("Model") then
            -- Cache ownership before removal: Parent may already be nil when destruction is observed.
            C.humanoids[owner]=o;C.humanoidOwners[o]=owner;C.objects[owner]=kindOfNPC(owner)
            local m=owner;local k=C.objects[m]
            if not C.indexing and not C.seen[m] and S.notifyBoss and k=="Boss" then note("Boss streamed in: "..m.Name) end
            C.seen[m]=true
            actions.watchParryModel(m)
        end
        if o:IsA("ProximityPrompt") then C.prompts[o]=true end
        local k=classify(o)
        if k then
            C.objects[o]=k
            if not C.indexing and not C.seen[o] then
                if S.notifyMuzan and k=="Muzan" then note("Muzan object streamed in") end
                if S.notifyBoss and k=="Boss" then note("Boss streamed in: "..o.Name) end
            end
            C.seen[o]=true
        end
    end
    local function remove(o)
        if not o then return end
        local removedModel
        if o:IsA("Humanoid") then
            local owner=C.humanoidOwners[o] or o.Parent
            C.humanoidOwners[o]=nil
            -- A late callback for an old Humanoid must not erase a newly indexed replacement.
            if owner and C.humanoids[owner]==o then
                C.humanoids[owner]=nil;C.objects[owner]=nil;C.seen[owner]=nil;C.cooldowns[owner]=nil
                removedModel=owner
            end
        elseif o:IsA("Model") then
            local humanoid=C.humanoids[o]
            if humanoid then C.humanoidOwners[humanoid]=nil end
            C.humanoids[o]=nil;removedModel=o
        end
        C.objects[o]=nil;C.prompts[o]=nil;C.seen[o]=nil;C.cooldowns[o]=nil
        if removedModel then
            if S.target==removedModel then S.target=nil;C.damageWatch=nil;release("Combat") end
            if C.goalTarget==removedModel and endTravel then endTravel() end
        end
        if C.activePrompt==o then endPrompt() end
    end
    local function promptKind(p)
        local obj=p.Parent
        while obj and obj~=workspace do
            if obj:GetAttribute("ChestState")=="Locked" then return nil,"Sealed chest: locked" end
            local k=classify(obj)
            if k=="Chest" or k=="Loot" then return k end
            obj=obj.Parent
        end
        return nil
    end
    local function withinPrompt(p)
        if not live(p) or not p.Enabled then return false end
        local _,_,r=char();local pp=part(p.Parent)
        if not r or not pp then return false end
        local d=(pp.Position-r.Position).Magnitude
        if d>p.MaxActivationDistance then return false end
        if p.RequiresLineOfSight then
            local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances={LP.Character}
            local hit=workspace:Raycast(r.Position,pp.Position-r.Position,params)
            if hit and hit.Instance~=pp and not hit.Instance:IsDescendantOf(pp.Parent) then return false end
        end
        return true,d
    end
    local function startPrompt(p)
        local ok,why=usable();if not ok then return false,why end
        if C.activePrompt then return false,"A prompt is already active" end
        if not withinPrompt(p) then return false,"Prompt disabled, occluded or too far" end
        local now=os.clock();if (C.cooldowns[p] or 0)>now then return false,"Prompt pacing" end
        C.cooldowns[p]=now+math.max(2,p.HoldDuration+1)
        if S.instant then
            if C.holds[p]==nil then C.holds[p]=p.HoldDuration end
            p.HoldDuration=0
        end
        C.activePrompt=p;local epoch=S.epoch
        p:InputHoldBegin()
        task.delay(math.max(0.08,p.HoldDuration+0.05),function()
            if C.activePrompt==p and S.epoch==epoch then endPrompt() end
        end)
        log("prompt",p:GetFullName());return true,"Native prompt held (not proof of reward)"
    end
    local function nearbyLoot()
        local best,distance=nil,math.huge
        for p in pairs(C.prompts) do
            local k=promptKind(p)
            if (k=="Loot" and S.loot or k=="Chest" and S.chest) and (C.cooldowns[p] or 0)<=os.clock() then
                local ok,d=withinPrompt(p)
                if ok and d<distance then best=p;distance=d end
            end
        end
        if best then release("Combat");return startPrompt(best) end
        return false,"No eligible nearby loot/chest prompt"
    end
    local function huntRows()
        local rows={};local root=RS:FindFirstChild("BossHunts");if not root then return rows end
        local d=data();local race=d and d:FindFirstChild("Race");race=race and race.Value
        for _,o in ipairs(root:GetChildren()) do
            local q=o:GetAttribute("Quest");local side=o:GetAttribute("Side");local expires=o:GetAttribute("ExpiresAt")
            local allowed=(side=="Crow" and (race=="Slayer" or race=="Hybrid")) or (side=="Muzan" and (race=="Demon" or race=="Hybrid"))
            if type(q)=="string" and allowed and (type(expires)~="number" or expires>workspace:GetServerTimeNow()) then rows[o.Name]={obj=o,quest=q,boss=o:GetAttribute("Boss"),expires=expires} end
        end
        return rows
    end
    local function claimHunt()
        local ok,why=usable();if not ok then return false,why end
        local rows=huntRows();local row=rows[S.huntId]
        if not row then return false,"Select a current hunt for your race" end
        if C.huntSent[S.huntId] then return false,"Already requested this hunt; waiting for server state" end
        local q=C.modules.Quests;local signal=C.modules.Signal
        if not q or type(q.CanAddQuest)~="function" or not signal or type(signal.ToServer)~="function" then return false,"Connect native controls first" end
        local allowed,reason=q.CanAddQuest(LP,row.quest)
        if allowed~=true then return false,"Quest denied: "..short(reason) end
        C.huntSent[S.huntId]=true
        signal.ToServer("BossHuntsRequest",{action="Claim",id=S.huntId})
        log("request","BossHuntsRequest Claim "..S.huntId)
        return true,"Hunt request sent; not confirmation of acceptance"
    end
    local function ownership(o)
        local p=part(o);local fn=isnetworkowner or Env.isnetworkowner
        if not p or type(fn)~="function" then return "unknown (API unavailable)" end
        local ok,v=pcall(fn,p);return ok and (v and "local client" or "not local client") or "unavailable"
    end
    local function teleportCF(cf)
        local ok,why=usable();if not ok then note(why) return end
        flag("farm",false);flag("autoLevel",false);endTravel();flag("attack",false);flag("skills",false);flag("fly",false)
        releaseAll();stopWalk();endFly();endPrompt()
        local c,_,r=char();if not c or not r then return end
        r.CFrame=cf;r.AssemblyLinearVelocity=Vector3.zero
        log("teleport","Local position changed; server may correct")
        local epoch=S.epoch
        task.delay(1,function()
            if not S.alive or epoch~=S.epoch then return end
            local _,_,r2=char();if r2 and (r2.Position-cf.Position).Magnitude>25 then note("Movement corrected or destination changed; no retry") end
        end)
    end
    local function teleportObject(o)
        if not live(o) then note("Destination is not currently streamed in") return end
        local p=part(o);if not p then note("Destination has no loaded BasePart") return end
        teleportCF(CFrame.new(p.Position+Vector3.new(0,3,5)))
    end
    local function recommended()
        local m=C.modules.Recommended
        if not m or type(m.Get)~="function" then return nil,"Connect native controls first" end
        local r=m.Get();return r,r and r.Name or "No recommendation (Book of Guidance / eligibility required)"
    end
    -- World-anchored ESP: Highlight + BillboardGui live on the streamed objects.
    -- Scan runs on a slow clock; only tracer line positions update at render rate.
    local gui=Instance.new("ScreenGui");gui.Name="CAM_Main_Overlay";gui.ResetOnSpawn=false;gui.IgnoreGuiInset=true;gui.DisplayOrder=40;gui.Parent=LP:WaitForChild("PlayerGui")
    local colors={Player=Color3.fromRGB(90,174,255),Mob=Color3.fromRGB(255,120,90),Boss=Color3.fromRGB(255,80,110),NPC=Color3.fromRGB(200,180,255),Chest=Color3.fromRGB(255,218,95),Loot=Color3.fromRGB(95,240,160),Muzan=Color3.fromRGB(230,70,220),["Spider Lily"]=Color3.fromRGB(255,120,200),Lever=Color3.fromRGB(90,220,220),["Wild Horse"]=Color3.fromRGB(220,190,140)}
    local espFlags={Player="players",Mob="mobs",Boss="bosses",NPC="npcs",Chest="chests",Loot="drops",Muzan="muzan",["Spider Lily"]="lily",Lever="levers",["Wild Horse"]="horses"}
    local function make(class,props,parent)
        local o=Instance.new(class);for k,v in pairs(props or {}) do o[k]=v end;o.Parent=parent;return o
    end
    local function line(frame,a,b)
        local dx,dy=b.X-a.X,b.Y-a.Y
        frame.Position=UDim2.fromOffset((a.X+b.X)/2,(a.Y+b.Y)/2)
        frame.Size=UDim2.fromOffset(math.sqrt(dx*dx+dy*dy),1)
        frame.Rotation=math.deg(math.atan2(dy,dx));frame.Visible=true
    end
    local function clearVisual(v)
        if v.hl then v.hl:Destroy() end
        if v.bb then v.bb:Destroy() end
        if v.tracer then v.tracer:Destroy() end
    end
    clearESP=function() for o,v in pairs(C.esp) do clearVisual(v);C.esp[o]=nil end end
    local function visual(o,k)
        local color=colors[k] or Color3.fromRGB(130,240,220)
        local v={color=color}
        v.hl=make("Highlight",{Name="CAM_ESP",FillColor=color,OutlineColor=color,FillTransparency=0.8,OutlineTransparency=0,DepthMode=Enum.HighlightDepthMode.AlwaysOnTop},o)
        local anchor=o:IsA("BasePart") and o or (o:FindFirstChild("HumanoidRootPart") or part(o))
        if anchor then
            v.bb=make("BillboardGui",{Name="CAM_ESP",Size=UDim2.fromOffset(180,44),StudsOffsetWorldSpace=Vector3.new(0,3,0),AlwaysOnTop=true},anchor)
            v.label=make("TextLabel",{Size=UDim2.fromScale(1,0.62),BackgroundTransparency=1,TextColor3=color,TextStrokeTransparency=0.3,TextSize=12,Font=Enum.Font.GothamBold,Text=""},v.bb)
            v.bar=make("Frame",{AnchorPoint=Vector2.new(0.5,0),Position=UDim2.fromScale(0.5,0.74),Size=UDim2.new(0.8,0,0.14,0),BackgroundColor3=Color3.fromRGB(25,26,32),BorderSizePixel=0,Visible=false},v.bb)
            v.hp=make("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.fromRGB(85,225,125),BorderSizePixel=0},v.bar)
        end
        C.esp[o]=v;return v
    end
    local function refreshText(v,o,d)
        if not v.bb then return end
        local h=o:IsA("Model") and o:FindFirstChildOfClass("Humanoid")
        v.label.Text=S.names and (o.Name..(h and ("  "..math.floor(h.Health).."/"..math.floor(h.MaxHealth)) or "").."\n"..math.floor(d).." st") or ""
        v.bar.Visible=S.hpbar and h~=nil
        if h then v.hp.Size=UDim2.fromScale(math.max(0,math.min(1,h.Health/math.max(h.MaxHealth,1))),1) end
    end
    local function renderESP()
        if not S.esp then if next(C.esp) then clearESP() end return end
        local _,_,r=char();if not r then return end
        local candidates={}
        for o,k in pairs(C.objects) do
            if live(o) and o~=LP.Character then
                if (k=="Mob" or k=="Boss" or k=="NPC" or k=="Player") and o:IsA("Model") and o:FindFirstChildOfClass("Humanoid") then k=kindOfNPC(o) end
                if espFlags[k] and S[espFlags[k]] then
                    local p=part(o)
                    if p then local d=(p.Position-r.Position).Magnitude;if d<=S.espRange then candidates[#candidates+1]={o=o,k=k,d=d,p=p} end end
                end
            end
        end
        table.sort(candidates,function(a,b) return a.d<b.d end)
        local kept={}
        for i=1,math.min(#candidates,S.espLimit) do
            local item=candidates[i];local o=item.o
            local v=C.esp[o] or visual(o,item.k);kept[o]=true
            refreshText(v,o,item.d)
        end
        for o,v in pairs(C.esp) do if not kept[o] then clearVisual(v);C.esp[o]=nil end end
    end
    local function tracerStep()
        if not (S.esp and S.tracer) then
            for _,v in pairs(C.esp) do if v.tracer then v.tracer.Visible=false end end
            return
        end
        local camera=workspace.CurrentCamera;local vp=camera and camera.ViewportSize
        if not vp then return end
        for o,v in pairs(C.esp) do
            local p=live(o) and part(o)
            local s=p and camera:WorldToViewportPoint(p.Position)
            if p and s.Z>0 and s.X>=0 and s.Y>=0 and s.X<=vp.X and s.Y<=vp.Y then
                if not v.tracer then v.tracer=make("Frame",{AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3=v.color,BorderSizePixel=0},gui) end
                line(v.tracer,Vector2.new(vp.X/2,vp.Y),Vector2.new(s.X,s.Y))
            elseif v.tracer then v.tracer.Visible=false end
        end
    end
    local function moveStep()
        local c,h,r=char()
        if not h or not r or h.Health<=0 then
            if C.flyHum then endFly() end
            return
        end
        local autoClip=S.farmNoclip and C.goal~=nil and (S.autoLevel or S.farm) and S.travelMode~="Walk" and not S.fly
        if S.noclip or autoClip then
            for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then if C.collision[p]==nil then C.collision[p]=p.CanCollide end;p.CanCollide=false end end
        elseif next(C.collision) then
            for p,v in pairs(C.collision) do if p.Parent then p.CanCollide=v end;C.collision[p]=nil end
        end
        if S.speed then
            if C.speedHum~=h then if C.speedHum then pcall(function() C.speedHum.WalkSpeed=C.oldSpeed end) end;C.speedHum=h;C.oldSpeed=h.WalkSpeed end
            h.WalkSpeed=S.walkSpeed
        elseif C.speedHum then C.speedHum.WalkSpeed=C.oldSpeed;C.speedHum=nil end
        if S.jump then
            if C.jumpHum~=h then C.jumpHum=h;C.oldJumpPower=h.JumpPower;C.oldJumpHeight=h.JumpHeight end
            if h.UseJumpPower then h.JumpPower=math.sqrt(2*workspace.Gravity*S.jumpHeight) else h.JumpHeight=S.jumpHeight end
        elseif C.jumpHum then C.jumpHum.JumpPower=C.oldJumpPower;C.jumpHum.JumpHeight=C.oldJumpHeight;C.jumpHum=nil end
        if S.shift then
            local m=C.modules.Run
            if m and type(m.SetShiftLock)=="function" then if C.oldShift==nil then C.oldShift=m.Shift_lock end;m.SetShiftLock(0) end
        elseif C.oldShift~=nil then restoreShift() end
        if not S.fly then if C.flyHum then endFly() end return end
        if C.flyRoot~=r then
            endFly();C.flyHum=h;C.flyRoot=r;C.flyStand=h.PlatformStand;C.flyRotate=h.AutoRotate
            C.flyAttach=make("Attachment",{Name="CAM_Fly_Attachment"},r)
            C.flyVelocity=make("LinearVelocity",{Attachment0=C.flyAttach,RelativeTo=Enum.ActuatorRelativeTo.World,MaxForce=100000,VectorVelocity=Vector3.zero},r)
            C.flyAlign=make("AlignOrientation",{Attachment0=C.flyAttach,Mode=Enum.OrientationAlignmentMode.OneAttachment,MaxTorque=100000,Responsiveness=18},r)
            h.PlatformStand=true;h.AutoRotate=false
        end
        local camera=workspace.CurrentCamera;if not camera then return end
        local vector=Vector3.zero
        if not focused() and not menuOpen() then
            local cf=camera.CFrame
            if Input.KeyboardEnabled then
                if Input:IsKeyDown(Enum.KeyCode.W) then vector=vector+cf.LookVector end
                if Input:IsKeyDown(Enum.KeyCode.S) then vector=vector-cf.LookVector end
                if Input:IsKeyDown(Enum.KeyCode.D) then vector=vector+cf.RightVector end
                if Input:IsKeyDown(Enum.KeyCode.A) then vector=vector-cf.RightVector end
            else vector=h.MoveDirection end
            if Input:IsKeyDown(Enum.KeyCode.Space) or C.flyUp then vector=vector+Vector3.new(0,1,0) end
            if Input:IsKeyDown(Enum.KeyCode.LeftControl) or C.flyDown then vector=vector-Vector3.new(0,1,0) end
        end
        C.flyVelocity.VectorVelocity=vector.Magnitude>0 and vector.Unit*S.flySpeed or Vector3.zero
        C.flyAlign.CFrame=camera.CFrame.Rotation
    end
    local function scheduler()
        local ok,why=usable()
        if not ok then releaseAll();endPrompt();endTravel();S.status=why;return end
        local _,h=char()
        if h.Health/math.max(h.MaxHealth,1)*100<=S.healthStop then
            if S.autoLevel or S.farm or S.attack or S.skills or S.loot or S.chest or S.autoHunt or S.run or S.fly then stopAll("Low HP: stopped, no automatic restart") end
            return
        end
        if S.fly then releaseAll();endTravel();S.status="Fly has movement priority";return end
        if S.run then if not C.owned.Run then press("Run") end else release("Run") end
        if S.autoPotion then usePotion(h) end
        if C.baitWatch then
            local d=data();local v=d and at(d,{"Misc","EquippedBaitId"})
            local cur=v and v:IsA("ValueBase") and v.Value
            if cur~=nil and cur==C.baitWatch.id then
                C.baitAcks=(C.baitAcks or 0)+1;log("bait","Misc/EquippedBaitId = "..tostring(cur).." acknowledged");C.baitWatch=nil
            elseif os.clock()>C.baitWatch.deadline then
                log("bait","No EquippedBaitId acknowledgement; server may have declined");C.baitWatch=nil
            end
        end
        if C.activePrompt then
            if not withinPrompt(C.activePrompt) then endPrompt() else release("Combat");endTravel();S.status="Holding native prompt";return end
        end
        if S.priority=="Loot first" and (S.loot or S.chest) then local done,msg=nearbyLoot();if done then S.status=msg;endTravel();return end end
        if S.autoLevel then
            local fight,msg=questStep()
            if not fight then release("Combat");S.status=msg;return end
        end
        if S.autoLevel or S.farm or S.attack or S.skills then
            local _,msg=farmStep();S.status=msg
            if not S.alive then return end
            if S.skills then local sent,skillMsg=skillOnce();if sent then S.status=msg.." | "..skillMsg end end
        else release("Combat");endTravel() end
        if (S.loot or S.chest) and not S.target then local _,msg=nearbyLoot();S.status=msg end
        if S.autoHunt and not C.activePrompt and not (S.autoLevel or S.farm or S.attack or S.skills) and (C.huntCheck or 0)<=os.clock() then
            C.huntCheck=os.clock()+5;local _,msg=claimHunt();S.status=msg
        end
    end
    local function snapshot()
        local state={};for k,v in pairs(S) do if type(v)=="number" or type(v)=="string" or type(v)=="boolean" then state[k]=v end end
        local modules={};for k in pairs(modulePaths) do modules[k]=C.modules[k] and "ready" or C.loading[k] or "not connected" end
        local m=S.target
        local loaded={};local _,_,root=char()
        for model in pairs(C.humanoids) do
            if #loaded>=60 then break end
            if live(model) and not isPlayer(model) then
                local p=part(model);local h=model:FindFirstChildOfClass("Humanoid");local def=npcDefinition(model)
                loaded[#loaded+1]={name=model.Name,kind=kindOfNPC(model),code=def and def.code or "unmatched",attributeCode=tostring(model:GetAttribute("NpcCode")),
                    hp=h and h.Health or 0,distance=root and p and (root.Position-p.Position).Magnitude or -1}
            end
        end
        C.snapshotHostiles=loaded
        -- Freeze this snapshot's log; later messages must not rewrite a recorder's runtimeBefore.
        local frozenLog={}
        for _,entry in ipairs(C.logs) do frozenLog[#frozenLog+1]={time=entry.time,kind=entry.kind,text=entry.text} end
        return {format="CAM Main Hub 3.2.4",timeUTC=os.date("!%Y-%m-%dT%H:%M:%SZ"),placeId=game.PlaceId,placeVersion=game.PlaceVersion,
            state=state,modules=modules,log=frozenLog,lastStop=C.lastStop,
            farm={backend=C.inputBackend or "not used",requests=C.attackRequests or 0,comboAcks=C.comboAcks or 0,damageObservations=C.damageEvents or 0,potionRequests=C.potionRequests or 0,potionAcks=C.potionAcks or 0,potionFailures=C.potionFailures or 0,baitRequests=C.baitRequests or 0,baitAcks=C.baitAcks or 0,
                quest=C.questRoute and C.questRoute.key or "none",questRequestAttempts=C.questAttempts or 0,level=level(),
                catalogNpcs=#CAM_CATALOG.npcs,catalogQuests=#CAM_CATALOG.quests,loadedHumanoids=C.snapshotHostiles,combatBusy=C.combatBusy==true},target=m and m:GetFullName() or "none",ownership=ownership(m),
            note="Client actions / requests are not proof of server acceptance. No private credentials or webhook URLs are collected."}
    end
    local function report()
        local d=snapshot();local ok,text=pcall(function() return Http:JSONEncode(d) end)
        if ok then return text end
        return PortableJSON(d,{error=tostring(text)})
    end
    local function manualReport(text)
        if C.reportFrame then C.reportFrame:Destroy() end
        local f=make("Frame",{Size=UDim2.fromScale(0.75,0.7),Position=UDim2.fromScale(0.125,0.15),BackgroundColor3=Color3.fromRGB(20,23,29),ZIndex=300},gui);C.reportFrame=f
        local b=make("TextBox",{Size=UDim2.new(1,-20,1,-60),Position=UDim2.fromOffset(10,10),MultiLine=true,ClearTextOnFocus=false,Text=text,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,TextColor3=Color3.new(1,1,1),BackgroundColor3=Color3.fromRGB(28,32,38),ZIndex=301},f)
        local select=make("TextButton",{Size=UDim2.fromOffset(180,30),Position=UDim2.new(0,10,1,-40),Text="Select all / Ctrl+C",ZIndex=301},f)
        select.Activated:Connect(function() b:CaptureFocus();b.CursorPosition=#b.Text+1;b.SelectionStart=1 end)
        local close=make("TextButton",{Size=UDim2.fromOffset(80,30),Position=UDim2.new(1,-90,1,-40),Text="Close",ZIndex=301},f)
        close.Activated:Connect(function() f:Destroy();C.reportFrame=nil end)
    end
    local function unload()
        if not S.alive then return end
        S.alive=false
        pcall(function() stopAll("Unloaded") end)
        for _,con in ipairs(C.connections) do pcall(function() con:Disconnect() end) end
        pcall(function() actions.fastM1Restore() end)
        pcall(function() actions.setLight(false) end)
        pcall(function() gui:Destroy() end)
        if Env.CAMMainHub and Env.CAMMainHub.State==S then Env.CAMMainHub=nil end
    end
    local oldUnload=Lumen.Unload
    function Lumen:Unload()
        local ok,err=pcall(unload)
        if not ok then pcall(function() warn("[CAM Main] unload cleanup error: "..tostring(err)) end) end
        return oldUnload(self)
    end
    Env.CAMMainHub={State=S,Stop=function() Lumen:Unload() end,StopAll=function() stopAll("Diagnostics STOP") end,Snapshot=snapshot,Version="3.2.4"}
    Lumen.Folder="cam_main_hub";Lumen.ConfigFolder=Lumen.Folder.."/configs";Lumen.ThemeFolder=Lumen.Folder.."/themes"
    local window=Lumen:Window({Name="CAM MAIN | Quest & Farm",Version="3.2.4 / + combat_service default, speed 300",Footer="RightCtrl menu | unload: settings | honest limits",Size=UDim2.fromOffset(900,660),Keybind=Enum.KeyCode.RightControl})
    -- hide the window drop shadow entirely (user request: no shadow behind the menu, ever)
    local winShadow=window.Items and window.Items.Shadow
    local function killShadow()
        if not winShadow then return end
        pcall(function()
            winShadow.Visible=false
            winShadow.BackgroundTransparency=1
            winShadow.Size=UDim2.new(0,0,0,0)
            for _,d in ipairs(winShadow:GetDescendants()) do pcall(function() d.BackgroundTransparency=1;d.ImageTransparency=1 end) end
        end)
    end
    killShadow()
    if winShadow then connect(winShadow:GetPropertyChangedSignal("Visible"),function() if winShadow.Visible then killShadow() end end,"shadow suppression") end
    pcall(function() Lumen:Init() end)
    local function page(name,group) return window:Page({Name=name,Columns=2,Group=group}) end
    local function section(p,name,side) return p:Section({Name=name,Side=side or 1}) end
    local function button(sec,name,fn,confirm)
        return sec:Button({Name=name,Confirm=confirm or false,Callback=function()
            local ok,err=pcall(fn);if not ok then log("button error",err);note("Action failed: "..short(err));stopAll("Action failed") end
        end})
    end
    local function toggle(sec,name,key,fn,visualOnly)
        local ref=sec:Toggle({Name=name,Flag="cam_"..key,Default=false,Callback=function(v)
            if v and not visualOnly and game.PlaceId~=136406881576517 then flag(key,false);note("Unsupported place") return end
            S[key]=v==true;if fn then fn(S[key]) end
        end});C.toggles[key]=ref;return ref
    end
    local function slider(sec,name,key,min,max)
        sec:Slider({Name=name,Flag="cam_"..key,Min=min,Max=max,Default=S[key],Decimals=(max<=10 and 2 or 0),Callback=function(v) S[key]=v end})
    end
    local function tell(ok,msg) note(msg or (ok and "Requested" or "Not available")) end
    local farmPage=page("farm","main")
    local hubSec=section(farmPage,"hub",2)
    button(hubSec,"Connect native controls",function() for k,v in pairs(C.loading) do if v~="loading" then C.loading[k]=nil end end;loadNative() end)
    hubSec:Label("Unload hub: settings tab (button at the bottom) -> menu -> unload ui.")
    hubSec:Label("Every feature toggles off the same way it was toggled on.")
    local farmSec=section(farmPage,"auto farm (direct)")
    toggle(farmSec,"Auto Farm (mob names below / nearest)","autoFarm",function(v) if v then loadNative() else C.farmTarget=nil;actions.m1Up() end end)
    toggle(farmSec,"Auto Boss (source-backed boss names)","autoBoss",function(v) if v then loadNative() else C.farmTarget=nil;actions.m1Up() end end)
    farmSec:Textbox({Name="Mob names, CSV (empty = any)",Placeholder="e.g. Bandit, Demon",Default=S.farmMobText,Flag="cam_farmmob",Callback=function(v) S.farmMobText=v end})
    farmSec:Dropdown({Name="Position",Items={"Behind","Above","Front","Below"},Default=S.farmStyle,Flag="cam_farmstyle",Callback=function(v) S.farmStyle=v end})
    slider(farmSec,"Distance","farmDist",2,14)
    slider(farmSec,"Farm height","farmHeight",0,20)
    slider(farmSec,"Farm speed (studs/s)","farmSpeed",20,300)
    slider(farmSec,"Search range","searchRange",50,2000)
    toggle(farmSec,"Farm noclip","farmNoclip")
    farmSec:Dropdown({Name="Attack mode",Items={"Fast Attack (Combat_Service)","Hold M1 (native)"},Default=S.m1Mode,Flag="cam_m1mode",Callback=function(v) S.m1Mode=v end})
    farmSec:Dropdown({Name="Weapon",Items={"Auto combat tool","Keep equipped","Slot 1","Slot 2","Slot 3","Slot 4","Slot 5"},Default=S.weapon,Flag="cam_weapon",Callback=function(v) S.weapon=v end})
    farmSec:Label("Regions scan -> stepped approach; attacks run inside the game's own input path (hold M1) or raw Combat_Service.")
    farmSec:Label("Defending targets (NpcCounter / Blocking) are skipped this pass.")
    local ps=section(farmPage,"auto potion (native toolbar)",2)
    toggle(ps,"Auto Potion - consumes toolbar potion at low HP","autoPotion",function(v) if v then loadNative() else C.potion=nil;C.potionLock=nil end end)
    ps:Dropdown({Name="Potion choice",Items={"Auto (strongest heal)","Health Elixir","Health Potion","Health Regen Elixir","Health Regen Potion"},Default=S.potionChoice,Flag="cam_potion_choice",Callback=function(v) S.potionChoice=v end})
    slider(ps,"Use below HP percent","potionHp",10,80)
    slider(ps,"Potion recheck seconds","potionDelay",3,15)
    ps:Label("Potion must sit on toolbar slot 1-5; drinking consumes the item.")
    ps:Label("HP threshold must stay above the STOP threshold or it never fires.")
    ps:Dropdown({Name="Action priority",Items={"Combat first","Loot first"},Default=S.priority,Flag="cam_priority",Callback=function(v) S.priority=v end})
    local cfSec=section(farmPage,"classic engage (native input path)",2)
    cfSec:Dropdown({Name="Target mode",Items={"Selected mob","Selected boss","Nearest hostile"},Default=S.targetMode,Flag="cam_tmode",Callback=function(v) S.targetMode=v;S.target=nil;endTravel();release("Combat") end})
    local mobNames,bossList,mobMap,bossMap={},{},{},{}
    for _,row in ipairs(CAM_CATALOG.npcs) do
        local list,map=row.boss and bossList or mobNames,row.boss and bossMap or mobMap
        list[#list+1]=row.name;map[row.name]=row.code
    end
    table.sort(mobNames);table.sort(bossList)
    cfSec:Dropdown({Name="Selected mob",Items=mobNames,Default="Bandit",Flag="cam_mobsel",Callback=function(v) S.mobCode=mobMap[v];S.target=nil;endTravel() end})
    cfSec:Dropdown({Name="Selected boss",Items=bossList,Default="Zuko",Flag="cam_bosssel",Callback=function(v) S.bossCode=bossMap[v];S.target=nil;endTravel() end})
    refreshTargets=function()
        local n=0;for m in pairs(C.humanoids) do if validTarget(m) then n=n+1 end end;return n
    end
    button(cfSec,"Count loaded hostile targets",function() note("Loaded source-matched hostiles: "..refreshTargets()) end)
    toggle(cfSec,"Auto Farm - selected / nearest (classic)","farm",function(v)
        endTravel();release("Combat");C.damageWatch=nil
        if v then flag("autoLevel",false);S.questStage="OFF";flag("fly",false);endFly();loadNative() end
    end)
    toggle(cfSec,"Auto M1 (no movement)","attack",function(v) if v then loadNative() elseif not S.farm and not S.autoLevel then release("Combat") end end)
    button(cfSec,"M1 once",function() tell(attackOnce()) end)
    local cfPos=section(farmPage,"classic position / movement")
    cfPos:Dropdown({Name="Farm position",Items={"Above","Below","Behind","In front","Left","Right","Orbit","Ground"},Default=S.positionMode,Flag="cam_posmode",Callback=function(v) S.positionMode=v;endTravel() end})
    cfPos:Dropdown({Name="Travel method",Items={"Tween","Instant","Walk"},Default=S.travelMode,Flag="cam_travel",Callback=function(v) S.travelMode=v;endTravel() end})
    cfPos:Dropdown({Name="Look at target",Items={"Horizontal","Full 3D","Off"},Default=S.lookMode,Flag="cam_lookmode",Callback=function(v) S.lookMode=v end})
    slider(cfPos,"Classic distance","farmDistance",1,15)
    slider(cfPos,"Tween speed (studs/sec)","travelSpeed",10,400)
    slider(cfPos,"Orbit speed","orbitSpeed",0.1,4)
    slider(cfPos,"M1 range","hitRange",3,10)
    slider(cfPos,"M1 interval (seconds)","attackDelay",0.25,3)
    slider(cfPos,"STOP at HP percent","healthStop",5,80)
    slider(cfPos,"STOP after no target damage (seconds)","noDamageTimeout",10,60)
    cfPos:Dropdown({Name="M1 input backend",Items={"Auto (live punch / native input)","Native input only"},Default=S.inputMode,Flag="cam_inputmode",Callback=function(v) S.inputMode=v;release("Combat");C.damageWatch=nil end})
    local autoPage=page("auto level","gameplay")
    local al=section(autoPage,"level-aware quest cycle")
    toggle(al,"Auto Level - accept / farm / repeat","autoLevel",function(v)
        endTravel();release("Combat");S.target=nil;C.questRoute=nil;C.questActive=nil;C.questSentAt=nil;C.questAttempts=0
        if v then flag("farm",false);flag("fly",false);endFly();loadNative();S.status="Loading native modules for Auto Level"
        else S.questStage="OFF";S.status="Auto Level OFF" end
    end)
    al:Dropdown({Name="Quest policy",Items={"Highest eligible","Mobs only"},Default=S.questPolicy,Flag="cam_quest_policy",Callback=function(v) S.questPolicy=v end})
    al:Label("17 repeatable kill routes by level; active quest finishes before switching.")
    al:Label("NPC -> AddQuest -> holder -> kills -> native closure. No fake CompleteQuest.")
    local routeSec=section(autoPage,"source-backed progression",2)
    for _,route in ipairs(CAM_CATALOG.quests) do routeSec:Label("Lv "..math.max(1,route.level).." | "..route.npc.." | "..npcByCode[route.code].name) end
    routeSec:Label("Race-specific routes may be skipped. No paid training.")
    local qpage=page("quests / boss hunts","gameplay")
    local qs=section(qpage,"native recommendations")
    button(qs,"Show recommended quest",function() local r,msg=recommended();note(msg);if r then log("quest",r.Name.." | NPC "..tostring(r.Npc)) end end)
    button(qs,"Teleport to recommended NPC position",function()
        local r,msg=recommended();if not r then note(msg) return end
        if typeof(r.Position)~="Vector3" then note("No native NPC position") return end
        teleportCF(CFrame.new(r.Position+Vector3.new(0,3,0)))
    end,true)
    qs:Label("Recommendation is not acceptance; the loop lives on the Auto Level page.")
    local hs=section(qpage,"boss hunt claim",2)
    huntDrop=hs:Dropdown({Name="Live hunt ID",Items={"Refresh hunts"},Default="Refresh hunts",Flag="cam_hunt",Callback=function(v) S.huntId=v end})
    refreshHunts=function()
        local rows=huntRows();local items={}
        for id,row in pairs(rows) do items[#items+1]=id;log("hunt",id.." | "..row.quest.." | "..tostring(row.boss)) end
        table.sort(items);huntDrop:Refresh(#items>0 and items or {"No eligible live hunts"})
        if rows[S.huntId] then huntDrop:Set(S.huntId,true) else S.huntId="" end
        return #items
    end
    button(hs,"Refresh hunts + write names to log",function() note("Eligible live hunts: "..refreshHunts()..". See diagnostics for names.") end)
    button(hs,"Claim selected hunt once",function() tell(claimHunt()) end,true)
    toggle(hs,"Auto claim selected hunt (once per ID)","autoHunt")
    hs:Label("Claims the selected ID once; race/expiry checked; completion stays server-side.")
    local lootpage=page("loot / interaction","gameplay")
    local ls=section(lootpage,"nearby native prompts")
    toggle(ls,"Auto Loot - prompts only","loot",function(v) if not v and not S.chest then endPrompt() end end)
    toggle(ls,"Auto Chest - unlocked prompts only","chest",function(v) if not v and not S.loot then endPrompt() end end)
    toggle(ls,"Instant ProximityPrompt (local hold duration)","instant",function(v) if not v then restorePrompts() end end)
    button(ls,"Use nearest visible prompt once",function()
        local best,dist=nil,math.huge
        for p in pairs(C.prompts) do local ok,d=withinPrompt(p);if ok and d<dist then best=p;dist=d end end
        if best then tell(startPrompt(best)) else note("No enabled prompt in native range / line of sight") end
    end,true)
    ls:Label("No prompt = no supported automatic interaction; no payload guesses.")
    ls:Label("Locked caches are skipped; no guard instant kill.")
    local inv=section(lootpage,"native toolbar",2)
    for i=1,5 do
        local slot=i
        button(inv,"Equip existing toolbar slot "..i,function()
            local ok,why=usable();if not ok then note(why) return end
            local equipped=at(LP,{"Items_Config","Equipped"})
            if not equipped or not equipped:IsA("IntValue") then note("Native toolbar unavailable") return end
            equipped.Value=slot;note("Native toolbar slot selected: "..slot)
        end)
    end
    inv:Label("Equips existing toolbar slots only; no invented best-gear scoring.")
    local bs=section(lootpage,"fishing bait (native signal)",2)
    local baitDrop=bs:Dropdown({Name="Bait from inventory",Items={"Refresh bait list"},Default="Refresh bait list",Flag="cam_bait",Callback=function(v) S.baitName=v end})
    button(bs,"Refresh bait list",function() local names=baitScan();baitDrop:Refresh(#names>0 and names or {"No bait-named items found"});note("Bait items found: "..#names) end)
    button(bs,"Equip selected bait",function()
        local id=C.baitItems and C.baitItems[S.baitName]
        if not id then note("Refresh the bait list and select an item first") return end
        if equippedBait()==id then note("Already equipped; use Unequip to toggle off") return end
        tell(baitRequest(id))
    end,true)
    button(bs,"Unequip bait",function() if equippedBait()==0 then note("No bait equipped") return end tell(baitRequest(0)) end,true)
    bs:Label("EquipBait native signal; ack via EquippedBaitId. Casting below.")
    local mp=page("movement / teleports","utilities")
    local ms=section(mp,"client movement")
    toggle(ms,"Fly (WASD / Space / LeftCtrl)","fly",function(v) if v then flag("farm",false);flag("autoLevel",false);S.questStage="OFF";endTravel();releaseAll();endPrompt() else endFly() end end)
    slider(ms,"Fly speed","flySpeed",10,120)
    button(ms,"Fly UP pulse (mobile)",function() C.flyUp=true;task.delay(0.5,function() C.flyUp=false end) end)
    button(ms,"Fly DOWN pulse (mobile)",function() C.flyDown=true;task.delay(0.5,function() C.flyDown=false end) end)
    toggle(ms,"Noclip","noclip")
    local farmNoclipRef=toggle(ms,"Noclip while farming/travelling (auto)","farmNoclip")
    farmNoclipRef:Set(S.farmNoclip,true)
    ms:Label("Auto noclip only while travelling to / holding a target (not Walk mode).")
    toggle(ms,"Speed override","speed");slider(ms,"Walk speed","walkSpeed",16,80)
    toggle(ms,"High Jump","jump");slider(ms,"Jump height (studs)","jumpHeight",7,40)
    toggle(ms,"Always Run - hold native Run input","run",function(v) if not v then release("Run") end end)
    toggle(ms,"Disable Shift Lock (native setting)","shift",function(v) if not v then restoreShift() end end)
    ms:Label("Local movement can be corrected by the server.")
    local ts=section(mp,"streamed destinations",2)
    ts:Dropdown({Name="Destination type",Items={"Zone","NPC","Mob","Boss","Muzan","Chest","Loot","Spider Lily","Lever","Wild Horse","Training"},Default="Zone",Flag="cam_dest_type",Callback=function(v) S.destinationType=v;S.destination="";if refreshDestinations then refreshDestinations() end end})
    destinationDrop=ts:Dropdown({Name="Destination path",Items={"Refresh destinations"},Default="Refresh destinations",Flag="cam_dest",Callback=function(v) S.destination=v end})
    refreshDestinations=function()
        C.destinations={};local names={}
        for o,k in pairs(C.objects) do
            if live(o) then
                if (k=="Mob" or k=="Boss" or k=="NPC" or k=="Player") and o:IsA("Model") and o:FindFirstChildOfClass("Humanoid") then k=kindOfNPC(o) end
                if k==S.destinationType and part(o) then
                    local name=o:GetFullName();if not C.destinations[name] and #names<200 then names[#names+1]=name;C.destinations[name]=o end
                end
            end
        end
        table.sort(names);destinationDrop:Refresh(#names>0 and names or {"No loaded destinations"})
        if C.destinations[S.destination] then destinationDrop:Set(S.destination,true) else S.destination="" end
        return #names
    end
    button(ts,"Refresh destinations",function() note("Loaded destinations: "..refreshDestinations()) end)
    button(ts,"Teleport to selected loaded object",function() teleportObject(C.destinations and C.destinations[S.destination]) end,true)
    button(ts,"Teleport to selected farm target",function() teleportObject(target()) end,true)
    button(ts,"Teleport to loaded Muzan",function() for o,k in pairs(C.objects) do if k=="Muzan" and live(o) then teleportObject(o) return end end;note("Muzan is not streamed in") end,true)
    button(ts,"Save current position",function() local _,_,r=char();if r then C.savedPosition=r.CFrame;note("Position saved for this session") end end)
    button(ts,"Return to saved position",function() if C.savedPosition then teleportCF(C.savedPosition) else note("Save a position first") end end,true)
    button(ts,"Ownership of selected target",function() note("Network ownership: "..ownership(target())) end)
    ts:Label("No fabricated coordinates / cross-world teleport.")
    local ep=page("ESP / notifications","visuals")
    local es=section(ep,"categories")
    toggle(es,"Enable ESP (Highlight chams)","esp",function(v) if not v then clearESP() end end,true)
    for _,row in ipairs({{"Player ESP","players"},{"Mob ESP","mobs"},{"Boss ESP","bosses"},{"NPC ESP","npcs"},{"Chest ESP","chests"},{"Loot ESP","drops"},{"Muzan ESP","muzan"},{"Spider Lily ESP","lily"},{"Lever ESP","levers"},{"Wild Horse ESP","horses"}}) do toggle(es,row[1],row[2],nil,true) end
    button(es,"Enable basic mob / boss ESP",function()
        for _,key in ipairs({"esp","mobs","bosses","names","hpbar"}) do flag(key,true) end
    end)
    slider(es,"ESP range","espRange",50,2000);slider(es,"Max objects drawn","espLimit",5,80)
    local ev=section(ep,"styles / notifications",2)
    toggle(ev,"Text: name / HP / distance","names",nil,true)
    toggle(ev,"Health bar","hpbar",nil,true)
    toggle(ev,"Tracers (screen lines)","tracer",nil,true)
    toggle(ev,"Boss streamed-in notification","notifyBoss",nil,true)
    toggle(ev,"Muzan streamed-in notification","notifyMuzan",nil,true)
    toggle(ev,"New eligible Boss Hunt notification","notifyHunts",nil,true)
    ev:Label("World-highlight ESP; streamed objects only (not a server-wide proof).")
    local dp=page("diagnostics / limits","system")
    local liveSec=section(dp,"live status")
    statusLabel=liveSec:Label("Ready; all automation OFF")
    nativeLabel=liveSec:Label("Native controls: not connected")
    targetLabel=liveSec:Label("Target: none")
    resourceLabel=liveSec:Label("HP / stamina: -")
    questLabel=liveSec:Label("Quest: -")
    indexLabel=liveSec:Label("Indexing loaded world...")
    local ds=section(dp,"local report")
    button(ds,"ONE CLICK - save + copy main diagnostics",function()
        local text=report();local name="CAM_Main_"..os.date("!%Y%m%d_%H%M%S")..".json";local saved,copied=false,false
        if type(writefile)=="function" then saved=pcall(writefile,name,text) end
        local fn=setclipboard or toclipboard or (Clipboard and Clipboard.set)
        if type(fn)=="function" then copied=pcall(fn,text) end
        note((saved and "Saved "..name or "File save unavailable").." | "..(copied and "Clipboard API accepted text" or "Clipboard unavailable"))
        if not saved and not copied then manualReport(text) end
    end)
    button(ds,"COPY diagnostic report",function()
        local text=report();local fn=setclipboard or toclipboard or (Clipboard and Clipboard.set)
        if type(fn)=="function" then local ok=pcall(fn,text);if ok then note("Report sent to clipboard") return end end
        manualReport(text)
    end)
    button(ds,"Save diagnostic JSON",function()
        if type(writefile)~="function" then manualReport(report());return end
        local name="CAM_Main_"..os.date("!%Y%m%d_%H%M%S")..".json";writefile(name,report());note("Saved: "..name)
    end)
    button(ds,"Show report on screen",function() manualReport(report()) end)
    button(ds,"Clear log",function() C.logs={} end)
    ds:Label("Send this one-click report when a native integration misbehaves.")
    -- v2.3.1 quest advance: honest deliver/collect nudge from decompiled 029/030/031:
    -- only QuestProgress(questKey, taskId) for specs whose RequiredItem is in the live inventory; server validates.
    actions.advanceQuest=function()
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
    actions.npcAction=function(name,...)
        local signal=C.modules.Signal
        if not (signal and type(signal.ToServer)=="function") then return false,"Connect native controls first" end
        signal.ToServer(name,...)
        log("npc",name)
        return true,name.." requested (stand near the NPC; server validates)"
    end
    -- v2.3.1 nearest world prompt (queues/levers/portals/join nodes are prompt-driven, no hidden remotes)
    actions.activateNearestPrompt=function()
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
    local cpage=page("combat","action")
    local spage=page("skills","action")
    local tr=section(spage,"skill tree (manual spend)",1)
    tr:Textbox({Name="Skill tree node (exact name)",Placeholder="e.g. Max Health",Default=S.treeNode,Callback=function(v) S.treeNode=v end})
    button(tr,"Unlock / level up node (UnlockSkillTreeNode)",function() loadNative();tell(actions.unlockTreeNode()) end,true)
    treeLabel=tr:Label("Skill points: - | node rank: -")
    tr:Label("Clicks only; real spend. Ack: points decrease + rank bump ~0.4s.")
    tr:Label("Protocol: ToServer UnlockSkillTreeNode(name) -> true on accept.")
    local pc=section(cpage,"defense - auto parry (beta)",2)
    toggle(pc,"Auto Parry - block hostile attack anims","autoParry",function(v)
        if v then loadNative();actions.watchBlockingValues();for m in pairs(C.humanoids) do actions.watchParryModel(m) end
        else release("Skills_1st") end
    end)
    slider(pc,"Parry range (studs)", "parryRange",4,30)
    slider(pc,"Block hold (s)","parryHold",0.15,1)
    slider(pc,"Parry cooldown (s)","parryCooldown",0.3,3)
    parryLabel=pc:Label("Parry: idle")
    pc:Label("Trigger: nearby action anims; ack via Values/Blocking (+Perfect).")
    pc:Label("Input first; falls back to direct signal; auto-pauses without ack.")
    local ts=section(cpage,"auto training (beta)",1)
    toggle(ts,"Auto Training - complete minigames","autoTraining",function(v)
        if v then loadNative();actions.watchTrainingValues() end
    end)
    ts:Dropdown({Name="Mode",Items={"Instant (win signal)","Default (auto-play slider)"},Default=S.trainingMode,Callback=function(v) S.trainingMode=v end})
    slider(ts,"Instant: delay before StateChanged (s)","trainDelay",0.1,3)
    trainLabel=ts:Label("Training: idle")
    ts:Label("Instant sends StateChanged + Stop,true exactly like a real win.")
    ts:Label("Clicks slider inside target zone only; skips unknown bars.")
    local sh=section(spage,"shop / loadout (explicit clicks only)",1)
    sh:Textbox({Name="Shop item name (exact)",Placeholder="e.g. Blood Bait",Default=S.buyName,Callback=function(v) S.buyName=v end})
    slider(sh,"Buy amount","buyAmount",1,25)
    button(sh,"Buy item (PurchaseFromShop)",function() loadNative();tell(actions.buyShop(false)) end,true)
    button(sh,"Buy item with ore (WithOre)",function() loadNative();tell(actions.buyShop(true)) end,true)
    sh:Textbox({Name="Loadout name",Placeholder="existing loadout",Default=S.loadoutName,Callback=function(v) S.loadoutName=v end})
    sh:Textbox({Name="Loadout rename text",Placeholder="new name",Default=S.loadoutText,Callback=function(v) S.loadoutText=v end})
    button(sh,"Save loadout (current build)",function() loadNative();tell(actions.loadoutAction(1,nil)) end,true)
    button(sh,"Load loadout",function() loadNative();tell(actions.loadoutAction(2,nil)) end)
    button(sh,"Rename loadout",function() loadNative();tell(actions.loadoutAction(3,S.loadoutText)) end)
    local skn=section(spage,"auto skills / native scheduler",2)
    toggle(skn,"Auto Skills (selected input slots)","skills",function(v) if v then loadNative() else for _,a in ipairs(skillActions) do release(a) end end end)
    for i=1,10 do
        local slot=i;local key="skillSlot"..i
        toggle(skn,"Use skill input slot "..i,key,function(v) S.skillSlots[slot]=v;if not v then release(skillActions[slot]) end end)
    end
    slider(skn,"Skill use interval (seconds)","skillDelay",0.25,5)
    slider(skn,"Skill hold (seconds, 0 = tap)","skillHold",0.01,1)
    slider(skn,"Skill range (studs)","skillRange",10,200)
    skn:Label("Native aim; slot 1 may be block - choose slots deliberately.")
    local rq=section(qpage,"muzan / ranked requests",1)
    button(rq,"Start Muzan Quest (Demon race)",function() loadNative();tell(actions.startMuzanQuest()) end,true)
    rq:Label("Stand at the Muzan lair; starts quest only when not already Doing.")
    rq:Textbox({Name="Ranked key (board/mode)",Placeholder="from ranked UI",Default=S.rankedKey,Callback=function(v) S.rankedKey=v end})
    button(rq,"Ranked: refresh board",function() loadNative();tell(actions.rankedRequest("Board")) end)
    button(rq,"Ranked: claim reward",function() loadNative();tell(actions.rankedRequest("Claim")) end,true)
    sh:Label("Protocols from sources 072/074/075/081. No auto-spend loops.")
    local cb=section(cpage,"combat assist (client-side)",1)
    toggle(cb,"Inf Stamina (client replica)","infStamina")
    cb:Label("Server stamina gates only in Boost/Zigzag; client pool pinned to MaxValue.")
    toggle(cb,"Inf Dash + no skill cooldowns (client)","noCd",function(v)
        if v then loadNative() end
    end)
    cb:Label("lastUsed reset every 0.3s; dash server has no gate (296). Silent caps may apply.")
    toggle(cb,"Rapid M1 pace (client swing unlock)","fastM1",function(v)
        if v then loadNative();local ok,msg=actions.fastM1Apply();if not ok then notify("Rapid M1",msg,4) end
        else actions.fastM1Restore() end
    end)
    cb:Label("Client swing gate unlocked: presets zeroed, stamps reset each frame. Restored on off.")
    toggle(cb,"Kill Aura (nearest mob in range)","killAura")
    cb:Slider({Name="Kill Aura extra range (studs)",Min=2,Max=60,Default=S.killAuraRange,Callback=function(v) S.killAuraRange=v end})
    cb:Label("Punches nearest living mob in range every 0.33s via native punch.")
    toggle(cb,"Instant Kill (network-owned mobs, HP <= threshold)","instaKill")
    cb:Slider({Name="Instant Kill HP threshold %",Min=1,Max=50,Default=S.instaKillPct,Callback=function(v) S.instaKillPct=v end})
    cb:Label("Kills owned mobs below threshold (ownership = the kill replicates).")
    toggle(cb,"Fast Attack (direct Combat_Service)","fastAttack",function(v) if v then loadNative() end end)
    cb:Label("Raw Combat_Service per client protocol (combo 1..Max, preset hit-delay).")
    toggle(cb,"No Stun / No Ragdoll (client values purge)","noDebuffs")
    cb:Label("Purges Stun/CombatStun/Strict_Stun/Ragdoll from client objects every 0.2s.")
    local qs=section(spage,"auto skills / breathing",2)
    toggle(qs,"Infinite Jump (JumpRequest)","infJump")
    toggle(qs,"Fullbright (local lighting)","fullbright",function(v) actions.setLight(v or S.noFog) end)
    toggle(qs,"No Fog + no global shadows","noFog",function(v) actions.setLight(v or S.fullbright);if not (v or S.fullbright) then actions.setLight(false) end end)
    qs:Textbox({Name="FPS cap (0 = default, applies via setfpscap)",Placeholder="e.g. 240",Default=S.fpsCapText,Callback=function(v) S.fpsCapText=v;local n=tonumber(v);if n and setfpscap then pcall(setfpscap,n>0 and n or 60) end end})
    toggle(qs,"Auto Skills (list below) - server signaler","autoSkills",function(v) if v then loadNative() end end)
    qs:Textbox({Name="Skills (comma separated, e.g. Water Surface Slash, Total Concentration)",Placeholder="skill, skill, skill",Default=S.autoSkillText,Callback=function(v) S.autoSkillText=v end})
    qs:Label("Signaler Hold(+Cancel 1s) each 1.4s; aim = zero vector. Stack with Inf Stamina no-CD.")
    toggle(qs,"Auto Breathing Boost (when Stamina >25%)","autoBreath",function(v) if v then loadNative() end end)
    qs:Label("Holds Breathing Boost 0.6s per 2.5s while client Stamina > 25%.")
    qs:Label("SIG_RE / CAM_RE: not in this game's dumps (0 matches). Real equivalents shipped above.")
    local fb=section(lootpage,"auto fishing",1)
    toggle(fb,"Auto Fishing - cast, catch, win","autoFish",function(v)
        if v then loadNative();actions.watchFishPortal() else C.fish.awaitingBite=false end
    end)
    slider(fb,"Answer delay after bite (s)","fishDelay",0.3,3)
    slider(fb,"Recast if no bite (s)","fishNudge",5,30)
    fishLabel=fb:Label("Fishing: idle")
    button(fb,"Cast now (single)",function() loadNative();tell(actions.castRod()) end)
    fb:Label("Needs a *Fishing Rod; cast = native Tool activation near water.")
    local qs=section(qpage,"quest / prompt helpers",2)
    button(qs,"Advance delivery/collect quest (inventory-verified)",function() loadNative();tell(actions.advanceQuest()) end)
    button(qs,"Activate nearest world prompt (queue/lever/portal)",function() tell(actions.activateNearestPrompt()) end)
    qs:Label("Queues/waves/trainers are prompt-driven; no dedicated remotes in dumps.")
    local npcq=section(qpage,"npc interactions (stand near the NPC)",1)
    button(npcq,"Gauntlet statues: begin",function() loadNative();tell(actions.npcAction("GauntletStatuesBegin")) end)
    button(npcq,"Gauntlet statue: give schematic",function() loadNative();tell(actions.npcAction("GauntletGiveSchematic")) end,true)
    button(npcq,"Wagasa: give schematic",function() loadNative();tell(actions.npcAction("WagasaGiveSchematic")) end,true)
    button(npcq,"Muzan: give bell",function() loadNative();tell(actions.npcAction("MuzanGiveBell")) end,true)
    button(npcq,"Take Foxfire",function() loadNative();tell(actions.npcAction("FoxfireTake")) end)
    button(npcq,"Retsu: tell Foxfire",function() loadNative();tell(actions.npcAction("RetsuTellFoxfire")) end)
    button(npcq,"Isao: take toll",function() loadNative();tell(actions.npcAction("IsaoTakeToll")) end,true)
    button(npcq,"Sofen: pull ledger",function() loadNative();tell(actions.npcAction("SofenPullLedger")) end)
    button(npcq,"Liv: gamble",function() loadNative();tell(actions.npcAction("LivGamble")) end,true)
    button(npcq,"Dismiss crow",function() loadNative();tell(actions.npcAction("CrowDismiss")) end)
    button(npcq,"Cleaver duel",function() loadNative();tell(actions.npcAction("CleaverDuel")) end,true)
    npcq:Dropdown({Name="WarFans clue #",Items={"1","2","3","4"},Default=S.wurfansClue,Callback=function(v) S.wurfansClue=v end})
    button(npcq,"WarFans: submit clue",function() loadNative();tell(actions.npcAction("WarFansClue",tonumber(S.wurfansClue))) end,true)
    local pending=section(dp,"NOT IMPLEMENTED - no fake switches",2)
    pending:Label("Still not wired: code redeem UI (no code remote exists in any dump), internal queue/wave scoring, gear scoring. VERDICT: instant kill IS possible via network ownership (Health=0 on your-owned mobs) - shipped in 2.5.0 ported from the working script. Damage remote still does not exist; this is why ownership is the only working path.")
    -- Lifecycle / streaming. No game state-changing action runs at startup.
    connect(workspace.DescendantAdded,add,"Workspace.DescendantAdded")
    connect(workspace.DescendantRemoving,remove,"Workspace.DescendantRemoving")
    -- respawn-safe: features persist through death; only target-selection state clears
    connect(LP.CharacterRemoving,function() S.target=nil;C.target=nil;C.farmTarget=nil;C.auraCache=nil;C.scanList=nil;C.cdWipeT=nil end)
    connect(LP.CharacterAdded,function() C.fatk.combo=1;C.fatk.next=0 end)
    connect(LP:GetPropertyChangedSignal("Team"),function() stopAll("Team changed") end)
    connect(Input.InputBegan,function(key)

    end)
    local tick,elapsed,uiTime=0,0,0
    connect(Run.Heartbeat,function(dt)
        if S.autoParry and not C.blockWatchDone then pcall(watchBlockingValues) end
        if S.autoTraining and not C.trainWatchDone then pcall(watchTrainingValues) end
        if S.infStamina then pcall(actions.infStaminaTick) end
        if S.noCd and os.clock()-(C.cdWipeT or 0)>0.3 then C.cdWipeT=os.clock();pcall(actions.wipeCooldowns) end
        if S.fastM1 then local cp=C.modules.CombatPresets;if type(cp)=="table" then cp.Last_Punched=-1000000;cp.Last_Punched_Jump=-1000000;cp.Last_Combo=0 end end
        if S.killAura and os.clock()-(C.auraT or 0)>0.33 then C.auraT=os.clock();pcall(actions.killAuraTick) end
        if S.noDebuffs and os.clock()-(C.purgeT or 0)>0.2 then C.purgeT=os.clock();pcall(actions.purgeDebuffs) end
        if (S.autoSkills or S.autoBreath) then pcall(actions.autoSkillTick) end
        if winShadow then pcall(function() if winShadow.Visible then killShadow() end end) end
        if S.autoFarm or S.autoBoss then pcall(actions.farmTick) end
        if S.instaKill and os.clock()-(C.ikT or 0)>0.1 then C.ikT=os.clock();pcall(actions.instaKillTick) end
        if S.fastAttack then pcall(actions.fastAttackTick) end
        if S.autoFish and os.clock()-C.fish.last>0.5 then
            if C.fish.awaitingBite and os.clock()-C.fish.last<=(S.fishNudge or 8) then
            else pcall(function() actions.castRod() end) end
        end
        local current,h=char()
        if h and h.Health<=0 and C.deadCharacter~=current then C.deadCharacter=current;stopAll("Death: all toggles OFF") end
        if h and h.Health>0 then C.deadCharacter=nil end
        moveStep();farmMove(dt)
        elapsed=elapsed+dt;uiTime=uiTime+dt;C.visualClock=C.visualClock+dt;C.espClock=(C.espClock or 0)+dt
        if C.visualClock>=0.08 then C.visualClock=0;tracerStep() end
        if C.espClock>=0.45 then C.espClock=0;renderESP() end
        if elapsed>=0.2 then elapsed=0;scheduler() end
        if uiTime>=1 then
            uiTime=0;tick=tick+1
            local _,h=char();local m=S.target;local n=0;for _ in pairs(C.objects) do n=n+1 end
            statusLabel:SetText(short(S.status,95));indexLabel:SetText((C.indexing and "Indexing... " or "Loaded index: ")..n.." objects")
            if parryLabel and parryLabel.SetText then parryLabel:SetText("Parry: "..C.parryAttempts.." taps / "..C.parryBlocked.." blocks / "..C.parryPerfect.." perfect | method "..C.parryPath..(C.parryConfirmed and " (server-confirmed)" or " (unconfirmed)")) end
            if trainLabel and trainLabel.SetText then trainLabel:SetText("Training: "..C.trainWins.." win signals / "..C.trainClicks.." slider clicks") end
            if fishLabel and fishLabel.SetText then fishLabel:SetText("Fishing: "..C.fish.casts.." casts / "..C.fish.bites.." bites / "..C.fish.wins.." wins") end
            if treeLabel and treeLabel.SetText then
                local pts,rank=actions.treeRank(S.treeNode)
                treeLabel:SetText("Skill points: "..tostring(pts).." | '"..tostring(S.treeNode).."' rank: "..tostring(rank))
            end
            local ready,total=0,0;for k in pairs(modulePaths) do total=total+1;if C.modules[k] then ready=ready+1 end end
            nativeLabel:SetText("Native modules ready: "..ready.."/"..total.." | "..(C.inputBackend or "input not used"))
            targetLabel:SetText(m and "Target: "..m.Name or "Target: none")
            local v=values();local stamina=v and v:FindFirstChild("Stamina")
            resourceLabel:SetText("HP "..(h and math.floor(h.Health) or "-").." | Stamina "..(stamina and tostring(stamina.Value) or "-"))
            local d=data();local holder=d and at(d,{"Quests","Holder"});local names={}
            if holder then for _,q in ipairs(holder:GetChildren()) do names[#names+1]=q.Name end end
            questLabel:SetText("Lv "..tostring(level() or "?").." | "..S.questStage.." | "..S.questProgress.." | "..short(S.questName,45))
            if tick%5==0 then
                local new={}
                for id,row in pairs(huntRows()) do
                    if C.huntsInitialized and S.notifyHunts and not C.huntSeen[id] then note("New eligible hunt: "..row.quest) end
                    new[id]=true
                end
                C.huntSeen=new;C.huntsInitialized=true
            end
        end
    end)
    task.spawn(function()
        local all=workspace:GetDescendants()
        for i,o in ipairs(all) do
            if not S.alive then return end
            local ok,err=pcall(add,o);if not ok then log("index",err) end
            if i%400==0 then task.wait() end
        end
        C.indexing=false
    end)
    note("CAM Main 3.2.4 ready. Auto Level or Auto Farm connects native controls automatically. All automation OFF. End: STOP.")
end
StartCAMHub(Lumen)

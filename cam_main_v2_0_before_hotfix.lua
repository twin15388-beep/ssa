-- CAM Main Hub 2.0 | source-backed client integration for place 136406881576517.
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
        attackDelay=0.5,skillDelay=3,skillHold=0.2,healthStop=25,
        walkSpeed=26,jumpHeight=12,flySpeed=45,espRange=600,espLimit=40,
        priority="Combat first",destinationType="Zone",destination="",huntId="",status="Ready - automation OFF",
        skillSlots={},epoch=0}
    local C={connections={},toggles={},logs={},modules={},loading={},loaderTasks={},owned={},tickets={},
        collision=setmetatable({}, {__mode="k"}),holds=setmetatable({}, {__mode="k"}),
        humanoids={},objects={},prompts={},esp={},cooldowns={},huntSent={},huntSeen={},
        skillIndex=0,seen=setmetatable({}, {__mode="k"}),count=0,indexing=true,visualClock=0}
    local stopAll,clearESP,refreshTargets,refreshDestinations,refreshHunts,endTravel
    local statusLabel,targetLabel,resourceLabel,questLabel,nativeLabel,indexLabel
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
    local function connect(signal,fn)
        local con=signal:Connect(function(...)
            if not S.alive then return end
            local ok,err=pcall(fn,...)
            if not ok then log("callback error",err);if stopAll then stopAll("Callback failed; see diagnostics") end end
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
        note("Loading allowlisted native controls. No gameplay action is requested by the hub.")
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
        S.epoch=S.epoch+1
        for key in pairs(C.toggles) do flag(key,false) end
        for key,thread in pairs(C.loaderTasks) do
            if C.loading[key]=="loading" then if thread then pcall(task.cancel,thread) end;C.loading[key]=nil end
        end
        releaseAll();endFly();stopWalk();if endTravel then endTravel() end;restoreMovement();restorePrompts();restoreShift()
        C.questActive=nil;C.questRoute=nil;C.questSentAt=nil;C.questAttempts=0;C.damageWatch=nil;C.punch=nil;C.equipAttempts=0;C.equipmentWait=nil;S.questStage="OFF"
        S.target=nil;S.skillSlots={};C.flyUp=false;C.flyDown=false;C.cooldowns={};C.huntSent={};C.attackAt=nil;C.skillAt=nil
        if clearESP then clearESP() end
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
        if not item then return false,"No usable combat weapon in selected toolbar slot" end
        if equipped.Value~=desired then
            if (C.equipAt or 0)>os.clock() then return false,"Waiting for equipment acknowledgement" end
            C.equipAt=os.clock()+2;C.equipAttempts=(C.equipAttempts or 0)+1
            if C.equipAttempts>3 then stopAll("Equipment rejected 3 times; equip weapon manually") return false,S.status end
            -- Equipped is the SLOT INDEX, not the inventory item ID. Native HUD Changed listener validates and sends Item_Equip.
            equipped.Value=desired;log("equipment","Selected native toolbar slot "..desired.." / "..item.Name)
            return false,"Preparing weapon: "..item.Name
        end
        local actual=info.Get_equipped_tool(LP)
        if not actual or actual.Name~=item.Name then return false,"Waiting for native equipped weapon state" end
        C.equipAttempts=0;S.equipment=item.Name
        return true
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
    local function add(o)
        if not live(o) then return end
        if o:IsA("Humanoid") and o.Parent:IsA("Model") then
            C.humanoids[o.Parent]=true;C.objects[o.Parent]=kindOfNPC(o.Parent)
            local m=o.Parent;local k=C.objects[m]
            if not C.indexing and not C.seen[m] and S.notifyBoss and k=="Boss" then note("Boss streamed in: "..m.Name) end
            C.seen[m]=true
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
        C.humanoids[o]=nil;C.objects[o]=nil;C.prompts[o]=nil;C.seen[o]=nil;C.cooldowns[o]=nil
        if o:IsA("Humanoid") then C.humanoids[o.Parent]=nil end
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
    -- Screen-space overlays, no Drawing API or external assets.
    local gui=Instance.new("ScreenGui");gui.Name="CAM_Main_Overlay";gui.ResetOnSpawn=false;gui.IgnoreGuiInset=true;gui.DisplayOrder=40;gui.Parent=LP:WaitForChild("PlayerGui")
    local colors={Player=Color3.fromRGB(90,174,255),Mob=Color3.fromRGB(255,172,85),Boss=Color3.fromRGB(255,80,110),NPC=Color3.fromRGB(160,155,255),Chest=Color3.fromRGB(255,218,95),Loot=Color3.fromRGB(95,240,160),Muzan=Color3.fromRGB(230,70,220)}
    local espFlags={Player="players",Mob="mobs",Boss="bosses",NPC="npcs",Chest="chests",Loot="drops",Muzan="muzan",["Spider Lily"]="lily",Lever="levers",["Wild Horse"]="horses"}
    local function make(class,props,parent)
        local o=Instance.new(class);for k,v in pairs(props or {}) do o[k]=v end;o.Parent=parent;return o
    end
    local function visual(o,k)
        local root=make("Frame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,BorderSizePixel=0},gui)
        local color=colors[k] or Color3.fromRGB(130,240,220)
        local v={root=root,color=color,lines={}}
        v.box=make("Frame",{BackgroundColor3=color,BackgroundTransparency=1,BorderSizePixel=0},root)
        v.stroke=make("UIStroke",{Color=color,Thickness=1.2,Enabled=false},v.box)
        v.label=make("TextLabel",{Size=UDim2.fromOffset(250,35),BackgroundTransparency=1,TextColor3=color,TextStrokeTransparency=0.25,TextSize=13,Font=Enum.Font.Code},root)
        v.bar=make("Frame",{BackgroundColor3=Color3.fromRGB(28,30,36),BorderSizePixel=0},root)
        v.hp=make("Frame",{BackgroundColor3=Color3.fromRGB(85,225,125),BorderSizePixel=0},v.bar)
        for i=1,13 do v.lines[i]=make("Frame",{AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3=color,BorderSizePixel=0,Visible=false},root) end
        C.esp[o]=v;return v
    end
    clearESP=function() for o,v in pairs(C.esp) do v.root:Destroy();C.esp[o]=nil end end
    local corners={{-1,-1,-1},{1,-1,-1},{1,1,-1},{-1,1,-1},{-1,-1,1},{1,-1,1},{1,1,1},{-1,1,1}}
    local edges={{1,2},{2,3},{3,4},{4,1},{5,6},{6,7},{7,8},{8,5},{1,5},{2,6},{3,7},{4,8}}
    local function line(frame,a,b)
        local dx,dy=b.X-a.X,b.Y-a.Y
        frame.Position=UDim2.fromOffset((a.X+b.X)/2,(a.Y+b.Y)/2)
        frame.Size=UDim2.fromOffset(math.sqrt(dx*dx+dy*dy),1)
        frame.Rotation=math.deg(math.atan2(dy,dx));frame.Visible=true
    end
    local function renderESP()
        if not S.esp then if next(C.esp) then clearESP() end return end
        local camera=workspace.CurrentCamera;local _,_,r=char();if not camera or not r then return end
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
            local item=candidates[i];local o=item.o;local v=C.esp[o] or visual(o,item.k);kept[o]=true
            local cf,size
            if o:IsA("Model") then cf,size=o:GetBoundingBox() else cf,size=item.p.CFrame,item.p.Size end
            local points={};local x1,y1,x2,y2=math.huge,math.huge,-math.huge,-math.huge;local front=true
            for j,c in ipairs(corners) do
                local p=camera:WorldToViewportPoint(cf:PointToWorldSpace(Vector3.new(c[1]*size.X/2,c[2]*size.Y/2,c[3]*size.Z/2)))
                if p.Z<=0 then front=false end
                points[j]=p;x1=math.min(x1,p.X);y1=math.min(y1,p.Y);x2=math.max(x2,p.X);y2=math.max(y2,p.Y)
            end
            local vp=camera.ViewportSize
            front=front and x2>=0 and y2>=0 and x1<=vp.X and y1<=vp.Y
            v.root.Visible=front
            if front then
                v.box.Visible=S.box or S.fill;v.box.Position=UDim2.fromOffset(x1,y1);v.box.Size=UDim2.fromOffset(x2-x1,y2-y1)
                v.box.BackgroundTransparency=S.fill and 0.86 or 1;v.stroke.Enabled=S.box
                local h=o:IsA("Model") and o:FindFirstChildOfClass("Humanoid")
                local text={};if S.names then text[#text+1]=o.Name end;if S.distance then text[#text+1]=math.floor(item.d).." st" end
                if S.health and h then text[#text+1]=math.floor(h.Health).."/"..math.floor(h.MaxHealth).." HP" end
                v.label.Visible=#text>0;v.label.Text=table.concat(text," | ");v.label.Position=UDim2.fromOffset((x1+x2)/2-125,y1-35)
                v.bar.Visible=S.hpbar and h~=nil
                if h then v.bar.Position=UDim2.fromOffset(x1-7,y1);v.bar.Size=UDim2.fromOffset(4,y2-y1);v.hp.Size=UDim2.fromScale(1,math.max(0,math.min(1,h.Health/math.max(h.MaxHealth,1)))) end
                for j=1,12 do local f=v.lines[j];f.Visible=false;if S.box3d then line(f,points[edges[j][1]],points[edges[j][2]]) end end
                v.lines[13].Visible=false
                if S.tracer then line(v.lines[13],Vector2.new(vp.X/2,vp.Y),Vector2.new((x1+x2)/2,y2)) end
            end
        end
        for o,v in pairs(C.esp) do if not kept[o] then v.root:Destroy();C.esp[o]=nil end end
    end
    local function moveStep()
        local c,h,r=char()
        if not h or not r or h.Health<=0 then
            if C.flyHum then endFly() end
            return
        end
        if S.noclip then
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
        return {format="CAM Main Hub 2.0",timeUTC=os.date("!%Y-%m-%dT%H:%M:%SZ"),placeId=game.PlaceId,placeVersion=game.PlaceVersion,
            state=state,modules=modules,log=C.logs,
            farm={backend=C.inputBackend or "not used",requests=C.attackRequests or 0,comboAcks=C.comboAcks or 0,damageObservations=C.damageEvents or 0,
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
        stopAll("Unloaded");S.alive=false
        for _,con in ipairs(C.connections) do pcall(function() con:Disconnect() end) end
        gui:Destroy()
        if Env.CAMMainHub and Env.CAMMainHub.State==S then Env.CAMMainHub=nil end
    end
    local oldUnload=Lumen.Unload
    function Lumen:Unload() unload();return oldUnload(self) end
    Env.CAMMainHub={State=S,Stop=function() Lumen:Unload() end,Snapshot=snapshot,Version="2.0"}
    Lumen.Folder="cam_main_hub";Lumen.ConfigFolder=Lumen.Folder.."/configs";Lumen.ThemeFolder=Lumen.Folder.."/themes"
    local window=Lumen:Window({Name="CAM MAIN | Quest & Farm",Version="2.0 / content 5354",Footer="RightCtrl menu | End STOP | No server bypass claims",Size=UDim2.fromOffset(900,660),Keybind=Enum.KeyCode.RightControl,SettingsPage=false})
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
    local home=page("dashboard","main")
    local liveSec=section(home,"live status")
    statusLabel=liveSec:Label("Ready; all automation OFF")
    nativeLabel=liveSec:Label("Native controls: not connected")
    targetLabel=liveSec:Label("Target: none")
    resourceLabel=liveSec:Label("HP / stamina: -")
    questLabel=liveSec:Label("Quest: -")
    indexLabel=liveSec:Label("Indexing loaded world...")
    button(liveSec,"Connect native controls",function() for k,v in pairs(C.loading) do if v~="loading" then C.loading[k]=nil end end;loadNative() end)
    button(liveSec,"STOP ALL (End)",function() stopAll("Manual STOP");note("Stopped; settings restored where modified") end)
    button(liveSec,"Unload hub",function() Lumen:Unload() end,true)
    local limits=section(home,"scope / safety",2)
    limits:Label("All toggles start OFF; no config autoload.")
    limits:Label("Native modules load on Connect or enabling a combat mode.")
    limits:Label("Wrong place: gameplay controls locked.")
    limits:Label("47 source-backed hostiles; selected or nearest mode.")
    limits:Label("Other players are never farm targets.")
    limits:Label("No purchases, skill-point spending or race change.")
    limits:Label("Native checks and server validation still apply.")
    limits:Label("No real-client test performed by the author.")
    local autoPage=page("auto level","gameplay")
    local al=section(autoPage,"level-aware quest cycle")
    toggle(al,"Auto Level - accept / farm / repeat","autoLevel",function(v)
        endTravel();release("Combat");S.target=nil;C.questRoute=nil;C.questActive=nil;C.questSentAt=nil;C.questAttempts=0
        if v then flag("farm",false);flag("fly",false);endFly();loadNative();S.status="Loading native modules for Auto Level"
        else S.questStage="OFF";S.status="Auto Level OFF" end
    end)
    al:Dropdown({Name="Quest policy",Items={"Highest eligible","Mobs only"},Default=S.questPolicy,Callback=function(v) S.questPolicy=v end})
    al:Label("17 free repeatable kill routes; level thresholds 1-115.")
    al:Label("Checks current level, race and native requirements.")
    al:Label("Active supported quest is finished before switching.")
    al:Label("NPC -> AddQuest -> replicated holder -> kills -> closure.")
    al:Label("Native cooldown respected; no fake CompleteQuest call.")
    local routeSec=section(autoPage,"source-backed progression",2)
    for _,route in ipairs(CAM_CATALOG.quests) do routeSec:Label("Lv "..math.max(1,route.level).." | "..route.npc.." | "..npcByCode[route.code].name) end
    routeSec:Label("Race-specific routes may be skipped. No paid training.")
    local fight=page("farm / combat","gameplay")
    local fs=section(fight,"hostile target selection")
    fs:Dropdown({Name="Target mode",Items={"Selected mob","Selected boss","Nearest hostile"},Default=S.targetMode,Callback=function(v) S.targetMode=v;S.target=nil;endTravel();release("Combat") end})
    local mobNames,bossList,mobMap,bossMap={},{},{},{}
    for _,row in ipairs(CAM_CATALOG.npcs) do
        local list,map=row.boss and bossList or mobNames,row.boss and bossMap or mobMap
        list[#list+1]=row.name;map[row.name]=row.code
    end
    table.sort(mobNames);table.sort(bossList)
    fs:Dropdown({Name="Selected mob",Items=mobNames,Default="Bandit",Callback=function(v) S.mobCode=mobMap[v];S.target=nil;endTravel() end})
    fs:Dropdown({Name="Selected boss",Items=bossList,Default="Zuko",Callback=function(v) S.bossCode=bossMap[v];S.target=nil;endTravel() end})
    refreshTargets=function()
        local n=0;for m in pairs(C.humanoids) do if validTarget(m) then n=n+1 end end;return n
    end
    button(fs,"Count loaded hostile targets",function() note("Loaded source-matched hostiles: "..refreshTargets()) end)
    toggle(fs,"Auto Farm - selected / nearest","farm",function(v)
        endTravel();release("Combat");C.damageWatch=nil
        if v then flag("autoLevel",false);S.questStage="OFF";flag("fly",false);endFly();loadNative() end
    end)
    toggle(fs,"Auto M1 (no movement)","attack",function(v) if v then loadNative() elseif not S.farm and not S.autoLevel then release("Combat") end end)
    toggle(fs,"Auto Skills (selected input slots)","skills",function(v) if v then loadNative() else for _,a in ipairs(skillActions) do release(a) end end end)
    button(fs,"M1 once",function() tell(attackOnce()) end)
    slider(fs,"Search range","searchRange",20,1200);slider(fs,"M1 range","hitRange",3,10)
    slider(fs,"M1 interval (seconds)","attackDelay",0.25,3);slider(fs,"STOP at HP percent","healthStop",5,80)
    slider(fs,"STOP after no target damage (seconds)","noDamageTimeout",10,60)
    local posPage=page("farm position","gameplay")
    local posSec=section(posPage,"position / movement")
    posSec:Dropdown({Name="Farm position",Items={"Above","Below","Behind","In front","Left","Right","Orbit","Ground"},Default=S.positionMode,Callback=function(v) S.positionMode=v;endTravel() end})
    posSec:Dropdown({Name="Travel method",Items={"Tween","Instant","Walk"},Default=S.travelMode,Callback=function(v) S.travelMode=v;endTravel() end})
    slider(posSec,"Distance","farmDistance",1,15);slider(posSec,"Height","farmHeight",0,15)
    slider(posSec,"Tween speed (studs/sec)","travelSpeed",10,400);slider(posSec,"Orbit speed","orbitSpeed",0.1,4)
    posSec:Dropdown({Name="Look at target",Items={"Horizontal","Full 3D","Off"},Default=S.lookMode,Callback=function(v) S.lookMode=v end})
    posSec:Label("Above default: height 3, distance 2. Not immunity.")
    posSec:Label("Tween = speed-limited linear movement each frame.")
    posSec:Label("Walk cannot hover. High offsets can make M1 miss.")
    local eqSec=section(posPage,"native equipment / input",2)
    eqSec:Dropdown({Name="Combat weapon",Items={"Auto combat tool","Keep equipped","Slot 1","Slot 2","Slot 3","Slot 4","Slot 5"},Default=S.weapon,Callback=function(v) S.weapon=v;C.equipAttempts=0;C.damageWatch=nil end})
    eqSec:Dropdown({Name="M1 input backend",Items={"Auto (live punch / native input)","Native input only"},Default=S.inputMode,Callback=function(v) S.inputMode=v;release("Combat");C.damageWatch=nil end})
    eqSec:Label("Auto keeps usable weapon; otherwise prefers slot 3 / 1.")
    eqSec:Label("No item buying or toolbar rewriting. Native restrictions apply.")
    eqSec:Label("Live Combat.punch uses getsenv only if supported.")
    eqSec:Label("Fallback InputHandler is not called success until observed.")
    eqSec:Label("No mouse clicks that could accidentally press hub buttons.")
    local sk=section(fight,"native skills / scheduler",2)
    sk:Label("Aim uses the game's native mouse/camera; no aim hook.")
    sk:Label("Slot 1 may be block; choose slots deliberately.")
    for i=1,10 do
        local slot=i;local key="skillSlot"..i
        toggle(sk,"Use skill input slot "..i,key,function(v) S.skillSlots[slot]=v;if not v then release(skillActions[slot]) end end)
    end
    button(sk,"Selected skill input once",function() tell(skillOnce()) end)
    slider(sk,"Skill interval","skillDelay",1,10);slider(sk,"Skill hold seconds","skillHold",0.08,3);slider(sk,"Skill target range","skillRange",5,100)
    sk:Dropdown({Name="Action priority",Items={"Combat first","Loot first"},Default=S.priority,Flag="cam_priority",Callback=function(v) S.priority=v end})
    sk:Label("Low HP / menu / death pause or stop actions.")
    sk:Label("Hunt requests wait while combat mode is enabled.")
    local qpage=page("quests / boss hunts","gameplay")
    local qs=section(qpage,"native recommendations")
    button(qs,"Show recommended quest",function() local r,msg=recommended();note(msg);if r then log("quest",r.Name.." | NPC "..tostring(r.Npc)) end end)
    button(qs,"Teleport to recommended NPC position",function()
        local r,msg=recommended();if not r then note(msg) return end
        if typeof(r.Position)~="Vector3" then note("No native NPC position") return end
        teleportCF(CFrame.new(r.Position+Vector3.new(0,3,0)))
    end,true)
    qs:Label("Requires Book of Guidance / native eligibility.")
    qs:Label("Use Auto Level page for the repeatable kill-quest loop.")
    qs:Label("Recommendation is NOT acceptance or completion.")
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
    hs:Label("Race / expiry / CanAddQuest are checked.")
    hs:Label("No auto claim of a new ID; select it explicitly.")
    hs:Label("Farm boss separately; completion is server-controlled.")
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
    ls:Label("No prompt = no supported automatic interaction.")
    ls:Label("No remote or touch-pickup payload is guessed.")
    ls:Label("Locked caches are skipped; no guard instant kill.")
    ls:Label("Instant hold applies to hub interactions only.")
    ls:Label("Not a server timing bypass.")
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
    inv:Label("Same slot assignment as Utility.ForceEquip.")
    inv:Label("No invented 'best gear' scoring or inventory edits.")
    inv:Label("Auto Potion / Auto Buy are not wired in this build.")
    local mp=page("movement / teleports","utilities")
    local ms=section(mp,"client movement")
    toggle(ms,"Fly (WASD / Space / LeftCtrl)","fly",function(v) if v then flag("farm",false);flag("autoLevel",false);S.questStage="OFF";endTravel();releaseAll();endPrompt() else endFly() end end)
    slider(ms,"Fly speed","flySpeed",10,120)
    button(ms,"Fly UP pulse (mobile)",function() C.flyUp=true;task.delay(0.5,function() C.flyUp=false end) end)
    button(ms,"Fly DOWN pulse (mobile)",function() C.flyDown=true;task.delay(0.5,function() C.flyDown=false end) end)
    toggle(ms,"Noclip","noclip")
    toggle(ms,"Speed override","speed");slider(ms,"Walk speed","walkSpeed",16,80)
    toggle(ms,"High Jump","jump");slider(ms,"Jump height (studs)","jumpHeight",7,40)
    toggle(ms,"Always Run - hold native Run input","run",function(v) if not v then release("Run") end end)
    toggle(ms,"Disable Shift Lock (native setting)","shift",function(v) if not v then restoreShift() end end)
    ms:Label("Local movement can be corrected by the server.")
    ms:Label("Hold Run follows native toggle/hold preferences.")
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
    toggle(es,"Enable ESP","esp",function(v) if not v then clearESP() end end,true)
    for _,row in ipairs({{"Player ESP","players"},{"Mob ESP (NPC candidates)","mobs"},{"Boss ESP","bosses"},{"NPC ESP (dialogue-tagged)","npcs"},{"Chest ESP","chests"},{"Loot ESP","drops"},{"Muzan ESP","muzan"},{"Spider Lily ESP","lily"},{"Lever ESP","levers"},{"Wild Horse ESP (exact name)","horses"}}) do toggle(es,row[1],row[2],nil,true) end
    button(es,"Enable basic mob / boss ESP",function()
        for _,key in ipairs({"esp","mobs","bosses","box","names","distance","health"}) do flag(key,true) end
    end)
    slider(es,"ESP range","espRange",50,2000);slider(es,"Max objects drawn","espLimit",5,80)
    es:Label("Only streamed objects; neutral NPC classification is conservative.")
    local ev=section(ep,"styles / local notifications",2)
    for _,row in ipairs({{"Box ESP","box"},{"Box Fill ESP","fill"},{"3D Box ESP","box3d"},{"Name ESP","names"},{"Distance ESP","distance"},{"Health Text ESP","health"},{"Health Bar ESP","hpbar"},{"Tracer ESP","tracer"}}) do toggle(ev,row[1],row[2],nil,true) end
    toggle(ev,"Boss streamed-in notification","notifyBoss",nil,true)
    toggle(ev,"Muzan streamed-in notification","notifyMuzan",nil,true)
    toggle(ev,"New eligible Boss Hunt notification","notifyHunts",nil,true)
    ev:Label("Stream-in is not proof of a new server-wide spawn.")
    ev:Label("No webhook / external upload is implemented.")
    local dp=page("diagnostics / limits","system")
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
    ds:Label("Send this report if a native integration is unavailable.")
    ds:Label("Report is small; overview UTF-8 fallback is included.")
    local pending=section(dp,"NOT IMPLEMENTED - no fake switches",2)
    for _,text in ipairs({"Delivery / escort / fishing quest automation","Queues / Ranked / Fill / Join World","Waves / cards / Bare Hands / forced heal cards","Bring Enemies / Instant Kill / cache guard bypass","Breathing unlock / skill-tree spending / training bot","Fishing / bait / purchases / inventory gear scoring","Auto Potion / Auto Parry / claim souls / schematics","Become Demon / redeem codes / set spawn crystal","Infinite stamina / climb / horse stamina","No drown / stun / ragdoll / sun / dash cooldown","No attack slowdown / external webhook reports","Restock / marketer / Final Selection notifications"}) do pending:Label(text) end
    pending:Label("See the supplied feature matrix for exact limits.")
    -- Lifecycle / streaming. No game state-changing action runs at startup.
    connect(workspace.DescendantAdded,add)
    connect(workspace.DescendantRemoving,remove)
    connect(LP.CharacterRemoving,function() stopAll("Character removed / respawn") end)
    connect(LP.CharacterAdded,function() stopAll("New character: all toggles OFF") end)
    connect(LP:GetPropertyChangedSignal("Team"),function() stopAll("Team changed") end)
    connect(Input.InputBegan,function(key)
        if key.KeyCode==Enum.KeyCode.End then stopAll("End key STOP");note("All automation OFF") end
    end)
    local tick,elapsed,uiTime=0,0,0
    connect(Run.Heartbeat,function(dt)
        local current,h=char()
        if h and h.Health<=0 and C.deadCharacter~=current then C.deadCharacter=current;stopAll("Death: all toggles OFF") end
        if h and h.Health>0 then C.deadCharacter=nil end
        moveStep();farmMove(dt)
        elapsed=elapsed+dt;uiTime=uiTime+dt;C.visualClock=C.visualClock+dt
        if C.visualClock>=0.08 then C.visualClock=0;renderESP() end
        if elapsed>=0.2 then elapsed=0;scheduler() end
        if uiTime>=1 then
            uiTime=0;tick=tick+1
            local _,h=char();local m=S.target;local n=0;for _ in pairs(C.objects) do n=n+1 end
            statusLabel:SetText(short(S.status,95));indexLabel:SetText((C.indexing and "Indexing... " or "Loaded index: ")..n.." objects")
            local ready=0;for _ in pairs(C.modules) do ready=ready+1 end
            nativeLabel:SetText("Native modules ready: "..ready.."/11 | "..(C.inputBackend or "input not used"))
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
    note("CAM Main 2.0 ready. Auto Level or Auto Farm connects native controls automatically. All automation OFF. End: STOP.")
end
StartCAMHub(Lumen)

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

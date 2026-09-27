-- NZL Main Hub 1.0 | client-side integration for place version 2812.
-- Payloads traced to the user's dump. Server acceptance is NOT guaranteed.
-- All automation is OFF at startup. No HTTP, admin remotes, hooks or decompilation.
local function StartMainHub(Lumen)
    local Env = (getgenv and getgenv()) or _G
    if Env.NZLMainHub and Env.NZLMainHub.Stop then pcall(Env.NZLMainHub.Stop) end
    local Players = game:GetService("Players")
    local RS = game:GetService("ReplicatedStorage")
    local Run = game:GetService("RunService")
    local Input = game:GetService("UserInputService")
    local Tween = game:GetService("TweenService")
    local Http = game:GetService("HttpService")
    local LP = Players.LocalPlayer
    assert(LP, "Run this script on the client")
    local S = {
        alive = true, autoM1 = false, autoWalk = false, autoSkill = false,
        autoPaper = false, autoOffer = false, espNPC = false, espPlayers = false,
        noclip = false, speed = false, fly = false, infJump = false,
        allowPlayers = false, faceTarget = false, attackDelay = 0.65,
        searchRange = 120, hitRange = 7, walkSpeed = 28, flySpeed = 45,
        travelSpeed = 45, espRange = 500, targetGroup = "Hunters",
        targetName = "", vampireSkill = "BloodDrink", target = nil,
        lastAction = "Idle", lastReply = "No server replies yet", status = "Ready",
        selectedLandmark = "Quest NPC", selectedShop = "", token = 0,
    }
    local C = { connections = {}, logs = {}, toggleRefs = {}, npcs = {}, prompts = {},
        esp = {}, cooldowns = {}, remoteTimes = {}, watched = {}, shopCards = {},
        collision = setmetatable({}, {__mode = "k"}), stopCount = 0 }
    local statusLabel, targetLabel, resourceLabel, actionLabel, questLabel, questDetailLabel, replyLabel, skillLabel
    local stopAll, unload, cancelTravel, stopFly, clearESP
    local function short(x, n)
        local s=tostring(x);n=n or 350
        if #s<=n then return s end
        while n>0 do local b=s:byte(n+1);if not b or b<128 or b>=192 then break end;n=n-1 end
        return s:sub(1,n).."..."
    end
    local function log(kind, text)
        C.logs[#C.logs+1] = {time=os.date("!%H:%M:%S"),kind=kind,text=short(text,1500)}
        if #C.logs > 150 then table.remove(C.logs,1) end
    end
    local function note(text)
        log("notice",text)
        if S.alive then pcall(function() Lumen:Notification({Name="NZL Main",Description=short(text,250),Duration=5}) end) end
    end
    local function connect(signal, fn)
        local c = signal:Connect(function(...)
            if not S.alive then return end
            local ok, err = pcall(fn,...)
            if not ok then log("callback error",err) end
        end)
        C.connections[#C.connections+1] = c
        return c
    end
    local function at(root, names)
        local o = root
        for _, name in ipairs(names) do if not o then return nil end o = o:FindFirstChild(name) end
        return o
    end
    local function char()
        local c = LP.Character
        return c, c and c:FindFirstChildOfClass("Humanoid"), c and c:FindFirstChild("HumanoidRootPart")
    end
    local function part(o)
        if not o then return nil end
        if o:IsA("BasePart") then return o end
        if o:IsA("Attachment") then return o.Parent and o.Parent:IsA("BasePart") and o.Parent or nil end
        if o:IsA("Model") then return o:FindFirstChild("HumanoidRootPart") or o.PrimaryPart or o:FindFirstChildWhichIsA("BasePart",true) end
        return nil
    end
    local function team() return LP.Team and LP.Team.Name or "None" end
    local function years() return tonumber(LP:GetAttribute("Years")) or 0 end
    local function vampire() return team()=="Vampires" or team()=="Cannibal Raised" end
    local function usable()
        local c,h,r = char()
        if not c or not h or not r or h.Health<=0 then return false,"Character unavailable" end
        for _, key in ipairs({"ActionLocked","Hibernating","Ragdolled","BeingCarried","ToolEquipLocked","BatFormTransforming","BatFormActive"}) do
            if c:GetAttribute(key)==true then return false,key end
        end
        return true
    end
    local routes = {
        Block={"ArczisCombat","Remotes","BlockEvent"},
        Quest={"QuestRemotes","QuestRemote"}, HunterQuest={"HunterQuestRemotes","HunterQuestRemote"},
        Quest2={"Quest2Remotes","Quest2Remote"},
        HumanSideQuest={"Funções","Eventos","HumanSideQuestRemote"},
        Shop={"Funções","Eventos","ShopRemote"}, Broom={"Funções","Eventos","BroomRemote"},
        Sleep={"Funções","Eventos","CeilingSleepRemote"},
        Track={"Funções","Eventos","VampiricTrackerRemote"},
        PainStop={"Funções","Eventos","WitchPainInflictionRemote"},
        StrengthCast={"Funções","Eventos","StrengthRemote"},
        HypnosisEnd={"Network","Combat","HypnosisRequest"},
    }
    for _, key in ipairs({"BreakNeck","BloodDrink","HeartRipping","Infect","Hypnosis","WitchLifeDrain","WitchBreakNeck","WitchHeartRipping","WitchPetrification","WitchPainInfliction","WitchInvisible","Strength","Incendia"}) do
        routes[key] = {"Network","Combat",key.."Request"}
    end
    local function send(key, ...)
        if not S.alive then return false,"Hub unloaded" end
        if game.PlaceId~=122287678911982 then return false,"Wrong place" end
        local path = routes[key]
        if not path then return false,"Unknown route: "..tostring(key) end
        local remote = at(RS,path)
        if not remote or not remote:IsA("RemoteEvent") then return false,"Missing RemoteEvent: "..table.concat(path,"/") end
        local now = os.clock()
        -- Local rate guard, not a server bypass. A two-message ability uses the same route.
        if now - (C.remoteTimes[key] or -100) < 0.025 then return false,"Local request throttle" end
        C.remoteTimes[key] = now
        local args = table.pack(...)
        local ok, err = pcall(function() remote:FireServer(table.unpack(args,1,args.n)) end)
        if not ok then log("remote error",key..": "..tostring(err)) return false,short(err) end
        S.lastAction = "Sent "..key.." / "..short(args[1] or "request",70)
        log("request",S.lastAction)
        return true
    end
    local function tell(ok, reason)
        note(ok and "Request sent; server result is not guaranteed." or (reason or "Action unavailable"))
    end
    local function boolState(c,name)
        local v = c and c:FindFirstChild(name)
        return v and v:IsA("BoolValue") and v.Value==true
    end
    local function isTarget(m)
        local c,_,r = char()
        if not m or not m.Parent or not m:IsA("Model") or m==c or not r then return false end
        local h,p = m:FindFirstChildOfClass("Humanoid"),part(m)
        if not h or h.Health<=0 or not p then return false end
        if m:GetAttribute("Invulnerable")==true or m:GetAttribute("QuestNPC")==true then return false end
        local player = Players:GetPlayerFromCharacter(m)
        if player then return S.allowPlayers and player~=LP end
        if m.Name=="NPCQuest" or m.Name=="NPCQuest2" then return false end
        return true
    end
    local function groupMatches(m)
        if Players:GetPlayerFromCharacter(m) then return S.allowPlayers end
        if S.targetGroup=="All NPCs" then return true end
        if S.targetGroup=="Humans" then return m.Name=="Human" end
        if S.targetGroup=="Hunters" then return m.Name=="Hunter" end
        if S.targetGroup=="Guards" then return m:GetAttribute("GuardNPC")==true or m.Name:lower():find("guard",1,true)~=nil end
        return false
    end
    local function findTarget()
        local _,_,r = char()
        if not r then return nil end
        local best,dist = nil,S.searchRange
        local function consider(m)
            if isTarget(m) and groupMatches(m) and (S.targetName=="" or m.Name:lower():find(S.targetName:lower(),1,true)) then
                local d=(part(m).Position-r.Position).Magnitude
                if d<dist then best,dist=m,d end
            end
        end
        for m in pairs(C.npcs) do if m.Parent then consider(m) else C.npcs[m]=nil end end
        if S.allowPlayers then for _,p in ipairs(Players:GetPlayers()) do consider(p.Character) end end
        return best
    end
    local function target()
        if isTarget(S.target) then
            local _,_,r=char()
            if (part(S.target).Position-r.Position).Magnitude<=S.searchRange then return S.target end
        end
        S.target=findTarget()
        return S.target
    end
    local function face(m)
        local _,_,r=char();local p=part(m)
        if r and p then
            local to=Vector3.new(p.Position.X,r.Position.Y,p.Position.Z)
            if (to-r.Position).Magnitude>0.01 then r.CFrame=CFrame.lookAt(r.Position,to) end
        end
    end
    local function inRange(m,range)
        local _,_,r=char();local p=part(m)
        return r and p and (r.Position-p.Position).Magnitude<=range
    end
    local function equipFists()
        local c,h=char()
        if not c or not h then return false,"No character" end
        local tool=c:FindFirstChild("Fists") or (LP:FindFirstChild("Backpack") and LP.Backpack:FindFirstChild("Fists"))
        if not tool or not tool:IsA("Tool") then return false,"Fists tool not found" end
        if tool.Parent~=c then h:EquipTool(tool) return true,"Equipping; wait for animation" end
        return true
    end
    local function punch()
        local ok,reason=usable();if not ok then return false,reason end
        local m=target();if not m or not inRange(m,S.hitRange) then return false,"No target in hit range" end
        local c=LP.Character
        for _,n in ipairs({"IsBlocking","IsStunned","IsGuardBroken","IsAttacking","IsInClash"}) do if boolState(c,n) then return false,n end end
        if (tonumber(LP:GetAttribute("Stamina")) or 0)<15 then return false,"Stamina below 15" end
        if os.clock()-(C.lastPunch or -100)<S.attackDelay then return false,"Attack interval" end
        local t=c:FindFirstChild("Fists")
        if not t then equipFists() return false,"Equip Fists first" end
        if not t:IsA("Tool") or not t.Enabled then return false,"Tool unavailable" end
        if S.faceTarget then face(m) end
        C.lastPunch=os.clock()
        -- Existing ArczisCombatController binds Fists.Activated, preserving its checks/animations.
        t:Activate()
        S.lastAction="Fists:Activate (native client controller)"
        return true
    end

    local vampireSkills = {
        BloodDrink={action="Bite",range=8,years=0,cd=8},
        BreakNeck={action="Break",range=8,years=5,cd=15},
        Infect={action="Infect",range=14,years=150,cd=8},
        HeartRipping={action="Attack",range=10,years=150,cd=90},
        Hypnosis={action="Select",range=10,years=20,cd=20},
    }
    local function castVampire(name)
        local d=vampireSkills[name];if not d then return false,"Unknown ability" end
        if not vampire() then return false,"Vampire team required" end
        if years()<d.years then return false,"Requires Years "..d.years end
        local ok,reason=usable();if not ok then return false,reason end
        if (C.cooldowns[name] or 0)>os.clock() then return false,"Local cooldown" end
        local m=target();if not m or not inRange(m,d.range) then return false,"Target must be within "..d.range.." studs" end
        if m:GetAttribute("ActionLocked") or m:GetAttribute("Hibernating") or m:GetAttribute("BreakNeckRecovering") then return false,"Target is locked" end
        if S.faceTarget then face(m) end
        local accepted,err=send(name,"Begin","UI")
        if not accepted then return false,err end
        C.cooldowns[name]=os.clock()+d.cd
        local token=S.token
        task.delay(0.06,function()
            if S.alive and S.token==token and isTarget(m) and inRange(m,d.range) then
                local sent,why=send(name,d.action,m,"UI")
                if not sent then log("ability error",why) end
            end
        end)
        return true
    end
    local witchSkills={
        WitchLifeDrain={years=0,cd=38},WitchBreakNeck={years=25,cd=15,mana=80},
        WitchHeartRipping={years=100,cd=90,mana=100},WitchPetrification={years=15,cd=25,mana=45},
        WitchInvisible={years=25,cd=25,action="Activate"},
    }
    local function castWitch(name)
        local d=witchSkills[name]
        if not d then return false,"Unknown witch ability" end
        if team()~="Witches" then return false,"Witches team required" end
        if years()<d.years then return false,"Requires Years "..d.years end
        local ok,reason=usable();if not ok then return false,reason end
        if (C.cooldowns[name] or 0)>os.clock() then return false,"Local cooldown" end
        local mana=tonumber(LP:GetAttribute("Mana"))
        if d.mana and mana and mana<d.mana then return false,"Not enough Mana" end
        local sent,err
        if d.action then sent,err=send(name,d.action) else sent,err=send(name) end
        if sent then C.cooldowns[name]=os.clock()+d.cd end
        return sent,err
    end
    local function pain()
        if team()~="Witches" or years()<140 then return false,"Witches / Years 140 required" end
        local ok,why=usable();if not ok then return false,why end
        if (C.cooldowns.Pain or 0)>os.clock() then return false,"Local cooldown" end
        local m=target();if not m or not inRange(m,40) then return false,"Target farther than 40 studs" end
        local sent,err=send("WitchPainInfliction","Begin",m)
        if sent then C.painOwned=true C.cooldowns.Pain=os.clock()+35 end
        return sent,err
    end
    local function stopPain()
        if C.painOwned then send("PainStop","Stop") C.painOwned=false end
    end
    local function toggleSleep()
        local c,_,r=char()
        if not c or not r then return false,"No character" end
        if c:GetAttribute("CeilingSleeping")==true then
            local ok,why=send("Sleep","Detach")
            if ok then C.sleepOwned=false end
            return ok,why
        end
        if not vampire() or years()<100 then return false,"Vampire / Years 100 required" end
        local ok,why=usable();if not ok then return false,why end
        local params=RaycastParams.new();params.FilterType=Enum.RaycastFilterType.Exclude;params.FilterDescendantsInstances={c}
        local hit=workspace:Raycast(r.Position,Vector3.new(0,14,0),params)
        if not hit or hit.Normal.Y>-0.55 then return false,"No suitable ceiling within 14 studs" end
        local sent,err=send("Sleep","Toggle",r.Position)
        if sent then C.sleepOwned=true end
        return sent,err
    end

    local function questBusy()
        return LP:GetAttribute("QuestActive")==true or LP:GetAttribute("Quest2Active")==true or LP:GetAttribute("HumanSideQuestActive")==true
    end
    local function nearestPaper()
        local _,_,r=char();if not r then return nil end
        local root=workspace:FindFirstChild("Quest2");if not root then return nil end
        local best,dist
        for _,o in ipairs(root:GetDescendants()) do
            if o:IsA("BasePart") and o:GetAttribute("Quest2Enabled")==true then
                local d=(o.Position-r.Position).Magnitude
                if not dist or d<dist then best,dist=o,d end
            end
        end
        return best,dist
    end
    local function acceptPaper()
        if questBusy() then return false,"Another quest is already active" end
        local o,d=nearestPaper();if not o then return false,"No loaded Quest2 offer" end
        if d>(tonumber(o:GetAttribute("Quest2Range")) or 11) then return false,"Move closer to the offer" end
        if years()<(tonumber(o:GetAttribute("Quest2MinLevel")) or 0) then return false,"Quest minimum level not reached" end
        local id=tostring(o:GetAttribute("Quest2OfferId") or "")
        if id=="" then return false,"Quest2OfferId missing" end
        if os.clock()-(C.lastPaper or -100)<5 then return false,"Waiting for quest state (5s)" end
        C.lastPaper=os.clock()
        return send("Quest2","Accept",o,id)
    end
    local function nearestPrompt()
        local _,_,r=char();if not r then return nil end
        local best,dist
        for p in pairs(C.prompts) do
            if not p.Parent then C.prompts[p]=nil
            elseif p.Enabled then
                local pt=part(p.Parent)
                if pt then local d=(pt.Position-r.Position).Magnitude if not dist or d<dist then best,dist=p,d end end
            end
        end
        return best,dist
    end
    local function usePrompt()
        local p,d=nearestPrompt()
        if not p then return false,"No enabled prompt found" end
        if d>p.MaxActivationDistance then return false,"Move within prompt activation range" end
        if C.holdingPrompt then return false,"A prompt is already held" end
        local token=S.token
        -- Preserve the prompt hold duration. No distance or Enabled modifications.
        p:InputHoldBegin();C.holdingPrompt=p
        task.delay(p.HoldDuration+0.1,function()
            pcall(function() p:InputHoldEnd() end)
            if C.holdingPrompt==p then C.holdingPrompt=nil end
            if S.alive and S.token==token then log("prompt","Input hold ended: "..p.Name) end
        end)
        return true
    end

    cancelTravel=function()
        if C.travel then pcall(function() C.travel:Cancel() end) C.travel=nil end
    end
    local function travelTo(p)
        local ok,why=usable();if not ok then note(why) return end
        if typeof(p)~="Vector3" then note("Destination unavailable / not streamed") return end
        local _,_,r=char();cancelTravel();S.autoWalk=false
        if C.toggleRefs.autoWalk then C.toggleRefs.autoWalk:Set(false,true) end
        local distance=(r.Position-p).Magnitude
        if distance>5000 then note("Destination too far for local tween; travel normally first") return end
        C.travel=Tween:Create(r,TweenInfo.new(math.max(distance/S.travelSpeed,0.15),Enum.EasingStyle.Linear),{CFrame=CFrame.new(p)})
        local active=C.travel
        local finished
        finished=active.Completed:Connect(function()
            if C.travel==active then C.travel=nil end
            if finished then finished:Disconnect() end
        end)
        C.connections[#C.connections+1]=finished
        active:Play();S.lastAction="Local travel tween (server may correct position)"
    end
    local landmarks={
        ["Quest NPC"]={"NPCQuest"},["Quest NPC 2"]={"NPCQuest2"},
        ["Delivery point"]={"Interativos","DeliveryPoint"},["Quest papers"]={"Quest2"},
        ["Hunter area"]={"HUNTERAREA"},["Humans"]={"Humans"},["Lockpick"]={"LOCKPICK"},
    }
    local function landmarkPart()
        if S.selectedLandmark=="Current target" then return part(target()) end
        if S.selectedLandmark=="Nearest prompt" then local p=nearestPrompt() return p and part(p.Parent) end
        if S.selectedLandmark=="Nearest quest paper" then return nearestPaper() end
        local o=at(workspace,landmarks[S.selectedLandmark] or {})
        return part(o) or (o and o:FindFirstChildWhichIsA("BasePart",true))
    end
    local function restoreCollision()
        for p,v in pairs(C.collision) do pcall(function() p.CanCollide=v end) C.collision[p]=nil end
    end
    local function restoreSpeed()
        if C.speedHum and C.speedHum.Parent then pcall(function() C.speedHum.WalkSpeed=C.originalSpeed end) end
        C.speedHum=nil;C.originalSpeed=nil
    end
    stopFly=function()
        if C.flight then
            pcall(function() C.flight.vel:Destroy() C.flight.gyro:Destroy() end)
            pcall(function() C.flight.hum.PlatformStand=C.flight.platform end)
            C.flight=nil
        end
    end
    local function flightStep()
        if not S.fly then stopFly() return end
        local _,h,r=char()
        if not h or not r or h.Health<=0 then stopFly() return end
        if not C.flight or C.flight.root~=r then
            stopFly();cancelTravel()
            local vel=Instance.new("BodyVelocity");vel.MaxForce=Vector3.new(1e6,1e6,1e6);vel.Velocity=Vector3.zero;vel.Parent=r
            local gyro=Instance.new("BodyGyro");gyro.MaxTorque=Vector3.new(1e6,1e6,1e6);gyro.P=20000;gyro.CFrame=r.CFrame;gyro.Parent=r
            C.flight={root=r,hum=h,vel=vel,gyro=gyro,platform=h.PlatformStand};h.PlatformStand=true
        end
        local cam=workspace.CurrentCamera;if not cam then return end
        local move=Vector3.zero
        if not Input:GetFocusedTextBox() then
            local function held(k) return Input:IsKeyDown(k) and 1 or 0 end
            local forward=held(Enum.KeyCode.W)-held(Enum.KeyCode.S)
            local right=held(Enum.KeyCode.D)-held(Enum.KeyCode.A)
            local up=held(Enum.KeyCode.Space)-held(Enum.KeyCode.LeftShift)
            move=cam.CFrame.LookVector*forward+cam.CFrame.RightVector*right+Vector3.new(0,up,0)
            if not Input.KeyboardEnabled then move=h.MoveDirection end
        end
        C.flight.vel.Velocity=move.Magnitude>0 and move.Unit*S.flySpeed or Vector3.zero
        C.flight.gyro.CFrame=cam.CFrame
    end
    local espFolder=Instance.new("Folder");espFolder.Name="NZL_Main_LocalVisuals";espFolder.Parent=workspace
    clearESP=function()
        for _,e in pairs(C.esp) do pcall(function() e.hl:Destroy() e.gui:Destroy() end) end
        C.esp={}
    end
    local function refreshESP()
        if not S.espNPC and not S.espPlayers then clearESP() return end
        local _,_,r=char();if not r then clearESP() return end
        local candidates={}
        local function add(m,color)
            local p=part(m);local h=m and m:FindFirstChildOfClass("Humanoid")
            if p and h and h.Health>0 then
                local d=(p.Position-r.Position).Magnitude
                if d<=S.espRange then candidates[#candidates+1]={model=m,root=p,hum=h,dist=d,color=color} end
            end
        end
        if S.espNPC then for m in pairs(C.npcs) do if m.Parent and not Players:GetPlayerFromCharacter(m) then add(m,Color3.fromRGB(255,195,100)) end end end
        if S.espPlayers then for _,p in ipairs(Players:GetPlayers()) do if p~=LP then add(p.Character,p.TeamColor.Color) end end end
        table.sort(candidates,function(a,b) return a.dist<b.dist end)
        local keep={}
        for i=1,math.min(28,#candidates) do
            local row=candidates[i];local m=row.model;keep[m]=true
            local e=C.esp[m]
            if not e then
                local hl=Instance.new("Highlight");hl.Adornee=m;hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop;hl.FillTransparency=0.8;hl.Parent=espFolder
                local gui=Instance.new("BillboardGui");gui.Size=UDim2.fromOffset(200,45);gui.StudsOffset=Vector3.new(0,3,0);gui.AlwaysOnTop=true;gui.Parent=espFolder
                local text=Instance.new("TextLabel");text.Size=UDim2.fromScale(1,1);text.BackgroundTransparency=1;text.Font=Enum.Font.Gotham;text.TextSize=12;text.TextStrokeTransparency=0.4;text.Parent=gui
                e={hl=hl,gui=gui,text=text};C.esp[m]=e
            end
            e.hl.FillColor=row.color;e.hl.OutlineColor=row.color;e.gui.Adornee=row.root;e.text.TextColor3=row.color
            e.text.Text=string.format("%s | %d studs\nHP %d / %d",m.Name,row.dist,row.hum.Health,row.hum.MaxHealth)
        end
        for m,e in pairs(C.esp) do if not keep[m] then e.hl:Destroy();e.gui:Destroy();C.esp[m]=nil end end
    end
    local function register(o)
        if o:IsA("Humanoid") and o.Parent and o.Parent:IsA("Model") then C.npcs[o.Parent]=true end
        if o:IsA("ProximityPrompt") then C.prompts[o]=true end
    end
    connect(workspace.DescendantAdded,register)
    connect(workspace.DescendantRemoving,function(o)
        if o:IsA("Model") then C.npcs[o]=nil end
        if o:IsA("ProximityPrompt") then C.prompts[o]=nil end
    end)
    task.spawn(function()
        for i,o in ipairs(workspace:GetDescendants()) do
            if not S.alive then break end
            register(o)
            if i%400==0 then task.wait() end
        end
    end)

    local shopDropdown
    local function refreshShop()
        C.shopCards={}
        local gui=LP:FindFirstChild("PlayerGui")
        local shop=gui and gui:FindFirstChild("DarkHazardItemShop")
        local items={}
        if shop then
            for _,o in ipairs(shop:GetDescendants()) do
                local name=o:GetAttribute("ShopItemName")
                if o:IsA("GuiObject") and type(name)=="string" and o:FindFirstChild("BuyButton") then
                    if not C.shopCards[name] then items[#items+1]=name C.shopCards[name]=o end
                end
            end
        end
        table.sort(items)
        if #items==0 then items={"No loaded shop cards"} end
        if shopDropdown then shopDropdown:Refresh(items);shopDropdown:Set(items[1],true) end
        S.selectedShop=items[1]
        return #items
    end
    local function purchase()
        local card=C.shopCards[S.selectedShop]
        if not card or not card.Parent then return false,"Refresh shop items first" end
        local button=card:FindFirstChild("BuyButton")
        if not button or button:GetAttribute("ShopAvailable")~=true then return false,"Native shop marks item unavailable" end
        local kind=card:GetAttribute("ShopKind")
        if kind=="Broom" then return send("Broom","Purchase") end
        if kind=="Hat" then return send("Shop","PurchaseHat") end
        if kind=="Cape" then return send("Shop","PurchaseCape") end
        return send("Shop","Purchase",card:GetAttribute("ShopItemName"))
    end
    local function watchRemotes()
        local function attach(remote)
            if not remote or not remote:IsA("RemoteEvent") or C.watched[remote] then return end
            C.watched[remote]=true
            connect(remote.OnClientEvent,function(...)
                local args=table.pack(...);local bits={}
                for i=1,math.min(args.n,4) do bits[#bits+1]=short(args[i],120) end
                S.lastReply=remote.Name..": "..table.concat(bits," | ");log("server reply",S.lastReply)
                if remote.Name=="HumanSideQuestRemote" and args[1]=="Offer" and S.autoOffer and team()=="Humans" and not questBusy() then
                    local token=S.token
                    task.delay(0.2,function() if S.alive and S.autoOffer and S.token==token and not questBusy() then send("HumanSideQuest","AcceptOffer") end end)
                end
            end)
        end
        for _,p in pairs(routes) do attach(at(RS,p)) end
        local events=at(RS,{"Funções","Eventos"})
        if events then
            for _,name in ipairs({"BreakNeckRemote","BloodDrinkRemote","InfectRemote","HeartRippingRemote","HypnosisRemote","WitchLifeDrainRemote","WitchBreakNeckRemote","WitchHeartRippingRemote","WitchPetrificationRemote","WitchInvisibleRemote","IncendiaRemote","MoneyRewardPopupRemote"}) do attach(events:FindFirstChild(name)) end
        end
    end
    local function syncToggles()
        for key,obj in pairs(C.toggleRefs) do pcall(function() obj:Set(S[key],true) end) end
    end
    stopAll=function(reason)
        S.token=S.token+1
        for _,key in ipairs({"autoM1","autoWalk","autoSkill","autoPaper","autoOffer","espNPC","espPlayers","noclip","speed","fly","infJump","faceTarget"}) do S[key]=false end
        cancelTravel();stopFly();restoreCollision();restoreSpeed();clearESP();stopPain()
        if C.blockOwned then C.remoteTimes.Block=nil;send("Block",false);C.blockOwned=false end
        if C.sleepOwned then C.remoteTimes.Sleep=nil;send("Sleep","Detach");C.sleepOwned=false end
        if C.holdingPrompt then pcall(function() C.holdingPrompt:InputHoldEnd() end) C.holdingPrompt=nil end
        local _,h,r=char();if h and r then pcall(function() h:MoveTo(r.Position) end) end
        S.target=nil;S.status="Stopped: "..(reason or "user");S.lastAction=S.status
        syncToggles();log("stop",S.status);C.stopCount=C.stopCount+1
    end
    unload=function()
        if not S.alive then return end
        stopAll("unload");S.alive=false
        for _,c in ipairs(C.connections) do pcall(function() c:Disconnect() end) end
        pcall(function() espFolder:Destroy() end)
        if Env.NZLMainHub and Env.NZLMainHub.State==S then Env.NZLMainHub=nil end
    end
    Env.NZLMainHub={Stop=unload,State=S}
    local oldUnload=Lumen.Unload
    function Lumen:Unload() unload() return oldUnload(self) end
    connect(LP.CharacterRemoving,function() stopAll("respawn") end)
    connect(LP:GetPropertyChangedSignal("Team"),function() stopAll("team change") end)
    connect(Input.InputBegan,function(input,processed)
        if not processed and input.KeyCode==Enum.KeyCode.End then stopAll("End key") note("All hub actions stopped") end
    end)
    connect(Input.JumpRequest,function()
        if S.infJump then local _,h=char();if h and h.Health>0 then h:ChangeState(Enum.HumanoidStateType.Jumping) end end
    end)
    local accumulator=0
    connect(Run.Heartbeat,function(dt)
        flightStep()
        accumulator=accumulator+dt;if accumulator<0.1 then return end;accumulator=0
        local c,h=char()
        if S.noclip and c then
            for _,p in ipairs(c:GetDescendants()) do
                if p:IsA("BasePart") then if C.collision[p]==nil then C.collision[p]=p.CanCollide end p.CanCollide=false end
            end
        elseif next(C.collision) then restoreCollision() end
        if S.speed and h then
            if C.speedHum~=h then restoreSpeed();C.speedHum=h;C.originalSpeed=h.WalkSpeed end
            h.WalkSpeed=S.walkSpeed
        elseif C.speedHum then restoreSpeed() end
    end)

    local function attrs(o)
        local t={};if not o then return t end
        for k,v in pairs(o:GetAttributes()) do t[k]=(type(v)=="string" or type(v)=="number" or type(v)=="boolean") and v or tostring(v) end
        return t
    end
    local function report()
        local c=LP.Character;local available={}
        for k,p in pairs(routes) do local o=at(RS,p);available[k]=o and o.ClassName or "missing" end
        local flags={};for k,v in pairs(S) do if type(v)=="boolean" or type(v)=="number" or type(v)=="string" then flags[k]=v end end
        return Http:JSONEncode({format="NZL Main Hub 1.0",placeId=game.PlaceId,placeVersion=game.PlaceVersion,
            timeUTC=os.date("!%Y-%m-%dT%H:%M:%SZ"),team=team(),playerAttributes=attrs(LP),characterAttributes=attrs(c),
            target=S.target and S.target:GetFullName() or "none",routes=available,state=flags,log=C.logs,
            warning="Local report. Requests sent do not imply server acceptance. Review before sharing."})
    end
    local copyFrame
    local function manualCopy(text)
        if copyFrame then copyFrame:Destroy() end
        local f=Instance.new("Frame");copyFrame=f;f.Size=UDim2.fromScale(0.85,0.65);f.Position=UDim2.fromScale(0.075,0.15);f.BackgroundColor3=Color3.fromRGB(20,22,28);f.ZIndex=300;f.Parent=Lumen.State.Screen
        local b=Instance.new("TextBox");b.Size=UDim2.new(1,-20,1,-60);b.Position=UDim2.fromOffset(10,10);b.Text=text;b.ClearTextOnFocus=false;b.MultiLine=true;b.TextSize=12;b.Font=Enum.Font.Code;b.TextColor3=Color3.new(1,1,1);b.BackgroundColor3=Color3.fromRGB(12,14,18);b.TextXAlignment=Enum.TextXAlignment.Left;b.TextYAlignment=Enum.TextYAlignment.Top;b.ZIndex=301;b.Parent=f
        local close=Instance.new("TextButton");close.Size=UDim2.fromOffset(130,30);close.Position=UDim2.new(1,-140,1,-40);close.Text="Close";close.ZIndex=301;close.Parent=f
        connect(close.Activated,function() f:Destroy();copyFrame=nil end)
        local select=Instance.new("TextButton");select.Size=UDim2.fromOffset(180,30);select.Position=UDim2.new(0,10,1,-40);select.Text="Select all, then Ctrl+C";select.ZIndex=301;select.Parent=f
        connect(select.Activated,function() b:CaptureFocus();b.CursorPosition=#b.Text+1;b.SelectionStart=1 end)
    end
    local function copyReport()
        local text=report();local fn=setclipboard or toclipboard or (Clipboard and Clipboard.set)
        if type(fn)=="function" then local ok=pcall(fn,text);if ok then note("Diagnostic report sent to clipboard") return end end
        manualCopy(text)
    end

    Lumen.Folder="nzl_main_hub";Lumen.ConfigFolder=Lumen.Folder.."/configs";Lumen.ThemeFolder=Lumen.Folder.."/themes"
    local window=Lumen:Window({Name="NZL Main | Dark Hazard",Version="1.0 / dump 2812",Footer="RightCtrl menu | End STOP | all automation OFF",Size=UDim2.fromOffset(840,610),Keybind=Enum.KeyCode.RightControl,SettingsPage=false})
    local function page(name,group) return window:Page({Name=name,Columns=2,Group=group}) end
    local function sec(p,name,side) return p:Section({Name=name,Side=side or 1}) end
    local function button(s,name,fn,confirm)
        return s:Button({Name=name,Confirm=confirm or false,Callback=function()
            local ok,err=pcall(fn);if not ok then log("button error",err);note("Action error: "..short(err,160)) end
        end})
    end
    local function toggle(s,name,key,callback)
        local obj=s:Toggle({Name=name,Flag="dh_"..key,Default=false,Callback=function(v)
            S[key]=v==true
            if callback then callback(S[key]) end
        end})
        C.toggleRefs[key]=obj;return obj
    end
    local function slider(s,name,key,min,max,default,decimals)
        s:Slider({Name=name,Flag="dh_"..key,Min=min,Max=max,Default=default,Decimals=decimals or 0,Callback=function(v) S[key]=v end})
    end
    local home=page("dashboard","main")
    local stateSec=sec(home,"live status")
    statusLabel=stateSec:Label("Ready; reading game state...")
    resourceLabel=stateSec:Label("Resources: -")
    targetLabel=stateSec:Label("Target: none")
    actionLabel=stateSec:Label("Last action: idle")
    replyLabel=stateSec:Label("Server: no reply")
    button(stateSec,"STOP ALL (End)",function() stopAll("button");note("All hub actions stopped") end)
    button(stateSec,"Unload hub",function() Lumen:Unload() end,true)
    local info=sec(home,"read first",2)
    info:Label("For place 122287678911982, dump version 2812.")
    info:Label("All loops start OFF. No config autoload.")
    info:Label("M1 uses the native Fists tool controller.")
    info:Label("Requests are NOT proof of server acceptance.")
    info:Label("Move/flight may be corrected by the server.")
    info:Label("Respawn or team change stops all automation.")
    info:Label("No admin, currency or level remotes used.")

    local combat=page("combat / farm","main")
    local targeting=sec(combat,"target selection")
    targeting:Dropdown({Name="NPC group",Items={"Hunters","Humans","Guards","All NPCs"},Default="Hunters",Flag="dh_group",Callback=function(v) S.targetGroup=v;S.target=nil end})
    targeting:Textbox({Name="Name contains",Default="",Flag="dh_name",Callback=function(v) S.targetName=tostring(v);S.target=nil end})
    slider(targeting,"Search radius", "searchRange",10,1000,120)
    toggle(targeting,"Include player targets (opt-in)","allowPlayers",function() S.target=nil end)
    button(targeting,"Select nearest valid target",function() S.target=findTarget();note(S.target and ("Target: "..S.target.Name) or "No loaded target in range") end)
    toggle(targeting,"Face target when attacking","faceTarget")
    local farm=sec(combat,"native combat",2)
    button(farm,"Equip Fists",function() local ok,why=equipFists();note(ok and (why or "Fists equipped") or why) end)
    button(farm,"M1 once",function() local ok,why=punch();note(ok and "Fists activated" or why) end)
    toggle(farm,"Auto M1","autoM1")
    toggle(farm,"Walk toward current target","autoWalk",function(v) if v then cancelTravel() end end)
    slider(farm,"Attack interval (seconds)","attackDelay",0.6,2,0.65,2)
    slider(farm,"M1 activation distance","hitRange",3,8,7)
    button(farm,"Block ON",function() local ok,why=send("Block",true);if ok then C.blockOwned=true end tell(ok,why) end)
    button(farm,"Block OFF",function() C.blockOwned=false;tell(send("Block",false)) end)
    farm:Label("Walking is MoveTo, not obstacle pathfinding.")
    farm:Label("Native cooldown/stamina/state checks still apply.")

    local powers=page("abilities","main")
    local vamp=sec(powers,"vampire")
    vamp:Dropdown({Name="Ability",Items={"BloodDrink","BreakNeck","Infect","HeartRipping","Hypnosis"},Default="BloodDrink",Flag="dh_skill",Callback=function(v) S.vampireSkill=v end})
    skillLabel=vamp:Label("Ability ready (local cooldown estimate)")
    button(vamp,"Cast selected on current target",function() tell(castVampire(S.vampireSkill)) end)
    toggle(vamp,"Auto selected ability","autoSkill")
    button(vamp,"Track (native request)",function()
        if not vampire() then note("Vampire team required") return end
        if (C.cooldowns.Track or 0)>os.clock() then note("Local cooldown") return end
        local ok,why=send("Track","UI");if ok then C.cooldowns.Track=os.clock()+23 end;tell(ok,why)
    end)
    button(vamp,"Ceiling sleep / detach",function() tell(toggleSleep()) end)
    button(vamp,"End hypnosis control",function() tell(send("HypnosisEnd","EndControl")) end)
    vamp:Label("BatForm omitted: Enabled=false in dumped config.")
    vamp:Label("Hypnosis selection uses the game's command UI.")
    local witch=sec(powers,"witch (native targeting)",2)
    for _,entry in ipairs({{"Life Drain","WitchLifeDrain"},{"Break Neck","WitchBreakNeck"},{"Heart Ripping","WitchHeartRipping"},{"Petrification","WitchPetrification"},{"Invisibility","WitchInvisible"}}) do
        local key=entry[2];button(witch,entry[1],function() tell(castWitch(key)) end)
    end
    button(witch,"Pain Infliction on current target",function() tell(pain()) end)
    button(witch,"Stop Pain Infliction",function() stopPain();note("Stop requested if started by hub") end)
    button(witch,"Strength: begin native selection",function()
        if team()~="Witches" or years()<25 then note("Witches / Years 25 required") return end
        local ok,why=usable();if not ok then note(why) return end
        tell(send("Strength","Begin"))
    end)
    witch:Label("Strength: select target in native UI afterwards.")
    witch:Label("Incendia: use native aim UI; no guessed payload.")

    local quests=page("quests","main")
    local q=sec(quests,"quest state / interaction")
    questLabel=q:Label("Quest state: -");questDetailLabel=q:Label("Progress: -")
    button(q,"Activate nearest enabled prompt",function() tell(usePrompt()) end)
    button(q,"Accept nearest Quest2 offer",function() tell(acceptPaper()) end)
    toggle(q,"Auto accept nearby Quest2 offer","autoPaper")
    toggle(q,"Auto accept incoming Human offer","autoOffer")
    q:Label("Offers must be loaded and in native range.")
    q:Label("No fake progress or reward-completion requests.")
    local dialog=sec(quests,"native dialogue choices",2)
    button(dialog,"Quest: choose kill",function() tell(send("Quest","ChooseKill")) end)
    button(dialog,"Quest: choose delivery",function() tell(send("Quest","ChooseDelivery")) end)
    button(dialog,"Hunter: choose kill",function() tell(send("HunterQuest","ChooseKill")) end)
    button(dialog,"Hunter: choose delivery",function() tell(send("HunterQuest","ChooseDelivery")) end)
    button(dialog,"Human: accept offer",function() tell(send("HumanSideQuest","AcceptOffer")) end)
    button(dialog,"Human: decline offer",function() tell(send("HumanSideQuest","DeclineOffer")) end)
    dialog:Label("Talk to the corresponding NPC first.")
    dialog:Label("Delivery/flowers still use game interactions.")

    local visual=page("ESP","utilities")
    local vs=sec(visual,"local visuals")
    toggle(vs,"NPC ESP","espNPC")
    toggle(vs,"Player ESP","espPlayers")
    slider(vs,"ESP distance","espRange",50,3000,500)
    button(vs,"Clear ESP",function() S.espNPC=false;S.espPlayers=false;syncToggles();clearESP() end)
    local vi=sec(visual,"limits",2)
    vi:Label("Highlight + name / HP / distance.")
    vi:Label("28 nearest entities, refreshed every second.")
    vi:Label("Only streamed, client-visible entities exist.")
    vi:Label("No CoreGui/Drawing dependency.")

    local movement=page("movement","utilities")
    local ms=sec(movement,"local movement")
    toggle(ms,"WalkSpeed override","speed",function(v) if not v then restoreSpeed() end end)
    slider(ms,"WalkSpeed","walkSpeed",16,100,28)
    toggle(ms,"Noclip","noclip",function(v) if not v then restoreCollision() end end)
    toggle(ms,"Infinite jump","infJump")
    toggle(ms,"Fly (WASD / Space / Shift)","fly",function(v) if not v then stopFly() else cancelTravel() end end)
    slider(ms,"Fly speed","flySpeed",10,150,45)
    ms:Label("Mobile fly uses the movement stick; no vertical UI.")
    local travel=sec(movement,"loaded landmarks",2)
    travel:Dropdown({Name="Destination",Items={"Quest NPC","Quest NPC 2","Delivery point","Quest papers","Hunter area","Humans","Lockpick","Current target","Nearest prompt","Nearest quest paper"},Default="Quest NPC",Flag="dh_landmark",Callback=function(v) S.selectedLandmark=v end})
    slider(travel,"Tween travel speed","travelSpeed",10,150,45)
    button(travel,"Travel (local tween, experimental)",function()
        if S.fly then note("Disable Fly first") return end
        local p=landmarkPart();if not p then note("Destination not loaded") return end
        travelTo(p.Position+Vector3.new(0,3,4))
    end)
    button(travel,"Cancel travel",cancelTravel)
    travel:Label("No fixed-map coordinates are fabricated.")
    travel:Label("Server may reject or correct movement.")

    local shop=page("shop / inventory","utilities")
    local ss=sec(shop,"native shop cards")
    shopDropdown=ss:Dropdown({Name="Item",Items={"Refresh items first"},Default="Refresh items first",Flag="dh_shop",Callback=function(v) S.selectedShop=v end})
    button(ss,"Refresh loaded shop items",function() refreshShop();note("Loaded native shop cards refreshed") end)
    button(ss,"BUY selected (spends game currency)",function() tell(purchase()) end,true)
    ss:Label("Requires ShopAvailable=true in native UI.")
    ss:Label("No automatic purchases; no guessed prices.")
    local inv=sec(shop,"inventory",2)
    button(inv,"List current tools",function()
        local names={};local c=LP.Character
        for _,root in pairs({backpack=LP:FindFirstChild("Backpack"),character=c}) do
            if root then for _,o in ipairs(root:GetChildren()) do if o:IsA("Tool") then names[#names+1]=o.Name end end end
        end
        note(#names>0 and table.concat(names,", ") or "No tools loaded")
    end)
    button(inv,"Unequip tools",function() local _,h=char();if h then h:UnequipTools() end end)
    inv:Label("Purchases may need NPC proximity / money.")
    inv:Label("Sent is not the same as purchased.")

    local debugPage=page("diagnostics","system")
    local ds=sec(debugPage,"report / lifecycle")
    button(ds,"COPY diagnostic report",copyReport)
    button(ds,"Save diagnostic JSON",function()
        if type(writefile)~="function" then note("writefile unavailable; use Copy") return end
        local name="NZL_Main_"..os.date("!%Y%m%d_%H%M%S")..".json"
        writefile(name,report());note("Saved: "..name)
    end)
    button(ds,"Clear log",function() C.logs={};note("Log cleared") end)
    button(ds,"Refresh remote listeners",function() watchRemotes();note("Available remotes checked") end)
    button(ds,"STOP ALL",function() stopAll("diagnostic stop") end)
    local limits=sec(debugPage,"known limits",2)
    limits:Label("Integration based on dump, not live-tested here.")
    limits:Label("Cooldown estimates are local and conservative.")
    limits:Label("No server code or server bypass is included.")
    limits:Label("Two witch UI dumps had decompiler errors.")
    limits:Label("No module require / external download used.")
    limits:Label("Reports may contain private attributes/logs.")

    task.spawn(function()
        local tick=0
        while S.alive do
            task.wait(0.2)
            if not S.alive then break end
            local ok,err=pcall(function()
                tick=tick+1
                if S.autoM1 or S.autoWalk or S.autoSkill then
                    local m=target()
                    if m then
                        if S.autoWalk and not S.fly and not C.travel then
                            local good=usable();local _,h,r=char();local p=part(m)
                            if good and h and r and p and (p.Position-r.Position).Magnitude>4.5 and tick%3==0 then
                                local away=r.Position-p.Position
                                local goal=p.Position+(away.Magnitude>0 and away.Unit*4 or Vector3.new(0,0,4))
                                h:MoveTo(goal)
                            end
                        end
                        if S.autoM1 then local sent,why=punch();S.status=sent and "M1 activated" or why end
                        if S.autoSkill and tick%5==0 then local sent,why=castVampire(S.vampireSkill);S.status=sent and "Ability requested" or why end
                    else S.status="No loaded target matching filters" end
                end
                if S.autoPaper and tick%10==0 then local sent,why=acceptPaper();S.status=sent and "Quest acceptance requested" or why end
                if tick%5==0 then
                    refreshESP()
                    local c,h,r=char();local m=S.target;local p=part(m)
                    statusLabel:SetText("Team: "..team().." | Years: "..years().." | "..short(S.status,45))
                    resourceLabel:SetText("HP "..(h and math.floor(h.Health) or "-").." | Stamina "..tostring(LP:GetAttribute("Stamina") or "-").." | Mana "..tostring(LP:GetAttribute("Mana") or "-").." | Blood "..tostring(LP:GetAttribute("BloodThirst") or "-"))
                    targetLabel:SetText(m and p and r and ("Target: "..m.Name.." | "..math.floor((p.Position-r.Position).Magnitude).." studs") or "Target: none")
                    actionLabel:SetText(short(S.lastAction,85));replyLabel:SetText(short(S.lastReply,85))
                    questLabel:SetText("Quest: "..tostring(LP:GetAttribute("QuestActive") or false).." | Quest2: "..tostring(LP:GetAttribute("Quest2Active") or false).." | Human: "..tostring(LP:GetAttribute("HumanSideQuestActive") or false))
                    questDetailLabel:SetText(short(LP:GetAttribute("Quest2Title") or LP:GetAttribute("HumanSideQuestStage") or "No Quest2/Human state",45).." | "..tostring(LP:GetAttribute("Quest2Progress") or "-").."/"..tostring(LP:GetAttribute("Quest2Required") or "-"))
                    skillLabel:SetText(S.vampireSkill.." | local cooldown "..math.ceil(math.max(0,(C.cooldowns[S.vampireSkill] or 0)-os.clock())).."s")
                end
                if tick%25==0 then watchRemotes() end
            end)
            if not ok then
                log("loop error",err);stopAll("loop error");note("Automation stopped; copy diagnostics: "..short(err,120))
            end
        end
    end)
    watchRemotes()
    note("Main Hub ready. All automation OFF. RightCtrl: menu. End: STOP.")
end
StartMainHub(Lumen)

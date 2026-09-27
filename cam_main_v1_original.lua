-- CAM Main Hub 1.0 | source-backed client integration for place 136406881576517.
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
    local S={alive=true, farm=false, attack=false, skills=false, autoHunt=false,
        loot=false,chest=false,fly=false,noclip=false,speed=false,jump=false,run=false,shift=false,instant=false,
        esp=false,players=false,mobs=false,bosses=false,npcs=false,chests=false,drops=false,muzan=false,lily=false,levers=false,horses=false,
        box=false,fill=false,box3d=false,names=false,distance=false,health=false,hpbar=false,tracer=false,
        notifyBoss=false,notifyMuzan=false,notifyHunts=false,
        targetName="",targetKind="Mob",searchRange=180,hitRange=6,standOff=4,skillRange=35,
        attackDelay=0.5,skillDelay=3,skillHold=0.2,healthStop=25,
        walkSpeed=26,jumpHeight=12,flySpeed=45,espRange=600,espLimit=40,
        priority="Combat first",destinationType="Zone",destination="",huntId="",status="Ready - automation OFF",
        skillSlots={},epoch=0}
    local C={connections={},toggles={},logs={},modules={},loading={},loaderTasks={},owned={},tickets={},
        collision=setmetatable({}, {__mode="k"}),holds=setmetatable({}, {__mode="k"}),
        humanoids={},objects={},prompts={},esp={},cooldowns={},huntSent={},huntSeen={},
        skillIndex=0,seen=setmetatable({}, {__mode="k"}),count=0,indexing=true,visualClock=0}
    local stopAll,clearESP,refreshTargets,refreshDestinations,refreshHunts
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
        releaseAll();endFly();stopWalk();restoreMovement();restorePrompts();restoreShift()
        S.target=nil;S.skillSlots={};C.flyUp=false;C.flyDown=false;C.cooldowns={};C.huntSent={};C.attackAt=nil;C.skillAt=nil
        if clearESP then clearESP() end
        S.status=reason or "Stopped";log("stop",S.status)
    end
    local function isPlayer(m) return m==LP.Character or Players:GetPlayerFromCharacter(m)~=nil end
    local function kindOfNPC(m)
        if isPlayer(m) then return "Player" end
        if CS:HasTag(m,"GauntletStatue") or CS:HasTag(m,"Dialogue") or CS:HasTag(m,"HiddenNpc") or m:FindFirstChildWhichIsA("ProximityPrompt",true) then return "NPC" end
        if bossNames[m.Name] then return "Boss" end
        return "Mob" -- candidate only; exact name selection required before any attack
    end
    local function validTarget(m,kind,name)
        if not live(m) or isPlayer(m) then return false end
        local h=m:FindFirstChildOfClass("Humanoid")
        if not h or h.Health<=0 or not part(m) then return false end
        local k=kindOfNPC(m)
        if k=="NPC" or k=="Player" then return false end
        if name==nil or name=="" or m.Name~=name then return false end
        return kind==nil or k==kind
    end
    local function target()
        local _,_,r=char();if not r then return nil end
        local best,dist=nil,S.searchRange
        for m in pairs(C.humanoids) do
            if validTarget(m,S.targetKind,S.targetName) then
                local d=(part(m).Position-r.Position).Magnitude
                if d<dist then best=m;dist=d end
            end
        end
        S.target=best;return best,dist
    end
    local function face(m)
        local _,_,r=char();local p=part(m)
        if r and p then
            local goal=Vector3.new(p.Position.X,r.Position.Y,p.Position.Z)
            if (goal-r.Position).Magnitude>0.1 then r.CFrame=CFrame.lookAt(r.Position,goal) end
        end
    end
    local function attackOnce()
        local m,d=target();if not m then return false,"Select a loaded non-player NPC name" end
        if d>S.hitRange then return false,"Target outside M1 range" end
        if C.attackAt and os.clock()-C.attackAt<S.attackDelay then return false,"M1 pacing" end
        face(m);C.attackAt=os.clock();return press("Combat",0.12)
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
        flag("farm",false);flag("attack",false);flag("skills",false);flag("fly",false)
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
        if not ok then releaseAll();endPrompt();stopWalk();S.status=why;return end
        local _,h,r=char()
        if h.Health/math.max(h.MaxHealth,1)*100<=S.healthStop then
            if S.farm or S.attack or S.skills or S.loot or S.chest or S.autoHunt or S.run or S.fly then stopAll("Low HP: stopped, no automatic restart") end
            return
        end
        if S.fly then releaseAll();stopWalk();S.status="Fly has movement priority";return end
        if S.farm or S.attack or S.skills or S.run then
            local native=C.modules.Input
            if not native or type(native.VirtualPress)~="function" or type(native.VirtualRelease)~="function" or type(native.IsDown)~="function" then
                releaseAll();stopWalk();S.status="Connect native controls first (InputHandler unavailable)";return
            end
        end
        if S.run then if not C.owned.Run then press("Run") end else release("Run") end
        if C.activePrompt then
            if not withinPrompt(C.activePrompt) then endPrompt() else release("Combat");stopWalk();S.status="Holding native prompt";return end
        end
        if S.priority=="Loot first" and (S.loot or S.chest) then local done,msg=nearbyLoot();if done then S.status=msg;stopWalk();return end end
        local m,dist=target()
        if (S.farm or S.attack or S.skills) and m then
            if S.farm and dist>S.standOff+1 then
                local away=r.Position-part(m).Position
                h:MoveTo(part(m).Position+(away.Magnitude>0.1 and away.Unit*S.standOff or Vector3.new(0,0,S.standOff)))
                C.walking=true
                if not C.walkStart then C.walkStart=os.clock();C.walkPos=r.Position end
                if os.clock()-C.walkStart>8 then
                    if (r.Position-C.walkPos).Magnitude<2 then stopAll("Farm movement blocked; choose another position") return end
                    C.walkStart=os.clock();C.walkPos=r.Position
                end
            else stopWalk() end
            if S.farm or S.attack then local sent,msg=attackOnce();S.status=msg;if not sent and dist>S.hitRange then release("Combat") end end
            if S.skills then local sent,msg=skillOnce();if sent or not (S.farm or S.attack) then S.status=msg end end
        else
            release("Combat");stopWalk()
            if S.farm or S.attack or S.skills then S.status="No loaded target with selected name / type" end
        end
        if (S.loot or S.chest) and (not m or not (S.farm or S.attack or S.skills)) then local _,msg=nearbyLoot();S.status=msg end
        if S.autoHunt and not C.activePrompt and not (S.farm or S.attack or S.skills) and (C.huntCheck or 0)<=os.clock() then
            C.huntCheck=os.clock()+5;local _,msg=claimHunt();S.status=msg
        end
    end
    local function snapshot()
        local state={};for k,v in pairs(S) do if type(v)=="number" or type(v)=="string" or type(v)=="boolean" then state[k]=v end end
        local modules={};for k in pairs(modulePaths) do modules[k]=C.modules[k] and "ready" or C.loading[k] or "not connected" end
        local m=S.target
        return {format="CAM Main Hub 1.0",timeUTC=os.date("!%Y-%m-%dT%H:%M:%SZ"),placeId=game.PlaceId,placeVersion=game.PlaceVersion,
            state=state,modules=modules,log=C.logs,target=m and m:GetFullName() or "none",ownership=ownership(m),
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
    Env.CAMMainHub={State=S,Stop=function() Lumen:Unload() end,Snapshot=snapshot,Version="1.0"}
    Lumen.Folder="cam_main_hub";Lumen.ConfigFolder=Lumen.Folder.."/configs";Lumen.ThemeFolder=Lumen.Folder.."/themes"
    local window=Lumen:Window({Name="CAM MAIN | Source-backed",Version="1.0 / place 5354",Footer="RightCtrl menu | End STOP | No server bypass claims",Size=UDim2.fromOffset(900,660),Keybind=Enum.KeyCode.RightControl,SettingsPage=false})
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
    limits:Label("Native modules are loaded only after Connect.")
    limits:Label("Wrong place: gameplay controls locked.")
    limits:Label("NPC targeting requires an exact selected name.")
    limits:Label("Other players are never farm targets.")
    limits:Label("No purchases, skill-point spending or race change.")
    limits:Label("Native checks and server validation still apply.")
    limits:Label("No real-client test performed by the author.")
    local fight=page("farm / combat","gameplay")
    local fs=section(fight,"selected NPC only")
    fs:Dropdown({Name="Target type",Items={"Mob","Boss"},Default="Mob",Flag="cam_kind",Callback=function(v) S.targetKind=v;S.targetName="";release("Combat");if refreshTargets then refreshTargets() end end})
    targetDrop=fs:Dropdown({Name="Exact NPC name",Items={"Refresh targets"},Default="Refresh targets",Flag="cam_target",Callback=function(v) S.targetName=v=="No loaded targets" and "" or v;release("Combat") end})
    refreshTargets=function()
        local set={};for m in pairs(C.humanoids) do if live(m) and not isPlayer(m) and kindOfNPC(m)==S.targetKind then set[m.Name]=true end end
        local names={};for n in pairs(set) do names[#names+1]=n end;table.sort(names)
        targetDrop:Refresh(#names>0 and names or {"No loaded targets"})
        if set[S.targetName] then targetDrop:Set(S.targetName,true) else S.targetName="" end
        return #names
    end
    button(fs,"Refresh loaded targets",function() note("Names loaded: "..refreshTargets()..". Select explicitly.") end)
    toggle(fs,"Auto Farm selected NPC (MoveTo + M1)","farm",function(v) if v then flag("fly",false);endFly() else stopWalk();release("Combat") end end)
    toggle(fs,"Auto M1 (no movement)","attack",function(v) if not v and not S.farm then release("Combat") end end)
    toggle(fs,"Auto Skills (selected input slots)","skills",function(v) if not v then for _,a in ipairs(skillActions) do release(a) end end end)
    button(fs,"M1 once",function() tell(attackOnce()) end)
    slider(fs,"Search range","searchRange",10,600);slider(fs,"M1 range","hitRange",3,10);slider(fs,"Stand-off distance","standOff",2,8)
    slider(fs,"M1 interval (seconds)","attackDelay",0.25,3);slider(fs,"STOP at HP percent","healthStop",5,80)
    fs:Label("Boss mode uses names from the supplied hunt/assets data.")
    fs:Label("MoveTo is direct walking, not a pathfinding bot.")
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
    qs:Label("Generic Auto Level / Auto Quest is not implemented.")
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
    toggle(ms,"Fly (WASD / Space / LeftCtrl)","fly",function(v) if v then flag("farm",false);stopWalk();releaseAll();endPrompt() else endFly() end end)
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
    local dp=page("diagnostics / roadmap","system")
    local ds=section(dp,"local report")
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
    for _,text in ipairs({"Auto Level / full Auto Quest / Delivery loop","Queues / Ranked / Fill / Join World","Waves / cards / Bare Hands / forced heal cards","Bring Enemies / Instant Kill / cache guard bypass","Breathing unlock / skill-tree spending / training bot","Fishing / bait / EXP / purchases / best equipment","Auto Potion / Auto Parry / claim souls / schematics","Become Demon / redeem codes / set spawn crystal","Infinite stamina / climb / horse stamina","No drown / stun / ragdoll / sun / dash cooldown","No attack slowdown / external webhook reports","Restock / marketer / Final Selection notifications"}) do pending:Label(text) end
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
        moveStep()
        elapsed=elapsed+dt;uiTime=uiTime+dt;C.visualClock=C.visualClock+dt
        if C.visualClock>=0.08 then C.visualClock=0;renderESP() end
        if elapsed>=0.2 then elapsed=0;scheduler() end
        if uiTime>=1 then
            uiTime=0;tick=tick+1
            local _,h=char();local m=S.target;local n=0;for _ in pairs(C.objects) do n=n+1 end
            statusLabel:SetText(short(S.status,95));indexLabel:SetText((C.indexing and "Indexing... " or "Loaded index: ")..n.." objects")
            local ready=0;for _ in pairs(C.modules) do ready=ready+1 end
            nativeLabel:SetText("Native modules ready: "..ready.."/6 (Connect / report for details)")
            targetLabel:SetText(m and "Target: "..m.Name or "Target: none")
            local v=values();local stamina=v and v:FindFirstChild("Stamina")
            resourceLabel:SetText("HP "..(h and math.floor(h.Health) or "-").." | Stamina "..(stamina and tostring(stamina.Value) or "-"))
            local d=data();local holder=d and at(d,{"Quests","Holder"});local names={}
            if holder then for _,q in ipairs(holder:GetChildren()) do names[#names+1]=q.Name end end
            questLabel:SetText("Active quests: "..(#names>0 and table.concat(names,", ") or "none / not loaded"))
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
    note("CAM Main ready. Connect native controls, then choose features. RightCtrl: menu. End: STOP.")
end
StartCAMHub(Lumen)

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local UserInputService = game:GetService("UserInputService");

return {
    Start = function(u1) -- Line: 10, Name: Start
        -- upvalues: Players (copy), ReplicatedStorage (copy), UserInputService (copy), TweenService (copy)
        local LocalPlayer = Players.LocalPlayer;
        local Humanoid = u1:WaitForChild("Humanoid");
        local Animator = Humanoid:WaitForChild("Animator");
        local HumanoidRootPart = u1:WaitForChild("HumanoidRootPart");
        local v2 = ReplicatedStorage:WaitForChild("Funções");
        local SprintRequest = v2:WaitForChild("Eventos"):WaitForChild("SprintRequest");
        local SprintConfig = require(v2:WaitForChild("SprintConfig"));
        local v3 = ReplicatedStorage:WaitForChild("Animações");
        local CharacterAnimations = require(v3:WaitForChild("CharacterAnimations"));
        local u4 = {};
        local u5 = false;
        local u6 = nil;
        local u7 = nil;
        local u8 = nil;
        local u9 = nil;
        local u10 = nil;
        local u11 = 0;

        local function connect(p12, p13) -- Line: 31
            -- upvalues: u4 (copy)
            local v14 = p12:Connect(p13);
            table.insert(u4, v14);

            return v14;
        end;

        local function isConfigured(p15) -- Line: 37
            if type(p15) ~= "string" then
                return false;
            end;

            local v16 = tonumber(string.match(p15, "%d+"));
            local v17;

            if v16 == nil then
                v17 = false;
            else
                v17 = v16 > 0;
            end;

            return v17;
        end;

        local function stopRunAnimation(p18) -- Line: 46
            -- upvalues: u9 (ref)
            if u9 and u9.IsPlaying then
                u9:Stop(p18 or 0.12);
            end;
        end;

        local function loadRunAnimation() -- Line: 52
            -- upvalues: LocalPlayer (copy), CharacterAnimations (copy), u1 (copy), u10 (ref), u9 (ref), u8 (ref), Animator (copy)
            local v19 = LocalPlayer.Team and LocalPlayer.Team.Name or "Humans";
            local Run = CharacterAnimations.GetForTeam(v19).Run;
            local v20;

            if type(Run) == "string" then
                local v21 = tonumber(string.match(Run, "%d+"));

                if v21 == nil then
                    v20 = false;
                else
                    v20 = v21 > 0;
                end;
            else
                v20 = false;
            end;

            if not v20 then
                local Animate = u1:FindFirstChild("Animate");

                if Animate then
                    Animate = Animate:FindFirstChild("run");
                end;

                if Animate then
                    Animate = Animate:FindFirstChild("RunAnim");
                end;

                Run = Animate and Animate.AnimationId or nil;
            end;

            local v22;

            if type(Run) == "string" then
                local v23 = tonumber(string.match(Run, "%d+"));

                if v23 == nil then
                    v22 = false;
                else
                    v22 = v23 > 0;
                end;
            else
                v22 = false;
            end;

            if not v22 then
                warn("[SprintClient] Configure a animação Run para o time " .. v19);

                return;
            end;

            if Run == u10 and u9 then
                return;
            end;

            if u9 and u9.IsPlaying then
                u9:Stop(0);
            end;

            if u9 then
                local u24 = u9;
                task.delay(0.15, function() -- Line: 76
                    -- upvalues: u24 (copy)
                    pcall(function() -- Line: 76
                        -- upvalues: u24 (ref)
                        u24:Destroy();
                    end);
                end);
                u9 = nil;
            end;

            if u8 then
                local u25 = u8;
                task.delay(0.15, function() -- Line: 80
                    -- upvalues: u25 (copy)
                    pcall(function() -- Line: 80
                        -- upvalues: u25 (ref)
                        u25:Destroy();
                    end);
                end);
                u8 = nil;
            end;

            u8 = Instance.new("Animation");
            u8.Name = "TeamSprintAnimation";
            u8.AnimationId = Run;
            local success, result = pcall(function() -- Line: 88
                -- upvalues: Animator (ref), u8 (ref)
                return Animator:LoadAnimation(u8);
            end);

            if success then
                u9 = result;
                u9.Looped = true;
                u9.Priority = Enum.AnimationPriority.Action;
                u10 = Run;

                return;
            end;

            warn("[SprintClient] Não foi possível carregar a animação de corrida: " .. tostring(result));
            local u26 = u8;
            task.delay(0.15, function() -- Line: 94
                -- upvalues: u26 (copy)
                pcall(function() -- Line: 94
                    -- upvalues: u26 (ref)
                    u26:Destroy();
                end);
            end);
            u8 = nil;
            u10 = nil;
        end;

        local function isGroundedRunning() -- Line: 106
            -- upvalues: Humanoid (copy)
            local State = Humanoid:GetState();

            return State == Enum.HumanoidStateType.Running and true or State == Enum.HumanoidStateType.RunningNoPhysics;
        end;

        local u27 = nil;

        local function updateRunAnimation() -- Line: 114
            -- upvalues: u5 (ref), UserInputService (ref), u27 (ref), Humanoid (copy), LocalPlayer (copy), u1 (copy), u9 (ref), loadRunAnimation (copy)
            if u5 then
                return;
            end;

            local v28 = (UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or (UserInputService:IsKeyDown(Enum.KeyCode.RightShift) or UserInputService:IsKeyDown(Enum.KeyCode.ButtonL3))) and u27 and u27();
            local v29 = Humanoid.MoveDirection.Magnitude > 0.05;

            if LocalPlayer:GetAttribute("IsSprinting") == true or v28 then
                if u1:GetAttribute("HypnosisPossessing") == true or Humanoid.Health <= 0 then
                    v28 = false;
                else
                    local State = Humanoid:GetState();
                    v28 = (State == Enum.HumanoidStateType.Running and true or State == Enum.HumanoidStateType.RunningNoPhysics) and v29;
                end;
            end;

            if v28 then
                if not u9 then
                    loadRunAnimation();
                end;

                if u9 and not u9.IsPlaying then
                    u9:Play(0.08, 1, 1);
                end;
            elseif u9 and u9.IsPlaying then
                u9:Stop(0.08);
            end;
        end;

        local StaminaViewer = u1:FindFirstChild("StaminaViewer");

        if StaminaViewer then
            StaminaViewer:Destroy();
        end;

        local BillboardGui = Instance.new("BillboardGui");
        BillboardGui.Name = "StaminaViewer";
        BillboardGui.Adornee = HumanoidRootPart;
        BillboardGui.AlwaysOnTop = true;
        BillboardGui.LightInfluence = 0;
        BillboardGui.MaxDistance = 100;
        BillboardGui.Size = UDim2.fromOffset(26, 96);
        BillboardGui.StudsOffsetWorldSpace = Vector3.new(3.2, 0.5, 0);
        BillboardGui.Enabled = false;
        BillboardGui.Parent = u1;
        local Frame = Instance.new("Frame");
        Frame.Name = "Background";
        Frame.AnchorPoint = Vector2.new(0.5, 0.5);
        Frame.Position = UDim2.fromOffset(5, 48);
        Frame.Size = UDim2.fromOffset(4, 88);
        Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15);
        Frame.BackgroundTransparency = 0.45;
        Frame.BorderSizePixel = 0;
        Frame.ClipsDescendants = true;
        Frame.Parent = BillboardGui;
        local UICorner = Instance.new("UICorner");
        UICorner.CornerRadius = UDim.new(0, 2);
        UICorner.Parent = Frame;
        local UIStroke = Instance.new("UIStroke");
        UIStroke.Color = Color3.fromRGB(255, 255, 255);
        UIStroke.Transparency = 0.15;
        UIStroke.Thickness = 1;
        UIStroke.LineJoinMode = Enum.LineJoinMode.Miter;
        UIStroke.Parent = Frame;
        local Frame2 = Instance.new("Frame");
        Frame2.Name = "Fill";
        Frame2.AnchorPoint = Vector2.new(0.5, 1);
        Frame2.Position = UDim2.fromScale(0.5, 1);
        Frame2.Size = UDim2.fromScale(1, 1);
        Frame2.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        Frame2.BorderSizePixel = 0;
        Frame2.Parent = Frame;
        local UICorner2 = Instance.new("UICorner");
        UICorner2.CornerRadius = UDim.new(0, 2);
        UICorner2.Parent = Frame2;
        local Frame3 = Instance.new("Frame");
        Frame3.Name = "BloodBackground";
        Frame3.AnchorPoint = Vector2.new(0.5, 0.5);
        Frame3.Position = UDim2.fromOffset(13, 48);
        Frame3.Size = UDim2.fromOffset(4, 88);
        Frame3.BackgroundColor3 = Color3.fromRGB(25, 0, 0);
        Frame3.BackgroundTransparency = 0.35;
        Frame3.BorderSizePixel = 0;
        Frame3.ClipsDescendants = true;
        Frame3.Visible = false;
        Frame3.Parent = BillboardGui;
        local UICorner3 = Instance.new("UICorner");
        UICorner3.CornerRadius = UDim.new(0, 2);
        UICorner3.Parent = Frame3;
        local UIStroke2 = Instance.new("UIStroke");
        UIStroke2.Color = Color3.fromRGB(255, 45, 45);
        UIStroke2.Transparency = 0.05;
        UIStroke2.Thickness = 1;
        UIStroke2.LineJoinMode = Enum.LineJoinMode.Miter;
        UIStroke2.Parent = Frame3;
        local Frame4 = Instance.new("Frame");
        Frame4.Name = "BloodFill";
        Frame4.AnchorPoint = Vector2.new(0.5, 1);
        Frame4.Position = UDim2.fromScale(0.5, 1);
        Frame4.Size = UDim2.fromScale(1, 1);
        Frame4.BackgroundColor3 = Color3.fromRGB(210, 0, 0);
        Frame4.BorderSizePixel = 0;
        Frame4.Parent = Frame3;
        local UICorner4 = Instance.new("UICorner");
        UICorner4.CornerRadius = UDim.new(0, 2);
        UICorner4.Parent = Frame4;
        local Frame5 = Instance.new("Frame");
        Frame5.Name = "ManaBackground";
        Frame5.AnchorPoint = Vector2.new(0.5, 0.5);
        Frame5.Position = UDim2.fromOffset(13, 48);
        Frame5.Size = UDim2.fromOffset(4, 88);
        Frame5.BackgroundColor3 = Color3.fromRGB(25, 0, 25);
        Frame5.BackgroundTransparency = 0.35;
        Frame5.BorderSizePixel = 0;
        Frame5.ClipsDescendants = true;
        Frame5.Visible = false;
        Frame5.Parent = BillboardGui;
        local UICorner5 = Instance.new("UICorner");
        UICorner5.CornerRadius = UDim.new(0, 2);
        UICorner5.Parent = Frame5;
        local UIStroke3 = Instance.new("UIStroke");
        UIStroke3.Color = Color3.fromRGB(150, 45, 255);
        UIStroke3.Transparency = 0.05;
        UIStroke3.Thickness = 1;
        UIStroke3.LineJoinMode = Enum.LineJoinMode.Miter;
        UIStroke3.Parent = Frame5;
        local Frame6 = Instance.new("Frame");
        Frame6.Name = "ManaFill";
        Frame6.AnchorPoint = Vector2.new(0.5, 1);
        Frame6.Position = UDim2.fromScale(0.5, 1);
        Frame6.Size = UDim2.fromScale(1, 1);
        Frame6.BackgroundColor3 = Color3.fromRGB(190, 0, 255);
        Frame6.BorderSizePixel = 0;
        Frame6.Parent = Frame5;
        local UICorner6 = Instance.new("UICorner");
        UICorner6.CornerRadius = UDim.new(0, 2);
        UICorner6.Parent = Frame6;
        local Frame7 = Instance.new("Frame");
        Frame7.Name = "XPBackground";
        Frame7.AnchorPoint = Vector2.new(0.5, 0.5);
        Frame7.Position = UDim2.fromOffset(21, 48);
        Frame7.Size = UDim2.fromOffset(4, 88);
        Frame7.BackgroundColor3 = Color3.fromRGB(0, 20, 35);
        Frame7.BackgroundTransparency = 0.35;
        Frame7.BorderSizePixel = 0;
        Frame7.ClipsDescendants = true;
        Frame7.Visible = false;
        Frame7.Parent = BillboardGui;
        local UICorner7 = Instance.new("UICorner");
        UICorner7.CornerRadius = UDim.new(0, 2);
        UICorner7.Parent = Frame7;
        local UIStroke4 = Instance.new("UIStroke");
        UIStroke4.Color = Color3.fromRGB(45, 150, 255);
        UIStroke4.Transparency = 0.05;
        UIStroke4.Thickness = 1;
        UIStroke4.LineJoinMode = Enum.LineJoinMode.Miter;
        UIStroke4.Parent = Frame7;
        local Frame8 = Instance.new("Frame");
        Frame8.Name = "XPFill";
        Frame8.AnchorPoint = Vector2.new(0.5, 1);
        Frame8.Position = UDim2.fromScale(0.5, 1);
        local v30 = tonumber(LocalPlayer:GetAttribute("VampireFarmXP")) or 0;
        local v31 = tonumber(LocalPlayer:GetAttribute("VampireFarmRequired")) or 100;
        local math_max_ret = math.max(v31, 1);
        Frame8.Size = UDim2.fromScale(1, (math.clamp(v30 / math_max_ret, 0, 1)));
        Frame8.BackgroundColor3 = Color3.fromRGB(0, 190, 255);
        Frame8.BorderSizePixel = 0;
        Frame8.Parent = Frame7;
        local UICorner8 = Instance.new("UICorner");
        UICorner8.CornerRadius = UDim.new(0, 2);
        UICorner8.Parent = Frame8;
        local u32 = nil;
        local u33 = nil;

        local function updateViewer() -- Line: 311
            -- upvalues: u5 (ref), LocalPlayer (copy), Frame (copy), Frame3 (copy), Frame5 (copy), Frame7 (copy), BillboardGui (copy), u6 (ref), u7 (ref), u32 (ref), u33 (ref), TweenService (ref), Frame2 (copy), Frame4 (copy), Frame6 (copy), Frame8 (copy)
            if u5 then
                return;
            end;

            local v34 = LocalPlayer:GetAttribute("Stamina") or 0;
            local v35 = LocalPlayer:GetAttribute("MaxStamina") or 100;
            local v36 = LocalPlayer:GetAttribute("IsSprinting") == true;
            local v37 = v34 / math.max(v35, 1);
            local math_clamp_ret = math.clamp(v37, 0, 1);
            local v38 = LocalPlayer:GetAttribute("BloodThirst") or 0;
            local v39 = LocalPlayer:GetAttribute("MaxBloodThirst") or 100;
            local v40 = v38 / math.max(v39, 1);
            local math_clamp_ret2 = math.clamp(v40, 0, 1);
            local v41 = LocalPlayer:GetAttribute("VampireFarmXP") or 0;
            local v42 = LocalPlayer:GetAttribute("VampireFarmRequired") or 100;
            local v43 = v41 / math.max(v42, 1);
            local math_clamp_ret3 = math.clamp(v43, 0, 1);
            local v44 = LocalPlayer:GetAttribute("Mana") or 0;
            local v45 = LocalPlayer:GetAttribute("MaxMana") or 100;
            local v46 = v44 / math.max(v45, 1);
            local math_clamp_ret4 = math.clamp(v46, 0, 1);
            local v47 = LocalPlayer.Team and (LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised");
            local v48 = LocalPlayer.Team and LocalPlayer.Team.Name == "Witches";

            if LocalPlayer.Team then
                local _ = LocalPlayer.Team.Name == "Humans";
            end;

            local v49 = LocalPlayer.Team and LocalPlayer.Team.Name == "VampireHunter";
            local v50 = v36 or math_clamp_ret < 0.999;
            Frame.Visible = v50;
            Frame3.Visible = v47;
            Frame5.Visible = v48;
            Frame7.Visible = v47 or (v48 or v49);
            BillboardGui.Enabled = v50 or (v47 or (v48 or v49));

            if u6 then
                u6:Cancel();
            end;

            if u7 then
                u7:Cancel();
            end;

            if u32 then
                u32:Cancel();
            end;

            if u33 then
                u33:Cancel();
            end;

            u6 = TweenService:Create(Frame2, TweenInfo.new(0.08, Enum.EasingStyle.Linear), {
                Size = UDim2.fromScale(1, math_clamp_ret)
            });
            u7 = TweenService:Create(Frame4, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
                Size = UDim2.fromScale(1, math_clamp_ret2)
            });
            u32 = TweenService:Create(Frame6, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
                Size = UDim2.fromScale(1, math_clamp_ret4)
            });
            u33 = TweenService:Create(Frame8, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {
                Size = UDim2.fromScale(1, math_clamp_ret3)
            });
            u6:Play();
            u7:Play();
            u32:Play();
            u33:Play();
        end;

        local function getLocalSpeeds() -- Line: 395
            -- upvalues: LocalPlayer (copy), SprintConfig (copy)
            local v51 = LocalPlayer.Team and LocalPlayer.Team.Name or "Humans";
            local ForPlayer = SprintConfig.GetForPlayer(v51, LocalPlayer:GetAttribute("VampireOrigin"), LocalPlayer:GetAttribute("Years"), LocalPlayer);
            local v52 = v51 == "Humans" and (LocalPlayer:GetAttribute("SpeedBonus") or 0) or 0;
            local v53 = tonumber(LocalPlayer:GetAttribute("StrengthSpeedMultiplier")) or 1;
            local v54 = v52 * math.clamp(v53, 1, 1.2);

            return ForPlayer.WalkSpeed + v54, ForPlayer.SprintSpeed + v54;
        end;

        u27 = function() -- Line: 409, Name: canLocallySprint
            -- upvalues: u5 (ref), Humanoid (copy), u1 (copy), LocalPlayer (copy)
            if u5 or (not Humanoid or Humanoid.Health <= 0) then
                return false;
            end;

            if u1:GetAttribute("ActionLocked") == true then
                return false;
            end;

            if u1:GetAttribute("HypnosisPossessing") == true then
                return false;
            end;

            if u1:GetAttribute("Hibernating") == true then
                return false;
            end;

            if u1:GetAttribute("FlyingBroom") == true then
                return false;
            end;

            if u1:GetAttribute("BatFormActive") == true or u1:GetAttribute("BatFormTransforming") == true then
                return false;
            end;

            return (LocalPlayer:GetAttribute("Stamina") or 100) > 0;
        end;

        local function startSprint() -- Line: 422
            -- upvalues: u27 (ref), getLocalSpeeds (copy), Humanoid (copy), SprintRequest (copy), updateRunAnimation (copy)
            if not u27() then
                return;
            end;

            local _, v55 = getLocalSpeeds();
            Humanoid.WalkSpeed = v55;
            SprintRequest:FireServer(true);
            updateRunAnimation();
        end;

        local function stopSprint() -- Line: 430
            -- upvalues: u5 (ref), Humanoid (copy), getLocalSpeeds (copy), SprintRequest (copy), updateRunAnimation (copy)
            if u5 or not Humanoid then
                return;
            end;

            Humanoid.WalkSpeed = getLocalSpeeds();
            SprintRequest:FireServer(false);
            updateRunAnimation();
        end;

        local function isSprintKey(p56) -- Line: 438
            return (p56.KeyCode == Enum.KeyCode.LeftShift or p56.KeyCode == Enum.KeyCode.RightShift) and true or p56.KeyCode == Enum.KeyCode.ButtonL3;
        end;

        local v60 = UserInputService.InputBegan:Connect(function(p57, p58) -- Line: 444
            -- upvalues: u27 (ref), getLocalSpeeds (copy), Humanoid (copy), SprintRequest (copy), updateRunAnimation (copy)
            if p58 or p57.KeyCode ~= Enum.KeyCode.LeftShift and p57.KeyCode ~= Enum.KeyCode.RightShift and p57.KeyCode ~= Enum.KeyCode.ButtonL3 then
                return;
            end;

            if not u27() then
                return;
            end;

            local _, v59 = getLocalSpeeds();
            Humanoid.WalkSpeed = v59;
            SprintRequest:FireServer(true);
            updateRunAnimation();
        end);
        table.insert(u4, v60);
        local v62 = UserInputService.InputEnded:Connect(function(p61) -- Line: 452
            -- upvalues: u5 (ref), Humanoid (copy), getLocalSpeeds (copy), SprintRequest (copy), updateRunAnimation (copy)
            if p61.KeyCode ~= Enum.KeyCode.LeftShift and p61.KeyCode ~= Enum.KeyCode.RightShift and p61.KeyCode ~= Enum.KeyCode.ButtonL3 then
                return;
            end;

            if not u5 then
                if not Humanoid then
                    return;
                end;

                Humanoid.WalkSpeed = getLocalSpeeds();
                SprintRequest:FireServer(false);
                updateRunAnimation();
            end;
        end);
        table.insert(u4, v62);
        local v63 = LocalPlayer:GetAttributeChangedSignal("Stamina"):Connect(function() -- Line: 460
            -- upvalues: updateViewer (copy), LocalPlayer (copy), getLocalSpeeds (copy), Humanoid (copy), updateRunAnimation (copy)
            updateViewer();

            if (LocalPlayer:GetAttribute("Stamina") or 0) <= 0 then
                Humanoid.WalkSpeed = getLocalSpeeds();
                updateRunAnimation();
            end;
        end);
        table.insert(u4, v63);
        local v64 = LocalPlayer:GetAttributeChangedSignal("MaxStamina"):Connect(updateViewer);
        table.insert(u4, v64);
        local v65 = LocalPlayer:GetAttributeChangedSignal("BloodThirst"):Connect(updateViewer);
        table.insert(u4, v65);
        local v66 = LocalPlayer:GetAttributeChangedSignal("MaxBloodThirst"):Connect(updateViewer);
        table.insert(u4, v66);
        local v67 = LocalPlayer:GetAttributeChangedSignal("Mana"):Connect(updateViewer);
        table.insert(u4, v67);
        local v68 = LocalPlayer:GetAttributeChangedSignal("MaxMana"):Connect(updateViewer);
        table.insert(u4, v68);

        local function refreshSpeedBuffs() -- Line: 474
            -- upvalues: u1 (copy), getLocalSpeeds (copy), Humanoid (copy), LocalPlayer (copy), updateRunAnimation (copy)
            if u1:GetAttribute("ActionLocked") == true or (u1:GetAttribute("Hibernating") == true or u1:GetAttribute("Ragdolled") == true) then
                return;
            end;

            local v69, v70 = getLocalSpeeds();
            Humanoid.WalkSpeed = LocalPlayer:GetAttribute("IsSprinting") == true and v70 and v70 or v69;
            updateRunAnimation();
        end;

        local v71 = LocalPlayer:GetAttributeChangedSignal("StrengthSpeedMultiplier"):Connect(refreshSpeedBuffs);
        table.insert(u4, v71);
        local v72 = LocalPlayer:GetAttributeChangedSignal("CannibalVampire"):Connect(refreshSpeedBuffs);
        table.insert(u4, v72);
        local v73 = LocalPlayer:GetAttributeChangedSignal("VampireFarmXP"):Connect(updateViewer);
        table.insert(u4, v73);
        local v74 = LocalPlayer:GetAttributeChangedSignal("VampireFarmRequired"):Connect(updateViewer);
        table.insert(u4, v74);
        local v75 = LocalPlayer:GetAttributeChangedSignal("Years"):Connect(updateViewer);
        table.insert(u4, v75);
        local v76 = LocalPlayer:GetAttributeChangedSignal("IsSprinting"):Connect(function() -- Line: 491
            -- upvalues: updateViewer (copy), updateRunAnimation (copy)
            updateViewer();
            updateRunAnimation();
        end);
        table.insert(u4, v76);
        local v77 = u1:GetAttributeChangedSignal("VampireInfected"):Connect(updateViewer);
        table.insert(u4, v77);

        for _, v in { "BatFormActive", "BatFormTransforming", "HypnosisPossessing", "FlyingBroom" } do
            local v78 = u1:GetAttributeChangedSignal(v):Connect(function() -- Line: 497
                -- upvalues: u1 (copy), v (copy), SprintRequest (copy), u9 (ref)
                if u1:GetAttribute(v) == true then
                    SprintRequest:FireServer(false);

                    if u9 and u9.IsPlaying then
                        u9:Stop(0.08);
                    end;
                end;
            end);
            table.insert(u4, v78);
        end;

        local v81 = Humanoid.StateChanged:Connect(function(p79, p80) -- Line: 505
            -- upvalues: updateRunAnimation (copy), u5 (ref), u11 (ref), SprintRequest (copy)
            updateRunAnimation();

            if p80 ~= Enum.HumanoidStateType.Jumping or u5 then
                return;
            end;

            local os_clock_ret = os.clock();

            if os_clock_ret - u11 >= 0.12 then
                u11 = os_clock_ret;
                SprintRequest:FireServer("Jump");
            end;
        end);
        table.insert(u4, v81);
        local v82 = Humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(function() -- Line: 518
            -- upvalues: updateRunAnimation (copy)
            updateRunAnimation();
        end);
        table.insert(u4, v82);
        local v83 = Humanoid.Running:Connect(function() -- Line: 522
            -- upvalues: updateRunAnimation (copy)
            updateRunAnimation();
        end);
        table.insert(u4, v83);
        local v84 = LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function() -- Line: 526
            -- upvalues: u10 (ref), loadRunAnimation (copy), updateRunAnimation (copy), updateViewer (copy)
            u10 = nil;
            loadRunAnimation();
            updateRunAnimation();
            updateViewer();
        end);
        table.insert(u4, v84);
        local v87 = u1.Destroying:Connect(function() -- Line: 533
            -- upvalues: u5 (ref), SprintRequest (copy), u9 (ref), u8 (ref), u4 (copy)
            u5 = true;
            SprintRequest:FireServer(false);

            if u9 and u9.IsPlaying then
                u9:Stop(0);
            end;

            if u9 then
                local u85 = u9;
                task.delay(0.15, function() -- Line: 539
                    -- upvalues: u85 (copy)
                    pcall(function() -- Line: 539
                        -- upvalues: u85 (ref)
                        u85:Destroy();
                    end);
                end);
                u9 = nil;
            end;

            if u8 then
                local u86 = u8;
                task.delay(0.15, function() -- Line: 543
                    -- upvalues: u86 (copy)
                    pcall(function() -- Line: 543
                        -- upvalues: u86 (ref)
                        u86:Destroy();
                    end);
                end);
                u8 = nil;
            end;

            for _, v in u4 do
                v:Disconnect();
            end;

            table.clear(u4);
        end);
        table.insert(u4, v87);
        loadRunAnimation();
        updateViewer();
        updateRunAnimation();
    end
};
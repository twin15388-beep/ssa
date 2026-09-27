-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService");
game:GetService("StarterGui");
local TeamGuiLayout = require(ReplicatedStorage:WaitForChild("TeamGuiLayout"));
local LocalPlayer = Players.LocalPlayer;
local Mouse = LocalPlayer:GetMouse();
local v1 = ReplicatedStorage:WaitForChild("Funções");
local NetworkRegistry = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("NetworkRegistry"));
local Event = NetworkRegistry.GetEvent("Combat", "WitchPainInflictionRequest");
local WitchPainInflictionRemote = NetworkRegistry.Legacy.Events:WaitForChild("WitchPainInflictionRemote");
local PainInfliction = require(v1:WaitForChild("WitchSpellsConfig")).PainInfliction;
local u2 = nil;
local u3 = nil;
local u4 = false;
local u5 = false;
local u6 = nil;
local u7 = 0;
local u8 = nil;
local u9 = nil;
local u10 = false;
local u11 = 0;
local u12 = false;

local function isWitch() -- Line: 28
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer.Team and LocalPlayer.Team.Name == "Witches";
end;

local function getYears() -- Line: 32
    -- upvalues: LocalPlayer (copy)
    local v13 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
    local math_floor_ret = math.floor(v13);

    return math.max(0, math_floor_ret);
end;

local function findButtonIn(p14) -- Line: 36
    -- upvalues: TeamGuiLayout (copy)
    local v15 = "Witches" .. TeamGuiLayout.GetMode();

    if p14 then
        p14 = TeamGuiLayout.FindPanel(p14, v15);
    end;

    if p14 then
        p14 = TeamGuiLayout.GetMenu(p14);
    end;

    if p14 then
        p14 = p14:FindFirstChild("Powers1") or p14:FindFirstChild("Powers");
    end;

    if p14 then
        p14 = p14:FindFirstChild("PainInfliction");
    end;

    if not (p14 and (p14:IsA("GuiObject") and p14)) then
        p14 = nil;
    end;

    return p14;
end;

local function findButton() -- Line: 45
    -- upvalues: findButtonIn (copy), LocalPlayer (copy)
    return findButtonIn(LocalPlayer:FindFirstChildOfClass("PlayerGui"));
end;

local function getCooldownLabel() -- Line: 49
    -- upvalues: u2 (ref)
    if u2 then
        return u2:FindFirstChild("COLDOWN") or (u2:FindFirstChild("Coldown") or u2:FindFirstChild("CooldownText"));
    end;

    return nil;
end;

local function getUnlockLabel() -- Line: 54
    -- upvalues: u2 (ref)
    if u2 then
        return u2:FindFirstChild("UNLOCKLV") or (u2:FindFirstChild("UnlockRequirement") or u2:FindFirstChild("UnlockRequirement1"));
    end;

    return nil;
end;

local function ensureBar(p16) -- Line: 59
    -- upvalues: u8 (ref), u9 (ref)
    if u8 then
        u8:Destroy();
        u8 = nil;
        u9 = nil;
    end;

    if p16 then
        p16 = p16:FindFirstChild("Head");
    end;

    if not p16 then
        return;
    end;

    local BillboardGui = Instance.new("BillboardGui");
    BillboardGui.Name = "PainInflictionProgressGui";
    BillboardGui.Adornee = p16;
    BillboardGui.Size = UDim2.fromOffset(34, 3);
    BillboardGui.StudsOffset = Vector3.new(0, 0.65, 0);
    BillboardGui.AlwaysOnTop = true;
    BillboardGui.MaxDistance = 50;
    BillboardGui.ResetOnSpawn = false;
    local Frame = Instance.new("Frame");
    Frame.Name = "Background";
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15);
    Frame.BackgroundTransparency = 0.4;
    Frame.BorderSizePixel = 0;
    Frame.Parent = BillboardGui;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Color = Color3.fromRGB(0, 0, 0);
    UIStroke.Transparency = 0.35;
    UIStroke.Thickness = 1;
    UIStroke.Parent = Frame;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Fill";
    Frame2.Size = UDim2.fromScale(1, 1);
    Frame2.BackgroundColor3 = Color3.fromRGB(200, 0, 0);
    Frame2.BorderSizePixel = 0;
    Frame2.Parent = Frame;
    BillboardGui.Parent = p16;
    u8 = BillboardGui;
    u9 = Frame2;
end;

local function clearBar() -- Line: 94
    -- upvalues: u8 (ref), u9 (ref)
    if u8 then
        u8:Destroy();
    end;

    u8 = nil;
    u9 = nil;
end;

local function setProgress(p17) -- Line: 100
    -- upvalues: u9 (ref)
    if u9 then
        u9.Size = UDim2.fromScale(1 - math.clamp(p17, 0, 1), 1);
    end;
end;

local function startShake() -- Line: 104
    -- upvalues: u11 (ref), u10 (ref), RunService (copy)
    u11 = u11 + 1;
    local u18 = u11;
    u10 = true;
    RunService:BindToRenderStep("WitchPainInflictionShake", Enum.RenderPriority.Camera.Value + 2, function() -- Line: 108
        -- upvalues: u18 (copy), u11 (ref), u10 (ref), RunService (ref)
        if u18 ~= u11 or not u10 then
            RunService:UnbindFromRenderStep("WitchPainInflictionShake");

            return;
        end;

        local workspace_CurrentCamera = workspace.CurrentCamera;

        if not workspace_CurrentCamera then
            return;
        end;

        local v19 = os.clock() * 45;
        local math_noise_ret = math.noise(v19, 0, 0);
        local math_noise_ret2 = math.noise(0, v19, 0);
        local math_noise_ret3 = math.noise(0, 0, v19);
        workspace_CurrentCamera.CFrame = workspace_CurrentCamera.CFrame * CFrame.new(math_noise_ret * 0.32, math_noise_ret2 * 0.32, 0) * CFrame.Angles(math_noise_ret2 * 0.038397243543875255, math_noise_ret * 0.038397243543875255, math_noise_ret3 * 0.027925268031909273);
    end);
end;

local function stopShake() -- Line: 123
    -- upvalues: u10 (ref), u11 (ref), RunService (copy)
    u10 = false;
    u11 = u11 + 1;
    RunService:UnbindFromRenderStep("WitchPainInflictionShake");
end;

local function currentTargetFromPointer() -- Line: 129
    -- upvalues: TeamGuiLayout (copy), LocalPlayer (copy), PainInfliction (copy), Mouse (copy)
    local v20;

    if TeamGuiLayout.GetMode() == "CONSOLE" then
        local workspace_CurrentCamera = workspace.CurrentCamera;

        if not workspace_CurrentCamera then
            return nil;
        end;

        local ViewportSize = workspace_CurrentCamera.ViewportSize;
        local v21 = workspace_CurrentCamera:ViewportPointToRay(ViewportSize.X * 0.5, ViewportSize.Y * 0.5);
        local RaycastParams_new_ret = RaycastParams.new();
        RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
        RaycastParams_new_ret.FilterDescendantsInstances = LocalPlayer.Character and { LocalPlayer.Character } or {};
        RaycastParams_new_ret.IgnoreWater = true;
        local v22 = workspace:Raycast(v21.Origin, v21.Direction * (PainInfliction.MaximumDistance or 40), RaycastParams_new_ret);
        v20 = v22 and v22.Instance or nil;
    else
        v20 = Mouse.Target;
    end;

    while v20 and v20 ~= workspace do
        if v20:IsA("Model") and v20:FindFirstChildOfClass("Humanoid") then
            return v20;
        end;

        v20 = v20.Parent;
    end;

    return nil;
end;

local function refreshButton() -- Line: 155
    -- upvalues: u2 (ref), u3 (ref), LocalPlayer (copy), PainInfliction (copy), u7 (ref), u5 (ref), u4 (ref)
    if not (u2 and (u2.Parent and u3)) then
        return;
    end;

    local v23 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
    local math_floor_ret = math.floor(v23);
    local v24 = math.max(0, math_floor_ret) >= (PainInfliction.UnlockYears or 140);
    local v25 = u7 - workspace:GetServerTimeNow();
    local math_max_ret = math.max(0, v25);
    local u26 = LocalPlayer.Team and LocalPlayer.Team.Name == "Witches";

    if u26 then
        if v24 then
            if math_max_ret <= 0 then
                u26 = not u5;
            else
                u26 = false;
            end;
        else
            u26 = v24;
        end;
    end;

    u2.Visible = LocalPlayer.Team and LocalPlayer.Team.Name == "Witches";
    u2.Active = u26;

    if u2:IsA("GuiButton") then
        local v27;

        if u26 then
            v27 = u3.autoButtonColor;
        else
            v27 = u26;
        end;

        u2.AutoButtonColor = v27;
    end;

    pcall(function() -- Line: 163
        -- upvalues: u2 (ref), u26 (copy)
        u2.Interactable = u26;
    end);
    local v28;

    if u2 then
        v28 = u2:FindFirstChild("UNLOCKLV") or (u2:FindFirstChild("UnlockRequirement") or u2:FindFirstChild("UnlockRequirement1"));
    else
        v28 = nil;
    end;

    if v28 and v28:IsA("TextLabel") then
        v28.Text = "+" .. tostring(PainInfliction.UnlockYears or 140);
        v28.Visible = LocalPlayer.Team and LocalPlayer.Team.Name == "Witches" and not v24;
    end;

    local v29;

    if u2 then
        v29 = u2:FindFirstChild("COLDOWN") or (u2:FindFirstChild("Coldown") or u2:FindFirstChild("CooldownText"));
    else
        v29 = nil;
    end;

    if v29 and v29:IsA("TextLabel") then
        v29.Visible = math_max_ret > 0;
        local v30;

        if math_max_ret > 0 then
            local math_ceil_ret = math.ceil(math_max_ret);
            v30 = tostring(math_ceil_ret) or "";
        else
            v30 = "";
        end;

        v29.Text = v30;
    end;

    u2:SetAttribute("PowerCooldown", (math.ceil(math_max_ret)));
    local v31 = u4 or u5 or not u26;

    if u2:IsA("ImageButton") then
        u2.ImageColor3 = v31 and u3.imageColor:Lerp(Color3.new(0, 0, 0), 0.6) or u3.imageColor;
        u2.ImageTransparency = v31 and math.min(0.88, u3.imageTransparency + 0.08) or u3.imageTransparency;
    end;

    u2.BackgroundColor3 = v31 and u3.backgroundColor:Lerp(Color3.new(0, 0, 0), 0.58) or u3.backgroundColor;
    u2.BackgroundTransparency = u3.backgroundTransparency;
end;

local function arm() -- Line: 184
    -- upvalues: u2 (ref), LocalPlayer (copy), PainInfliction (copy), u7 (ref), u5 (ref), u4 (ref)
    if u2 then
        if LocalPlayer.Team and LocalPlayer.Team.Name == "Witches" then
            local v32 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
            local math_floor_ret = math.floor(v32);

            if math.max(0, math_floor_ret) >= (PainInfliction.UnlockYears or 140) then
                if workspace:GetServerTimeNow() < u7 or u5 then
                    return;
                end;

                u4 = true;
            end;
        end;
    end;
end;

local function faceActiveTarget() -- Line: 190
    -- upvalues: u5 (ref), u6 (ref), LocalPlayer (copy), u12 (ref)
    if not (u5 and u6) then
        return;
    end;

    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    local HumanoidRootPart = u6:FindFirstChild("HumanoidRootPart");

    if not (Character and HumanoidRootPart) then
        return;
    end;

    local Vector3_new_ret = Vector3.new(HumanoidRootPart.Position.X, Character.Position.Y, HumanoidRootPart.Position.Z);

    if (Vector3_new_ret - Character.Position).Magnitude > 0.05 then
        local CFrame_lookAt_ret = CFrame.lookAt(Character.Position, Vector3_new_ret);

        if u12 then
            CFrame_lookAt_ret = CFrame_lookAt_ret * CFrame.Angles(0, 3.141592653589793, 0) or CFrame_lookAt_ret;
        end;

        Character.CFrame = CFrame_lookAt_ret;
    end;
end;

local function beginHold(p33) -- Line: 203
    -- upvalues: u4 (ref), u5 (ref), u6 (ref), u12 (ref), faceActiveTarget (copy), ensureBar (copy), Event (copy), refreshButton (copy)
    if not (u4 and (not u5 and p33)) then
        return;
    end;

    u5 = true;
    u6 = p33;
    u12 = true;
    faceActiveTarget();
    ensureBar(p33);
    Event:FireServer("Begin", p33);
    refreshButton();
end;

local function stopHold() -- Line: 215
    -- upvalues: u5 (ref), u4 (ref), WitchPainInflictionRemote (copy)
    if not u5 then
        u4 = false;

        return;
    end;

    u5 = false;
    u4 = false;
    WitchPainInflictionRemote:FireServer("Stop");
end;

local function bindButton() -- Line: 222
    -- upvalues: findButtonIn (copy), LocalPlayer (copy), u2 (ref), u3 (ref), arm (copy), PainInfliction (copy), u7 (ref), u5 (ref), u4 (ref), refreshButton (copy)
    local v34 = findButtonIn(LocalPlayer:FindFirstChildOfClass("PlayerGui"));

    if not v34 or v34 == u2 then
        return;
    end;

    u2 = v34;
    u2.Active = true;
    u3 = {
        imageColor = u2:IsA("ImageButton") and u2.ImageColor3 or Color3.new(1, 1, 1),
        imageTransparency = u2:IsA("ImageButton") and u2.ImageTransparency or 0,
        backgroundColor = u2.BackgroundColor3,
        backgroundTransparency = u2.BackgroundTransparency,
        autoButtonColor = u2:IsA("GuiButton") and u2.AutoButtonColor or false
    };

    if u2:IsA("GuiButton") then
        u2.Activated:Connect(arm);
    else
        u2.InputBegan:Connect(function(p35) -- Line: 237
            -- upvalues: u2 (ref), LocalPlayer (ref), PainInfliction (ref), u7 (ref), u5 (ref), u4 (ref)
            if (p35.UserInputType == Enum.UserInputType.MouseButton1 or p35.UserInputType == Enum.UserInputType.Touch) and u2 then
                if LocalPlayer.Team and LocalPlayer.Team.Name == "Witches" then
                    local v36 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
                    local math_floor_ret = math.floor(v36);

                    if math.max(0, math_floor_ret) < (PainInfliction.UnlockYears or 140) then
                        return;
                    end;

                    if workspace:GetServerTimeNow() >= u7 then
                        if u5 then
                            return;
                        end;

                        u4 = true;
                    end;
                end;
            end;
        end);
    end;

    refreshButton();
end;

UserInputService.InputBegan:Connect(function(p37, p38) -- Line: 244
    -- upvalues: UserInputService (copy), TeamGuiLayout (copy), u4 (ref), u5 (ref), u2 (ref), LocalPlayer (copy), PainInfliction (copy), u7 (ref), currentTargetFromPointer (copy), u6 (ref), u12 (ref), faceActiveTarget (copy), ensureBar (copy), Event (copy), refreshButton (copy)
    if p38 or UserInputService:GetFocusedTextBox() then
        return;
    end;

    if TeamGuiLayout.GetMode() == "CONSOLE" and p37.KeyCode == Enum.KeyCode.ButtonR1 then
        if not (u4 or (u5 or not u2)) then
            if LocalPlayer.Team and LocalPlayer.Team.Name == "Witches" then
                local v39 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
                local math_floor_ret = math.floor(v39);

                if math.max(0, math_floor_ret) >= (PainInfliction.UnlockYears or 140) and (workspace:GetServerTimeNow() >= u7 and not u5) then
                    u4 = true;
                end;
            end;
        end;

        if u4 and not u5 then
            local v40 = currentTargetFromPointer();

            if u4 and not u5 then
                if not v40 then
                    return;
                end;

                u5 = true;
                u6 = v40;
                u12 = true;
                faceActiveTarget();
                ensureBar(v40);
                Event:FireServer("Begin", v40);
                refreshButton();
            end;
        end;

        return;
    end;

    if p37.KeyCode == Enum.KeyCode.B then
        if u2 then
            if LocalPlayer.Team and LocalPlayer.Team.Name == "Witches" then
                local v41 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
                local math_floor_ret = math.floor(v41);

                if math.max(0, math_floor_ret) < (PainInfliction.UnlockYears or 140) then
                    return;
                end;

                if workspace:GetServerTimeNow() >= u7 then
                    if u5 then
                        return;
                    end;

                    u4 = true;
                end;
            end;
        end;

        return;
    end;

    if not u4 or u5 then
        return;
    end;

    if p37.UserInputType == Enum.UserInputType.MouseButton1 or p37.UserInputType == Enum.UserInputType.Touch then
        local v42 = currentTargetFromPointer();

        if u4 and not u5 then
            if not v42 then
                return;
            end;

            u5 = true;
            u6 = v42;
            u12 = true;
            faceActiveTarget();
            ensureBar(v42);
            Event:FireServer("Begin", v42);
            refreshButton();
        end;
    end;
end);
UserInputService.InputEnded:Connect(function(p43) -- Line: 261
    -- upvalues: TeamGuiLayout (copy), u5 (ref), u4 (ref), WitchPainInflictionRemote (copy), refreshButton (copy)
    if TeamGuiLayout.GetMode() ~= "CONSOLE" or p43.KeyCode ~= Enum.KeyCode.ButtonR1 then
        if (p43.UserInputType == Enum.UserInputType.MouseButton1 or p43.UserInputType == Enum.UserInputType.Touch) and u5 then
            if not u5 then
                u4 = false;

                return;
            end;

            u5 = false;
            u4 = false;
            WitchPainInflictionRemote:FireServer("Stop");
        end;

        return;
    end;

    if not u5 then
        u4 = false;
        refreshButton();

        return;
    end;

    if not u5 then
        u4 = false;

        return;
    end;

    u5 = false;
    u4 = false;
    WitchPainInflictionRemote:FireServer("Stop");
end);
WitchPainInflictionRemote.OnClientEvent:Connect(function(p44, p45, p46, p47) -- Line: 271
    -- upvalues: u6 (ref), PainInfliction (copy), u7 (ref), ensureBar (copy), u9 (ref), u12 (ref), faceActiveTarget (copy), u11 (ref), u10 (ref), RunService (copy), u5 (ref), u4 (ref), u8 (ref), refreshButton (copy), LocalPlayer (copy)
    if p44 == "Started" then
        u6 = p45;

        if not tonumber(p46) then
            local _ = PainInfliction.MaximumChannelSeconds or 8;
        end;

        u7 = tonumber(p47) or u7;
        ensureBar(u6);

        if u9 then
            u9.Size = UDim2.fromScale(1, 1);
        end;
    elseif p44 == "Progress" then
        local v48 = tonumber(p45) or 0;

        if u9 then
            u9.Size = UDim2.fromScale(1 - math.clamp(v48, 0, 1), 1);
        end;
    else
        if p44 == "PainPhase" then
            u12 = true;
            faceActiveTarget();
            u11 = u11 + 1;
            local u49 = u11;
            u10 = true;
            RunService:BindToRenderStep("WitchPainInflictionShake", Enum.RenderPriority.Camera.Value + 2, function() -- Line: 108
                -- upvalues: u49 (copy), u11 (ref), u10 (ref), RunService (ref)
                if u49 ~= u11 or not u10 then
                    RunService:UnbindFromRenderStep("WitchPainInflictionShake");

                    return;
                end;

                local workspace_CurrentCamera = workspace.CurrentCamera;

                if not workspace_CurrentCamera then
                    return;
                end;

                local v50 = os.clock() * 45;
                local math_noise_ret = math.noise(v50, 0, 0);
                local math_noise_ret2 = math.noise(0, v50, 0);
                local math_noise_ret3 = math.noise(0, 0, v50);
                workspace_CurrentCamera.CFrame = workspace_CurrentCamera.CFrame * CFrame.new(math_noise_ret * 0.32, math_noise_ret2 * 0.32, 0) * CFrame.Angles(math_noise_ret2 * 0.038397243543875255, math_noise_ret * 0.038397243543875255, math_noise_ret3 * 0.027925268031909273);
            end);

            return;
        end;

        if p44 == "Stopped" then
            u5 = false;
            u4 = false;
            u12 = false;
            u6 = nil;
            u10 = false;
            u11 = u11 + 1;
            RunService:UnbindFromRenderStep("WitchPainInflictionShake");

            if u8 then
                u8:Destroy();
            end;

            u8 = nil;
            u9 = nil;
            refreshButton();

            return;
        end;

        if p44 == "Rejected" then
            u5 = false;
            u4 = false;
            u12 = false;

            if p45 == "Cooldown" then
                u7 = tonumber(p46) or u7;
            end;

            u10 = false;
            u11 = u11 + 1;
            RunService:UnbindFromRenderStep("WitchPainInflictionShake");

            if u8 then
                u8:Destroy();
            end;

            u8 = nil;
            u9 = nil;
            refreshButton();

            return;
        end;

        if p44 == "VictimStarted" then
            u6 = LocalPlayer.Character;
            ensureBar(LocalPlayer.Character);

            if u9 then
                u9.Size = UDim2.fromScale(1, 1);
            end;
        elseif p44 == "VictimProgress" then
            local v51 = tonumber(p45) or 0;

            if u9 then
                u9.Size = UDim2.fromScale(1 - math.clamp(v51, 0, 1), 1);
            end;
        elseif p44 == "VictimStopped" then
            u10 = false;
            u11 = u11 + 1;
            RunService:UnbindFromRenderStep("WitchPainInflictionShake");

            if u8 then
                u8:Destroy();
            end;

            u8 = nil;
            u9 = nil;
        end;
    end;
end);
LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function() -- Line: 312
    -- upvalues: LocalPlayer (copy), u4 (ref), u5 (ref), WitchPainInflictionRemote (copy), refreshButton (copy)
    if not (LocalPlayer.Team and LocalPlayer.Team.Name == "Witches") then
        u4 = false;

        if u5 then
            if u5 then
                u5 = false;
                u4 = false;
                WitchPainInflictionRemote:FireServer("Stop");
            else
                u4 = false;
            end;
        end;
    end;

    refreshButton();
end);
LocalPlayer:GetAttributeChangedSignal("Years"):Connect(refreshButton);
LocalPlayer.CharacterAdded:Connect(function() -- Line: 317
    -- upvalues: u4 (ref), u5 (ref), u10 (ref), u11 (ref), RunService (copy), u8 (ref), u9 (ref), bindButton (copy)
    u4 = false;
    u5 = false;
    u10 = false;
    u11 = u11 + 1;
    RunService:UnbindFromRenderStep("WitchPainInflictionShake");

    if u8 then
        u8:Destroy();
    end;

    u8 = nil;
    u9 = nil;
    task.defer(bindButton);
end);
LocalPlayer:WaitForChild("PlayerGui").DescendantAdded:Connect(function(p52) -- Line: 325
    -- upvalues: bindButton (copy)
    if p52.Name == "PainInfliction" then
        task.defer(bindButton);
    end;
end);
bindButton();
RunService:BindToRenderStep("WitchPainInflictionFacing", Enum.RenderPriority.Character.Value + 2, function() -- Line: 330
    -- upvalues: faceActiveTarget (copy), refreshButton (copy)
    faceActiveTarget();
    refreshButton();
end);
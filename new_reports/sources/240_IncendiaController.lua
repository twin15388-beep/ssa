-- Decompiled with Potassium's decompiler.

local TeamGuiLayout = require(game:GetService("ReplicatedStorage"):WaitForChild("TeamGuiLayout"));
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer;
local Incendia = script.Parent:WaitForChild("Incendia", 10);

if not Incendia then
    return;
end;

local v1 = ReplicatedStorage:WaitForChild("Funções", 10);

if not v1 then
    return;
end;

local IncendiaRemote = v1:WaitForChild("Eventos"):WaitForChild("IncendiaRemote");
local Event = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("NetworkRegistry")).GetEvent("Combat", "IncendiaRequest");
local Incendia2 = require(v1:WaitForChild("WitchSpellsConfig")).Incendia;
local Mouse = LocalPlayer:GetMouse();
Incendia.Active = true;
local u2 = Incendia:IsA("TextLabel") and Incendia.TextColor3 or Color3.new(1, 1, 1);
local u3 = Incendia:IsA("TextLabel") and (Incendia.TextTransparency or 0) or 0;
local u4 = Incendia:IsA("ImageButton") and Incendia.ImageColor3 or Color3.new(1, 1, 1);
local u5 = Incendia:IsA("ImageButton") and (Incendia.ImageTransparency or 0) or 0;
local BackgroundColor3 = Incendia.BackgroundColor3;
local BackgroundTransparency = Incendia.BackgroundTransparency;
local u6;

if Incendia:IsA("GuiButton") then
    u6 = Incendia.AutoButtonColor or false;
else
    u6 = false;
end;

local u7 = Incendia:FindFirstChild("COLDOWN") or Incendia:FindFirstChild("Coldown");

if u7 and u7:IsA("TextLabel") then
    u7.Visible = false;
    u7.Text = "";
end;

local u8 = false;
local u9 = 0;
local u10 = false;
local u11 = 0;
local u12 = 0;

local function isWitch() -- Line: 41
    -- upvalues: LocalPlayer (copy)
    local v13;

    if LocalPlayer.Team == nil then
        v13 = false;
    else
        v13 = LocalPlayer.Team.Name == "Witches";
    end;

    return v13;
end;

local function shakeCamera() -- Line: 45
    -- upvalues: u12 (ref), RunService (copy)
    u12 = u12 + 1;
    local u14 = u12;
    local os_clock_ret = os.clock();
    RunService:UnbindFromRenderStep("IncendiaCameraShakePC");
    RunService:BindToRenderStep("IncendiaCameraShakePC", Enum.RenderPriority.Camera.Value + 1, function() -- Line: 52
        -- upvalues: u14 (copy), u12 (ref), RunService (ref), os_clock_ret (copy)
        if u14 ~= u12 then
            RunService:UnbindFromRenderStep("IncendiaCameraShakePC");

            return;
        end;

        local v15 = os.clock() - os_clock_ret;

        if v15 >= 0.42 then
            RunService:UnbindFromRenderStep("IncendiaCameraShakePC");

            return;
        end;

        local workspace_CurrentCamera = workspace.CurrentCamera;

        if not workspace_CurrentCamera then
            return;
        end;

        local v16 = 1 - v15 / 0.42;
        local v17 = v15 * 42;
        local math_noise_ret = math.noise(v17, 0, 0);
        local math_noise_ret2 = math.noise(0, v17, 0);
        local math_noise_ret3 = math.noise(0, 0, v17);
        workspace_CurrentCamera.CFrame = workspace_CurrentCamera.CFrame * CFrame.new(math_noise_ret * 0.22 * v16, math_noise_ret2 * 0.22 * v16, 0) * CFrame.Angles(math_noise_ret2 * 0.026179938779914945 * v16, math_noise_ret * 0.026179938779914945 * v16, math_noise_ret3 * 0.014398966328953218 * v16);
    end);
end;

local function getCharacterParts() -- Line: 75
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;
    local v18;

    if Character then
        v18 = Character:FindFirstChildOfClass("Humanoid");
    else
        v18 = Character;
    end;

    local v19;

    if Character then
        v19 = Character:FindFirstChild("HumanoidRootPart");
    else
        v19 = Character;
    end;

    if not (Character and (v18 and (v18.Health > 0 and v19))) then
        return nil;
    end;

    if Character:GetAttribute("ActionLocked") == true or (Character:GetAttribute("Hibernating") == true or (Character:GetAttribute("Ragdolled") == true or (Character:GetAttribute("SoulDrainActive") == true or Character:GetAttribute("FlyingBroom") == true))) then
        return nil;
    end;

    return Character, v18, v19;
end;

local function setButtonState() -- Line: 91
    -- upvalues: u11 (ref), LocalPlayer (copy), u10 (ref), Incendia (copy), u6 (copy), u7 (copy), u8 (ref), u2 (copy), u3 (copy), u4 (copy), u5 (copy), BackgroundColor3 (copy), BackgroundTransparency (copy)
    local v20 = u11 - workspace:GetServerTimeNow();
    local math_max_ret = math.max(0, v20);
    local u21;

    if LocalPlayer.Team == nil then
        u21 = false;
    else
        u21 = LocalPlayer.Team.Name == "Witches";
    end;

    if u21 then
        if math_max_ret <= 0 then
            u21 = not u10;
        else
            u21 = false;
        end;
    end;

    local v22;

    if LocalPlayer.Team == nil then
        v22 = false;
    else
        v22 = LocalPlayer.Team.Name == "Witches";
    end;

    Incendia.Visible = v22;
    Incendia.Active = u21;
    pcall(function() -- Line: 96
        -- upvalues: Incendia (ref), u21 (copy)
        Incendia.Interactable = u21;
    end);

    if Incendia:IsA("GuiButton") then
        if u21 then
            u21 = u6;
        end;

        Incendia.AutoButtonColor = u21;
    end;

    if u7 and u7:IsA("TextLabel") then
        u7.Visible = math_max_ret > 0;
        local v23;

        if math_max_ret > 0 then
            local math_ceil_ret = math.ceil(math_max_ret);
            v23 = tostring(math_ceil_ret) or "";
        else
            v23 = "";
        end;

        u7.Text = v23;
    end;

    Incendia:SetAttribute("PowerCooldown", (math.ceil(math_max_ret)));

    if u8 or (math_max_ret > 0 or u10) then
        if Incendia:IsA("TextLabel") then
            Incendia.TextColor3 = u2:Lerp(Color3.new(0, 0, 0), 0.62);
            Incendia.TextTransparency = math.min(0.82, u3 + 0.25);
        elseif Incendia:IsA("ImageButton") then
            Incendia.ImageColor3 = u4:Lerp(Color3.new(0, 0, 0), 0.6);
            Incendia.ImageTransparency = math.min(0.88, u5 + 0.08);
        end;

        Incendia.BackgroundColor3 = BackgroundColor3:Lerp(Color3.new(0, 0, 0), 0.58);
    else
        if Incendia:IsA("TextLabel") then
            Incendia.TextColor3 = u2;
            Incendia.TextTransparency = u3;
        elseif Incendia:IsA("ImageButton") then
            Incendia.ImageColor3 = u4;
            Incendia.ImageTransparency = u5;
        end;

        Incendia.BackgroundColor3 = BackgroundColor3;
    end;

    Incendia.BackgroundTransparency = BackgroundTransparency;
end;

local function stopAiming(p24) -- Line: 128
    -- upvalues: u8 (ref), Event (copy), setButtonState (copy)
    local v25 = u8;
    u8 = false;

    if v25 then
        Event:FireServer("Disarm", p24 == true);
    end;

    setButtonState();
end;

local function beginAiming() -- Line: 137
    -- upvalues: TeamGuiLayout (copy), Incendia (copy), u8 (ref), Event (copy), setButtonState (copy), u10 (ref), u11 (ref), LocalPlayer (copy), getCharacterParts (copy), u9 (ref), Incendia2 (copy)
    if not TeamGuiLayout.IsVisible(Incendia) then
        return;
    end;

    if not u8 then
        if not u10 and workspace:GetServerTimeNow() >= u11 then
            local v26;

            if LocalPlayer.Team == nil then
                v26 = false;
            else
                v26 = LocalPlayer.Team.Name == "Witches";
            end;

            if v26 then
                if not getCharacterParts() then
                    return;
                end;

                u8 = true;
                u9 = os.clock();
                Event:FireServer("Arm");
                setButtonState();
                task.delay(Incendia2.AimTimeout, function() -- Line: 149
                    -- upvalues: u8 (ref), u9 (ref), Incendia2 (ref), Event (ref), setButtonState (ref)
                    if u8 and os.clock() - u9 >= Incendia2.AimTimeout - 0.1 then
                        local v27 = u8;
                        u8 = false;

                        if v27 then
                            Event:FireServer("Disarm", true);
                        end;

                        setButtonState();
                    end;
                end);

                return;
            end;
        end;

        return;
    end;

    local v28 = u8;
    u8 = false;

    if v28 then
        Event:FireServer("Disarm", true);
    end;

    setButtonState();
end;

local function findHumanoidModel(p29) -- Line: 156
    while p29 and p29 ~= workspace do
        if p29:IsA("Model") and p29:FindFirstChildOfClass("Humanoid") then
            return p29;
        end;

        p29 = p29.Parent;
    end;

    return nil;
end;

local function castAtMouse() -- Line: 167
    -- upvalues: u8 (ref), u10 (ref), u9 (ref), Mouse (copy), Event (copy), setButtonState (copy), findHumanoidModel (copy)
    if not (u8 and (not u10 and os.clock() - u9 >= 0.15)) then
        return;
    end;

    local Target = Mouse.Target;
    local Hit = Mouse.Hit;

    if not (Target and Hit) then
        local v30 = u8;
        u8 = false;

        if v30 then
            Event:FireServer("Disarm", true);
        end;

        setButtonState();

        return;
    end;

    local v31 = findHumanoidModel(Target);
    u10 = true;
    local v32 = u8;
    u8 = false;

    if v32 then
        Event:FireServer("Disarm", false);
    end;

    setButtonState();
    setButtonState();
    Event:FireServer("Cast", Hit.Position, v31);
    task.delay(2, function() -- Line: 180
        -- upvalues: u10 (ref), setButtonState (ref)
        if u10 then
            u10 = false;
            setButtonState();
        end;
    end);
end;

local function activateFromUi() -- Line: 188
    -- upvalues: beginAiming (copy)
    beginAiming();
end;

if Incendia:IsA("GuiButton") then
    Incendia.Activated:Connect(activateFromUi);
else
    Incendia.InputBegan:Connect(function(p33) -- Line: 195
        -- upvalues: beginAiming (copy)
        if p33.UserInputType == Enum.UserInputType.MouseButton1 or p33.UserInputType == Enum.UserInputType.Touch then
            beginAiming();
        end;
    end);
end;

UserInputService.InputBegan:Connect(function(p34, p35) -- Line: 204
    -- upvalues: TeamGuiLayout (copy), UserInputService (copy), beginAiming (copy), u8 (ref), castAtMouse (copy)
    if TeamGuiLayout.GetMode() ~= "PC" or UserInputService:GetFocusedTextBox() then
        return;
    end;

    if p34.KeyCode == Enum.KeyCode.E and not p35 then
        beginAiming();

        return;
    end;

    if u8 and not (p35 or p34.UserInputType ~= Enum.UserInputType.MouseButton1 and p34.UserInputType ~= Enum.UserInputType.Touch) then
        castAtMouse();
    end;
end);
IncendiaRemote.OnClientEvent:Connect(function(p36, p37, p38) -- Line: 216
    -- upvalues: u8 (ref), Event (copy), setButtonState (copy), u10 (ref), u11 (ref), Incendia2 (copy), TeamGuiLayout (copy), shakeCamera (copy)
    if p36 == "CastAccepted" then
        local v39 = u8;
        u8 = false;

        if v39 then
            Event:FireServer("Disarm", false);
        end;

        setButtonState();
        u10 = false;
        u11 = tonumber(p37) or workspace:GetServerTimeNow() + Incendia2.Cooldown;

        if TeamGuiLayout.GetMode() == "PC" then
            shakeCamera();
        end;
    elseif p36 == "Rejected" then
        local v40 = u8;
        u8 = false;

        if v40 then
            Event:FireServer("Disarm", false);
        end;

        setButtonState();
        u10 = false;

        if tonumber(p38) then
            u11 = tonumber(p38);
        end;
    end;

    setButtonState();
end);
local u41 = 0;
RunService.RenderStepped:Connect(function(p42) -- Line: 231
    -- upvalues: u41 (ref), u8 (ref), LocalPlayer (copy), TeamGuiLayout (copy), Event (copy), setButtonState (copy)
    u41 = u41 + p42;

    if u41 < 0.05 then
        return;
    end;

    u41 = 0;

    if u8 then
        local v43;

        if LocalPlayer.Team == nil then
            v43 = false;
        else
            v43 = LocalPlayer.Team.Name == "Witches";
        end;

        if not v43 or TeamGuiLayout.GetMode() ~= "PC" then
            local v44 = u8;
            u8 = false;

            if v44 then
                Event:FireServer("Disarm", false);
            end;

            setButtonState();
        end;
    end;

    setButtonState();
end);
LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function() -- Line: 239
    -- upvalues: LocalPlayer (copy), u8 (ref), Event (copy), setButtonState (copy)
    local v45;

    if LocalPlayer.Team == nil then
        v45 = false;
    else
        v45 = LocalPlayer.Team.Name == "Witches";
    end;

    if not v45 then
        local v46 = u8;
        u8 = false;

        if v46 then
            Event:FireServer("Disarm", false);
        end;

        setButtonState();
    end;

    setButtonState();
end);
LocalPlayer.CharacterAdded:Connect(function() -- Line: 243
    -- upvalues: u8 (ref), Event (copy), setButtonState (copy)
    local v47 = u8;
    u8 = false;

    if v47 then
        Event:FireServer("Disarm", false);
    end;

    setButtonState();
end);
setButtonState();
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

local function getConsoleAim() -- Line: 21
    -- upvalues: LocalPlayer (copy), Incendia2 (copy)
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if not workspace_CurrentCamera then
        return nil, nil;
    end;

    local ViewportSize = workspace_CurrentCamera.ViewportSize;
    local v2 = workspace_CurrentCamera:ViewportPointToRay(ViewportSize.X * 0.5, ViewportSize.Y * 0.5);
    local RaycastParams_new_ret = RaycastParams.new();
    RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
    RaycastParams_new_ret.FilterDescendantsInstances = LocalPlayer.Character and { LocalPlayer.Character } or {};
    RaycastParams_new_ret.IgnoreWater = true;
    local v3 = workspace:Raycast(v2.Origin, v2.Direction * (Incendia2.MaximumDistance or 80), RaycastParams_new_ret);

    if v3 then
        return v3.Instance, v3.Position;
    end;

    return nil, v2.Origin + v2.Direction * (Incendia2.MaximumDistance or 80);
end;

Incendia.Active = true;
local u4 = Incendia:IsA("TextLabel") and Incendia.TextColor3 or Color3.new(1, 1, 1);
local u5 = Incendia:IsA("TextLabel") and (Incendia.TextTransparency or 0) or 0;
local u6 = Incendia:IsA("ImageButton") and Incendia.ImageColor3 or Color3.new(1, 1, 1);
local u7 = Incendia:IsA("ImageButton") and (Incendia.ImageTransparency or 0) or 0;
local BackgroundColor3 = Incendia.BackgroundColor3;
local BackgroundTransparency = Incendia.BackgroundTransparency;
local u8;

if Incendia:IsA("GuiButton") then
    u8 = Incendia.AutoButtonColor or false;
else
    u8 = false;
end;

local u9 = Incendia:FindFirstChild("COLDOWN") or Incendia:FindFirstChild("Coldown");

if u9 and u9:IsA("TextLabel") then
    u9.Visible = false;
    u9.Text = "";
end;

local u10 = false;
local u11 = 0;
local u12 = false;
local u13 = 0;
local u14 = 0;

local function isWitch() -- Line: 55
    -- upvalues: LocalPlayer (copy)
    local v15;

    if LocalPlayer.Team == nil then
        v15 = false;
    else
        v15 = LocalPlayer.Team.Name == "Witches";
    end;

    return v15;
end;

local function shakeCamera() -- Line: 59
    -- upvalues: u14 (ref), RunService (copy)
    u14 = u14 + 1;
    local u16 = u14;
    local os_clock_ret = os.clock();
    RunService:UnbindFromRenderStep("IncendiaCameraShakePC");
    RunService:BindToRenderStep("IncendiaCameraShakePC", Enum.RenderPriority.Camera.Value + 1, function() -- Line: 66
        -- upvalues: u16 (copy), u14 (ref), RunService (ref), os_clock_ret (copy)
        if u16 ~= u14 then
            RunService:UnbindFromRenderStep("IncendiaCameraShakePC");

            return;
        end;

        local v17 = os.clock() - os_clock_ret;

        if v17 >= 0.42 then
            RunService:UnbindFromRenderStep("IncendiaCameraShakePC");

            return;
        end;

        local workspace_CurrentCamera = workspace.CurrentCamera;

        if not workspace_CurrentCamera then
            return;
        end;

        local v18 = 1 - v17 / 0.42;
        local v19 = v17 * 42;
        local math_noise_ret = math.noise(v19, 0, 0);
        local math_noise_ret2 = math.noise(0, v19, 0);
        local math_noise_ret3 = math.noise(0, 0, v19);
        workspace_CurrentCamera.CFrame = workspace_CurrentCamera.CFrame * CFrame.new(math_noise_ret * 0.22 * v18, math_noise_ret2 * 0.22 * v18, 0) * CFrame.Angles(math_noise_ret2 * 0.026179938779914945 * v18, math_noise_ret * 0.026179938779914945 * v18, math_noise_ret3 * 0.014398966328953218 * v18);
    end);
end;

local function getCharacterParts() -- Line: 89
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;
    local v20;

    if Character then
        v20 = Character:FindFirstChildOfClass("Humanoid");
    else
        v20 = Character;
    end;

    local v21;

    if Character then
        v21 = Character:FindFirstChild("HumanoidRootPart");
    else
        v21 = Character;
    end;

    if not (Character and (v20 and (v20.Health > 0 and v21))) then
        return nil;
    end;

    if Character:GetAttribute("ActionLocked") == true or (Character:GetAttribute("Hibernating") == true or (Character:GetAttribute("Ragdolled") == true or (Character:GetAttribute("SoulDrainActive") == true or Character:GetAttribute("FlyingBroom") == true))) then
        return nil;
    end;

    return Character, v20, v21;
end;

local function setButtonState() -- Line: 105
    -- upvalues: u13 (ref), LocalPlayer (copy), u12 (ref), Incendia (copy), u8 (copy), u9 (copy), u10 (ref), u4 (copy), u5 (copy), u6 (copy), u7 (copy), BackgroundColor3 (copy), BackgroundTransparency (copy)
    local v22 = u13 - workspace:GetServerTimeNow();
    local math_max_ret = math.max(0, v22);
    local u23;

    if LocalPlayer.Team == nil then
        u23 = false;
    else
        u23 = LocalPlayer.Team.Name == "Witches";
    end;

    if u23 then
        if math_max_ret <= 0 then
            u23 = not u12;
        else
            u23 = false;
        end;
    end;

    local v24;

    if LocalPlayer.Team == nil then
        v24 = false;
    else
        v24 = LocalPlayer.Team.Name == "Witches";
    end;

    Incendia.Visible = v24;
    Incendia.Active = u23;
    pcall(function() -- Line: 110
        -- upvalues: Incendia (ref), u23 (copy)
        Incendia.Interactable = u23;
    end);

    if Incendia:IsA("GuiButton") then
        if u23 then
            u23 = u8;
        end;

        Incendia.AutoButtonColor = u23;
    end;

    if u9 and u9:IsA("TextLabel") then
        u9.Visible = math_max_ret > 0;
        local v25;

        if math_max_ret > 0 then
            local math_ceil_ret = math.ceil(math_max_ret);
            v25 = tostring(math_ceil_ret) or "";
        else
            v25 = "";
        end;

        u9.Text = v25;
    end;

    Incendia:SetAttribute("PowerCooldown", (math.ceil(math_max_ret)));

    if u10 or (math_max_ret > 0 or u12) then
        if Incendia:IsA("TextLabel") then
            Incendia.TextColor3 = u4:Lerp(Color3.new(0, 0, 0), 0.62);
            Incendia.TextTransparency = math.min(0.82, u5 + 0.25);
        elseif Incendia:IsA("ImageButton") then
            Incendia.ImageColor3 = u6:Lerp(Color3.new(0, 0, 0), 0.6);
            Incendia.ImageTransparency = math.min(0.88, u7 + 0.08);
        end;

        Incendia.BackgroundColor3 = BackgroundColor3:Lerp(Color3.new(0, 0, 0), 0.58);
    else
        if Incendia:IsA("TextLabel") then
            Incendia.TextColor3 = u4;
            Incendia.TextTransparency = u5;
        elseif Incendia:IsA("ImageButton") then
            Incendia.ImageColor3 = u6;
            Incendia.ImageTransparency = u7;
        end;

        Incendia.BackgroundColor3 = BackgroundColor3;
    end;

    Incendia.BackgroundTransparency = BackgroundTransparency;
end;

local function stopAiming(p26) -- Line: 142
    -- upvalues: u10 (ref), Event (copy), setButtonState (copy)
    local v27 = u10;
    u10 = false;

    if v27 then
        Event:FireServer("Disarm", p26 == true);
    end;

    setButtonState();
end;

local function beginAiming() -- Line: 151
    -- upvalues: TeamGuiLayout (copy), Incendia (copy), u10 (ref), Event (copy), setButtonState (copy), u12 (ref), u13 (ref), LocalPlayer (copy), getCharacterParts (copy), u11 (ref), Incendia2 (copy)
    if not TeamGuiLayout.IsVisible(Incendia) then
        return;
    end;

    if not u10 then
        if not u12 and workspace:GetServerTimeNow() >= u13 then
            local v28;

            if LocalPlayer.Team == nil then
                v28 = false;
            else
                v28 = LocalPlayer.Team.Name == "Witches";
            end;

            if v28 then
                if not getCharacterParts() then
                    return;
                end;

                u10 = true;
                u11 = os.clock();
                Event:FireServer("Arm");
                setButtonState();
                task.delay(Incendia2.AimTimeout, function() -- Line: 163
                    -- upvalues: u10 (ref), u11 (ref), Incendia2 (ref), Event (ref), setButtonState (ref)
                    if u10 and os.clock() - u11 >= Incendia2.AimTimeout - 0.1 then
                        local v29 = u10;
                        u10 = false;

                        if v29 then
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

    local v30 = u10;
    u10 = false;

    if v30 then
        Event:FireServer("Disarm", true);
    end;

    setButtonState();
end;

local function findHumanoidModel(p31) -- Line: 170
    while p31 and p31 ~= workspace do
        if p31:IsA("Model") and p31:FindFirstChildOfClass("Humanoid") then
            return p31;
        end;

        p31 = p31.Parent;
    end;

    return nil;
end;

local function castAtMouse() -- Line: 181
    -- upvalues: u10 (ref), u12 (ref), u11 (ref), TeamGuiLayout (copy), getConsoleAim (copy), Mouse (copy), Event (copy), setButtonState (copy), findHumanoidModel (copy)
    if not (u10 and (not u12 and os.clock() - u11 >= 0.15)) then
        return;
    end;

    local v32, v33;

    if TeamGuiLayout.GetMode() == "CONSOLE" then
        v32, v33 = getConsoleAim();
    else
        v32 = Mouse.Target;
        v33 = Mouse.Hit and Mouse.Hit.Position or nil;
    end;

    if not v33 then
        local v34 = u10;
        u10 = false;

        if v34 then
            Event:FireServer("Disarm", true);
        end;

        setButtonState();

        return;
    end;

    local v35 = v32 and findHumanoidModel(v32) or nil;
    u12 = true;
    local v36 = u10;
    u10 = false;

    if v36 then
        Event:FireServer("Disarm", false);
    end;

    setButtonState();
    setButtonState();
    Event:FireServer("Cast", v33, v35);
    task.delay(2, function() -- Line: 199
        -- upvalues: u12 (ref), setButtonState (ref)
        if u12 then
            u12 = false;
            setButtonState();
        end;
    end);
end;

local function activateFromUi() -- Line: 207
    -- upvalues: beginAiming (copy)
    beginAiming();
end;

if Incendia:IsA("GuiButton") then
    Incendia.Activated:Connect(activateFromUi);
else
    Incendia.InputBegan:Connect(function(p37) -- Line: 214
        -- upvalues: beginAiming (copy)
        if p37.UserInputType == Enum.UserInputType.MouseButton1 or p37.UserInputType == Enum.UserInputType.Touch then
            beginAiming();
        end;
    end);
end;

UserInputService.InputBegan:Connect(function(p38, p39) -- Line: 223
    -- upvalues: TeamGuiLayout (copy), UserInputService (copy), u10 (ref), castAtMouse (copy), beginAiming (copy)
    if TeamGuiLayout.GetMode() ~= "CONSOLE" or UserInputService:GetFocusedTextBox() then
        return;
    end;

    if p38.KeyCode ~= Enum.KeyCode.DPadLeft or p39 then
        if u10 and (not p39 and p38.KeyCode == Enum.KeyCode.ButtonA) then
            castAtMouse();
        end;

        return;
    end;

    if u10 then
        castAtMouse();

        return;
    end;

    beginAiming();
end);
IncendiaRemote.OnClientEvent:Connect(function(p40, p41, p42) -- Line: 236
    -- upvalues: u10 (ref), Event (copy), setButtonState (copy), u12 (ref), u13 (ref), Incendia2 (copy), TeamGuiLayout (copy), shakeCamera (copy)
    if p40 == "CastAccepted" then
        local v43 = u10;
        u10 = false;

        if v43 then
            Event:FireServer("Disarm", false);
        end;

        setButtonState();
        u12 = false;
        u13 = tonumber(p41) or workspace:GetServerTimeNow() + Incendia2.Cooldown;

        if TeamGuiLayout.GetMode() == "CONSOLE" then
            shakeCamera();
        end;
    elseif p40 == "Rejected" then
        local v44 = u10;
        u10 = false;

        if v44 then
            Event:FireServer("Disarm", false);
        end;

        setButtonState();
        u12 = false;

        if tonumber(p42) then
            u13 = tonumber(p42);
        end;
    end;

    setButtonState();
end);
local u45 = 0;
RunService.RenderStepped:Connect(function(p46) -- Line: 251
    -- upvalues: u45 (ref), u10 (ref), LocalPlayer (copy), TeamGuiLayout (copy), Event (copy), setButtonState (copy)
    u45 = u45 + p46;

    if u45 < 0.05 then
        return;
    end;

    u45 = 0;

    if u10 then
        local v47;

        if LocalPlayer.Team == nil then
            v47 = false;
        else
            v47 = LocalPlayer.Team.Name == "Witches";
        end;

        if not v47 or TeamGuiLayout.GetMode() ~= "CONSOLE" then
            local v48 = u10;
            u10 = false;

            if v48 then
                Event:FireServer("Disarm", false);
            end;

            setButtonState();
        end;
    end;

    setButtonState();
end);
LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function() -- Line: 259
    -- upvalues: LocalPlayer (copy), u10 (ref), Event (copy), setButtonState (copy)
    local v49;

    if LocalPlayer.Team == nil then
        v49 = false;
    else
        v49 = LocalPlayer.Team.Name == "Witches";
    end;

    if not v49 then
        local v50 = u10;
        u10 = false;

        if v50 then
            Event:FireServer("Disarm", false);
        end;

        setButtonState();
    end;

    setButtonState();
end);
LocalPlayer.CharacterAdded:Connect(function() -- Line: 263
    -- upvalues: u10 (ref), Event (copy), setButtonState (copy)
    local v51 = u10;
    u10 = false;

    if v51 then
        Event:FireServer("Disarm", false);
    end;

    setButtonState();
end);
setButtonState();
-- Decompiled with Potassium's decompiler.

local TeamGuiLayout = require(game:GetService("ReplicatedStorage"):WaitForChild("TeamGuiLayout"));
local UserInputService = game:GetService("UserInputService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer;
local NetworkRegistry = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("NetworkRegistry"));
local Event = NetworkRegistry.GetEvent("Combat", "WitchHeartRippingRequest");
local WitchHeartRippingRemote = NetworkRegistry.Legacy.Events:WaitForChild("WitchHeartRippingRemote");
local HeartRipping = require(ReplicatedStorage:WaitForChild("Funções"):WaitForChild("WitchSpellsConfig")).HeartRipping;
local u1 = false;
local u2 = 0;
local u3 = nil;
local u4 = nil;
local u5 = 0;

local function isWitch() -- Line: 19
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer.Team and LocalPlayer.Team.Name == "Witches";
end;

local function getYears() -- Line: 23
    -- upvalues: LocalPlayer (copy)
    local v6 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
    local math_floor_ret = math.floor(v6);

    return math.max(0, math_floor_ret);
end;

local function findButton() -- Line: 27
    -- upvalues: LocalPlayer (copy), TeamGuiLayout (copy)
    local v7 = LocalPlayer:FindFirstChildOfClass("PlayerGui");

    if not v7 then
        return nil;
    end;

    local v8 = "Witches" .. TeamGuiLayout.GetMode();
    local v9 = TeamGuiLayout.FindPanel(v7, v8);

    if v9 then
        v9 = TeamGuiLayout.GetMenu(v9);
    end;

    if v9 then
        v9 = v9:FindFirstChild("Powers1") or v9:FindFirstChild("Powers");
    end;

    if v9 then
        v9 = v9:FindFirstChild("Heart-Ripping");
    end;

    if not (v9 and (v9:IsA("GuiObject") and v9)) then
        v9 = nil;
    end;

    return v9;
end;

local function refreshButton() -- Line: 38
    -- upvalues: u3 (ref), u4 (ref), LocalPlayer (copy), HeartRipping (copy), u2 (ref), u1 (ref), TeamGuiLayout (copy)
    if not (u3 and (u3.Parent and u4)) then
        return;
    end;

    local u10 = LocalPlayer.Team and LocalPlayer.Team.Name == "Witches";
    local v11 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
    local math_floor_ret = math.floor(v11);
    local u12 = math.max(0, math_floor_ret) >= HeartRipping.UnlockYears;
    local v13 = u2 - workspace:GetServerTimeNow();
    local math_max_ret = math.max(0, v13);
    local u14 = u1 or math_max_ret > 0;
    u3.Visible = u10;
    local v15;

    if u10 then
        if u12 then
            v15 = not u14;
        else
            v15 = u12;
        end;
    else
        v15 = u10;
    end;

    u3.Active = v15;

    if u3:IsA("GuiButton") then
        u3.AutoButtonColor = u10 and (u12 and not u14) and u4.autoButtonColor;
    end;

    pcall(function() -- Line: 52
        -- upvalues: u3 (ref), u10 (copy), u12 (copy), u14 (copy)
        u3.Interactable = u10 and u12 and not u14;
    end);
    local v16 = LocalPlayer:FindFirstChildOfClass("PlayerGui");

    if v16 then
        for _, v in ipairs({ "WitchesPC", "WitchesMOBILE", "WitchesCONSOLE" }) do
            local v17 = TeamGuiLayout.FindPanel(v16, v);

            if v17 then
                v17 = TeamGuiLayout.GetMenu(v17);
            end;

            if v17 then
                v17 = v17:FindFirstChild("Powers1") or v17:FindFirstChild("Powers");
            end;

            if v17 then
                v17 = v17:FindFirstChild("Heart-Ripping");
            end;

            if v17 then
                v17 = v17:FindFirstChild("UNLOCKLV") or v17:FindFirstChild("UnlockRequirement");
            end;

            if v17 and v17:IsA("TextLabel") then
                local v18;

                if u10 then
                    v18 = not u12;
                else
                    v18 = u10;
                end;

                v17.Visible = v18;
                v17.Text = "+" .. tostring(HeartRipping.UnlockYears);
            end;
        end;
    end;

    local v19 = u3:FindFirstChild("COLDOWN") or u3:FindFirstChild("Coldown");

    if not v19 and u3:IsA("GuiButton") then
        v19 = u3:FindFirstChild("CooldownText");

        if not v19 then
            v19 = Instance.new("TextLabel");
            v19.Name = "CooldownText";
            v19.BackgroundTransparency = 1;
            v19.AnchorPoint = Vector2.new(0.5, 0.5);
            v19.Position = UDim2.fromScale(0.5, 0.5);
            v19.Size = UDim2.fromScale(0.55, 0.55);
            v19.Font = Enum.Font.JosefinSans;
            v19.TextColor3 = Color3.new(1, 1, 1);
            v19.TextScaled = true;
            v19.TextStrokeTransparency = 0.2;
            v19.ZIndex = u3.ZIndex + 4;
            v19.Parent = u3;
        end;
    end;

    if v19 and v19:IsA("TextLabel") then
        if u10 then
            u10 = math_max_ret > 0;
        end;

        v19.Visible = u10;
        local v20;

        if math_max_ret > 0 then
            local math_ceil_ret = math.ceil(math_max_ret);
            v20 = tostring(math_ceil_ret) or "";
        else
            v20 = "";
        end;

        v19.Text = v20;
    end;

    u3:SetAttribute("PowerCooldown", (math.ceil(math_max_ret)));

    if u14 or not u12 then
        if u3:IsA("TextLabel") then
            u3.TextColor3 = u4.textColor:Lerp(Color3.new(0, 0, 0), 0.62);
            u3.TextTransparency = math.min(0.82, u4.textTransparency + 0.25);
        elseif u3:IsA("ImageButton") then
            u3.ImageColor3 = u4.imageColor:Lerp(Color3.new(0, 0, 0), 0.6);
            u3.ImageTransparency = math.min(0.88, u4.imageTransparency + 0.08);
        end;

        u3.BackgroundColor3 = u4.backgroundColor;

        return;
    end;

    if u3:IsA("TextLabel") then
        u3.TextColor3 = u4.textColor;
        u3.TextTransparency = u4.textTransparency;
    elseif u3:IsA("ImageButton") then
        u3.ImageColor3 = u4.imageColor;
        u3.ImageTransparency = u4.imageTransparency;
    end;

    u3.BackgroundColor3 = u4.backgroundColor;
end;

local function scheduleCooldownRefresh() -- Line: 114
    -- upvalues: u5 (ref), u2 (ref), u1 (ref), refreshButton (copy)
    u5 = u5 + 1;
    local u21 = u5;
    local v22 = u2 - workspace:GetServerTimeNow();
    local math_max_ret = math.max(0, v22);
    task.delay(math_max_ret + 0.05, function() -- Line: 118
        -- upvalues: u21 (copy), u5 (ref), u1 (ref), refreshButton (ref)
        if u21 == u5 then
            u1 = false;
            refreshButton();
        end;
    end);
end;

local function tryHeartRipping() -- Line: 126
    -- upvalues: LocalPlayer (copy), HeartRipping (copy), u1 (ref), u2 (ref), refreshButton (copy), Event (copy)
    if LocalPlayer.Team and LocalPlayer.Team.Name == "Witches" then
        local v23 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
        local math_floor_ret = math.floor(v23);

        if math.max(0, math_floor_ret) >= HeartRipping.UnlockYears and (not u1 and workspace:GetServerTimeNow() >= u2) then
            u1 = true;
            refreshButton();
            Event:FireServer();
            task.delay(1.5, function() -- Line: 133
                -- upvalues: u1 (ref), u2 (ref), refreshButton (ref)
                if u1 and u2 <= workspace:GetServerTimeNow() then
                    u1 = false;
                    refreshButton();
                end;
            end);
        end;
    end;
end;

UserInputService.InputBegan:Connect(function(p24, p25) -- Line: 141
    -- upvalues: UserInputService (copy), tryHeartRipping (copy)
    if p25 or UserInputService:GetFocusedTextBox() then
        return;
    end;

    if p24.KeyCode == Enum.KeyCode.X or p24.KeyCode == Enum.KeyCode.DPadDown then
        tryHeartRipping();
    end;
end);
WitchHeartRippingRemote.OnClientEvent:Connect(function(p26, p27, p28) -- Line: 148
    -- upvalues: u2 (ref), HeartRipping (copy), u1 (ref), refreshButton (copy), u5 (ref)
    if p26 ~= "Started" then
        if p26 == "Rejected" then
            if p27 == "Cooldown" then
                u2 = tonumber(p28) or u2;
            end;

            u1 = false;
            refreshButton();

            if workspace:GetServerTimeNow() < u2 then
                u5 = u5 + 1;
                local u29 = u5;
                local v30 = u2 - workspace:GetServerTimeNow();
                local math_max_ret = math.max(0, v30);
                task.delay(math_max_ret + 0.05, function() -- Line: 118
                    -- upvalues: u29 (copy), u5 (ref), u1 (ref), refreshButton (ref)
                    if u29 == u5 then
                        u1 = false;
                        refreshButton();
                    end;
                end);
            end;
        end;

        return;
    end;

    u2 = tonumber(p27) or workspace:GetServerTimeNow() + HeartRipping.Cooldown;
    u1 = false;
    refreshButton();
    u5 = u5 + 1;
    local u31 = u5;
    local v32 = u2 - workspace:GetServerTimeNow();
    local math_max_ret = math.max(0, v32);
    task.delay(math_max_ret + 0.05, function() -- Line: 118
        -- upvalues: u31 (copy), u5 (ref), u1 (ref), refreshButton (ref)
        if u31 == u5 then
            u1 = false;
            refreshButton();
        end;
    end);
end);

local function refreshBinding() -- Line: 166
    -- upvalues: LocalPlayer (copy), u1 (ref), refreshButton (copy)
    if not (LocalPlayer.Team and LocalPlayer.Team.Name == "Witches") then
        u1 = false;
    end;

    refreshButton();
end;

local function bindButton() -- Line: 171
    -- upvalues: findButton (copy), u3 (ref), u4 (ref), TeamGuiLayout (copy), tryHeartRipping (copy), refreshButton (copy)
    local u33 = findButton();

    if not u33 or u33 == u3 then
        return;
    end;

    u3 = u33;
    u33.Active = true;
    local v34 = {
        textColor = u33:IsA("TextLabel") and u33.TextColor3 or Color3.new(1, 1, 1),
        textTransparency = u33:IsA("TextLabel") and (u33.TextTransparency or 0) or 0,
        imageColor = u33:IsA("ImageButton") and u33.ImageColor3 or Color3.new(1, 1, 1),
        imageTransparency = u33:IsA("ImageButton") and (u33.ImageTransparency or 0) or 0,
        backgroundColor = u33.BackgroundColor3
    };
    local v35;

    if u33:IsA("GuiButton") then
        v35 = u33.AutoButtonColor or false;
    else
        v35 = false;
    end;

    v34.autoButtonColor = v35;
    u4 = v34;

    local function activateFromUi() -- Line: 184
        -- upvalues: u33 (copy), TeamGuiLayout (ref), tryHeartRipping (ref)
        local v36 = u33:FindFirstAncestorOfClass("ScreenGui");

        if v36 and (v36.Enabled and TeamGuiLayout.IsVisible(u33)) then
            tryHeartRipping();
        end;
    end;

    if u33:IsA("GuiButton") then
        u33.Activated:Connect(activateFromUi);
    else
        u33.InputBegan:Connect(function(p37) -- Line: 193
            -- upvalues: u33 (copy), TeamGuiLayout (ref), tryHeartRipping (ref)
            if p37.UserInputType == Enum.UserInputType.MouseButton1 or p37.UserInputType == Enum.UserInputType.Touch then
                local v38 = u33:FindFirstAncestorOfClass("ScreenGui");

                if v38 and (v38.Enabled and TeamGuiLayout.IsVisible(u33)) then
                    tryHeartRipping();
                end;
            end;
        end);
    end;

    refreshButton();
end;

LocalPlayer:GetPropertyChangedSignal("Team"):Connect(refreshBinding);
LocalPlayer:GetAttributeChangedSignal("Years"):Connect(refreshBinding);
LocalPlayer.CharacterAdded:Connect(function() -- Line: 206
    -- upvalues: u1 (ref), LocalPlayer (copy), refreshButton (copy)
    u1 = false;

    if not (LocalPlayer.Team and LocalPlayer.Team.Name == "Witches") then
        u1 = false;
    end;

    refreshButton();
end);
LocalPlayer:WaitForChild("PlayerGui").DescendantAdded:Connect(function(p39) -- Line: 212
    -- upvalues: bindButton (copy)
    if p39.Name == "Heart-Ripping" and p39:IsA("GuiObject") then
        task.defer(bindButton);
    end;
end);
bindButton();

if not (LocalPlayer.Team and LocalPlayer.Team.Name == "Witches") then
    u1 = false;
end;

refreshButton();
local u40 = 0;
RunService.RenderStepped:Connect(function(p41) -- Line: 224
    -- upvalues: u40 (ref), refreshButton (copy)
    u40 = u40 + p41;

    if u40 < 0.1 then
        return;
    end;

    u40 = 0;
    refreshButton();
end);
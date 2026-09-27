-- Decompiled with Potassium's decompiler.

local TeamGuiLayout = require(game:GetService("ReplicatedStorage"):WaitForChild("TeamGuiLayout"));
local UserInputService = game:GetService("UserInputService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer;
local NetworkRegistry = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("NetworkRegistry"));
local Event = NetworkRegistry.GetEvent("Combat", "WitchLifeDrainRequest");
local WitchLifeDrainRemote = NetworkRegistry.Legacy.Events:WaitForChild("WitchLifeDrainRemote");
local u1 = false;
local u2 = 0;
local u3 = nil;
local u4 = nil;
local u5 = 0;

local function findDrainButton() -- Line: 19
    -- upvalues: LocalPlayer (copy), TeamGuiLayout (copy)
    local v6 = LocalPlayer:FindFirstChildOfClass("PlayerGui");
    local Mode = TeamGuiLayout.GetMode();

    if v6 then
        v6 = TeamGuiLayout.FindPanel(v6, "Witches" .. (Mode == "CONSOLE" and "CONSOLE" or "PC"));
    end;

    if v6 then
        v6 = TeamGuiLayout.GetMenu(v6);
    end;

    if Mode == "PC" or Mode == "CONSOLE" then
        if v6 then
            v6 = v6:FindFirstChild("Powers1") or v6:FindFirstChild("Powers");
        end;
    elseif v6 then
        v6 = v6:FindFirstChild("passivas");
    end;

    if v6 then
        v6 = v6:FindFirstChild("Drain");
    end;

    if v6 and v6:IsA("GuiObject") then
        return v6;
    end;

    return nil;
end;

local function isWitch() -- Line: 37
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer.Team and LocalPlayer.Team.Name == "Witches";
end;

local function refreshDrainButton() -- Line: 41
    -- upvalues: u3 (ref), u4 (ref), u2 (ref), u1 (ref), LocalPlayer (copy)
    if not (u3 and (u3.Parent and u4)) then
        return;
    end;

    local v7 = u2 - workspace:GetServerTimeNow();
    local math_max_ret = math.max(0, v7);
    local u8 = u1 or math_max_ret > 0;
    local u9 = LocalPlayer.Team and LocalPlayer.Team.Name == "Witches";
    u3.Visible = u9;
    local v10;

    if u9 then
        v10 = not u8;
    else
        v10 = u9;
    end;

    u3.Active = v10;

    if u3:IsA("GuiButton") then
        u3.AutoButtonColor = u9 and not u8 and u4.autoButtonColor;
    end;

    pcall(function() -- Line: 56
        -- upvalues: u3 (ref), u9 (copy), u8 (copy)
        u3.Interactable = u9 and not u8;
    end);
    local v11 = u3:FindFirstChild("COLDOWN") or u3:FindFirstChild("Coldown");

    if not v11 and u3:IsA("GuiButton") then
        v11 = u3:FindFirstChild("CooldownText");

        if not v11 then
            v11 = Instance.new("TextLabel");
            v11.Name = "CooldownText";
            v11.BackgroundTransparency = 1;
            v11.AnchorPoint = Vector2.new(0.5, 0.5);
            v11.Position = UDim2.fromScale(0.5, 0.5);
            v11.Size = UDim2.fromScale(0.55, 0.55);
            v11.Font = Enum.Font.JosefinSans;
            v11.TextColor3 = Color3.new(1, 1, 1);
            v11.TextScaled = true;
            v11.TextStrokeTransparency = 0.2;
            v11.ZIndex = u3.ZIndex + 4;
            v11.Parent = u3;
        end;
    end;

    if v11 and v11:IsA("TextLabel") then
        if u9 then
            u9 = math_max_ret > 0;
        end;

        v11.Visible = u9;
        local v12;

        if math_max_ret > 0 then
            local math_ceil_ret = math.ceil(math_max_ret);
            v12 = tostring(math_ceil_ret) or "";
        else
            v12 = "";
        end;

        v11.Text = v12;
    end;

    u3:SetAttribute("PowerCooldown", (math.ceil(math_max_ret)));

    if u8 then
        if u3:IsA("TextLabel") then
            u3.TextColor3 = u4.textColor:Lerp(Color3.new(0, 0, 0), 0.62);
            u3.TextTransparency = math.min(0.82, u4.textTransparency + 0.25);
        elseif u3:IsA("ImageButton") then
            u3.ImageColor3 = u4.imageColor:Lerp(Color3.new(0, 0, 0), 0.58);
            u3.ImageTransparency = math.min(0.85, u4.imageTransparency + 0.08);
        end;

        u3.BackgroundColor3 = u4.backgroundColor:Lerp(Color3.new(0, 0, 0), 0.58);
        u3.BackgroundTransparency = u4.backgroundTransparency;

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
    u3.BackgroundTransparency = u4.backgroundTransparency;
end;

local function scheduleCooldownVisualRefresh() -- Line: 107
    -- upvalues: u5 (ref), u2 (ref), u1 (ref), refreshDrainButton (copy)
    u5 = u5 + 1;
    local u13 = u5;
    local v14 = u2 - workspace:GetServerTimeNow();
    local math_max_ret = math.max(0, v14);
    task.delay(math_max_ret + 0.05, function() -- Line: 111
        -- upvalues: u13 (copy), u5 (ref), u1 (ref), refreshDrainButton (ref)
        if u13 == u5 then
            u1 = false;
            refreshDrainButton();
        end;
    end);
end;

local function tryDrain() -- Line: 119
    -- upvalues: LocalPlayer (copy), u1 (ref), u2 (ref), refreshDrainButton (copy), Event (copy)
    if not (LocalPlayer.Team and LocalPlayer.Team.Name == "Witches" and (not u1 and workspace:GetServerTimeNow() >= u2)) then
        return;
    end;

    u1 = true;
    refreshDrainButton();
    Event:FireServer();
    task.delay(1.5, function() -- Line: 127
        -- upvalues: u1 (ref), u2 (ref), refreshDrainButton (ref)
        if u1 and u2 <= workspace:GetServerTimeNow() then
            u1 = false;
            refreshDrainButton();
        end;
    end);
end;

game:GetService("ContextActionService"):BindActionAtPriority("WitchDrainAction", function(p15, p16) -- Line: 137, Name: handleDrainAction
    -- upvalues: UserInputService (copy), LocalPlayer (copy), tryDrain (copy)
    if not UserInputService:GetFocusedTextBox() then
        if LocalPlayer.Team and LocalPlayer.Team.Name == "Witches" then
            if p16 == Enum.UserInputState.Begin then
                tryDrain();
            end;

            return Enum.ContextActionResult.Sink;
        end;
    end;

    return Enum.ContextActionResult.Pass;
end, false, 5000, Enum.KeyCode.R, Enum.KeyCode.ButtonL1);

local function refreshBinding() -- Line: 159
    -- upvalues: LocalPlayer (copy), u1 (ref), refreshDrainButton (copy)
    if not (LocalPlayer.Team and LocalPlayer.Team.Name == "Witches") then
        u1 = false;
    end;

    refreshDrainButton();
end;

WitchLifeDrainRemote.OnClientEvent:Connect(function(p17, p18, p19) -- Line: 166
    -- upvalues: u2 (ref), u1 (ref), refreshDrainButton (copy), u5 (ref)
    if p17 ~= "Started" then
        if p17 == "Rejected" then
            u2 = tonumber(p19) or u2;
            u1 = false;
            refreshDrainButton();

            if workspace:GetServerTimeNow() < u2 then
                u5 = u5 + 1;
                local u20 = u5;
                local v21 = u2 - workspace:GetServerTimeNow();
                local math_max_ret = math.max(0, v21);
                task.delay(math_max_ret + 0.05, function() -- Line: 111
                    -- upvalues: u20 (copy), u5 (ref), u1 (ref), refreshDrainButton (ref)
                    if u20 == u5 then
                        u1 = false;
                        refreshDrainButton();
                    end;
                end);
            end;
        end;

        return;
    end;

    u2 = tonumber(p18) or workspace:GetServerTimeNow() + 38;
    u1 = false;
    refreshDrainButton();
    u5 = u5 + 1;
    local u22 = u5;
    local v23 = u2 - workspace:GetServerTimeNow();
    local math_max_ret = math.max(0, v23);
    task.delay(math_max_ret + 0.05, function() -- Line: 111
        -- upvalues: u22 (copy), u5 (ref), u1 (ref), refreshDrainButton (ref)
        if u22 == u5 then
            u1 = false;
            refreshDrainButton();
        end;
    end);
end);
LocalPlayer:GetPropertyChangedSignal("Team"):Connect(refreshBinding);
LocalPlayer.CharacterAdded:Connect(function() -- Line: 183
    -- upvalues: u1 (ref), LocalPlayer (copy), refreshDrainButton (copy)
    u1 = false;

    if not (LocalPlayer.Team and LocalPlayer.Team.Name == "Witches") then
        u1 = false;
    end;

    refreshDrainButton();
end);

local function bindDrainButton() -- Line: 188
    -- upvalues: findDrainButton (copy), u3 (ref), u4 (ref), TeamGuiLayout (copy), tryDrain (copy), refreshDrainButton (copy)
    local u24 = findDrainButton();

    if not u24 or u24 == u3 then
        return;
    end;

    u3 = u24;
    u24.Active = true;
    local v25 = {
        textColor = u24:IsA("TextLabel") and u24.TextColor3 or Color3.new(1, 1, 1),
        textTransparency = u24:IsA("TextLabel") and (u24.TextTransparency or 0) or 0,
        imageColor = u24:IsA("ImageButton") and u24.ImageColor3 or Color3.new(1, 1, 1),
        imageTransparency = u24:IsA("ImageButton") and (u24.ImageTransparency or 0) or 0,
        backgroundColor = u24.BackgroundColor3,
        backgroundTransparency = u24.BackgroundTransparency
    };
    local v26;

    if u24:IsA("GuiButton") then
        v26 = u24.AutoButtonColor or false;
    else
        v26 = false;
    end;

    v25.autoButtonColor = v26;
    u4 = v25;

    local function activateFromUi() -- Line: 206
        -- upvalues: u24 (copy), TeamGuiLayout (ref), tryDrain (ref)
        local v27 = u24:FindFirstAncestorOfClass("ScreenGui");

        if v27 and (v27.Enabled and TeamGuiLayout.IsVisible(u24)) then
            tryDrain();
        end;
    end;

    if u24:IsA("GuiButton") then
        u24.Activated:Connect(activateFromUi);
    else
        u24.InputBegan:Connect(function(p28) -- Line: 215
            -- upvalues: u24 (copy), TeamGuiLayout (ref), tryDrain (ref)
            if p28.UserInputType == Enum.UserInputType.MouseButton1 or p28.UserInputType == Enum.UserInputType.Touch then
                local v29 = u24:FindFirstAncestorOfClass("ScreenGui");

                if v29 and (v29.Enabled and TeamGuiLayout.IsVisible(u24)) then
                    tryDrain();
                end;
            end;
        end);
    end;

    refreshDrainButton();
end;

LocalPlayer:WaitForChild("PlayerGui").DescendantAdded:Connect(function(p30) -- Line: 229
    -- upvalues: bindDrainButton (copy)
    if p30.Name == "Drain" and (p30:IsA("GuiObject") and (p30.Parent and (p30.Parent.Name == "Powers1" or (p30.Parent.Name == "Powers" or p30.Parent.Name == "passivas")))) then
        task.defer(bindDrainButton);
    end;
end);
bindDrainButton();

if not (LocalPlayer.Team and LocalPlayer.Team.Name == "Witches") then
    u1 = false;
end;

refreshDrainButton();
local u31 = 0;
RunService.RenderStepped:Connect(function(p32) -- Line: 245
    -- upvalues: u31 (ref), u3 (ref), u4 (ref), bindDrainButton (copy), findDrainButton (copy), refreshDrainButton (copy)
    u31 = u31 + p32;

    if u31 < 0.1 then
        return;
    end;

    u31 = 0;

    if u3 and u3.Parent then
        local v33 = findDrainButton();

        if v33 and v33 ~= u3 then
            u3 = nil;
            u4 = nil;
            bindDrainButton();
        end;
    else
        u3 = nil;
        u4 = nil;
        bindDrainButton();
    end;

    refreshDrainButton();
end);
-- Decompiled with Potassium's decompiler.

local TeamGuiLayout = require(game:GetService("ReplicatedStorage"):WaitForChild("TeamGuiLayout"));
local UserInputService = game:GetService("UserInputService");
local ContextActionService = game:GetService("ContextActionService");
local GuiService = game:GetService("GuiService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer;
local NetworkRegistry = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("NetworkRegistry"));
local Event = NetworkRegistry.GetEvent("Combat", "WitchBreakNeckRequest");
local WitchBreakNeckRemote = NetworkRegistry.Legacy.Events:WaitForChild("WitchBreakNeckRemote");
local BreakNeck = require(ReplicatedStorage:WaitForChild("Funções"):WaitForChild("WitchSpellsConfig")).BreakNeck;
local u1 = false;
local u2 = 0;
local u3 = nil;
local u4 = nil;
local u5 = 0;
local u6 = nil;

local function isWitch() -- Line: 23
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer.Team and LocalPlayer.Team.Name == "Witches";
end;

local function getYears() -- Line: 27
    -- upvalues: LocalPlayer (copy)
    local v7 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
    local math_floor_ret = math.floor(v7);

    return math.max(0, math_floor_ret);
end;

local function findButton() -- Line: 31
    -- upvalues: LocalPlayer (copy), TeamGuiLayout (copy)
    local v8 = LocalPlayer:FindFirstChildOfClass("PlayerGui");

    if not v8 then
        return nil;
    end;

    local v9 = "Witches" .. TeamGuiLayout.GetMode();
    local v10 = TeamGuiLayout.FindPanel(v8, v9);

    if v10 then
        v10 = TeamGuiLayout.GetMenu(v10);
    end;

    if v10 then
        v10 = v10:FindFirstChild("Powers1") or v10:FindFirstChild("Powers");
    end;

    if v10 then
        v10 = v10:FindFirstChild("BreakNeck");
    end;

    if v10 and v10:IsA("GuiObject") then
        return v10;
    end;

    return nil;
end;

local function refreshButton() -- Line: 47
    -- upvalues: u3 (ref), u4 (ref), LocalPlayer (copy), BreakNeck (copy), u2 (ref), u1 (ref)
    if not (u3 and (u3.Parent and u4)) then
        return;
    end;

    local u11 = LocalPlayer.Team and LocalPlayer.Team.Name == "Witches";
    local v12 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
    local math_floor_ret = math.floor(v12);
    local u13 = math.max(0, math_floor_ret) >= (tonumber(BreakNeck.UnlockYears) or 25);
    local v14 = u2 - workspace:GetServerTimeNow();
    local math_max_ret = math.max(0, v14);
    local u15 = u1 or math_max_ret > 0;
    u3.Visible = u11;
    local v16;

    if u11 then
        if u13 then
            v16 = not u15;
        else
            v16 = u13;
        end;
    else
        v16 = u11;
    end;

    u3.Active = v16;

    if u3:IsA("GuiButton") then
        u3.AutoButtonColor = u11 and (u13 and not u15) and u4.autoButtonColor;
    end;

    pcall(function() -- Line: 62
        -- upvalues: u3 (ref), u11 (copy), u13 (copy), u15 (copy)
        u3.Interactable = u11 and u13 and not u15;
    end);
    local v17 = u3:FindFirstChild("UNLOCKLV") or (u3:FindFirstChild("UnlockRequirement") or u3:FindFirstChild("UnlockRequirement1"));

    if not v17 then
        v17 = Instance.new("TextLabel");
        v17.Name = "UnlockRequirement";
        v17.BackgroundTransparency = 1;
        v17.AnchorPoint = Vector2.new(0, 1);
        v17.Position = UDim2.new(0, 155, 0.98, 0);
        v17.Size = UDim2.fromScale(0.75, 0.3);
        v17.Font = Enum.Font.JosefinSans;
        v17.TextColor3 = Color3.new(1, 1, 1);
        v17.TextScaled = true;
        v17.TextStrokeTransparency = 1;
        v17.ZIndex = u3.ZIndex + 4;
        v17.Parent = u3;
    end;

    local v18 = tonumber(BreakNeck.UnlockYears) or 25;
    v17.Text = "+" .. tostring(v18);
    local v19;

    if u11 then
        v19 = not u13;
    else
        v19 = u11;
    end;

    v17.Visible = v19;
    local v20 = u3:FindFirstChild("COLDOWN") or u3:FindFirstChild("Coldown");

    if not v20 and u3:IsA("GuiButton") then
        v20 = u3:FindFirstChild("CooldownText");

        if not v20 then
            v20 = Instance.new("TextLabel");
            v20.Name = "CooldownText";
            v20.BackgroundTransparency = 1;
            v20.AnchorPoint = Vector2.new(0, 0.5);
            v20.Position = UDim2.new(0, 155, 0.5, 0);
            v20.Size = UDim2.fromScale(0.55, 0.55);
            v20.Font = Enum.Font.JosefinSans;
            v20.TextColor3 = Color3.new(1, 1, 1);
            v20.TextScaled = true;
            v20.TextStrokeTransparency = 0.2;
            v20.ZIndex = u3.ZIndex + 4;
            v20.Parent = u3;
        end;
    end;

    if v20 and v20:IsA("TextLabel") then
        if u11 then
            u11 = math_max_ret > 0;
        end;

        v20.Visible = u11;
        local v21;

        if math_max_ret > 0 then
            local math_ceil_ret = math.ceil(math_max_ret);
            v21 = tostring(math_ceil_ret) or "";
        else
            v21 = "";
        end;

        v20.Text = v21;
    end;

    u3:SetAttribute("PowerCooldown", (math.ceil(math_max_ret)));

    if u15 or not u13 then
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

local function scheduleCooldownRefresh() -- Line: 132
    -- upvalues: u5 (ref), u2 (ref), u1 (ref), refreshButton (copy)
    u5 = u5 + 1;
    local u22 = u5;
    local v23 = u2 - workspace:GetServerTimeNow();
    local math_max_ret = math.max(0, v23);
    task.delay(math_max_ret + 0.05, function() -- Line: 136
        -- upvalues: u22 (copy), u5 (ref), u1 (ref), refreshButton (ref)
        if u22 == u5 then
            u1 = false;
            refreshButton();
        end;
    end);
end;

local function clearLiftedHighlight() -- Line: 144
    -- upvalues: u6 (ref)
    if u6 then
        u6:Destroy();
        u6 = nil;
    end;
end;

local function showLiftedHighlight(p24) -- Line: 151
    -- upvalues: u6 (ref)
    if u6 then
        u6:Destroy();
        u6 = nil;
    end;

    if typeof(p24) ~= "Instance" or not (p24:IsA("Model") and p24.Parent) then
        return;
    end;

    local Highlight = Instance.new("Highlight");
    Highlight.Name = "WitchBreakNeckTargetHighlight";
    Highlight.Adornee = p24;
    Highlight.FillTransparency = 1;
    Highlight.OutlineColor = Color3.fromRGB(255, 0, 0);
    Highlight.OutlineTransparency = 0;
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
    Highlight.Parent = p24;
    u6 = Highlight;
end;

local function tryBreakNeck() -- Line: 168
    -- upvalues: LocalPlayer (copy), BreakNeck (copy), u1 (ref), u2 (ref), refreshButton (copy), Event (copy)
    if LocalPlayer.Team and LocalPlayer.Team.Name == "Witches" then
        local v25 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
        local math_floor_ret = math.floor(v25);

        if math.max(0, math_floor_ret) >= (tonumber(BreakNeck.UnlockYears) or 25) and (not u1 and workspace:GetServerTimeNow() >= u2) then
            u1 = true;
            refreshButton();
            Event:FireServer();
            task.delay(1.5, function() -- Line: 178
                -- upvalues: u1 (ref), u2 (ref), refreshButton (ref)
                if u1 and u2 <= workspace:GetServerTimeNow() then
                    u1 = false;
                    refreshButton();
                end;
            end);
        end;
    end;
end;

ContextActionService:BindActionAtPriority("WitchBreakNeckGamepad", function(p26, p27) -- Line: 186
    -- upvalues: TeamGuiLayout (copy), LocalPlayer (copy), UserInputService (copy), GuiService (copy), findButton (copy), tryBreakNeck (copy)
    if TeamGuiLayout.GetMode() == "CONSOLE" then
        if LocalPlayer.Team and LocalPlayer.Team.Name == "Witches" and not (UserInputService:GetFocusedTextBox() or (GuiService.SelectedObject or not TeamGuiLayout.IsVisible((findButton())))) then
            if p27 == Enum.UserInputState.Begin then
                tryBreakNeck();
            end;

            return Enum.ContextActionResult.Sink;
        end;
    end;

    return Enum.ContextActionResult.Pass;
end, false, 4500, Enum.KeyCode.ButtonB);
UserInputService.InputBegan:Connect(function(p28, p29) -- Line: 198
    -- upvalues: UserInputService (copy), tryBreakNeck (copy)
    if p29 or UserInputService:GetFocusedTextBox() then
        return;
    end;

    if p28.KeyCode == Enum.KeyCode.Q then
        tryBreakNeck();
    end;
end);
WitchBreakNeckRemote.OnClientEvent:Connect(function(p30, p31, p32) -- Line: 207
    -- upvalues: u2 (ref), u1 (ref), refreshButton (copy), u5 (ref), showLiftedHighlight (copy), u6 (ref)
    if p30 ~= "Started" then
        if p30 == "LiftedTarget" then
            showLiftedHighlight(p31);

            return;
        end;

        if p30 == "ClearLiftedTarget" then
            if u6 then
                u6:Destroy();
                u6 = nil;

                return;
            end;
        elseif p30 == "Rejected" then
            if p31 == "Cooldown" then
                u2 = tonumber(p32) or u2;
            end;

            u1 = false;

            if u6 then
                u6:Destroy();
                u6 = nil;
            end;

            refreshButton();

            if workspace:GetServerTimeNow() < u2 then
                u5 = u5 + 1;
                local u33 = u5;
                local v34 = u2 - workspace:GetServerTimeNow();
                local math_max_ret = math.max(0, v34);
                task.delay(math_max_ret + 0.05, function() -- Line: 136
                    -- upvalues: u33 (copy), u5 (ref), u1 (ref), refreshButton (ref)
                    if u33 == u5 then
                        u1 = false;
                        refreshButton();
                    end;
                end);
            end;
        end;

        return;
    end;

    u2 = tonumber(p31) or workspace:GetServerTimeNow() + 35;
    u1 = false;
    refreshButton();
    u5 = u5 + 1;
    local u35 = u5;
    local v36 = u2 - workspace:GetServerTimeNow();
    local math_max_ret = math.max(0, v36);
    task.delay(math_max_ret + 0.05, function() -- Line: 136
        -- upvalues: u35 (copy), u5 (ref), u1 (ref), refreshButton (ref)
        if u35 == u5 then
            u1 = false;
            refreshButton();
        end;
    end);
end);

local function refreshBinding() -- Line: 230
    -- upvalues: LocalPlayer (copy), u1 (ref), refreshButton (copy)
    if not (LocalPlayer.Team and LocalPlayer.Team.Name == "Witches") then
        u1 = false;
    end;

    refreshButton();
end;

local function bindButton() -- Line: 237
    -- upvalues: findButton (copy), u3 (ref), u4 (ref), TeamGuiLayout (copy), tryBreakNeck (copy), refreshButton (copy)
    local u37 = findButton();

    if not u37 or u37 == u3 then
        return;
    end;

    u3 = u37;
    u37.Active = true;
    local v38 = {
        textColor = u37:IsA("TextLabel") and u37.TextColor3 or Color3.new(1, 1, 1),
        textTransparency = u37:IsA("TextLabel") and (u37.TextTransparency or 0) or 0,
        imageColor = u37:IsA("ImageButton") and u37.ImageColor3 or Color3.new(1, 1, 1),
        imageTransparency = u37:IsA("ImageButton") and (u37.ImageTransparency or 0) or 0,
        backgroundColor = u37.BackgroundColor3
    };
    local v39;

    if u37:IsA("GuiButton") then
        v39 = u37.AutoButtonColor or false;
    else
        v39 = false;
    end;

    v38.autoButtonColor = v39;
    u4 = v38;

    local function activateFromUi() -- Line: 254
        -- upvalues: u37 (copy), TeamGuiLayout (ref), tryBreakNeck (ref)
        local v40 = u37:FindFirstAncestorOfClass("ScreenGui");

        if v40 and (v40.Enabled and TeamGuiLayout.IsVisible(u37)) then
            tryBreakNeck();
        end;
    end;

    if u37:IsA("GuiButton") then
        u37.Activated:Connect(activateFromUi);
    else
        u37.InputBegan:Connect(function(p41) -- Line: 263
            -- upvalues: u37 (copy), TeamGuiLayout (ref), tryBreakNeck (ref)
            if p41.UserInputType == Enum.UserInputType.MouseButton1 or p41.UserInputType == Enum.UserInputType.Touch then
                local v42 = u37:FindFirstAncestorOfClass("ScreenGui");

                if v42 and (v42.Enabled and TeamGuiLayout.IsVisible(u37)) then
                    tryBreakNeck();
                end;
            end;
        end);
    end;

    refreshButton();
end;

LocalPlayer:GetPropertyChangedSignal("Team"):Connect(refreshBinding);
LocalPlayer:GetAttributeChangedSignal("Years"):Connect(refreshBinding);
LocalPlayer.CharacterAdded:Connect(function() -- Line: 276
    -- upvalues: u1 (ref), u6 (ref), LocalPlayer (copy), refreshButton (copy)
    u1 = false;

    if u6 then
        u6:Destroy();
        u6 = nil;
    end;

    if not (LocalPlayer.Team and LocalPlayer.Team.Name == "Witches") then
        u1 = false;
    end;

    refreshButton();
end);
LocalPlayer:WaitForChild("PlayerGui").DescendantAdded:Connect(function(p43) -- Line: 283
    -- upvalues: bindButton (copy)
    if p43.Name == "BreakNeck" and p43:IsA("GuiObject") then
        task.defer(bindButton);
    end;
end);
bindButton();

if not (LocalPlayer.Team and LocalPlayer.Team.Name == "Witches") then
    u1 = false;
end;

refreshButton();
local u44 = 0;
RunService.RenderStepped:Connect(function(p45) -- Line: 295
    -- upvalues: u44 (ref), refreshButton (copy)
    u44 = u44 + p45;

    if u44 < 0.1 then
        return;
    end;

    u44 = 0;
    refreshButton();
end);
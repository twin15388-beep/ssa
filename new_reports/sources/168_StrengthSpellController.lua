-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService");
local TextChatService = game:GetService("TextChatService");
local LocalPlayer = Players.LocalPlayer;
local Mouse = LocalPlayer:GetMouse();
local NetworkRegistry = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("NetworkRegistry"));
local Event = NetworkRegistry.GetEvent("Combat", "StrengthRequest");
local StrengthRemote = NetworkRegistry.Legacy.Events:WaitForChild("StrengthRemote");
local Strength = require(ReplicatedStorage:WaitForChild("Funções"):WaitForChild("WitchSpellsConfig")).Strength;
local u1 = false;
local u2 = 0;
local u3 = 0;
local u4 = nil;
local ScreenGui = Instance.new("ScreenGui");
ScreenGui.Name = "StrengthSpellGui";
ScreenGui.ResetOnSpawn = false;
ScreenGui.IgnoreGuiInset = true;
ScreenGui.DisplayOrder = 80;
ScreenGui.Enabled = false;
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui");
local TextLabel = Instance.new("TextLabel");
TextLabel.Name = "Status";
TextLabel.AnchorPoint = Vector2.new(0.5, 1);
TextLabel.Position = UDim2.fromScale(0.5, 0.85);
TextLabel.Size = UDim2.new(0.4, 0, 0, 24);
TextLabel.BackgroundColor3 = Color3.fromRGB(20, 12, 28);
TextLabel.BackgroundTransparency = 1;
TextLabel.TextColor3 = Color3.fromRGB(224, 178, 255);
TextLabel.TextStrokeTransparency = 0;
TextLabel.Font = Enum.Font.JosefinSans;
TextLabel.TextScaled = false;
TextLabel.TextSize = 18;
TextLabel.TextWrapped = true;
TextLabel.ZIndex = 20;
TextLabel.Parent = ScreenGui;
local UICorner = Instance.new("UICorner");
UICorner.CornerRadius = UDim.new(0, 8);
UICorner.Parent = TextLabel;
local Highlight = Instance.new("Highlight");
Highlight.Name = "StrengthTargetHighlight";
Highlight.FillColor = Color3.fromRGB(150, 60, 210);
Highlight.FillTransparency = 0.68;
Highlight.OutlineColor = Color3.fromRGB(235, 190, 255);
Highlight.OutlineTransparency = 0;
Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
Highlight.Enabled = false;
Highlight.Parent = workspace;

local function now() -- Line: 57
    return workspace:GetServerTimeNow();
end;

local function normalize(p5) -- Line: 61
    return string.lower((tostring(p5):gsub("^%s+", ""):gsub("%s+$", "")));
end;

local function isIncantation(p6) -- Line: 65
    -- upvalues: Strength (copy)
    return string.lower((tostring(p6):gsub("^%s+", ""):gsub("%s+$", ""))) == string.lower(Strength.Incantation);
end;

local function requestBegin(p7) -- Line: 69
    -- upvalues: LocalPlayer (copy), Strength (copy), u3 (ref), Event (copy)
    if LocalPlayer.Team == nil or LocalPlayer.Team.Name ~= "Witches" then
        return;
    end;

    if string.lower((tostring(p7):gsub("^%s+", ""):gsub("%s+$", ""))) ~= string.lower(Strength.Incantation) or os.clock() - u3 < 0.4 then
        return;
    end;

    u3 = os.clock();
    Event:FireServer("Begin");
end;

LocalPlayer.Chatted:Connect(requestBegin);
pcall(function() -- Line: 79
    -- upvalues: TextChatService (copy), requestBegin (copy)
    TextChatService.SendingMessage:Connect(function(p8) -- Line: 80
        -- upvalues: requestBegin (ref)
        requestBegin(p8.Text);
    end);
end);

local function findHumanoidModel(p9) -- Line: 85
    while p9 and p9 ~= workspace do
        if p9:IsA("Model") and p9:FindFirstChildOfClass("Humanoid") then
            return p9;
        end;

        p9 = p9.Parent;
    end;

    return nil;
end;

local function targetFromInput(p10) -- Line: 96
    -- upvalues: LocalPlayer (copy), Strength (copy), findHumanoidModel (copy), Mouse (copy)
    if p10.UserInputType ~= Enum.UserInputType.Touch then
        return findHumanoidModel(Mouse.Target);
    end;

    local workspace_CurrentCamera = workspace.CurrentCamera;

    if not workspace_CurrentCamera then
        return nil;
    end;

    local v11 = workspace_CurrentCamera:ViewportPointToRay(p10.Position.X, p10.Position.Y);
    local RaycastParams_new_ret = RaycastParams.new();
    RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
    RaycastParams_new_ret.FilterDescendantsInstances = LocalPlayer.Character and { LocalPlayer.Character } or {};
    RaycastParams_new_ret.IgnoreWater = true;
    local v12 = workspace:Raycast(v11.Origin, v11.Direction * Strength.MaximumDistance, RaycastParams_new_ret);

    return v12 and findHumanoidModel(v12.Instance) or nil;
end;

local function clearSelection() -- Line: 111
    -- upvalues: u1 (ref), u4 (ref), ScreenGui (copy), Highlight (copy)
    u1 = false;
    u4 = nil;
    ScreenGui.Enabled = false;
    Highlight.Enabled = false;
    Highlight.Adornee = nil;
end;

local function showTemporary(u13, p14) -- Line: 119
    -- upvalues: u1 (ref), u4 (ref), Highlight (copy), ScreenGui (copy), TextLabel (copy)
    u1 = false;
    u4 = nil;
    Highlight.Enabled = false;
    Highlight.Adornee = nil;
    ScreenGui.Enabled = true;
    TextLabel.Text = u13;
    task.delay(p14 or 2, function() -- Line: 126
        -- upvalues: u1 (ref), TextLabel (ref), u13 (copy), ScreenGui (ref)
        if not u1 and TextLabel.Text == u13 then
            ScreenGui.Enabled = false;
        end;
    end);
end;

StrengthRemote.OnClientEvent:Connect(function(p15, p16, p17) -- Line: 133
    -- upvalues: u1 (ref), u2 (ref), Strength (copy), ScreenGui (copy), TextLabel (copy), u4 (ref), Highlight (copy)
    if p15 == "SelectionStarted" then
        u1 = true;
        u2 = tonumber(p16) or workspace:GetServerTimeNow() + Strength.SelectionTime;
        ScreenGui.Enabled = true;
        TextLabel.Text = Strength.Incantation;
        task.delay(2, function() -- Line: 139
            -- upvalues: u1 (ref), TextLabel (ref), Strength (ref), ScreenGui (ref)
            if u1 and TextLabel.Text == Strength.Incantation then
                ScreenGui.Enabled = false;
            end;
        end);

        return;
    end;

    if p15 ~= "CastAccepted" then
        if p15 == "Rejected" then
            local v18 = tostring(p16);

            if v18 == "Level" then
                local u19 = "STRENGTH UNLOCKS AT LEVEL " .. tostring(p17 or Strength.UnlockYears);
                u1 = false;
                u4 = nil;
                Highlight.Enabled = false;
                Highlight.Adornee = nil;
                ScreenGui.Enabled = true;
                TextLabel.Text = u19;
                task.delay(3, function() -- Line: 126
                    -- upvalues: u1 (ref), TextLabel (ref), u19 (copy), ScreenGui (ref)
                    if not u1 and TextLabel.Text == u19 then
                        ScreenGui.Enabled = false;
                    end;
                end);

                return;
            end;

            if v18 == "Mana" then
                local u20 = "NOT ENOUGH MANA (NEEDS " .. tostring(p17 or Strength.ManaCost) .. ")";
                u1 = false;
                u4 = nil;
                Highlight.Enabled = false;
                Highlight.Adornee = nil;
                ScreenGui.Enabled = true;
                TextLabel.Text = u20;
                task.delay(3, function() -- Line: 126
                    -- upvalues: u1 (ref), TextLabel (ref), u20 (copy), ScreenGui (ref)
                    if not u1 and TextLabel.Text == u20 then
                        ScreenGui.Enabled = false;
                    end;
                end);

                return;
            end;

            if v18 == "Cooldown" then
                local v21 = (tonumber(p17) or workspace:GetServerTimeNow()) - workspace:GetServerTimeNow();
                local math_ceil_ret = math.ceil(v21);
                local math_max_ret = math.max(1, math_ceil_ret);
                local u22 = "STRENGTH COOLDOWN: " .. tostring(math_max_ret) .. "s";
                u1 = false;
                u4 = nil;
                Highlight.Enabled = false;
                Highlight.Adornee = nil;
                ScreenGui.Enabled = true;
                TextLabel.Text = u22;
                task.delay(2.5, function() -- Line: 126
                    -- upvalues: u1 (ref), TextLabel (ref), u22 (copy), ScreenGui (ref)
                    if not u1 and TextLabel.Text == u22 then
                        ScreenGui.Enabled = false;
                    end;
                end);

                return;
            end;

            if v18 == "Expired" then
                u1 = false;
                u4 = nil;
                ScreenGui.Enabled = false;
                Highlight.Enabled = false;
                Highlight.Adornee = nil;

                return;
            end;

            TextLabel.Text = v18 == "OutOfRange" and "TARGET IS TOO FAR" or (v18 == "Blocked" and "TARGET IS BLOCKED" or (v18 == "InvalidTarget" and "CLICK A LIVING TARGET" or "STRENGTH IS UNAVAILABLE"));
            ScreenGui.Enabled = true;
        end;

        return;
    end;

    local v23 = typeof(p16) == "Instance" and p16 and p16 or nil;
    u1 = false;
    u4 = nil;
    ScreenGui.Enabled = false;
    Highlight.Enabled = false;
    Highlight.Adornee = nil;
    local u24 = (v23 and v23.Name or "Target") .. " STRENGTHENED +20%";
    u1 = false;
    u4 = nil;
    Highlight.Enabled = false;
    Highlight.Adornee = nil;
    ScreenGui.Enabled = true;
    TextLabel.Text = u24;
    task.delay(2.5, function() -- Line: 126
        -- upvalues: u1 (ref), TextLabel (ref), u24 (copy), ScreenGui (ref)
        if not u1 and TextLabel.Text == u24 then
            ScreenGui.Enabled = false;
        end;
    end);
end);
UserInputService.InputBegan:Connect(function(p25, p26) -- Line: 169
    -- upvalues: u1 (ref), u2 (ref), targetFromInput (copy), LocalPlayer (copy), StrengthRemote (copy)
    if p26 or (not u1 or u2 < workspace:GetServerTimeNow()) then
        return;
    end;

    if p25.UserInputType ~= Enum.UserInputType.MouseButton1 and p25.UserInputType ~= Enum.UserInputType.Touch then
        return;
    end;

    local v27 = targetFromInput(p25);

    if v27 and v27 ~= LocalPlayer.Character then
        StrengthRemote:FireServer("Cast", v27);
    end;
end);
RunService.RenderStepped:Connect(function() -- Line: 184
    -- upvalues: u1 (ref), u2 (ref), u4 (ref), ScreenGui (copy), Highlight (copy), UserInputService (copy), findHumanoidModel (copy), Mouse (copy), LocalPlayer (copy)
    if not u1 then
        return;
    end;

    local v28 = u2 - workspace:GetServerTimeNow();

    if math.max(0, v28) > 0 then
        if not UserInputService.TouchEnabled then
            u4 = findHumanoidModel(Mouse.Target);
            local v29 = u4 and u4:FindFirstChildOfClass("Humanoid");

            if u4 ~= LocalPlayer.Character and (v29 and v29.Health > 0) then
                Highlight.Adornee = u4;
                Highlight.Enabled = true;

                return;
            end;

            Highlight.Adornee = nil;
            Highlight.Enabled = false;
        end;

        return;
    end;

    u1 = false;
    u4 = nil;
    ScreenGui.Enabled = false;
    Highlight.Enabled = false;
    Highlight.Adornee = nil;
end);
LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function() -- Line: 205
    -- upvalues: LocalPlayer (copy), u1 (ref), u4 (ref), ScreenGui (copy), Highlight (copy)
    if not LocalPlayer.Team or LocalPlayer.Team.Name ~= "Witches" then
        u1 = false;
        u4 = nil;
        ScreenGui.Enabled = false;
        Highlight.Enabled = false;
        Highlight.Adornee = nil;
    end;
end);
LocalPlayer.CharacterAdded:Connect(clearSelection);
script.Destroying:Connect(function() -- Line: 212
    -- upvalues: Highlight (copy)
    if Highlight.Parent then
        Highlight:Destroy();
    end;
end);
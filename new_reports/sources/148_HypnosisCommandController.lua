-- Decompiled with Potassium's decompiler.

local TeamGuiLayout = require(game:GetService("ReplicatedStorage"):WaitForChild("TeamGuiLayout"));
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local GuiService = game:GetService("GuiService");
local UserInputService = game:GetService("UserInputService");
local Lighting = game:GetService("Lighting");
local LocalPlayer = Players.LocalPlayer;
local NetworkRegistry = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("NetworkRegistry"));
local Event = NetworkRegistry.GetEvent("Combat", "HypnosisRequest");
local LegacyCombat = NetworkRegistry.GetLegacyCombat("Hypnosis");
local ScreenGui = Instance.new("ScreenGui");
ScreenGui.Name = "HypnosisCommands";
ScreenGui.DisplayOrder = 80;
ScreenGui.IgnoreGuiInset = false;
ScreenGui.ResetOnSpawn = false;
ScreenGui.Enabled = false;
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui");
local ScreenGui2 = Instance.new("ScreenGui");
ScreenGui2.Name = "HypnosisPossession";
ScreenGui2.DisplayOrder = 79;
ScreenGui2.IgnoreGuiInset = true;
ScreenGui2.ResetOnSpawn = false;
ScreenGui2.Enabled = false;
ScreenGui2.Parent = LocalPlayer.PlayerGui;
local HypnosisControlDepth = Lighting:FindFirstChild("HypnosisControlDepth");

if HypnosisControlDepth and not HypnosisControlDepth:IsA("DepthOfFieldEffect") then
    HypnosisControlDepth:Destroy();
    HypnosisControlDepth = nil;
end;

if not HypnosisControlDepth then
    HypnosisControlDepth = Instance.new("DepthOfFieldEffect");
    HypnosisControlDepth.Name = "HypnosisControlDepth";
    HypnosisControlDepth.Parent = Lighting;
end;

HypnosisControlDepth.Enabled = false;
HypnosisControlDepth.NearIntensity = 0.7;
HypnosisControlDepth.FarIntensity = 0.32;
HypnosisControlDepth.InFocusRadius = 9;
HypnosisControlDepth.FocusDistance = 12;
local TextLabel = Instance.new("TextLabel");
TextLabel.Name = "PossessionTitle";
TextLabel.AnchorPoint = Vector2.new(0.5, 0);
TextLabel.Position = UDim2.fromScale(0.5, 0.035);
TextLabel.Size = UDim2.fromOffset(360, 34);
TextLabel.BackgroundTransparency = 1;
TextLabel.Font = Enum.Font.JosefinSans;
TextLabel.Text = "CONTROLLING BODY";
TextLabel.TextColor3 = Color3.fromRGB(215, 205, 225);
TextLabel.TextStrokeTransparency = 0.6;
TextLabel.TextScaled = true;
TextLabel.ZIndex = 3;
TextLabel.Parent = ScreenGui2;
local UITextSizeConstraint = Instance.new("UITextSizeConstraint");
UITextSizeConstraint.MinTextSize = 15;
UITextSizeConstraint.MaxTextSize = 25;
UITextSizeConstraint.Parent = TextLabel;
local TextButton = Instance.new("TextButton");
TextButton.Name = "LeaveBody";
TextButton.AnchorPoint = Vector2.new(0.5, 1);
TextButton.Position = UDim2.fromScale(0.5, 0.94);
TextButton.Size = UDim2.fromOffset(190, 42);
TextButton.BackgroundTransparency = 1;
TextButton.BorderSizePixel = 0;
TextButton.AutoButtonColor = false;
TextButton.Font = Enum.Font.JosefinSans;
TextButton.Text = "LEAVE BODY";
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255);
TextButton.TextStrokeTransparency = 0.55;
TextButton.TextSize = 20;
TextButton.ZIndex = 4;
TextButton.Parent = ScreenGui2;
local Frame = Instance.new("Frame");
Frame.Name = "Commands";
Frame.AnchorPoint = Vector2.new(0, 0.5);
Frame.Position = UDim2.fromScale(0.025, 0.5);
Frame.Size = UDim2.fromScale(0.26, 0.3);
Frame.BackgroundTransparency = 1;
Frame.BorderSizePixel = 0;
Frame.Parent = ScreenGui;
local UIListLayout = Instance.new("UIListLayout");
UIListLayout.FillDirection = Enum.FillDirection.Vertical;
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left;
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
UIListLayout.Padding = UDim.new(0, 6);
UIListLayout.Parent = Frame;
local u1 = 0;
local u2 = {};
local u3 = nil;
local u4 = false;
local u5 = nil;
local u6 = 0;
local u7 = false;
local u8 = {};

local function hideVampireInterfaces() -- Line: 116
    -- upvalues: LocalPlayer (copy), u8 (copy), TeamGuiLayout (copy)
    local TEAMS = LocalPlayer.PlayerGui:FindFirstChild("TEAMS");

    if TEAMS then
        TEAMS:SetAttribute("HiddenByHypnosis", true);
    end;

    table.clear(u8);
    local TEAMS2 = LocalPlayer.PlayerGui:FindFirstChild("TEAMS");

    if TEAMS2 then
        TEAMS2:SetAttribute("HiddenByHypnosis", true);
    end;

    for _, v in ipairs({ "Vampires", "VampiresMOBILE", "VampiresCONSOLE" }) do
        local v9 = TeamGuiLayout.FindPanel(LocalPlayer.PlayerGui, v);

        if v9 and v9:IsA("GuiObject") then
            u8[v9] = v9.Visible;
            v9.Visible = false;
        end;
    end;
end;

local function restoreVampireInterfaces() -- Line: 131
    -- upvalues: u8 (copy), LocalPlayer (copy)
    for i, v in pairs(u8) do
        if i.Parent then
            i.Visible = v;
        end;
    end;

    table.clear(u8);
    local TEAMS = LocalPlayer.PlayerGui:FindFirstChild("TEAMS");

    if TEAMS then
        TEAMS:SetAttribute("HiddenByHypnosis", false);
    end;
end;

local function stopPossessionView() -- Line: 140
    -- upvalues: u5 (ref), u7 (ref), ScreenGui2 (copy), HypnosisControlDepth (ref), restoreVampireInterfaces (copy), LocalPlayer (copy)
    u5 = nil;
    u7 = false;
    ScreenGui2.Enabled = false;
    HypnosisControlDepth.Enabled = false;
    restoreVampireInterfaces();
    local workspace_CurrentCamera = workspace.CurrentCamera;
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChildOfClass("Humanoid");
    end;

    if workspace_CurrentCamera and Character then
        workspace_CurrentCamera.CameraSubject = Character;
    end;
end;

local function startPossessionView(p10) -- Line: 152
    -- upvalues: u5 (ref), u6 (ref), ScreenGui2 (copy), HypnosisControlDepth (ref), hideVampireInterfaces (copy), u8 (copy)
    local v11;

    if p10 then
        v11 = p10:FindFirstChildOfClass("Humanoid");
    else
        v11 = p10;
    end;

    if not v11 then
        return;
    end;

    u5 = p10;
    u6 = 0;
    ScreenGui2.Enabled = true;
    HypnosisControlDepth.Enabled = true;
    hideVampireInterfaces();

    for i in pairs(u8) do
        if i.Parent then
            i.Visible = false;
        end;
    end;

    local workspace_CurrentCamera = workspace.CurrentCamera;

    if workspace_CurrentCamera then
        workspace_CurrentCamera.CameraSubject = v11;
    end;
end;

TextButton.Activated:Connect(function() -- Line: 167
    -- upvalues: u5 (ref), Event (copy)
    if u5 then
        Event:FireServer("EndControl");
    end;
end);
UserInputService.JumpRequest:Connect(function() -- Line: 171
    -- upvalues: u5 (ref), u7 (ref)
    if u5 then
        u7 = true;
    end;
end);

local function closeMenu() -- Line: 175
    -- upvalues: u1 (ref), u4 (ref), ScreenGui (copy), Frame (copy), u3 (ref)
    u1 = u1 + 1;
    u4 = false;
    ScreenGui.Enabled = false;
    Frame.Visible = false;
    u3 = nil;
end;

for i, v in ipairs({ {
        text = "KILL YOURSELF",
        command = "SelfKill"
    }, {
        text = "FOLLOW ME",
        command = "Follow"
    }, {
        text = "STAY STILL",
        command = "Stay"
    }, {
        text = "CONTROL BODY",
        command = "Control"
    } }) do
    local TextButton2 = Instance.new("TextButton");
    TextButton2.Name = v.command;
    TextButton2.LayoutOrder = i;
    TextButton2.Size = UDim2.new(1, 0, 0, 36);
    TextButton2.BackgroundTransparency = 1;
    TextButton2.BorderSizePixel = 0;
    TextButton2.AutoButtonColor = false;
    TextButton2.Font = Enum.Font.JosefinSans;
    TextButton2.Text = v.text;
    TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextButton2.TextStrokeColor3 = Color3.fromRGB(75, 0, 0);
    TextButton2.TextStrokeTransparency = 0.2;
    TextButton2.TextScaled = true;
    TextButton2.TextXAlignment = Enum.TextXAlignment.Left;
    TextButton2.Parent = Frame;
    local UITextSizeConstraint2 = Instance.new("UITextSizeConstraint");
    UITextSizeConstraint2.MinTextSize = 15;
    UITextSizeConstraint2.MaxTextSize = 31;
    UITextSizeConstraint2.Parent = TextButton2;
    TextButton2.MouseEnter:Connect(function() -- Line: 205
        -- upvalues: TextButton2 (copy)
        TextButton2.TextColor3 = Color3.fromRGB(255, 70, 70);
    end);
    TextButton2.MouseLeave:Connect(function() -- Line: 208
        -- upvalues: TextButton2 (copy)
        TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255);
    end);
    TextButton2.InputBegan:Connect(function(p12) -- Line: 211
        -- upvalues: TextButton2 (copy)
        if p12.UserInputType == Enum.UserInputType.Touch then
            TextButton2.TextColor3 = Color3.fromRGB(255, 70, 70);
        end;
    end);
    TextButton2.InputEnded:Connect(function(p13) -- Line: 216
        -- upvalues: TextButton2 (copy)
        if p13.UserInputType == Enum.UserInputType.Touch then
            TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255);
        end;
    end);
    TextButton2.Activated:Connect(function() -- Line: 221
        -- upvalues: u4 (ref), u1 (ref), ScreenGui (copy), Frame (copy), u3 (ref), LegacyCombat (copy), v (copy)
        if not u4 then
            return;
        end;

        u1 = u1 + 1;
        u4 = false;
        ScreenGui.Enabled = false;
        Frame.Visible = false;
        u3 = nil;
        LegacyCombat:FireServer("Command", v.command);
    end);
    u2[v.command] = TextButton2;
end;

LegacyCombat.OnClientEvent:Connect(function(p14, p15, p16) -- Line: 232
    -- upvalues: LocalPlayer (copy), u1 (ref), u4 (ref), ScreenGui (copy), Frame (copy), u3 (ref), u2 (copy), startPossessionView (copy), u5 (ref), u7 (ref), ScreenGui2 (copy), HypnosisControlDepth (ref), restoreVampireInterfaces (copy)
    if p14 ~= "CommandWindowOpened" then
        if p14 ~= "CommandWindowClosed" then
            if p14 == "PossessionStarted" then
                startPossessionView(p15);

                return;
            end;

            if p14 == "PossessionEnded" or p14 == "ControlRejected" then
                u5 = nil;
                u7 = false;
                ScreenGui2.Enabled = false;
                HypnosisControlDepth.Enabled = false;
                restoreVampireInterfaces();
                local workspace_CurrentCamera = workspace.CurrentCamera;
                local Character = LocalPlayer.Character;

                if Character then
                    Character = Character:FindFirstChildOfClass("Humanoid");
                end;

                if workspace_CurrentCamera and Character then
                    workspace_CurrentCamera.CameraSubject = Character;
                end;
            end;

            return;
        end;

        u1 = u1 + 1;
        u4 = false;
        ScreenGui.Enabled = false;
        Frame.Visible = false;
        u3 = nil;

        return;
    end;

    if not (LocalPlayer.Team and (LocalPlayer.Team.Name == "Vampires" or LocalPlayer.Team.Name == "Cannibal Raised")) then
        u1 = u1 + 1;
        u4 = false;
        ScreenGui.Enabled = false;
        Frame.Visible = false;
        u3 = nil;

        return;
    end;

    local v17;

    if p16 then
        v17 = p16:FindFirstChild("Head") or p16:FindFirstChild("HumanoidRootPart");
    else
        v17 = p16;
    end;

    if not (v17 and v17:IsA("BasePart")) then
        u1 = u1 + 1;
        u4 = false;
        ScreenGui.Enabled = false;
        Frame.Visible = false;
        u3 = nil;

        return;
    end;

    u1 = u1 + 1;
    u4 = false;
    ScreenGui.Enabled = false;
    Frame.Visible = false;
    u3 = nil;
    u1 = u1 + 1;
    local u18 = u1;
    u4 = true;
    u3 = p16;
    local Control = u2.Control;

    if Control then
        Control.Visible = true;
    end;

    ScreenGui.Enabled = true;
    Frame.Parent = ScreenGui;
    Frame.AnchorPoint = Vector2.new(0, 0.5);
    Frame.Size = UDim2.fromOffset(230, 180);
    Frame.Visible = true;
    local v19 = tonumber(p15) or workspace:GetServerTimeNow() + 8;
    local task_delay = task.delay;
    local v20 = v19 - workspace:GetServerTimeNow();
    task_delay(math.max(0, v20), function() -- Line: 260
        -- upvalues: u18 (copy), u1 (ref), u4 (ref), ScreenGui (ref), Frame (ref), u3 (ref)
        if u18 == u1 then
            u1 = u1 + 1;
            u4 = false;
            ScreenGui.Enabled = false;
            Frame.Visible = false;
            u3 = nil;
        end;
    end);
end);
RunService.RenderStepped:Connect(function() -- Line: 274
    -- upvalues: u4 (ref), u3 (ref), u1 (ref), ScreenGui (copy), Frame (copy), GuiService (copy)
    if not (u4 and u3) then
        return;
    end;

    local workspace_CurrentCamera = workspace.CurrentCamera;
    local v21 = u3:FindFirstChild("Head") or u3:FindFirstChild("HumanoidRootPart");

    if not (workspace_CurrentCamera and (v21 and (v21:IsA("BasePart") and u3.Parent))) then
        u1 = u1 + 1;
        u4 = false;
        ScreenGui.Enabled = false;
        Frame.Visible = false;
        u3 = nil;

        return;
    end;

    local v22, v23 = workspace_CurrentCamera:WorldToViewportPoint(v21.Position + Vector3.new(0, 0.35, 0));

    if v23 then
        v23 = v22.Z > 0;
    end;

    Frame.Visible = v23;

    if not Frame.Visible then
        return;
    end;

    local GuiInset = GuiService:GetGuiInset();
    local ViewportSize = workspace_CurrentCamera.ViewportSize;
    local math_min_ret = math.min(ViewportSize.X / 1280, ViewportSize.Y / 720);
    local math_clamp_ret = math.clamp(math_min_ret, 0.9, 1.15);
    local v24 = math_clamp_ret * 230;
    local v25 = math_clamp_ret * 180;
    Frame.Size = UDim2.fromOffset(v24, v25);
    local v26 = v22.X - GuiInset.X + math_clamp_ret * 64;
    local v27 = v22.Y - GuiInset.Y;
    local math_max_ret = math.max(8, ViewportSize.X - v24 - 8);
    local math_clamp_ret2 = math.clamp(v26, 8, math_max_ret);
    local math_max_ret2 = math.max(v25 * 0.5 + 8, ViewportSize.Y - v25 * 0.5 - 8);
    local math_clamp_ret3 = math.clamp(v27, v25 * 0.5 + 8, math_max_ret2);
    Frame.Position = UDim2.fromOffset(math_clamp_ret2, math_clamp_ret3);
end);
RunService.RenderStepped:Connect(function() -- Line: 306
    -- upvalues: u5 (ref), u8 (copy), LocalPlayer (copy), LegacyCombat (copy), u7 (ref), ScreenGui2 (copy), HypnosisControlDepth (ref), restoreVampireInterfaces (copy), u6 (ref), UserInputService (copy)
    if not u5 then
        return;
    end;

    for i in pairs(u8) do
        if i.Parent then
            i.Visible = false;
        end;
    end;

    local v28 = u5:FindFirstChildOfClass("Humanoid");
    local HumanoidRootPart = u5:FindFirstChild("HumanoidRootPart");
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChildOfClass("Humanoid");
    end;

    if v28 and (v28.Health > 0 and (HumanoidRootPart and (Character and u5.Parent))) then
        local workspace_CurrentCamera = workspace.CurrentCamera;

        if workspace_CurrentCamera then
            if workspace_CurrentCamera.CameraSubject ~= v28 then
                workspace_CurrentCamera.CameraSubject = v28;
            end;

            HypnosisControlDepth.FocusDistance = math.max(1, (workspace_CurrentCamera.CFrame.Position - HumanoidRootPart.Position).Magnitude);
        end;

        local os_clock_ret = os.clock();

        if u7 or os_clock_ret - u6 >= 0.05 then
            u6 = os_clock_ret;
            LegacyCombat:FireServer("ControlMove", UserInputService:GetFocusedTextBox() and Vector3.new(0, 0, 0) or Character.MoveDirection, u7);
            u7 = false;
        end;

        return;
    end;

    LegacyCombat:FireServer("EndControl");
    u5 = nil;
    u7 = false;
    ScreenGui2.Enabled = false;
    HypnosisControlDepth.Enabled = false;
    restoreVampireInterfaces();
    local workspace_CurrentCamera = workspace.CurrentCamera;
    local Character2 = LocalPlayer.Character;

    if Character2 then
        Character2 = Character2:FindFirstChildOfClass("Humanoid");
    end;

    if workspace_CurrentCamera and Character2 then
        workspace_CurrentCamera.CameraSubject = Character2;
    end;
end);
LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function() -- Line: 336
    -- upvalues: LocalPlayer (copy), u1 (ref), u4 (ref), ScreenGui (copy), Frame (copy), u3 (ref)
    if not (LocalPlayer.Team and (LocalPlayer.Team.Name == "Vampires" or LocalPlayer.Team.Name == "Cannibal Raised")) then
        u1 = u1 + 1;
        u4 = false;
        ScreenGui.Enabled = false;
        Frame.Visible = false;
        u3 = nil;
    end;
end);
LocalPlayer.CharacterAdded:Connect(function() -- Line: 342
    -- upvalues: u1 (ref), u4 (ref), ScreenGui (copy), Frame (copy), u3 (ref), u5 (ref), u7 (ref), ScreenGui2 (copy), HypnosisControlDepth (ref), restoreVampireInterfaces (copy), LocalPlayer (copy)
    u1 = u1 + 1;
    u4 = false;
    ScreenGui.Enabled = false;
    Frame.Visible = false;
    u3 = nil;
    u5 = nil;
    u7 = false;
    ScreenGui2.Enabled = false;
    HypnosisControlDepth.Enabled = false;
    restoreVampireInterfaces();
    local workspace_CurrentCamera = workspace.CurrentCamera;
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChildOfClass("Humanoid");
    end;

    if workspace_CurrentCamera and Character then
        workspace_CurrentCamera.CameraSubject = Character;
    end;
end);
-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
game:GetService("StarterGui");
local UserInputService = game:GetService("UserInputService");
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local u1 = workspace:FindFirstChild("Quest2") or workspace:WaitForChild("Quest2", 10);
local Quest2Remote = ReplicatedStorage:WaitForChild("Quest2Remotes"):WaitForChild("Quest2Remote");
local Quest2BillboardUI = PlayerGui:WaitForChild("Quest2BillboardUI");
local Panel = Quest2BillboardUI:WaitForChild("Panel");
local MissionName = Panel:WaitForChild("MissionName");
local MissionDescription = Panel:WaitForChild("MissionDescription");
local Reward = Panel:WaitForChild("Reward");
local AcceptButton = Panel:WaitForChild("AcceptButton");
local SFX = Panel:WaitForChild("SFX");

local function updateResponsiveOfferUI() -- Line: 22
    -- upvalues: Quest2BillboardUI (copy), Panel (copy), MissionName (copy), MissionDescription (copy), Reward (copy), AcceptButton (copy)
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if not workspace_CurrentCamera then
        return;
    end;

    local math_floor_ret = math.floor(workspace_CurrentCamera.ViewportSize.X * 0.78 + 0.5);
    local math_clamp_ret = math.clamp(math_floor_ret, 300, 380);
    local v2 = math_clamp_ret / 380;
    local math_floor_ret2 = math.floor(v2 * 210 + 0.5);
    Quest2BillboardUI.Size = UDim2.fromOffset(math_clamp_ret, math_floor_ret2);
    Panel.ClipsDescendants = true;

    for _, v in ipairs({
        MissionName,
        MissionDescription,
        Reward,
        AcceptButton
    }) do
        v.AnchorPoint = Vector2.new(0, 0);
        v.ZIndex = 2;
    end;

    MissionName.Position = UDim2.new(0.05, 0, 0.065, 0);
    MissionName.Size = UDim2.new(0.9, 0, 0.15, 0);
    MissionDescription.Position = UDim2.new(0.05, 0, 0.235, 0);
    MissionDescription.Size = UDim2.new(0.9, 0, 0.3, 0);
    Reward.Position = UDim2.new(0.05, 0, 0.56, 0);
    Reward.Size = UDim2.new(0.9, 0, 0.12, 0);
    AcceptButton.Position = UDim2.new(0.05, 0, 0.73, 0);
    AcceptButton.Size = UDim2.new(0.9, 0, 0.19, 0);
    MissionName.TextScaled = false;
    MissionDescription.TextScaled = false;
    Reward.TextScaled = false;
    AcceptButton.TextScaled = false;
    MissionDescription.TextWrapped = true;
    local math_floor_ret3 = math.floor(v2 * 20 + 0.5);
    MissionName.TextSize = math.max(16, math_floor_ret3);
    local math_floor_ret4 = math.floor(v2 * 14 + 0.5);
    MissionDescription.TextSize = math.max(12, math_floor_ret4);
    local math_floor_ret5 = math.floor(v2 * 14 + 0.5);
    Reward.TextSize = math.max(12, math_floor_ret5);
    local math_floor_ret6 = math.floor(v2 * 16 + 0.5);
    AcceptButton.TextSize = math.max(14, math_floor_ret6);
end;

updateResponsiveOfferUI();

if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateResponsiveOfferUI);
end;

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- Line: 66
    -- upvalues: updateResponsiveOfferUI (copy)
    updateResponsiveOfferUI();
end);
local u3 = { "PAPEL", "PAPEL2", "PAPEL3", "PAPEL4" };
local u4 = {};

local function refreshPapers() -- Line: 72
    -- upvalues: u4 (copy), u1 (ref), u3 (copy)
    table.clear(u4);
    u1 = workspace:FindFirstChild("Quest2") or u1;

    if not u1 then
        return;
    end;

    for _, v in ipairs(u3) do
        local v5 = u1:FindFirstChild(v);

        if v5 and v5:IsA("BasePart") then
            table.insert(u4, v5);
        end;
    end;
end;

refreshPapers();
workspace.ChildAdded:Connect(function(p6) -- Line: 84
    -- upvalues: u1 (ref), refreshPapers (copy)
    if p6.Name == "Quest2" then
        u1 = p6;
        task.defer(refreshPapers);
    end;
end);

if u1 then
    u1.ChildAdded:Connect(function() -- Line: 91
        -- upvalues: refreshPapers (copy)
        task.defer(refreshPapers);
    end);
end;

local ScreenGui = Instance.new("ScreenGui");
ScreenGui.Name = "Quest2TrackerUI";
ScreenGui.ResetOnSpawn = false;
ScreenGui.IgnoreGuiInset = false;
ScreenGui.ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets;
ScreenGui.Parent = PlayerGui;
ScreenGui.Enabled = true;
local Frame = Instance.new("Frame");
Frame.Name = "Tracker";
Frame.AnchorPoint = Vector2.new(1, 0);
Frame.Position = UDim2.new(1, -28, 0, 130);
Frame.Size = UDim2.fromOffset(380, 190);
Frame.BackgroundTransparency = 1;
Frame.BorderSizePixel = 0;
Frame.Visible = false;
Frame.Parent = ScreenGui;
local UIScale = Instance.new("UIScale");
UIScale.Name = "ResponsiveScale";
UIScale.Scale = 1;
UIScale.Parent = Frame;
local u7 = nil;

local function updateResponsiveTrackerUI() -- Line: 120
    -- upvalues: UserInputService (copy), UIScale (copy), Frame (copy)
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if not workspace_CurrentCamera then
        return;
    end;

    local ViewportSize = workspace_CurrentCamera.ViewportSize;

    if not UserInputService.TouchEnabled and ViewportSize.Y > 600 then
        UIScale.Scale = 1;
        Frame.AnchorPoint = Vector2.new(1, 0);
        Frame.Position = UDim2.new(1, -28, 0, 130);

        return;
    end;

    local math_min_ret = math.min(ViewportSize.X / 1050, ViewportSize.Y / 620);
    local math_clamp_ret = math.clamp(math_min_ret, 0.7, 0.86);
    local v8;

    if ViewportSize.X >= 700 then
        local math_floor_ret = math.floor(ViewportSize.X * 0.115 + 0.5);
        v8 = math.clamp(math_floor_ret, 72, 120) or 16;
    else
        v8 = 16;
    end;

    local math_floor_ret = math.floor(ViewportSize.Y * 0.15 + 0.5);
    local math_clamp_ret2 = math.clamp(math_floor_ret, 30, 80);
    UIScale.Scale = math_clamp_ret;
    Frame.AnchorPoint = Vector2.new(1, 0);
    Frame.Position = UDim2.new(1, -v8, 0, math_clamp_ret2);
end;

local function bindTrackerCamera() -- Line: 146
    -- upvalues: u7 (ref), updateResponsiveTrackerUI (copy)
    if u7 then
        u7:Disconnect();
        u7 = nil;
    end;

    local workspace_CurrentCamera = workspace.CurrentCamera;

    if workspace_CurrentCamera then
        u7 = workspace_CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateResponsiveTrackerUI);
    end;

    updateResponsiveTrackerUI();
end;

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindTrackerCamera);

if u7 then
    u7:Disconnect();
    u7 = nil;
end;

local workspace_CurrentCamera = workspace.CurrentCamera;

if workspace_CurrentCamera then
    u7 = workspace_CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateResponsiveTrackerUI);
end;

updateResponsiveTrackerUI();
local UICorner = Instance.new("UICorner");
UICorner.CornerRadius = UDim.new(0, 10);
UICorner.Parent = Frame;
local UIStroke = Instance.new("UIStroke");
UIStroke.Color = Color3.fromRGB(202, 163, 72);
UIStroke.Thickness = 1.5;
UIStroke.Transparency = 1;
UIStroke.Parent = Frame;
local TextLabel = Instance.new("TextLabel");
TextLabel.BackgroundTransparency = 1;
TextLabel.Position = UDim2.fromOffset(0, 20);
TextLabel.Size = UDim2.new(1, 0, 0, 30);
TextLabel.Font = Enum.Font.JosefinSans;
TextLabel.TextColor3 = Color3.fromRGB(240, 205, 112);
TextLabel.TextScaled = false;
TextLabel.TextSize = 26;
TextLabel.TextStrokeColor3 = Color3.fromRGB(30, 18, 4);
TextLabel.TextStrokeTransparency = 0.25;
TextLabel.TextXAlignment = Enum.TextXAlignment.Right;
TextLabel.Text = "MISSION";
TextLabel.Parent = Frame;
local TextLabel2 = Instance.new("TextLabel");
TextLabel2.BackgroundTransparency = 1;
TextLabel2.Position = UDim2.fromOffset(0, 52);
TextLabel2.Size = UDim2.new(1, 0, 0, 48);
TextLabel2.Font = Enum.Font.JosefinSans;
TextLabel2.TextColor3 = Color3.fromRGB(240, 240, 240);
TextLabel2.TextSize = 18;
TextLabel2.TextWrapped = true;
TextLabel2.TextXAlignment = Enum.TextXAlignment.Right;
TextLabel2.TextYAlignment = Enum.TextYAlignment.Top;
TextLabel2.Text = "";
TextLabel2.Parent = Frame;
local TextLabel3 = Instance.new("TextLabel");
TextLabel3.BackgroundTransparency = 1;
TextLabel3.Position = UDim2.fromOffset(0, 106);
TextLabel3.Size = UDim2.new(1, 0, 0, 30);
TextLabel3.Font = Enum.Font.JosefinSans;
TextLabel3.TextColor3 = Color3.fromRGB(255, 255, 255);
TextLabel3.TextSize = 24;
TextLabel3.TextXAlignment = Enum.TextXAlignment.Right;
TextLabel3.Text = "0 / 0";
TextLabel3.Parent = Frame;
local TextLabel4 = Instance.new("TextLabel");
TextLabel4.BackgroundTransparency = 1;
TextLabel4.Position = UDim2.fromOffset(0, 138);
TextLabel4.Size = UDim2.new(1, 0, 0, 22);
TextLabel4.Font = Enum.Font.JosefinSans;
TextLabel4.TextColor3 = Color3.fromRGB(240, 205, 112);
TextLabel4.TextSize = 16;
TextLabel4.TextXAlignment = Enum.TextXAlignment.Right;
TextLabel4.Text = "";
TextLabel4.Parent = Frame;
local TextLabel5 = Instance.new("TextLabel");
TextLabel5.BackgroundTransparency = 1;
TextLabel5.Position = UDim2.fromOffset(0, 162);
TextLabel5.Size = UDim2.new(1, 0, 0, 22);
TextLabel5.Font = Enum.Font.JosefinSans;
TextLabel5.TextColor3 = Color3.fromRGB(224, 92, 92);
TextLabel5.TextSize = 16;
TextLabel5.TextXAlignment = Enum.TextXAlignment.Right;
TextLabel5.Text = "";
TextLabel5.Visible = false;
TextLabel5.Parent = Frame;
local TextLabel6 = Instance.new("TextLabel");
TextLabel6.Name = "Ornament";
TextLabel6.BackgroundTransparency = 1;
TextLabel6.Size = UDim2.new(1, 0, 0, 22);
TextLabel6.Font = Enum.Font.JosefinSans;
TextLabel6.TextSize = 14;
TextLabel6.TextColor3 = Color3.fromRGB(125, 88, 27);
TextLabel6.TextStrokeColor3 = Color3.fromRGB(30, 18, 4);
TextLabel6.TextStrokeTransparency = 0.25;
TextLabel6.TextXAlignment = Enum.TextXAlignment.Right;
TextLabel6.Text = "◆ ───────────── ◆";
TextLabel6.Parent = Frame;
local u9 = nil;
local u10 = nil;

local function notify(p11) -- Line: 258
end;

local function clearHighlight() -- Line: 271
    -- upvalues: u10 (ref)
    if u10 then
        u10:Destroy();
        u10 = nil;
    end;
end;

local function updateTargetHighlight() -- Line: 278
    -- upvalues: u10 (ref)
    if u10 then
        u10:Destroy();
        u10 = nil;
    end;
end;

local function updateTracker() -- Line: 304
    -- upvalues: Frame (copy), u10 (ref), LocalPlayer (copy), TextLabel (copy), TextLabel2 (copy), TextLabel3 (copy), TextLabel4 (copy), TextLabel5 (copy)
    Frame.Visible = false;

    if u10 then
        u10:Destroy();
        u10 = nil;
    end;

    local v12 = LocalPlayer:GetAttribute("Quest2Active") == true;
    Frame.Visible = v12;

    if not v12 then
        if u10 then
            u10:Destroy();
            u10 = nil;
        end;

        return;
    end;

    local v13 = LocalPlayer:GetAttribute("Quest2Title") or "MISSION";
    local v14 = tostring(v13);
    local v15 = LocalPlayer:GetAttribute("Quest2Description") or "";
    local v16 = tostring(v15);
    local v17 = tonumber(LocalPlayer:GetAttribute("Quest2Progress")) or 0;
    local math_max_ret = math.max(0, v17);
    local v18 = tonumber(LocalPlayer:GetAttribute("Quest2Required")) or 0;
    local math_max_ret2 = math.max(0, v18);
    local v19 = tonumber(LocalPlayer:GetAttribute("Quest2RewardXP")) or 0;
    local math_max_ret3 = math.max(0, v19);
    local v20 = tonumber(LocalPlayer:GetAttribute("Quest2RewardMoney")) or 0;
    local math_max_ret4 = math.max(0, v20);
    local v21 = LocalPlayer:GetAttribute("Quest2TargetName") or "";
    local v22 = tostring(v21);
    TextLabel.Text = v14;
    TextLabel2.Text = v16;
    TextLabel3.Text = string.format("%d / %d", math_max_ret, math_max_ret2);
    TextLabel4.Text = string.format("%d XP  |  $%d", math_max_ret3, math_max_ret4);
    TextLabel5.Visible = v22 ~= "";
    TextLabel5.Text = v22 == "" and "" or ("TARGET: " .. string.upper(v22) or "");

    if u10 then
        u10:Destroy();
        u10 = nil;
    end;
end;

local function canUsePaper(p23) -- Line: 249
    -- upvalues: LocalPlayer (copy)
    if not (p23 and (p23.Parent and p23:GetAttribute("Quest2Enabled") == true)) then
        return false;
    end;

    local v24 = tonumber(p23:GetAttribute("Quest2MinLevel")) or 0;
    local math_max_ret = math.max(0, v24);
    local v25 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;

    return math_max_ret <= math.max(0, v25);
end;

for _, v in ipairs({ "Quest2Active", "Quest2Title", "Quest2Description", "Quest2Progress", "Quest2Required", "Quest2RewardXP", "Quest2RewardMoney", "Quest2TargetUserId", "Quest2TargetName" }) do
    LocalPlayer:GetAttributeChangedSignal(v):Connect(updateTracker);
end;

Players.PlayerAdded:Connect(function(p26) -- Line: 346
    -- upvalues: updateTargetHighlight (copy)
    p26.CharacterAdded:Connect(function() -- Line: 347
        -- upvalues: updateTargetHighlight (ref)
        task.defer(updateTargetHighlight);
    end);
end);

for _, v in ipairs(Players:GetPlayers()) do
    v.CharacterAdded:Connect(function() -- Line: 352
        -- upvalues: updateTargetHighlight (copy)
        task.defer(updateTargetHighlight);
    end);
end;

local function refreshBillboard() -- Line: 357
    -- upvalues: u9 (ref), Quest2BillboardUI (copy), canUsePaper (copy), MissionName (copy), MissionDescription (copy), Reward (copy), LocalPlayer (copy), AcceptButton (copy)
    if not (u9 and u9.Parent) then
        Quest2BillboardUI.Enabled = false;
        Quest2BillboardUI.Adornee = nil;

        return;
    end;

    if not canUsePaper(u9) then
        Quest2BillboardUI.Enabled = false;
        Quest2BillboardUI.Adornee = nil;

        return;
    end;

    local v27 = u9:GetAttribute("Quest2OfferId") or "";

    if tostring(v27) == "" then
        Quest2BillboardUI.Enabled = false;

        return;
    end;

    local v28 = u9:GetAttribute("Quest2Title") or "MISSION";
    MissionName.Text = tostring(v28);
    local v29 = u9:GetAttribute("Quest2Description") or "";
    MissionDescription.Text = tostring(v29);
    local v30 = tonumber(u9:GetAttribute("Quest2XP")) or 0;
    local math_max_ret = math.max(0, v30);
    local v31 = tonumber(u9:GetAttribute("Quest2Money")) or 0;
    local math_max_ret2 = math.max(0, v31);
    Reward.Text = string.format("REWARD  •  %d XP  •  $%d", math_max_ret, math_max_ret2);

    if (LocalPlayer:GetAttribute("Quest2Active") == true or LocalPlayer:GetAttribute("QuestActive") == true) and true or LocalPlayer:GetAttribute("HumanSideQuestActive") == true then
        Quest2BillboardUI.Enabled = false;
        Quest2BillboardUI.Adornee = nil;

        return;
    end;

    AcceptButton.Text = "ACCEPT";
    AcceptButton.Active = true;
    AcceptButton.AutoButtonColor = true;
    Quest2BillboardUI.Adornee = u9;
    Quest2BillboardUI.Enabled = true;
end;

AcceptButton.Activated:Connect(function() -- Line: 397
    -- upvalues: u9 (ref), LocalPlayer (copy), Quest2Remote (copy)
    if not (u9 and (LocalPlayer:GetAttribute("Quest2Active") ~= true and (LocalPlayer:GetAttribute("QuestActive") ~= true and LocalPlayer:GetAttribute("HumanSideQuestActive") ~= true))) then
        return;
    end;

    local v32 = u9:GetAttribute("Quest2OfferId") or "";
    local v33 = tostring(v32);

    if v33 == "" then
        return;
    end;

    Quest2Remote:FireServer("Accept", u9, v33);
end);
Quest2Remote.OnClientEvent:Connect(function(p34, p35) -- Line: 412
    -- upvalues: refreshBillboard (copy), updateTracker (copy), SFX (copy)
    if p34 == "Refresh" then
        refreshBillboard();

        return;
    end;

    if p34 ~= "State" then
        if p34 == "Completed" and type(p35) == "table" then
            if SFX.IsPlaying then
                SFX:Stop();
            end;

            SFX.TimePosition = 0;
            SFX:Play();
            string.format("%s complete! +%d XP and +$%d", tostring(p35.title or "Mission"), tonumber(p35.xp) or 0, tonumber(p35.money) or 0);
            updateTracker();
            refreshBillboard();
        end;

        return;
    end;

    if type(p35) == "table" and p35.message then
        local _ = p35.message;
    end;

    updateTracker();
    refreshBillboard();
end);
local u36 = 0;
RunService.RenderStepped:Connect(function(p37) -- Line: 434
    -- upvalues: u36 (ref), LocalPlayer (copy), u9 (ref), Quest2BillboardUI (copy), u4 (copy), canUsePaper (copy), refreshBillboard (copy)
    u36 = u36 + p37;

    if u36 < 0.08 then
        return;
    end;

    u36 = 0;
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    if not Character then
        u9 = nil;
        Quest2BillboardUI.Enabled = false;
        Quest2BillboardUI.Adornee = nil;

        return;
    end;

    local v38 = (1 / 0);
    local v39 = nil;

    for _, v in ipairs(u4) do
        if canUsePaper(v) then
            local Magnitude = (Character.Position - v.Position).Magnitude;
            local v40 = tonumber(v:GetAttribute("Quest2Range")) or 11;

            if Magnitude <= math.max(4, v40) and Magnitude < v38 then
                v39 = v;
                v38 = Magnitude;
            end;
        end;
    end;

    if v39 ~= u9 then
        u9 = v39;
    end;

    refreshBillboard();
end);
updateTracker();
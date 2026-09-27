-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("PathfindingService");
local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");
local Workspace = game:GetService("Workspace");
local UserInputService = game:GetService("UserInputService");
local LocalPlayer = Players.LocalPlayer;
local HunterQuestRemote = ReplicatedStorage:WaitForChild("HunterQuestRemotes"):WaitForChild("HunterQuestRemote");
local Quest2Remote = ReplicatedStorage:WaitForChild("Quest2Remotes"):WaitForChild("Quest2Remote");
local Color3_fromRGB_ret = Color3.fromRGB(212, 168, 70);
local Color3_fromRGB_ret2 = Color3.fromRGB(255, 218, 125);
local Color3_fromRGB_ret3 = Color3.fromRGB(125, 88, 27);
local Color3_fromRGB_ret4 = Color3.fromRGB(170, 130, 58);
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local HunterQuestGUI = PlayerGui:FindFirstChild("HunterQuestGUI");

if HunterQuestGUI then
    HunterQuestGUI:Destroy();
end;

local ScreenGui = Instance.new("ScreenGui");
ScreenGui.Name = "HunterQuestGUI";
ScreenGui.ResetOnSpawn = false;
ScreenGui.DisplayOrder = 100;
ScreenGui.Parent = PlayerGui;

local function styleText(p1, p2, p3) -- Line: 57
    -- upvalues: Color3_fromRGB_ret (copy)
    p1.BackgroundTransparency = 1;
    p1.Font = Enum.Font.JosefinSans;
    p1.TextSize = p2;
    p1.TextColor3 = p3 or Color3_fromRGB_ret;
    p1.TextStrokeColor3 = Color3.fromRGB(30, 18, 4);
    p1.TextStrokeTransparency = 0.25;
end;

local Frame = Instance.new("Frame");
Frame.AnchorPoint = Vector2.new(1, 0);
Frame.Position = UDim2.new(1, -35, 0.15, 0);
Frame.Size = UDim2.fromOffset(380, 125);
Frame.BackgroundTransparency = 1;
Frame.Visible = false;
Frame.Parent = ScreenGui;
local TextLabel = Instance.new("TextLabel");
TextLabel.Size = UDim2.new(1, 0, 0, 22);
TextLabel.Text = "◆ ───────────── ◆";
TextLabel.TextXAlignment = Enum.TextXAlignment.Right;
TextLabel.BackgroundTransparency = 1;
TextLabel.Font = Enum.Font.JosefinSans;
TextLabel.TextSize = 14;
TextLabel.TextColor3 = Color3_fromRGB_ret3 or Color3_fromRGB_ret;
TextLabel.TextStrokeColor3 = Color3.fromRGB(30, 18, 4);
TextLabel.TextStrokeTransparency = 0.25;
TextLabel.Parent = Frame;
local TextLabel2 = Instance.new("TextLabel");
TextLabel2.Position = UDim2.fromOffset(0, 20);
TextLabel2.Size = UDim2.new(1, 0, 0, 30);
TextLabel2.Text = "HUNT";
TextLabel2.TextXAlignment = Enum.TextXAlignment.Right;
TextLabel2.BackgroundTransparency = 1;
TextLabel2.Font = Enum.Font.JosefinSans;
TextLabel2.TextSize = 26;
TextLabel2.TextColor3 = Color3_fromRGB_ret2 or Color3_fromRGB_ret;
TextLabel2.TextStrokeColor3 = Color3.fromRGB(30, 18, 4);
TextLabel2.TextStrokeTransparency = 0.25;
TextLabel2.Parent = Frame;
local TextLabel3 = Instance.new("TextLabel");
TextLabel3.Position = UDim2.fromOffset(0, 52);
TextLabel3.Size = UDim2.new(1, 0, 0, 25);
TextLabel3.Text = "";
TextLabel3.TextXAlignment = Enum.TextXAlignment.Right;
TextLabel3.BackgroundTransparency = 1;
TextLabel3.Font = Enum.Font.JosefinSans;
TextLabel3.TextSize = 18;
TextLabel3.TextColor3 = Color3_fromRGB_ret;
TextLabel3.TextStrokeColor3 = Color3.fromRGB(30, 18, 4);
TextLabel3.TextStrokeTransparency = 0.25;
TextLabel3.Parent = Frame;
local TextLabel4 = Instance.new("TextLabel");
TextLabel4.Position = UDim2.fromOffset(0, 79);
TextLabel4.Size = UDim2.new(1, 0, 0, 32);
TextLabel4.Text = "";
TextLabel4.TextXAlignment = Enum.TextXAlignment.Right;
TextLabel4.BackgroundTransparency = 1;
TextLabel4.Font = Enum.Font.JosefinSans;
TextLabel4.TextSize = 24;
TextLabel4.TextColor3 = Color3_fromRGB_ret2 or Color3_fromRGB_ret;
TextLabel4.TextStrokeColor3 = Color3.fromRGB(30, 18, 4);
TextLabel4.TextStrokeTransparency = 0.25;
TextLabel4.Parent = Frame;
local Frame2 = Instance.new("Frame");
Frame2.AnchorPoint = Vector2.new(0.5, 1);
Frame2.Position = UDim2.new(0.5, 0, 1, -140);
Frame2.Size = UDim2.fromOffset(820, 250);
Frame2.BackgroundTransparency = 1;
Frame2.Visible = false;
Frame2.Parent = ScreenGui;
local Frame3 = Instance.new("Frame");
Frame3.AnchorPoint = Vector2.new(0.5, 0);
Frame3.Position = UDim2.new(0.5, 0, 0, 15);
Frame3.Size = UDim2.new(0.86, 0, 0, 1);
Frame3.BackgroundColor3 = Color3_fromRGB_ret3;
Frame3.BorderSizePixel = 0;
Frame3.Parent = Frame2;
local TextLabel5 = Instance.new("TextLabel");
TextLabel5.AnchorPoint = Vector2.new(0.5, 0.5);
TextLabel5.Position = UDim2.new(0.5, 0, 0, 15);
TextLabel5.Size = UDim2.fromOffset(40, 40);
TextLabel5.Text = "◆";
TextLabel5.BackgroundTransparency = 1;
TextLabel5.Font = Enum.Font.JosefinSans;
TextLabel5.TextSize = 19;
TextLabel5.TextColor3 = Color3_fromRGB_ret2 or Color3_fromRGB_ret;
TextLabel5.TextStrokeColor3 = Color3.fromRGB(30, 18, 4);
TextLabel5.TextStrokeTransparency = 0.25;
TextLabel5.Parent = Frame2;
local TextLabel6 = Instance.new("TextLabel");
TextLabel6.Position = UDim2.new(0, 0, 0, 31);
TextLabel6.Size = UDim2.new(1, 0, 0, 40);
TextLabel6.Text = "";
TextLabel6.TextXAlignment = Enum.TextXAlignment.Center;
TextLabel6.BackgroundTransparency = 1;
TextLabel6.Font = Enum.Font.JosefinSans;
TextLabel6.TextSize = 30;
TextLabel6.TextColor3 = Color3_fromRGB_ret2 or Color3_fromRGB_ret;
TextLabel6.TextStrokeColor3 = Color3.fromRGB(30, 18, 4);
TextLabel6.TextStrokeTransparency = 0.25;
TextLabel6.Parent = Frame2;
local TextLabel7 = Instance.new("TextLabel");
TextLabel7.AnchorPoint = Vector2.new(0.5, 0);
TextLabel7.Position = UDim2.new(0.5, 0, 0, 80);
TextLabel7.Size = UDim2.new(0.88, 0, 0, 95);
TextLabel7.TextWrapped = true;
TextLabel7.TextXAlignment = Enum.TextXAlignment.Center;
TextLabel7.TextYAlignment = Enum.TextYAlignment.Top;
TextLabel7.BackgroundTransparency = 1;
TextLabel7.Font = Enum.Font.JosefinSans;
TextLabel7.TextSize = 20;
TextLabel7.TextColor3 = Color3_fromRGB_ret;
TextLabel7.TextStrokeColor3 = Color3.fromRGB(30, 18, 4);
TextLabel7.TextStrokeTransparency = 0.25;
TextLabel7.Parent = Frame2;
local Frame4 = Instance.new("Frame");
Frame4.AnchorPoint = Vector2.new(0.5, 0);
Frame4.Position = UDim2.new(0.5, 0, 0, 176);
Frame4.Size = UDim2.new(0.65, 0, 0, 1);
Frame4.BackgroundColor3 = Color3_fromRGB_ret3;
Frame4.BorderSizePixel = 0;
Frame4.Parent = Frame2;
local Frame5 = Instance.new("Frame");
Frame5.AnchorPoint = Vector2.new(0.5, 0);
Frame5.Position = UDim2.new(0.5, 0, 0, 194);
Frame5.Size = UDim2.fromOffset(420, 45);
Frame5.BackgroundTransparency = 1;
Frame5.Parent = Frame2;
local TextButton = Instance.new("TextButton");
TextButton.Position = UDim2.fromOffset(5, 0);
TextButton.Size = UDim2.fromOffset(195, 40);
TextButton.AutoButtonColor = false;
TextButton.BackgroundTransparency = 1;
TextButton.Font = Enum.Font.JosefinSans;
TextButton.TextSize = 19;
TextButton.TextColor3 = Color3_fromRGB_ret4 or Color3_fromRGB_ret;
TextButton.TextStrokeColor3 = Color3.fromRGB(30, 18, 4);
TextButton.TextStrokeTransparency = 0.25;
TextButton.Parent = Frame5;
local UIStroke = Instance.new("UIStroke");
UIStroke.Color = Color3_fromRGB_ret3;
UIStroke.Thickness = 1;
UIStroke.Transparency = 0.35;
UIStroke.Parent = TextButton;
local TextButton2 = Instance.new("TextButton");
TextButton2.Position = UDim2.fromOffset(220, 0);
TextButton2.Size = UDim2.fromOffset(195, 40);
TextButton2.AutoButtonColor = false;
TextButton2.BackgroundTransparency = 1;
TextButton2.Font = Enum.Font.JosefinSans;
TextButton2.TextSize = 19;
TextButton2.TextColor3 = Color3_fromRGB_ret2 or Color3_fromRGB_ret;
TextButton2.TextStrokeColor3 = Color3.fromRGB(30, 18, 4);
TextButton2.TextStrokeTransparency = 0.25;
TextButton2.Parent = Frame5;
local UIStroke2 = Instance.new("UIStroke");
UIStroke2.Color = Color3_fromRGB_ret;
UIStroke2.Thickness = 1;
UIStroke2.Transparency = 0.2;
UIStroke2.Parent = TextButton2;
local u4 = nil;
local u5 = 0;

local function typeText(p6) -- Line: 191
    -- upvalues: u5 (ref), TextLabel7 (copy)
    u5 = u5 + 1;
    local u7 = u5;
    TextLabel7.Text = p6;
    TextLabel7.MaxVisibleGraphemes = 0;
    local u8 = utf8.len(p6) or #p6;
    task.spawn(function() -- Line: 202
        -- upvalues: u8 (copy), u7 (copy), u5 (ref), TextLabel7 (ref)
        for i = 1, u8 do
            if u7 ~= u5 then
                return;
            end;

            TextLabel7.MaxVisibleGraphemes = i;
            task.wait(0.012);
            local _ = i;
        end;
    end);
end;

local function openDialogue(p9, p10, p11) -- Line: 214
    -- upvalues: LocalPlayer (copy), UserInputService (copy), u4 (ref), Frame2 (copy), TextLabel6 (copy), TextButton (copy), TextButton2 (copy), u5 (ref), TextLabel7 (copy)
    if LocalPlayer then
        pcall(function() -- Line: 215
            -- upvalues: LocalPlayer (ref)
            LocalPlayer.DevEnableMouseLock = false;
        end);
    end;

    pcall(function() -- Line: 216
        -- upvalues: UserInputService (ref)
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default;
    end);
    u4 = p9;
    Frame2.Visible = true;
    TextLabel6.Text = string.upper(p10);

    if p9 == "MissionChoice" then
        TextButton.Text = "HUNT HUNTERS";
        TextButton2.Visible = false;
        TextButton.Visible = true;
        TextButton.Position = UDim2.fromScale(0.5, 0);
        TextButton.AnchorPoint = Vector2.new(0.5, 0);
        TextButton2.Position = UDim2.fromOffset(220, 0);
    else
        TextButton.Visible = false;
        TextButton2.Visible = true;
        TextButton2.Text = "CONTINUE";
        TextButton2.Position = UDim2.fromOffset(112, 0);
    end;

    u5 = u5 + 1;
    local u12 = u5;
    TextLabel7.Text = p11;
    TextLabel7.MaxVisibleGraphemes = 0;
    local u13 = utf8.len(p11) or #p11;
    task.spawn(function() -- Line: 202
        -- upvalues: u13 (copy), u12 (copy), u5 (ref), TextLabel7 (ref)
        for i = 1, u13 do
            if u12 ~= u5 then
                return;
            end;

            TextLabel7.MaxVisibleGraphemes = i;
            task.wait(0.012);
            local _ = i;
        end;
    end);
end;

local function closeDialogue() -- Line: 246
    -- upvalues: u5 (ref), TextLabel7 (copy), Frame2 (copy), u4 (ref), LocalPlayer (copy)
    u5 = u5 + 1;
    TextLabel7.MaxVisibleGraphemes = -1;
    Frame2.Visible = false;
    u4 = nil;

    if LocalPlayer then
        pcall(function() -- Line: 251
            -- upvalues: LocalPlayer (ref)
            LocalPlayer.DevEnableMouseLock = true;
        end);
    end;
end;

TextButton.Activated:Connect(function() -- Line: 254
    -- upvalues: u4 (ref), HunterQuestRemote (copy), u5 (ref), TextLabel7 (copy), Frame2 (copy), LocalPlayer (copy)
    if u4 == "MissionChoice" then
        HunterQuestRemote:FireServer("ChooseKill");
    end;

    u5 = u5 + 1;
    TextLabel7.MaxVisibleGraphemes = -1;
    Frame2.Visible = false;
    u4 = nil;

    if LocalPlayer then
        pcall(function() -- Line: 251
            -- upvalues: LocalPlayer (ref)
            LocalPlayer.DevEnableMouseLock = true;
        end);
    end;
end);
TextButton2.Activated:Connect(function() -- Line: 262
    -- upvalues: u4 (ref), HunterQuestRemote (copy), u5 (ref), TextLabel7 (copy), Frame2 (copy), LocalPlayer (copy)
    if u4 == "MissionChoice" then
        HunterQuestRemote:FireServer("ChooseDelivery");
    end;

    u5 = u5 + 1;
    TextLabel7.MaxVisibleGraphemes = -1;
    Frame2.Visible = false;
    u4 = nil;

    if LocalPlayer then
        pcall(function() -- Line: 251
            -- upvalues: LocalPlayer (ref)
            LocalPlayer.DevEnableMouseLock = true;
        end);
    end;
end);
local u14 = {};

local function registerHuman(p15) -- Line: 272
    -- upvalues: u14 (copy)
    if p15:IsA("Model") and p15.Name == "Hunter" then
        u14[p15] = true;
    end;
end;

for _, descendant in ipairs(Workspace:GetDescendants()) do
    if descendant:IsA("Model") and descendant.Name == "Hunter" then
        u14[descendant] = true;
    end;
end;

Workspace.DescendantAdded:Connect(registerHuman);
Workspace.DescendantRemoving:Connect(function(p16) -- Line: 292
    -- upvalues: u14 (copy)
    u14[p16] = nil;
end);
local Folder = Instance.new("Folder");
Folder.Name = "QuestTrail";
Folder.Parent = Workspace;
local u17 = nil;
local u18 = nil;
local u19 = nil;
local u20 = nil;
local u21 = false;
local u22 = "Human";
local u23 = nil;
local u24 = nil;
local u25 = 0;
local u26 = false;

local function clearTrail() -- Line: 314
    -- upvalues: u25 (ref), Folder (copy)
    u25 = u25 + 1;

    for _, child in ipairs(Folder:GetChildren()) do
        child:Destroy();
    end;
end;

local function clearTargetVisual() -- Line: 324
    -- upvalues: u20 (ref), u18 (ref), u19 (ref)
    if u20 then
        u20:Disconnect();
        u20 = nil;
    end;

    if u18 then
        u18:Destroy();
        u18 = nil;
    end;

    if u19 then
        u19:Destroy();
        u19 = nil;
    end;
end;

local function getRoot(p27) -- Line: 341
    if not p27 then
        return nil;
    end;

    if p27:IsA("BasePart") then
        return p27;
    end;

    if p27:IsA("Model") then
        return p27:FindFirstChild("HumanoidRootPart") or p27:FindFirstChild("Head") or (p27.PrimaryPart or p27:FindFirstChildWhichIsA("BasePart", true));
    end;

    return nil;
end;

local function getPlayerRoot() -- Line: 360
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if Character then
        return Character:FindFirstChild("HumanoidRootPart");
    end;

    return nil;
end;

local function findNearestHuman() -- Line: 373
    -- upvalues: LocalPlayer (copy), u14 (copy), getRoot (copy)
    local Character = LocalPlayer.Character;
    local v28;

    if Character then
        v28 = Character:FindFirstChild("HumanoidRootPart");
    else
        v28 = nil;
    end;

    if not v28 then
        return nil;
    end;

    local v29 = (1 / 0);
    local v30 = nil;

    for i in pairs(u14) do
        if i.Parent then
            local v31 = i:FindFirstChildOfClass("Humanoid");
            local v32 = getRoot(i);

            if v31 and (v32 and v31.Health > 0) then
                local Magnitude = (v28.Position - v32.Position).Magnitude;

                if Magnitude < v29 then
                    v30 = i;
                    v29 = Magnitude;
                end;
            end;
        end;
    end;

    return v30;
end;

local function findQuestNPC() -- Line: 416
    -- upvalues: Workspace (copy)
    return Workspace:FindFirstChild("NPCQuest2", true);
end;

local function findDeliveryPoint() -- Line: 423
    -- upvalues: Workspace (copy)
    return Workspace:FindFirstChild("DeliveryPoint", true);
end;

local function findNearestQuest2Model(p33) -- Line: 430
    -- upvalues: LocalPlayer (copy), Workspace (copy), getRoot (copy), Players (copy)
    local Character = LocalPlayer.Character;
    local v34;

    if Character then
        v34 = Character:FindFirstChild("HumanoidRootPart");
    else
        v34 = nil;
    end;

    if not v34 then
        return nil;
    end;

    local v35 = (1 / 0);
    local v36 = nil;

    for _, descendant in ipairs(Workspace:GetDescendants()) do
        if descendant:IsA("Model") then
            local v37 = descendant:FindFirstChildOfClass("Humanoid");
            local v38 = getRoot(descendant);
            local PlayerFromCharacter = Players:GetPlayerFromCharacter(descendant);
            local v39 = false;

            if v37 and (v37.Health > 0 and v38) then
                if p33 == "Quest2Guard" then
                    if descendant:GetAttribute("GuardNPC") == true and descendant:GetAttribute("BossGuard") ~= true then
                        v39 = descendant:GetAttribute("HomeCity") == "CIDADE";
                    else
                        v39 = false;
                    end;
                elseif p33 == "Quest2NPC" then
                    if PlayerFromCharacter == nil and descendant:GetAttribute("GuardNPC") ~= true then
                        v39 = descendant:GetAttribute("TargetCity") == "CIDADE";
                    else
                        v39 = false;
                    end;
                end;
            end;

            if v39 then
                local Magnitude = (v34.Position - v38.Position).Magnitude;

                if Magnitude < v35 then
                    v36 = descendant;
                    v35 = Magnitude;
                end;
            end;
        end;
    end;

    return v36;
end;

local function findQuest2PlayerTarget() -- Line: 469
    -- upvalues: LocalPlayer (copy), Players (copy)
    local v40 = tonumber(LocalPlayer:GetAttribute("Quest2TargetUserId")) or 0;

    if v40 <= 0 then
        return nil;
    end;

    local PlayerByUserId = Players:GetPlayerByUserId(v40);

    if PlayerByUserId then
        PlayerByUserId = PlayerByUserId.Character;
    end;

    local v41;

    if PlayerByUserId then
        v41 = PlayerByUserId:FindFirstChildOfClass("Humanoid");
    else
        v41 = PlayerByUserId;
    end;

    if PlayerByUserId and (v41 and v41.Health > 0) then
        return PlayerByUserId;
    end;

    return nil;
end;

local function findStakeShop() -- Line: 483
    -- upvalues: u17 (ref), LocalPlayer (copy), Workspace (copy)
    if u17 and (u17:IsA("BasePart") and (u17.Parent and (u17:GetAttribute("ShopEnabled") == true and u17:GetAttribute("ShopItemName") == "Stake"))) then
        return u17;
    end;

    local Character = LocalPlayer.Character;
    local v42;

    if Character then
        v42 = Character:FindFirstChild("HumanoidRootPart");
    else
        v42 = nil;
    end;

    local v43 = (1 / 0);
    local v44 = nil;

    for _, descendant in ipairs(Workspace:GetDescendants()) do
        if descendant:IsA("BasePart") and (descendant:GetAttribute("ShopEnabled") == true and descendant:GetAttribute("ShopItemName") == "Stake") then
            local v45 = v42 and ((v42.Position - descendant.Position).Magnitude or 0) or 0;

            if v45 < v43 then
                v44 = descendant;
                v43 = v45;
            end;
        end;
    end;

    return v44;
end;

local u46 = nil;

local function createTargetMarker(p47, u48) -- Line: 513
    -- upvalues: u20 (ref), u18 (ref), u19 (ref), getRoot (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy), Workspace (copy), PlayerGui (copy), u25 (ref), Folder (copy), u21 (ref), u22 (ref), u46 (ref)
    if u20 then
        u20:Disconnect();
        u20 = nil;
    end;

    if u18 then
        u18:Destroy();
        u18 = nil;
    end;

    if u19 then
        u19:Destroy();
        u19 = nil;
    end;

    local v49 = getRoot(p47);

    if not v49 then
        return;
    end;

    u18 = Instance.new("Highlight");
    u18.Adornee = p47;
    u18.FillColor = Color3_fromRGB_ret;
    u18.OutlineColor = Color3_fromRGB_ret2;
    u18.FillTransparency = 0.93;
    u18.OutlineTransparency = 0.15;
    u18.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
    u18.Parent = Workspace;
    u19 = Instance.new("BillboardGui");
    u19.Adornee = v49;
    u19.Size = UDim2.fromOffset(240, 72);
    u19.StudsOffset = Vector3.new(0, 4.5, 0);
    u19.AlwaysOnTop = true;
    u19.Parent = PlayerGui;
    local TextLabel8 = Instance.new("TextLabel");
    TextLabel8.BackgroundTransparency = 1;
    TextLabel8.Size = UDim2.new(1, 0, 0, 34);
    TextLabel8.Font = Enum.Font.JosefinSans;
    TextLabel8.TextSize = 23;
    TextLabel8.TextColor3 = Color3_fromRGB_ret2;
    TextLabel8.TextStrokeColor3 = Color3.fromRGB(20, 12, 2);
    TextLabel8.TextStrokeTransparency = 0.2;

    if u48 == "Human" or (u48 == "Quest2Guard" or (u48 == "Quest2NPC" or u48 == "Quest2Player")) then
        TextLabel8.Text = "◆ TARGET";
    elseif u48 == "Quest2Stake" then
        TextLabel8.Text = "◆ SHOP";
    elseif u48 == "Delivery" then
        TextLabel8.Text = "◆ WAREHOUSE";
    else
        TextLabel8.Text = "◆ RETURN";
    end;

    TextLabel8.Parent = u19;
    local TextLabel9 = Instance.new("TextLabel");
    TextLabel9.Name = "Distance";
    TextLabel9.Position = UDim2.fromOffset(0, 32);
    TextLabel9.Size = UDim2.new(1, 0, 0, 24);
    TextLabel9.BackgroundTransparency = 1;
    TextLabel9.Font = Enum.Font.JosefinSans;
    TextLabel9.TextSize = 16;
    TextLabel9.TextColor3 = Color3_fromRGB_ret;
    TextLabel9.TextStrokeColor3 = Color3.fromRGB(20, 12, 2);
    TextLabel9.TextStrokeTransparency = 0.3;
    TextLabel9.Parent = u19;
    local v50 = (u48 == "Human" or (u48 == "Quest2Guard" or (u48 == "Quest2NPC" or u48 == "Quest2Player"))) and p47:FindFirstChildOfClass("Humanoid");

    if v50 then
        u20 = v50.Died:Connect(function() -- Line: 598
            -- upvalues: u25 (ref), Folder (ref), u21 (ref), u22 (ref), u48 (copy), u46 (ref)
            u25 = u25 + 1;

            for _, child in ipairs(Folder:GetChildren()) do
                child:Destroy();
            end;

            task.delay(0.08, function() -- Line: 600
                -- upvalues: u21 (ref), u22 (ref), u48 (ref), u46 (ref)
                if u21 and u22 == u48 then
                    u46(true);
                end;
            end);
        end);
    end;
end;

local function createGroundArrow(p51, p52, p53) -- Line: 610
    -- upvalues: Folder (copy), LocalPlayer (copy), u17 (ref), Workspace (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret3 (copy), TweenService (copy)
    local Vector3_new_ret = Vector3.new(p52.X, 0, p52.Z);

    if Vector3_new_ret.Magnitude < 0.05 then
        return;
    end;

    local Unit = Vector3_new_ret.Unit;
    local RaycastParams_new_ret = RaycastParams.new();
    RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
    local v54 = { Folder };

    if LocalPlayer.Character then
        table.insert(v54, LocalPlayer.Character);
    end;

    if u17 then
        table.insert(v54, u17);
    end;

    RaycastParams_new_ret.FilterDescendantsInstances = v54;
    local v55 = Workspace:Raycast(p51 + Vector3.new(0, 10, 0), Vector3.new(0, -30, 0), RaycastParams_new_ret);

    if not v55 then
        return;
    end;

    local Part = Instance.new("Part");
    Part.Size = Vector3.new(3.2, 0.05, 3.2);
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanTouch = false;
    Part.CanQuery = false;
    Part.CastShadow = false;
    Part.Transparency = 1;
    Part.CFrame = CFrame.lookAt(v55.Position + Vector3.new(0, 0.075, 0), v55.Position + Unit);
    Part.Parent = Folder;
    local SurfaceGui = Instance.new("SurfaceGui");
    SurfaceGui.Face = Enum.NormalId.Top;
    SurfaceGui.CanvasSize = Vector2.new(180, 180);
    SurfaceGui.LightInfluence = 0;
    SurfaceGui.Parent = Part;
    local TextLabel8 = Instance.new("TextLabel");
    TextLabel8.BackgroundTransparency = 1;
    TextLabel8.Size = UDim2.fromScale(1, 1);
    TextLabel8.Font = Enum.Font.JosefinSans;
    TextLabel8.Text = "▲";
    TextLabel8.TextScaled = true;
    TextLabel8.TextColor3 = p53 % 2 == 0 and Color3_fromRGB_ret or Color3_fromRGB_ret2;
    TextLabel8.TextStrokeColor3 = Color3_fromRGB_ret3;
    TextLabel8.TextStrokeTransparency = 0.4;
    TextLabel8.TextTransparency = 1;
    TextLabel8.Parent = SurfaceGui;
    TweenService:Create(TextLabel8, TweenInfo.new(0.22), {
        TextTransparency = p53 % 2 == 0 and 0.18 or 0.3
    }):Play();
end;

local function buildTrail(p56, p57) -- Line: 726
    -- upvalues: u25 (ref), Folder (copy), createGroundArrow (copy)
    if p57 ~= u25 then
        return;
    end;

    for _, child in ipairs(Folder:GetChildren()) do
        child:Destroy();
    end;

    local v58 = 0;

    for i = 1, #p56 - 1 do
        if p57 ~= u25 then
            return;
        end;

        if v58 >= 45 then
            break;
        end;

        local v59 = p56[i];
        local v60 = p56[i + 1];
        local v61 = v60 - v59;
        local Magnitude = v61.Magnitude;
        local v62;

        if Magnitude > 0.1 then
            local Unit = v61.Unit;
            local math_floor_ret = math.floor(Magnitude / 6);
            local math_max_ret = math.max(1, math_floor_ret);
            v62 = i;

            for i2 = 1, math_max_ret do
                if v58 >= 45 then
                    break;
                end;

                local v63 = v59:Lerp(v60, i2 / math_max_ret);
                v58 = v58 + 1;
                createGroundArrow(v63, Unit, v58);
                local _ = i2;
            end;
        else
            v62 = i;
        end;
    end;
end;

local function calculatePath(p64) -- Line: 793
    -- upvalues: u25 (ref), Folder (copy)
    u25 = u25 + 1;

    for _, child in ipairs(Folder:GetChildren()) do
        child:Destroy();
    end;
end;

u46 = function(p65) -- Line: 798
    -- upvalues: u21 (ref), u17 (ref), u25 (ref), Folder (copy), u20 (ref), u18 (ref), u19 (ref), u22 (ref), findNearestHuman (copy), Workspace (copy), findNearestQuest2Model (copy), findQuest2PlayerTarget (copy), findStakeShop (copy), u23 (ref), u24 (ref), createTargetMarker (copy), LocalPlayer (copy), getRoot (copy), u26 (ref)
    if not u21 then
        u17 = nil;
        u25 = u25 + 1;

        for _, child in ipairs(Folder:GetChildren()) do
            child:Destroy();
        end;

        if u20 then
            u20:Disconnect();
            u20 = nil;
        end;

        if u18 then
            u18:Destroy();
            u18 = nil;
        end;

        if u19 then
            u19:Destroy();
            u19 = nil;
        end;

        return;
    end;

    local v66 = nil;

    if u22 == "Human" then
        v66 = findNearestHuman();
    elseif u22 == "Delivery" then
        v66 = Workspace:FindFirstChild("DeliveryPoint", true);
    elseif u22 == "NPC" then
        v66 = Workspace:FindFirstChild("NPCQuest2", true);
    elseif u22 == "Quest2Guard" then
        v66 = findNearestQuest2Model("Quest2Guard");
    elseif u22 == "Quest2NPC" then
        v66 = findNearestQuest2Model("Quest2NPC");
    elseif u22 == "Quest2Player" then
        v66 = findQuest2PlayerTarget();
    elseif u22 == "Quest2Stake" then
        v66 = findStakeShop();
    end;

    if not v66 then
        u17 = nil;
        u25 = u25 + 1;

        for _, child in ipairs(Folder:GetChildren()) do
            child:Destroy();
        end;

        if u20 then
            u20:Disconnect();
            u20 = nil;
        end;

        if u18 then
            u18:Destroy();
            u18 = nil;
        end;

        if u19 then
            u19:Destroy();
            u19 = nil;
        end;

        return;
    end;

    if p65 or u17 ~= v66 then
        u17 = v66;
        u23 = nil;
        u24 = nil;
        createTargetMarker(u17, u22);
        u25 = u25 + 1;

        for _, child in ipairs(Folder:GetChildren()) do
            child:Destroy();
        end;

        return;
    end;

    local Character = LocalPlayer.Character;
    local v67;

    if Character then
        v67 = Character:FindFirstChild("HumanoidRootPart");
    else
        v67 = nil;
    end;

    local v68 = getRoot(u17);

    if not (v67 and v68) then
        return;
    end;

    local Magnitude = (v67.Position - v68.Position).Magnitude;

    if Magnitude <= 8 then
        if not u26 then
            u26 = true;
            u25 = u25 + 1;

            for _, child in ipairs(Folder:GetChildren()) do
                child:Destroy();
            end;
        end;

        return;
    end;

    if not u26 or Magnitude < 10 then
        if not u23 or (v67.Position - u23).Magnitude >= 5 or (not u24 or (v68.Position - u24).Magnitude >= 5) then
            u23 = v67.Position;
            u24 = v68.Position;
            u25 = u25 + 1;

            for _, child in ipairs(Folder:GetChildren()) do
                child:Destroy();
            end;
        end;

        return;
    end;

    u26 = false;
    u25 = u25 + 1;

    for _, child in ipairs(Folder:GetChildren()) do
        child:Destroy();
    end;

    u23 = v67.Position;
    u24 = v68.Position;
end;

RunService.Heartbeat:Connect(function() -- Line: 928
    -- upvalues: u17 (ref), u19 (ref), LocalPlayer (copy), getRoot (copy), u22 (ref)
    if not (u17 and u19) then
        return;
    end;

    local Character = LocalPlayer.Character;
    local v69;

    if Character then
        v69 = Character:FindFirstChild("HumanoidRootPart");
    else
        v69 = nil;
    end;

    local v70 = getRoot(u17);

    if not (v69 and v70) then
        return;
    end;

    local Magnitude = (v69.Position - v70.Position).Magnitude;
    local Distance = u19:FindFirstChild("Distance");

    if Distance then
        if Magnitude <= 8 then
            if u22 == "Delivery" then
                Distance.Text = "YOU HAVE ARRIVED";

                return;
            end;

            if u22 == "NPC" then
                Distance.Text = "TALK TO HIM";

                return;
            end;

            if u22 == "Quest2Stake" then
                Distance.Text = "SHOP NEARBY";

                return;
            end;

            Distance.Text = "TARGET NEARBY";

            return;
        end;

        Distance.Text = math.floor(Magnitude) .. " studs";
    end;
end);
task.spawn(function() -- Line: 976
    -- upvalues: u21 (ref), u46 (ref)
    while true do
        repeat
            task.wait(0.35);
        until u21;

        u46(false);
    end;
end);
local u71 = 0;
RunService.Heartbeat:Connect(function(p72) -- Line: 990
    -- upvalues: u4 (ref), Frame2 (copy), u71 (ref), LocalPlayer (copy), Workspace (copy), getRoot (copy), u5 (ref), TextLabel7 (copy)
    if u4 ~= "MissionChoice" or not Frame2.Visible then
        u71 = 0;

        return;
    end;

    u71 = u71 + p72;

    if u71 < 0.1 then
        return;
    end;

    u71 = 0;
    local Character = LocalPlayer.Character;
    local v73;

    if Character then
        v73 = Character:FindFirstChild("HumanoidRootPart");
    else
        v73 = nil;
    end;

    local v74 = getRoot((Workspace:FindFirstChild("NPCQuest2", true)));

    if not (v73 and (v74 and (v73.Position - v74.Position).Magnitude <= 14)) then
        u5 = u5 + 1;
        TextLabel7.MaxVisibleGraphemes = -1;
        Frame2.Visible = false;
        u4 = nil;

        if LocalPlayer then
            pcall(function() -- Line: 251
                -- upvalues: LocalPlayer (ref)
                LocalPlayer.DevEnableMouseLock = true;
            end);
        end;
    end;
end);

local function updateQuest2Tracker() -- Line: 1013
end;

for _, v in ipairs({ "Quest2Active", "QuestActive", "Quest2MissionId", "Quest2Title", "Quest2Progress", "Quest2Required", "Quest2TargetUserId", "Quest2TargetName", "DeliveryStage", "CarryingQuestCart" }) do
    LocalPlayer:GetAttributeChangedSignal(v):Connect(function() -- Line: 1103
        -- upvalues: updateQuest2Tracker (copy)
        task.defer(updateQuest2Tracker);
    end);
end;

Quest2Remote.OnClientEvent:Connect(function(p75, p76) -- Line: 1108
end);
HunterQuestRemote.OnClientEvent:Connect(function(p77, ...) -- Line: 1133
    -- upvalues: u5 (ref), TextLabel7 (copy), Frame2 (copy), u4 (ref), LocalPlayer (copy), openDialogue (copy), Frame (copy), u21 (ref), u17 (ref), u25 (ref), Folder (copy), u20 (ref), u18 (ref), u19 (ref), u22 (ref), TextLabel2 (copy), TextLabel3 (copy), TextLabel4 (copy), u46 (ref)
    local v78 = { ... };

    if p77 == "CloseDialogue" then
        u5 = u5 + 1;
        TextLabel7.MaxVisibleGraphemes = -1;
        Frame2.Visible = false;
        u4 = nil;

        if LocalPlayer then
            pcall(function() -- Line: 251
                -- upvalues: LocalPlayer (ref)
                LocalPlayer.DevEnableMouseLock = true;
            end);
        end;
    else
        if p77 == "MissionChoice" then
            openDialogue("MissionChoice", v78[1], v78[2]);

            return;
        end;

        if p77 == "Message" then
            openDialogue("Message", v78[1], v78[2]);

            return;
        end;

        if p77 == "Tracker" then
            local v79 = v78[1];
            local v80 = v78[2];
            local v81 = v78[3];
            local v82 = v78[4];
            Frame.Visible = v79;
            u21 = v79;

            if v79 then
                if v82 then
                    u22 = "NPC";
                    TextLabel2.Text = "HUNT COMPLETE";
                    TextLabel3.Text = "Return to the Stranger";
                    TextLabel4.Text = "◆ RETURN";
                else
                    u22 = "Human";
                    TextLabel2.Text = "HUNT";
                    TextLabel3.Text = "Eliminate the Hunters";
                    TextLabel4.Text = v80 .. " / " .. v81;
                end;

                u17 = nil;
                u46(true);

                return;
            end;

            u17 = nil;
            u25 = u25 + 1;

            for _, child in ipairs(Folder:GetChildren()) do
                child:Destroy();
            end;

            if u20 then
                u20:Disconnect();
                u20 = nil;
            end;

            if u18 then
                u18:Destroy();
                u18 = nil;
            end;

            if u19 then
                u19:Destroy();
                u19 = nil;
            end;

            return;
        end;

        if p77 == "DeliveryTracker" then
            local v83 = v78[1];
            local v84 = v78[2];
            Frame.Visible = v83;
            u21 = v83;

            if not v83 then
                u17 = nil;
                u25 = u25 + 1;

                for _, child in ipairs(Folder:GetChildren()) do
                    child:Destroy();
                end;

                if u20 then
                    u20:Disconnect();
                    u20 = nil;
                end;

                if u18 then
                    u18:Destroy();
                    u18 = nil;
                end;

                if u19 then
                    u19:Destroy();
                    u19 = nil;
                end;

                return;
            end;

            TextLabel2.Text = "DELIVERY";

            if v84 == "Pickup" then
                u22 = "Delivery";
                TextLabel3.Text = "Take the cart to the warehouse";
                TextLabel4.Text = "◆ COLLECT THE CARGO";
            elseif v84 == "Return" then
                u22 = "NPC";
                TextLabel3.Text = "Bring the three boxes back";
                TextLabel4.Text = "◆ RETURN";
            end;

            u17 = nil;
            u46(true);
        end;
    end;
end);
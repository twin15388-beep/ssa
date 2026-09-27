-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local UserInputService = game:GetService("UserInputService");
local LocalPlayer = Players.LocalPlayer;
local CorpseDeliveryQuestRemote = ReplicatedStorage:WaitForChild("CorpseDeliveryQuestRemote");
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local ScreenGui = Instance.new("ScreenGui");
ScreenGui.Name = "CorpseDeliveryQuestGui";
ScreenGui.ResetOnSpawn = false;
ScreenGui.DisplayOrder = 101;
ScreenGui.Parent = PlayerGui;
local Frame = Instance.new("Frame");
Frame.Name = "Tracker";
Frame.AnchorPoint = UserInputService.TouchEnabled and Vector2.new(0.5, 0) or Vector2.new(1, 0);
Frame.Position = UserInputService.TouchEnabled and UDim2.new(0.5, 0, 0, 42) or UDim2.new(1, -30, 0.16, 0);
Frame.Size = UserInputService.TouchEnabled and UDim2.new(0.75, 0, 0, 72) or UDim2.fromOffset(330, 100);
Frame.BackgroundTransparency = 1;
Frame.Visible = false;
Frame.Parent = ScreenGui;

local function label(p1, p2, p3, p4, p5) -- Line: 24
    -- upvalues: UserInputService (copy), Frame (copy)
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = p1;
    TextLabel.Position = UDim2.fromOffset(0, p2);
    TextLabel.Size = UDim2.new(1, 0, 0, p3);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Font = Enum.Font.JosefinSans;
    TextLabel.TextSize = p4;
    TextLabel.TextColor3 = p5;
    TextLabel.TextStrokeColor3 = Color3.new(0, 0, 0);
    TextLabel.TextStrokeTransparency = 0.35;
    TextLabel.TextXAlignment = UserInputService.TouchEnabled and Enum.TextXAlignment.Center or Enum.TextXAlignment.Right;
    TextLabel.TextWrapped = true;
    TextLabel.Parent = Frame;

    return TextLabel;
end;

local Color3_fromRGB_ret = Color3.fromRGB(255, 216, 135);
local u6 = label("Title", 0, UserInputService.TouchEnabled and 23 or 29, UserInputService.TouchEnabled and 16 or 24, Color3_fromRGB_ret);
local u7 = label("Objective", UserInputService.TouchEnabled and 22 or 30, UserInputService.TouchEnabled and 31 or 40, UserInputService.TouchEnabled and 12 or 17, Color3.new(1, 1, 1));
local u8 = label("Distance", UserInputService.TouchEnabled and 52 or 72, UserInputService.TouchEnabled and 18 or 22, UserInputService.TouchEnabled and 10 or 15, Color3_fromRGB_ret);
local TextLabel = Instance.new("TextLabel");
TextLabel.Name = "Notice";
TextLabel.AnchorPoint = Vector2.new(0.5, 0);
TextLabel.Position = UserInputService.TouchEnabled and UDim2.new(0.5, 0, 0, 115) or UDim2.new(0.5, 0, 0.16, 0);
TextLabel.Size = UserInputService.TouchEnabled and UDim2.new(0.85, 0, 0, 38) or UDim2.new(0.8, 0, 0, 54);
TextLabel.BackgroundTransparency = 1;
TextLabel.Font = Enum.Font.JosefinSans;
TextLabel.TextSize = UserInputService.TouchEnabled and 14 or 21;
TextLabel.TextColor3 = Color3_fromRGB_ret;
TextLabel.TextStrokeColor3 = Color3.new(0, 0, 0);
TextLabel.TextStrokeTransparency = 0.25;
TextLabel.TextWrapped = true;
TextLabel.Visible = false;
TextLabel.Parent = ScreenGui;
local u9 = 0;

local function showNotice(p10) -- Line: 60
    -- upvalues: u9 (ref), TextLabel (copy)
    if not p10 or p10 == "" then
        return;
    end;

    u9 = u9 + 1;
    local u11 = u9;
    TextLabel.Text = p10;
    TextLabel.Visible = true;
    task.delay(4, function() -- Line: 66
        -- upvalues: u11 (copy), u9 (ref), TextLabel (ref)
        if u11 == u9 then
            TextLabel.Visible = false;
        end;
    end);
end;

local BillboardGui = Instance.new("BillboardGui");
BillboardGui.Name = "CorpseQuestTarget";
BillboardGui.Size = UDim2.fromOffset(86, 28);
BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, 3.4, 0);
BillboardGui.AlwaysOnTop = true;
BillboardGui.MaxDistance = 450;
BillboardGui.Enabled = false;
BillboardGui.Parent = ScreenGui;
local TextLabel2 = Instance.new("TextLabel");
TextLabel2.Size = UDim2.fromScale(1, 1);
TextLabel2.BackgroundTransparency = 1;
TextLabel2.Font = Enum.Font.JosefinSans;
TextLabel2.TextSize = 15;
TextLabel2.TextColor3 = Color3_fromRGB_ret;
TextLabel2.TextStrokeColor3 = Color3.new(0, 0, 0);
TextLabel2.TextStrokeTransparency = 0.15;
TextLabel2.Parent = BillboardGui;

local function getCart() -- Line: 89
    -- upvalues: Workspace (copy), LocalPlayer (copy)
    return Workspace:FindFirstChild("CorpseQuestCart_" .. LocalPlayer.UserId);
end;

local function getTarget(p12) -- Line: 92
    -- upvalues: Workspace (copy), LocalPlayer (copy)
    if p12 == "Deliver" then
        return Workspace:FindFirstChild("DeliveryPoint", true), "CIDADE2";
    end;

    if p12 ~= "Collect" then
        return nil;
    end;

    if LocalPlayer:GetAttribute("CarryingQuestBody") == true then
        local v13 = Workspace:FindFirstChild("CorpseQuestCart_" .. LocalPlayer.UserId);

        if v13 then
            v13 = v13:FindFirstChild("Main");
        end;

        return v13, "CART";
    end;

    local v14 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart");
    local v15 = (1 / 0);
    local v16 = nil;

    for _, child in ipairs(Workspace:GetChildren()) do
        if child:IsA("Model") and (child.Name == "QuestCorpse" and (child:GetAttribute("CorpseQuestOwnerUserId") == LocalPlayer.UserId and child:GetAttribute("CorpseQuestBodyStatus") == "Ground")) then
            local Torso = child:FindFirstChild("Torso");

            if Torso then
                local v17 = v14 and ((v14.Position - Torso.Position).Magnitude or 0) or 0;

                if v17 < v15 then
                    v16 = Torso;
                    v15 = v17;
                end;
            end;
        end;
    end;

    return v16, "BODY";
end;

local function update() -- Line: 117
    -- upvalues: LocalPlayer (copy), Frame (copy), BillboardGui (copy), u6 (copy), u7 (copy), getTarget (copy), TextLabel2 (copy), u8 (copy)
    local v18 = LocalPlayer:GetAttribute("CorpseQuestStage") or "";
    Frame.Visible = v18 ~= "";

    if v18 == "" then
        BillboardGui.Enabled = false;
        BillboardGui.Adornee = nil;

        return;
    end;

    local v19 = tonumber(LocalPlayer:GetAttribute("CorpseQuestLoaded")) or 0;

    if v18 == "Collect" then
        u6.Text = ("BODIES %d/5"):format(v19);
        u7.Text = LocalPlayer:GetAttribute("CarryingQuestBody") == true and "Load the body into the cart in First City" or "Find a body and carry it to the cart";
    else
        u6.Text = "DELIVER THE CART";
        u7.Text = "Take the bodies to Second City for cremation";
    end;

    local v20, v21 = getTarget(v18);
    BillboardGui.Adornee = v20;
    BillboardGui.Enabled = v20 ~= nil;
    TextLabel2.Text = v21;
    local v22 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart");
    u8.Text = v22 and (v20 and ("%d studs"):format((math.floor((v22.Position - v20.Position).Magnitude + 0.5)))) or "";
end;

CorpseDeliveryQuestRemote.OnClientEvent:Connect(function(p23, p24, p25, p26) -- Line: 138
    -- upvalues: u9 (ref), TextLabel (copy), update (copy)
    if p26 and p26 ~= "" then
        u9 = u9 + 1;
        local u27 = u9;
        TextLabel.Text = p26;
        TextLabel.Visible = true;
        task.delay(4, function() -- Line: 66
            -- upvalues: u27 (copy), u9 (ref), TextLabel (ref)
            if u27 == u9 then
                TextLabel.Visible = false;
            end;
        end);
    end;

    update();
end);
LocalPlayer:GetAttributeChangedSignal("CorpseQuestStage"):Connect(update);
LocalPlayer:GetAttributeChangedSignal("CorpseQuestLoaded"):Connect(update);
LocalPlayer:GetAttributeChangedSignal("CarryingQuestBody"):Connect(update);
task.spawn(function() -- Line: 145
    -- upvalues: ScreenGui (copy), update (copy)
    while ScreenGui.Parent do
        update();
        task.wait(0.5);
    end;
end);
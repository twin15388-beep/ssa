-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local UserInputService = game:GetService("UserInputService");
local GuiService = game:GetService("GuiService");
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local HumanSideQuestRemote = ReplicatedStorage:WaitForChild("Funções"):WaitForChild("Eventos"):WaitForChild("HumanSideQuestRemote");
local HumanSideQuestUI = PlayerGui:FindFirstChild("HumanSideQuestUI");

if HumanSideQuestUI then
    HumanSideQuestUI:Destroy();
end;

local ScreenGui = Instance.new("ScreenGui");
ScreenGui.Name = "HumanSideQuestUI";
ScreenGui.ResetOnSpawn = false;
ScreenGui.IgnoreGuiInset = false;
ScreenGui.DisplayOrder = 15;
ScreenGui.Parent = PlayerGui;
local Frame = Instance.new("Frame");
Frame.Name = "Tracker";
Frame.AnchorPoint = Vector2.new(1, 0);
Frame.Position = UDim2.new(1, -35, 0.15, 0);
Frame.Size = UDim2.fromOffset(380, 150);
Frame.BackgroundTransparency = 1;
Frame.BorderSizePixel = 0;
Frame.Visible = false;
Frame.Parent = ScreenGui;
local Color3_fromRGB_ret = Color3.fromRGB(212, 168, 70);
local Color3_fromRGB_ret2 = Color3.fromRGB(255, 218, 125);
local Color3_fromRGB_ret3 = Color3.fromRGB(125, 88, 27);
local TextLabel = Instance.new("TextLabel");
TextLabel.Name = "Ornament";
TextLabel.BackgroundTransparency = 1;
TextLabel.Size = UDim2.new(1, 0, 0, 22);
TextLabel.Font = Enum.Font.JosefinSans;
TextLabel.TextSize = 14;
TextLabel.TextColor3 = Color3_fromRGB_ret3;
TextLabel.TextStrokeColor3 = Color3.fromRGB(30, 18, 4);
TextLabel.TextStrokeTransparency = 0.25;
TextLabel.TextXAlignment = Enum.TextXAlignment.Right;
TextLabel.Text = "◆ ───────────── ◆";
TextLabel.Parent = Frame;
local TextLabel2 = Instance.new("TextLabel");
TextLabel2.Name = "Title";
TextLabel2.BackgroundTransparency = 1;
TextLabel2.Position = UDim2.fromOffset(0, 20);
TextLabel2.Size = UDim2.new(1, 0, 0, 30);
TextLabel2.Font = Enum.Font.JosefinSans;
TextLabel2.TextScaled = false;
TextLabel2.TextSize = 26;
TextLabel2.TextColor3 = Color3_fromRGB_ret2;
TextLabel2.TextStrokeColor3 = Color3.fromRGB(30, 18, 4);
TextLabel2.TextStrokeTransparency = 0.25;
TextLabel2.TextXAlignment = Enum.TextXAlignment.Right;
TextLabel2.Text = "SIDE QUEST";
TextLabel2.Parent = Frame;
local TextLabel3 = Instance.new("TextLabel");
TextLabel3.Name = "Objective";
TextLabel3.BackgroundTransparency = 1;
TextLabel3.Position = UDim2.fromOffset(0, 52);
TextLabel3.Size = UDim2.new(1, 0, 0, 42);
TextLabel3.Font = Enum.Font.JosefinSans;
TextLabel3.TextSize = 18;
TextLabel3.TextColor3 = Color3_fromRGB_ret;
TextLabel3.TextStrokeColor3 = Color3.fromRGB(30, 18, 4);
TextLabel3.TextStrokeTransparency = 0.25;
TextLabel3.TextWrapped = true;
TextLabel3.TextXAlignment = Enum.TextXAlignment.Right;
TextLabel3.TextYAlignment = Enum.TextYAlignment.Top;
TextLabel3.Text = "";
TextLabel3.Parent = Frame;
local TextLabel4 = Instance.new("TextLabel");
TextLabel4.Name = "Progress";
TextLabel4.BackgroundTransparency = 1;
TextLabel4.Position = UDim2.fromOffset(0, 96);
TextLabel4.Size = UDim2.new(1, 0, 0, 28);
TextLabel4.Font = Enum.Font.JosefinSans;
TextLabel4.TextColor3 = Color3_fromRGB_ret2;
TextLabel4.TextStrokeColor3 = Color3.fromRGB(30, 18, 4);
TextLabel4.TextStrokeTransparency = 0.25;
TextLabel4.TextSize = 24;
TextLabel4.TextXAlignment = Enum.TextXAlignment.Right;
TextLabel4.Text = "0 / 1";
TextLabel4.Parent = Frame;
local TextLabel5 = Instance.new("TextLabel");
TextLabel5.Name = "Reward";
TextLabel5.BackgroundTransparency = 1;
TextLabel5.Position = UDim2.fromOffset(0, 124);
TextLabel5.Size = UDim2.new(1, 0, 0, 22);
TextLabel5.Font = Enum.Font.JosefinSans;
TextLabel5.TextColor3 = Color3_fromRGB_ret;
TextLabel5.TextStrokeColor3 = Color3.fromRGB(30, 18, 4);
TextLabel5.TextStrokeTransparency = 0.25;
TextLabel5.TextSize = 16;
TextLabel5.TextXAlignment = Enum.TextXAlignment.Right;
TextLabel5.Text = "$500 - $1000";
TextLabel5.Parent = Frame;
local TextLabel6 = Instance.new("TextLabel");
TextLabel6.Name = "Target";
TextLabel6.BackgroundTransparency = 1;
TextLabel6.Position = UDim2.fromOffset(0, 146);
TextLabel6.Size = UDim2.new(1, 0, 0, 22);
TextLabel6.Font = Enum.Font.JosefinSans;
TextLabel6.TextColor3 = Color3_fromRGB_ret2;
TextLabel6.TextStrokeColor3 = Color3.fromRGB(30, 18, 4);
TextLabel6.TextStrokeTransparency = 0.25;
TextLabel6.TextSize = 16;
TextLabel6.TextXAlignment = Enum.TextXAlignment.Right;
TextLabel6.Text = "";
TextLabel6.Visible = false;
TextLabel6.Parent = Frame;
local UIScale = Instance.new("UIScale");
UIScale.Name = "ResponsiveScale";
UIScale.Parent = Frame;

local function updateResponsiveTracker() -- Line: 127
    -- upvalues: UserInputService (copy), UIScale (copy), Frame (copy)
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if not workspace_CurrentCamera then
        return;
    end;

    local ViewportSize = workspace_CurrentCamera.ViewportSize;

    if not UserInputService.TouchEnabled and ViewportSize.Y > 600 then
        UIScale.Scale = 1;
        Frame.Position = UDim2.new(1, -35, 0.15, 0);

        return;
    end;

    local math_min_ret = math.min(ViewportSize.X / 1050, ViewportSize.Y / 620);
    UIScale.Scale = math.clamp(math_min_ret, 0.7, 0.86);
    local v1;

    if ViewportSize.X >= 700 then
        local math_floor_ret = math.floor(ViewportSize.X * 0.115 + 0.5);
        v1 = math.clamp(math_floor_ret, 72, 120) or 16;
    else
        v1 = 16;
    end;

    local math_floor_ret = math.floor(ViewportSize.Y * 0.15 + 0.5);
    local math_clamp_ret = math.clamp(math_floor_ret, 30, 80);
    Frame.Position = UDim2.new(1, -v1, 0, math_clamp_ret);
end;

local u2 = nil;

local function bindCamera() -- Line: 145
    -- upvalues: u2 (ref), updateResponsiveTracker (copy)
    if u2 then
        u2:Disconnect();
    end;

    if workspace.CurrentCamera then
        u2 = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateResponsiveTracker);
    end;

    updateResponsiveTracker();
end;

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindCamera);

if u2 then
    u2:Disconnect();
end;

if workspace.CurrentCamera then
    u2 = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateResponsiveTracker);
end;

updateResponsiveTracker();
local u3 = nil;

local function clearTargetHighlight() -- Line: 156
    -- upvalues: u3 (ref)
    if u3 then
        u3:Destroy();
        u3 = nil;
    end;
end;

local function markTarget(p4, p5) -- Line: 163
    -- upvalues: u3 (ref), TextLabel6 (copy)
    if u3 then
        u3:Destroy();
        u3 = nil;
    end;

    TextLabel6.Text = "TARGET: " .. p5;
    TextLabel6.Visible = true;

    if not (p4 and p4.Parent) then
        return;
    end;

    local Highlight = Instance.new("Highlight");
    Highlight.Name = "HumanSideQuestTargetHighlight";
    Highlight.FillColor = Color3.fromRGB(202, 163, 72);
    Highlight.FillTransparency = 0.65;
    Highlight.OutlineColor = Color3.fromRGB(255, 225, 150);
    Highlight.OutlineTransparency = 0;
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
    Highlight.Adornee = p4;
    Highlight.Parent = p4;
    u3 = Highlight;
end;

local Frame2 = Instance.new("Frame");
Frame2.Name = "Dialogue";
Frame2.AnchorPoint = Vector2.new(0.5, 1);
Frame2.Position = UDim2.new(0.5, 0, 1, -140);
Frame2.Size = UDim2.fromOffset(820, 250);
Frame2.BackgroundTransparency = 1;
Frame2.Visible = false;
Frame2.Parent = ScreenGui;
local UIScale2 = Instance.new("UIScale");
UIScale2.Name = "ResponsiveScale";
UIScale2.Parent = Frame2;
local Frame3 = Instance.new("Frame");
Frame3.AnchorPoint = Vector2.new(0.5, 0);
Frame3.Position = UDim2.new(0.5, 0, 0, 15);
Frame3.Size = UDim2.new(0.86, 0, 0, 1);
Frame3.BackgroundColor3 = Color3_fromRGB_ret3;
Frame3.BorderSizePixel = 0;
Frame3.Parent = Frame2;
local TextLabel7 = Instance.new("TextLabel");
TextLabel7.AnchorPoint = Vector2.new(0.5, 0.5);
TextLabel7.Position = UDim2.new(0.5, 0, 0, 15);
TextLabel7.Size = UDim2.fromOffset(40, 40);
TextLabel7.BackgroundTransparency = 1;
TextLabel7.Font = Enum.Font.JosefinSans;
TextLabel7.TextSize = 19;
TextLabel7.TextColor3 = Color3_fromRGB_ret2;
TextLabel7.TextStrokeColor3 = Color3.fromRGB(30, 18, 4);
TextLabel7.TextStrokeTransparency = 0.25;
TextLabel7.Text = "◆";
TextLabel7.Parent = Frame2;
local TextLabel8 = Instance.new("TextLabel");
TextLabel8.Position = UDim2.new(0, 0, 0, 31);
TextLabel8.Size = UDim2.new(1, 0, 0, 40);
TextLabel8.BackgroundTransparency = 1;
TextLabel8.Font = Enum.Font.JosefinSans;
TextLabel8.TextSize = 30;
TextLabel8.TextColor3 = Color3_fromRGB_ret2;
TextLabel8.TextStrokeColor3 = Color3.fromRGB(30, 18, 4);
TextLabel8.TextStrokeTransparency = 0.25;
TextLabel8.TextXAlignment = Enum.TextXAlignment.Center;
TextLabel8.Text = "VILLAGER";
TextLabel8.Parent = Frame2;
local TextLabel9 = Instance.new("TextLabel");
TextLabel9.AnchorPoint = Vector2.new(0.5, 0);
TextLabel9.Position = UDim2.new(0.5, 0, 0, 80);
TextLabel9.Size = UDim2.new(0.88, 0, 0, 95);
TextLabel9.BackgroundTransparency = 1;
TextLabel9.Font = Enum.Font.JosefinSans;
TextLabel9.TextSize = 20;
TextLabel9.TextColor3 = Color3_fromRGB_ret;
TextLabel9.TextStrokeColor3 = Color3.fromRGB(30, 18, 4);
TextLabel9.TextStrokeTransparency = 0.25;
TextLabel9.TextWrapped = true;
TextLabel9.TextXAlignment = Enum.TextXAlignment.Center;
TextLabel9.TextYAlignment = Enum.TextYAlignment.Top;
TextLabel9.Text = "";
TextLabel9.Parent = Frame2;
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
TextButton.Name = "Decline";
TextButton.Position = UDim2.fromOffset(5, 0);
TextButton.Size = UDim2.fromOffset(195, 40);
TextButton.BackgroundTransparency = 1;
TextButton.AutoButtonColor = false;
TextButton.Selectable = true;
TextButton.Font = Enum.Font.JosefinSans;
TextButton.TextSize = 19;
TextButton.TextColor3 = Color3.fromRGB(170, 130, 58);
TextButton.TextStrokeColor3 = Color3.fromRGB(30, 18, 4);
TextButton.TextStrokeTransparency = 0.25;
TextButton.Text = "DECLINE";
TextButton.Parent = Frame5;
local UIStroke = Instance.new("UIStroke");
UIStroke.Color = Color3_fromRGB_ret3;
UIStroke.Thickness = 1;
UIStroke.Transparency = 0.35;
UIStroke.Parent = TextButton;
local TextButton2 = Instance.new("TextButton");
TextButton2.Name = "Accept";
TextButton2.Position = UDim2.fromOffset(220, 0);
TextButton2.Size = UDim2.fromOffset(195, 40);
TextButton2.BackgroundTransparency = 1;
TextButton2.AutoButtonColor = false;
TextButton2.Selectable = true;
TextButton2.Font = Enum.Font.JosefinSans;
TextButton2.TextSize = 19;
TextButton2.TextColor3 = Color3_fromRGB_ret2;
TextButton2.TextStrokeColor3 = Color3.fromRGB(30, 18, 4);
TextButton2.TextStrokeTransparency = 0.25;
TextButton2.Text = "ACCEPT";
TextButton2.Parent = Frame5;
local UIStroke2 = Instance.new("UIStroke");
UIStroke2.Color = Color3_fromRGB_ret;
UIStroke2.Thickness = 1;
UIStroke2.Transparency = 0.2;
UIStroke2.Parent = TextButton2;
local u6 = 0;
local u7 = nil;

local function closeDialogue() -- Line: 301
    -- upvalues: u6 (ref), TextLabel9 (copy), Frame2 (copy), u7 (ref), GuiService (copy), TextButton2 (copy), TextButton (copy)
    u6 = u6 + 1;
    TextLabel9.MaxVisibleGraphemes = -1;
    Frame2.Visible = false;
    u7 = nil;

    if GuiService.SelectedObject == TextButton2 or GuiService.SelectedObject == TextButton then
        GuiService.SelectedObject = nil;
    end;
end;

local function openOffer(p8) -- Line: 311
    -- upvalues: u7 (ref), TextButton (copy), TextButton2 (copy), u6 (ref), Frame2 (copy), TextLabel8 (copy), TextLabel9 (copy), UserInputService (copy), GuiService (copy)
    u7 = "Offer";
    TextButton.Visible = true;
    TextButton2.Text = "ACCEPT";
    TextButton2.Position = UDim2.fromOffset(220, 0);
    u6 = u6 + 1;
    local u9 = u6;
    Frame2.Visible = true;
    TextLabel8.Text = string.upper((tostring(p8.npcName or "Villager")));
    local u10 = tostring(p8.text or "Do you accept this mission?");
    TextLabel9.Text = u10;
    TextLabel9.MaxVisibleGraphemes = 0;

    if UserInputService.GamepadEnabled and not UserInputService.TouchEnabled then
        GuiService.SelectedObject = TextButton2;
    end;

    task.spawn(function() -- Line: 326
        -- upvalues: u10 (copy), u9 (copy), u6 (ref), Frame2 (ref), TextLabel9 (ref)
        for i = 1, utf8.len(u10) or #u10 do
            if u9 ~= u6 or not Frame2.Visible then
                return;
            end;

            TextLabel9.MaxVisibleGraphemes = i;
            task.wait(0.012);
            local _ = i;
        end;
    end);
end;

local function openCompletion(p11) -- Line: 336
    -- upvalues: u6 (ref), u7 (ref), Frame2 (copy), TextLabel8 (copy), TextLabel9 (copy), TextButton (copy), TextButton2 (copy), UserInputService (copy), GuiService (copy)
    u6 = u6 + 1;
    u7 = "Completed";
    Frame2.Visible = true;
    TextLabel8.Text = "VILLAGER";
    TextLabel9.Text = string.format("Mission complete! You received $%d.", tonumber(p11.money) or 0);
    TextLabel9.MaxVisibleGraphemes = -1;
    TextButton.Visible = false;
    TextButton2.Text = "CONTINUE";
    TextButton2.Position = UDim2.fromOffset(112, 0);

    if UserInputService.GamepadEnabled and not UserInputService.TouchEnabled then
        GuiService.SelectedObject = TextButton2;
    end;
end;

TextButton2.Activated:Connect(function() -- Line: 351
    -- upvalues: Frame2 (copy), u7 (ref), HumanSideQuestRemote (copy), Frame (copy), u6 (ref), TextLabel9 (copy), GuiService (copy), TextButton2 (copy), TextButton (copy)
    if not Frame2.Visible then
        return;
    end;

    if u7 == "Offer" then
        HumanSideQuestRemote:FireServer("AcceptOffer");
    elseif u7 == "Completed" then
        Frame.Visible = false;
    end;

    u6 = u6 + 1;
    TextLabel9.MaxVisibleGraphemes = -1;
    Frame2.Visible = false;
    u7 = nil;

    if GuiService.SelectedObject == TextButton2 or GuiService.SelectedObject == TextButton then
        GuiService.SelectedObject = nil;
    end;
end);
TextButton.Activated:Connect(function() -- Line: 361
    -- upvalues: Frame2 (copy), HumanSideQuestRemote (copy), u6 (ref), TextLabel9 (copy), u7 (ref), GuiService (copy), TextButton2 (copy), TextButton (copy)
    if not Frame2.Visible then
        return;
    end;

    HumanSideQuestRemote:FireServer("DeclineOffer");
    u6 = u6 + 1;
    TextLabel9.MaxVisibleGraphemes = -1;
    Frame2.Visible = false;
    u7 = nil;

    if GuiService.SelectedObject == TextButton2 or GuiService.SelectedObject == TextButton then
        GuiService.SelectedObject = nil;
    end;
end);

local function updateDialogueResponsive() -- Line: 367
    -- upvalues: UIScale2 (copy), UserInputService (copy), Frame2 (copy)
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if not workspace_CurrentCamera then
        return;
    end;

    local ViewportSize = workspace_CurrentCamera.ViewportSize;
    local math_min_ret = math.min(ViewportSize.X / 950, ViewportSize.Y / 650);
    UIScale2.Scale = math.clamp(math_min_ret, 0.62, 1);
    Frame2.Position = UDim2.new(0.5, 0, 1, -(UserInputService.TouchEnabled and 105 or 140));
end;

if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateDialogueResponsive);
end;

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(updateDialogueResponsive);
local workspace_CurrentCamera = workspace.CurrentCamera;

if workspace_CurrentCamera then
    local ViewportSize = workspace_CurrentCamera.ViewportSize;
    local math_min_ret = math.min(ViewportSize.X / 950, ViewportSize.Y / 650);
    UIScale2.Scale = math.clamp(math_min_ret, 0.62, 1);
    Frame2.Position = UDim2.new(0.5, 0, 1, -(UserInputService.TouchEnabled and 105 or 140));
end;

local TextLabel10 = Instance.new("TextLabel");
TextLabel10.Name = "Notice";
TextLabel10.AnchorPoint = Vector2.new(0.5, 0);
TextLabel10.Position = UDim2.new(0.5, 0, 0, 78);
TextLabel10.Size = UDim2.new(0.82, 0, 0, 42);
local UISizeConstraint = Instance.new("UISizeConstraint");
UISizeConstraint.MaxSize = Vector2.new(620, 42);
UISizeConstraint.MinSize = Vector2.new(240, 42);
UISizeConstraint.Parent = TextLabel10;
TextLabel10.BackgroundTransparency = 1;
TextLabel10.TextTransparency = 1;
TextLabel10.Font = Enum.Font.JosefinSans;
TextLabel10.TextSize = 17;
TextLabel10.TextWrapped = true;
TextLabel10.TextColor3 = Color3.fromRGB(255, 240, 205);
TextLabel10.TextStrokeColor3 = Color3.fromRGB(20, 14, 8);
TextLabel10.TextStrokeTransparency = 0.35;
TextLabel10.Text = "";
TextLabel10.Visible = false;
TextLabel10.Parent = ScreenGui;
local u12 = 0;

local function showNotice(p13) -- Line: 405
    -- upvalues: u12 (ref), TextLabel10 (copy), TweenService (copy)
    u12 = u12 + 1;
    local u14 = u12;
    TextLabel10.Text = tostring(p13 or "");
    TextLabel10.Visible = true;
    TweenService:Create(TextLabel10, TweenInfo.new(0.18), {
        TextTransparency = 0
    }):Play();
    task.delay(3.5, function() -- Line: 411
        -- upvalues: u14 (copy), u12 (ref), TweenService (ref), TextLabel10 (ref)
        if u14 ~= u12 then
            return;
        end;

        local v15 = TweenService:Create(TextLabel10, TweenInfo.new(0.22), {
            TextTransparency = 1
        });
        v15:Play();
        v15.Completed:Once(function() -- Line: 415
            -- upvalues: u14 (ref), u12 (ref), TextLabel10 (ref)
            if u14 == u12 then
                TextLabel10.Visible = false;
            end;
        end);
    end);
end;

local function updateFlowerTarget() -- Line: 421
    -- upvalues: LocalPlayer (copy), u3 (ref), markTarget (copy)
    if LocalPlayer:GetAttribute("HumanSideQuestKind") ~= "WhiteFlowers" or LocalPlayer:GetAttribute("HumanSideQuestStage") ~= "Cutting" then
        return;
    end;

    local HumanSideQuestFlowers = workspace:FindFirstChild("HumanSideQuestFlowers");
    local v16 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart");
    local v17 = nil;
    local v18 = nil;

    if HumanSideQuestFlowers and v16 then
        for _, child in ipairs(HumanSideQuestFlowers:GetChildren()) do
            if child:IsA("Model") and child:FindFirstChild("CutFlowerPrompt", true) then
                local Magnitude = (child:GetPivot().Position - v16.Position).Magnitude;

                if not v18 or Magnitude < v18 then
                    v17 = child;
                    v18 = Magnitude;
                end;
            end;
        end;
    end;

    if u3 and (u3.Parent and u3.Adornee == v17) then
        return;
    end;

    markTarget(v17, "WHITE FLOWER");
end;

task.spawn(function() -- Line: 441
    -- upvalues: ScreenGui (copy), updateFlowerTarget (copy)
    while ScreenGui.Parent do
        task.wait(1.25);
        updateFlowerTarget();
    end;
end);

local function setTracker(p19) -- Line: 448
    -- upvalues: Frame (copy), TextLabel2 (copy), TextLabel3 (copy), TextLabel4 (copy), TextLabel5 (copy), TextLabel6 (copy)
    Frame.Visible = true;
    TextLabel2.Text = string.upper((tostring(p19.title or "MISSION")));
    TextLabel3.Text = tostring(p19.objective or "");
    TextLabel4.Text = tostring(p19.progressText or "0 / 1");

    if p19.money then
        TextLabel5.Text = string.format("$%d", tonumber(p19.money) or 0);
    else
        TextLabel5.Text = "$500 - $1000";
    end;

    local v20 = tostring(p19.targetText or "");
    TextLabel6.Visible = v20 ~= "";
    TextLabel6.Text = v20;
end;

HumanSideQuestRemote.OnClientEvent:Connect(function(p21, p22) -- Line: 463
    -- upvalues: openOffer (copy), setTracker (copy), updateFlowerTarget (copy), markTarget (copy), LocalPlayer (copy), u3 (ref), TextLabel6 (copy), openCompletion (copy), showNotice (copy)
    local v23 = typeof(p22) == "table" and p22 and p22 or {};

    if p21 == "Offer" then
        openOffer(v23);

        return;
    end;

    if p21 == "Started" then
        if v23.kind == "WhiteFlowers" then
            v23.progressText = string.format("%d / %d", v23.progress or 0, v23.goal or 5);
            v23.targetText = "TARGET: WHITE FLOWER";
            setTracker(v23);
            task.defer(updateFlowerTarget);

            return;
        end;

        v23.progressText = "0 / 1";
        v23.targetText = "TARGET: LOST CRATE";
        setTracker(v23);
        markTarget(v23.box, "LOST CRATE");

        if not (v23.box and v23.box.Parent) then
            task.spawn(function() -- Line: 479
                -- upvalues: LocalPlayer (ref), markTarget (ref)
                local HumanSideQuestBoxes = workspace:WaitForChild("HumanSideQuestBoxes", 5);

                if HumanSideQuestBoxes then
                    HumanSideQuestBoxes = HumanSideQuestBoxes:WaitForChild("LostCrate_" .. LocalPlayer.UserId, 5);
                end;

                if HumanSideQuestBoxes and LocalPlayer:GetAttribute("HumanSideQuestStage") == "Finding" then
                    markTarget(HumanSideQuestBoxes, "LOST CRATE");
                end;
            end);
        end;
    else
        if p21 == "FlowerProgress" then
            v23.progressText = string.format("%d / %d", v23.progress or 0, v23.goal or 5);
            v23.targetText = "TARGET: WHITE FLOWER";
            setTracker(v23);
            task.defer(updateFlowerTarget);

            return;
        end;

        if p21 == "FlowersReady" then
            v23.progressText = string.format("%d / %d", v23.progress or 5, v23.goal or 5);
            v23.targetText = "TARGET: VILLAGER";
            setTracker(v23);
            markTarget(v23.giver, "VILLAGER");

            return;
        end;

        if p21 == "Carrying" then
            v23.progressText = "1 / 1";
            v23.targetText = "TARGET: VILLAGER";
            setTracker(v23);
            markTarget(v23.giver, "VILLAGER");

            return;
        end;

        if p21 == "GiverLost" then
            if v23.kind == "WhiteFlowers" then
                setTracker({
                    title = "White Flowers",
                    objective = "Return to any quest villager.",
                    progressText = "5 / 5",
                    targetText = "TARGET: VILLAGER"
                });
            else
                setTracker({
                    title = "Lost Cargo",
                    objective = "Bring the crate to any quest villager.",
                    progressText = "1 / 1",
                    targetText = "TARGET: VILLAGER"
                });
            end;

            if u3 then
                u3:Destroy();
                u3 = nil;
            end;

            TextLabel6.Text = "TARGET: VILLAGER";
            TextLabel6.Visible = true;

            return;
        end;

        if p21 == "Completed" then
            if u3 then
                u3:Destroy();
                u3 = nil;
            end;

            v23.progressText = string.format("%d / %d", v23.progress or 1, v23.goal or 1);
            v23.targetText = "";
            setTracker(v23);
            openCompletion(v23);

            return;
        end;

        if p21 == "Message" then
            showNotice(v23.text);
        end;
    end;
end);
LocalPlayer:GetAttributeChangedSignal("HumanSideQuestActive"):Connect(function() -- Line: 521
    -- upvalues: LocalPlayer (copy), u7 (ref), Frame (copy), u3 (ref)
    if LocalPlayer:GetAttribute("HumanSideQuestActive") ~= true then
        task.delay(0.1, function() -- Line: 523
            -- upvalues: LocalPlayer (ref), u7 (ref), Frame (ref), u3 (ref)
            if LocalPlayer:GetAttribute("HumanSideQuestActive") ~= true and u7 ~= "Completed" then
                Frame.Visible = false;

                if u3 then
                    u3:Destroy();
                    u3 = nil;
                end;
            end;
        end);
    end;
end);
local Humans = workspace:WaitForChild("Humans");

local function useVampireTalkKey() -- Line: 534
    -- upvalues: LocalPlayer (copy)
    local v24 = LocalPlayer.Team and LocalPlayer.Team.Name;
    local Character = LocalPlayer.Character;

    if v24 == "Vampires" or v24 == "Cannibal Raised" then
        Character = true;
    elseif Character then
        Character = Character:GetAttribute("VampireInfected") == true;
    end;

    return Character;
end;

local function updateVillagerTalkKeys() -- Line: 541
    -- upvalues: LocalPlayer (copy), Humans (copy)
    local v25 = LocalPlayer.Team and LocalPlayer.Team.Name;
    local Character = LocalPlayer.Character;

    if v25 == "Vampires" or v25 == "Cannibal Raised" then
        Character = true;
    elseif Character then
        Character = Character:GetAttribute("VampireInfected") == true;
    end;

    local v26 = Character and Enum.KeyCode.G or Enum.KeyCode.E;

    for _, descendant in ipairs(Humans:GetDescendants()) do
        if descendant:IsA("ProximityPrompt") and descendant.Name == "HumanSideQuestPrompt" then
            descendant.KeyboardKeyCode = v26;
        end;
    end;
end;

Humans.DescendantAdded:Connect(function(p27) -- Line: 550
    -- upvalues: LocalPlayer (copy)
    if p27:IsA("ProximityPrompt") and p27.Name == "HumanSideQuestPrompt" then
        local v28 = LocalPlayer.Team and LocalPlayer.Team.Name;
        local Character = LocalPlayer.Character;

        if v28 == "Vampires" or v28 == "Cannibal Raised" then
            Character = true;
        elseif Character then
            Character = Character:GetAttribute("VampireInfected") == true;
        end;

        p27.KeyboardKeyCode = Character and Enum.KeyCode.G or Enum.KeyCode.E;
    end;
end);
LocalPlayer:GetPropertyChangedSignal("Team"):Connect(updateVillagerTalkKeys);
LocalPlayer.CharacterAdded:Connect(function(p29) -- Line: 556, Name: watchCharacter
    -- upvalues: updateVillagerTalkKeys (copy)
    p29:GetAttributeChangedSignal("VampireInfected"):Connect(updateVillagerTalkKeys);
    updateVillagerTalkKeys();
end);

if LocalPlayer.Character then
    LocalPlayer.Character:GetAttributeChangedSignal("VampireInfected"):Connect(updateVillagerTalkKeys);
    updateVillagerTalkKeys();
end;

updateVillagerTalkKeys();
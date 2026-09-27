-- Decompiled with Potassium's decompiler.

local TeamGuiLayout = require(game:GetService("ReplicatedStorage"):WaitForChild("TeamGuiLayout"));
local Players = game:GetService("Players");
local Workspace = game:GetService("Workspace");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local LocalPlayer = Players.LocalPlayer;
local u1 = TeamGuiLayout.GetMode() == "MOBILE";
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local script_Parent = script.Parent;
local StatsPanel = script_Parent:FindFirstChild("StatsPanel");

if StatsPanel then
    StatsPanel:Destroy();
end;

local Frame = Instance.new("Frame");
Frame.Name = "StatsPanel";
Frame.AnchorPoint = Vector2.new(1, 1);

if u1 then
    Frame.AnchorPoint = Vector2.new(1, 0);
    Frame.Position = UDim2.new(1, -12, 0, 60);
else
    Frame.Position = UDim2.new(1, -18, 1, -18);
end;

Frame.Size = UDim2.fromOffset(205, 64);
Frame.BackgroundColor3 = Color3.fromRGB(12, 12, 16);
Frame.BackgroundTransparency = 1;
Frame.BorderSizePixel = 0;
Frame.Active = u1;
Frame.Parent = script_Parent;
local UICorner = Instance.new("UICorner");
UICorner.CornerRadius = UDim.new(0, 8);
UICorner.Parent = Frame;
local UIStroke = Instance.new("UIStroke");
UIStroke.Color = Color3.fromRGB(255, 255, 255);
UIStroke.Transparency = 1;
UIStroke.Thickness = 1;
UIStroke.Parent = Frame;
local UIPadding = Instance.new("UIPadding");
UIPadding.PaddingLeft = UDim.new(0, 12);
UIPadding.PaddingRight = UDim.new(0, 12);
UIPadding.PaddingTop = UDim.new(0, 7);
UIPadding.PaddingBottom = UDim.new(0, 7);
UIPadding.Parent = Frame;
local UIListLayout = Instance.new("UIListLayout");
UIListLayout.FillDirection = Enum.FillDirection.Vertical;
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right;
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
UIListLayout.Padding = UDim.new(0, 2);
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
UIListLayout.Parent = Frame;
local UIScale = Instance.new("UIScale");
UIScale.Name = "ResponsiveScale";
UIScale.Parent = Frame;

local function createLabel(p2, p3, p4) -- Line: 64
    -- upvalues: Frame (ref)
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = p2;
    TextLabel.LayoutOrder = p3;
    TextLabel.Size = UDim2.new(1, 0, 0, 23);
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Font = Enum.Font.JosefinSans;
    TextLabel.TextColor3 = p4;
    TextLabel.TextSize = 19;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel.TextYAlignment = Enum.TextYAlignment.Center;
    TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0);
    TextLabel.TextStrokeTransparency = 0.55;
    TextLabel.Parent = Frame;

    return TextLabel;
end;

local u5 = createLabel("Money", 1, Color3.fromRGB(255, 226, 145));
local u6 = createLabel("Kills", 2, Color3.fromRGB(255, 255, 255));
local u7 = false;
local u8 = false;
local Position = Frame.Position;
local u9 = nil;
local Vector2_zero = Vector2.zero;
local Position2 = Frame.Position;
local Vector2_zero2 = Vector2.zero;

local function beginMobileDrag(u10) -- Line: 93
    -- upvalues: u1 (ref), u7 (ref), u9 (ref), Vector2_zero (ref), Position2 (ref), Frame (ref), Vector2_zero2 (ref)
    if not (u1 and (not u7 and u10.UserInputType == Enum.UserInputType.Touch)) then
        return;
    end;

    u7 = true;
    u9 = u10;
    Vector2_zero = Vector2.new(u10.Position.X, u10.Position.Y);
    Position2 = Frame.Position;
    Vector2_zero2 = Frame.AbsolutePosition;
    u10.Changed:Connect(function() -- Line: 107
        -- upvalues: u10 (copy), u7 (ref), u9 (ref)
        if u10.UserInputState == Enum.UserInputState.End then
            u7 = false;
            u9 = nil;
        end;
    end);
end;

local function updateMobileDrag(p11) -- Line: 115
    -- upvalues: u7 (ref), u9 (ref), Vector2_zero (ref), Workspace (copy), Frame (ref), Vector2_zero2 (ref), u8 (ref), Position2 (ref), Position (ref)
    if not u7 or p11 ~= u9 then
        return;
    end;

    local v12 = Vector2.new(p11.Position.X, p11.Position.Y) - Vector2_zero;

    if v12.Magnitude < 10 then
        return;
    end;

    local CurrentCamera = Workspace.CurrentCamera;

    if not CurrentCamera then
        return;
    end;

    local ViewportSize = CurrentCamera.ViewportSize;
    local AbsoluteSize = Frame.AbsoluteSize;
    local Vector2_new_ret = Vector2.new(math.clamp(v12.X, -Vector2_zero2.X, ViewportSize.X - AbsoluteSize.X - Vector2_zero2.X), (math.clamp(v12.Y, -Vector2_zero2.Y, ViewportSize.Y - AbsoluteSize.Y - Vector2_zero2.Y)));
    u8 = true;
    Frame.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + Vector2_new_ret.X, Position2.Y.Scale, Position2.Y.Offset + Vector2_new_ret.Y);
    Position = Frame.Position;
end;

Frame.InputBegan:Connect(beginMobileDrag);
u5.InputBegan:Connect(beginMobileDrag);
u6.InputBegan:Connect(beginMobileDrag);
UserInputService.InputChanged:Connect(updateMobileDrag);
local MONEYDROP = script_Parent:WaitForChild("MONEYDROP");
local Quantidade = MONEYDROP:WaitForChild("Quantidade");
local DROP = MONEYDROP:WaitForChild("DROP");
local CANCEL = MONEYDROP:WaitForChild("CANCEL");
local MoneyDropRemote = ReplicatedStorage:WaitForChild("Funções"):WaitForChild("Eventos"):WaitForChild("MoneyDropRemote");
u5.Active = true;

local function openMoneyDrop() -- Line: 166
    -- upvalues: MONEYDROP (copy), Quantidade (copy)
    MONEYDROP.Visible = true;
    Quantidade.Text = "";
    task.defer(function() -- Line: 169
        -- upvalues: MONEYDROP (ref), Quantidade (ref)
        if MONEYDROP.Visible then
            Quantidade:CaptureFocus();
        end;
    end);
end;

local function submitMoneyDrop() -- Line: 176
    -- upvalues: Quantidade (copy), LocalPlayer (copy), MoneyDropRemote (copy), MONEYDROP (copy)
    local v13 = tonumber(Quantidade.Text);

    if not (v13 and (v13 == v13 and (v13 ~= (1 / 0) and v13 ~= (-1 / 0)))) then
        return;
    end;

    local math_floor_ret = math.floor(v13);

    if math_floor_ret <= 0 then
        return;
    end;

    local v14 = tonumber(LocalPlayer:GetAttribute("Money")) or 0;
    local math_floor_ret2 = math.floor(v14);

    if math.max(0, math_floor_ret2) < math_floor_ret then
        return;
    end;

    MoneyDropRemote:FireServer(math_floor_ret);
    MONEYDROP.Visible = false;
    Quantidade.Text = "";
end;

u5.InputBegan:Connect(function(u15) -- Line: 195
    -- upvalues: MONEYDROP (copy), Quantidade (copy)
    if u15.UserInputType == Enum.UserInputType.MouseButton1 then
        MONEYDROP.Visible = true;
        Quantidade.Text = "";
        task.defer(function() -- Line: 169
            -- upvalues: MONEYDROP (ref), Quantidade (ref)
            if MONEYDROP.Visible then
                Quantidade:CaptureFocus();
            end;
        end);

        return;
    end;

    if u15.UserInputType ~= Enum.UserInputType.Touch then
        return;
    end;

    local Vector2_new_ret = Vector2.new(u15.Position.X, u15.Position.Y);
    u15.Changed:Connect(function() -- Line: 205
        -- upvalues: u15 (copy), Vector2_new_ret (copy), MONEYDROP (ref), Quantidade (ref)
        if u15.UserInputState ~= Enum.UserInputState.End then
            return;
        end;

        if (Vector2.new(u15.Position.X, u15.Position.Y) - Vector2_new_ret).Magnitude < 10 then
            MONEYDROP.Visible = true;
            Quantidade.Text = "";
            task.defer(function() -- Line: 169
                -- upvalues: MONEYDROP (ref), Quantidade (ref)
                if MONEYDROP.Visible then
                    Quantidade:CaptureFocus();
                end;
            end);
        end;
    end);
end);
CANCEL.Activated:Connect(function() -- Line: 161, Name: closeMoneyDrop
    -- upvalues: MONEYDROP (copy), Quantidade (copy)
    MONEYDROP.Visible = false;
    Quantidade.Text = "";
end);
DROP.Activated:Connect(submitMoneyDrop);
Quantidade.FocusLost:Connect(function(p16) -- Line: 218
    -- upvalues: submitMoneyDrop (copy)
    if p16 then
        submitMoneyDrop();
    end;
end);

local function formatInteger(p17) -- Line: 224
    local v18 = tonumber(p17) or 0;
    local math_floor_ret = math.floor(v18);
    local math_max_ret = math.max(0, math_floor_ret);
    local v19 = tostring(math_max_ret);
    local v20;

    repeat
        v19, v20 = v19:gsub("^(-?%d+)(%d%d%d)", "%1,%2");
    until v20 == 0;

    return v19;
end;

local function getHeartPowerLabel() -- Line: 236
    -- upvalues: TeamGuiLayout (copy), PlayerGui (copy)
    local v21 = TeamGuiLayout.FindPanel(PlayerGui, "Vampire" .. (TeamGuiLayout.GetMode() == "CONSOLE" and "CONSOLE" or "PC"));

    if v21 then
        v21 = TeamGuiLayout.GetMenu(v21);
    end;

    if v21 then
        v21 = v21:FindFirstChild("passivas");
    end;

    if v21 then
        v21 = v21:FindFirstChild("Corações");
    end;

    if v21 then
        v21 = v21:FindFirstChild("Quantidade");
    end;

    if v21 and v21:IsA("TextLabel") then
        return v21;
    end;

    return nil;
end;

local function getMobileHeartPowerLabel() -- Line: 248
    -- upvalues: TeamGuiLayout (copy), PlayerGui (copy)
    local v22 = TeamGuiLayout.FindPanel(PlayerGui, "VampiresMOBILE");

    if v22 then
        v22 = TeamGuiLayout.GetMenu(v22);
    end;

    if v22 then
        v22 = v22:FindFirstChild("CORACAOQUNTIDADE");
    end;

    if v22 and v22:IsA("TextLabel") then
        return v22;
    end;

    return nil;
end;

local function updateStats() -- Line: 258
    -- upvalues: LocalPlayer (copy), u5 (copy), formatInteger (copy), u6 (copy), getHeartPowerLabel (copy), TeamGuiLayout (copy), PlayerGui (copy), Frame (ref)
    local v23 = LocalPlayer.Team and LocalPlayer.Team.Name;
    local v24 = v23 == "Vampires" and true or v23 == "Cannibal Raised";
    u5.Text = "Money " .. formatInteger(LocalPlayer:GetAttribute("Money"));
    u6.Text = "Kills " .. formatInteger(LocalPlayer:GetAttribute("Kills"));
    local v25 = tonumber(LocalPlayer:GetAttribute("ExtraHearts")) or 0;
    local math_floor_ret = math.floor(v25);
    local math_clamp_ret = math.clamp(math_floor_ret, 0, 3);
    local v26 = getHeartPowerLabel();

    if v26 then
        v26.Text = "x" .. tostring(math_clamp_ret);

        if v24 then
            v24 = TeamGuiLayout.GetMode() ~= "PC";
        end;

        v26.Visible = v24;
    end;

    local v27 = TeamGuiLayout.FindPanel(PlayerGui, "VampiresMOBILE");

    if v27 then
        v27 = TeamGuiLayout.GetMenu(v27);
    end;

    if v27 then
        v27 = v27:FindFirstChild("CORACAOQUNTIDADE");
    end;

    if not (v27 and v27:IsA("TextLabel")) then
        v27 = nil;
    end;

    if v27 then
        v27.Text = "";
        v27.Visible = false;
    end;

    Frame.Size = UDim2.fromOffset(205, 64 + (showsLevel and 25 or 0));
end;

local function updateScale() -- Line: 288
    -- upvalues: Workspace (copy), UIScale (copy)
    local CurrentCamera = Workspace.CurrentCamera;

    if not CurrentCamera then
        return;
    end;

    local ViewportSize = CurrentCamera.ViewportSize;
    local math_min_ret = math.min(ViewportSize.X / 1280, ViewportSize.Y / 720);
    UIScale.Scale = math.clamp(math_min_ret, 0.72, 1.05);
end;

local function updateDeviceLayout() -- Line: 296
    -- upvalues: TeamGuiLayout (copy), u1 (ref), Frame (ref), u8 (ref), Position (ref)
    local v28 = TeamGuiLayout.GetMode() == "MOBILE";

    if v28 == u1 then
        if v28 and not u8 then
            Frame.AnchorPoint = Vector2.new(1, 0);
            Frame.Position = UDim2.new(1, -12, 0, 60);
        end;

        return;
    end;

    u1 = v28;
    Frame.Active = v28;

    if v28 then
        Frame.AnchorPoint = Vector2.new(1, 0);
        Frame.Position = u8 and Position or UDim2.new(1, -12, 0, 60);

        return;
    end;

    Frame.AnchorPoint = Vector2.new(1, 1);
    Frame.Position = UDim2.new(1, -18, 1, -18);
end;

LocalPlayer:GetAttributeChangedSignal("MobileHudResetRevision"):Connect(function() -- Line: 314
    -- upvalues: u8 (ref), Position (ref), updateDeviceLayout (copy)
    u8 = false;
    Position = UDim2.new(1, -12, 0, 60);
    updateDeviceLayout();
end);
LocalPlayer:GetAttributeChangedSignal("Years"):Connect(updateStats);
LocalPlayer:GetAttributeChangedSignal("Money"):Connect(updateStats);
LocalPlayer:GetAttributeChangedSignal("Kills"):Connect(updateStats);
LocalPlayer:GetAttributeChangedSignal("ExtraHearts"):Connect(updateStats);
LocalPlayer:GetAttributeChangedSignal("Strength"):Connect(updateStats);
LocalPlayer:GetAttributeChangedSignal("Agility"):Connect(updateStats);
LocalPlayer:GetAttributeChangedSignal("Endurance"):Connect(updateStats);
LocalPlayer:GetAttributeChangedSignal("Reflexes"):Connect(updateStats);
LocalPlayer:GetPropertyChangedSignal("Team"):Connect(updateStats);
local v29 = TeamGuiLayout.FindPanel(PlayerGui, "Human");
local Menu = TeamGuiLayout.GetMenu(v29);

if Menu then
    Menu = Menu:FindFirstChild("StatusBar");
end;

if Menu then
    Menu = Menu:FindFirstChild("Habilidades");
end;

local u30 = Menu and Menu:FindFirstChild("Strength") and Menu.Strength:FindFirstChild("Pontos");
local u31 = Menu and Menu:FindFirstChild("Agility") and Menu.Agility:FindFirstChild("Pontos");
local u32 = Menu and Menu:FindFirstChild("Endurance") and Menu.Endurance:FindFirstChild("Pontos");
local u33 = Menu and Menu:FindFirstChild("Reflexes") and Menu.Reflexes:FindFirstChild("Pontos");
local u34 = Menu and Menu:FindFirstChild("Total") and Menu.Total:FindFirstChild("Pontos");

local function updateHumanAttributes() -- Line: 340
    -- upvalues: LocalPlayer (copy), Menu (copy), u30 (copy), u31 (copy), u32 (copy), u33 (copy), u34 (copy)
    local v35 = LocalPlayer.Team and LocalPlayer.Team.Name == "Humans";

    if not Menu then
        return;
    end;

    Menu.Visible = v35;

    if not v35 then
        return;
    end;

    local v36 = tonumber(LocalPlayer:GetAttribute("Strength")) or 0;
    local math_floor_ret = math.floor(v36);
    local math_clamp_ret = math.clamp(math_floor_ret, 0, 100);
    local v37 = tonumber(LocalPlayer:GetAttribute("Agility")) or 0;
    local math_floor_ret2 = math.floor(v37);
    local math_clamp_ret2 = math.clamp(math_floor_ret2, 0, 100);
    local v38 = tonumber(LocalPlayer:GetAttribute("Endurance")) or (tonumber(LocalPlayer:GetAttribute("Durability")) or 0);
    local math_floor_ret3 = math.floor(v38);
    local math_clamp_ret3 = math.clamp(math_floor_ret3, 0, 100);
    local v39 = tonumber(LocalPlayer:GetAttribute("Reflexes")) or 0;
    local math_floor_ret4 = math.floor(v39);
    local math_clamp_ret4 = math.clamp(math_floor_ret4, 0, 100);

    if u30 then
        u30.Text = tostring(math_clamp_ret);
    end;

    if u31 then
        u31.Text = tostring(math_clamp_ret2);
    end;

    if u32 then
        u32.Text = tostring(math_clamp_ret3);
    end;

    if u33 then
        u33.Text = tostring(math_clamp_ret4);
    end;

    if u34 then
        u34.Text = tostring(math_clamp_ret + math_clamp_ret2 + math_clamp_ret3 + math_clamp_ret4);
    end;
end;

LocalPlayer:GetAttributeChangedSignal("Strength"):Connect(updateHumanAttributes);
LocalPlayer:GetAttributeChangedSignal("Agility"):Connect(updateHumanAttributes);
LocalPlayer:GetAttributeChangedSignal("Endurance"):Connect(updateHumanAttributes);
LocalPlayer:GetAttributeChangedSignal("Reflexes"):Connect(updateHumanAttributes);
PlayerGui.ChildAdded:Connect(function(p40) -- Line: 360
    -- upvalues: updateStats (copy)
    if p40.Name == "Vampires" or p40.Name == "VampiresMOBILE" then
        task.defer(updateStats);
    end;
end);
local u41 = nil;

local function connectCamera() -- Line: 367
    -- upvalues: u41 (ref), Workspace (copy), UIScale (copy), updateDeviceLayout (copy)
    if u41 then
        u41:Disconnect();
    end;

    local CurrentCamera = Workspace.CurrentCamera;

    if CurrentCamera then
        u41 = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- Line: 373
            -- upvalues: Workspace (ref), UIScale (ref), updateDeviceLayout (ref)
            local CurrentCamera2 = Workspace.CurrentCamera;

            if CurrentCamera2 then
                local ViewportSize = CurrentCamera2.ViewportSize;
                local math_min_ret = math.min(ViewportSize.X / 1280, ViewportSize.Y / 720);
                UIScale.Scale = math.clamp(math_min_ret, 0.72, 1.05);
            end;

            updateDeviceLayout();
        end);
    end;

    local CurrentCamera2 = Workspace.CurrentCamera;

    if CurrentCamera2 then
        local ViewportSize = CurrentCamera2.ViewportSize;
        local math_min_ret = math.min(ViewportSize.X / 1280, ViewportSize.Y / 720);
        UIScale.Scale = math.clamp(math_min_ret, 0.72, 1.05);
    end;

    updateDeviceLayout();
end;

UserInputService.LastInputTypeChanged:Connect(updateDeviceLayout);
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(connectCamera);
connectCamera();
updateStats();
updateHumanAttributes();
-- Decompiled with Potassium's decompiler.

local ContextActionService = game:GetService("ContextActionService");
local Players = game:GetService("Players");
local StarterGui = game:GetService("StarterGui");
local UserInputService = game:GetService("UserInputService");
local Workspace = game:GetService("Workspace");
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
local Font_new_ret = Font.new("rbxasset://fonts/families/JosefinSans.json");

local function disableDefaultList() -- Line: 13
    -- upvalues: StarterGui (copy)
    pcall(function() -- Line: 14
        -- upvalues: StarterGui (ref)
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false);
    end);
end;

pcall(function() -- Line: 14
    -- upvalues: StarterGui (copy)
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false);
end);
task.spawn(function() -- Line: 20
    -- upvalues: StarterGui (copy)
    for i = 1, 10 do
        task.wait(0.5);
        pcall(function() -- Line: 14
            -- upvalues: StarterGui (ref)
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false);
        end);
        local _ = i;
    end;
end);
local PlayersWithoutTeams = PlayerGui:FindFirstChild("PlayersWithoutTeams");

if PlayersWithoutTeams then
    PlayersWithoutTeams:Destroy();
end;

local ScreenGui = Instance.new("ScreenGui");
ScreenGui.Name = "PlayersWithoutTeams";
ScreenGui.ResetOnSpawn = false;
ScreenGui.IgnoreGuiInset = false;
ScreenGui.DisplayOrder = 90;
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
ScreenGui.Parent = PlayerGui;
local TextButton = Instance.new("TextButton");
TextButton.Name = "OpenPlayerList";
TextButton.AnchorPoint = Vector2.new(1, 0);
TextButton.Position = UDim2.new(1, -12, 0, 52);
TextButton.Size = UDim2.fromOffset(42, 42);
TextButton.BackgroundColor3 = Color3.fromRGB(17, 18, 25);
TextButton.BackgroundTransparency = 0.12;
TextButton.Text = "☰";
TextButton.TextColor3 = Color3.new(1, 1, 1);
TextButton.TextSize = 24;
TextButton.FontFace = Font_new_ret;
TextButton.Visible = true;
TextButton.Parent = ScreenGui;
local UICorner = Instance.new("UICorner");
UICorner.CornerRadius = UDim.new(0, 8);
UICorner.Parent = TextButton;
local Frame = Instance.new("Frame");
Frame.Name = "PlayerList";
Frame.AnchorPoint = Vector2.new(1, 0);
Frame.Position = UDim2.new(1, -10, 0, 52);
Frame.BackgroundColor3 = Color3.fromRGB(12, 13, 20);
Frame.BackgroundTransparency = 0.08;
Frame.BorderSizePixel = 0;
Frame.Visible = false;
Frame.Parent = ScreenGui;
local UICorner2 = Instance.new("UICorner");
UICorner2.CornerRadius = UDim.new(0, 8);
UICorner2.Parent = Frame;
local TextLabel = Instance.new("TextLabel");
TextLabel.Name = "Title";
TextLabel.Position = UDim2.fromOffset(14, 0);
TextLabel.Size = UDim2.new(1, -54, 0, 42);
TextLabel.BackgroundTransparency = 1;
TextLabel.Text = "PLAYERS";
TextLabel.TextColor3 = Color3.new(1, 1, 1);
TextLabel.TextSize = 17;
TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
TextLabel.FontFace = Font_new_ret;
TextLabel.Parent = Frame;
local TextButton2 = Instance.new("TextButton");
TextButton2.Name = "Close";
TextButton2.AnchorPoint = Vector2.new(1, 0);
TextButton2.Position = UDim2.new(1, -6, 0, 5);
TextButton2.Size = UDim2.fromOffset(32, 32);
TextButton2.BackgroundTransparency = 1;
TextButton2.Text = "×";
TextButton2.TextColor3 = Color3.fromRGB(230, 230, 235);
TextButton2.TextSize = 25;
TextButton2.FontFace = Font_new_ret;
TextButton2.Parent = Frame;
local Frame2 = Instance.new("Frame");
Frame2.Position = UDim2.fromOffset(10, 41);
Frame2.Size = UDim2.new(1, -20, 0, 1);
Frame2.BorderSizePixel = 0;
Frame2.BackgroundColor3 = Color3.fromRGB(78, 79, 90);
Frame2.BackgroundTransparency = 0.45;
Frame2.Parent = Frame;
local ScrollingFrame = Instance.new("ScrollingFrame");
ScrollingFrame.Name = "Names";
ScrollingFrame.Position = UDim2.fromOffset(8, 48);
ScrollingFrame.Size = UDim2.new(1, -16, 1, -56);
ScrollingFrame.BackgroundTransparency = 1;
ScrollingFrame.BorderSizePixel = 0;
ScrollingFrame.ScrollBarThickness = 3;
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(175, 175, 185);
ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;
ScrollingFrame.CanvasSize = UDim2.new();
ScrollingFrame.Parent = Frame;
local UIListLayout = Instance.new("UIListLayout");
UIListLayout.Padding = UDim.new(0, 4);
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
UIListLayout.Parent = ScrollingFrame;

local function updateSize() -- Line: 119
    -- upvalues: Workspace (copy), Players (copy), Frame (copy)
    local CurrentCamera = Workspace.CurrentCamera;
    local v1 = CurrentCamera and CurrentCamera.ViewportSize or Vector2.new(1280, 720);
    local math_floor_ret = math.floor(v1.X * 0.22);
    local math_clamp_ret = math.clamp(math_floor_ret, 220, 300);
    local v2 = #Players:GetPlayers();
    local math_min_ret = math.min(v2, 10);
    local math_floor_ret2 = math.floor(v1.Y * 0.72);
    local math_max_ret = math.max(100, math_floor_ret2);
    local math_clamp_ret2 = math.clamp(math_min_ret * 42 + 56, 100, math_max_ret);
    Frame.Size = UDim2.fromOffset(math_clamp_ret, math_clamp_ret2);
end;

local function addPlayer(u3) -- Line: 129
    -- upvalues: ScrollingFrame (copy), Font_new_ret (copy), Players (copy)
    local Frame3 = Instance.new("Frame");
    Frame3.Name = tostring(u3.UserId);
    Frame3.Size = UDim2.new(1, -4, 0, 38);
    Frame3.BackgroundColor3 = Color3.fromRGB(31, 32, 42);
    Frame3.BackgroundTransparency = 0.3;
    Frame3.BorderSizePixel = 0;
    Frame3.LayoutOrder = u3.UserId;
    Frame3.Parent = ScrollingFrame;
    local UICorner3 = Instance.new("UICorner");
    UICorner3.CornerRadius = UDim.new(0, 5);
    UICorner3.Parent = Frame3;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Avatar";
    ImageLabel.Position = UDim2.fromOffset(4, 3);
    ImageLabel.Size = UDim2.fromOffset(32, 32);
    ImageLabel.BackgroundColor3 = Color3.fromRGB(50, 51, 62);
    ImageLabel.BorderSizePixel = 0;
    ImageLabel.Parent = Frame3;
    local UICorner4 = Instance.new("UICorner");
    UICorner4.CornerRadius = UDim.new(1, 0);
    UICorner4.Parent = ImageLabel;
    local TextLabel2 = Instance.new("TextLabel");
    TextLabel2.Name = "PlayerName";
    TextLabel2.Position = UDim2.fromOffset(44, 0);
    TextLabel2.Size = UDim2.new(1, -50, 1, 0);
    TextLabel2.BackgroundTransparency = 1;
    TextLabel2.Text = u3.DisplayName;
    TextLabel2.TextColor3 = Color3.new(1, 1, 1);
    TextLabel2.TextSize = 16;
    TextLabel2.TextTruncate = Enum.TextTruncate.AtEnd;
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel2.FontFace = Font_new_ret;
    TextLabel2.Parent = Frame3;
    task.spawn(function() -- Line: 166
        -- upvalues: Players (ref), u3 (copy), Frame3 (copy), ImageLabel (copy)
        local success, result = pcall(Players.GetUserThumbnailAsync, Players, u3.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100);

        if success and Frame3.Parent then
            ImageLabel.Image = result;
        end;
    end);
end;

local function refresh() -- Line: 180
    -- upvalues: ScrollingFrame (copy), Players (copy), addPlayer (copy), updateSize (copy)
    for _, child in ipairs(ScrollingFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy();
        end;
    end;

    local Players2 = Players:GetPlayers();
    table.sort(Players2, function(p4, p5) -- Line: 187
        return string.lower(p4.DisplayName) < string.lower(p5.DisplayName);
    end);

    for i, v in ipairs(Players2) do
        addPlayer(v);
        local v6 = ScrollingFrame:FindFirstChild((tostring(v.UserId)));

        if v6 then
            v6.LayoutOrder = i;
        end;
    end;

    updateSize();
end;

local function setOpen(p7) -- Line: 200
    -- upvalues: Frame (copy), TextButton (copy), StarterGui (copy), refresh (copy)
    Frame.Visible = p7;
    TextButton.Visible = not p7;
    pcall(function() -- Line: 14
        -- upvalues: StarterGui (ref)
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false);
    end);

    if p7 then
        refresh();
    end;
end;

TextButton.Activated:Connect(function() -- Line: 209
    -- upvalues: Frame (copy), TextButton (copy), StarterGui (copy), refresh (copy)
    Frame.Visible = true;
    TextButton.Visible = false;
    pcall(function() -- Line: 14
        -- upvalues: StarterGui (ref)
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false);
    end);
    refresh();
end);
TextButton2.Activated:Connect(function() -- Line: 212
    -- upvalues: Frame (copy), TextButton (copy), StarterGui (copy)
    Frame.Visible = false;
    TextButton.Visible = true;
    pcall(function() -- Line: 14
        -- upvalues: StarterGui (ref)
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false);
    end);
end);
ContextActionService:BindActionAtPriority("TogglePlayersWithoutTeams", function(p8, p9) -- Line: 218
    -- upvalues: UserInputService (copy), Frame (copy), TextButton (copy), StarterGui (copy), refresh (copy)
    if p9 ~= Enum.UserInputState.Begin then
        return Enum.ContextActionResult.Pass;
    end;

    if UserInputService:GetFocusedTextBox() then
        return Enum.ContextActionResult.Pass;
    end;

    local v10 = not Frame.Visible;
    Frame.Visible = v10;
    TextButton.Visible = not v10;
    pcall(function() -- Line: 14
        -- upvalues: StarterGui (ref)
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false);
    end);

    if v10 then
        refresh();
    end;

    return Enum.ContextActionResult.Sink;
end, false, 3500, Enum.KeyCode.Tab);
Players.PlayerAdded:Connect(refresh);
Players.PlayerRemoving:Connect(function() -- Line: 234
    -- upvalues: refresh (copy)
    task.defer(refresh);
end);

if Workspace.CurrentCamera then
    Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateSize);
end;

Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- Line: 241
    -- upvalues: updateSize (copy)
    updateSize();
end);
refresh();
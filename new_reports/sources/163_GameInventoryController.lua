-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local StarterGui = game:GetService("StarterGui");
local UserInputService = game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");
local Workspace = game:GetService("Workspace");
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
LocalPlayer:WaitForChild("Backpack");
local JosefinSans = Enum.Font.JosefinSans;
local u1 = {
    Background = Color3.fromRGB(8, 9, 12),
    Panel = Color3.fromRGB(13, 14, 18),
    Slot = Color3.fromRGB(22, 23, 29),
    SlotHover = Color3.fromRGB(31, 32, 39),
    Text = Color3.fromRGB(242, 242, 242),
    Muted = Color3.fromRGB(164, 164, 172),
    Accent = Color3.fromRGB(160, 28, 34),
    Gold = Color3.fromRGB(195, 157, 79),
    Stroke = Color3.fromRGB(82, 82, 92)
};
local GameInventoryUI = PlayerGui:FindFirstChild("GameInventoryUI");

if GameInventoryUI then
    GameInventoryUI:Destroy();
end;

local ScreenGui = Instance.new("ScreenGui");
ScreenGui.Name = "GameInventoryUI";
ScreenGui.ResetOnSpawn = false;
ScreenGui.IgnoreGuiInset = false;
ScreenGui.DisplayOrder = 45;
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
ScreenGui.Parent = PlayerGui;

local function addCorner(p2, p3) -- Line: 36
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0, p3);
    UICorner.Parent = p2;

    return UICorner;
end;

local function addStroke(p4, p5, p6, p7) -- Line: 43
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Color = p5;
    UIStroke.Thickness = p6;
    UIStroke.Transparency = p7 or 0;
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke.Parent = p4;

    return UIStroke;
end;

local function makeText(p8, p9, p10) -- Line: 53
    -- upvalues: JosefinSans (copy), u1 (copy)
    local Instance_new_ret = Instance.new(p9);
    Instance_new_ret.BackgroundTransparency = 1;
    Instance_new_ret.BorderSizePixel = 0;
    Instance_new_ret.Font = JosefinSans;
    Instance_new_ret.Text = p10;
    Instance_new_ret.TextColor3 = u1.Text;
    Instance_new_ret.TextScaled = true;
    Instance_new_ret.Parent = p8;
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint");
    UITextSizeConstraint.MinTextSize = 9;
    UITextSizeConstraint.MaxTextSize = 22;
    UITextSizeConstraint.Parent = Instance_new_ret;

    return Instance_new_ret;
end;

local TextButton = Instance.new("TextButton");
TextButton.Name = "Backdrop";
TextButton.Text = "";
TextButton.AutoButtonColor = false;
TextButton.BackgroundColor3 = Color3.new(0, 0, 0);
TextButton.BackgroundTransparency = 0.38;
TextButton.BorderSizePixel = 0;
TextButton.Size = UDim2.fromScale(1, 1);
TextButton.Visible = false;
TextButton.ZIndex = 20;
TextButton.Parent = ScreenGui;
local Frame = Instance.new("Frame");
Frame.Name = "InventoryPanel";
Frame.AnchorPoint = Vector2.new(0.5, 0.5);
Frame.Position = UDim2.fromScale(0.5, 0.5);
Frame.Size = UDim2.fromScale(0.56, 0.62);
Frame.BackgroundColor3 = u1.Panel;
Frame.BackgroundTransparency = 0.08;
Frame.BorderSizePixel = 0;
Frame.Visible = false;
Frame.ClipsDescendants = true;
Frame.ZIndex = 21;
Frame.Parent = ScreenGui;
local UICorner = Instance.new("UICorner");
UICorner.CornerRadius = UDim.new(0, 10);
UICorner.Parent = Frame;
local Stroke = u1.Stroke;
local UIStroke = Instance.new("UIStroke");
UIStroke.Color = Stroke;
UIStroke.Thickness = 1.2;
UIStroke.Transparency = 0.2;
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
UIStroke.Parent = Frame;
local UIScale = Instance.new("UIScale");
UIScale.Scale = 1;
UIScale.Parent = Frame;
local UISizeConstraint = Instance.new("UISizeConstraint");
UISizeConstraint.MinSize = Vector2.new(280, 300);
UISizeConstraint.MaxSize = Vector2.new(880, 580);
UISizeConstraint.Parent = Frame;
local Frame2 = Instance.new("Frame");
Frame2.Name = "Accent";
Frame2.BackgroundColor3 = u1.Accent;
Frame2.BorderSizePixel = 0;
Frame2.Size = UDim2.new(1, 0, 0, 3);
Frame2.ZIndex = 22;
Frame2.Parent = Frame;
local TextLabel = Instance.new("TextLabel");
TextLabel.BackgroundTransparency = 1;
TextLabel.BorderSizePixel = 0;
TextLabel.Font = JosefinSans;
TextLabel.Text = "INVENTORY";
TextLabel.TextColor3 = u1.Text;
TextLabel.TextScaled = true;
TextLabel.Parent = Frame;
local UITextSizeConstraint = Instance.new("UITextSizeConstraint");
UITextSizeConstraint.MinTextSize = 9;
UITextSizeConstraint.MaxTextSize = 22;
UITextSizeConstraint.Parent = TextLabel;
TextLabel.Name = "Title";
TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
TextLabel.Position = UDim2.new(0, 18, 0, 12);
TextLabel.Size = UDim2.new(0.55, 0, 0, 34);
TextLabel.ZIndex = 22;
local TextLabel2 = Instance.new("TextLabel");
TextLabel2.BackgroundTransparency = 1;
TextLabel2.BorderSizePixel = 0;
TextLabel2.Font = JosefinSans;
TextLabel2.Text = "YOUR ITEMS";
TextLabel2.TextColor3 = u1.Text;
TextLabel2.TextScaled = true;
TextLabel2.Parent = Frame;
local UITextSizeConstraint2 = Instance.new("UITextSizeConstraint");
UITextSizeConstraint2.MinTextSize = 9;
UITextSizeConstraint2.MaxTextSize = 22;
UITextSizeConstraint2.Parent = TextLabel2;
TextLabel2.Name = "Subtitle";
TextLabel2.TextColor3 = u1.Muted;
TextLabel2.TextXAlignment = Enum.TextXAlignment.Left;
TextLabel2.Position = UDim2.new(0, 20, 0, 43);
TextLabel2.Size = UDim2.new(0.45, 0, 0, 14);
TextLabel2.ZIndex = 22;
TextLabel2:FindFirstChildOfClass("UITextSizeConstraint").MaxTextSize = 11;
local TextButton2 = Instance.new("TextButton");
TextButton2.BackgroundTransparency = 1;
TextButton2.BorderSizePixel = 0;
TextButton2.Font = JosefinSans;
TextButton2.Text = "×";
TextButton2.TextColor3 = u1.Text;
TextButton2.TextScaled = true;
TextButton2.Parent = Frame;
local UITextSizeConstraint3 = Instance.new("UITextSizeConstraint");
UITextSizeConstraint3.MinTextSize = 9;
UITextSizeConstraint3.MaxTextSize = 22;
UITextSizeConstraint3.Parent = TextButton2;
TextButton2.Name = "Close";
TextButton2.AnchorPoint = Vector2.new(1, 0);
TextButton2.Position = UDim2.new(1, -12, 0, 12);
TextButton2.Size = UDim2.fromOffset(36, 36);
TextButton2.BackgroundColor3 = Color3.fromRGB(28, 29, 35);
TextButton2.BackgroundTransparency = 0.1;
TextButton2.AutoButtonColor = true;
TextButton2.ZIndex = 23;
local UICorner2 = Instance.new("UICorner");
UICorner2.CornerRadius = UDim.new(0, 7);
UICorner2.Parent = TextButton2;
local Stroke2 = u1.Stroke;
local UIStroke2 = Instance.new("UIStroke");
UIStroke2.Color = Stroke2;
UIStroke2.Thickness = 1;
UIStroke2.Transparency = 0.35;
UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
UIStroke2.Parent = TextButton2;
local TextBox = Instance.new("TextBox");
TextBox.BackgroundTransparency = 1;
TextBox.BorderSizePixel = 0;
TextBox.Font = JosefinSans;
TextBox.Text = "";
TextBox.TextColor3 = u1.Text;
TextBox.TextScaled = true;
TextBox.Parent = Frame;
local UITextSizeConstraint4 = Instance.new("UITextSizeConstraint");
UITextSizeConstraint4.MinTextSize = 9;
UITextSizeConstraint4.MaxTextSize = 22;
UITextSizeConstraint4.Parent = TextBox;
TextBox.Name = "Search";
TextBox.PlaceholderText = "Search items...";
TextBox.PlaceholderColor3 = u1.Muted;
TextBox.TextXAlignment = Enum.TextXAlignment.Left;
TextBox.ClearTextOnFocus = false;
TextBox.TextScaled = false;
TextBox.TextSize = 16;
TextBox.Position = UDim2.new(0, 18, 0, 68);
TextBox.Size = UDim2.new(1, -36, 0, 38);
TextBox.BackgroundColor3 = u1.Background;
TextBox.BackgroundTransparency = 0.16;
TextBox.ZIndex = 22;
local UICorner3 = Instance.new("UICorner");
UICorner3.CornerRadius = UDim.new(0, 7);
UICorner3.Parent = TextBox;
local Stroke3 = u1.Stroke;
local UIStroke3 = Instance.new("UIStroke");
UIStroke3.Color = Stroke3;
UIStroke3.Thickness = 1;
UIStroke3.Transparency = 0.35;
UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
UIStroke3.Parent = TextBox;
local UIPadding = Instance.new("UIPadding");
UIPadding.PaddingLeft = UDim.new(0, 12);
UIPadding.PaddingRight = UDim.new(0, 12);
UIPadding.Parent = TextBox;
local ScrollingFrame = Instance.new("ScrollingFrame");
ScrollingFrame.Name = "Items";
ScrollingFrame.Position = UDim2.new(0, 18, 0, 118);
ScrollingFrame.Size = UDim2.new(1, -36, 1, -158);
ScrollingFrame.BackgroundTransparency = 1;
ScrollingFrame.BorderSizePixel = 0;
ScrollingFrame.ScrollBarThickness = 4;
ScrollingFrame.ScrollBarImageColor3 = u1.Accent;
ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;
ScrollingFrame.CanvasSize = UDim2.new();
ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y;
ScrollingFrame.ZIndex = 22;
ScrollingFrame.Parent = Frame;
local UIGridLayout = Instance.new("UIGridLayout");
UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder;
UIGridLayout.CellPadding = UDim2.fromOffset(8, 8);
UIGridLayout.CellSize = UDim2.fromOffset(86, 92);
UIGridLayout.Parent = ScrollingFrame;
local TextLabel3 = Instance.new("TextLabel");
TextLabel3.BackgroundTransparency = 1;
TextLabel3.BorderSizePixel = 0;
TextLabel3.Font = JosefinSans;
TextLabel3.Text = "NO ITEMS";
TextLabel3.TextColor3 = u1.Text;
TextLabel3.TextScaled = true;
TextLabel3.Parent = Frame;
local UITextSizeConstraint5 = Instance.new("UITextSizeConstraint");
UITextSizeConstraint5.MinTextSize = 9;
UITextSizeConstraint5.MaxTextSize = 22;
UITextSizeConstraint5.Parent = TextLabel3;
TextLabel3.Name = "Empty";
TextLabel3.TextColor3 = u1.Muted;
TextLabel3.AnchorPoint = Vector2.new(0.5, 0.5);
TextLabel3.Position = UDim2.fromScale(0.5, 0.56);
TextLabel3.Size = UDim2.fromOffset(180, 44);
TextLabel3.Visible = false;
TextLabel3.ZIndex = 23;
local TextLabel4 = Instance.new("TextLabel");
TextLabel4.BackgroundTransparency = 1;
TextLabel4.BorderSizePixel = 0;
TextLabel4.Font = JosefinSans;
TextLabel4.Text = "0 ITEMS";
TextLabel4.TextColor3 = u1.Text;
TextLabel4.TextScaled = true;
TextLabel4.Parent = Frame;
local UITextSizeConstraint6 = Instance.new("UITextSizeConstraint");
UITextSizeConstraint6.MinTextSize = 9;
UITextSizeConstraint6.MaxTextSize = 22;
UITextSizeConstraint6.Parent = TextLabel4;
TextLabel4.Name = "Count";
TextLabel4.TextColor3 = u1.Muted;
TextLabel4.TextXAlignment = Enum.TextXAlignment.Right;
TextLabel4.AnchorPoint = Vector2.new(1, 1);
TextLabel4.Position = UDim2.new(1, -18, 1, -10);
TextLabel4.Size = UDim2.fromOffset(180, 22);
TextLabel4.ZIndex = 22;
TextLabel4:FindFirstChildOfClass("UITextSizeConstraint").MaxTextSize = 13;
local TextButton3 = Instance.new("TextButton");
TextButton3.BackgroundTransparency = 1;
TextButton3.BorderSizePixel = 0;
TextButton3.Font = JosefinSans;
TextButton3.Text = "INVENTORY  [B]";
TextButton3.TextColor3 = u1.Text;
TextButton3.TextScaled = true;
TextButton3.Parent = ScreenGui;
local UITextSizeConstraint7 = Instance.new("UITextSizeConstraint");
UITextSizeConstraint7.MinTextSize = 9;
UITextSizeConstraint7.MaxTextSize = 22;
UITextSizeConstraint7.Parent = TextButton3;
TextButton3.Name = "InventoryButton";
TextButton3.TextScaled = false;
TextButton3.TextSize = 16;
TextButton3.TextWrapped = false;
TextButton3.Position = UDim2.fromOffset(16, 64);
TextButton3.Size = UDim2.fromOffset(142, 40);
TextButton3.BackgroundColor3 = u1.Panel;
TextButton3.BackgroundTransparency = 0.12;
TextButton3.AutoButtonColor = true;
TextButton3.Visible = false;
TextButton3.Active = false;
TextButton3.ZIndex = 12;
local UICorner4 = Instance.new("UICorner");
UICorner4.CornerRadius = UDim.new(0, 8);
UICorner4.Parent = TextButton3;
local Stroke4 = u1.Stroke;
local UIStroke4 = Instance.new("UIStroke");
UIStroke4.Color = Stroke4;
UIStroke4.Thickness = 1;
UIStroke4.Transparency = 0.25;
UIStroke4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
UIStroke4.Parent = TextButton3;
local Frame3 = Instance.new("Frame");
Frame3.BackgroundColor3 = u1.Accent;
Frame3.BorderSizePixel = 0;
Frame3.Size = UDim2.new(0, 3, 1, -10);
Frame3.Position = UDim2.fromOffset(5, 5);
Frame3.ZIndex = 13;
Frame3.Parent = TextButton3;
local UICorner5 = Instance.new("UICorner");
UICorner5.CornerRadius = UDim.new(0, 2);
UICorner5.Parent = Frame3;
local u11 = false;
local u12 = setmetatable({}, {
    __mode = "k"
});
local u13 = 0;
local u14 = {};
local u15 = false;
local u16 = false;

local function getCharacter() -- Line: 234
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer.Character;
end;

local function getHumanoid() -- Line: 238
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChildOfClass("Humanoid");
    end;

    return Character;
end;

local function isEquipped(p17) -- Line: 243
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;
    local v18;

    if Character == nil then
        v18 = false;
    else
        v18 = p17.Parent == Character;
    end;

    return v18;
end;

local function getToolAmount(p19) -- Line: 248
    local v20 = tonumber(p19:GetAttribute("Amount"));

    if v20 then
        local math_floor_ret = math.floor(v20);

        return math.max(1, math_floor_ret);
    end;

    local Amount = p19:FindFirstChild("Amount");

    if not (Amount and (Amount:IsA("IntValue") or Amount:IsA("NumberValue"))) then
        return 1;
    end;

    local math_floor_ret = math.floor(Amount.Value);

    return math.max(1, math_floor_ret);
end;

local function getTools() -- Line: 260
    -- upvalues: u12 (copy), u13 (ref), LocalPlayer (copy)
    local u21 = {};
    local u22 = {};

    local function collect(p23) -- Line: 263
        -- upvalues: u22 (copy), u12 (ref), u13 (ref), u21 (copy)
        if not p23 then
            return;
        end;

        for _, child in ipairs(p23:GetChildren()) do
            if child:IsA("Tool") and not u22[child] then
                u22[child] = true;

                if not u12[child] then
                    u13 = u13 + 1;
                    u12[child] = u13;
                end;

                table.insert(u21, child);
            end;
        end;
    end;

    collect(LocalPlayer:FindFirstChild("Backpack"));
    collect(LocalPlayer.Character);
    table.sort(u21, function(p24, p25) -- Line: 280
        -- upvalues: u12 (ref)
        local v26 = u12[p24] or (1 / 0);
        local v27 = u12[p25] or (1 / 0);

        if v26 == v27 then
            return p24.Name:lower() < p25.Name:lower();
        end;

        return v26 < v27;
    end);

    return u21;
end;

local function getToolGroups() -- Line: 291
    -- upvalues: getTools (copy), u12 (copy), getToolAmount (copy), LocalPlayer (copy)
    local v28 = {};
    local v29 = {};

    for _, v in ipairs((getTools())) do
        local string_lower_ret = string.lower(v.Name);
        local v30 = v28[string_lower_ret];

        if not v30 then
            v30 = {
                Amount = 0,
                Equipped = false,
                Name = v.Name,
                TextureId = v.TextureId or "",
                Tools = {},
                Order = u12[v] or (1 / 0)
            };
            v28[string_lower_ret] = v30;
            table.insert(v29, v30);
        end;

        table.insert(v30.Tools, v);
        v30.Amount = v30.Amount + getToolAmount(v);
        v30.Order = math.min(v30.Order, u12[v] or (1 / 0));
        local Character = LocalPlayer.Character;
        local v31;

        if Character == nil then
            v31 = false;
        else
            v31 = v.Parent == Character;
        end;

        if v31 then
            v30.Equipped = true;
            v30.EquippedTool = v;
        end;
    end;

    table.sort(v29, function(p32, p33) -- Line: 320
        if p32.Order == p33.Order then
            return p32.Name:lower() < p33.Name:lower();
        end;

        return p32.Order < p33.Order;
    end);

    return v29;
end;

local function clearGeneratedSlots(p34) -- Line: 329
    for _, child in ipairs(p34:GetChildren()) do
        if child:GetAttribute("GeneratedInventorySlot") == true then
            child:Destroy();
        end;
    end;
end;

local function equipToolGroup(p35) -- Line: 337
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChildOfClass("Humanoid");
    end;

    if not (Character and (Character.Health > 0 and p35)) then
        return;
    end;

    if p35.Equipped then
        Character:UnequipTools();

        return;
    end;

    local v36 = nil;

    for _, v in ipairs(p35.Tools) do
        if v.Parent == LocalPlayer:FindFirstChild("Backpack") then
            v36 = v;
            break;
        end;
    end;

    local v37 = v36 or p35.Tools[1];

    if v37 and v37.Parent then
        Character:EquipTool(v37);
    end;
end;

local function createSlot(u38, p39, p40, p41) -- Line: 361
    -- upvalues: u1 (copy), JosefinSans (copy), u16 (ref), equipToolGroup (copy)
    if not u38.Tools[1] then
        return nil;
    end;

    local TextButton4 = Instance.new("TextButton");
    TextButton4.Name = "ToolSlot";
    TextButton4:SetAttribute("GeneratedInventorySlot", true);
    TextButton4.LayoutOrder = p39;
    TextButton4.Text = "";
    TextButton4.AutoButtonColor = false;
    TextButton4.BackgroundColor3 = u1.Slot;
    TextButton4.BackgroundTransparency = 0.08;
    TextButton4.BorderSizePixel = 0;
    TextButton4.Size = UDim2.fromOffset(p40, p40);
    TextButton4.ZIndex = 24;
    local UICorner6 = Instance.new("UICorner");
    UICorner6.CornerRadius = UDim.new(0, 7);
    UICorner6.Parent = TextButton4;
    local v42 = u38.Equipped and u1.Gold or u1.Stroke;
    local v43 = u38.Equipped and 2 or 1;
    local v44 = u38.Equipped and 0 or 0.3;
    local UIStroke5 = Instance.new("UIStroke");
    UIStroke5.Color = v42;
    UIStroke5.Thickness = v43;
    UIStroke5.Transparency = v44 or 0;
    UIStroke5.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke5.Parent = TextButton4;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "Icon";
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Image = u38.TextureId;
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Position = UDim2.new(0, 7, 0, 6);
    ImageLabel.Size = UDim2.new(1, -14, 0.6, 0);
    ImageLabel.ZIndex = 25;
    ImageLabel.Parent = TextButton4;
    local string_upper_ret = string.upper((string.sub(u38.Name, 1, 2)));
    local TextLabel5 = Instance.new("TextLabel");
    TextLabel5.BackgroundTransparency = 1;
    TextLabel5.BorderSizePixel = 0;
    TextLabel5.Font = JosefinSans;
    TextLabel5.Text = string_upper_ret;
    TextLabel5.TextColor3 = u1.Text;
    TextLabel5.TextScaled = true;
    TextLabel5.Parent = TextButton4;
    local UITextSizeConstraint8 = Instance.new("UITextSizeConstraint");
    UITextSizeConstraint8.MinTextSize = 9;
    UITextSizeConstraint8.MaxTextSize = 22;
    UITextSizeConstraint8.Parent = TextLabel5;
    TextLabel5.Name = "Fallback";
    TextLabel5.TextColor3 = u1.Muted;
    TextLabel5.Position = UDim2.new(0, 7, 0, 7);
    TextLabel5.Size = UDim2.new(1, -14, 0.52, 0);
    TextLabel5.Visible = ImageLabel.Image == "";
    TextLabel5.ZIndex = 25;
    TextLabel5:FindFirstChildOfClass("UITextSizeConstraint").MaxTextSize = math.floor(p40 * 0.28);
    local string_upper_ret2 = string.upper(u38.Name);
    local TextLabel6 = Instance.new("TextLabel");
    TextLabel6.BackgroundTransparency = 1;
    TextLabel6.BorderSizePixel = 0;
    TextLabel6.Font = JosefinSans;
    TextLabel6.Text = string_upper_ret2;
    TextLabel6.TextColor3 = u1.Text;
    TextLabel6.TextScaled = true;
    TextLabel6.Parent = TextButton4;
    local UITextSizeConstraint9 = Instance.new("UITextSizeConstraint");
    UITextSizeConstraint9.MinTextSize = 9;
    UITextSizeConstraint9.MaxTextSize = 22;
    UITextSizeConstraint9.Parent = TextLabel6;
    TextLabel6.Name = "ToolName";
    TextLabel6.TextWrapped = true;
    TextLabel6.TextTruncate = Enum.TextTruncate.AtEnd;
    TextLabel6.Position = UDim2.new(0, 5, 0.66, 0);
    TextLabel6.Size = UDim2.new(1, -10, 0.27, 0);
    TextLabel6.ZIndex = 25;
    TextLabel6:FindFirstChildOfClass("UITextSizeConstraint").MaxTextSize = u16 and 10 or 12;
    local Amount = u38.Amount;

    if Amount > 1 then
        local v45 = "×" .. tostring(Amount);
        local TextLabel7 = Instance.new("TextLabel");
        TextLabel7.BackgroundTransparency = 1;
        TextLabel7.BorderSizePixel = 0;
        TextLabel7.Font = JosefinSans;
        TextLabel7.Text = v45;
        TextLabel7.TextColor3 = u1.Text;
        TextLabel7.TextScaled = true;
        TextLabel7.Parent = TextButton4;
        local UITextSizeConstraint10 = Instance.new("UITextSizeConstraint");
        UITextSizeConstraint10.MinTextSize = 9;
        UITextSizeConstraint10.MaxTextSize = 22;
        UITextSizeConstraint10.Parent = TextLabel7;
        TextLabel7.Name = "Amount";
        TextLabel7.TextXAlignment = Enum.TextXAlignment.Right;
        TextLabel7.AnchorPoint = Vector2.new(1, 0);
        TextLabel7.Position = UDim2.new(1, -5, 0, 4);
        TextLabel7.Size = UDim2.new(0.48, 0, 0, 16);
        TextLabel7.TextColor3 = u1.Gold;
        TextLabel7.ZIndex = 26;
        TextLabel7:FindFirstChildOfClass("UITextSizeConstraint").MaxTextSize = 12;
    end;

    if p41 then
        local v46 = tostring(p39);
        local TextLabel7 = Instance.new("TextLabel");
        TextLabel7.BackgroundTransparency = 1;
        TextLabel7.BorderSizePixel = 0;
        TextLabel7.Font = JosefinSans;
        TextLabel7.Text = v46;
        TextLabel7.TextColor3 = u1.Text;
        TextLabel7.TextScaled = true;
        TextLabel7.Parent = TextButton4;
        local UITextSizeConstraint10 = Instance.new("UITextSizeConstraint");
        UITextSizeConstraint10.MinTextSize = 9;
        UITextSizeConstraint10.MaxTextSize = 22;
        UITextSizeConstraint10.Parent = TextLabel7;
        TextLabel7.Name = "Key";
        TextLabel7.TextXAlignment = Enum.TextXAlignment.Left;
        TextLabel7.Position = UDim2.fromOffset(5, 4);
        TextLabel7.Size = UDim2.fromOffset(18, 16);
        TextLabel7.TextColor3 = u1.Muted;
        TextLabel7.ZIndex = 26;
        TextLabel7:FindFirstChildOfClass("UITextSizeConstraint").MaxTextSize = 11;
    end;

    TextButton4.MouseEnter:Connect(function() -- Line: 437
        -- upvalues: TextButton4 (copy), u1 (ref)
        TextButton4.BackgroundColor3 = u1.SlotHover;
    end);
    TextButton4.MouseLeave:Connect(function() -- Line: 440
        -- upvalues: TextButton4 (copy), u1 (ref)
        TextButton4.BackgroundColor3 = u1.Slot;
    end);
    TextButton4.Activated:Connect(function() -- Line: 443
        -- upvalues: equipToolGroup (ref), u38 (copy)
        equipToolGroup(u38);
    end);

    return TextButton4;
end;

local function updateResponsiveLayout() -- Line: 449
    -- upvalues: Workspace (copy), u16 (ref), UISizeConstraint (copy), Frame (copy), TextButton3 (copy), TextButton2 (copy), ScrollingFrame (copy), UIGridLayout (copy)
    local CurrentCamera = Workspace.CurrentCamera;
    local v47 = CurrentCamera and CurrentCamera.ViewportSize or Vector2.new(1280, 720);
    u16 = v47.X < 720 and true or v47.Y < 520;

    if u16 then
        UISizeConstraint.MinSize = Vector2.new(280, 200);
        Frame.AnchorPoint = Vector2.new(0.5, 0);
        Frame.Position = UDim2.new(0.5, 0, 0, 40);
        Frame.Size = UDim2.new(0.94, 0, 0, (math.max(205, v47.Y - 98)));
        TextButton3.Size = UDim2.fromOffset(120, 44);
        TextButton3.Text = "INVENTORY";
        TextButton3.Position = UDim2.fromOffset(10, 54);
        TextButton2.Size = UDim2.fromOffset(44, 44);
        TextButton2.Position = UDim2.new(1, -10, 0, 8);
    else
        UISizeConstraint.MinSize = Vector2.new(280, 300);
        Frame.AnchorPoint = Vector2.new(0.5, 0.5);
        Frame.Position = UDim2.fromScale(0.5, 0.5);
        Frame.Size = UDim2.fromScale(0.56, 0.62);
        TextButton3.Size = UDim2.fromOffset(142, 40);
        TextButton3.Text = "INVENTORY  [B]";
        TextButton3.Position = UDim2.fromOffset(16, 64);
        TextButton2.Size = UDim2.fromOffset(36, 36);
        TextButton2.Position = UDim2.new(1, -12, 0, 12);
    end;

    task.defer(function() -- Line: 476
        -- upvalues: ScrollingFrame (ref), u16 (ref), UIGridLayout (ref)
        local math_max_ret = math.max(220, ScrollingFrame.AbsoluteSize.X);
        local math_floor_ret = math.floor((math_max_ret + 8) / ((u16 and 70 or 88) + 8));
        local math_max_ret2 = math.max(3, math_floor_ret);
        local math_floor_ret2 = math.floor((math_max_ret - (math_max_ret2 - 1) * 8) / math_max_ret2);
        local v48 = u16 and math.max(72, math_floor_ret2) or math.max(86, math_floor_ret2);
        UIGridLayout.CellSize = UDim2.fromOffset(math_floor_ret2, v48);
    end);
end;

local function refresh() -- Line: 486
    -- upvalues: u15 (ref), getToolGroups (copy), clearGeneratedSlots (copy), ScrollingFrame (copy), TextBox (copy), createSlot (copy), TextLabel4 (copy), TextLabel3 (copy), updateResponsiveLayout (copy)
    u15 = false;
    local v49 = getToolGroups();
    clearGeneratedSlots(ScrollingFrame);
    local v50 = TextBox.Text:lower();
    local v51 = 0;

    for _, v in ipairs(v49) do
        if v50 == "" or string.find(v.Name:lower(), v50, 1, true) then
            v51 = v51 + 1;
            local v52 = createSlot(v, v51, 86, false);

            if v52 then
                v52.Parent = ScrollingFrame;
            end;
        end;
    end;

    TextLabel4.Text = string.format("%d ITEM TYPE%s", #v49, #v49 == 1 and "" or "S");
    TextLabel3.Visible = v51 == 0;
    updateResponsiveLayout();
end;

local function queueRefresh() -- Line: 508
    -- upvalues: u15 (ref), refresh (copy)
    if u15 then
        return;
    end;

    u15 = true;
    task.defer(refresh);
end;

local function setOpen(p53) -- Line: 516
    -- upvalues: u11 (ref), Frame (copy), TextButton (copy), UIScale (copy), TweenService (copy), u15 (ref), refresh (copy), TextBox (copy)
    u11 = p53 == true;

    if not u11 then
        Frame.Visible = false;
        TextButton.Visible = false;
        TextBox:ReleaseFocus();

        return;
    end;

    Frame.Visible = true;
    TextButton.Visible = true;
    UIScale.Scale = 0.94;
    TweenService:Create(UIScale, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play();

    if u15 then
        return;
    end;

    u15 = true;
    task.defer(refresh);
end;

local function disconnectCharacterConnections() -- Line: 535
    -- upvalues: u14 (copy)
    for _, v in ipairs(u14) do
        v:Disconnect();
    end;

    table.clear(u14);
end;

local u54 = {};

local function watchBackpack(p55) -- Line: 543
    -- upvalues: u54 (copy), queueRefresh (copy), u15 (ref), refresh (copy)
    for _, v in ipairs(u54) do
        v:Disconnect();
    end;

    table.clear(u54);

    if p55 then
        table.insert(u54, p55.ChildAdded:Connect(queueRefresh));
        table.insert(u54, p55.ChildRemoved:Connect(queueRefresh));
    end;

    if u15 then
        return;
    end;

    u15 = true;
    task.defer(refresh);
end;

LocalPlayer.ChildAdded:Connect(function(p56) -- Line: 553
    -- upvalues: watchBackpack (copy)
    if p56:IsA("Backpack") then
        watchBackpack(p56);
    end;
end);

local function watchCharacter(p57) -- Line: 559
    -- upvalues: u14 (copy), u15 (ref), refresh (copy), queueRefresh (copy)
    for _, v in ipairs(u14) do
        v:Disconnect();
    end;

    table.clear(u14);

    if not p57 then
        if u15 then
            return;
        end;

        u15 = true;
        task.defer(refresh);

        return;
    end;

    table.insert(u14, p57.ChildAdded:Connect(queueRefresh));
    table.insert(u14, p57.ChildRemoved:Connect(queueRefresh));

    if u15 then
        return;
    end;

    u15 = true;
    task.defer(refresh);
end;

local function enableDefaultBackpack() -- Line: 570
    -- upvalues: StarterGui (copy)
    for i = 1, 5 do
        pcall(function() -- Line: 572
            -- upvalues: StarterGui (ref)
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true);
        end);
        task.wait(0.25);
        local _ = i;
    end;
end;

local function dropEquippedTool() -- Line: 579
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if not Character then
        return;
    end;

    local v58 = Character:FindFirstChildOfClass("Tool");

    if not v58 then
        return;
    end;

    local DropToolRemote = game.ReplicatedStorage:WaitForChild("Funções"):WaitForChild("Eventos"):WaitForChild("DropToolRemote", 5);

    if DropToolRemote then
        DropToolRemote:FireServer(v58);

        return;
    end;

    warn("DropToolRemote não ficou disponível a tempo");
end;

local function bindDropButton(p59) -- Line: 597
    -- upvalues: dropEquippedTool (copy)
    if not (p59 and p59:IsA("GuiButton")) then
        return;
    end;

    if p59:GetAttribute("InventoryDropBound") == true then
        return;
    end;

    p59:SetAttribute("InventoryDropBound", true);
    p59.Activated:Connect(dropEquippedTool);
end;

local function bindMobileDropButtons() -- Line: 604
    -- upvalues: PlayerGui (copy), bindDropButton (copy)
    local TEAMS = PlayerGui:FindFirstChild("TEAMS");

    if not TEAMS then
        return;
    end;

    local VampireMOBILE = TEAMS:FindFirstChild("VampireMOBILE");

    if VampireMOBILE then
        VampireMOBILE = VampireMOBILE:FindFirstChild("DROP", true);
    end;

    bindDropButton(VampireMOBILE);
    local WitchesMOBILE = TEAMS:FindFirstChild("WitchesMOBILE");

    if WitchesMOBILE then
        WitchesMOBILE = WitchesMOBILE:FindFirstChild("Powers");
    end;

    if WitchesMOBILE then
        WitchesMOBILE = WitchesMOBILE:FindFirstChild("DROP");
    end;

    bindDropButton(WitchesMOBILE);
end;

bindMobileDropButtons();
PlayerGui.ChildAdded:Connect(function(p60) -- Line: 617
    -- upvalues: bindMobileDropButtons (copy)
    if p60.Name == "TEAMS" then
        task.defer(bindMobileDropButtons);
    end;
end);
UserInputService.InputBegan:Connect(function(p61, p62) -- Line: 623
    -- upvalues: UserInputService (copy), LocalPlayer (copy)
    if p62 and p61.KeyCode ~= Enum.KeyCode.Backspace or UserInputService:GetFocusedTextBox() then
        return;
    end;

    local v63 = p61.KeyCode == Enum.KeyCode.Backspace and LocalPlayer.Character;

    if v63 then
        for _, child in ipairs(v63:GetChildren()) do
            if child:IsA("Tool") then
                local DropToolRemote = game.ReplicatedStorage:WaitForChild("Funções"):WaitForChild("Eventos"):WaitForChild("DropToolRemote", 5);

                if DropToolRemote then
                    DropToolRemote:FireServer(child);

                    return;
                end;

                warn("DropToolRemote não ficou disponível a tempo");

                return;
            end;
        end;
    end;
end);
LocalPlayer.CharacterAdded:Connect(watchCharacter);
LocalPlayer.CharacterRemoving:Connect(function() -- Line: 647
    -- upvalues: u14 (copy), u15 (ref), refresh (copy)
    for _, v in ipairs(u14) do
        v:Disconnect();
    end;

    table.clear(u14);

    if u15 then
        return;
    end;

    u15 = true;
    task.defer(refresh);
end);

local function bindCamera() -- Line: 652
    -- upvalues: Workspace (copy), updateResponsiveLayout (copy), u15 (ref), refresh (copy)
    local CurrentCamera = Workspace.CurrentCamera;

    if CurrentCamera then
        CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- Line: 655
            -- upvalues: updateResponsiveLayout (ref), u15 (ref), refresh (ref)
            updateResponsiveLayout();

            if u15 then
                return;
            end;

            u15 = true;
            task.defer(refresh);
        end);
    end;
end;

Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindCamera);
local CurrentCamera = Workspace.CurrentCamera;

if CurrentCamera then
    CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- Line: 655
        -- upvalues: updateResponsiveLayout (copy), u15 (ref), refresh (copy)
        updateResponsiveLayout();

        if u15 then
            return;
        end;

        u15 = true;
        task.defer(refresh);
    end);
end;

local Character = LocalPlayer.Character;

for _, v in ipairs(u14) do
    v:Disconnect();
end;

table.clear(u14);

if Character then
    table.insert(u14, Character.ChildAdded:Connect(queueRefresh));
    table.insert(u14, Character.ChildRemoved:Connect(queueRefresh));

    if not u15 then
        u15 = true;
        task.defer(refresh);
    end;
elseif not u15 then
    u15 = true;
    task.defer(refresh);
end;

watchBackpack(LocalPlayer:FindFirstChild("Backpack"));
updateResponsiveLayout();

if not u15 then
    u15 = true;
    task.defer(refresh);
end;

task.spawn(function() -- Line: 669
    -- upvalues: ScreenGui (copy), getTools (copy), getToolAmount (copy), u15 (ref), refresh (copy)
    local v64 = "";

    while ScreenGui.Parent do
        task.wait(0.35);
        local v65 = {};

        for i, v in ipairs((getTools())) do
            local table_concat = table.concat;
            local v66 = {};
            local Name = v.Name;
            local v67 = v.Parent and (v.Parent.Name or "") or "";
            local v68 = getToolAmount(v);
            v66[1], v66[2], v66[3], v66[4] = Name, v67, tostring(v68), v.TextureId or "";
            v65[i] = table_concat(v66, "|");
        end;

        local table_concat_ret = table.concat(v65, ";");

        if table_concat_ret == v64 then
            table_concat_ret = v64;
        elseif not u15 then
            u15 = true;
            task.defer(refresh);
        end;

        v64 = table_concat_ret;
    end;
end);
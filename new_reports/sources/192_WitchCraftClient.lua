-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local GuiService = game:GetService("GuiService");
local ContextActionService = game:GetService("ContextActionService");
local LocalPlayer = Players.LocalPlayer;
local Eventos = ReplicatedStorage:WaitForChild("Funções"):WaitForChild("Eventos");
local WitchCraftOpen = Eventos:WaitForChild("WitchCraftOpen");
local WitchCraftRequest = Eventos:WaitForChild("WitchCraftRequest");
local WitchCraftUI = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("WitchCraftUI");
local Main = WitchCraftUI:WaitForChild("Main");
local Inventory = Main:WaitForChild("Inventory");
local Slots = Main:WaitForChild("Slots");
local Status = Main:WaitForChild("Status");
local Craft = Main:WaitForChild("Craft");
local Close = Main:WaitForChild("Close");
local u1 = { Slots:WaitForChild("Slot1"), Slots:WaitForChild("Slot2"), Slots:WaitForChild("Slot3") };
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = false;

local function setStatus(p6, p7) -- Line: 33
    -- upvalues: Status (copy)
    Status.Text = tostring(p6 or "");
    Status.TextColor3 = p7 and Color3.fromRGB(155, 230, 170) or Color3.fromRGB(225, 165, 175);
end;

local function clearSlot(p8) -- Line: 38
    p8:SetAttribute("ToolName", "");
    p8.Text = "+";
    p8.TextSize = 24;
end;

local function clearSlots() -- Line: 44
    -- upvalues: u1 (copy)
    for _, v in ipairs(u1) do
        v:SetAttribute("ToolName", "");
        v.Text = "+";
        v.TextSize = 24;
    end;
end;

local function slotAtPoint(p9) -- Line: 50
    -- upvalues: u1 (copy)
    for _, v in ipairs(u1) do
        local AbsolutePosition = v.AbsolutePosition;
        local AbsoluteSize = v.AbsoluteSize;

        if p9.X >= AbsolutePosition.X and (p9.X <= AbsolutePosition.X + AbsoluteSize.X and (p9.Y >= AbsolutePosition.Y and p9.Y <= AbsolutePosition.Y + AbsoluteSize.Y)) then
            return v;
        end;
    end;

    return nil;
end;

local function countOwnedByName() -- Line: 61
    -- upvalues: LocalPlayer (copy)
    local u10 = {};

    local function scan(p11) -- Line: 63
        -- upvalues: u10 (copy)
        if not p11 then
            return;
        end;

        for _, child in ipairs(p11:GetChildren()) do
            if child:IsA("Tool") then
                u10[child.Name] = (u10[child.Name] or 0) + 1;
            end;
        end;
    end;

    scan(LocalPlayer.Character);
    scan(LocalPlayer:FindFirstChildOfClass("Backpack"));

    return u10;
end;

local function countSlotted(p12) -- Line: 76
    -- upvalues: u1 (copy)
    local v13 = 0;

    for _, v in ipairs(u1) do
        if v:GetAttribute("ToolName") == p12 then
            v13 = v13 + 1;
        end;
    end;

    return v13;
end;

local function placeToolInSlot(p14, p15) -- Line: 84
    -- upvalues: countOwnedByName (copy), countSlotted (copy), Status (copy)
    if not (p14 and (p14 ~= "" and p15)) then
        return false;
    end;

    local v16 = countOwnedByName()[p14] or 0;
    local v17 = countSlotted(p14);

    if p15:GetAttribute("ToolName") ~= p14 and v16 <= v17 then
        Status.Text = tostring("You do not have another " .. p14 or "");
        Status.TextColor3 = Color3.fromRGB(225, 165, 175);

        return false;
    end;

    p15:SetAttribute("ToolName", p14);
    p15.Text = p14;
    p15.TextSize = 13;
    Status.Text = tostring("");
    Status.TextColor3 = Color3.fromRGB(225, 165, 175);

    return true;
end;

local function removeInventoryButtons() -- Line: 99
    -- upvalues: Inventory (copy)
    for _, child in ipairs(Inventory:GetChildren()) do
        if child:IsA("TextButton") and child.Name == "InventoryItem" then
            child:Destroy();
        end;
    end;
end;

local function updateGhostPosition(p18) -- Line: 107
    -- upvalues: u2 (ref)
    if u2 then
        u2.Position = UDim2.fromOffset(p18.X - 70, p18.Y - 20);
    end;
end;

local function endDrag(p19) -- Line: 113
    -- upvalues: u3 (ref), slotAtPoint (copy), placeToolInSlot (copy), u2 (ref), u4 (ref)
    if not u3 then
        return;
    end;

    local v20 = slotAtPoint(p19);

    if v20 then
        placeToolInSlot(u3, v20);
    end;

    if u2 then
        u2:Destroy();
    end;

    u2 = nil;
    u3 = nil;
    u4 = nil;
end;

local function beginDrag(p21, p22) -- Line: 125
    -- upvalues: u5 (ref), u3 (ref), u4 (ref), u2 (ref), WitchCraftUI (copy)
    if u5 then
        return;
    end;

    u3 = p21:GetAttribute("ToolName");

    if not u3 or u3 == "" then
        return;
    end;

    u4 = p22;
    u2 = Instance.new("TextLabel");
    u2.Name = "WitchCraftDragGhost";
    u2.Size = UDim2.fromOffset(140, 40);
    u2.BackgroundColor3 = Color3.fromRGB(22, 22, 22);
    u2.BackgroundTransparency = 0.03;
    u2.BorderSizePixel = 0;
    u2.Font = Enum.Font.GothamMedium;
    u2.Text = u3;
    u2.TextColor3 = Color3.fromRGB(255, 255, 255);
    u2.TextSize = 13;
    u2.ZIndex = 100;
    u2.Parent = WitchCraftUI;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0, 8);
    UICorner.Parent = u2;
    local Position = p22.Position;

    if u2 then
        u2.Position = UDim2.fromOffset(Position.X - 70, Position.Y - 20);
    end;
end;

local function createInventoryButton(u23, p24, p25) -- Line: 149
    -- upvalues: u1 (copy), Inventory (copy), beginDrag (copy), u5 (ref), WitchCraftUI (copy), placeToolInSlot (copy), Status (copy)
    local TextButton = Instance.new("TextButton");
    TextButton.Name = "InventoryItem";
    TextButton.LayoutOrder = p25;
    TextButton.Size = UDim2.new(1, 0, 0, 38);
    TextButton.BackgroundColor3 = Color3.fromRGB(22, 22, 22);
    TextButton.BorderSizePixel = 0;
    TextButton.AutoButtonColor = true;
    TextButton.Font = Enum.Font.GothamMedium;
    local v26;

    if p24 > 1 then
        v26 = u23 .. "  x" .. p24 or u23;
    else
        v26 = u23;
    end;

    TextButton.Text = v26;
    TextButton.TextColor3 = Color3.fromRGB(240, 240, 240);
    TextButton.TextSize = 13;
    TextButton.TextXAlignment = Enum.TextXAlignment.Left;
    TextButton:SetAttribute("ToolName", u23);
    TextButton.Selectable = true;
    TextButton.NextSelectionRight = u1[1];
    TextButton.Parent = Inventory;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0, 7);
    UICorner.Parent = TextButton;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.PaddingLeft = UDim.new(0, 12);
    UIPadding.PaddingRight = UDim.new(0, 8);
    UIPadding.Parent = TextButton;
    TextButton.InputBegan:Connect(function(p27) -- Line: 174
        -- upvalues: beginDrag (ref), TextButton (copy)
        if p27.UserInputType == Enum.UserInputType.MouseButton1 or p27.UserInputType == Enum.UserInputType.Touch then
            beginDrag(TextButton, p27);
        end;
    end);
    TextButton.Activated:Connect(function() -- Line: 179
        -- upvalues: u5 (ref), WitchCraftUI (ref), u1 (ref), placeToolInSlot (ref), u23 (copy), Status (ref)
        if u5 or not WitchCraftUI.Enabled then
            return;
        end;

        for _, v in ipairs(u1) do
            if (v:GetAttribute("ToolName") or "") == "" then
                placeToolInSlot(u23, v);

                return;
            end;
        end;

        Status.Text = tostring("All slots are filled");
        Status.TextColor3 = Color3.fromRGB(225, 165, 175);
    end);
end;

local function refreshInventory() -- Line: 191
    -- upvalues: removeInventoryButtons (copy), countOwnedByName (copy), createInventoryButton (copy), Inventory (copy), u1 (copy), Craft (copy), Close (copy)
    removeInventoryButtons();
    local v28 = countOwnedByName();
    local v29 = {};

    for i in pairs(v28) do
        table.insert(v29, i);
    end;

    table.sort(v29, function(p30, p31) -- Line: 196
        return string.lower(p30) < string.lower(p31);
    end);

    for i, v in ipairs(v29) do
        createInventoryButton(v, v28[v], i);
    end;

    local InventoryItem = Inventory:FindFirstChild("InventoryItem");

    for _, v in ipairs(u1) do
        v.Selectable = true;

        if InventoryItem then
            v.NextSelectionLeft = InventoryItem;
        end;
    end;

    Craft.Selectable = true;
    Close.Selectable = true;
end;

local function fitUi() -- Line: 209
    -- upvalues: Main (copy)
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if not workspace_CurrentCamera then
        return;
    end;

    local ResponsiveScale = Main:FindFirstChild("ResponsiveScale");

    if not ResponsiveScale then
        ResponsiveScale = Instance.new("UIScale");
        ResponsiveScale.Name = "ResponsiveScale";
        ResponsiveScale.Parent = Main;
    end;

    local ViewportSize = workspace_CurrentCamera.ViewportSize;
    local math_min_ret = math.min(ViewportSize.X / 700, ViewportSize.Y / 430);
    ResponsiveScale.Scale = math.clamp(math_min_ret, 0.68, 1);
end;

local u32 = nil;

local function openUi(p33) -- Line: 223
    -- upvalues: fitUi (copy), u1 (copy), refreshInventory (copy), Status (copy), Main (copy), WitchCraftUI (copy), ContextActionService (copy), u32 (ref), UserInputService (copy), GuiService (copy), Inventory (copy), Craft (copy)
    fitUi();

    for _, v in ipairs(u1) do
        v:SetAttribute("ToolName", "");
        v.Text = "+";
        v.TextSize = 24;
    end;

    refreshInventory();
    Status.Text = tostring(p33 or "" or "");
    Status.TextColor3 = Color3.fromRGB(225, 165, 175);
    local Hint = Main:FindFirstChild("Hint");

    if Hint and Hint:IsA("TextLabel") then
        Hint.Text = "Select an inventory item or drag it into a slot, then CRAFT";
    end;

    WitchCraftUI.Enabled = true;
    ContextActionService:BindActionAtPriority("WitchCraftCloseGamepad", function(p34, p35) -- Line: 233
        -- upvalues: u32 (ref)
        if p35 == Enum.UserInputState.Begin then
            u32();
        end;

        return Enum.ContextActionResult.Sink;
    end, false, 3500, Enum.KeyCode.ButtonB);

    if UserInputService:GetLastInputType().Name:match("^Gamepad") then
        GuiService.SelectedObject = Inventory:FindFirstChild("InventoryItem") or Craft;
    end;
end;

u32 = function() -- Line: 242
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), ContextActionService (copy), GuiService (copy), WitchCraftUI (copy)
    if u2 then
        u2:Destroy();
    end;

    u2 = nil;
    u3 = nil;
    u4 = nil;
    ContextActionService:UnbindAction("WitchCraftCloseGamepad");

    if GuiService.SelectedObject and GuiService.SelectedObject:IsDescendantOf(WitchCraftUI) then
        GuiService.SelectedObject = nil;
    end;

    WitchCraftUI.Enabled = false;
end;

for _, v in ipairs(u1) do
    v.Activated:Connect(function() -- Line: 255
        -- upvalues: u5 (ref), v (copy), Status (copy)
        if not u5 then
            local v36 = v;
            v36:SetAttribute("ToolName", "");
            v36.Text = "+";
            v36.TextSize = 24;
            Status.Text = tostring("");
            Status.TextColor3 = Color3.fromRGB(225, 165, 175);
        end;
    end);
end;

Close.Activated:Connect(u32);
UserInputService.InputChanged:Connect(function(p37) -- Line: 265
    -- upvalues: u3 (ref), u2 (ref)
    if u3 and (p37.UserInputType == Enum.UserInputType.MouseMovement or p37.UserInputType == Enum.UserInputType.Touch) then
        local Position = p37.Position;

        if u2 then
            u2.Position = UDim2.fromOffset(Position.X - 70, Position.Y - 20);
        end;
    end;
end);
UserInputService.InputEnded:Connect(function(p38) -- Line: 271
    -- upvalues: u3 (ref), slotAtPoint (copy), placeToolInSlot (copy), u2 (ref), u4 (ref)
    if u3 and (p38.UserInputType == Enum.UserInputType.MouseButton1 or p38.UserInputType == Enum.UserInputType.Touch) then
        if not u3 then
            return;
        end;

        local v39 = slotAtPoint(p38.Position);

        if v39 then
            placeToolInSlot(u3, v39);
        end;

        if u2 then
            u2:Destroy();
        end;

        u2 = nil;
        u3 = nil;
        u4 = nil;
    end;
end);
Craft.Activated:Connect(function() -- Line: 277
    -- upvalues: u5 (ref), u1 (copy), Craft (copy), WitchCraftRequest (copy), Status (copy), refreshInventory (copy)
    if u5 then
        return;
    end;

    local u40 = {};

    for i, v in ipairs(u1) do
        u40[i] = v:GetAttribute("ToolName") or "";
    end;

    u5 = true;
    Craft.Text = "CRAFTING...";
    Craft.AutoButtonColor = false;
    local success, result = pcall(function() -- Line: 286
        -- upvalues: WitchCraftRequest (ref), u40 (copy)
        return WitchCraftRequest:InvokeServer(u40);
    end);
    u5 = false;
    Craft.Text = "CRAFT";
    Craft.AutoButtonColor = true;

    if not success then
        Status.Text = tostring("Craft request failed");
        Status.TextColor3 = Color3.fromRGB(225, 165, 175);

        return;
    end;

    if type(result) ~= "table" then
        Status.Text = tostring("Invalid server response");
        Status.TextColor3 = Color3.fromRGB(225, 165, 175);

        return;
    end;

    local v41 = result.ok == true;
    Status.Text = tostring(result.message or "" or "");
    Status.TextColor3 = v41 and Color3.fromRGB(155, 230, 170) or Color3.fromRGB(225, 165, 175);

    if result.ok then
        for _, v in ipairs(u1) do
            v:SetAttribute("ToolName", "");
            v.Text = "+";
            v.TextSize = 24;
        end;

        refreshInventory();
    end;
end);
WitchCraftOpen.OnClientEvent:Connect(function(p42, p43) -- Line: 308
    -- upvalues: LocalPlayer (copy), u32 (ref), openUi (copy)
    if not LocalPlayer.Team or LocalPlayer.Team.Name ~= "Witches" then
        u32();

        return;
    end;

    if p42 == "Open" then
        openUi();

        return;
    end;

    if p42 == "Error" then
        openUi(p43 or "Cannot use spell table");
    end;
end);
LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function() -- Line: 320
    -- upvalues: LocalPlayer (copy), u32 (ref)
    if not LocalPlayer.Team or LocalPlayer.Team.Name ~= "Witches" then
        u32();
    end;
end);
local Backpack = LocalPlayer:WaitForChild("Backpack");
Backpack.ChildAdded:Connect(function() -- Line: 327
    -- upvalues: WitchCraftUI (copy), refreshInventory (copy)
    if WitchCraftUI.Enabled then
        task.defer(refreshInventory);
    end;
end);
Backpack.ChildRemoved:Connect(function() -- Line: 328
    -- upvalues: WitchCraftUI (copy), refreshInventory (copy)
    if WitchCraftUI.Enabled then
        task.defer(refreshInventory);
    end;
end);
LocalPlayer.CharacterAdded:Connect(function(p44) -- Line: 329
    -- upvalues: WitchCraftUI (copy), refreshInventory (copy)
    p44.ChildAdded:Connect(function() -- Line: 330
        -- upvalues: WitchCraftUI (ref), refreshInventory (ref)
        if WitchCraftUI.Enabled then
            task.defer(refreshInventory);
        end;
    end);
    p44.ChildRemoved:Connect(function() -- Line: 331
        -- upvalues: WitchCraftUI (ref), refreshInventory (ref)
        if WitchCraftUI.Enabled then
            task.defer(refreshInventory);
        end;
    end);
end);

if LocalPlayer.Character then
    LocalPlayer.Character.ChildAdded:Connect(function() -- Line: 334
        -- upvalues: WitchCraftUI (copy), refreshInventory (copy)
        if WitchCraftUI.Enabled then
            task.defer(refreshInventory);
        end;
    end);
    LocalPlayer.Character.ChildRemoved:Connect(function() -- Line: 335
        -- upvalues: WitchCraftUI (copy), refreshInventory (copy)
        if WitchCraftUI.Enabled then
            task.defer(refreshInventory);
        end;
    end);
end;

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- Line: 338
    -- upvalues: WitchCraftUI (copy), fitUi (copy)
    if WitchCraftUI.Enabled then
        task.defer(fitUi);
    end;
end);
WitchCraftUI.Enabled = false;
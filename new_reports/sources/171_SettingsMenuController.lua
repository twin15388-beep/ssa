-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local GuiService = game:GetService("GuiService");
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local Icon = require(ReplicatedStorage:WaitForChild("TopbarPlus"):WaitForChild("Icon"));
local Eventos = ReplicatedStorage:WaitForChild("Funções"):WaitForChild("Eventos");
local PartyRemote = Eventos:WaitForChild("PartyRemote");
local MobileHudLayoutRemote = Eventos:WaitForChild("MobileHudLayoutRemote");
local RedeemCodeRemote = Eventos:WaitForChild("RedeemCodeRemote");
local QuestRemote = ReplicatedStorage:WaitForChild("QuestRemotes"):WaitForChild("QuestRemote");
local HunterQuestRemote = ReplicatedStorage:WaitForChild("HunterQuestRemotes"):WaitForChild("HunterQuestRemote");
local Quest2Remote = ReplicatedStorage:WaitForChild("Quest2Remotes"):WaitForChild("Quest2Remote");

local function destroyIcon(p1) -- Line: 17
    -- upvalues: Icon (copy)
    while true do
        local Icon2 = Icon.getIcon(p1);

        if not Icon2 then
            break;
        end;

        Icon2:destroy();
    end;
end;

destroyIcon("LowGraphicsMode");
destroyIcon("SettingsMenu");
destroyIcon("SettingsLowGraphics");
destroyIcon("SettingsPVP");
destroyIcon("SettingsAutoQuest");
destroyIcon("SettingsCodes");
destroyIcon("SettingsHudEdit");
destroyIcon("SettingsHudReset");
local u2 = Icon.new():setName("SettingsLowGraphics"):setLabel("LOW: OFF"):setOrder(1):oneClick();
local u3 = Icon.new():setName("SettingsPVP"):setLabel("PVP: ON"):setOrder(2):oneClick();
local u4 = Icon.new():setName("SettingsAutoQuest"):setLabel("AUTO QUEST: OFF"):setOrder(3):oneClick();
local u5 = Icon.new():setName("SettingsHudEdit"):setLabel("HUD EDIT: OFF"):setOrder(4):setEnabled(UserInputService.TouchEnabled):oneClick();
local v6 = Icon.new():setName("SettingsHudReset"):setLabel("RESET HUD"):setOrder(5):setEnabled(UserInputService.TouchEnabled):oneClick();
local v7 = Icon.new():setName("SettingsCodes"):setLabel("CODES"):setOrder(6):oneClick();
local u8 = Icon.new():setName("SettingsMenu"):setLabel("⚙"):setOrder(24):align("Left"):setDropdown({
    u2,
    u3,
    u4,
    u5,
    v6,
    v7
});
local CodeRedemptionGui = PlayerGui:FindFirstChild("CodeRedemptionGui");

if CodeRedemptionGui then
    CodeRedemptionGui:Destroy();
end;

local ScreenGui = Instance.new("ScreenGui");
ScreenGui.Name = "CodeRedemptionGui";
ScreenGui.ResetOnSpawn = false;
ScreenGui.IgnoreGuiInset = true;
ScreenGui.ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets;
ScreenGui.SafeAreaCompatibility = Enum.SafeAreaCompatibility.None;
ScreenGui.DisplayOrder = 80;
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
ScreenGui.Enabled = false;
ScreenGui.Parent = PlayerGui;
local TextButton = Instance.new("TextButton");
TextButton.Name = "Shade";
TextButton.Text = "";
TextButton.AutoButtonColor = false;
TextButton.BackgroundColor3 = Color3.new(0, 0, 0);
TextButton.BackgroundTransparency = 0.45;
TextButton.BorderSizePixel = 0;
TextButton.Size = UDim2.fromScale(1, 1);
TextButton.ZIndex = 1;
TextButton.Parent = ScreenGui;
local Frame = Instance.new("Frame");
Frame.Name = "Panel";
Frame.AnchorPoint = Vector2.new(0.5, 0.5);
Frame.Position = UDim2.fromScale(0.5, 0.5);
Frame.Size = UDim2.new(0.88, 0, 0, 214);
Frame.BackgroundColor3 = Color3.fromRGB(13, 13, 18);
Frame.BackgroundTransparency = 0.03;
Frame.BorderSizePixel = 0;
Frame.ZIndex = 2;
Frame.Parent = ScreenGui;
local UISizeConstraint = Instance.new("UISizeConstraint");
UISizeConstraint.MinSize = Vector2.new(280, 190);
UISizeConstraint.MaxSize = Vector2.new(420, 214);
UISizeConstraint.Parent = Frame;
local UICorner = Instance.new("UICorner");
UICorner.CornerRadius = UDim.new(0, 12);
UICorner.Parent = Frame;
local UIStroke = Instance.new("UIStroke");
UIStroke.Color = Color3.fromRGB(150, 24, 45);
UIStroke.Thickness = 1.5;
UIStroke.Transparency = 0.08;
UIStroke.Parent = Frame;
local TextLabel = Instance.new("TextLabel");
TextLabel.Name = "Title";
TextLabel.BackgroundTransparency = 1;
TextLabel.Position = UDim2.fromOffset(22, 14);
TextLabel.Size = UDim2.new(1, -70, 0, 28);
TextLabel.Font = Enum.Font.JosefinSans;
TextLabel.Text = "REDEEM CODE";
TextLabel.TextColor3 = Color3.new(1, 1, 1);
TextLabel.TextSize = 22;
TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
TextLabel.ZIndex = 3;
TextLabel.Parent = Frame;
local TextButton2 = Instance.new("TextButton");
TextButton2.Name = "Close";
TextButton2.AnchorPoint = Vector2.new(1, 0);
TextButton2.Position = UDim2.new(1, -12, 0, 11);
TextButton2.Size = UDim2.fromOffset(34, 34);
TextButton2.BackgroundColor3 = Color3.fromRGB(38, 38, 46);
TextButton2.Text = "×";
TextButton2.TextColor3 = Color3.new(1, 1, 1);
TextButton2.TextSize = 24;
TextButton2.Font = Enum.Font.JosefinSans;
TextButton2.ZIndex = 4;
TextButton2.Parent = Frame;
local UICorner2 = Instance.new("UICorner");
UICorner2.CornerRadius = UDim.new(0, 8);
UICorner2.Parent = TextButton2;
local TextBox = Instance.new("TextBox");
TextBox.Name = "CodeInput";
TextBox.Position = UDim2.fromOffset(22, 58);
TextBox.Size = UDim2.new(1, -44, 0, 46);
TextBox.BackgroundColor3 = Color3.fromRGB(27, 27, 34);
TextBox.BorderSizePixel = 0;
TextBox.ClearTextOnFocus = false;
TextBox.Font = Enum.Font.JosefinSans;
TextBox.PlaceholderText = "ENTER CODE";
TextBox.PlaceholderColor3 = Color3.fromRGB(145, 145, 155);
TextBox.Text = "";
TextBox.TextColor3 = Color3.new(1, 1, 1);
TextBox.TextSize = 18;
TextBox.TextXAlignment = Enum.TextXAlignment.Center;
TextBox.ZIndex = 3;
TextBox.Selectable = true;
TextBox.Parent = Frame;
local UICorner3 = Instance.new("UICorner");
UICorner3.CornerRadius = UDim.new(0, 8);
UICorner3.Parent = TextBox;
local UIStroke2 = Instance.new("UIStroke");
UIStroke2.Color = Color3.fromRGB(76, 76, 90);
UIStroke2.Transparency = 0.25;
UIStroke2.Parent = TextBox;
local TextButton3 = Instance.new("TextButton");
TextButton3.Name = "Redeem";
TextButton3.Position = UDim2.fromOffset(22, 116);
TextButton3.Size = UDim2.new(1, -44, 0, 42);
TextButton3.BackgroundColor3 = Color3.fromRGB(126, 18, 39);
TextButton3.BorderSizePixel = 0;
TextButton3.AutoButtonColor = true;
TextButton3.Font = Enum.Font.JosefinSans;
TextButton3.Text = "REDEEM";
TextButton3.TextColor3 = Color3.new(1, 1, 1);
TextButton3.TextSize = 17;
TextButton3.ZIndex = 3;
TextButton3.Selectable = true;
TextButton3.Parent = Frame;
local UICorner4 = Instance.new("UICorner");
UICorner4.CornerRadius = UDim.new(0, 8);
UICorner4.Parent = TextButton3;
local TextLabel2 = Instance.new("TextLabel");
TextLabel2.Name = "Status";
TextLabel2.BackgroundTransparency = 1;
TextLabel2.Position = UDim2.fromOffset(18, 166);
TextLabel2.Size = UDim2.new(1, -36, 0, 34);
TextLabel2.Font = Enum.Font.JosefinSans;
TextLabel2.Text = "";
TextLabel2.TextColor3 = Color3.fromRGB(210, 210, 220);
TextLabel2.TextSize = 13;
TextLabel2.TextWrapped = true;
TextLabel2.ZIndex = 3;
TextLabel2.Parent = Frame;
local u9 = {
    SettingsLowGraphics = true,
    SettingsPVP = true,
    SettingsAutoQuest = true,
    SettingsHudEdit = true,
    SettingsHudReset = true,
    SettingsCodes = true
};

local function isSettingsGuiObject(p10) -- Line: 235
    -- upvalues: PlayerGui (copy), u9 (copy), ScreenGui (copy)
    local v11 = p10;

    while p10 and p10 ~= PlayerGui do
        if u9[p10.Name] then
            return true;
        end;

        p10 = p10.Parent;
    end;

    return v11:IsDescendantOf(ScreenGui);
end;

local function disableAutomaticLocalization(p12) -- Line: 246
    -- upvalues: PlayerGui (copy), u9 (copy), ScreenGui (copy)
    if p12:IsA("TextLabel") or (p12:IsA("TextButton") or p12:IsA("TextBox")) then
        local v13 = p12;
        local v14;

        while true do
            if not p12 or p12 == PlayerGui then
                v14 = v13:IsDescendantOf(ScreenGui);
                break;
            end;

            if u9[p12.Name] then
                v14 = true;
                break;
            end;

            p12 = p12.Parent;
        end;

        if v14 then
            v13.AutoLocalize = false;
        end;
    end;
end;

for _, descendant in ipairs(PlayerGui:GetDescendants()) do
    if descendant:IsA("TextLabel") or (descendant:IsA("TextButton") or descendant:IsA("TextBox")) then
        local v15 = descendant;
        local v16 = v15;
        local v17 = v15;
        v15 = v16;
        v17 = v16;
        local v18;

        while true do
            if not v16 or v16 == PlayerGui then
                v18 = v15:IsDescendantOf(ScreenGui);
                break;
            end;

            if u9[v16.Name] then
                v18 = true;
                break;
            end;

            v16 = v16.Parent;
        end;

        if v18 then
            v15.AutoLocalize = false;
        end;
    end;
end;

PlayerGui.DescendantAdded:Connect(disableAutomaticLocalization);
local u19 = false;

local function closeCodes() -- Line: 261
    -- upvalues: ScreenGui (copy), TextBox (copy), GuiService (copy)
    ScreenGui.Enabled = false;
    TextBox:ReleaseFocus();

    if GuiService.SelectedObject and GuiService.SelectedObject:IsDescendantOf(ScreenGui) then
        GuiService.SelectedObject = nil;
    end;
end;

local function submitCode() -- Line: 282
    -- upvalues: u19 (ref), TextBox (copy), TextLabel2 (copy), TextButton3 (copy), RedeemCodeRemote (copy)
    if u19 then
        return;
    end;

    local u20 = string.upper(TextBox.Text):match("^%s*(.-)%s*$") or "";

    if u20 == "" then
        TextLabel2.TextColor3 = Color3.fromRGB(255, 120, 135);
        TextLabel2.Text = "Enter a code first.";

        return;
    end;

    u19 = true;
    TextButton3.Text = "CHECKING...";
    TextButton3.Interactable = false;
    TextLabel2.Text = "";
    task.spawn(function() -- Line: 298
        -- upvalues: RedeemCodeRemote (ref), u20 (copy), u19 (ref), TextButton3 (ref), TextLabel2 (ref), TextBox (ref)
        local success, result = pcall(function() -- Line: 299
            -- upvalues: RedeemCodeRemote (ref), u20 (ref)
            return RedeemCodeRemote:InvokeServer(u20);
        end);
        u19 = false;
        TextButton3.Text = "REDEEM";
        TextButton3.Interactable = true;

        if not success or type(result) ~= "table" then
            TextLabel2.TextColor3 = Color3.fromRGB(255, 120, 135);
            TextLabel2.Text = "Unable to check the code. Try again.";

            return;
        end;

        TextLabel2.TextColor3 = result.Success and Color3.fromRGB(115, 255, 150) or Color3.fromRGB(255, 120, 135);
        TextLabel2.Text = tostring(result.Message or "Unable to redeem code.");

        if result.Success then
            TextBox.Text = "";
        end;
    end);
end;

v7.selected:Connect(function() -- Line: 269, Name: openCodes
    -- upvalues: TextLabel2 (copy), TextBox (copy), ScreenGui (copy), UserInputService (copy), GuiService (copy)
    TextLabel2.Text = "";
    TextBox.Text = "";
    ScreenGui.Enabled = true;
    task.defer(function() -- Line: 273
        -- upvalues: UserInputService (ref), GuiService (ref), TextBox (ref)
        if UserInputService.GamepadEnabled and not UserInputService.KeyboardEnabled then
            GuiService.SelectedObject = TextBox;

            return;
        end;

        TextBox:CaptureFocus();
    end);
end);
TextButton2.Activated:Connect(closeCodes);
TextButton.Activated:Connect(closeCodes);
TextButton3.Activated:Connect(submitCode);
TextBox.FocusLost:Connect(function(p21) -- Line: 327
    -- upvalues: submitCode (copy)
    if p21 then
        submitCode();
    end;
end);
UserInputService.InputBegan:Connect(function(p22, p23) -- Line: 333
    -- upvalues: ScreenGui (copy), TextBox (copy), GuiService (copy), TextButton3 (copy), submitCode (copy)
    if not ScreenGui.Enabled then
        return;
    end;

    if p22.KeyCode == Enum.KeyCode.ButtonB or p22.KeyCode == Enum.KeyCode.Escape then
        ScreenGui.Enabled = false;
        TextBox:ReleaseFocus();

        if GuiService.SelectedObject and GuiService.SelectedObject:IsDescendantOf(ScreenGui) then
            GuiService.SelectedObject = nil;
        end;
    elseif p22.KeyCode == Enum.KeyCode.ButtonA and (GuiService.SelectedObject == TextButton3 and not p23) then
        submitCode();
    end;
end);

local function hideLegacyPVPButton() -- Line: 344
    -- upvalues: PlayerGui (copy)
    local PARTYUI = PlayerGui:FindFirstChild("PARTYUI");

    if PARTYUI then
        PARTYUI = PARTYUI:FindFirstChild("BASE");
    end;

    if PARTYUI then
        PARTYUI = PARTYUI:FindFirstChild("PVP");
    end;

    if PARTYUI and PARTYUI:IsA("GuiObject") then
        PARTYUI.Visible = false;
        PARTYUI.Active = false;

        if PARTYUI:IsA("GuiButton") then
            PARTYUI.Interactable = false;
        end;
    end;
end;

local function updateAutoQuestLabel() -- Line: 365
    -- upvalues: LocalPlayer (copy), u4 (copy)
    local v24 = LocalPlayer:GetAttribute("AutoQuestRepeatEnabled") == true;
    local v25 = LocalPlayer:GetAttribute("AutoQuestRepeatQuest") or "";
    local v26 = tostring(v25);

    if v24 and v26 ~= "" then
        u4:setLabel("AUTO " .. string.upper(v26) .. ": ON");

        return;
    end;

    if v24 then
        u4:setLabel("AUTO QUEST: ON");

        return;
    end;

    u4:setLabel("AUTO QUEST: OFF");
end;

u2.selected:Connect(function() -- Line: 382
    -- upvalues: LocalPlayer (copy)
    LocalPlayer:SetAttribute("LowGraphicsEnabled", LocalPlayer:GetAttribute("LowGraphicsEnabled") ~= true);
end);
u3.selected:Connect(function() -- Line: 386
    -- upvalues: PartyRemote (copy), LocalPlayer (copy)
    PartyRemote:FireServer("TogglePVP", LocalPlayer:GetAttribute("PVPDisabled") ~= true);
end);
u4.selected:Connect(function() -- Line: 390
    -- upvalues: LocalPlayer (copy), Quest2Remote (copy), HunterQuestRemote (copy), QuestRemote (copy)
    local v27 = LocalPlayer:GetAttribute("AutoQuestRepeatEnabled") ~= true;
    local v28 = LocalPlayer:GetAttribute("QuestSource") or "";
    local v29 = tostring(v28);
    local v30 = LocalPlayer:GetAttribute("AutoQuestRepeatSource") or "";
    local v31 = tostring(v30);

    if LocalPlayer:GetAttribute("Quest2Active") == true or v31 == "Quest2" then
        Quest2Remote:FireServer("SetAutoRepeat", v27);

        return;
    end;

    if v29 == "NPCQuest2" or v31 == "NPCQuest2" then
        HunterQuestRemote:FireServer("SetAutoRepeat", v27);

        return;
    end;

    QuestRemote:FireServer("SetAutoRepeat", v27);
end);
u5.selected:Connect(function() -- Line: 404
    -- upvalues: UserInputService (copy), LocalPlayer (copy)
    if not UserInputService.TouchEnabled then
        return;
    end;

    LocalPlayer:SetAttribute("MobileHudEditMode", LocalPlayer:GetAttribute("MobileHudEditMode") ~= true);
end);
v6.selected:Connect(function() -- Line: 411
    -- upvalues: UserInputService (copy), MobileHudLayoutRemote (copy), LocalPlayer (copy)
    if not UserInputService.TouchEnabled then
        return;
    end;

    task.spawn(function() -- Line: 413
        -- upvalues: MobileHudLayoutRemote (ref), LocalPlayer (ref)
        local success, result = pcall(function() -- Line: 414
            -- upvalues: MobileHudLayoutRemote (ref)
            return MobileHudLayoutRemote:InvokeServer("Save", {});
        end);

        if success and result == true then
            LocalPlayer:SetAttribute("MobileHudEditMode", false);
            LocalPlayer:SetAttribute("MobileHudResetRevision", (LocalPlayer:GetAttribute("MobileHudResetRevision") or 0) + 1);
        end;
    end);
end);
local ScreenGui2 = Instance.new("ScreenGui");
ScreenGui2.Name = "FinishEditGui";
ScreenGui2.ResetOnSpawn = false;
ScreenGui2.DisplayOrder = 100;
ScreenGui2.Enabled = false;
ScreenGui2.Parent = PlayerGui;
local TextButton4 = Instance.new("TextButton");
TextButton4.Name = "FinishButton";
TextButton4.Size = UDim2.fromOffset(220, 44);
TextButton4.Position = UDim2.new(0.5, 0, 0, 60);
TextButton4.AnchorPoint = Vector2.new(0.5, 0);
TextButton4.BackgroundTransparency = 1;
TextButton4.AutoButtonColor = false;
TextButton4.TextColor3 = Color3.new(1, 1, 1);
TextButton4.TextStrokeTransparency = 1;
TextButton4.Font = Enum.Font.Ubuntu;
TextButton4.TextSize = 20;
TextButton4.Text = "FINISH EDITING HUD";
TextButton4.ZIndex = 10;
TextButton4.Parent = ScreenGui2;
TextButton4.Activated:Connect(function() -- Line: 446
    -- upvalues: LocalPlayer (copy)
    LocalPlayer:SetAttribute("MobileHudEditMode", false);
end);
local u32 = false;
u8.selected:Connect(function() -- Line: 454
    -- upvalues: LocalPlayer (copy)
    if LocalPlayer:GetAttribute("MobileHudEditMode") == true then
        LocalPlayer:SetAttribute("MobileHudEditMode", false);
    end;
end);
u8.deselected:Connect(function() -- Line: 460
    -- upvalues: LocalPlayer (copy), u32 (ref)
    if LocalPlayer:GetAttribute("MobileHudEditMode") == true and not u32 then
        LocalPlayer:SetAttribute("MobileHudEditMode", false);
    end;
end);
LocalPlayer:GetAttributeChangedSignal("MobileHudEditMode"):Connect(function() -- Line: 466
    -- upvalues: LocalPlayer (copy), ScreenGui2 (copy), u8 (copy), u32 (ref)
    local v33 = LocalPlayer:GetAttribute("MobileHudEditMode") == true;
    ScreenGui2.Enabled = v33;

    if v33 and u8.isSelected then
        u32 = true;
        u8:deselect();
        task.defer(function() -- Line: 472
            -- upvalues: u32 (ref)
            u32 = false;
        end);
    end;
end);
LocalPlayer:GetAttributeChangedSignal("LowGraphicsEnabled"):Connect(function() -- Line: 357, Name: updateLowLabel
    -- upvalues: u2 (copy), LocalPlayer (copy)
    u2:setLabel(LocalPlayer:GetAttribute("LowGraphicsEnabled") == true and "LOW: ON" or "LOW: OFF");
end);
LocalPlayer:GetAttributeChangedSignal("PVPDisabled"):Connect(function() -- Line: 361, Name: updatePVPLabel
    -- upvalues: u3 (copy), LocalPlayer (copy)
    u3:setLabel(LocalPlayer:GetAttribute("PVPDisabled") == true and "PVP: OFF" or "PVP: ON");
end);
LocalPlayer:GetAttributeChangedSignal("AutoQuestRepeatEnabled"):Connect(updateAutoQuestLabel);
LocalPlayer:GetAttributeChangedSignal("AutoQuestRepeatQuest"):Connect(updateAutoQuestLabel);
LocalPlayer:GetAttributeChangedSignal("MobileHudEditMode"):Connect(function() -- Line: 377, Name: updateHudEditLabel
    -- upvalues: UserInputService (copy), LocalPlayer (copy), u5 (copy)
    local v34 = UserInputService.TouchEnabled and LocalPlayer:GetAttribute("MobileHudEditMode") == true;
    u5:setLabel(v34 and "HUD EDIT: ON" or "HUD EDIT: OFF");
end);
PlayerGui.ChildAdded:Connect(function(p35) -- Line: 484
    -- upvalues: hideLegacyPVPButton (copy)
    if p35.Name == "PARTYUI" then
        task.defer(hideLegacyPVPButton);
    end;
end);
LocalPlayer:SetAttribute("MobileHudEditMode", false);
hideLegacyPVPButton();
u2:setLabel(LocalPlayer:GetAttribute("LowGraphicsEnabled") == true and "LOW: ON" or "LOW: OFF");
u3:setLabel(LocalPlayer:GetAttribute("PVPDisabled") == true and "PVP: OFF" or "PVP: ON");
updateAutoQuestLabel();
local v36 = UserInputService.TouchEnabled and LocalPlayer:GetAttribute("MobileHudEditMode") == true;
u5:setLabel(v36 and "HUD EDIT: ON" or "HUD EDIT: OFF");
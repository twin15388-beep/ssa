-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local CommonUtils = require(script.Parent.Parent:WaitForChild("CommonUtils"));
local u1 = require(script.Parent:WaitForChild("AvatarAbilitiesInterface")).get(Players.LocalPlayer);
local InputSlots = require(script.Parent:WaitForChild("InputSlots"));
local v2 = CommonUtils.get("FlagUtil");
local UserFlag = v2.getUserFlag("UserAbilitiesUserInterfaceA");
local UserFlag2 = v2.getUserFlag("UserAbilitiesUserInterfaceC");
local u3 = { {
        small = { 72, 60, 60 },
        large = { 92, 112, 112 }
    }, {
        small = { 44, 132, 132 },
        large = { 56, 200, 200 }
    }, {
        small = { 44, 132, 16 },
        large = { 56, 200, 60 }
    }, {
        small = { 44, 16, 132 },
        large = { 56, 60, 200 }
    }, {
        small = { 44, 156, 74 },
        large = { 56, 228, 130 }
    }, {
        small = { 44, 74, 156 },
        large = { 56, 130, 228 }
    }, {
        small = { 44, 16, 16 },
        large = { 56, 60, 60 }
    } };
local u4 = { 28, 44 };
local u5 = { 36, 56 };
local u6 = { 16, 12 };
local u7 = { 16, 12 };

local function IsPortrait() -- Line: 52
    -- upvalues: Players (copy)
    local v8 = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui");

    if v8 then
        return v8.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait;
    end;

    return false;
end;

local u9 = {};
u9.__index = u9;

function u9.new(p10) -- Line: 70
    -- upvalues: u9 (copy)
    local v11 = setmetatable({}, u9);
    v11.parentUIFrame = p10;
    v11.managedButtons = {};
    v11.created = false;
    v11.enabled = false;
    v11.enabledChangedEvent = Instance.new("BindableEvent");

    return v11;
end;

function u9.Enable(p12, p13) -- Line: 83
    if p12.enabled == p13 then
        return;
    end;

    p12.enabled = p13;

    if p13 and not p12.created then
        p12:Create();
        p12.created = true;
    end;

    p12.enabledChangedEvent:Fire();
end;

function u9.CreateAbilityButton(u14, u15, p16, u17, u18, u19) -- Line: 95
    -- upvalues: u1 (copy)
    local u20 = false;
    local u21 = not p16.ButtonAssetId and "rbxassetid://136780077406114" or p16.ButtonAssetId;
    local u22 = not p16.ButtonPressedAssetId and "rbxassetid://76895455502876" or p16.ButtonPressedAssetId;
    local u23;

    if p16.ButtonInvalidAssetId then
        u23 = p16.ButtonInvalidAssetId;
    else
        u23 = nil;
    end;

    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = u15 .. "Button";
    ImageButton.Visible = false;
    ImageButton.BackgroundTransparency = 1;
    ImageButton.Image = u21;
    ImageButton.Parent = u14.parentUIFrame;

    for _, child in u17:GetChildren() do
        if string.find(child.Name, "Touch") and child:IsA("InputBinding") then
            child.UIButton = ImageButton;
            break;
        end;
    end;

    local function ResizeButton() -- Line: 124
        -- upvalues: u14 (copy), u18 (copy), ImageButton (copy), u19 (copy)
        local v24 = math.min(u14.parentUIFrame.AbsoluteSize.x, u14.parentUIFrame.AbsoluteSize.y) <= 500 and u18.small or u18.large;
        local v25 = v24[1];
        local v26 = v24[3];
        local v27 = -v24[2] - v25;
        ImageButton.Size = UDim2.new(0, v25, 0, v25);

        if u19 then
            ImageButton.Position = UDim2.new(1, v27, 0, v26);

            return;
        end;

        ImageButton.Position = UDim2.new(1, v27, 1, -v26 - v25);
    end;

    ResizeButton();
    local u28 = {};
    local PropertyChangedSignal = u14.parentUIFrame:GetPropertyChangedSignal("AbsoluteSize");
    table.insert(u28, PropertyChangedSignal:Connect(ResizeButton));

    local function UpdateButtonState() -- Line: 151
        -- upvalues: u1 (ref), u15 (copy), ImageButton (copy), u14 (copy), u17 (copy), u20 (ref), u22 (ref), u21 (ref), u23 (ref)
        local AbilityValid = u1:GetAbilityValid(u15);
        local AbilityActive = u1:GetAbilityActive(u15);
        ImageButton.Visible = u14.enabled and u17.Enabled;

        if ImageButton.Visible then
            if AbilityActive or u20 and AbilityValid then
                ImageButton.Image = u22;
                ImageButton.ImageTransparency = 0;

                return;
            end;

            if AbilityValid then
                ImageButton.Image = u21;
                ImageButton.ImageTransparency = 0;

                return;
            end;

            if u23 then
                ImageButton.Image = u23;
                ImageButton.ImageTransparency = 0;

                return;
            end;

            ImageButton.Image = u21;
            ImageButton.ImageTransparency = 0.6;
        end;
    end;

    UpdateButtonState();
    ImageButton.MouseButton1Down:Connect(function() -- Line: 176
        -- upvalues: u20 (ref), UpdateButtonState (copy)
        u20 = true;
        UpdateButtonState();
    end);
    ImageButton.MouseButton1Up:Connect(function() -- Line: 181
        -- upvalues: u20 (ref), UpdateButtonState (copy)
        u20 = false;
        UpdateButtonState();
    end);
    ImageButton.MouseLeave:Connect(function() -- Line: 186
        -- upvalues: u20 (ref), UpdateButtonState (copy)
        u20 = false;
        UpdateButtonState();
    end);
    local AbilityActiveChangedSignal = u1:GetAbilityActiveChangedSignal(u15);
    table.insert(u28, AbilityActiveChangedSignal:Connect(UpdateButtonState));
    local AbilityValidChangedSignal = u1:GetAbilityValidChangedSignal(u15);
    table.insert(u28, AbilityValidChangedSignal:Connect(UpdateButtonState));
    table.insert(u28, u14.enabledChangedEvent.Event:Connect(UpdateButtonState));
    local PropertyChangedSignal2 = u17:GetPropertyChangedSignal("Enabled");
    table.insert(u28, PropertyChangedSignal2:Connect(UpdateButtonState));
    ImageButton.Destroying:Connect(function() -- Line: 196
        -- upvalues: u28 (copy)
        for _, v in u28 do
            v:Disconnect();
        end;

        table.clear(u28);
    end);

    return ImageButton;
end;

function u9.CreateOverflowScrollButton(u29, u30) -- Line: 206
    -- upvalues: Players (copy), u4 (copy), u5 (copy), u6 (copy), u7 (copy), InputSlots (copy)
    local ImageButton = Instance.new("ImageButton");
    ImageButton.Name = "ScrollButton";
    ImageButton.BackgroundTransparency = 1;
    ImageButton.Image = "rbxassetid://120193229129639";
    ImageButton.PressedImage = "rbxassetid://122643389561468";
    ImageButton.Parent = u29.parentUIFrame;

    local function v38() -- Line: 217
        -- upvalues: u29 (copy), Players (ref), u4 (ref), u5 (ref), u6 (ref), u7 (ref), ImageButton (copy), u30 (copy)
        local math_min_ret = math.min(u29.parentUIFrame.AbsoluteSize.x, u29.parentUIFrame.AbsoluteSize.y);
        local v31 = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui");
        local v32;

        if v31 then
            v32 = v31.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait;
        else
            v32 = false;
        end;

        local v33 = math_min_ret <= 500;
        local v34 = v33 and u4 or u5;
        local v35 = v33 and u6 or u7;
        local v36 = v33 and 8 or 10;
        local v37 = v33 and 44 or 56;
        ImageButton.Size = UDim2.new(0, v34[1], 0, v34[2]);

        if u30 then
            if v32 then
                ImageButton.Position = UDim2.new(1, -v35[1] - v34[2] + 0.5 * (v34[2] - v34[1]), 0, v35[2] + v34[1] + 4 * v36 + 3 * v37 - 0.5 * (v34[2] - v34[1]));
                ImageButton.Rotation = 270;

                return;
            end;

            ImageButton.Position = UDim2.new(1, -v35[1] - 2 * v34[1] - 4 * v36 - 3 * v37, 0, v35[2]);
            ImageButton.Rotation = 0;

            return;
        end;

        ImageButton.Position = UDim2.new(1, -v35[1] - v34[1], 0, v35[2]);

        if v32 then
            ImageButton.Position = UDim2.new(1, -v35[1] - v34[2] + 0.5 * (v34[2] - v34[1]), 0, v35[2] - 0.5 * (v34[2] - v34[1]));
            ImageButton.Rotation = 90;

            return;
        end;

        ImageButton.Position = UDim2.new(1, -v35[1] - v34[1], 0, v35[2]);
        ImageButton.Rotation = 180;
    end;

    v38();
    local u39 = {};
    local PropertyChangedSignal = u29.parentUIFrame:GetPropertyChangedSignal("AbsoluteSize");
    table.insert(u39, PropertyChangedSignal:Connect(v38));
    ImageButton.Activated:Connect(function() -- Line: 253
        -- upvalues: u30 (copy), InputSlots (ref)
        if u30 then
            InputSlots.setOverflowScrollIndex(InputSlots.getOverflowScrollIndex() + 1);

            return;
        end;

        InputSlots.setOverflowScrollIndex(InputSlots.getOverflowScrollIndex() - 1);
    end);
    ImageButton.Destroying:Connect(function() -- Line: 261
        -- upvalues: u39 (copy)
        for _, v in u39 do
            v:Disconnect();
        end;

        table.clear(u39);
    end);

    return ImageButton;
end;

function u9.Create(u40) -- Line: 271
    -- upvalues: u1 (copy), InputSlots (copy), u3 (copy), UserFlag (copy), UserFlag2 (copy), u4 (copy), u5 (copy), Players (copy), u6 (copy), u7 (copy)
    if not u40.parentUIFrame then
        return;
    end;

    local function CreateButtons() -- Line: 276
        -- upvalues: u40 (copy), u1 (ref), InputSlots (ref), u3 (ref), UserFlag (ref), UserFlag2 (ref), u4 (ref), u5 (ref), Players (ref), u6 (ref), u7 (ref)
        for _, v in u40.managedButtons do
            v:Destroy();
        end;

        u40.managedButtons = {};

        if u1:isEnabled() then
            local SlotMap = InputSlots.GetSlotMap();

            for i, v in pairs(SlotMap) do
                local ActionInSlot = InputSlots.GetActionInSlot(i);

                if v and (ActionInSlot and (i <= #u3 and (UserFlag or i == 1))) then
                    local AbilityConfig = u1:GetAbilityConfig(v);
                    table.insert(u40.managedButtons, u40:CreateAbilityButton(v, AbilityConfig, ActionInSlot, u3[i], false));
                end;
            end;

            if UserFlag and UserFlag2 then
                local AbilitiesInOverflow = InputSlots.GetAbilitiesInOverflow();
                local v41, v42;

                if #AbilitiesInOverflow > InputSlots.GetNumOverflowSlots() then
                    if InputSlots.getOverflowScrollIndex() > 0 then
                        table.insert(u40.managedButtons, u40:CreateOverflowScrollButton(false));
                    end;

                    if InputSlots.getOverflowScrollIndex() < #AbilitiesInOverflow - InputSlots.GetNumOverflowSlots() then
                        table.insert(u40.managedButtons, u40:CreateOverflowScrollButton(true));
                    end;

                    v41 = u4[1] + 8;
                    v42 = u5[1] + 10;
                else
                    v41 = 0;
                    v42 = 0;
                end;

                for i = 1, math.min(#AbilitiesInOverflow, InputSlots.GetNumOverflowSlots()) do
                    local v43 = AbilitiesInOverflow[i + InputSlots.getOverflowScrollIndex()];
                    local OverflowAction = InputSlots.GetOverflowAction(i);
                    local v44;

                    if v43 and OverflowAction then
                        local AbilityConfig = u1:GetAbilityConfig(v43);
                        local v45 = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui");
                        local v46;

                        if v45 then
                            v46 = v45.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait;
                        else
                            v46 = false;
                        end;

                        local v47;

                        if v46 then
                            v47 = {
                                small = { 44, u6[1], u6[2] + v41 + (i - 1) * 52 },
                                large = { 56, u7[1], u7[2] + v42 + (i - 1) * 66 }
                            };
                        else
                            v47 = {
                                small = { 44, u6[1] + v41 + (i - 1) * 52, u6[2] },
                                large = { 56, u7[1] + v42 + (i - 1) * 66, u7[2] }
                            };
                        end;

                        table.insert(u40.managedButtons, u40:CreateAbilityButton(v43, AbilityConfig, OverflowAction, v47, true));
                        v44 = i;
                    else
                        v44 = i;
                    end;
                end;
            end;
        end;
    end;

    CreateButtons();
    InputSlots.GetSlotMapChangedSignal():Connect(CreateButtons);
    u1:GetEnabledChangedSignal():Connect(CreateButtons);
    InputSlots.getScrollIndexChangedEvent():Connect(CreateButtons);
    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui", 5);

    if PlayerGui then
        PlayerGui:GetPropertyChangedSignal("CurrentScreenOrientation"):Connect(CreateButtons);
    end;
end;

return u9;
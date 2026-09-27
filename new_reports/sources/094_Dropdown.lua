-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");
local Themes = require(script.Parent.Parent.Features.Themes);

return function(u1) -- Line: 5
    -- upvalues: Themes (copy), TweenService (copy), RunService (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "Dropdown";
    Frame.AutomaticSize = Enum.AutomaticSize.X;
    Frame.BackgroundTransparency = 1;
    Frame.BorderSizePixel = 0;
    Frame.AnchorPoint = Vector2.new(0.5, 0);
    Frame.Position = UDim2.new(0.5, 0, 1, 10);
    Frame.ZIndex = -2;
    Frame.ClipsDescendants = true;
    Frame.Parent = u1.widget;
    local GuiService = game:GetService("GuiService");
    u1:setBehaviour("Dropdown", "BackgroundTransparency", function(p2) -- Line: 20
        -- upvalues: GuiService (copy)
        if p2 == 1 then
            return p2;
        end;

        return p2 * GuiService.PreferredTransparency;
    end);
    u1.janitor:add(GuiService:GetPropertyChangedSignal("PreferredTransparency"):Connect(function() -- Line: 28
        -- upvalues: u1 (copy), Frame (copy)
        u1:refreshAppearance(Frame, "BackgroundTransparency");
    end));
    local UICorner = Instance.new("UICorner");
    UICorner.Name = "DropdownCorner";
    UICorner.CornerRadius = UDim.new(0, 10);
    UICorner.Parent = Frame;
    local ScrollingFrame = Instance.new("ScrollingFrame");
    ScrollingFrame.Name = "DropdownScroller";
    ScrollingFrame.AutomaticSize = Enum.AutomaticSize.X;
    ScrollingFrame.BackgroundTransparency = 1;
    ScrollingFrame.BorderSizePixel = 0;
    ScrollingFrame.AnchorPoint = Vector2.new(0, 0);
    ScrollingFrame.Position = UDim2.new(0, 0, 0, 0);
    ScrollingFrame.ZIndex = -1;
    ScrollingFrame.ClipsDescendants = true;
    ScrollingFrame.Visible = true;
    ScrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.None;
    ScrollingFrame.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right;
    ScrollingFrame.Active = false;
    ScrollingFrame.ScrollingEnabled = true;
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;
    ScrollingFrame.ScrollBarThickness = 5;
    ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255);
    ScrollingFrame.ScrollBarImageTransparency = 0.8;
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0);
    ScrollingFrame.Selectable = false;
    ScrollingFrame.Active = true;
    ScrollingFrame.Parent = Frame;
    local NumberValue = Instance.new("NumberValue");
    NumberValue.Name = "DropdownSpeed";
    NumberValue.Value = 0.07;
    NumberValue.Parent = Frame;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.Name = "DropdownPadding";
    UIPadding.PaddingTop = UDim.new(0, 0);
    UIPadding.PaddingBottom = UDim.new(0, 0);
    UIPadding.Parent = ScrollingFrame;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "DropdownList";
    UIListLayout.FillDirection = Enum.FillDirection.Vertical;
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    UIListLayout.HorizontalFlex = Enum.UIFlexAlignment.SpaceEvenly;
    UIListLayout.Parent = ScrollingFrame;
    local dropdownJanitor = u1.dropdownJanitor;
    local iconModule = require(u1.iconModule);
    u1.dropdownChildAdded:Connect(function(u3) -- Line: 81
        local _, u4 = u3:modifyTheme({
            { "Widget", "BorderSize", 0 },
            { "IconCorners", "CornerRadius", UDim.new(0, 10) },
            { "Widget", "MinimumWidth", 190 },
            { "Widget", "MinimumHeight", 58 },
            { "IconLabel", "TextSize", 20 },
            { "IconOverlay", "Size", UDim2.new(1, 0, 1, 0) },
            { "PaddingLeft", "Size", UDim2.fromOffset(25, 0) },
            { "Notice", "Position", UDim2.new(1, -24, 0, 5) },
            { "ContentsList", "HorizontalAlignment", Enum.HorizontalAlignment.Left },
            { "Selection", "Size", UDim2.new(1, -0, 1, -0) },
            { "Selection", "Position", UDim2.new(0, 0, 0, 0) }
        });
        task.defer(function() -- Line: 95
            -- upvalues: u3 (copy), u4 (copy)
            u3.joinJanitor:add(function() -- Line: 96
                -- upvalues: u3 (ref), u4 (ref)
                u3:removeModification(u4);
            end);
        end);
    end);
    u1.dropdownSet:Connect(function(p5) -- Line: 101
        -- upvalues: u1 (copy), iconModule (copy)
        for _, v in pairs(u1.dropdownIcons) do
            iconModule.getIconByUID(v):destroy();
        end;

        if type(p5) == "table" then
            for _, v in pairs(p5) do
                v:joinDropdown(u1);
            end;
        end;
    end);

    local function updateMaxIcons() -- Line: 113
        -- upvalues: Frame (copy), ScrollingFrame (copy), UIPadding (copy)
        local Attribute = Frame:GetAttribute("MaxIcons");

        if not Attribute then
            return 0;
        end;

        local v6 = {};

        for _, child in pairs(ScrollingFrame:GetChildren()) do
            if child:IsA("GuiObject") and child.Visible then
                table.insert(v6, child);
            end;
        end;

        table.sort(v6, function(p7, p8) -- Line: 124
            return p7.AbsolutePosition.Y < p8.AbsolutePosition.Y;
        end);
        local math_ceil_ret = math.ceil(Attribute);
        local v9 = 0;

        for i = 1, math_ceil_ret do
            local v10 = v6[i];

            if not v10 then
                break;
            end;

            local Y = v10.AbsoluteSize.Y;
            local v11;

            if i == math_ceil_ret then
                v11 = math_ceil_ret ~= Attribute;
            else
                v11 = false;
            end;

            if v11 then
                Y = Y * (Attribute - math_ceil_ret + 1);
            end;

            v9 = v9 + Y;
            local _ = i;
        end;

        return v9 + (UIPadding.PaddingTop.Offset + UIPadding.PaddingBottom.Offset);
    end;

    local u12 = nil;
    local u13 = nil;
    local u14 = nil;
    local u15 = nil;

    local function getTweenInfo() -- Line: 145
        -- upvalues: Themes (ref), Frame (copy), u14 (ref), u15 (ref), NumberValue (copy)
        local v16 = Themes.getInstanceValue(Frame, "MaxIcons") or 1;

        if u14 and (u14 == v16 and u15) then
            return u15;
        end;

        local TweenInfo_new_ret = TweenInfo.new(NumberValue.Value * v16, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out);
        u15 = TweenInfo_new_ret;
        u14 = v16;

        return TweenInfo_new_ret;
    end;

    local function updateVisibility() -- Line: 159
        -- upvalues: Themes (ref), Frame (copy), u14 (ref), u15 (ref), NumberValue (copy), u12 (ref), u13 (ref), u1 (copy), updateMaxIcons (copy), TweenService (ref)
        local v17 = Themes.getInstanceValue(Frame, "MaxIcons") or 1;
        local v18;

        if u14 and (u14 == v17 and u15) then
            v18 = u15;
        else
            v18 = TweenInfo.new(NumberValue.Value * v17, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out);
            u15 = v18;
            u14 = v17;
        end;

        if u12 then
            u12:Cancel();
            u12 = nil;
        end;

        if u13 then
            u13:Cancel();
            u13 = nil;
        end;

        if not u1.isSelected then
            u13 = TweenService:Create(Frame, TweenInfo.new(0), {
                Size = UDim2.new(0, Frame.Size.X.Offset, 0, 0)
            });
            u13:Play();
            u13.Completed:Connect(function() -- Line: 187
                -- upvalues: u13 (ref)
                u13 = nil;
            end);

            return;
        end;

        local v19 = updateMaxIcons();
        Frame.Visible = true;
        Frame.BackgroundTransparency = 0;
        Frame.Size = UDim2.new(0, Frame.Size.X.Offset, 0, 0);
        u12 = TweenService:Create(Frame, v18, {
            Size = UDim2.new(0, Frame.Size.X.Offset, 0, v19)
        });
        u12:Play();
        u12.Completed:Connect(function() -- Line: 180
            -- upvalues: u12 (ref)
            u12 = nil;
        end);
    end;

    dropdownJanitor:add(u1.toggled:Connect(updateVisibility));
    updateVisibility();

    local function updateChildSize() -- Line: 197
        -- upvalues: Themes (ref), Frame (copy), u14 (ref), u15 (ref), NumberValue (copy), u1 (copy), u12 (ref), u13 (ref), RunService (ref), updateMaxIcons (copy), TweenService (ref)
        local v20 = Themes.getInstanceValue(Frame, "MaxIcons") or 1;
        local v21;

        if u14 and (u14 == v20 and u15) then
            v21 = u15;
        else
            v21 = TweenInfo.new(NumberValue.Value * v20, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out);
            u15 = v21;
            u14 = v20;
        end;

        if not u1.isSelected then
            return;
        end;

        if u12 then
            u12:Cancel();
            u12 = nil;
        end;

        if u13 then
            u13:Cancel();
            u13 = nil;
        end;

        RunService.Heartbeat:Wait();
        local v22 = updateMaxIcons();
        u12 = TweenService:Create(Frame, v21, {
            Size = UDim2.new(0, Frame.Size.X.Offset, 0, v22)
        });
        u12:Play();
        u12.Completed:Connect(function() -- Line: 215
            -- upvalues: u12 (ref)
            u12 = nil;
        end);
    end;

    dropdownJanitor:add(u1.toggled:Connect(updateVisibility));
    local u23 = 0;
    local u24 = false;

    local function updateMaxIconsListener() -- Line: 228
        -- upvalues: u23 (ref), u24 (ref), updateMaxIconsListener (copy), Frame (copy), ScrollingFrame (copy), iconModule (copy), u1 (copy), UIPadding (copy)
        u23 = u23 + 1;

        if u24 then
            return;
        end;

        local u25 = u23;
        u24 = true;
        task.defer(function() -- Line: 233
            -- upvalues: u24 (ref), u23 (ref), u25 (copy), updateMaxIconsListener (ref)
            u24 = false;

            if u23 ~= u25 then
                updateMaxIconsListener();
            end;
        end);
        local Attribute = Frame:GetAttribute("MaxIcons");

        if not Attribute then
            return;
        end;

        local v26 = {};

        for _, child in pairs(ScrollingFrame:GetChildren()) do
            if child:IsA("GuiObject") and child.Visible then
                table.insert(v26, { child, child.AbsolutePosition.Y });
            end;
        end;

        table.sort(v26, function(p27, p28) -- Line: 248
            return p27[2] < p28[2];
        end);
        local math_ceil_ret = math.ceil(Attribute);
        local v29 = 0;
        local v30 = false;

        for i = 1, math_ceil_ret do
            local v31 = v26[i];

            if not v31 then
                break;
            end;

            local v32 = v31[1];
            local Y = v32.AbsoluteSize.Y;
            local v33;

            if i == math_ceil_ret then
                v33 = math_ceil_ret ~= Attribute;
            else
                v33 = false;
            end;

            if v33 then
                Y = Y * (Attribute - math_ceil_ret + 1);
            end;

            v29 = v29 + Y;
            local v34;

            if v33 then
                v34 = i;
            else
                local Attribute2 = v32:GetAttribute("WidgetUID");

                if Attribute2 then
                    Attribute2 = iconModule.getIconByUID(Attribute2);
                end;

                if Attribute2 then
                    local v35;

                    if v30 then
                        v35 = nil;
                    else
                        v35 = u1:getInstance("ClickRegion");
                        v30 = true;
                    end;

                    Attribute2:getInstance("ClickRegion").NextSelectionUp = v35;
                    v34 = i;
                else
                    v34 = i;
                end;
            end;
        end;

        ScrollingFrame.Size = UDim2.fromOffset(0, v29 + (UIPadding.PaddingTop.Offset + UIPadding.PaddingBottom.Offset));
    end;

    dropdownJanitor:add(ScrollingFrame:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(updateMaxIconsListener));
    dropdownJanitor:add(ScrollingFrame.ChildAdded:Connect(updateMaxIconsListener));
    dropdownJanitor:add(ScrollingFrame.ChildRemoved:Connect(updateChildSize));
    dropdownJanitor:add(ScrollingFrame.ChildRemoved:Connect(updateMaxIconsListener));
    dropdownJanitor:add(Frame:GetAttributeChangedSignal("MaxIcons"):Connect(updateMaxIconsListener));
    dropdownJanitor:add(Frame:GetAttributeChangedSignal("MaxIcons"):Connect(updateChildSize));
    dropdownJanitor:add(u1.childThemeModified:Connect(updateMaxIconsListener));
    updateMaxIconsListener();

    local function connectVisibilityListeners(p36) -- Line: 293
        -- upvalues: updateChildSize (copy)
        if p36:IsA("GuiObject") then
            p36:GetPropertyChangedSignal("Visible"):Connect(updateChildSize);
            p36:GetPropertyChangedSignal("Size"):Connect(updateChildSize);
        end;
    end;

    for _, child in pairs(ScrollingFrame:GetChildren()) do
        if child:IsA("GuiObject") then
            child:GetPropertyChangedSignal("Visible"):Connect(updateChildSize);
            child:GetPropertyChangedSignal("Size"):Connect(updateChildSize);
        end;
    end;

    ScrollingFrame.ChildAdded:Connect(function(p37) -- Line: 305
        -- upvalues: RunService (ref), updateChildSize (copy)
        RunService.Heartbeat:Wait();

        if p37:IsA("GuiObject") then
            p37:GetPropertyChangedSignal("Visible"):Connect(updateChildSize);
            p37:GetPropertyChangedSignal("Size"):Connect(updateChildSize);
        end;

        updateChildSize();
    end);
    Frame.Visible = false;

    return Frame;
end;
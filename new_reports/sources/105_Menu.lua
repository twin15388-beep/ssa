-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);

return function(u1, u2) -- Line: 3
    local u3 = false;
    local u4 = nil;
    local u5 = {};

    local function EmptyMenuStack(p6: number?) -- Line: 8
        -- upvalues: u5 (copy), u1 (copy), u3 (ref), u4 (ref)
        for i = #u5, p6 and p6 + 1 or 1, -1 do
            local v7 = u5[i];
            v7.state.isOpened:set(false);
            v7.Instance.BackgroundColor3 = u1._config.HeaderColor;
            v7.Instance.BackgroundTransparency = 1;
            table.remove(u5, i);
            local _ = i;
        end;

        if #u5 == 0 then
            u3 = false;
            u4 = nil;
        end;
    end;

    local function UpdateChildContainerTransform(p8) -- Line: 25
        -- upvalues: u1 (copy)
        local v9 = p8.parentWidget.type == "Menu";
        local Instance2 = p8.Instance;
        local ChildContainer = p8.ChildContainer;
        ChildContainer.Size = UDim2.fromOffset(math.max(ChildContainer.AbsoluteSize.X, Instance2.AbsoluteSize.X), (math.max(ChildContainer.AbsoluteSize.Y, Instance2.AbsoluteSize.Y)));

        if ChildContainer.Parent == nil then
            return;
        end;

        local AbsolutePosition = Instance2.AbsolutePosition;
        local AbsoluteSize = Instance2.AbsoluteSize;
        local AbsoluteSize2 = ChildContainer.AbsoluteSize;
        local PopupBorderSize = u1._config.PopupBorderSize;
        local AbsoluteSize3 = ChildContainer.Parent.AbsoluteSize;
        local v10 = AbsolutePosition.X + PopupBorderSize;

        if p8.parentWidget.type == "Menu" then
            if AbsolutePosition.X + AbsoluteSize2.X > AbsoluteSize3.X then
                v10 = AbsolutePosition.X - PopupBorderSize - (v9 and (AbsoluteSize2.X or 0) or 0);
            else
                v10 = AbsolutePosition.X + PopupBorderSize + (v9 and (AbsoluteSize.X or 0) or 0);
            end;
        end;

        local v11;

        if AbsolutePosition.Y + AbsoluteSize2.Y > AbsoluteSize3.Y then
            v11 = AbsolutePosition.Y - PopupBorderSize - AbsoluteSize2.Y + (v9 and AbsoluteSize.Y or 0);
        else
            v11 = AbsolutePosition.Y + PopupBorderSize + (v9 and 0 or AbsoluteSize.Y);
        end;

        ChildContainer.Position = UDim2.fromOffset(v10, v11);
    end;

    u2.UserInputService.InputBegan:Connect(function(p12: userdata) -- Line: 62
        -- upvalues: u3 (ref), u4 (ref), u2 (copy), u5 (copy), EmptyMenuStack (copy)
        if p12.UserInputType ~= Enum.UserInputType.MouseButton1 and p12.UserInputType ~= Enum.UserInputType.MouseButton2 then
            return;
        end;

        if u3 == false then
            return;
        end;

        if u4 == nil then
            return;
        end;

        local MouseLocation = u2.getMouseLocation();
        local v13 = false;

        for _, v in u5 do
            for _, v2 in { v.ChildContainer, v.Instance } do
                local AbsolutePosition = v2.AbsolutePosition;

                if u2.isPosInsideRect(MouseLocation, AbsolutePosition, AbsolutePosition + v2.AbsoluteSize) then
                    v13 = true;
                    break;
                end;
            end;
        end;

        if not v13 then
            EmptyMenuStack();
        end;
    end);
    u1.WidgetConstructor("MenuBar", {
        hasState = false,
        hasChildren = true,
        Args = {},
        Events = {},

        Generate = function(p14) -- Line: 97, Name: Generate
            -- upvalues: u1 (copy), u2 (copy)
            local Frame = Instance.new("Frame");
            Frame.Name = "MenuBar";
            Frame.Size = UDim2.fromScale(1, 0);
            Frame.AutomaticSize = Enum.AutomaticSize.Y;
            Frame.BackgroundColor3 = u1._config.MenubarBgColor;
            Frame.BackgroundTransparency = u1._config.MenubarBgTransparency;
            Frame.BorderSizePixel = 0;
            Frame.ZIndex = p14.ZIndex;
            Frame.LayoutOrder = p14.ZIndex;
            Frame.ClipsDescendants = true;
            u2.UIPadding(Frame, Vector2.new(u1._config.ItemSpacing.X, 2));
            u2.UIListLayout(Frame, Enum.FillDirection.Horizontal, UDim.new()).VerticalAlignment = Enum.VerticalAlignment.Center;

            return Frame;
        end,

        Update = function(p15) -- Line: 114, Name: Update
            -- upvalues: u1 (copy)
            local parentWidget = p15.parentWidget;

            if parentWidget.type ~= "Window" then
                if parentWidget.type == "Root" then
                    return;
                end;

                error("The MenuBar was not created directly under a window or root.");

                return;
            end;

            local v16 = parentWidget.Instance and parentWidget.Instance:FindFirstChild("WindowButton");

            if v16 then
                p15.Instance.Parent = v16;
                local u17 = #u1._postCycleCallbacks + 1;
                local u18 = u1._cycleTick + 1;

                u1._postCycleCallbacks[u17] = function() -- Line: 125
                    -- upvalues: u1 (ref), u18 (copy), parentWidget (copy), u17 (copy)
                    if u1._cycleTick == u18 then
                        u1._widgets.Window.Update(parentWidget);
                        u1._postCycleCallbacks[u17] = nil;
                    end;
                end;
            end;
        end,

        ChildAdded = function(p19) -- Line: 139, Name: ChildAdded
            return p19.Instance;
        end,

        Discard = function(p20) -- Line: 142, Name: Discard
            -- upvalues: u1 (copy)
            local parentWidget = p20.parentWidget;
            p20.Instance:Destroy();
            u1._widgets.Window.Update(parentWidget);
        end
    });
    u1.WidgetConstructor("Menu", {
        hasState = true,
        hasChildren = true,
        Args = {
            Text = 1
        },
        Events = {
            clicked = u2.EVENTS.click(function(p21) -- Line: 157
                return p21.Instance;
            end),
            hovered = u2.EVENTS.hover(function(p22) -- Line: 160
                return p22.Instance;
            end),
            opened = {
                Init = function(p23) -- Line: 164
                end,

                Get = function(p24) -- Line: 165
                    -- upvalues: u1 (copy)
                    return p24.lastOpenedTick == u1._cycleTick;
                end
            },
            closed = {
                Init = function(p25) -- Line: 170
                end,

                Get = function(p26) -- Line: 171
                    -- upvalues: u1 (copy)
                    return p26.lastClosedTick == u1._cycleTick;
                end
            }
        },

        Generate = function(u27) -- Line: 176, Name: Generate
            -- upvalues: u1 (copy), u2 (copy), u5 (copy), u3 (ref), u4 (ref), EmptyMenuStack (copy)
            u27.ButtonColors = {
                ButtonTransparency = 1,
                ButtonColor = u1._config.HeaderColor,
                ButtonHoveredColor = u1._config.HeaderHoveredColor,
                ButtonHoveredTransparency = u1._config.HeaderHoveredTransparency,
                ButtonActiveColor = u1._config.HeaderHoveredColor,
                ButtonActiveTransparency = u1._config.HeaderHoveredTransparency
            };
            local v28;

            if u27.parentWidget.type == "Menu" then
                v28 = Instance.new("TextButton");
                v28.Name = "Menu";
                v28.BackgroundColor3 = u1._config.HeaderColor;
                v28.BackgroundTransparency = 1;
                v28.BorderSizePixel = 0;
                v28.Size = UDim2.fromScale(1, 0);
                v28.Text = "";
                v28.AutomaticSize = Enum.AutomaticSize.Y;
                v28.ZIndex = u27.ZIndex;
                v28.LayoutOrder = u27.ZIndex;
                v28.AutoButtonColor = false;
                local v29 = u2.UIPadding(v28, u1._config.FramePadding);
                v29.PaddingTop = v29.PaddingTop - UDim.new(0, 1);
                u2.UIListLayout(v28, Enum.FillDirection.Horizontal, UDim.new(0, u1._config.ItemInnerSpacing.X)).VerticalAlignment = Enum.VerticalAlignment.Center;
                local TextLabel = Instance.new("TextLabel");
                TextLabel.Name = "TextLabel";
                TextLabel.AnchorPoint = Vector2.new(0, 0);
                TextLabel.BackgroundTransparency = 1;
                TextLabel.BorderSizePixel = 0;
                TextLabel.ZIndex = u27.ZIndex + 2;
                TextLabel.LayoutOrder = u27.ZIndex + 2;
                TextLabel.AutomaticSize = Enum.AutomaticSize.XY;
                u2.applyTextStyle(TextLabel);
                TextLabel.Parent = v28;
                local v30 = u1._config.TextSize + 2 * u1._config.FramePadding.Y;
                local v31 = v30 - math.round(v30 * 0.2) * 2;
                local ImageLabel = Instance.new("ImageLabel");
                ImageLabel.Name = "Icon";
                ImageLabel.Size = UDim2.fromOffset(v31, v31);
                ImageLabel.BackgroundTransparency = 1;
                ImageLabel.BorderSizePixel = 0;
                ImageLabel.ImageColor3 = u1._config.TextColor;
                ImageLabel.ImageTransparency = u1._config.TextTransparency;
                ImageLabel.Image = u2.ICONS.RIGHT_POINTING_TRIANGLE;
                ImageLabel.ZIndex = u27.ZIndex + 3;
                ImageLabel.LayoutOrder = u27.ZIndex + 3;
                ImageLabel.Parent = v28;
            else
                v28 = Instance.new("TextButton");
                v28.Name = "Menu";
                v28.Size = UDim2.fromScale(0, 0);
                v28.AutomaticSize = Enum.AutomaticSize.XY;
                v28.BackgroundColor3 = u1._config.HeaderColor;
                v28.BackgroundTransparency = 1;
                v28.BorderSizePixel = 0;
                v28.Text = "";
                v28.LayoutOrder = u27.ZIndex;
                v28.ZIndex = u27.ZIndex;
                v28.AutoButtonColor = false;
                v28.ClipsDescendants = true;
                u2.applyTextStyle(v28);
                u2.UIPadding(v28, Vector2.new(u1._config.ItemSpacing.X, u1._config.FramePadding.Y));
            end;

            u2.applyInteractionHighlights(v28, v28, u27.ButtonColors);
            v28.MouseButton1Click:Connect(function() -- Line: 252
                -- upvalues: u5 (ref), u27 (copy), u3 (ref), u4 (ref)
                local v32 = #u5 > 1 and true or not u27.state.isOpened.value;
                u27.state.isOpened:set(v32);
                u3 = v32;
                u4 = v32 and u27 or nil;

                if #u5 <= 1 then
                    if v32 then
                        table.insert(u5, u27);

                        return;
                    end;

                    table.remove(u5);
                end;
            end);
            v28.MouseEnter:Connect(function() -- Line: 267
                -- upvalues: u3 (ref), u4 (ref), u27 (copy), u5 (ref), EmptyMenuStack (ref)
                if u3 and (u4 and u4 ~= u27) then
                    EmptyMenuStack((table.find(u5, u27.parentWidget)));
                    u27.state.isOpened:set(true);
                    u4 = u27;
                    u3 = true;
                    table.insert(u5, u27);
                end;
            end);
            local ScrollingFrame = Instance.new("ScrollingFrame");
            ScrollingFrame.Name = "ChildContainer";
            ScrollingFrame.BackgroundColor3 = u1._config.WindowBgColor;
            ScrollingFrame.BackgroundTransparency = u1._config.WindowBgTransparency;
            ScrollingFrame.BorderSizePixel = 0;
            ScrollingFrame.Size = UDim2.fromOffset(0, 0);
            ScrollingFrame.AutomaticSize = Enum.AutomaticSize.XY;
            ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;
            ScrollingFrame.ScrollBarImageTransparency = u1._config.ScrollbarGrabTransparency;
            ScrollingFrame.ScrollBarImageColor3 = u1._config.ScrollbarGrabColor;
            ScrollingFrame.ScrollBarThickness = u1._config.ScrollbarSize;
            ScrollingFrame.CanvasSize = UDim2.fromScale(0, 0);
            ScrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar;
            ScrollingFrame.ZIndex = u27.ZIndex + 6;
            ScrollingFrame.LayoutOrder = u27.ZIndex + 6;
            ScrollingFrame.ClipsDescendants = true;
            u2.UIListLayout(ScrollingFrame, Enum.FillDirection.Vertical, UDim.new(0, 1)).VerticalAlignment = Enum.VerticalAlignment.Top;
            local v33 = u1._rootInstance and u1._rootInstance:FindFirstChild("PopupScreenGui");
            ScrollingFrame.Parent = v33;
            u27.ChildContainer = ScrollingFrame;
            u2.UIStroke(ScrollingFrame, u1._config.WindowBorderSize, u1._config.BorderColor, u1._config.BorderTransparency);
            u2.UIPadding(ScrollingFrame, Vector2.new(2, u1._config.WindowPadding.Y - u1._config.ItemSpacing.Y));

            return v28;
        end,

        Update = function(p34) -- Line: 316, Name: Update
            local Instance2 = p34.Instance;

            if p34.parentWidget.type == "Menu" then
                Instance2 = Instance2.TextLabel;
            end;

            Instance2.Text = p34.arguments.Text or "Menu";
        end,

        ChildAdded = function(p35, p36) -- Line: 326, Name: ChildAdded
            -- upvalues: UpdateChildContainerTransform (copy)
            UpdateChildContainerTransform(p35);

            return p35.ChildContainer;
        end,

        ChildDiscarded = function(p37, p38) -- Line: 330, Name: ChildDiscarded
            -- upvalues: UpdateChildContainerTransform (copy)
            UpdateChildContainerTransform(p37);
        end,

        GenerateState = function(p39) -- Line: 333, Name: GenerateState
            -- upvalues: u1 (copy)
            if p39.state.isOpened == nil then
                p39.state.isOpened = u1._widgetState(p39, "isOpened", false);
            end;
        end,

        UpdateState = function(p40) -- Line: 338, Name: UpdateState
            -- upvalues: u1 (copy), UpdateChildContainerTransform (copy)
            local ChildContainer = p40.ChildContainer;

            if not p40.state.isOpened.value then
                p40.lastClosedTick = u1._cycleTick + 1;
                p40.ButtonColors.ButtonTransparency = 1;
                ChildContainer.Visible = false;

                return;
            end;

            p40.lastOpenedTick = u1._cycleTick + 1;
            p40.ButtonColors.ButtonTransparency = u1._config.HeaderTransparency;
            ChildContainer.Visible = true;
            UpdateChildContainerTransform(p40);
        end,

        Discard = function(p41) -- Line: 353, Name: Discard
            -- upvalues: u2 (copy)
            p41.Instance:Destroy();
            u2.discardState(p41);
        end
    });
    u1.WidgetConstructor("MenuItem", {
        hasState = false,
        hasChildren = false,
        Args = {
            Text = 1,
            KeyCode = 2,
            ModifierKey = 3
        },
        Events = {
            clicked = u2.EVENTS.click(function(p42) -- Line: 368
                return p42.Instance;
            end),
            hovered = u2.EVENTS.hover(function(p43) -- Line: 371
                return p43.Instance;
            end)
        },

        Generate = function(u44) -- Line: 375, Name: Generate
            -- upvalues: u2 (copy), u1 (copy), EmptyMenuStack (copy), u3 (ref), u4 (ref), u5 (copy)
            local TextButton = Instance.new("TextButton");
            TextButton.Name = "MenuItem";
            TextButton.BackgroundTransparency = 1;
            TextButton.BorderSizePixel = 0;
            TextButton.Size = UDim2.fromScale(1, 0);
            TextButton.Text = "";
            TextButton.AutomaticSize = Enum.AutomaticSize.Y;
            TextButton.ZIndex = u44.ZIndex;
            TextButton.LayoutOrder = u44.ZIndex;
            TextButton.AutoButtonColor = false;
            local v45 = u2.UIPadding(TextButton, u1._config.FramePadding);
            v45.PaddingTop = v45.PaddingTop - UDim.new(0, 1);
            u2.UIListLayout(TextButton, Enum.FillDirection.Horizontal, UDim.new(0, u1._config.ItemInnerSpacing.X));
            u2.applyInteractionHighlights(TextButton, TextButton, {
                ButtonTransparency = 1,
                ButtonColor = u1._config.HeaderColor,
                ButtonHoveredColor = u1._config.HeaderHoveredColor,
                ButtonHoveredTransparency = u1._config.HeaderHoveredTransparency,
                ButtonActiveColor = u1._config.HeaderHoveredColor,
                ButtonActiveTransparency = u1._config.HeaderHoveredTransparency
            });
            TextButton.MouseButton1Click:Connect(function() -- Line: 400
                -- upvalues: EmptyMenuStack (ref)
                EmptyMenuStack();
            end);
            TextButton.MouseEnter:Connect(function() -- Line: 404
                -- upvalues: u44 (copy), u3 (ref), u4 (ref), u5 (ref), EmptyMenuStack (ref)
                local parentWidget = u44.parentWidget;

                if u3 and (u4 and u4 ~= parentWidget) then
                    EmptyMenuStack((table.find(u5, parentWidget)));
                    u4 = parentWidget;
                    u3 = true;
                end;
            end);
            local TextLabel = Instance.new("TextLabel");
            TextLabel.Name = "TextLabel";
            TextLabel.AnchorPoint = Vector2.new(0, 0);
            TextLabel.BackgroundTransparency = 1;
            TextLabel.BorderSizePixel = 0;
            TextLabel.ZIndex = u44.ZIndex + 2;
            TextLabel.LayoutOrder = u44.ZIndex + 2;
            TextLabel.AutomaticSize = Enum.AutomaticSize.XY;
            u2.applyTextStyle(TextLabel);
            TextLabel.Parent = TextButton;
            local TextLabel2 = Instance.new("TextLabel");
            TextLabel2.Name = "Shortcut";
            TextLabel2.AnchorPoint = Vector2.new(0, 0);
            TextLabel2.BackgroundTransparency = 1;
            TextLabel2.BorderSizePixel = 0;
            TextLabel2.ZIndex = u44.ZIndex + 3;
            TextLabel2.LayoutOrder = u44.ZIndex + 3;
            TextLabel2.AutomaticSize = Enum.AutomaticSize.XY;
            u2.applyTextStyle(TextLabel2);
            TextLabel2.Text = "";
            TextLabel2.TextColor3 = u1._config.TextDisabledColor;
            TextLabel2.TextTransparency = u1._config.TextDisabledTransparency;
            TextLabel2.Parent = TextButton;

            return TextButton;
        end,

        Update = function(p46) -- Line: 447, Name: Update
            local Instance2 = p46.Instance;
            local Shortcut = Instance2.Shortcut;
            Instance2.TextLabel.Text = p46.arguments.Text;

            if p46.arguments.KeyCode then
                Shortcut.Text = p46.arguments.ModifierKey.Name .. " + " .. p46.arguments.KeyCode.Name;
            end;
        end,

        Discard = function(p47) -- Line: 457, Name: Discard
            p47.Instance:Destroy();
        end
    });
    u1.WidgetConstructor("MenuToggle", {
        hasState = true,
        hasChildren = false,
        Args = {
            Text = 1,
            KeyCode = 2,
            ModifierKey = 3
        },
        Events = {
            checked = {
                Init = function(p48) -- Line: 472
                end,

                Get = function(p49) -- Line: 473
                    -- upvalues: u1 (copy)
                    return p49.lastCheckedTick == u1._cycleTick;
                end
            },
            unchecked = {
                Init = function(p50) -- Line: 478
                end,

                Get = function(p51) -- Line: 479
                    -- upvalues: u1 (copy)
                    return p51.lastUncheckedTick == u1._cycleTick;
                end
            },
            hovered = u2.EVENTS.hover(function(p52) -- Line: 483
                return p52.Instance;
            end)
        },

        Generate = function(u53) -- Line: 487, Name: Generate
            -- upvalues: u2 (copy), u1 (copy), EmptyMenuStack (copy), u3 (ref), u4 (ref), u5 (copy)
            local TextButton = Instance.new("TextButton");
            TextButton.Name = "MenuItem";
            TextButton.BackgroundTransparency = 1;
            TextButton.BorderSizePixel = 0;
            TextButton.Size = UDim2.fromScale(1, 0);
            TextButton.Text = "";
            TextButton.AutomaticSize = Enum.AutomaticSize.Y;
            TextButton.ZIndex = u53.ZIndex;
            TextButton.LayoutOrder = u53.ZIndex;
            TextButton.AutoButtonColor = false;
            local v54 = u2.UIPadding(TextButton, u1._config.FramePadding);
            v54.PaddingTop = v54.PaddingTop - UDim.new(0, 1);
            u2.UIListLayout(TextButton, Enum.FillDirection.Horizontal, UDim.new(0, u1._config.ItemInnerSpacing.X)).VerticalAlignment = Enum.VerticalAlignment.Center;
            u2.applyInteractionHighlights(TextButton, TextButton, {
                ButtonTransparency = 1,
                ButtonColor = u1._config.HeaderColor,
                ButtonHoveredColor = u1._config.HeaderHoveredColor,
                ButtonHoveredTransparency = u1._config.HeaderHoveredTransparency,
                ButtonActiveColor = u1._config.HeaderHoveredColor,
                ButtonActiveTransparency = u1._config.HeaderHoveredTransparency
            });
            TextButton.MouseButton1Click:Connect(function() -- Line: 512
                -- upvalues: u53 (copy), EmptyMenuStack (ref)
                u53.state.isChecked:set(not u53.state.isChecked.value);
                EmptyMenuStack();
            end);
            TextButton.MouseEnter:Connect(function() -- Line: 518
                -- upvalues: u53 (copy), u3 (ref), u4 (ref), u5 (ref), EmptyMenuStack (ref)
                local parentWidget = u53.parentWidget;

                if u3 and (u4 and u4 ~= parentWidget) then
                    EmptyMenuStack((table.find(u5, parentWidget)));
                    u4 = parentWidget;
                    u3 = true;
                end;
            end);
            local TextLabel = Instance.new("TextLabel");
            TextLabel.Name = "TextLabel";
            TextLabel.AnchorPoint = Vector2.new(0, 0);
            TextLabel.BackgroundTransparency = 1;
            TextLabel.BorderSizePixel = 0;
            TextLabel.ZIndex = u53.ZIndex + 2;
            TextLabel.LayoutOrder = u53.ZIndex + 2;
            TextLabel.AutomaticSize = Enum.AutomaticSize.XY;
            u2.applyTextStyle(TextLabel);
            TextLabel.Parent = TextButton;
            local TextLabel2 = Instance.new("TextLabel");
            TextLabel2.Name = "Shortcut";
            TextLabel2.AnchorPoint = Vector2.new(0, 0);
            TextLabel2.BackgroundTransparency = 1;
            TextLabel2.BorderSizePixel = 0;
            TextLabel2.ZIndex = u53.ZIndex + 3;
            TextLabel2.LayoutOrder = u53.ZIndex + 3;
            TextLabel2.AutomaticSize = Enum.AutomaticSize.XY;
            u2.applyTextStyle(TextLabel2);
            TextLabel2.Text = "";
            TextLabel2.TextColor3 = u1._config.TextDisabledColor;
            TextLabel2.TextTransparency = u1._config.TextDisabledTransparency;
            TextLabel2.Parent = TextButton;
            local v55 = u1._config.TextSize + 2 * u1._config.FramePadding.Y;
            local v56 = v55 - math.round(v55 * 0.2) * 2;
            local ImageLabel = Instance.new("ImageLabel");
            ImageLabel.Name = "Icon";
            ImageLabel.Size = UDim2.fromOffset(v56, v56);
            ImageLabel.BackgroundTransparency = 1;
            ImageLabel.BorderSizePixel = 0;
            ImageLabel.ImageColor3 = u1._config.TextColor;
            ImageLabel.ImageTransparency = u1._config.TextTransparency;
            ImageLabel.Image = u2.ICONS.CHECK_MARK;
            ImageLabel.ZIndex = u53.ZIndex + 4;
            ImageLabel.LayoutOrder = u53.ZIndex + 4;
            ImageLabel.Parent = TextButton;

            return TextButton;
        end,

        GenerateState = function(p57) -- Line: 578, Name: GenerateState
            -- upvalues: u1 (copy)
            if p57.state.isChecked == nil then
                p57.state.isChecked = u1._widgetState(p57, "isChecked", false);
            end;
        end,

        Update = function(p58) -- Line: 583, Name: Update
            local Instance2 = p58.Instance;
            local Shortcut = Instance2.Shortcut;
            Instance2.TextLabel.Text = p58.arguments.Text;

            if p58.arguments.KeyCode then
                Shortcut.Text = p58.arguments.ModifierKey.Name .. " + " .. p58.arguments.KeyCode.Name;
            end;
        end,

        UpdateState = function(p59) -- Line: 593, Name: UpdateState
            -- upvalues: u2 (copy), u1 (copy)
            local Icon = p59.Instance.Icon;

            if p59.state.isChecked.value then
                Icon.Image = u2.ICONS.CHECK_MARK;
                p59.lastCheckedTick = u1._cycleTick + 1;

                return;
            end;

            Icon.Image = "";
            p59.lastUncheckedTick = u1._cycleTick + 1;
        end,

        Discard = function(p60) -- Line: 605, Name: Discard
            -- upvalues: u2 (copy)
            p60.Instance:Destroy();
            u2.discardState(p60);
        end
    });
end;
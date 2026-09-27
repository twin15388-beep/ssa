-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);

return function(u1, u2) -- Line: 3
    local function onSelectionChange(p3) -- Line: 4
        if type(p3.state.index.value) == "boolean" then
            p3.state.index:set(not p3.state.index.value);

            return;
        end;

        p3.state.index:set(p3.arguments.Index);
    end;

    u1.WidgetConstructor("Selectable", {
        hasState = true,
        hasChildren = false,
        Args = {
            Text = 1,
            Index = 2,
            NoClick = 3
        },
        Events = {
            selected = {
                Init = function(p4) -- Line: 22
                end,

                Get = function(p5) -- Line: 23
                    -- upvalues: u1 (copy)
                    return p5.lastSelectedTick == u1._cycleTick;
                end
            },
            unselected = {
                Init = function(p6) -- Line: 28
                end,

                Get = function(p7) -- Line: 29
                    -- upvalues: u1 (copy)
                    return p7.lastUnselectedTick == u1._cycleTick;
                end
            },
            active = {
                Init = function(p8) -- Line: 34
                end,

                Get = function(p9) -- Line: 35
                    return p9.state.index.value == p9.arguments.Index;
                end
            },
            clicked = u2.EVENTS.click(function(p10) -- Line: 39
                return p10.Instance.SelectableButton;
            end),
            rightClicked = u2.EVENTS.rightClick(function(p11) -- Line: 43
                return p11.Instance.SelectableButton;
            end),
            doubleClicked = u2.EVENTS.doubleClick(function(p12) -- Line: 47
                return p12.Instance.SelectableButton;
            end),
            ctrlClicked = u2.EVENTS.ctrlClick(function(p13) -- Line: 51
                return p13.Instance.SelectableButton;
            end),
            hovered = u2.EVENTS.hover(function(p14) -- Line: 55
                return p14.Instance.SelectableButton;
            end)
        },

        Generate = function(u15) -- Line: 60, Name: Generate
            -- upvalues: u1 (copy), u2 (copy)
            local Frame = Instance.new("Frame");
            Frame.Name = "Iris_Selectable";
            Frame.Size = UDim2.new(u1._config.ItemWidth, UDim.new(0, u1._config.TextSize));
            Frame.AutomaticSize = Enum.AutomaticSize.None;
            Frame.BackgroundTransparency = 1;
            Frame.BorderSizePixel = 0;
            Frame.ZIndex = u15.ZIndex;
            Frame.LayoutOrder = u15.ZIndex;
            local TextButton = Instance.new("TextButton");
            TextButton.Name = "SelectableButton";
            TextButton.Size = UDim2.new(1, 0, 1, u1._config.ItemSpacing.Y - 1);
            TextButton.Position = UDim2.fromOffset(0, -bit32.rshift(u1._config.ItemSpacing.Y, 1));
            TextButton.BackgroundColor3 = u1._config.HeaderColor;
            TextButton.ZIndex = u15.ZIndex + 1;
            TextButton.LayoutOrder = u15.ZIndex + 1;
            u2.applyFrameStyle(TextButton);
            u2.applyTextStyle(TextButton);
            u15.ButtonColors = {
                ButtonTransparency = 1,
                ButtonColor = u1._config.HeaderColor,
                ButtonHoveredColor = u1._config.HeaderHoveredColor,
                ButtonHoveredTransparency = u1._config.HeaderHoveredTransparency,
                ButtonActiveColor = u1._config.HeaderActiveColor,
                ButtonActiveTransparency = u1._config.HeaderActiveTransparency
            };
            u2.applyInteractionHighlights(TextButton, TextButton, u15.ButtonColors);
            TextButton.MouseButton1Click:Connect(function() -- Line: 92
                -- upvalues: u15 (copy)
                if u15.arguments.NoClick ~= true then
                    local v16 = u15;

                    if type(v16.state.index.value) == "boolean" then
                        v16.state.index:set(not v16.state.index.value);

                        return;
                    end;

                    v16.state.index:set(v16.arguments.Index);
                end;
            end);
            TextButton.Parent = Frame;

            return Frame;
        end,

        Update = function(p17) -- Line: 102, Name: Update
            p17.Instance.SelectableButton.Text = p17.arguments.Text or "Selectable";
        end,

        Discard = function(p18) -- Line: 107, Name: Discard
            -- upvalues: u2 (copy)
            p18.Instance:Destroy();
            u2.discardState(p18);
        end,

        GenerateState = function(p19) -- Line: 111, Name: GenerateState
            -- upvalues: u1 (copy)
            if p19.state.index == nil then
                if p19.arguments.Index ~= nil then
                    error("a shared state index is required for Selectables with an Index argument", 5);
                end;

                p19.state.index = u1._widgetState(p19, "index", false);
            end;
        end,

        UpdateState = function(p20) -- Line: 119, Name: UpdateState
            -- upvalues: u1 (copy)
            local SelectableButton = p20.Instance.SelectableButton;

            if p20.state.index.value == (p20.arguments.Index or true) then
                p20.ButtonColors.ButtonTransparency = u1._config.HeaderTransparency;
                SelectableButton.BackgroundTransparency = u1._config.HeaderTransparency;
                p20.lastSelectedTick = u1._cycleTick + 1;

                return;
            end;

            p20.ButtonColors.ButtonTransparency = 1;
            SelectableButton.BackgroundTransparency = 1;
            p20.lastUnselectedTick = u1._cycleTick + 1;
        end
    });
    local u21 = false;
    local u22 = -1;
    local u23 = nil;

    local function UpdateChildContainerTransform(p24) -- Line: 138
        -- upvalues: u1 (copy)
        local PreviewContainer = p24.Instance.PreviewContainer;
        local PreviewLabel = PreviewContainer.PreviewLabel;
        local ChildContainer = p24.ChildContainer;
        local v25 = u1._config.TextSize + 2 * u1._config.FramePadding.Y;
        local PopupBorderSize = u1._config.PopupBorderSize;
        local v26 = v25 * math.min(p24.ComboChildrenHeight, 8) - PopupBorderSize * 2 + 3 * u1._config.FramePadding.Y;
        local UDim_new_ret = UDim.new(0, PreviewContainer.AbsoluteSize.X - PopupBorderSize * 2);
        ChildContainer.Size = UDim2.new(UDim_new_ret, UDim.new(0, v26));

        if PreviewLabel.AbsolutePosition.Y + v25 + v26 > ChildContainer.Parent.AbsoluteSize.Y then
            ChildContainer.Position = UDim2.new(0, PreviewLabel.AbsolutePosition.X + PopupBorderSize, 0, PreviewLabel.AbsolutePosition.Y - PopupBorderSize - v26);

            return;
        end;

        ChildContainer.Position = UDim2.new(0, PreviewLabel.AbsolutePosition.X + PopupBorderSize, 0, PreviewLabel.AbsolutePosition.Y + v25 + PopupBorderSize);
    end;

    u2.UserInputService.InputBegan:Connect(function(p27: userdata) -- Line: 161
        -- upvalues: u21 (ref), u22 (ref), u1 (copy), u2 (copy), u23 (ref)
        if p27.UserInputType ~= Enum.UserInputType.MouseButton1 and (p27.UserInputType ~= Enum.UserInputType.MouseButton2 and p27.UserInputType ~= Enum.UserInputType.Touch) then
            return;
        end;

        if u21 == false then
            return;
        end;

        if u22 == u1._cycleTick then
            return;
        end;

        local MouseLocation = u2.getMouseLocation();
        local ChildContainer = u23.ChildContainer;
        local v28 = ChildContainer.AbsolutePosition - Vector2.new(0, u23.LabelHeight);

        if not u2.isPosInsideRect(MouseLocation, v28, ChildContainer.AbsolutePosition + ChildContainer.AbsoluteSize) then
            u23.state.isOpened:set(false);
        end;
    end);
    u1.WidgetConstructor("Combo", {
        hasState = true,
        hasChildren = true,
        Args = {
            Text = 1,
            NoButton = 2,
            NoPreview = 3
        },
        Events = {
            opened = {
                Init = function(p29) -- Line: 190
                end,

                Get = function(p30) -- Line: 191
                    -- upvalues: u1 (copy)
                    return p30.lastOpenedTick == u1._cycleTick;
                end
            },
            closed = {
                Init = function(p31) -- Line: 196
                end,

                Get = function(p32) -- Line: 197
                    -- upvalues: u1 (copy)
                    return p32.lastClosedTick == u1._cycleTick;
                end
            },
            clicked = u2.EVENTS.click(function(p33) -- Line: 201
                return p33.Instance;
            end),
            hovered = u2.EVENTS.hover(function(p34) -- Line: 204
                return p34.Instance;
            end)
        },

        Generate = function(u35) -- Line: 208, Name: Generate
            -- upvalues: u1 (copy), u2 (copy), u21 (ref), u23 (ref)
            local v36 = u1._config.TextSize + 2 * u1._config.FramePadding.Y;
            u35.ComboChildrenHeight = 0;
            local Frame = Instance.new("Frame");
            Frame.Name = "Iris_Combo";
            Frame.Size = UDim2.fromScale(1, 0);
            Frame.AutomaticSize = Enum.AutomaticSize.Y;
            Frame.BackgroundTransparency = 1;
            Frame.BorderSizePixel = 0;
            Frame.ZIndex = u35.ZIndex;
            Frame.LayoutOrder = u35.ZIndex;
            u2.UIListLayout(Frame, Enum.FillDirection.Horizontal, UDim.new(0, u1._config.ItemInnerSpacing.Y + 1));
            local TextButton = Instance.new("TextButton");
            TextButton.Name = "PreviewContainer";
            TextButton.Size = UDim2.new(u1._config.ContentWidth, UDim.new(0, 0));
            TextButton.AutomaticSize = Enum.AutomaticSize.Y;
            TextButton.BackgroundTransparency = 1;
            TextButton.Text = "";
            TextButton.ZIndex = u35.ZIndex + 2;
            TextButton.LayoutOrder = u35.ZIndex + 2;
            TextButton.AutoButtonColor = false;
            u2.applyFrameStyle(TextButton, true, true);
            u2.UIListLayout(TextButton, Enum.FillDirection.Horizontal, UDim.new(0, 0));
            TextButton.Parent = Frame;
            local TextLabel = Instance.new("TextLabel");
            TextLabel.Name = "PreviewLabel";
            TextLabel.Size = UDim2.new(1, 0, 0, 0);
            TextLabel.AutomaticSize = Enum.AutomaticSize.Y;
            TextLabel.BackgroundColor3 = u1._config.FrameBgColor;
            TextLabel.BackgroundTransparency = u1._config.FrameBgTransparency;
            TextLabel.BorderSizePixel = 0;
            TextLabel.ZIndex = u35.ZIndex + 3;
            TextLabel.LayoutOrder = u35.ZIndex + 3;
            u2.applyTextStyle(TextLabel);
            u2.UIPadding(TextLabel, u1._config.FramePadding);
            TextLabel.Parent = TextButton;
            local TextLabel2 = Instance.new("TextLabel");
            TextLabel2.Name = "DropdownButton";
            TextLabel2.Size = UDim2.new(0, v36, 0, v36);
            TextLabel2.BorderSizePixel = 0;
            TextLabel2.BackgroundColor3 = u1._config.ButtonColor;
            TextLabel2.BackgroundTransparency = u1._config.ButtonTransparency;
            TextLabel2.Text = "";
            TextLabel2.ZIndex = u35.ZIndex + 4;
            TextLabel2.LayoutOrder = u35.ZIndex + 4;
            local math_round_ret = math.round(v36 * 0.2);
            local v37 = v36 - math_round_ret * 2;
            local ImageLabel = Instance.new("ImageLabel");
            ImageLabel.Name = "Dropdown";
            ImageLabel.Size = UDim2.fromOffset(v37, v37);
            ImageLabel.Position = UDim2.fromOffset(math_round_ret, math_round_ret);
            ImageLabel.BackgroundTransparency = 1;
            ImageLabel.BorderSizePixel = 0;
            ImageLabel.ImageColor3 = u1._config.TextColor;
            ImageLabel.ImageTransparency = u1._config.TextTransparency;
            ImageLabel.ZIndex = u35.ZIndex + 5;
            ImageLabel.LayoutOrder = u35.ZIndex + 5;
            ImageLabel.Parent = TextLabel2;
            TextLabel2.Parent = TextButton;
            u2.applyInteractionHighlightsWithMultiHighlightee(TextButton, {
                {
                    TextLabel,
                    {
                        ButtonColor = u1._config.FrameBgColor,
                        ButtonTransparency = u1._config.FrameBgTransparency,
                        ButtonHoveredColor = u1._config.FrameBgHoveredColor,
                        ButtonHoveredTransparency = u1._config.FrameBgHoveredTransparency,
                        ButtonActiveColor = u1._config.FrameBgActiveColor,
                        ButtonActiveTransparency = u1._config.FrameBgActiveTransparency
                    }
                },
                {
                    TextLabel2,
                    {
                        ButtonColor = u1._config.ButtonColor,
                        ButtonTransparency = u1._config.ButtonTransparency,
                        ButtonHoveredColor = u1._config.ButtonHoveredColor,
                        ButtonHoveredTransparency = u1._config.ButtonHoveredTransparency,
                        ButtonActiveColor = u1._config.ButtonHoveredColor,
                        ButtonActiveTransparency = u1._config.ButtonHoveredColor
                    }
                }
            });
            TextButton.InputBegan:Connect(function(p38) -- Line: 308
                -- upvalues: u21 (ref), u23 (ref), u35 (copy)
                if u21 and u23 ~= u35 then
                    return;
                end;

                if p38.UserInputType == Enum.UserInputType.MouseButton1 or p38.UserInputType == Enum.UserInputType.Touch then
                    u35.state.isOpened:set(not u35.state.isOpened.value);
                end;
            end);
            local TextLabel3 = Instance.new("TextLabel");
            TextLabel3.Name = "TextLabel";
            TextLabel3.Size = UDim2.fromOffset(0, v36);
            TextLabel3.AutomaticSize = Enum.AutomaticSize.X;
            TextLabel3.BackgroundTransparency = 1;
            TextLabel3.BorderSizePixel = 0;
            TextLabel3.ZIndex = u35.ZIndex + 5;
            TextLabel3.LayoutOrder = u35.ZIndex + 5;
            u2.applyTextStyle(TextLabel3);
            TextLabel3.Parent = Frame;
            local ScrollingFrame = Instance.new("ScrollingFrame");
            ScrollingFrame.Name = "ChildContainer";
            ScrollingFrame.BackgroundColor3 = u1._config.WindowBgColor;
            ScrollingFrame.BackgroundTransparency = u1._config.WindowBgTransparency;
            ScrollingFrame.BorderSizePixel = 0;
            ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;
            ScrollingFrame.ScrollBarImageTransparency = u1._config.ScrollbarGrabTransparency;
            ScrollingFrame.ScrollBarImageColor3 = u1._config.ScrollbarGrabColor;
            ScrollingFrame.ScrollBarThickness = u1._config.ScrollbarSize;
            ScrollingFrame.CanvasSize = UDim2.fromScale(0, 0);
            ScrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar;
            ScrollingFrame.ZIndex = u35.ZIndex + 6;
            ScrollingFrame.LayoutOrder = u35.ZIndex + 6;
            ScrollingFrame.ClipsDescendants = true;
            u2.UIStroke(ScrollingFrame, u1._config.WindowBorderSize, u1._config.BorderColor, u1._config.BorderTransparency);
            u2.UIPadding(ScrollingFrame, Vector2.new(2, 2 * u1._config.FramePadding.Y));
            u2.UIListLayout(ScrollingFrame, Enum.FillDirection.Vertical, UDim.new(0, u1._config.ItemSpacing.Y)).VerticalAlignment = Enum.VerticalAlignment.Top;
            local v39 = u1._rootInstance and u1._rootInstance:WaitForChild("PopupScreenGui");
            ScrollingFrame.Parent = v39;
            u35.ChildContainer = ScrollingFrame;

            return Frame;
        end,

        Update = function(p40) -- Line: 365, Name: Update
            -- upvalues: u1 (copy)
            local Instance2 = p40.Instance;
            local PreviewContainer = Instance2.PreviewContainer;
            local PreviewLabel = PreviewContainer.PreviewLabel;
            local DropdownButton = PreviewContainer.DropdownButton;
            Instance2.TextLabel.Text = p40.arguments.Text or "Combo";

            if p40.arguments.NoButton then
                DropdownButton.Visible = false;
                PreviewLabel.Size = UDim2.new(1, 0, 0, 0);
            else
                DropdownButton.Visible = true;
                PreviewLabel.Size = UDim2.new(1, -(u1._config.TextSize + 2 * u1._config.FramePadding.Y), 0, 0);
            end;

            if p40.arguments.NoPreview then
                PreviewLabel.Visible = false;
                PreviewContainer.Size = UDim2.new(0, 0, 0, 0);
                PreviewContainer.AutomaticSize = Enum.AutomaticSize.X;

                return;
            end;

            PreviewLabel.Visible = true;
            PreviewContainer.Size = UDim2.new(u1._config.ContentWidth, UDim.new(0, 0));
            PreviewContainer.AutomaticSize = Enum.AutomaticSize.Y;
        end,

        ChildAdded = function(p41, p42) -- Line: 393, Name: ChildAdded
            -- upvalues: UpdateChildContainerTransform (copy)
            if p42.type == "Selectable" then
                p41.ComboChildrenHeight = p41.ComboChildrenHeight + 1;
            else
                p41.ComboChildrenHeight = p41.ComboChildrenHeight + 10;
            end;

            UpdateChildContainerTransform(p41);

            return p41.ChildContainer;
        end,

        ChildDiscarded = function(p43, p44) -- Line: 403, Name: ChildDiscarded
            if p44.type == "Selectable" then
                p43.ComboChildrenHeight = p43.ComboChildrenHeight - 1;

                return;
            end;

            p43.ComboChildrenHeight = p43.ComboChildrenHeight - 10;
        end,

        GenerateState = function(u45) -- Line: 410, Name: GenerateState
            -- upvalues: u1 (copy)
            if u45.state.index == nil then
                u45.state.index = u1._widgetState(u45, "index", "No Selection");
            end;

            u45.state.index:onChange(function() -- Line: 414
                -- upvalues: u45 (copy)
                if u45.state.isOpened.value then
                    u45.state.isOpened:set(false);
                end;
            end);

            if u45.state.isOpened == nil then
                u45.state.isOpened = u1._widgetState(u45, "isOpened", false);
            end;
        end,

        UpdateState = function(p46) -- Line: 423, Name: UpdateState
            -- upvalues: u21 (ref), u23 (ref), u22 (ref), u1 (copy), u2 (copy), UpdateChildContainerTransform (copy)
            local PreviewContainer = p46.Instance.PreviewContainer;
            local PreviewLabel = PreviewContainer.PreviewLabel;
            local Dropdown = PreviewContainer.DropdownButton.Dropdown;
            local ChildContainer = p46.ChildContainer;

            if p46.state.isOpened.value then
                u21 = true;
                u23 = p46;
                u22 = u1._cycleTick;
                p46.lastOpenedTick = u1._cycleTick + 1;
                Dropdown.Image = u2.ICONS.RIGHT_POINTING_TRIANGLE;
                ChildContainer.Visible = true;
                UpdateChildContainerTransform(p46);
            else
                if u21 then
                    u21 = false;
                    u23 = nil;
                    p46.lastClosedTick = u1._cycleTick + 1;
                end;

                Dropdown.Image = u2.ICONS.DOWN_POINTING_TRIANGLE;
                ChildContainer.Visible = false;
            end;

            local value = p46.state.index.value;
            local v47;

            if typeof(value) == "EnumItem" then
                v47 = value.Name;
            else
                v47 = tostring(value);
            end;

            PreviewLabel.Text = v47;
        end,

        Discard = function(p48) -- Line: 455, Name: Discard
            -- upvalues: u2 (copy)
            p48.Instance:Destroy();
            u2.discardState(p48);
        end
    });
end;
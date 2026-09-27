-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);

return function(u1, u2) -- Line: 3
    local v12 = {
        hasState = true,
        hasChildren = true,
        Events = {
            collasped = {
                Init = function(p3) -- Line: 9
                end,

                Get = function(p4) -- Line: 10
                    -- upvalues: u1 (copy)
                    return p4.lastCollapsedTick == u1._cycleTick;
                end
            },
            uncollapsed = {
                Init = function(p5) -- Line: 15
                end,

                Get = function(p6) -- Line: 16
                    -- upvalues: u1 (copy)
                    return p6.lastUncollapsedTick == u1._cycleTick;
                end
            },
            hovered = u2.EVENTS.hover(function(p7) -- Line: 20
                return p7.Instance;
            end)
        },

        Discard = function(p8) -- Line: 24, Name: Discard
            -- upvalues: u2 (copy)
            p8.Instance:Destroy();
            u2.discardState(p8);
        end,

        ChildAdded = function(p9) -- Line: 28, Name: ChildAdded
            local ChildContainer = p9.Instance.ChildContainer;
            ChildContainer.Visible = p9.state.isUncollapsed.value;

            return ChildContainer;
        end,

        UpdateState = function(p10) -- Line: 36, Name: UpdateState
            -- upvalues: u2 (copy), u1 (copy)
            local value = p10.state.isUncollapsed.value;
            local Instance2 = p10.Instance;
            local ChildContainer = Instance2.ChildContainer;
            Instance2.Header.Button.Arrow.Image = value and u2.ICONS.DOWN_POINTING_TRIANGLE or u2.ICONS.RIGHT_POINTING_TRIANGLE;

            if value then
                p10.lastUncollapsedTick = u1._cycleTick + 1;
            else
                p10.lastCollapsedTick = u1._cycleTick + 1;
            end;

            ChildContainer.Visible = value;
        end,

        GenerateState = function(p11) -- Line: 53, Name: GenerateState
            -- upvalues: u1 (copy)
            if p11.state.isUncollapsed == nil then
                p11.state.isUncollapsed = u1._widgetState(p11, "isUncollapsed", false);
            end;
        end
    };
    u1.WidgetConstructor("Tree", u2.extend(v12, {
        Args = {
            Text = 1,
            SpanAvailWidth = 2,
            NoIndent = 3
        },

        Generate = function(u13) -- Line: 68, Name: Generate
            -- upvalues: u1 (copy), u2 (copy)
            local Frame = Instance.new("Frame");
            Frame.Name = "Iris_Tree";
            Frame.Size = UDim2.new(u1._config.ItemWidth, UDim.new(0, 0));
            Frame.AutomaticSize = Enum.AutomaticSize.Y;
            Frame.BackgroundTransparency = 1;
            Frame.BorderSizePixel = 0;
            Frame.ZIndex = u13.ZIndex;
            Frame.LayoutOrder = u13.ZIndex;
            u2.UIListLayout(Frame, Enum.FillDirection.Vertical, UDim.new(0, 0));
            local Frame2 = Instance.new("Frame");
            Frame2.Name = "ChildContainer";
            Frame2.Size = UDim2.fromScale(1, 0);
            Frame2.AutomaticSize = Enum.AutomaticSize.Y;
            Frame2.BackgroundTransparency = 1;
            Frame2.BorderSizePixel = 0;
            Frame2.ZIndex = u13.ZIndex + 1;
            Frame2.LayoutOrder = u13.ZIndex + 1;
            Frame2.Visible = false;
            u2.UIListLayout(Frame2, Enum.FillDirection.Vertical, UDim.new(0, u1._config.ItemSpacing.Y));
            u2.UIPadding(Frame2, Vector2.new(0, 0)).PaddingTop = UDim.new(0, u1._config.ItemSpacing.Y);
            Frame2.Parent = Frame;
            local Frame3 = Instance.new("Frame");
            Frame3.Name = "Header";
            Frame3.Size = UDim2.fromScale(1, 0);
            Frame3.AutomaticSize = Enum.AutomaticSize.Y;
            Frame3.BackgroundTransparency = 1;
            Frame3.BorderSizePixel = 0;
            Frame3.ZIndex = u13.ZIndex;
            Frame3.LayoutOrder = u13.ZIndex;
            Frame3.Parent = Frame;
            local TextButton = Instance.new("TextButton");
            TextButton.Name = "Button";
            TextButton.BackgroundTransparency = 1;
            TextButton.BorderSizePixel = 0;
            TextButton.Text = "";
            TextButton.ZIndex = u13.ZIndex;
            TextButton.LayoutOrder = u13.ZIndex;
            TextButton.AutoButtonColor = false;
            u2.applyInteractionHighlights(TextButton, Frame3, {
                ButtonTransparency = 1,
                ButtonColor = Color3.fromRGB(0, 0, 0),
                ButtonHoveredColor = u1._config.HeaderHoveredColor,
                ButtonHoveredTransparency = u1._config.HeaderHoveredTransparency,
                ButtonActiveColor = u1._config.HeaderActiveColor,
                ButtonActiveTransparency = u1._config.HeaderActiveTransparency
            });
            u2.UIPadding(TextButton, Vector2.zero).PaddingLeft = UDim.new(0, u1._config.FramePadding.X);
            u2.UIListLayout(TextButton, Enum.FillDirection.Horizontal, UDim.new(0, u1._config.FramePadding.X)).VerticalAlignment = Enum.VerticalAlignment.Center;
            TextButton.Parent = Frame3;
            local ImageLabel = Instance.new("ImageLabel");
            ImageLabel.Name = "Arrow";
            ImageLabel.Size = UDim2.fromOffset(u1._config.TextSize, (math.floor(u1._config.TextSize * 0.7)));
            ImageLabel.BackgroundTransparency = 1;
            ImageLabel.BorderSizePixel = 0;
            ImageLabel.ImageColor3 = u1._config.TextColor;
            ImageLabel.ImageTransparency = u1._config.TextTransparency;
            ImageLabel.ScaleType = Enum.ScaleType.Fit;
            ImageLabel.ZIndex = u13.ZIndex;
            ImageLabel.LayoutOrder = u13.ZIndex;
            ImageLabel.Parent = TextButton;
            local TextLabel = Instance.new("TextLabel");
            TextLabel.Name = "TextLabel";
            TextLabel.Size = UDim2.fromOffset(0, 0);
            TextLabel.AutomaticSize = Enum.AutomaticSize.XY;
            TextLabel.BackgroundTransparency = 1;
            TextLabel.BorderSizePixel = 0;
            TextLabel.ZIndex = u13.ZIndex;
            TextLabel.LayoutOrder = u13.ZIndex;
            u2.UIPadding(TextLabel, Vector2.new(0, 0)).PaddingRight = UDim.new(0, 21);
            u2.applyTextStyle(TextLabel);
            TextLabel.Parent = TextButton;
            TextButton.MouseButton1Click:Connect(function() -- Line: 160
                -- upvalues: u13 (copy)
                u13.state.isUncollapsed:set(not u13.state.isUncollapsed.value);
            end);

            return Frame;
        end,

        Update = function(p14) -- Line: 166, Name: Update
            -- upvalues: u1 (copy)
            local Instance2 = p14.Instance;
            local Button = Instance2.Header.Button;
            local UIPadding = Instance2.ChildContainer.UIPadding;
            Button.TextLabel.Text = p14.arguments.Text or "Tree";

            if p14.arguments.SpanAvailWidth then
                Button.AutomaticSize = Enum.AutomaticSize.Y;
                Button.Size = UDim2.fromScale(1, 0);
            else
                Button.AutomaticSize = Enum.AutomaticSize.XY;
                Button.Size = UDim2.fromScale(0, 0);
            end;

            if p14.arguments.NoIndent then
                UIPadding.PaddingLeft = UDim.new(0, 0);

                return;
            end;

            UIPadding.PaddingLeft = UDim.new(0, u1._config.IndentSpacing);
        end
    }));
    u1.WidgetConstructor("CollapsingHeader", u2.extend(v12, {
        Args = {
            Text = 1
        },

        Generate = function(u15) -- Line: 198, Name: Generate
            -- upvalues: u1 (copy), u2 (copy)
            local Frame = Instance.new("Frame");
            Frame.Name = "Iris_CollapsingHeader";
            Frame.Size = UDim2.new(u1._config.ItemWidth, UDim.new(0, 0));
            Frame.AutomaticSize = Enum.AutomaticSize.Y;
            Frame.BackgroundTransparency = 1;
            Frame.BorderSizePixel = 0;
            Frame.ZIndex = u15.ZIndex;
            Frame.LayoutOrder = u15.ZIndex;
            u2.UIListLayout(Frame, Enum.FillDirection.Vertical, UDim.new(0, 0));
            local Frame2 = Instance.new("Frame");
            Frame2.Name = "ChildContainer";
            Frame2.Size = UDim2.fromScale(1, 0);
            Frame2.AutomaticSize = Enum.AutomaticSize.Y;
            Frame2.BackgroundTransparency = 1;
            Frame2.BorderSizePixel = 0;
            Frame2.ZIndex = u15.ZIndex + 1;
            Frame2.LayoutOrder = u15.ZIndex + 1;
            Frame2.Visible = false;
            u2.UIListLayout(Frame2, Enum.FillDirection.Vertical, UDim.new(0, u1._config.ItemSpacing.Y));
            u2.UIPadding(Frame2, Vector2.new(0, 0)).PaddingTop = UDim.new(0, u1._config.ItemSpacing.Y);
            Frame2.Parent = Frame;
            local Frame3 = Instance.new("Frame");
            Frame3.Name = "Header";
            Frame3.Size = UDim2.fromScale(1, 0);
            Frame3.AutomaticSize = Enum.AutomaticSize.Y;
            Frame3.BackgroundTransparency = 1;
            Frame3.BorderSizePixel = 0;
            Frame3.ZIndex = u15.ZIndex;
            Frame3.LayoutOrder = u15.ZIndex;
            Frame3.Parent = Frame;
            local TextButton = Instance.new("TextButton");
            TextButton.Name = "Button";
            TextButton.Size = UDim2.new(1, 2 * u1._config.FramePadding.X, 0, 0);
            TextButton.Position = UDim2.fromOffset(-4, 0);
            TextButton.AutomaticSize = Enum.AutomaticSize.Y;
            TextButton.BackgroundColor3 = u1._config.HeaderColor;
            TextButton.BackgroundTransparency = u1._config.HeaderTransparency;
            TextButton.BorderSizePixel = 0;
            TextButton.Text = "";
            TextButton.ZIndex = u15.ZIndex;
            TextButton.LayoutOrder = u15.ZIndex;
            TextButton.AutoButtonColor = false;
            TextButton.ClipsDescendants = true;
            u2.UIPadding(TextButton, Vector2.new(2 * u1._config.FramePadding.X, u1._config.FramePadding.Y));
            u2.applyFrameStyle(TextButton, true, true);
            u2.UIListLayout(TextButton, Enum.FillDirection.Horizontal, UDim.new(0, 2 * u1._config.FramePadding.X)).VerticalAlignment = Enum.VerticalAlignment.Center;
            u2.applyInteractionHighlights(TextButton, TextButton, {
                ButtonColor = u1._config.HeaderColor,
                ButtonTransparency = u1._config.HeaderTransparency,
                ButtonHoveredColor = u1._config.HeaderHoveredColor,
                ButtonHoveredTransparency = u1._config.HeaderHoveredTransparency,
                ButtonActiveColor = u1._config.HeaderActiveColor,
                ButtonActiveTransparency = u1._config.HeaderActiveTransparency
            });
            TextButton.Parent = Frame3;
            local ImageLabel = Instance.new("ImageLabel");
            ImageLabel.Name = "Arrow";
            ImageLabel.Size = UDim2.fromOffset(u1._config.TextSize, (math.ceil(u1._config.TextSize * 0.8)));
            ImageLabel.AutomaticSize = Enum.AutomaticSize.Y;
            ImageLabel.BackgroundTransparency = 1;
            ImageLabel.BorderSizePixel = 0;
            ImageLabel.ImageColor3 = u1._config.TextColor;
            ImageLabel.ImageTransparency = u1._config.TextTransparency;
            ImageLabel.ScaleType = Enum.ScaleType.Fit;
            ImageLabel.ZIndex = u15.ZIndex;
            ImageLabel.LayoutOrder = u15.ZIndex;
            ImageLabel.Parent = TextButton;
            local TextLabel = Instance.new("TextLabel");
            TextLabel.Name = "TextLabel";
            TextLabel.Size = UDim2.fromOffset(0, 0);
            TextLabel.AutomaticSize = Enum.AutomaticSize.XY;
            TextLabel.BackgroundTransparency = 1;
            TextLabel.BorderSizePixel = 0;
            TextLabel.ZIndex = u15.ZIndex;
            TextLabel.LayoutOrder = u15.ZIndex;
            u2.UIPadding(TextLabel, Vector2.new(0, 0)).PaddingRight = UDim.new(0, 21);
            u2.applyTextStyle(TextLabel);
            TextLabel.Parent = TextButton;
            TextButton.MouseButton1Click:Connect(function() -- Line: 296
                -- upvalues: u15 (copy)
                u15.state.isUncollapsed:set(not u15.state.isUncollapsed.value);
            end);

            return Frame;
        end,

        Update = function(p16) -- Line: 302, Name: Update
            p16.Instance.Header.Button.TextLabel.Text = p16.arguments.Text or "Collapsing Header";
        end
    }));
end;
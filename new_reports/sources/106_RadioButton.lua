-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);

return function(u1, u2) -- Line: 3
    u1.WidgetConstructor("RadioButton", {
        hasState = true,
        hasChildren = false,
        Args = {
            Text = 1,
            Index = 2
        },
        Events = {
            selected = {
                Init = function(p3) -- Line: 13
                end,

                Get = function(p4) -- Line: 14
                    -- upvalues: u1 (copy)
                    return p4.lastSelectedTick == u1._cycleTick;
                end
            },
            unselected = {
                Init = function(p5) -- Line: 19
                end,

                Get = function(p6) -- Line: 20
                    -- upvalues: u1 (copy)
                    return p6.lastUnselectedTick == u1._cycleTick;
                end
            },
            active = {
                Init = function(p7) -- Line: 25
                end,

                Get = function(p8) -- Line: 26
                    return p8.state.index.value == p8.arguments.Index;
                end
            },
            hovered = u2.EVENTS.hover(function(p9) -- Line: 30
                return p9.Instance;
            end)
        },

        Generate = function(u10) -- Line: 34, Name: Generate
            -- upvalues: u1 (copy), u2 (copy)
            local TextButton = Instance.new("TextButton");
            TextButton.Name = "Iris_RadioButton";
            TextButton.BackgroundTransparency = 1;
            TextButton.BorderSizePixel = 0;
            TextButton.Size = UDim2.fromOffset(0, 0);
            TextButton.Text = "";
            TextButton.AutomaticSize = Enum.AutomaticSize.XY;
            TextButton.ZIndex = u10.ZIndex;
            TextButton.AutoButtonColor = false;
            TextButton.LayoutOrder = u10.ZIndex;
            local v11 = u1._config.TextSize + 2 * (u1._config.FramePadding.Y - 1);
            local Frame = Instance.new("Frame");
            Frame.Name = "Button";
            Frame.Size = UDim2.fromOffset(v11, v11);
            Frame.ZIndex = u10.ZIndex + 1;
            Frame.LayoutOrder = u10.ZIndex + 1;
            Frame.Parent = TextButton;
            Frame.BackgroundColor3 = u1._config.FrameBgColor;
            Frame.BackgroundTransparency = u1._config.FrameBgTransparency;
            u2.UICorner(Frame);
            local Frame2 = Instance.new("Frame");
            Frame2.Name = "Circle";
            Frame2.Position = UDim2.fromOffset(u1._config.FramePadding.Y, u1._config.FramePadding.Y);
            Frame2.Size = UDim2.fromOffset(u1._config.TextSize - 2, u1._config.TextSize - 2);
            Frame2.ZIndex = u10.ZIndex + 1;
            Frame2.LayoutOrder = u10.ZIndex + 1;
            Frame2.Parent = Frame;
            Frame2.BackgroundColor3 = u1._config.CheckMarkColor;
            Frame2.BackgroundTransparency = u1._config.CheckMarkTransparency;
            u2.UICorner(Frame2);
            u2.applyInteractionHighlights(TextButton, Frame, {
                ButtonColor = u1._config.FrameBgColor,
                ButtonTransparency = u1._config.FrameBgTransparency,
                ButtonHoveredColor = u1._config.FrameBgHoveredColor,
                ButtonHoveredTransparency = u1._config.FrameBgHoveredTransparency,
                ButtonActiveColor = u1._config.FrameBgActiveColor,
                ButtonActiveTransparency = u1._config.FrameBgActiveTransparency
            });
            TextButton.MouseButton1Click:Connect(function() -- Line: 78
                -- upvalues: u10 (copy)
                u10.state.index:set(u10.arguments.Index);
            end);
            local TextLabel = Instance.new("TextLabel");
            TextLabel.Name = "TextLabel";
            u2.applyTextStyle(TextLabel);
            TextLabel.Position = UDim2.new(0, v11 + u1._config.ItemInnerSpacing.X, 0.5, 0);
            TextLabel.ZIndex = u10.ZIndex + 1;
            TextLabel.LayoutOrder = u10.ZIndex + 1;
            TextLabel.AutomaticSize = Enum.AutomaticSize.XY;
            TextLabel.AnchorPoint = Vector2.new(0, 0.5);
            TextLabel.BackgroundTransparency = 1;
            TextLabel.BorderSizePixel = 0;
            TextLabel.Parent = TextButton;

            return TextButton;
        end,

        Update = function(p12) -- Line: 96, Name: Update
            -- upvalues: u1 (copy)
            p12.Instance.TextLabel.Text = p12.arguments.Text or "Radio Button";

            if p12.state then
                u1._widgets[p12.type].UpdateState(p12);
            end;
        end,

        Discard = function(p13) -- Line: 105, Name: Discard
            -- upvalues: u2 (copy)
            p13.Instance:Destroy();
            u2.discardState(p13);
        end,

        GenerateState = function(p14) -- Line: 109, Name: GenerateState
            -- upvalues: u1 (copy)
            if p14.state.index == nil then
                p14.state.index = u1._widgetState(p14, "index", p14.arguments.Value);
            end;
        end,

        UpdateState = function(p15) -- Line: 114, Name: UpdateState
            -- upvalues: u1 (copy)
            local Circle = p15.Instance.Button.Circle;

            if p15.state.index.value == p15.arguments.Index then
                Circle.BackgroundTransparency = u1._config.CheckMarkTransparency;
                p15.lastSelectedTick = u1._cycleTick + 1;

                return;
            end;

            Circle.BackgroundTransparency = 1;
            p15.lastUnselectedTick = u1._cycleTick + 1;
        end
    });
end;
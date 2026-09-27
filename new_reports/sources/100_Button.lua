-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);

return function(u1, u2) -- Line: 3
    local u11 = {
        hasState = false,
        hasChildren = false,
        Args = {
            Text = 1
        },
        Events = {
            clicked = u2.EVENTS.click(function(p3) -- Line: 11
                return p3.Instance;
            end),
            rightClicked = u2.EVENTS.rightClick(function(p4) -- Line: 14
                return p4.Instance;
            end),
            doubleClicked = u2.EVENTS.doubleClick(function(p5) -- Line: 17
                return p5.Instance;
            end),
            ctrlClicked = u2.EVENTS.ctrlClick(function(p6) -- Line: 20
                return p6.Instance;
            end),
            hovered = u2.EVENTS.hover(function(p7) -- Line: 23
                return p7.Instance;
            end)
        },

        Generate = function(p8) -- Line: 27, Name: Generate
            -- upvalues: u1 (copy), u2 (copy)
            local TextButton = Instance.new("TextButton");
            TextButton.Size = UDim2.fromOffset(0, 0);
            TextButton.BackgroundColor3 = u1._config.ButtonColor;
            TextButton.BackgroundTransparency = u1._config.ButtonTransparency;
            TextButton.AutoButtonColor = false;
            u2.applyTextStyle(TextButton);
            TextButton.AutomaticSize = Enum.AutomaticSize.XY;
            u2.applyFrameStyle(TextButton);
            u2.applyInteractionHighlights(TextButton, TextButton, {
                ButtonColor = u1._config.ButtonColor,
                ButtonTransparency = u1._config.ButtonTransparency,
                ButtonHoveredColor = u1._config.ButtonHoveredColor,
                ButtonHoveredTransparency = u1._config.ButtonHoveredTransparency,
                ButtonActiveColor = u1._config.ButtonActiveColor,
                ButtonActiveTransparency = u1._config.ButtonActiveTransparency
            });
            TextButton.ZIndex = p8.ZIndex;
            TextButton.LayoutOrder = p8.ZIndex;

            return TextButton;
        end,

        Update = function(p9) -- Line: 53, Name: Update
            p9.Instance.Text = p9.arguments.Text or "Button";
        end,

        Discard = function(p10) -- Line: 57, Name: Discard
            p10.Instance:Destroy();
        end
    };
    u2.abstractButton = u11;
    u1.WidgetConstructor("Button", u2.extend(u11, {
        Generate = function(p12) -- Line: 66, Name: Generate
            -- upvalues: u11 (copy)
            local v13 = u11.Generate(p12);
            v13.Name = "Iris_Button";

            return v13;
        end
    }));
    u1.WidgetConstructor("SmallButton", u2.extend(u11, {
        Generate = function(p14) -- Line: 78, Name: Generate
            -- upvalues: u11 (copy)
            local v15 = u11.Generate(p14);
            v15.Name = "Iris_SmallButton";
            local UIPadding = v15.UIPadding;
            UIPadding.PaddingLeft = UDim.new(0, 2);
            UIPadding.PaddingRight = UDim.new(0, 2);
            UIPadding.PaddingTop = UDim.new(0, 0);
            UIPadding.PaddingBottom = UDim.new(0, 0);

            return v15;
        end
    }));
end;
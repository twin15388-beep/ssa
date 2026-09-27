-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);

return function(u1, u2) -- Line: 3
    u1.WidgetConstructor("Separator", {
        hasState = false,
        hasChildren = false,
        Args = {},
        Events = {},

        Generate = function(p3) -- Line: 9, Name: Generate
            -- upvalues: u1 (copy), u2 (copy)
            local Frame = Instance.new("Frame");
            Frame.Name = "Iris_Separator";
            Frame.BackgroundColor3 = u1._config.SeparatorColor;
            Frame.BackgroundTransparency = u1._config.SeparatorTransparency;
            Frame.BorderSizePixel = 0;

            if p3.parentWidget.type == "SameLine" then
                Frame.Size = UDim2.new(0, 1, 1, 0);
            else
                Frame.Size = UDim2.new(1, 0, 0, 1);
            end;

            Frame.ZIndex = p3.ZIndex;
            Frame.LayoutOrder = p3.ZIndex;
            u2.UIListLayout(Frame, Enum.FillDirection.Vertical, UDim.new(0, 0));

            return Frame;
        end,

        Update = function(p4) -- Line: 28, Name: Update
        end,

        Discard = function(p5) -- Line: 29, Name: Discard
            p5.Instance:Destroy();
        end
    });
    u1.WidgetConstructor("Indent", {
        hasState = false,
        hasChildren = true,
        Args = {
            Width = 1
        },
        Events = {},

        Generate = function(p6) -- Line: 41, Name: Generate
            -- upvalues: u2 (copy), u1 (copy)
            local Frame = Instance.new("Frame");
            Frame.Name = "Iris_Indent";
            Frame.BackgroundTransparency = 1;
            Frame.BorderSizePixel = 0;
            Frame.Size = UDim2.fromScale(1, 0);
            Frame.AutomaticSize = Enum.AutomaticSize.Y;
            Frame.ZIndex = p6.ZIndex;
            Frame.LayoutOrder = p6.ZIndex;
            u2.UIListLayout(Frame, Enum.FillDirection.Vertical, UDim.new(0, u1._config.ItemSpacing.Y));
            u2.UIPadding(Frame, Vector2.new(0, 0));

            return Frame;
        end,

        Update = function(p7) -- Line: 56, Name: Update
            -- upvalues: u1 (copy)
            local v8;

            if p7.arguments.Width then
                v8 = p7.arguments.Width;
            else
                v8 = u1._config.IndentSpacing;
            end;

            p7.Instance.UIPadding.PaddingLeft = UDim.new(0, v8);
        end,

        Discard = function(p9) -- Line: 67, Name: Discard
            p9.Instance:Destroy();
        end,

        ChildAdded = function(p10, p11) -- Line: 70, Name: ChildAdded
            return p10.Instance;
        end
    });
    u1.WidgetConstructor("SameLine", {
        hasState = false,
        hasChildren = true,
        Args = {
            Width = 1,
            VerticalAlignment = 2
        },
        Events = {},

        Generate = function(p12) -- Line: 83, Name: Generate
            -- upvalues: u2 (copy)
            local Frame = Instance.new("Frame");
            Frame.Name = "Iris_SameLine";
            Frame.BackgroundTransparency = 1;
            Frame.BorderSizePixel = 0;
            Frame.Size = UDim2.fromScale(1, 0);
            Frame.AutomaticSize = Enum.AutomaticSize.Y;
            Frame.ZIndex = p12.ZIndex;
            Frame.LayoutOrder = p12.ZIndex;
            u2.UIListLayout(Frame, Enum.FillDirection.Horizontal, UDim.new(0, 0));

            return Frame;
        end,

        Update = function(p13) -- Line: 97, Name: Update
            -- upvalues: u1 (copy)
            local UIListLayout = p13.Instance.UIListLayout;
            local v14;

            if p13.arguments.Width then
                v14 = p13.arguments.Width;
            else
                v14 = u1._config.ItemSpacing.X;
            end;

            UIListLayout.Padding = UDim.new(0, v14);

            if p13.arguments.VerticalAlignment then
                UIListLayout.VerticalAlignment = p13.arguments.VerticalAlignment;

                return;
            end;

            UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
        end,

        Discard = function(p15) -- Line: 113, Name: Discard
            p15.Instance:Destroy();
        end,

        ChildAdded = function(p16, p17) -- Line: 116, Name: ChildAdded
            return p16.Instance;
        end
    });
    u1.WidgetConstructor("Group", {
        hasState = false,
        hasChildren = true,
        Args = {},
        Events = {},

        Generate = function(p18) -- Line: 126, Name: Generate
            -- upvalues: u2 (copy), u1 (copy)
            local Frame = Instance.new("Frame");
            Frame.Name = "Iris_Group";
            Frame.BackgroundTransparency = 1;
            Frame.BorderSizePixel = 0;
            Frame.Size = UDim2.fromOffset(0, 0);
            Frame.AutomaticSize = Enum.AutomaticSize.XY;
            Frame.ZIndex = p18.ZIndex;
            Frame.LayoutOrder = p18.ZIndex;
            Frame.ClipsDescendants = true;
            u2.UIListLayout(Frame, Enum.FillDirection.Vertical, UDim.new(0, u1._config.ItemSpacing.X));

            return Frame;
        end,

        Update = function(p19) -- Line: 141, Name: Update
        end,

        Discard = function(p20) -- Line: 142, Name: Discard
            p20.Instance:Destroy();
        end,

        ChildAdded = function(p21, p22) -- Line: 145, Name: ChildAdded
            return p21.Instance;
        end
    });
end;
-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);

return function(u1, u2) -- Line: 3
    local u3 = {};
    table.insert(u1._postCycleCallbacks, function() -- Line: 7
        -- upvalues: u3 (copy)
        for _, v in u3 do
            v.RowColumnIndex = 0;
        end;
    end);
    u1.WidgetConstructor("Table", {
        hasState = false,
        hasChildren = true,
        Args = {
            NumColumns = 1,
            RowBg = 2,
            BordersOuter = 3,
            BordersInner = 4
        },
        Events = {
            hovered = u2.EVENTS.hover(function(p4) -- Line: 23
                return p4.Instance;
            end)
        },

        Generate = function(p5) -- Line: 27, Name: Generate
            -- upvalues: u3 (copy), u1 (copy), u2 (copy)
            u3[p5.ID] = p5;
            p5.InitialNumColumns = -1;
            p5.RowColumnIndex = 0;
            p5.ColumnInstances = {};
            p5.CellInstances = {};
            local Frame = Instance.new("Frame");
            Frame.Name = "Iris_Table";
            Frame.Size = UDim2.new(u1._config.ItemWidth, UDim.new(0, 0));
            Frame.AutomaticSize = Enum.AutomaticSize.Y;
            Frame.BackgroundTransparency = 1;
            Frame.BorderSizePixel = 0;
            Frame.ZIndex = p5.ZIndex + 1024;
            Frame.LayoutOrder = p5.ZIndex;
            Frame.ClipsDescendants = true;
            u2.UIListLayout(Frame, Enum.FillDirection.Horizontal, UDim.new(0, 0));
            u2.UIStroke(Frame, 1, u1._config.TableBorderStrongColor, u1._config.TableBorderStrongTransparency);

            return Frame;
        end,

        Update = function(p6) -- Line: 51, Name: Update
            -- upvalues: u2 (copy), u1 (copy)
            local Instance2 = p6.Instance;

            if p6.arguments.BordersOuter == false then
                Instance2.UIStroke.Thickness = 0;
            else
                Instance2.UIStroke.Thickness = 1;
            end;

            if p6.InitialNumColumns == -1 then
                if p6.arguments.NumColumns == nil then
                    error("Iris.Table NumColumns argument is required", 5);
                end;

                p6.InitialNumColumns = p6.arguments.NumColumns;

                for i = 1, p6.InitialNumColumns do
                    local v7 = p6.ZIndex + 1 + i;
                    local Frame = Instance.new("Frame");
                    Frame.Name = `Column_{i}`;
                    Frame.Size = UDim2.new(1 / p6.InitialNumColumns, 0, 0, 0);
                    Frame.AutomaticSize = Enum.AutomaticSize.Y;
                    Frame.BackgroundTransparency = 1;
                    Frame.BorderSizePixel = 0;
                    Frame.ZIndex = v7;
                    Frame.LayoutOrder = v7;
                    Frame.ClipsDescendants = true;
                    u2.UIListLayout(Frame, Enum.FillDirection.Vertical, UDim.new(0, 0));
                    p6.ColumnInstances[i] = Frame;
                    Frame.Parent = Instance2;
                    local _ = i;
                end;
            elseif p6.arguments.NumColumns ~= p6.InitialNumColumns then
                error("Iris.Table NumColumns Argument must be static");
            end;

            if p6.arguments.RowBg == false then
                for _, v in p6.CellInstances do
                    v.BackgroundTransparency = 1;
                end;
            else
                for i, v in p6.CellInstances do
                    local v8;

                    if math.ceil(i / p6.InitialNumColumns) % 2 == 0 then
                        v8 = u1._config.TableRowBgAltTransparency;
                    else
                        v8 = u1._config.TableRowBgTransparency;
                    end;

                    v.BackgroundTransparency = v8;
                end;
            end;

            if p6.arguments.BordersInner == false then
                for _, v in p6.CellInstances do
                    v.UIStroke.Thickness = 0;
                end;

                return;
            end;

            for _, v in p6.CellInstances do
                v.UIStroke.Thickness = 0.5;
            end;
        end,

        Discard = function(p9) -- Line: 113, Name: Discard
            -- upvalues: u3 (copy)
            u3[p9.ID] = nil;
            p9.Instance:Destroy();
        end,

        ChildAdded = function(p10) -- Line: 117, Name: ChildAdded
            -- upvalues: u2 (copy), u1 (copy)
            if p10.RowColumnIndex == 0 then
                p10.RowColumnIndex = 1;
            end;

            local v11 = p10.CellInstances[p10.RowColumnIndex];

            if v11 then
                return v11;
            end;

            local v12 = p10.ColumnInstances[(p10.RowColumnIndex - 1) % p10.InitialNumColumns + 1];
            local v13 = v12.ZIndex + p10.RowColumnIndex;
            local Frame = Instance.new("Frame");
            Frame.Name = `Cell_{p10.RowColumnIndex}`;
            Frame.Size = UDim2.new(1, 0, 0, 0);
            Frame.AutomaticSize = Enum.AutomaticSize.Y;
            Frame.BackgroundTransparency = 1;
            Frame.BorderSizePixel = 0;
            Frame.ZIndex = v13;
            Frame.LayoutOrder = v13;
            Frame.ClipsDescendants = true;
            u2.UIPadding(Frame, u1._config.CellPadding);
            u2.UIListLayout(Frame, Enum.FillDirection.Vertical, UDim.new(0, u1._config.ItemSpacing.Y));

            if p10.arguments.BordersInner == false then
                u2.UIStroke(Frame, 0, u1._config.TableBorderLightColor, u1._config.TableBorderLightTransparency);
            else
                u2.UIStroke(Frame, 0.5, u1._config.TableBorderLightColor, u1._config.TableBorderLightTransparency);
            end;

            if p10.arguments.RowBg ~= false then
                local math_ceil_ret = math.ceil(p10.RowColumnIndex / p10.InitialNumColumns);
                local v14;

                if math_ceil_ret % 2 == 0 then
                    v14 = u1._config.TableRowBgAltColor;
                else
                    v14 = u1._config.TableRowBgColor;
                end;

                local v15;

                if math_ceil_ret % 2 == 0 then
                    v15 = u1._config.TableRowBgAltTransparency;
                else
                    v15 = u1._config.TableRowBgTransparency;
                end;

                Frame.BackgroundColor3 = v14;
                Frame.BackgroundTransparency = v15;
            end;

            p10.CellInstances[p10.RowColumnIndex] = Frame;
            Frame.Parent = v12;

            return Frame;
        end
    });
end;
-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);

return function(u1, u2) -- Line: 3
    local u5 = {
        Init = function(p3) -- Line: 5
        end,

        Get = function(p4) -- Line: 6
            -- upvalues: u1 (copy)
            return p4.lastNumberChangedTick == u1._cycleTick;
        end
    };

    local function getValueByIndex(p6: any, p7: number, p8: any) -- Line: 11
        if typeof(p6) == "number" then
            return p6;
        end;

        if typeof(p6) == "Vector2" then
            if p7 == 1 then
                return p6.X;
            end;

            if p7 == 2 then
                return p6.Y;
            end;
        elseif typeof(p6) == "Vector3" then
            if p7 == 1 then
                return p6.X;
            end;

            if p7 == 2 then
                return p6.Y;
            end;

            if p7 == 3 then
                return p6.Z;
            end;
        elseif typeof(p6) == "UDim" then
            if p7 == 1 then
                return p6.Scale;
            end;

            if p7 == 2 then
                return p6.Offset;
            end;
        elseif typeof(p6) == "UDim2" then
            if p7 == 1 then
                return p6.X.Scale;
            end;

            if p7 == 2 then
                return p6.X.Offset;
            end;

            if p7 == 3 then
                return p6.Y.Scale;
            end;

            if p7 == 4 then
                return p6.Y.Offset;
            end;
        elseif typeof(p6) == "Color3" then
            local v9 = p8.UseHSV and { p6:ToHSV() } or { p6.R, p6.G, p6.B };

            if p7 == 1 then
                return v9[1];
            end;

            if p7 == 2 then
                return v9[2];
            end;

            if p7 == 3 then
                return v9[3];
            end;
        elseif typeof(p6) == "Rect" then
            if p7 == 1 then
                return p6.Min.X;
            end;

            if p7 == 2 then
                return p6.Min.Y;
            end;

            if p7 == 3 then
                return p6.Max.X;
            end;

            if p7 == 4 then
                return p6.Max.Y;
            end;
        elseif typeof(p6) == "table" then
            return p6[p7];
        end;

        error((`Incorrect datatype or value: {p6} {typeof(p6)} {p7}`));
    end;

    local function updateValueByIndex(p10: any, p11: number, p12: number, p13: any) -- Line: 70
        if typeof(p10) == "number" then
            return p12;
        end;

        if typeof(p10) == "Vector2" then
            if p11 == 1 then
                return Vector2.new(p12, p10.Y);
            end;

            if p11 == 2 then
                return Vector2.new(p10.X, p12);
            end;
        elseif typeof(p10) == "Vector3" then
            if p11 == 1 then
                return Vector3.new(p12, p10.Y, p10.Z);
            end;

            if p11 == 2 then
                return Vector3.new(p10.X, p12, p10.Z);
            end;

            if p11 == 3 then
                return Vector3.new(p10.X, p10.Y, p12);
            end;
        elseif typeof(p10) == "UDim" then
            if p11 == 1 then
                return UDim.new(p12, p10.Offset);
            end;

            if p11 == 2 then
                return UDim.new(p10.Scale, p12);
            end;
        elseif typeof(p10) == "UDim2" then
            if p11 == 1 then
                return UDim2.new(UDim.new(p12, p10.X.Offset), p10.Y);
            end;

            if p11 == 2 then
                return UDim2.new(UDim.new(p10.X.Scale, p12), p10.Y);
            end;

            if p11 == 3 then
                return UDim2.new(p10.X, UDim.new(p12, p10.Y.Offset));
            end;

            if p11 == 4 then
                return UDim2.new(p10.X, UDim.new(p10.Y.Scale, p12));
            end;
        elseif typeof(p10) == "Rect" then
            if p11 == 1 then
                return Rect.new(Vector2.new(p12, p10.Min.Y), p10.Max);
            end;

            if p11 == 2 then
                return Rect.new(Vector2.new(p10.Min.X, p12), p10.Max);
            end;

            if p11 == 3 then
                return Rect.new(p10.Min, Vector2.new(p12, p10.Max.Y));
            end;

            if p11 == 4 then
                return Rect.new(p10.Min, Vector2.new(p10.Max.X, p12));
            end;
        elseif typeof(p10) == "Color3" then
            if p13.UseHSV then
                local v14, v15, v16 = p10:ToHSV();

                if p11 == 1 then
                    return Color3.fromHSV(p12, v15, v16);
                end;

                if p11 == 2 then
                    return Color3.fromHSV(v14, p12, v16);
                end;

                if p11 == 3 then
                    return Color3.fromHSV(v14, v15, p12);
                end;
            end;

            if p11 == 1 then
                return Color3.new(p12, p10.G, p10.B);
            end;

            if p11 == 2 then
                return Color3.new(p10.R, p12, p10.B);
            end;

            if p11 == 3 then
                return Color3.new(p10.R, p10.G, p12);
            end;
        end;

        error((`Incorrect datatype or value {p10} {typeof(p10)} {p11}`));
    end;

    local u17 = {
        Num = { 1 },
        Vector2 = { 1, 1 },
        Vector3 = { 1, 1, 1 },
        UDim = { 0.01, 1 },
        UDim2 = { 0.01, 1, 0.01, 1 },
        Color3 = { 1, 1, 1 },
        Color4 = { 1, 1, 1, 1 },
        Rect = { 1, 1, 1, 1 }
    };
    local u18 = {
        Num = { 0 },
        Vector2 = { 0, 0 },
        Vector3 = { 0, 0, 0 },
        UDim = { 0, 0 },
        UDim2 = { 0, 0, 0, 0 },
        Rect = { 0, 0, 0, 0 }
    };
    local u19 = {
        Num = { 100 },
        Vector2 = { 100, 100 },
        Vector3 = { 100, 100, 100 },
        UDim = { 1, 960 },
        UDim2 = { 1, 960, 1, 960 },
        Rect = { 960, 960, 960, 960 }
    };
    local u20 = {
        Num = { "" },
        Vector2 = { "X: ", "Y: " },
        Vector3 = { "X: ", "Y: ", "Z: " },
        UDim = { "", "" },
        UDim2 = { "", "", "", "" },
        Color3_RGB = { "R: ", "G: ", "B: " },
        Color3_HSV = { "H: ", "S: ", "V: " },
        Color4_RGB = { "R: ", "G: ", "B: ", "T: " },
        Color4_HSV = { "H: ", "S: ", "V: ", "T: " },
        Rect = { "X: ", "Y: ", "X: ", "Y: " }
    };
    local u21 = {
        Num = { 0 },
        Vector2 = { 0, 0 },
        Vector3 = { 0, 0, 0 },
        UDim = { 3, 0 },
        UDim2 = { 3, 0, 3, 0 },
        Color3 = { 0, 0, 0 },
        Color4 = { 0, 0, 0, 0 },
        Rect = { 0, 0, 0, 0 }
    };

    local function generateButtons(u22: any, p23: userdata, p24: number, p25: number) -- Line: 194
        -- upvalues: u1 (copy), u2 (copy), getValueByIndex (copy)
        local v26 = p24 + (2 * u1._config.ItemInnerSpacing.X + p25 * 2);
        local v27 = u2.abstractButton.Generate(u22);
        v27.Name = "SubButton";
        v27.ZIndex = u22.ZIndex + 5;
        v27.LayoutOrder = u22.ZIndex + 5;
        v27.TextXAlignment = Enum.TextXAlignment.Center;
        v27.Text = "-";
        v27.Size = UDim2.fromOffset(u1._config.TextSize + 2 * u1._config.FramePadding.Y, u1._config.TextSize);
        v27.Parent = p23;
        v27.MouseButton1Click:Connect(function() -- Line: 206
            -- upvalues: u2 (ref), u22 (copy), getValueByIndex (ref), u1 (ref)
            local v28 = u2.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or u2.UserInputService:IsKeyDown(Enum.KeyCode.RightControl);
            local v29 = u22.arguments.Increment and getValueByIndex(u22.arguments.Increment, 1, u22.arguments) or 1;
            local v30 = u22.state.number.value - v29 * (v28 and 100 or 1);

            if u22.arguments.Min ~= nil then
                v30 = math.max(v30, getValueByIndex(u22.arguments.Min, 1, u22.arguments));
            end;

            if u22.arguments.Max ~= nil then
                v30 = math.min(v30, getValueByIndex(u22.arguments.Max, 1, u22.arguments));
            end;

            u22.state.number:set(v30);
            u22.lastNumberChangedTick = u1._cycleTick + 1;
        end);
        local v31 = u2.abstractButton.Generate(u22);
        v31.Name = "AddButton";
        v31.ZIndex = u22.ZIndex + 6;
        v31.LayoutOrder = u22.ZIndex + 6;
        v31.TextXAlignment = Enum.TextXAlignment.Center;
        v31.Text = "+";
        v31.Size = UDim2.fromOffset(u1._config.TextSize + 2 * u1._config.FramePadding.Y, u1._config.TextSize);
        v31.Parent = p23;
        v31.MouseButton1Click:Connect(function() -- Line: 232
            -- upvalues: u2 (ref), u22 (copy), getValueByIndex (ref), u1 (ref)
            local v32 = u2.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or u2.UserInputService:IsKeyDown(Enum.KeyCode.RightControl);
            local v33 = u22.arguments.Increment and getValueByIndex(u22.arguments.Increment, 1, u22.arguments) or 1;
            local v34 = u22.state.number.value + v33 * (v32 and 100 or 1);

            if u22.arguments.Min ~= nil then
                v34 = math.max(v34, getValueByIndex(u22.arguments.Min, 1, u22.arguments));
            end;

            if u22.arguments.Max ~= nil then
                v34 = math.min(v34, getValueByIndex(u22.arguments.Max, 1, u22.arguments));
            end;

            u22.state.number:set(v34);
            u22.lastNumberChangedTick = u1._cycleTick + 1;
        end);

        return v26;
    end;

    local function generateInputScalar(u35: any, u36: number, u37: any) -- Line: 252
        -- upvalues: u5 (copy), u2 (copy), u1 (copy), generateButtons (copy), getValueByIndex (copy), updateValueByIndex (copy), u21 (copy), u20 (copy)
        return {
            hasState = true,
            hasChildren = false,
            Args = {
                Text = 1,
                Increment = 2,
                Min = 3,
                Max = 4,
                Format = 5
            },
            Events = {
                numberChanged = u5,
                hovered = u2.EVENTS.hover(function(p38) -- Line: 265
                    return p38.Instance;
                end)
            },

            Generate = function(u39) -- Line: 269, Name: Generate
                -- upvalues: u35 (copy), u2 (ref), u1 (ref), u36 (copy), generateButtons (ref), getValueByIndex (ref), updateValueByIndex (ref)
                local Frame = Instance.new("Frame");
                Frame.Name = "Iris_Input" .. u35;
                Frame.Size = UDim2.fromScale(1, 0);
                Frame.BackgroundTransparency = 1;
                Frame.BorderSizePixel = 0;
                Frame.ZIndex = u39.ZIndex;
                Frame.LayoutOrder = u39.ZIndex;
                Frame.AutomaticSize = Enum.AutomaticSize.Y;
                u2.UIListLayout(Frame, Enum.FillDirection.Horizontal, UDim.new(0, u1._config.ItemInnerSpacing.X));
                local v40 = 0;
                local v41 = u1._config.TextSize + 2 * u1._config.FramePadding.Y;

                if u36 == 1 then
                    v40 = generateButtons(u39, Frame, v40, v41);
                end;

                local UDim_new_ret = UDim.new(u1._config.ContentWidth.Scale / u36, (u1._config.ContentWidth.Offset - u1._config.ItemInnerSpacing.X * (u36 - 1) - v40) / u36);
                local UDim_new_ret2 = UDim.new(UDim_new_ret.Scale * (u36 - 1), UDim_new_ret.Offset * (u36 - 1) + u1._config.ItemInnerSpacing.X * (u36 - 1) + v40);
                local v42 = u1._config.ContentWidth - UDim_new_ret2;

                for i = 1, u36 do
                    local TextBox = Instance.new("TextBox");
                    TextBox.Name = "InputField" .. tostring(i);
                    TextBox.ZIndex = u39.ZIndex + i;
                    TextBox.LayoutOrder = u39.ZIndex + i;

                    if i == u36 then
                        TextBox.Size = UDim2.new(v42, UDim.new());
                    else
                        TextBox.Size = UDim2.new(UDim_new_ret, UDim.new());
                    end;

                    TextBox.AutomaticSize = Enum.AutomaticSize.Y;
                    TextBox.BackgroundColor3 = u1._config.FrameBgColor;
                    TextBox.BackgroundTransparency = u1._config.FrameBgTransparency;
                    TextBox.ClearTextOnFocus = false;
                    TextBox.TextTruncate = Enum.TextTruncate.AtEnd;
                    TextBox.ClipsDescendants = true;
                    u2.applyFrameStyle(TextBox);
                    u2.applyTextStyle(TextBox);
                    u2.UISizeConstraint(TextBox, Vector2.new(1, 0));
                    TextBox.Parent = Frame;
                    TextBox.FocusLost:Connect(function() -- Line: 325
                        -- upvalues: TextBox (copy), u39 (copy), getValueByIndex (ref), i (copy), updateValueByIndex (ref), u1 (ref)
                        local v43 = tonumber(TextBox.Text:match("-?%d*%.?%d*"));

                        if v43 ~= nil then
                            if u39.arguments.Min ~= nil then
                                v43 = math.max(v43, getValueByIndex(u39.arguments.Min, i, u39.arguments));
                            end;

                            if u39.arguments.Max ~= nil then
                                v43 = math.min(v43, getValueByIndex(u39.arguments.Max, i, u39.arguments));
                            end;

                            if u39.arguments.Increment then
                                local v44 = v43 / getValueByIndex(u39.arguments.Increment, i, u39.arguments);
                                v43 = math.round(v44) * getValueByIndex(u39.arguments.Increment, i, u39.arguments);
                            end;

                            u39.state.number:set(updateValueByIndex(u39.state.number.value, i, v43, u39.arguments));
                            u39.lastNumberChangedTick = u1._cycleTick + 1;
                        end;

                        local v45 = u39.arguments.Format[i] or u39.arguments.Format[1];

                        if u39.arguments.Prefix then
                            v45 = u39.arguments.Prefix[i] .. v45;
                        end;

                        TextBox.Text = string.format(v45, getValueByIndex(u39.state.number.value, i, u39.arguments));
                        u39.state.editingText:set(0);
                    end);
                    TextBox.Focused:Connect(function() -- Line: 352
                        -- upvalues: TextBox (copy), u39 (copy), i (copy)
                        TextBox.CursorPosition = #TextBox.Text + 1;
                        TextBox.SelectionStart = 1;
                        u39.state.editingText:set(i);
                    end);
                    local _ = i;
                end;

                local TextLabel = Instance.new("TextLabel");
                TextLabel.Name = "TextLabel";
                TextLabel.Size = UDim2.fromOffset(0, v41);
                TextLabel.BackgroundTransparency = 1;
                TextLabel.BorderSizePixel = 0;
                TextLabel.ZIndex = u39.ZIndex + 7;
                TextLabel.LayoutOrder = u39.ZIndex + 7;
                TextLabel.AutomaticSize = Enum.AutomaticSize.X;
                u2.applyTextStyle(TextLabel);
                TextLabel.Parent = Frame;

                return Frame;
            end,

            Update = function(p46) -- Line: 376, Name: Update
                -- upvalues: u35 (copy), u36 (copy), u21 (ref), getValueByIndex (ref), u20 (ref)
                local Instance2 = p46.Instance;
                Instance2.TextLabel.Text = p46.arguments.Text or `Input {u35}`;

                if u36 == 1 then
                    Instance2.SubButton.Visible = not p46.arguments.NoButtons;
                    Instance2.AddButton.Visible = not p46.arguments.NoButtons;
                end;

                if p46.arguments.Format and typeof(p46.arguments.Format) ~= "table" then
                    p46.arguments.Format = { p46.arguments.Format };

                    return;
                end;

                local v47 = {};

                for i = 1, u36 do
                    local v48 = u21[u35][i];

                    if p46.arguments.Increment then
                        local v49 = getValueByIndex(p46.arguments.Increment, i, p46.arguments);
                        local v50 = -math.log10(v49 == 0 and 1 or v49);
                        local math_ceil_ret = math.ceil(v50);
                        v48 = math.max(v48, math_ceil_ret, v48);
                    end;

                    if p46.arguments.Max then
                        local v51 = getValueByIndex(p46.arguments.Max, i, p46.arguments);
                        local v52 = -math.log10(v51 == 0 and 1 or v51);
                        local math_ceil_ret = math.ceil(v52);
                        v48 = math.max(v48, math_ceil_ret, v48);
                    end;

                    if p46.arguments.Min then
                        local v53 = getValueByIndex(p46.arguments.Min, i, p46.arguments);
                        local v54 = -math.log10(v53 == 0 and 1 or v53);
                        local math_ceil_ret = math.ceil(v54);
                        v48 = math.max(v48, math_ceil_ret, v48);
                    end;

                    local v55;

                    if v48 > 0 then
                        v47[i] = `%.{v48}f`;
                        v55 = i;
                    else
                        v47[i] = "%d";
                        v55 = i;
                    end;
                end;

                p46.arguments.Format = v47;
                p46.arguments.Prefix = u20[u35];
            end,

            Discard = function(p56) -- Line: 421, Name: Discard
                -- upvalues: u2 (ref)
                p56.Instance:Destroy();
                u2.discardState(p56);
            end,

            GenerateState = function(p57) -- Line: 425, Name: GenerateState
                -- upvalues: u1 (ref), u37 (copy)
                if p57.state.number == nil then
                    p57.state.number = u1._widgetState(p57, "number", u37);
                end;

                if p57.state.editingText == nil then
                    p57.state.editingText = u1._widgetState(p57, "editingText", 0);
                end;
            end,

            UpdateState = function(p58) -- Line: 433, Name: UpdateState
                -- upvalues: u36 (copy), getValueByIndex (ref)
                local Instance2 = p58.Instance;

                for i = 1, u36 do
                    local v59 = Instance2:FindFirstChild("InputField" .. tostring(i));
                    local v60 = p58.arguments.Format[i] or p58.arguments.Format[1];

                    if p58.arguments.Prefix then
                        v60 = p58.arguments.Prefix[i] .. v60;
                    end;

                    v59.Text = string.format(v60, getValueByIndex(p58.state.number.value, i, p58.arguments));
                    local _ = i;
                end;
            end
        };
    end;

    local u61 = 0;
    local u62 = false;
    local u63 = nil;
    local u64 = 0;
    local u65 = "";

    local function updateActiveDrag() -- Line: 461
        -- upvalues: u2 (copy), u61 (ref), u62 (ref), u63 (ref), u65 (ref), u64 (ref), getValueByIndex (copy), u17 (copy), updateValueByIndex (copy), u1 (copy)
        local X = u2.getMouseLocation().X;
        local v66 = X - u61;
        u61 = X;

        if u62 == false then
            return;
        end;

        if u63 == nil then
            return;
        end;

        local number = u63.state.number;

        if u65 == "Color3" or u65 == "Color4" then
            number = u63.state.color;

            if u64 == 4 then
                number = u63.state.transparency;
            end;
        end;

        local v67 = (u63.arguments.Increment and getValueByIndex(u63.arguments.Increment, u64, u63.arguments) or u17[u65][u64]) * ((u2.UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or u2.UserInputService:IsKeyDown(Enum.KeyCode.RightShift)) and 10 or 1) * ((u2.UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) or u2.UserInputService:IsKeyDown(Enum.KeyCode.RightAlt)) and 0.1 or 1) * ((u65 == "Color3" or u65 == "Color4") and 5 or 1);
        local v68 = getValueByIndex(number.value, u64, u63.arguments) + v66 * v67;

        if u63.arguments.Min ~= nil then
            v68 = math.max(v68, getValueByIndex(u63.arguments.Min, u64, u63.arguments));
        end;

        if u63.arguments.Max ~= nil then
            v68 = math.min(v68, getValueByIndex(u63.arguments.Max, u64, u63.arguments));
        end;

        number:set(updateValueByIndex(number.value, u64, v68, u63.arguments));
        u63.lastNumberChangedTick = u1._cycleTick + 1;
    end;

    local function DragMouseDown(p69: any, p70: any, p71: number, p72: number, p73: number) -- Line: 502
        -- upvalues: u2 (copy), u1 (copy), u62 (ref), u63 (ref), u64 (ref), u65 (ref), updateActiveDrag (copy)
        local Time = u2.getTime();
        local v74 = Time - p69.lastClickedTime < u1._config.MouseDoubleClickTime;
        local v75 = u2.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or u2.UserInputService:IsKeyDown(Enum.KeyCode.RightControl);

        if v74 and (Vector2.new(p72, p73) - p69.lastClickedPosition).Magnitude < u1._config.MouseDoubleClickMaxDist or v75 then
            p69.state.editingText:set(p71);

            return;
        end;

        p69.lastClickedTime = Time;
        p69.lastClickedPosition = Vector2.new(p72, p73);
        u62 = true;
        u63 = p69;
        u64 = p71;
        u65 = p70;
        updateActiveDrag();
    end;

    u2.UserInputService.InputChanged:Connect(updateActiveDrag);
    u2.UserInputService.InputEnded:Connect(function(p76: userdata) -- Line: 525
        -- upvalues: u62 (ref), u63 (ref), u64 (ref)
        if p76.UserInputType == Enum.UserInputType.MouseButton1 and u62 then
            u62 = false;
            u63 = nil;
            u64 = 0;
        end;
    end);

    local function generateDragScalar(u77: any, u78: number, u79: any) -- Line: 533
        -- upvalues: u5 (copy), u2 (copy), u1 (copy), getValueByIndex (copy), updateValueByIndex (copy), DragMouseDown (copy), u21 (copy), u20 (copy)
        return {
            hasState = true,
            hasChildren = false,
            Args = {
                Text = 1,
                Increment = 2,
                Min = 3,
                Max = 4,
                Format = 5
            },
            Events = {
                numberChanged = u5,
                hovered = u2.EVENTS.hover(function(p80) -- Line: 546
                    return p80.Instance;
                end)
            },

            Generate = function(u81) -- Line: 550, Name: Generate
                -- upvalues: u77 (copy), u2 (ref), u1 (ref), u78 (copy), getValueByIndex (ref), updateValueByIndex (ref), DragMouseDown (ref)
                u81.lastClickedTime = -1;
                u81.lastClickedPosition = Vector2.zero;
                local Frame = Instance.new("Frame");
                Frame.Name = "Iris_Drag" .. u77;
                Frame.Size = UDim2.fromScale(1, 0);
                Frame.BackgroundTransparency = 1;
                Frame.BorderSizePixel = 0;
                Frame.ZIndex = u81.ZIndex;
                Frame.LayoutOrder = u81.ZIndex;
                Frame.AutomaticSize = Enum.AutomaticSize.Y;
                u2.UIListLayout(Frame, Enum.FillDirection.Horizontal, UDim.new(0, u1._config.ItemInnerSpacing.X));
                local v82 = 0;
                local v83 = u1._config.TextSize + 2 * u1._config.FramePadding.Y;

                if u77 == "Color3" or u77 == "Color4" then
                    v82 = v82 + (u1._config.ItemInnerSpacing.X + v83);
                    local ImageLabel = Instance.new("ImageLabel");
                    ImageLabel.Name = "ColorBox";
                    ImageLabel.BorderSizePixel = 0;
                    ImageLabel.Size = UDim2.fromOffset(v83, v83);
                    ImageLabel.ZIndex = u81.ZIndex + 5;
                    ImageLabel.LayoutOrder = u81.ZIndex + 5;
                    ImageLabel.Image = u2.ICONS.ALPHA_BACKGROUND_TEXTURE;
                    ImageLabel.ImageTransparency = 1;
                    u2.applyFrameStyle(ImageLabel, true, true);
                    ImageLabel.Parent = Frame;
                end;

                local UDim_new_ret = UDim.new(u1._config.ContentWidth.Scale / u78, (u1._config.ContentWidth.Offset - u1._config.ItemInnerSpacing.X * (u78 - 1) - v82) / u78);
                local UDim_new_ret2 = UDim.new(UDim_new_ret.Scale * (u78 - 1), UDim_new_ret.Offset * (u78 - 1) + u1._config.ItemInnerSpacing.X * (u78 - 1) + v82);
                local v84 = u1._config.ContentWidth - UDim_new_ret2;

                for i = 1, u78 do
                    local TextButton = Instance.new("TextButton");
                    TextButton.Name = "DragField" .. tostring(i);
                    TextButton.ZIndex = u81.ZIndex + i;
                    TextButton.LayoutOrder = u81.ZIndex + i;

                    if i == u78 then
                        TextButton.Size = UDim2.new(v84, UDim.new());
                    else
                        TextButton.Size = UDim2.new(UDim_new_ret, UDim.new());
                    end;

                    TextButton.AutomaticSize = Enum.AutomaticSize.Y;
                    TextButton.BackgroundColor3 = u1._config.FrameBgColor;
                    TextButton.BackgroundTransparency = u1._config.FrameBgTransparency;
                    TextButton.AutoButtonColor = false;
                    TextButton.Text = "";
                    TextButton.ClipsDescendants = true;
                    u2.applyFrameStyle(TextButton);
                    u2.applyTextStyle(TextButton);
                    u2.UISizeConstraint(TextButton, Vector2.new(1, 0));
                    TextButton.TextXAlignment = Enum.TextXAlignment.Center;
                    TextButton.Parent = Frame;
                    u2.applyInteractionHighlights(TextButton, TextButton, {
                        ButtonColor = u1._config.FrameBgColor,
                        ButtonTransparency = u1._config.FrameBgTransparency,
                        ButtonHoveredColor = u1._config.FrameBgHoveredColor,
                        ButtonHoveredTransparency = u1._config.FrameBgHoveredTransparency,
                        ButtonActiveColor = u1._config.FrameBgActiveColor,
                        ButtonActiveTransparency = u1._config.FrameBgActiveTransparency
                    });
                    local TextBox = Instance.new("TextBox");
                    TextBox.Name = "InputField";
                    TextBox.ZIndex = u81.ZIndex + 5;
                    TextBox.LayoutOrder = u81.ZIndex + 2;
                    TextBox.Size = UDim2.new(1, 0, 1, 0);
                    TextBox.BackgroundTransparency = 1;
                    TextBox.ClearTextOnFocus = false;
                    TextBox.TextTruncate = Enum.TextTruncate.AtEnd;
                    TextBox.ClipsDescendants = true;
                    TextBox.Visible = false;
                    u2.applyFrameStyle(TextBox, true);
                    u2.applyTextStyle(TextBox);
                    TextBox.Parent = TextButton;
                    TextBox.FocusLost:Connect(function() -- Line: 648
                        -- upvalues: TextBox (copy), u81 (copy), u77 (ref), i (copy), getValueByIndex (ref), updateValueByIndex (ref), u1 (ref)
                        local v85 = tonumber(TextBox.Text:match("-?%d*%.?%d*"));
                        local number = u81.state.number;

                        if u77 == "Color4" and i == 4 then
                            number = u81.state.transparency;
                        elseif u77 == "Color3" or u77 == "Color4" then
                            number = u81.state.color;
                        end;

                        if v85 ~= nil then
                            if u77 == "Color3" or u77 == "Color4" and not u81.arguments.UseFloats then
                                v85 = v85 / 255;
                            end;

                            if u81.arguments.Min ~= nil then
                                v85 = math.max(v85, getValueByIndex(u81.arguments.Min, i, u81.arguments));
                            end;

                            if u81.arguments.Max ~= nil then
                                v85 = math.min(v85, getValueByIndex(u81.arguments.Max, i, u81.arguments));
                            end;

                            if u81.arguments.Increment then
                                local v86 = v85 / getValueByIndex(u81.arguments.Increment, i, u81.arguments);
                                v85 = math.round(v86) * getValueByIndex(u81.arguments.Increment, i, u81.arguments);
                            end;

                            number:set(updateValueByIndex(number.value, i, v85, u81.arguments));
                            u81.lastNumberChangedTick = u1._cycleTick + 1;
                        end;

                        local v87 = getValueByIndex(number.value, i, u81.arguments);

                        if u77 == "Color3" or u77 == "Color4" and not u81.arguments.UseFloats then
                            v87 = math.round(v87 * 255);
                        end;

                        local v88 = u81.arguments.Format[i] or u81.arguments.Format[1];

                        if u81.arguments.Prefix then
                            v88 = u81.arguments.Prefix[i] .. v88;
                        end;

                        TextBox.Text = string.format(v88, v87);
                        u81.state.editingText:set(0);
                        TextBox:ReleaseFocus(true);
                    end);
                    TextBox.Focused:Connect(function() -- Line: 691
                        -- upvalues: TextBox (copy), u81 (copy), i (copy)
                        TextBox.CursorPosition = #TextBox.Text + 1;
                        TextBox.SelectionStart = 1;
                        u81.state.editingText:set(i);
                    end);
                    TextButton.MouseButton1Down:Connect(function(p89: number, p90: number) -- Line: 699
                        -- upvalues: DragMouseDown (ref), u81 (copy), u77 (ref), i (copy)
                        DragMouseDown(u81, u77, i, p89, p90);
                    end);
                    local _ = i;
                end;

                local TextLabel = Instance.new("TextLabel");
                TextLabel.Name = "TextLabel";
                TextLabel.Size = UDim2.fromOffset(0, v83);
                TextLabel.BackgroundTransparency = 1;
                TextLabel.BorderSizePixel = 0;
                TextLabel.ZIndex = u81.ZIndex + 5;
                TextLabel.LayoutOrder = u81.ZIndex + 5;
                TextLabel.AutomaticSize = Enum.AutomaticSize.X;
                u2.applyTextStyle(TextLabel);
                TextLabel.Parent = Frame;

                return Frame;
            end,

            Update = function(p91) -- Line: 719, Name: Update
                -- upvalues: u77 (copy), u78 (copy), u21 (ref), getValueByIndex (ref), u20 (ref)
                p91.Instance.TextLabel.Text = p91.arguments.Text or `Drag {u77}`;

                if p91.arguments.Format and typeof(p91.arguments.Format) ~= "table" then
                    p91.arguments.Format = { p91.arguments.Format };

                    return;
                end;

                if not p91.arguments.Format then
                    local v92 = {};

                    for i = 1, u78 do
                        local v93 = u21[u77][i];

                        if p91.arguments.Increment then
                            local v94 = getValueByIndex(p91.arguments.Increment, i, p91.arguments);
                            local v95 = -math.log10(v94 == 0 and 1 or v94);
                            local math_ceil_ret = math.ceil(v95);
                            v93 = math.max(v93, math_ceil_ret, v93);
                        end;

                        if p91.arguments.Max then
                            local v96 = getValueByIndex(p91.arguments.Max, i, p91.arguments);
                            local v97 = -math.log10(v96 == 0 and 1 or v96);
                            local math_ceil_ret = math.ceil(v97);
                            v93 = math.max(v93, math_ceil_ret, v93);
                        end;

                        if p91.arguments.Min then
                            local v98 = getValueByIndex(p91.arguments.Min, i, p91.arguments);
                            local v99 = -math.log10(v98 == 0 and 1 or v98);
                            local math_ceil_ret = math.ceil(v99);
                            v93 = math.max(v93, math_ceil_ret, v93);
                        end;

                        local v100;

                        if v93 > 0 then
                            v92[i] = `%.{v93}f`;
                            v100 = i;
                        else
                            v92[i] = "%d";
                            v100 = i;
                        end;
                    end;

                    p91.arguments.Format = v92;
                    p91.arguments.Prefix = u20[u77];
                end;
            end,

            Discard = function(p101) -- Line: 759, Name: Discard
                -- upvalues: u2 (ref)
                p101.Instance:Destroy();
                u2.discardState(p101);
            end,

            GenerateState = function(p102) -- Line: 763, Name: GenerateState
                -- upvalues: u1 (ref), u79 (copy)
                if p102.state.number == nil then
                    p102.state.number = u1._widgetState(p102, "number", u79);
                end;

                if p102.state.editingText == nil then
                    p102.state.editingText = u1._widgetState(p102, "editingText", false);
                end;
            end,

            UpdateState = function(p103) -- Line: 771, Name: UpdateState
                -- upvalues: u78 (copy), u77 (copy), getValueByIndex (ref), u1 (ref)
                local Instance2 = p103.Instance;

                for i = 1, u78 do
                    local number = p103.state.number;

                    if u77 == "Color3" or u77 == "Color4" then
                        number = p103.state.color;

                        if i == 4 then
                            number = p103.state.transparency;
                        end;
                    end;

                    local v104 = Instance2:FindFirstChild("DragField" .. tostring(i));
                    local InputField = v104.InputField;
                    local v105 = getValueByIndex(number.value, i, p103.arguments);

                    if not (u77 ~= "Color3" and u77 ~= "Color4" or p103.arguments.UseFloats) then
                        v105 = math.round(v105 * 255);
                    end;

                    local v106 = p103.arguments.Format[i] or p103.arguments.Format[1];

                    if p103.arguments.Prefix then
                        v106 = p103.arguments.Prefix[i] .. v106;
                    end;

                    v104.Text = string.format(v106, v105);
                    InputField.Text = tostring(v105);
                    local v107;

                    if p103.state.editingText.value == i then
                        InputField.Visible = true;
                        InputField:CaptureFocus();
                        v104.TextTransparency = 1;
                        v107 = i;
                    else
                        InputField.Visible = false;
                        v104.TextTransparency = u1._config.TextTransparency;
                        v107 = i;
                    end;
                end;

                if u77 == "Color3" or u77 == "Color4" then
                    local ColorBox = Instance2.ColorBox;
                    ColorBox.BackgroundColor3 = p103.state.color.value;

                    if u77 == "Color4" then
                        ColorBox.ImageTransparency = 1 - p103.state.transparency.value;
                    end;
                end;
            end
        };
    end;

    local function generateColorDragScalar(u108, ...) -- Line: 819
        -- upvalues: generateDragScalar (ref), u2 (copy), u20 (copy), u1 (copy)
        local u109 = { ... };
        local v110 = generateDragScalar(u108, u108 == "Color4" and 4 or 3, u109[1]);

        return u2.extend(v110, {
            Args = {
                Text = 1,
                UseFloats = 2,
                UseHSV = 3,
                Format = 4
            },

            Update = function(p111) -- Line: 830, Name: Update
                -- upvalues: u108 (copy), u20 (ref), u1 (ref)
                p111.Instance.TextLabel.Text = p111.arguments.Text or `Drag {u108}`;

                if p111.arguments.Format and typeof(p111.arguments.Format) ~= "table" then
                    p111.arguments.Format = { p111.arguments.Format };
                else
                    if p111.arguments.UseFloats then
                        p111.arguments.Format = { "%.3f" };
                    else
                        p111.arguments.Format = { "%d" };
                    end;

                    p111.arguments.Prefix = u20[u108 .. (p111.arguments.UseHSV and "_HSV" or "_RGB")];
                end;

                p111.arguments.Min = { 0, 0, 0, 0 };
                p111.arguments.Max = { 1, 1, 1, 1 };
                p111.arguments.Increment = { 0.001, 0.001, 0.001, 0.001 };

                if p111.state then
                    u1._widgets[p111.type].UpdateState(p111);
                end;
            end,

            GenerateState = function(p112) -- Line: 857, Name: GenerateState
                -- upvalues: u1 (ref), u109 (copy), u108 (copy)
                if p112.state.color == nil then
                    p112.state.color = u1._widgetState(p112, "color", u109[1]);
                end;

                if u108 == "Color4" and p112.state.transparency == nil then
                    p112.state.transparency = u1._widgetState(p112, "transparency", u109[2]);
                end;

                if p112.state.editingText == nil then
                    p112.state.editingText = u1._widgetState(p112, "editingText", false);
                end;
            end
        });
    end;

    local u113 = false;
    local u114 = nil;
    local u115 = 0;
    local u116 = "";

    local function updateActiveSlider() -- Line: 885
        -- upvalues: u113 (ref), u114 (ref), u115 (ref), getValueByIndex (copy), u17 (copy), u116 (ref), u18 (copy), u19 (copy), u1 (copy), u2 (copy), updateValueByIndex (copy)
        if u113 == false then
            return;
        end;

        if u114 == nil then
            return;
        end;

        local v117 = u114.Instance:FindFirstChild("SliderField" .. tostring(u115));
        local v118 = u114.arguments.Increment and getValueByIndex(u114.arguments.Increment, u115, u114.arguments) or u17[u116][u115];
        local v119 = u114.arguments.Min and getValueByIndex(u114.arguments.Min, u115, u114.arguments) or u18[u116][u115];
        local v120 = u114.arguments.Max and getValueByIndex(u114.arguments.Max, u115, u114.arguments) or u19[u116][u115];
        local X = u1._config.FramePadding.X;
        local math_floor_ret = math.floor(((v118 < 1 and 0 or 1) + v120 - v119) / v118);
        local v121 = (u2.getMouseLocation().X - (v117.AbsolutePosition.X + X)) / (v117.AbsoluteSize.X - X * 2) * math_floor_ret;
        local v122 = math.floor(v121) * v118 + v119;
        local math_clamp_ret = math.clamp(v122, v119, v120);
        u114.state.number:set(updateValueByIndex(u114.state.number.value, u115, math_clamp_ret, u114.arguments));
        u114.lastNumberChangedTick = u1._cycleTick + 1;
    end;

    local function SliderMouseDown(p123: any, p124: any, p125: number) -- Line: 915
        -- upvalues: u2 (copy), u113 (ref), u114 (ref), u115 (ref), u116 (ref), updateActiveSlider (copy)
        if u2.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or u2.UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then
            p123.state.editingText:set(p125);

            return;
        end;

        u113 = true;
        u114 = p123;
        u115 = p125;
        u116 = p124;
        updateActiveSlider();
    end;

    u2.UserInputService.InputChanged:Connect(updateActiveSlider);
    u2.UserInputService.InputEnded:Connect(function(p126: userdata) -- Line: 931
        -- upvalues: u113 (ref), u114 (ref), u115 (ref), u116 (ref)
        if p126.UserInputType == Enum.UserInputType.MouseButton1 and u113 then
            u113 = false;
            u114 = nil;
            u115 = 0;
            u116 = "";
        end;
    end);

    local function generateSliderScalar(u127: any, u128: number, u129: any, ...) -- Line: 940
        -- upvalues: u5 (copy), u2 (copy), u1 (copy), getValueByIndex (copy), updateValueByIndex (copy), SliderMouseDown (copy), u21 (copy), u20 (copy), u17 (copy), u18 (copy), u19 (copy)
        return {
            hasState = true,
            hasChildren = false,
            Args = {
                Text = 1,
                Increment = 2,
                Min = 3,
                Max = 4,
                Format = 5
            },
            Events = {
                numberChanged = u5,
                hovered = u2.EVENTS.hover(function(p130) -- Line: 953
                    return p130.Instance;
                end)
            },

            Generate = function(u131) -- Line: 957, Name: Generate
                -- upvalues: u127 (copy), u2 (ref), u1 (ref), u128 (copy), getValueByIndex (ref), updateValueByIndex (ref), SliderMouseDown (ref)
                local Frame = Instance.new("Frame");
                Frame.Name = "Iris_Slider" .. u127;
                Frame.Size = UDim2.fromScale(1, 0);
                Frame.BackgroundTransparency = 1;
                Frame.BorderSizePixel = 0;
                Frame.ZIndex = u131.ZIndex;
                Frame.LayoutOrder = u131.ZIndex;
                Frame.AutomaticSize = Enum.AutomaticSize.Y;
                u2.UIListLayout(Frame, Enum.FillDirection.Horizontal, UDim.new(0, u1._config.ItemInnerSpacing.X));
                local v132 = u1._config.TextSize + 2 * u1._config.FramePadding.Y;
                local UDim_new_ret = UDim.new(u1._config.ContentWidth.Scale / u128, (u1._config.ContentWidth.Offset - u1._config.ItemInnerSpacing.X * (u128 - 1)) / u128);
                local UDim_new_ret2 = UDim.new(UDim_new_ret.Scale * (u128 - 1), UDim_new_ret.Offset * (u128 - 1) + u1._config.ItemInnerSpacing.X * (u128 - 1));
                local v133 = u1._config.ContentWidth - UDim_new_ret2;

                for i = 1, u128 do
                    local TextButton = Instance.new("TextButton");
                    TextButton.Name = "SliderField" .. tostring(i);
                    TextButton.ZIndex = u131.ZIndex + i;
                    TextButton.LayoutOrder = u131.ZIndex + i;

                    if i == u128 then
                        TextButton.Size = UDim2.new(v133, UDim.new());
                    else
                        TextButton.Size = UDim2.new(UDim_new_ret, UDim.new());
                    end;

                    TextButton.AutomaticSize = Enum.AutomaticSize.Y;
                    TextButton.BackgroundColor3 = u1._config.FrameBgColor;
                    TextButton.BackgroundTransparency = u1._config.FrameBgTransparency;
                    TextButton.AutoButtonColor = false;
                    TextButton.Text = "";
                    TextButton.ClipsDescendants = true;
                    u2.applyFrameStyle(TextButton);
                    u2.applyTextStyle(TextButton);
                    u2.UISizeConstraint(TextButton, Vector2.new(1, 0));
                    TextButton.Parent = Frame;
                    local TextLabel = Instance.new("TextLabel");
                    TextLabel.Name = "OverlayText";
                    TextLabel.Size = UDim2.fromScale(1, 1);
                    TextLabel.BackgroundTransparency = 1;
                    TextLabel.BorderSizePixel = 0;
                    TextLabel.ZIndex = u131.ZIndex + 10;
                    TextLabel.ClipsDescendants = true;
                    u2.applyTextStyle(TextLabel);
                    TextLabel.TextXAlignment = Enum.TextXAlignment.Center;
                    TextLabel.Parent = TextButton;
                    u2.applyInteractionHighlights(TextButton, TextButton, {
                        ButtonColor = u1._config.FrameBgColor,
                        ButtonTransparency = u1._config.FrameBgTransparency,
                        ButtonHoveredColor = u1._config.FrameBgHoveredColor,
                        ButtonHoveredTransparency = u1._config.FrameBgHoveredTransparency,
                        ButtonActiveColor = u1._config.FrameBgActiveColor,
                        ButtonActiveTransparency = u1._config.FrameBgActiveTransparency
                    });
                    local TextBox = Instance.new("TextBox");
                    TextBox.Name = "InputField";
                    TextBox.ZIndex = u131.ZIndex + 5;
                    TextBox.LayoutOrder = u131.ZIndex + 2;
                    TextBox.Size = UDim2.new(1, 0, 1, 0);
                    TextBox.BackgroundTransparency = 1;
                    TextBox.ClearTextOnFocus = false;
                    TextBox.TextTruncate = Enum.TextTruncate.AtEnd;
                    TextBox.ClipsDescendants = true;
                    TextBox.Visible = false;
                    u2.applyFrameStyle(TextBox, true);
                    u2.applyTextStyle(TextBox);
                    TextBox.Parent = TextButton;
                    TextBox.FocusLost:Connect(function() -- Line: 1045
                        -- upvalues: TextBox (copy), u131 (copy), getValueByIndex (ref), i (copy), updateValueByIndex (ref), u1 (ref)
                        local v134 = tonumber(TextBox.Text:match("-?%d*%.?%d*"));

                        if v134 ~= nil then
                            if u131.arguments.Min ~= nil then
                                v134 = math.max(v134, getValueByIndex(u131.arguments.Min, i, u131.arguments));
                            end;

                            if u131.arguments.Max ~= nil then
                                v134 = math.min(v134, getValueByIndex(u131.arguments.Max, i, u131.arguments));
                            end;

                            if u131.arguments.Increment then
                                local v135 = v134 / getValueByIndex(u131.arguments.Increment, i, u131.arguments);
                                v134 = math.round(v135) * getValueByIndex(u131.arguments.Increment, i, u131.arguments);
                            end;

                            u131.state.number:set(updateValueByIndex(u131.state.number.value, i, v134, u131.arguments));
                            u131.lastNumberChangedTick = u1._cycleTick + 1;
                        end;

                        local v136 = u131.arguments.Format[i] or u131.arguments.Format[1];

                        if u131.arguments.Prefix then
                            v136 = u131.arguments.Prefix[i] .. v136;
                        end;

                        TextBox.Text = string.format(v136, getValueByIndex(u131.state.number.value, i, u131.arguments));
                        u131.state.editingText:set(0);
                        TextBox:ReleaseFocus(true);
                    end);
                    TextBox.Focused:Connect(function() -- Line: 1075
                        -- upvalues: TextBox (copy), u131 (copy), i (copy)
                        TextBox.CursorPosition = #TextBox.Text + 1;
                        TextBox.SelectionStart = 1;
                        u131.state.editingText:set(i);
                    end);
                    TextButton.MouseButton1Down:Connect(function() -- Line: 1083
                        -- upvalues: SliderMouseDown (ref), u131 (copy), u127 (ref), i (copy)
                        SliderMouseDown(u131, u127, i);
                    end);
                    local Frame2 = Instance.new("Frame");
                    Frame2.Name = "GrabBar";
                    Frame2.ZIndex = u131.ZIndex + 5;
                    Frame2.LayoutOrder = u131.ZIndex + 5;
                    Frame2.AnchorPoint = Vector2.new(0, 0.5);
                    Frame2.Position = UDim2.new(0, 0, 0.5, 0);
                    Frame2.BorderSizePixel = 0;
                    Frame2.BackgroundColor3 = u1._config.SliderGrabColor;
                    Frame2.Transparency = u1._config.SliderGrabTransparency;

                    if u1._config.GrabRounding > 0 then
                        u2.UICorner(Frame2, u1._config.GrabRounding);
                    end;

                    Frame2.Parent = TextButton;
                    local _ = i;
                end;

                local TextLabel = Instance.new("TextLabel");
                TextLabel.Name = "TextLabel";
                TextLabel.Size = UDim2.fromOffset(0, v132);
                TextLabel.BackgroundTransparency = 1;
                TextLabel.BorderSizePixel = 0;
                TextLabel.ZIndex = u131.ZIndex + 5;
                TextLabel.LayoutOrder = u131.ZIndex + 5;
                TextLabel.AutomaticSize = Enum.AutomaticSize.X;
                u2.applyTextStyle(TextLabel);
                TextLabel.Parent = Frame;

                return Frame;
            end,

            Update = function(p137) -- Line: 1118, Name: Update
                -- upvalues: u127 (copy), u128 (copy), u21 (ref), getValueByIndex (ref), u20 (ref), u17 (ref), u18 (ref), u19 (ref), u1 (ref)
                local Instance2 = p137.Instance;
                Instance2.TextLabel.Text = p137.arguments.Text or `Slider {u127}`;

                if p137.arguments.Format and typeof(p137.arguments.Format) ~= "table" then
                    p137.arguments.Format = { p137.arguments.Format };
                else
                    local v138 = {};

                    for i = 1, u128 do
                        local v139 = u21[u127][i];

                        if p137.arguments.Increment then
                            local v140 = getValueByIndex(p137.arguments.Increment, i, p137.arguments);
                            local v141 = -math.log10(v140 == 0 and 1 or v140);
                            local math_ceil_ret = math.ceil(v141);
                            v139 = math.max(v139, math_ceil_ret, v139);
                        end;

                        if p137.arguments.Max then
                            local v142 = getValueByIndex(p137.arguments.Max, i, p137.arguments);
                            local v143 = -math.log10(v142 == 0 and 1 or v142);
                            local math_ceil_ret = math.ceil(v143);
                            v139 = math.max(v139, math_ceil_ret, v139);
                        end;

                        if p137.arguments.Min then
                            local v144 = getValueByIndex(p137.arguments.Min, i, p137.arguments);
                            local v145 = -math.log10(v144 == 0 and 1 or v144);
                            local math_ceil_ret = math.ceil(v145);
                            v139 = math.max(v139, math_ceil_ret, v139);
                        end;

                        local v146;

                        if v139 > 0 then
                            v138[i] = `%.{v139}f`;
                            v146 = i;
                        else
                            v138[i] = "%d";
                            v146 = i;
                        end;
                    end;

                    p137.arguments.Format = v138;
                    p137.arguments.Prefix = u20[u127];
                end;

                for i = 1, u128 do
                    local v147 = Instance2:FindFirstChild("SliderField" .. tostring(i));
                    local GrabBar = v147.GrabBar;
                    local v148 = p137.arguments.Increment and getValueByIndex(p137.arguments.Increment, i, p137.arguments) or u17[u127][i];
                    local v149 = p137.arguments.Min and getValueByIndex(p137.arguments.Min, i, p137.arguments) or u18[u127][i];
                    local v150 = p137.arguments.Max and getValueByIndex(p137.arguments.Max, i, p137.arguments) or u19[u127][i];
                    local v151 = 1 / math.floor((v150 + 1 - v149) / v148);
                    local math_max_ret = math.max(v151, u1._config.GrabMinSize / v147.AbsoluteSize.X);
                    GrabBar.Size = UDim2.new(math_max_ret, 0, 1, 0);
                    local _ = i;
                end;
            end,

            Discard = function(p152) -- Line: 1176, Name: Discard
                -- upvalues: u2 (ref)
                p152.Instance:Destroy();
                u2.discardState(p152);
            end,

            GenerateState = function(p153) -- Line: 1180, Name: GenerateState
                -- upvalues: u1 (ref), u129 (copy)
                if p153.state.number == nil then
                    p153.state.number = u1._widgetState(p153, "number", u129);
                end;

                if p153.state.editingText == nil then
                    p153.state.editingText = u1._widgetState(p153, "editingText", false);
                end;
            end,

            UpdateState = function(p154) -- Line: 1188, Name: UpdateState
                -- upvalues: u128 (copy), getValueByIndex (ref), u17 (ref), u127 (copy), u18 (ref), u19 (ref), u1 (ref)
                local Instance2 = p154.Instance;

                for i = 1, u128 do
                    local v155 = Instance2:FindFirstChild("SliderField" .. tostring(i));
                    local InputField = v155.InputField;
                    local OverlayText = v155.OverlayText;
                    local GrabBar = v155.GrabBar;
                    local v156 = getValueByIndex(p154.state.number.value, i, p154.arguments);
                    local v157 = p154.arguments.Format[i] or p154.arguments.Format[1];

                    if p154.arguments.Prefix then
                        v157 = p154.arguments.Prefix[i] .. v157;
                    end;

                    OverlayText.Text = string.format(v157, v156);
                    InputField.Text = tostring(v156);
                    local v158 = p154.arguments.Increment and getValueByIndex(p154.arguments.Increment, i, p154.arguments) or u17[u127][i];
                    local v159 = p154.arguments.Min and getValueByIndex(p154.arguments.Min, i, p154.arguments) or u18[u127][i];
                    local v160 = p154.arguments.Max and getValueByIndex(p154.arguments.Max, i, p154.arguments) or u19[u127][i];
                    local X = u1._config.FramePadding.X;
                    local math_floor_ret = math.floor(((v158 < 1 and 0 or 1) + v160 - v159) / v158);
                    local v161 = 1 - GrabBar.AbsoluteSize.X / (v155.AbsoluteSize.X - X * 2);
                    local v162 = math.floor((v156 - v159) / (v160 - v159) * math_floor_ret) / math_floor_ret;
                    local math_clamp_ret = math.clamp(v162, 0, v161);
                    GrabBar.Position = UDim2.new(math_clamp_ret, 0, 0.5, 0);
                    local v163;

                    if p154.state.editingText.value == i then
                        InputField.Visible = true;
                        OverlayText.Visible = false;
                        GrabBar.Visible = false;
                        InputField:CaptureFocus();
                        v163 = i;
                    else
                        InputField.Visible = false;
                        OverlayText.Visible = true;
                        GrabBar.Visible = true;
                        v163 = i;
                    end;
                end;
            end
        };
    end;

    local function generateEnumSliderScalar(u164: userdata, u165: userdata) -- Line: 1238
        -- upvalues: generateSliderScalar (ref), u2 (copy), u1 (copy)
        local v166 = generateSliderScalar("Enum", 1, u165.Value);
        local v167 = { string };

        for _, v in u164:GetEnumItems() do
            v167[v.Value] = v.Name;
        end;

        return u2.extend(v166, {
            Args = {
                Text = 1
            },

            Update = function(p168) -- Line: 1250, Name: Update
                -- upvalues: u164 (copy), u1 (ref)
                local Instance2 = p168.Instance;
                Instance2.TextLabel.Text = p168.arguments.Text or "Input Enum";
                p168.arguments.Increment = 1;
                p168.arguments.Min = 0;
                p168.arguments.Max = #u164:GetEnumItems() - 1;
                local SliderField1 = Instance2:FindFirstChild("SliderField1");
                local GrabBar = SliderField1.GrabBar;
                local v169 = #u164:GetEnumItems();
                local v170 = 1 / math.floor(v169);
                local math_max_ret = math.max(v170, u1._config.GrabMinSize / SliderField1.AbsoluteSize.X);
                GrabBar.Size = UDim2.new(math_max_ret, 0, 1, 0);
            end,

            GenerateState = function(p171) -- Line: 1266, Name: GenerateState
                -- upvalues: u1 (ref), u165 (copy)
                if p171.state.number == nil then
                    p171.state.number = u1._widgetState(p171, "number", u165.Value);
                end;

                if p171.state.enumItem == nil then
                    p171.state.enumItem = u1._widgetState(p171, "enumItem", u165);
                end;

                if p171.state.editingText == nil then
                    p171.state.editingText = u1._widgetState(p171, "editingText", false);
                end;
            end
        });
    end;

    local v172 = generateInputScalar("Num", 1, 0);
    v172.Args.NoButtons = 6;
    u1.WidgetConstructor("InputNum", v172);
    u1.WidgetConstructor("InputVector2", generateInputScalar("Vector2", 2, Vector2.zero));
    u1.WidgetConstructor("InputVector3", generateInputScalar("Vector3", 3, Vector3.new(0, 0, 0)));
    u1.WidgetConstructor("InputUDim", generateInputScalar("UDim", 2, UDim.new()));
    u1.WidgetConstructor("InputUDim2", generateInputScalar("UDim2", 4, UDim2.new()));
    u1.WidgetConstructor("InputRect", generateInputScalar("Rect", 4, Rect.new(0, 0, 0, 0)));
    u1.WidgetConstructor("DragNum", generateDragScalar("Num", 1, 0));
    u1.WidgetConstructor("DragVector2", generateDragScalar("Vector2", 2, Vector2.zero));
    u1.WidgetConstructor("DragVector3", generateDragScalar("Vector3", 3, Vector3.new(0, 0, 0)));
    u1.WidgetConstructor("DragUDim", generateDragScalar("UDim", 2, UDim.new()));
    u1.WidgetConstructor("DragUDim2", generateDragScalar("UDim2", 4, UDim2.new()));
    u1.WidgetConstructor("DragRect", generateDragScalar("Rect", 4, Rect.new(0, 0, 0, 0)));
    u1.WidgetConstructor("InputColor3", generateColorDragScalar("Color3", Color3.fromRGB(0, 0, 0)));
    u1.WidgetConstructor("InputColor4", generateColorDragScalar("Color4", Color3.fromRGB(0, 0, 0), 0));
    u1.WidgetConstructor("SliderNum", generateSliderScalar("Num", 1, 0));
    u1.WidgetConstructor("SliderVector2", generateSliderScalar("Vector2", 2, Vector2.zero));
    u1.WidgetConstructor("SliderVector3", generateSliderScalar("Vector3", 3, Vector3.new(0, 0, 0)));
    u1.WidgetConstructor("SliderUDim", generateSliderScalar("UDim", 2, UDim.new()));
    u1.WidgetConstructor("SliderUDim2", generateSliderScalar("UDim2", 4, UDim2.new()));
    u1.WidgetConstructor("SliderRect", generateSliderScalar("Rect", 4, Rect.new(0, 0, 0, 0)));
    u1.WidgetConstructor("InputText", {
        hasState = true,
        hasChildren = false,
        Args = {
            Text = 1,
            TextHint = 2
        },
        Events = {
            textChanged = {
                Init = function(p173) -- Line: 1319
                    p173.lastTextchangeTick = 0;
                end,

                Get = function(p174) -- Line: 1322
                    -- upvalues: u1 (copy)
                    return p174.lastTextchangeTick == u1._cycleTick;
                end
            },
            hovered = u2.EVENTS.hover(function(p175) -- Line: 1326
                return p175.Instance;
            end)
        },

        Generate = function(u176) -- Line: 1330, Name: Generate
            -- upvalues: u1 (copy), u2 (copy)
            local Frame = Instance.new("Frame");
            Frame.Name = "Iris_InputText";
            Frame.Size = UDim2.new(u1._config.ContentWidth, UDim.new(0, 0));
            Frame.BackgroundTransparency = 1;
            Frame.BorderSizePixel = 0;
            Frame.ZIndex = u176.ZIndex;
            Frame.LayoutOrder = u176.ZIndex;
            Frame.AutomaticSize = Enum.AutomaticSize.Y;
            u2.UIListLayout(Frame, Enum.FillDirection.Horizontal, UDim.new(0, u1._config.ItemInnerSpacing.X));
            local TextBox = Instance.new("TextBox");
            TextBox.Name = "InputField";
            TextBox.Size = UDim2.new(1, 0, 0, 0);
            TextBox.AutomaticSize = Enum.AutomaticSize.Y;
            TextBox.BackgroundColor3 = u1._config.FrameBgColor;
            TextBox.BackgroundTransparency = u1._config.FrameBgTransparency;
            TextBox.Text = "";
            TextBox.PlaceholderColor3 = u1._config.TextDisabledColor;
            TextBox.TextTruncate = Enum.TextTruncate.AtEnd;
            TextBox.ClearTextOnFocus = false;
            TextBox.ZIndex = u176.ZIndex + 1;
            TextBox.LayoutOrder = u176.ZIndex + 1;
            TextBox.ClipsDescendants = true;
            u2.applyFrameStyle(TextBox);
            u2.applyTextStyle(TextBox);
            u2.UISizeConstraint(TextBox, Vector2.new(1, 0));
            TextBox.Parent = Frame;
            TextBox.FocusLost:Connect(function() -- Line: 1362
                -- upvalues: u176 (copy), TextBox (copy), u1 (ref)
                u176.state.text:set(TextBox.Text);
                u176.lastTextchangeTick = u1._cycleTick + 1;
            end);
            local v177 = u1._config.TextSize + u1._config.FramePadding.Y * 2;
            local TextLabel = Instance.new("TextLabel");
            TextLabel.Name = "TextLabel";
            TextLabel.Size = UDim2.fromOffset(0, v177);
            TextLabel.AutomaticSize = Enum.AutomaticSize.X;
            TextLabel.BackgroundTransparency = 1;
            TextLabel.BorderSizePixel = 0;
            TextLabel.ZIndex = u176.ZIndex + 4;
            TextLabel.LayoutOrder = u176.ZIndex + 4;
            u2.applyTextStyle(TextLabel);
            TextLabel.Parent = Frame;

            return Frame;
        end,

        Update = function(p178) -- Line: 1384, Name: Update
            local Instance2 = p178.Instance;
            local InputField = Instance2.InputField;
            Instance2.TextLabel.Text = p178.arguments.Text or "Input Text";
            InputField.PlaceholderText = p178.arguments.TextHint or "";
        end,

        Discard = function(p179) -- Line: 1392, Name: Discard
            -- upvalues: u2 (copy)
            p179.Instance:Destroy();
            u2.discardState(p179);
        end,

        GenerateState = function(p180) -- Line: 1396, Name: GenerateState
            -- upvalues: u1 (copy)
            if p180.state.text == nil then
                p180.state.text = u1._widgetState(p180, "text", "");
            end;
        end,

        UpdateState = function(p181) -- Line: 1401, Name: UpdateState
            p181.Instance.InputField.Text = p181.state.text.value;
        end
    });
end;
-- Decompiled with Potassium's decompiler.

require(script.Parent.Types);
local u1 = {};

return function(u2) -- Line: 5
    -- upvalues: u1 (copy)
    u1.GuiService = game:GetService("GuiService");
    u1.RunService = game:GetService("RunService");
    u1.UserInputService = game:GetService("UserInputService");
    u1.ContextActionService = game:GetService("ContextActionService");
    u1.TextService = game:GetService("TextService");
    u1.ICONS = {
        RIGHT_POINTING_TRIANGLE = "rbxasset://textures/DeveloperFramework/button_arrow_right.png",
        DOWN_POINTING_TRIANGLE = "rbxasset://textures/DeveloperFramework/button_arrow_down.png",
        MULTIPLICATION_SIGN = "rbxasset://textures/AnimationEditor/icon_close.png",
        BOTTOM_RIGHT_CORNER = "◢",
        CHECK_MARK = "rbxasset://textures/AnimationEditor/icon_checkmark.png",
        ALPHA_BACKGROUND_TEXTURE = "rbxasset://textures/meshPartFallback.png"
    };
    u1.GuiInset = u1.GuiService:GetGuiInset();
    u1.IS_STUDIO = u1.RunService:IsStudio();

    function u1.getTime() -- Line: 24
        -- upvalues: u1 (ref)
        if u1.IS_STUDIO then
            return os.clock();
        end;

        return time();
    end;

    function u1.getMouseLocation() -- Line: 33
        -- upvalues: u1 (ref)
        return u1.UserInputService:GetMouseLocation() - u1.GuiInset;
    end;

    function u1.findBestWindowPosForPopup(p3, p4, p5, p6) -- Line: 37
        local v7;

        if p3.X + p4.X + 20 > p6.X then
            if p3.Y + p4.Y + 20 > p6.Y then
                v7 = p3 + Vector2.new(0, -(20 + p4.Y));
            else
                v7 = p3 + Vector2.new(0, 20);
            end;
        else
            v7 = p3 + Vector2.new(20, 0);
        end;

        local Vector2_new = Vector2.new;
        local v8 = math.min(v7.X + p4.X, p6.X) - p4.X;
        local math_max_ret = math.max(v8, p5.X);
        local v9 = math.min(v7.Y + p4.Y, p6.Y) - p4.Y;

        return Vector2_new(math_max_ret, (math.max(v9, p5.Y)));
    end;

    function u1.isPosInsideRect(p10, p11, p12) -- Line: 57
        local v13;

        if p10.X > p11.X and (p10.X < p12.X and p10.Y > p11.Y) then
            v13 = p10.Y < p12.Y;
        else
            v13 = false;
        end;

        return v13;
    end;

    function u1.extend(p14, p15) -- Line: 61
        local table_clone_ret = table.clone(p14);

        for i, v in p15 do
            table_clone_ret[i] = v;
        end;

        return table_clone_ret;
    end;

    function u1.UIPadding(p16: userdata, p17) -- Line: 69
        local UIPadding = Instance.new("UIPadding");
        UIPadding.PaddingLeft = UDim.new(0, p17.X);
        UIPadding.PaddingRight = UDim.new(0, p17.X);
        UIPadding.PaddingTop = UDim.new(0, p17.Y);
        UIPadding.PaddingBottom = UDim.new(0, p17.Y);
        UIPadding.Parent = p16;

        return UIPadding;
    end;

    function u1.UIListLayout(p18: userdata, p19: any, p20) -- Line: 79
        local UIListLayout = Instance.new("UIListLayout");
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
        UIListLayout.Padding = p20;
        UIListLayout.FillDirection = p19;
        UIListLayout.Parent = p18;

        return UIListLayout;
    end;

    function u1.UIStroke(p21: userdata, p22: number, p23, p24: number) -- Line: 88
        local UIStroke = Instance.new("UIStroke");
        UIStroke.Thickness = p22;
        UIStroke.Color = p23;
        UIStroke.Transparency = p24;
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
        UIStroke.LineJoinMode = Enum.LineJoinMode.Round;
        UIStroke.Parent = p21;

        return UIStroke;
    end;

    function u1.UICorner(p25: userdata, p26: number?) -- Line: 99
        local UICorner = Instance.new("UICorner");
        UICorner.CornerRadius = UDim.new(p26 and 0 or 1, p26 or 0);
        UICorner.Parent = p25;

        return UICorner;
    end;

    function u1.UISizeConstraint(p27: userdata, p28, p29) -- Line: 106
        local UISizeConstraint = Instance.new("UISizeConstraint");
        UISizeConstraint.MinSize = p28 or UISizeConstraint.MinSize;
        UISizeConstraint.MaxSize = p29 or UISizeConstraint.MaxSize;
        UISizeConstraint.Parent = p27;

        return UISizeConstraint;
    end;

    function u1.UIReference(p30: userdata, p31: userdata, p32: string) -- Line: 114
        local ObjectValue = Instance.new("ObjectValue");
        ObjectValue.Name = p32;
        ObjectValue.Value = p31;
        ObjectValue.Parent = p30;

        return ObjectValue;
    end;

    function u1.getScreenSizeForWindow(p33) -- Line: 123
        if p33.usesScreenGUI then
            return p33.Instance.AbsoluteSize;
        end;

        local Parent = p33.Instance.Parent;

        if Parent:IsA("GuiBase2d") then
            return Parent.AbsoluteSize;
        end;

        if Parent.Parent:IsA("GuiBase2d") then
            return Parent.AbsoluteSize;
        end;

        return workspace.CurrentCamera.ViewportSize;
    end;

    local GetTextBoundsParams = Instance.new("GetTextBoundsParams");
    GetTextBoundsParams.Font = u2._config.TextFont;
    GetTextBoundsParams.Size = u2._config.TextSize;
    GetTextBoundsParams.Width = (1 / 0);

    function u1.calculateTextSize(p34: string, p35: number?) -- Line: 148
        -- upvalues: GetTextBoundsParams (copy), u1 (ref)
        if p35 then
            GetTextBoundsParams.Width = p35;
        end;

        GetTextBoundsParams.Text = p34;
        local TextBoundsAsync = u1.TextService:GetTextBoundsAsync(GetTextBoundsParams);

        if p35 then
            GetTextBoundsParams.Width = (1 / 0);
        end;

        return TextBoundsAsync;
    end;

    function u1.applyTextStyle(p36) -- Line: 163
        -- upvalues: u2 (copy)
        p36.FontFace = u2._config.TextFont;
        p36.TextSize = u2._config.TextSize;
        p36.TextColor3 = u2._config.TextColor;
        p36.TextTransparency = u2._config.TextTransparency;
        p36.TextXAlignment = Enum.TextXAlignment.Left;
        p36.AutoLocalize = false;
        p36.RichText = false;
    end;

    function u1.applyInteractionHighlights(p37: userdata, u38: userdata, u39: table) -- Line: 174
        -- upvalues: u2 (copy)
        local u40 = false;
        p37.MouseEnter:Connect(function() -- Line: 176
            -- upvalues: u38 (copy), u39 (copy), u40 (ref)
            u38.BackgroundColor3 = u39.ButtonHoveredColor;
            u38.BackgroundTransparency = u39.ButtonHoveredTransparency;
            u40 = false;
        end);
        p37.MouseLeave:Connect(function() -- Line: 183
            -- upvalues: u38 (copy), u39 (copy), u40 (ref)
            u38.BackgroundColor3 = u39.ButtonColor;
            u38.BackgroundTransparency = u39.ButtonTransparency;
            u40 = true;
        end);
        p37.InputBegan:Connect(function(p41: userdata) -- Line: 190
            -- upvalues: u38 (copy), u39 (copy)
            if p41.UserInputType ~= Enum.UserInputType.MouseButton1 and p41.UserInputType ~= Enum.UserInputType.Gamepad1 then
                return;
            end;

            u38.BackgroundColor3 = u39.ButtonActiveColor;
            u38.BackgroundTransparency = u39.ButtonActiveTransparency;
        end);
        p37.InputEnded:Connect(function(p42: userdata) -- Line: 198
            -- upvalues: u40 (ref), u38 (copy), u39 (copy)
            if p42.UserInputType ~= Enum.UserInputType.MouseButton1 and p42.UserInputType ~= Enum.UserInputType.Gamepad1 or u40 then
                return;
            end;

            if p42.UserInputType == Enum.UserInputType.MouseButton1 then
                u38.BackgroundColor3 = u39.ButtonHoveredColor;
                u38.BackgroundTransparency = u39.ButtonHoveredTransparency;
            end;

            if p42.UserInputType == Enum.UserInputType.Gamepad1 then
                u38.BackgroundColor3 = u39.ButtonColor;
                u38.BackgroundTransparency = u39.ButtonTransparency;
            end;
        end);
        p37.SelectionImageObject = u2.SelectionImageObject;
    end;

    function u1.applyInteractionHighlightsWithMultiHighlightee(p43: userdata, u44: table) -- Line: 215
        -- upvalues: u2 (copy)
        local u45 = false;
        p43.MouseEnter:Connect(function() -- Line: 217
            -- upvalues: u44 (copy), u45 (ref)
            for _, v in u44 do
                v[1].BackgroundColor3 = v[2].ButtonHoveredColor;
                v[1].BackgroundTransparency = v[2].ButtonHoveredTransparency;
                u45 = false;
            end;
        end);
        p43.MouseLeave:Connect(function() -- Line: 226
            -- upvalues: u44 (copy), u45 (ref)
            for _, v in u44 do
                v[1].BackgroundColor3 = v[2].ButtonColor;
                v[1].BackgroundTransparency = v[2].ButtonTransparency;
                u45 = true;
            end;
        end);
        p43.InputBegan:Connect(function(p46: userdata) -- Line: 235
            -- upvalues: u44 (copy)
            if p46.UserInputType ~= Enum.UserInputType.MouseButton1 and p46.UserInputType ~= Enum.UserInputType.Gamepad1 then
                return;
            end;

            for _, v in u44 do
                v[1].BackgroundColor3 = v[2].ButtonActiveColor;
                v[1].BackgroundTransparency = v[2].ButtonActiveTransparency;
            end;
        end);
        p43.InputEnded:Connect(function(p47: userdata) -- Line: 245
            -- upvalues: u45 (ref), u44 (copy)
            if p47.UserInputType ~= Enum.UserInputType.MouseButton1 and p47.UserInputType ~= Enum.UserInputType.Gamepad1 or u45 then
                return;
            end;

            for _, v in u44 do
                if p47.UserInputType == Enum.UserInputType.MouseButton1 then
                    v[1].BackgroundColor3 = v[2].ButtonHoveredColor;
                    v[1].BackgroundTransparency = v[2].ButtonHoveredTransparency;
                end;

                if p47.UserInputType == Enum.UserInputType.Gamepad1 then
                    v[1].BackgroundColor3 = v[2].ButtonColor;
                    v[1].BackgroundTransparency = v[2].ButtonTransparency;
                end;
            end;
        end);
        p43.SelectionImageObject = u2.SelectionImageObject;
    end;

    function u1.applyTextInteractionHighlights(p48: userdata, u49: any, u50: table) -- Line: 264
        -- upvalues: u2 (copy)
        local u51 = false;
        p48.MouseEnter:Connect(function() -- Line: 266
            -- upvalues: u49 (copy), u50 (copy), u51 (ref)
            u49.TextColor3 = u50.ButtonHoveredColor;
            u49.TextTransparency = u50.ButtonHoveredTransparency;
            u51 = false;
        end);
        p48.MouseLeave:Connect(function() -- Line: 273
            -- upvalues: u49 (copy), u50 (copy), u51 (ref)
            u49.TextColor3 = u50.ButtonColor;
            u49.TextTransparency = u50.ButtonTransparency;
            u51 = true;
        end);
        p48.InputBegan:Connect(function(p52: userdata) -- Line: 280
            -- upvalues: u49 (copy), u50 (copy)
            if p52.UserInputType ~= Enum.UserInputType.MouseButton1 and p52.UserInputType ~= Enum.UserInputType.Gamepad1 then
                return;
            end;

            u49.TextColor3 = u50.ButtonActiveColor;
            u49.TextTransparency = u50.ButtonActiveTransparency;
        end);
        p48.InputEnded:Connect(function(p53: userdata) -- Line: 288
            -- upvalues: u51 (ref), u49 (copy), u50 (copy)
            if p53.UserInputType ~= Enum.UserInputType.MouseButton1 and p53.UserInputType ~= Enum.UserInputType.Gamepad1 or u51 then
                return;
            end;

            if p53.UserInputType == Enum.UserInputType.MouseButton1 then
                u49.TextColor3 = u50.ButtonHoveredColor;
                u49.TextTransparency = u50.ButtonHoveredTransparency;
            end;

            if p53.UserInputType == Enum.UserInputType.Gamepad1 then
                u49.TextColor3 = u50.ButtonColor;
                u49.TextTransparency = u50.ButtonTransparency;
            end;
        end);
        p48.SelectionImageObject = u2.SelectionImageObject;
    end;

    function u1.applyFrameStyle(p54: userdata, p55: boolean?, p56: boolean?) -- Line: 305
        -- upvalues: u2 (copy), u1 (ref)
        local FramePadding = u2._config.FramePadding;
        local FrameBorderSize = u2._config.FrameBorderSize;
        local BorderColor = u2._config.BorderColor;
        local ButtonTransparency = u2._config.ButtonTransparency;
        local FrameRounding = u2._config.FrameRounding;

        if FrameBorderSize > 0 and FrameRounding > 0 then
            p54.BorderSizePixel = 0;
            local UIStroke = Instance.new("UIStroke");
            UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
            UIStroke.LineJoinMode = Enum.LineJoinMode.Round;
            UIStroke.Transparency = ButtonTransparency;
            UIStroke.Thickness = FrameBorderSize;
            UIStroke.Color = BorderColor;
            u1.UICorner(p54, FrameRounding);
            UIStroke.Parent = p54;

            if not p55 then
                u1.UIPadding(p54, u2._config.FramePadding);
            end;
        elseif FrameBorderSize < 1 and FrameRounding > 0 then
            p54.BorderSizePixel = 0;
            u1.UICorner(p54, FrameRounding);

            if not p55 then
                u1.UIPadding(p54, u2._config.FramePadding);
            end;
        elseif FrameRounding < 1 then
            p54.BorderSizePixel = FrameBorderSize;
            p54.BorderColor3 = BorderColor;
            p54.BorderMode = Enum.BorderMode.Inset;

            if not p55 then
                u1.UIPadding(p54, FramePadding - Vector2.new(FrameBorderSize, FrameBorderSize));

                return;
            end;

            if not p56 then
                u1.UIPadding(p54, -Vector2.new(FrameBorderSize, FrameBorderSize));
            end;
        end;
    end;

    function u1.discardState(p57) -- Line: 350
        for _, v in p57.state do
            v.ConnectedWidgets[p57.ID] = nil;
        end;
    end;

    u1.EVENTS = {
        hover = function(u58: function) -- Line: 357, Name: hover
            return {
                Init = function(u59) -- Line: 359
                    -- upvalues: u58 (copy)
                    local v60 = u58(u59);
                    v60.MouseEnter:Connect(function() -- Line: 361
                        -- upvalues: u59 (copy)
                        u59.isHoveredEvent = true;
                    end);
                    v60.MouseLeave:Connect(function() -- Line: 364
                        -- upvalues: u59 (copy)
                        u59.isHoveredEvent = false;
                    end);
                    u59.isHoveredEvent = false;
                end,

                Get = function(p61) -- Line: 369
                    return p61.isHoveredEvent;
                end
            };
        end,

        click = function(u62: function) -- Line: 375, Name: click
            -- upvalues: u2 (copy)
            return {
                Init = function(u63) -- Line: 377
                    -- upvalues: u62 (copy), u2 (ref)
                    local v64 = u62(u63);
                    u63.lastClickedTick = -1;
                    v64.MouseButton1Click:Connect(function() -- Line: 381
                        -- upvalues: u63 (copy), u2 (ref)
                        u63.lastClickedTick = u2._cycleTick + 1;
                    end);
                end,

                Get = function(p65) -- Line: 385
                    -- upvalues: u2 (ref)
                    return p65.lastClickedTick == u2._cycleTick;
                end
            };
        end,

        rightClick = function(u66: function) -- Line: 391, Name: rightClick
            -- upvalues: u2 (copy)
            return {
                Init = function(u67) -- Line: 393
                    -- upvalues: u66 (copy), u2 (ref)
                    local v68 = u66(u67);
                    u67.lastRightClickedTick = -1;
                    v68.MouseButton2Click:Connect(function() -- Line: 397
                        -- upvalues: u67 (copy), u2 (ref)
                        u67.lastRightClickedTick = u2._cycleTick + 1;
                    end);
                end,

                Get = function(p69) -- Line: 401
                    -- upvalues: u2 (ref)
                    return p69.lastRightClickedTick == u2._cycleTick;
                end
            };
        end,

        doubleClick = function(u70: function) -- Line: 407, Name: doubleClick
            -- upvalues: u1 (ref), u2 (copy)
            return {
                Init = function(u71) -- Line: 409
                    -- upvalues: u70 (copy), u1 (ref), u2 (ref)
                    local v72 = u70(u71);
                    u71.lastClickedTime = -1;
                    u71.lastClickedPosition = Vector2.zero;
                    u71.lastDoubleClickedTick = -1;
                    v72.MouseButton1Down:Connect(function(p73: number, p74: number) -- Line: 415
                        -- upvalues: u1 (ref), u71 (copy), u2 (ref)
                        local Time = u1.getTime();

                        if Time - u71.lastClickedTime < u2._config.MouseDoubleClickTime and (Vector2.new(p73, p74) - u71.lastClickedPosition).Magnitude < u2._config.MouseDoubleClickMaxDist then
                            u71.lastDoubleClickedTick = u2._cycleTick + 1;

                            return;
                        end;

                        u71.lastClickedTime = Time;
                        u71.lastClickedPosition = Vector2.new(p73, p74);
                    end);
                end,

                Get = function(p75) -- Line: 426
                    -- upvalues: u2 (ref)
                    return p75.lastDoubleClickedTick == u2._cycleTick;
                end
            };
        end,

        ctrlClick = function(u76: function) -- Line: 432, Name: ctrlClick
            -- upvalues: u1 (ref), u2 (copy)
            return {
                Init = function(u77) -- Line: 434
                    -- upvalues: u76 (copy), u1 (ref), u2 (ref)
                    local v78 = u76(u77);
                    u77.lastCtrlClickedTick = -1;
                    v78.MouseButton1Click:Connect(function() -- Line: 438
                        -- upvalues: u1 (ref), u77 (copy), u2 (ref)
                        if u1.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or u1.UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then
                            u77.lastCtrlClickedTick = u2._cycleTick + 1;
                        end;
                    end);
                end,

                Get = function(p79) -- Line: 444
                    -- upvalues: u2 (ref)
                    return p79.lastCtrlClickedTick == u2._cycleTick;
                end
            };
        end,

        shortcut = function(u80: function) -- Line: 450, Name: shortcut
            -- upvalues: u1 (ref), u2 (copy)
            return {
                Init = function(u81) -- Line: 452
                    -- upvalues: u80 (copy), u1 (ref), u2 (ref)
                    local v82, u83 = u80(u81);
                    u81.lastShortcutTick = -1;
                    u1.ContextActionService:BindAction(u81.ID, function(p84: any, p85: any, p86: userdata) -- Line: 456
                        -- upvalues: u83 (copy), u81 (copy), u2 (ref)
                        if p85 == Enum.UserInputState.Begin and p86:IsModifierKeyDown(u83) then
                            u81.lastShortcutTick = u2._cycleTick + 1;
                        end;
                    end, false, v82);
                end,

                Get = function(p87) -- Line: 464
                    -- upvalues: u2 (ref)
                    return p87.lastShortcutTick == u2._cycleTick;
                end
            };
        end
    };
    require(script.Root)(u2, u1);
    require(script.Window)(u2, u1);
    require(script.Menu)(u2, u1);
    require(script.Format)(u2, u1);
    require(script.Text)(u2, u1);
    require(script.Button)(u2, u1);
    require(script.Checkbox)(u2, u1);
    require(script.RadioButton)(u2, u1);
    require(script.Tree)(u2, u1);
    require(script.Input)(u2, u1);
    require(script.Combo)(u2, u1);
    require(script.Table)(u2, u1);
end;
-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);

return function(u1, u2) -- Line: 3
    local function relocateTooltips() -- Line: 4
        -- upvalues: u1 (copy), u2 (copy)
        if u1._rootInstance == nil then
            return;
        end;

        local PopupScreenGui = u1._rootInstance:FindFirstChild("PopupScreenGui");

        if not PopupScreenGui then
            return;
        end;

        local TooltipContainer = PopupScreenGui.TooltipContainer;
        local MouseLocation = u2.getMouseLocation();
        local v3 = u2.findBestWindowPosForPopup(MouseLocation, TooltipContainer.AbsoluteSize, u1._config.DisplaySafeAreaPadding, PopupScreenGui.AbsoluteSize);
        TooltipContainer.Position = UDim2.fromOffset(v3.X, v3.Y);
    end;

    u2.UserInputService.InputChanged:Connect(relocateTooltips);
    u1.WidgetConstructor("Tooltip", {
        hasState = false,
        hasChildren = false,
        Args = {
            Text = 1
        },
        Events = {},

        Generate = function(p4) -- Line: 32, Name: Generate
            -- upvalues: u1 (copy), u2 (copy)
            p4.parentWidget = u1._rootWidget;
            local Frame = Instance.new("Frame");
            Frame.Name = "Iris_Tooltip";
            Frame.Size = UDim2.new(u1._config.ContentWidth, UDim.new(0, 0));
            Frame.AutomaticSize = Enum.AutomaticSize.Y;
            Frame.BorderSizePixel = 0;
            Frame.BackgroundTransparency = 1;
            Frame.ZIndex = p4.ZIndex + 1;
            Frame.LayoutOrder = p4.ZIndex + 1;
            local TextLabel = Instance.new("TextLabel");
            TextLabel.Name = "TooltipText";
            TextLabel.Size = UDim2.fromOffset(0, 0);
            TextLabel.AutomaticSize = Enum.AutomaticSize.XY;
            TextLabel.BackgroundColor3 = u1._config.WindowBgColor;
            TextLabel.BackgroundTransparency = u1._config.WindowBgTransparency;
            TextLabel.BorderSizePixel = u1._config.PopupBorderSize;
            TextLabel.TextWrapped = true;
            TextLabel.ZIndex = p4.ZIndex + 1;
            TextLabel.LayoutOrder = p4.ZIndex + 1;
            u2.applyTextStyle(TextLabel);
            u2.UIStroke(TextLabel, u1._config.WindowBorderSize, u1._config.BorderActiveColor, u1._config.BorderActiveTransparency);
            u2.UIPadding(TextLabel, u1._config.WindowPadding);

            if u1._config.PopupRounding > 0 then
                u2.UICorner(TextLabel, u1._config.PopupRounding);
            end;

            TextLabel.Parent = Frame;

            return Frame;
        end,

        Update = function(p5) -- Line: 66, Name: Update
            -- upvalues: relocateTooltips (copy)
            local TooltipText = p5.Instance.TooltipText;

            if p5.arguments.Text == nil then
                error("Iris.Text Text Argument is required", 5);
            end;

            TooltipText.Text = p5.arguments.Text;
            relocateTooltips();
        end,

        Discard = function(p6) -- Line: 75, Name: Discard
            p6.Instance:Destroy();
        end
    });
    local u7 = 0;
    local u8 = nil;
    local u9 = false;
    local u10 = nil;
    local u11 = nil;
    local u12 = false;
    local u13 = false;
    local u14 = false;
    local Top = Enum.TopBottom.Top;
    local Left = Enum.LeftRight.Left;
    local u15 = nil;
    local u16 = nil;
    local u17 = false;
    local u18 = {};

    local function quickSwapWindows() -- Line: 99
        -- upvalues: u1 (copy), u18 (copy)
        if u1._config.UseScreenGUIs == false then
            return;
        end;

        local v19 = 65535;
        local v20 = nil;

        for _, v in u18 do
            if v.state.isOpened.value and (not v.arguments.NoNav and v.Instance:IsA("ScreenGui")) then
                local DisplayOrder = v.Instance.DisplayOrder;

                if DisplayOrder < v19 then
                    v20 = v;
                    v19 = DisplayOrder;
                end;
            end;
        end;

        if not v20 then
            return;
        end;

        if v20.state.isUncollapsed.value == false then
            v20.state.isUncollapsed:set(true);
        end;

        u1.SetFocusedWindow(v20);
    end;

    local function fitSizeToWindowBounds(p21: any, p22) -- Line: 127
        -- upvalues: u1 (copy), u2 (copy)
        local Vector2_new_ret = Vector2.new(p21.state.position.value.X, p21.state.position.value.Y);
        local v23 = (u1._config.TextSize + u1._config.FramePadding.Y * 2) * 2;
        local ScreenSizeForWindow = u2.getScreenSizeForWindow(p21);
        local Vector2_new_ret2 = Vector2.new(u1._config.WindowBorderSize + u1._config.DisplaySafeAreaPadding.X, u1._config.WindowBorderSize + u1._config.DisplaySafeAreaPadding.Y);
        local v24 = ScreenSizeForWindow - Vector2_new_ret - Vector2_new_ret2;
        local Vector2_new = Vector2.new;
        local X = p22.X;
        local math_max_ret = math.max(v24.X, v23);
        local math_clamp_ret = math.clamp(X, v23, math_max_ret);
        local Y = p22.Y;
        local math_max_ret2 = math.max(v24.Y, v23);

        return Vector2_new(math_clamp_ret, (math.clamp(Y, v23, math_max_ret2)));
    end;

    local function fitPositionToWindowBounds(p25: any, p26) -- Line: 143
        -- upvalues: u2 (copy), u1 (copy)
        local Instance2 = p25.Instance;
        local ScreenSizeForWindow = u2.getScreenSizeForWindow(p25);
        local Vector2_new_ret = Vector2.new(u1._config.WindowBorderSize + u1._config.DisplaySafeAreaPadding.X, u1._config.WindowBorderSize + u1._config.DisplaySafeAreaPadding.Y);
        local Vector2_new = Vector2.new;
        local X = p26.X;
        local X2 = Vector2_new_ret.X;
        local math_max_ret = math.max(Vector2_new_ret.X, ScreenSizeForWindow.X - Instance2.WindowButton.AbsoluteSize.X - Vector2_new_ret.X);
        local math_clamp_ret = math.clamp(X, X2, math_max_ret);
        local Y = p26.Y;
        local Y2 = Vector2_new_ret.Y;
        local math_max_ret2 = math.max(Vector2_new_ret.Y, ScreenSizeForWindow.Y - Instance2.WindowButton.AbsoluteSize.Y - Vector2_new_ret.Y);

        return Vector2_new(math_clamp_ret, (math.clamp(Y, Y2, math_max_ret2)));
    end;

    function u1.SetFocusedWindow(p27) -- Line: 165
        -- upvalues: u16 (ref), u17 (ref), u18 (copy), u1 (copy), u7 (ref), u2 (copy)
        if u16 == p27 then
            return;
        end;

        if u17 and u16 ~= nil then
            if u18[u16.ID] then
                local WindowButton = u16.Instance.WindowButton;
                local TitleBar = WindowButton.TitleBar;

                if u16.state.isUncollapsed.value then
                    TitleBar.BackgroundColor3 = u1._config.TitleBgColor;
                    TitleBar.BackgroundTransparency = u1._config.TitleBgTransparency;
                else
                    TitleBar.BackgroundColor3 = u1._config.TitleBgCollapsedColor;
                    TitleBar.BackgroundTransparency = u1._config.TitleBgCollapsedTransparency;
                end;

                WindowButton.UIStroke.Color = u1._config.BorderColor;
            end;

            u17 = false;
            u16 = nil;
        end;

        if p27 ~= nil then
            u17 = true;
            u16 = p27;
            local Instance2 = p27.Instance;
            local WindowButton = Instance2.WindowButton;
            local TitleBar = WindowButton.TitleBar;
            TitleBar.BackgroundColor3 = u1._config.TitleBgActiveColor;
            TitleBar.BackgroundTransparency = u1._config.TitleBgActiveTransparency;
            WindowButton.UIStroke.Color = u1._config.BorderActiveColor;
            u7 = u7 + 1;

            if p27.usesScreenGUI then
                Instance2.DisplayOrder = u7 + u1._config.DisplayOrderOffset;
            end;

            if p27.state.isUncollapsed.value == false then
                p27.state.isUncollapsed:set(true);
            end;

            if u2.GuiService.SelectedObject then
                if TitleBar.Visible then
                    u2.GuiService:Select(TitleBar);

                    return;
                end;

                u2.GuiService:Select(Instance2.ChildContainer);
            end;
        end;
    end;

    u2.UserInputService.InputBegan:Connect(function(p28: userdata, p29: boolean) -- Line: 222
        -- upvalues: u1 (copy), u2 (copy), quickSwapWindows (copy), u13 (ref), u14 (ref), u17 (ref), u16 (ref), Top (ref), Left (ref), u12 (ref), u11 (ref)
        if not p29 and p28.UserInputType == Enum.UserInputType.MouseButton1 then
            u1.SetFocusedWindow(nil);
        end;

        if p28.KeyCode == Enum.KeyCode.Tab and (u2.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or u2.UserInputService:IsKeyDown(Enum.KeyCode.RightControl)) then
            quickSwapWindows();
        end;

        if p28.UserInputType == Enum.UserInputType.MouseButton1 and (u13 and (not u14 and (u17 and u16))) then
            local v30 = u16.state.position.value + u16.state.size.value * 0.5;
            local v31 = u2.getMouseLocation() - v30;

            if math.abs(v31.X) * u16.state.size.value.Y >= math.abs(v31.Y) * u16.state.size.value.X then
                Top = Enum.TopBottom.Center;
                local v32;

                if math.sign(v31.X) == -1 then
                    v32 = Enum.LeftRight.Left;
                else
                    v32 = Enum.LeftRight.Right;
                end;

                Left = v32;
            else
                Left = Enum.LeftRight.Center;
                local v33;

                if math.sign(v31.Y) == -1 then
                    v33 = Enum.TopBottom.Top;
                else
                    v33 = Enum.TopBottom.Bottom;
                end;

                Top = v33;
            end;

            u12 = true;
            u11 = u16;
        end;
    end);
    u2.UserInputService.TouchTapInWorld:Connect(function(p34: any, p35: boolean) -- Line: 253
        -- upvalues: u1 (copy)
        if not p35 then
            u1.SetFocusedWindow(nil);
        end;
    end);
    u2.UserInputService.InputChanged:Connect(function(p36: userdata) -- Line: 259
        -- upvalues: u9 (ref), u8 (ref), u2 (copy), u10 (ref), fitPositionToWindowBounds (copy), u12 (ref), u11 (ref), u15 (ref), Left (ref), Top (ref), fitSizeToWindowBounds (copy)
        if u9 and u8 then
            local v37;

            if p36.UserInputType == Enum.UserInputType.Touch then
                local Position = p36.Position;
                v37 = Vector2.new(Position.X, Position.Y);
            else
                v37 = u2.getMouseLocation();
            end;

            local WindowButton = u8.Instance.WindowButton;
            local v38 = fitPositionToWindowBounds(u8, v37 - u10);
            WindowButton.Position = UDim2.fromOffset(v38.X, v38.Y);
            u8.state.position.value = v38;
        end;

        if u12 and (u11 and u11.arguments.NoResize ~= true) then
            local WindowButton = u11.Instance.WindowButton;
            local Vector2_new_ret = Vector2.new(WindowButton.Position.X.Offset, WindowButton.Position.Y.Offset);
            local Vector2_new_ret2 = Vector2.new(WindowButton.Size.X.Offset, WindowButton.Size.Y.Offset);
            local v39;

            if p36.UserInputType == Enum.UserInputType.Touch then
                v39 = p36.Delta;
            else
                v39 = u2.getMouseLocation() - u15;
            end;

            local v40 = Vector2_new_ret + Vector2.new(Left ~= Enum.LeftRight.Left and 0 or v39.X, Top ~= Enum.TopBottom.Top and 0 or v39.Y);
            local v41;

            if Left == Enum.LeftRight.Left then
                v41 = -v39.X;
            else
                v41 = Left ~= Enum.LeftRight.Right and 0 or v39.X;
            end;

            local v42;

            if Top == Enum.TopBottom.Top then
                v42 = -v39.Y;
            else
                v42 = Top ~= Enum.TopBottom.Bottom and 0 or v39.Y;
            end;

            local v43 = fitSizeToWindowBounds(u11, Vector2_new_ret2 + Vector2.new(v41, v42));
            local v44 = fitPositionToWindowBounds(u11, v40);
            WindowButton.Size = UDim2.fromOffset(v43.X, v43.Y);
            u11.state.size.value = v43;
            WindowButton.Position = UDim2.fromOffset(v44.X, v44.Y);
            u11.state.position.value = v44;
        end;

        u15 = u2.getMouseLocation();
    end);
    u2.UserInputService.InputEnded:Connect(function(p45, p46) -- Line: 320
        -- upvalues: u9 (ref), u8 (ref), u12 (ref), u11 (ref), quickSwapWindows (copy)
        if (p45.UserInputType == Enum.UserInputType.MouseButton1 or p45.UserInputType == Enum.UserInputType.Touch) and (u9 and u8) then
            local WindowButton = u8.Instance.WindowButton;
            u9 = false;
            u8.state.position:set(Vector2.new(WindowButton.Position.X.Offset, WindowButton.Position.Y.Offset));
        end;

        if (p45.UserInputType == Enum.UserInputType.MouseButton1 or p45.UserInputType == Enum.UserInputType.Touch) and (u12 and u11) then
            u12 = false;
            u11.state.size:set(u11.Instance.WindowButton.AbsoluteSize);
        end;

        if p45.KeyCode == Enum.KeyCode.ButtonX then
            quickSwapWindows();
        end;
    end);
    u1.WidgetConstructor("Window", {
        hasState = true,
        hasChildren = true,
        Args = {
            Title = 1,
            NoTitleBar = 2,
            NoBackground = 3,
            NoCollapse = 4,
            NoClose = 5,
            NoMove = 6,
            NoScrollbar = 7,
            NoResize = 8,
            NoNav = 9,
            NoMenu = 10
        },
        Events = {
            closed = {
                Init = function(p47) -- Line: 363
                end,

                Get = function(p48) -- Line: 364
                    -- upvalues: u1 (copy)
                    return p48.lastClosedTick == u1._cycleTick;
                end
            },
            opened = {
                Init = function(p49) -- Line: 369
                end,

                Get = function(p50) -- Line: 370
                    -- upvalues: u1 (copy)
                    return p50.lastOpenedTick == u1._cycleTick;
                end
            },
            collapsed = {
                Init = function(p51) -- Line: 375
                end,

                Get = function(p52) -- Line: 376
                    -- upvalues: u1 (copy)
                    return p52.lastCollapsedTick == u1._cycleTick;
                end
            },
            uncollapsed = {
                Init = function(p53) -- Line: 381
                end,

                Get = function(p54) -- Line: 382
                    -- upvalues: u1 (copy)
                    return p54.lastUncollapsedTick == u1._cycleTick;
                end
            },
            hovered = u2.EVENTS.hover(function(p55) -- Line: 386
                return p55.Instance.WindowButton;
            end)
        },

        Generate = function(u56) -- Line: 391, Name: Generate
            -- upvalues: u1 (copy), u18 (copy), u2 (copy), u8 (ref), u9 (ref), u10 (ref), u17 (ref), u16 (ref), u12 (ref), Top (ref), Left (ref), u11 (ref), u13 (ref), u14 (ref)
            u56.parentWidget = u1._rootWidget;
            u56.usesScreenGUI = u1._config.UseScreenGUIs;
            u18[u56.ID] = u56;
            local v57;

            if u56.usesScreenGUI then
                v57 = Instance.new("ScreenGui");
                v57.ResetOnSpawn = false;
                v57.DisplayOrder = u1._config.DisplayOrderOffset;
                v57.IgnoreGuiInset = u1._config.IgnoreGuiInset;
            else
                v57 = Instance.new("Folder");
            end;

            v57.Name = "Iris_Window";
            local TextButton = Instance.new("TextButton");
            TextButton.Name = "WindowButton";
            TextButton.Size = UDim2.fromOffset(0, 0);
            TextButton.BackgroundTransparency = 1;
            TextButton.BorderSizePixel = 0;
            TextButton.Text = "";
            TextButton.ClipsDescendants = false;
            TextButton.AutoButtonColor = false;
            TextButton.Selectable = false;
            TextButton.SelectionImageObject = u1.SelectionImageObject;
            TextButton.ZIndex = u56.ZIndex + 1;
            TextButton.LayoutOrder = u56.ZIndex + 1;
            TextButton.SelectionGroup = true;
            TextButton.SelectionBehaviorUp = Enum.SelectionBehavior.Stop;
            TextButton.SelectionBehaviorDown = Enum.SelectionBehavior.Stop;
            TextButton.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop;
            TextButton.SelectionBehaviorRight = Enum.SelectionBehavior.Stop;
            u2.UIStroke(TextButton, u1._config.WindowBorderSize, u1._config.BorderColor, u1._config.BorderTransparency);
            TextButton.Parent = v57;
            TextButton.InputBegan:Connect(function(p58: userdata) -- Line: 431
                -- upvalues: u56 (copy), u1 (ref), u8 (ref), u9 (ref), u10 (ref), u2 (ref)
                if p58.UserInputType == Enum.UserInputType.MouseMovement or p58.UserInputType == Enum.UserInputType.Keyboard then
                    return;
                end;

                if u56.state.isUncollapsed.value then
                    u1.SetFocusedWindow(u56);
                end;

                if not u56.arguments.NoMove and p58.UserInputType == Enum.UserInputType.MouseButton1 then
                    u8 = u56;
                    u9 = true;
                    u10 = u2.getMouseLocation() - u56.state.position.value;
                end;
            end);
            local ScrollingFrame = Instance.new("ScrollingFrame");
            ScrollingFrame.Name = "ChildContainer";
            ScrollingFrame.Size = UDim2.fromScale(1, 1);
            ScrollingFrame.Position = UDim2.fromOffset(0, 0);
            ScrollingFrame.BackgroundColor3 = u1._config.WindowBgColor;
            ScrollingFrame.BackgroundTransparency = u1._config.WindowBgTransparency;
            ScrollingFrame.BorderSizePixel = 0;
            ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;
            ScrollingFrame.ScrollBarImageTransparency = u1._config.ScrollbarGrabTransparency;
            ScrollingFrame.ScrollBarImageColor3 = u1._config.ScrollbarGrabColor;
            ScrollingFrame.CanvasSize = UDim2.fromScale(0, 1);
            ScrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar;
            ScrollingFrame.ZIndex = u56.ZIndex + 3;
            ScrollingFrame.LayoutOrder = u56.ZIndex + 3;
            ScrollingFrame.ClipsDescendants = true;
            u2.UIPadding(ScrollingFrame, u1._config.WindowPadding);
            ScrollingFrame.Parent = TextButton;
            ScrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- Line: 467
                -- upvalues: u56 (copy), ScrollingFrame (copy)
                u56.state.scrollDistance.value = ScrollingFrame.CanvasPosition.Y;
            end);
            ScrollingFrame.InputBegan:Connect(function(p59: userdata) -- Line: 472
                -- upvalues: u56 (copy), u1 (ref)
                if p59.UserInputType == Enum.UserInputType.MouseMovement or p59.UserInputType == Enum.UserInputType.Keyboard then
                    return;
                end;

                if u56.state.isUncollapsed.value then
                    u1.SetFocusedWindow(u56);
                end;
            end);
            local Frame = Instance.new("Frame");
            Frame.Name = "TerminatingFrame";
            Frame.Size = UDim2.fromOffset(0, u1._config.WindowPadding.Y + u1._config.FramePadding.Y);
            Frame.BackgroundTransparency = 1;
            Frame.BorderSizePixel = 0;
            Frame.LayoutOrder = 2147483632;
            u2.UIListLayout(ScrollingFrame, Enum.FillDirection.Vertical, UDim.new(0, u1._config.ItemSpacing.Y)).VerticalAlignment = Enum.VerticalAlignment.Top;
            Frame.Parent = ScrollingFrame;
            local Frame2 = Instance.new("Frame");
            Frame2.Name = "TitleBar";
            Frame2.Size = UDim2.fromScale(1, 0);
            Frame2.AutomaticSize = Enum.AutomaticSize.Y;
            Frame2.BorderSizePixel = 0;
            Frame2.ZIndex = u56.ZIndex + 1;
            Frame2.LayoutOrder = u56.ZIndex + 1;
            Frame2.ClipsDescendants = true;
            Frame2.Parent = TextButton;
            Frame2.InputBegan:Connect(function(p60: userdata) -- Line: 505
                -- upvalues: u56 (copy), u8 (ref), u9 (ref), u10 (ref)
                if p60.UserInputType == Enum.UserInputType.Touch and not u56.arguments.NoMove then
                    u8 = u56;
                    u9 = true;
                    local Position = p60.Position;
                    u10 = Vector2.new(Position.X, Position.Y) - u56.state.position.value;
                end;
            end);
            local v61 = u1._config.TextSize + (u1._config.FramePadding.Y - 1) * 2;
            local TextButton2 = Instance.new("TextButton");
            TextButton2.Name = "CollapseButton";
            TextButton2.AnchorPoint = Vector2.new(0, 0.5);
            TextButton2.Size = UDim2.fromOffset(v61, v61);
            TextButton2.Position = UDim2.new(0, u1._config.FramePadding.X + 1, 0.5, 0);
            TextButton2.AutomaticSize = Enum.AutomaticSize.None;
            TextButton2.BackgroundTransparency = 1;
            TextButton2.BorderSizePixel = 0;
            TextButton2.AutoButtonColor = false;
            TextButton2.Text = "";
            TextButton2.ZIndex = u56.ZIndex + 4;
            u2.UICorner(TextButton2);
            TextButton2.Parent = Frame2;
            TextButton2.MouseButton1Click:Connect(function() -- Line: 534
                -- upvalues: u56 (copy)
                u56.state.isUncollapsed:set(not u56.state.isUncollapsed.value);
            end);
            u2.applyInteractionHighlights(TextButton2, TextButton2, {
                ButtonTransparency = 1,
                ButtonColor = u1._config.ButtonColor,
                ButtonHoveredColor = u1._config.ButtonHoveredColor,
                ButtonHoveredTransparency = u1._config.ButtonHoveredTransparency,
                ButtonActiveColor = u1._config.ButtonActiveColor,
                ButtonActiveTransparency = u1._config.ButtonActiveTransparency
            });
            local ImageLabel = Instance.new("ImageLabel");
            ImageLabel.Name = "Arrow";
            ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
            ImageLabel.Size = UDim2.fromOffset(math.floor(v61 * 0.7), (math.floor(v61 * 0.7)));
            ImageLabel.Position = UDim2.fromScale(0.5, 0.5);
            ImageLabel.BackgroundTransparency = 1;
            ImageLabel.BorderSizePixel = 0;
            ImageLabel.Image = u2.ICONS.MULTIPLICATION_SIGN;
            ImageLabel.ImageColor3 = u1._config.TextColor;
            ImageLabel.ImageTransparency = u1._config.TextTransparency;
            ImageLabel.ZIndex = u56.ZIndex + 5;
            ImageLabel.Parent = TextButton2;
            local TextButton3 = Instance.new("TextButton");
            TextButton3.Name = "CloseButton";
            TextButton3.AnchorPoint = Vector2.new(1, 0.5);
            TextButton3.Size = UDim2.fromOffset(v61, v61);
            TextButton3.Position = UDim2.new(1, -(u1._config.FramePadding.X + 1), 0.5, 0);
            TextButton3.AutomaticSize = Enum.AutomaticSize.None;
            TextButton3.BackgroundTransparency = 1;
            TextButton3.BorderSizePixel = 0;
            TextButton3.Text = "";
            TextButton3.ZIndex = u56.ZIndex + 4;
            TextButton3.AutoButtonColor = false;
            u2.UICorner(TextButton3);
            TextButton3.MouseButton1Click:Connect(function() -- Line: 575
                -- upvalues: u56 (copy)
                u56.state.isOpened:set(false);
            end);
            u2.applyInteractionHighlights(TextButton3, TextButton3, {
                ButtonTransparency = 1,
                ButtonColor = u1._config.ButtonColor,
                ButtonHoveredColor = u1._config.ButtonHoveredColor,
                ButtonHoveredTransparency = u1._config.ButtonHoveredTransparency,
                ButtonActiveColor = u1._config.ButtonActiveColor,
                ButtonActiveTransparency = u1._config.ButtonActiveTransparency
            });
            TextButton3.Parent = Frame2;
            local ImageLabel2 = Instance.new("ImageLabel");
            ImageLabel2.Name = "Icon";
            ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5);
            ImageLabel2.Size = UDim2.fromOffset(math.floor(v61 * 0.7), (math.floor(v61 * 0.7)));
            ImageLabel2.Position = UDim2.fromScale(0.5, 0.5);
            ImageLabel2.BackgroundTransparency = 1;
            ImageLabel2.BorderSizePixel = 0;
            ImageLabel2.Image = u2.ICONS.MULTIPLICATION_SIGN;
            ImageLabel2.ImageColor3 = u1._config.TextColor;
            ImageLabel2.ImageTransparency = u1._config.TextTransparency;
            ImageLabel2.ZIndex = u56.ZIndex + 5;
            ImageLabel2.Parent = TextButton3;
            local v62 = u1._config.WindowTitleAlign == Enum.LeftRight.Left and 0 or (u1._config.WindowTitleAlign == Enum.LeftRight.Center and 0.5 or 1);
            local TextLabel = Instance.new("TextLabel");
            TextLabel.Name = "Title";
            TextLabel.AnchorPoint = Vector2.new(v62, 0);
            TextLabel.Position = UDim2.fromScale(v62, 0);
            TextLabel.AutomaticSize = Enum.AutomaticSize.XY;
            TextLabel.BorderSizePixel = 0;
            TextLabel.BackgroundTransparency = 1;
            TextLabel.ZIndex = u56.ZIndex + 3;
            u2.applyTextStyle(TextLabel);
            u2.UIPadding(TextLabel, u1._config.FramePadding);
            TextLabel.Parent = Frame2;
            local v63 = u1._config.TextSize + u1._config.FramePadding.X;
            local TextButton4 = Instance.new("TextButton");
            TextButton4.Name = "ResizeGrip";
            TextButton4.AnchorPoint = Vector2.new(1, 1);
            TextButton4.Size = UDim2.fromOffset(v63, v63);
            TextButton4.Position = UDim2.fromScale(1, 1);
            TextButton4.AutoButtonColor = false;
            TextButton4.BorderSizePixel = 0;
            TextButton4.BackgroundTransparency = 1;
            TextButton4.Text = u2.ICONS.BOTTOM_RIGHT_CORNER;
            TextButton4.TextSize = v63;
            TextButton4.TextColor3 = u1._config.ButtonColor;
            TextButton4.TextTransparency = u1._config.ButtonTransparency;
            TextButton4.LineHeight = 1.1;
            TextButton4.Selectable = false;
            TextButton4.ZIndex = u56.ZIndex + 3;
            TextButton4.Parent = TextButton;
            u2.applyTextInteractionHighlights(TextButton4, TextButton4, {
                ButtonColor = u1._config.ButtonColor,
                ButtonTransparency = u1._config.ButtonTransparency,
                ButtonHoveredColor = u1._config.ButtonHoveredColor,
                ButtonHoveredTransparency = u1._config.ButtonHoveredTransparency,
                ButtonActiveColor = u1._config.ButtonActiveColor,
                ButtonActiveTransparency = u1._config.ButtonActiveTransparency
            });
            TextButton4.MouseButton1Down:Connect(function() -- Line: 656
                -- upvalues: u17 (ref), u16 (ref), u56 (copy), u1 (ref), u12 (ref), Top (ref), Left (ref), u11 (ref)
                if not u17 or u16 ~= u56 then
                    u1.SetFocusedWindow(u56);
                end;

                u12 = true;
                Top = Enum.TopBottom.Bottom;
                Left = Enum.LeftRight.Right;
                u11 = u56;
            end);
            local TextButton5 = Instance.new("TextButton");
            TextButton5.Name = "ResizeBorder";
            TextButton5.Size = UDim2.new(1, u1._config.WindowResizePadding.X * 2, 1, u1._config.WindowResizePadding.Y * 2);
            TextButton5.Position = UDim2.fromOffset(-u1._config.WindowResizePadding.X, -u1._config.WindowResizePadding.Y);
            TextButton5.BackgroundTransparency = 1;
            TextButton5.BorderSizePixel = 0;
            TextButton5.Text = "";
            TextButton5.AutoButtonColor = false;
            TextButton5.Active = true;
            TextButton5.Selectable = false;
            TextButton5.ZIndex = u56.ZIndex;
            TextButton5.LayoutOrder = u56.ZIndex;
            TextButton5.ClipsDescendants = false;
            TextButton5.Parent = TextButton;
            TextButton5.MouseEnter:Connect(function() -- Line: 682
                -- upvalues: u16 (ref), u56 (copy), u13 (ref)
                if u16 == u56 then
                    u13 = true;
                end;
            end);
            TextButton5.MouseLeave:Connect(function() -- Line: 687
                -- upvalues: u16 (ref), u56 (copy), u13 (ref)
                if u16 == u56 then
                    u13 = false;
                end;
            end);
            TextButton.MouseEnter:Connect(function() -- Line: 693
                -- upvalues: u16 (ref), u56 (copy), u14 (ref)
                if u16 == u56 then
                    u14 = true;
                end;
            end);
            TextButton.MouseLeave:Connect(function() -- Line: 698
                -- upvalues: u16 (ref), u56 (copy), u14 (ref)
                if u16 == u56 then
                    u14 = false;
                end;
            end);

            return v57;
        end,

        Update = function(p64) -- Line: 706, Name: Update
            -- upvalues: u1 (copy)
            local WindowButton = p64.Instance.WindowButton;
            local TitleBar = WindowButton.TitleBar;
            local Title = TitleBar.Title;
            local MenuBar = WindowButton:FindFirstChild("MenuBar");
            local ChildContainer = WindowButton.ChildContainer;
            local ResizeGrip = WindowButton.ResizeGrip;
            local v65 = 0;
            local v66 = 0;

            if p64.arguments.NoResize == true then
                ResizeGrip.Visible = false;
            else
                ResizeGrip.Visible = true;
            end;

            if p64.arguments.NoScrollbar then
                ChildContainer.ScrollBarThickness = 0;
            else
                ChildContainer.ScrollBarThickness = u1._config.ScrollbarSize;
            end;

            if p64.arguments.NoTitleBar then
                TitleBar.Visible = false;
            else
                TitleBar.Visible = true;
                local Y = TitleBar.AbsoluteSize.Y;
                v65 = v65 + Y;
                v66 = v66 + Y;
            end;

            if MenuBar then
                if p64.arguments.NoMenu then
                    MenuBar.Visible = false;
                else
                    MenuBar.Visible = true;
                    v65 = v65 + MenuBar.AbsoluteSize.Y;
                end;

                MenuBar.Position = UDim2.fromOffset(0, v66);
            end;

            if p64.arguments.NoBackground then
                ChildContainer.BackgroundTransparency = 1;
            else
                ChildContainer.BackgroundTransparency = u1._config.WindowBgTransparency;
            end;

            local v67 = u1._config.FramePadding.X + u1._config.TextSize + u1._config.FramePadding.X * 2;

            if p64.arguments.NoCollapse then
                TitleBar.CollapseButton.Visible = false;
                TitleBar.Title.UIPadding.PaddingLeft = UDim.new(0, u1._config.FramePadding.X);
            else
                TitleBar.CollapseButton.Visible = true;
                TitleBar.Title.UIPadding.PaddingLeft = UDim.new(0, v67);
            end;

            if p64.arguments.NoClose then
                TitleBar.CloseButton.Visible = false;
                TitleBar.Title.UIPadding.PaddingRight = UDim.new(0, u1._config.FramePadding.X);
            else
                TitleBar.CloseButton.Visible = true;
                TitleBar.Title.UIPadding.PaddingRight = UDim.new(0, v67);
            end;

            ChildContainer.Size = UDim2.new(1, 0, 1, -v65);
            ChildContainer.CanvasSize = UDim2.new(0, 0, 1, -v65);
            ChildContainer.Position = UDim2.fromOffset(0, v65);
            Title.Text = p64.arguments.Title or "";
        end,

        Discard = function(p68) -- Line: 776, Name: Discard
            -- upvalues: u16 (ref), u17 (ref), u8 (ref), u9 (ref), u11 (ref), u12 (ref), u18 (copy), u2 (copy)
            if u16 == p68 then
                u16 = nil;
                u17 = false;
            end;

            if u8 == p68 then
                u8 = nil;
                u9 = false;
            end;

            if u11 == p68 then
                u11 = nil;
                u12 = false;
            end;

            u18[p68.ID] = nil;
            p68.Instance:Destroy();
            u2.discardState(p68);
        end,

        ChildAdded = function(p69) -- Line: 793, Name: ChildAdded
            return p69.Instance.WindowButton.ChildContainer;
        end,

        UpdateState = function(p70) -- Line: 798, Name: UpdateState
            -- upvalues: u1 (copy), u2 (copy)
            local value = p70.state.size.value;
            local value2 = p70.state.position.value;
            local value3 = p70.state.isUncollapsed.value;
            local value4 = p70.state.isOpened.value;
            local value5 = p70.state.scrollDistance.value;
            local Instance2 = p70.Instance;
            local WindowButton = Instance2.WindowButton;
            local TitleBar = WindowButton.TitleBar;
            local ChildContainer = WindowButton.ChildContainer;
            local ResizeGrip = WindowButton.ResizeGrip;
            WindowButton.Size = UDim2.fromOffset(value.X, value.Y);
            WindowButton.Position = UDim2.fromOffset(value2.X, value2.Y);

            if value4 then
                if p70.usesScreenGUI then
                    Instance2.Enabled = true;
                    WindowButton.Visible = true;
                else
                    WindowButton.Visible = true;
                end;

                p70.lastOpenedTick = u1._cycleTick + 1;
            else
                if p70.usesScreenGUI then
                    Instance2.Enabled = false;
                    WindowButton.Visible = false;
                else
                    WindowButton.Visible = false;
                end;

                p70.lastClosedTick = u1._cycleTick + 1;
            end;

            if value3 then
                TitleBar.CollapseButton.Arrow.Image = u2.ICONS.DOWN_POINTING_TRIANGLE;
                ChildContainer.Visible = true;

                if p70.arguments.NoResize ~= true then
                    ResizeGrip.Visible = true;
                end;

                WindowButton.AutomaticSize = Enum.AutomaticSize.None;
                p70.lastUncollapsedTick = u1._cycleTick + 1;
            else
                local Y = TitleBar.AbsoluteSize.Y;
                TitleBar.CollapseButton.Arrow.Image = u2.ICONS.RIGHT_POINTING_TRIANGLE;
                ChildContainer.Visible = false;
                ResizeGrip.Visible = false;
                WindowButton.Size = UDim2.fromOffset(value.X, Y);
                p70.lastCollapsedTick = u1._cycleTick + 1;
            end;

            if value4 and value3 then
                u1.SetFocusedWindow(p70);
            else
                TitleBar.BackgroundColor3 = u1._config.TitleBgCollapsedColor;
                TitleBar.BackgroundTransparency = u1._config.TitleBgCollapsedTransparency;
                WindowButton.UIStroke.Color = u1._config.BorderColor;
                u1.SetFocusedWindow(nil);
            end;

            if value5 and value5 ~= 0 then
                local u71 = #u1._postCycleCallbacks + 1;
                local u72 = u1._cycleTick + 1;

                u1._postCycleCallbacks[u71] = function() -- Line: 864
                    -- upvalues: u1 (ref), u72 (copy), ChildContainer (copy), value5 (copy), u71 (copy)
                    if u1._cycleTick == u72 then
                        ChildContainer.CanvasPosition = Vector2.new(0, value5);
                        u1._postCycleCallbacks[u71] = nil;
                    end;
                end;
            end;
        end,

        GenerateState = function(p73) -- Line: 872, Name: GenerateState
            -- upvalues: u1 (copy), u17 (ref), u16 (ref), fitPositionToWindowBounds (copy), fitSizeToWindowBounds (copy)
            if p73.state.size == nil then
                p73.state.size = u1._widgetState(p73, "size", Vector2.new(400, 300));
            end;

            if p73.state.position == nil then
                local state = p73.state;
                local _widgetState = u1._widgetState;
                local v74;

                if u17 and u16 then
                    v74 = u16.state.position.value + Vector2.new(15, 45);
                else
                    v74 = Vector2.new(150, 250);
                end;

                state.position = _widgetState(p73, "position", v74);
            end;

            p73.state.position.value = fitPositionToWindowBounds(p73, p73.state.position.value);
            p73.state.size.value = fitSizeToWindowBounds(p73, p73.state.size.value);

            if p73.state.isUncollapsed == nil then
                p73.state.isUncollapsed = u1._widgetState(p73, "isUncollapsed", true);
            end;

            if p73.state.isOpened == nil then
                p73.state.isOpened = u1._widgetState(p73, "isOpened", true);
            end;

            if p73.state.scrollDistance == nil then
                p73.state.scrollDistance = u1._widgetState(p73, "scrollDistance", 0);
            end;
        end
    });
end;
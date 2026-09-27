-- Decompiled with Potassium's decompiler.

return function(u1) -- Line: 1
    local ScrollingFrame = Instance.new("ScrollingFrame");
    ScrollingFrame.Name = "Menu";
    ScrollingFrame.BackgroundTransparency = 1;
    ScrollingFrame.Visible = true;
    ScrollingFrame.ZIndex = 1;
    ScrollingFrame.Size = UDim2.fromScale(1, 1);
    ScrollingFrame.ClipsDescendants = true;
    ScrollingFrame.TopImage = "";
    ScrollingFrame.BottomImage = "";
    ScrollingFrame.HorizontalScrollBarInset = Enum.ScrollBarInset.Always;
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 1, -1);
    ScrollingFrame.ScrollingEnabled = true;
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X;
    ScrollingFrame.ZIndex = 20;
    ScrollingFrame.ScrollBarThickness = 3;
    ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255);
    ScrollingFrame.ScrollBarImageTransparency = 0.8;
    ScrollingFrame.BorderSizePixel = 0;
    ScrollingFrame.Selectable = false;
    local iconModule = require(u1.iconModule);
    local u2 = iconModule.container.TopbarStandard:FindFirstChild("UIListLayout", true):Clone();
    u2.Name = "MenuUIListLayout";
    u2.VerticalAlignment = Enum.VerticalAlignment.Center;
    u2.Parent = ScrollingFrame;
    local Frame = Instance.new("Frame");
    Frame.Name = "MenuGap";
    Frame.BackgroundTransparency = 1;
    Frame.Visible = false;
    Frame.AnchorPoint = Vector2.new(0, 0.5);
    Frame.ZIndex = 5;
    Frame.Parent = ScrollingFrame;
    local u3 = false;
    local Themes = require(script.Parent.Parent.Features.Themes);
    u1.menuChildAdded:Connect(function() -- Line: 39, Name: totalChildrenChanged
        -- upvalues: u1 (copy), u3 (ref), ScrollingFrame (copy), Themes (copy), u2 (copy)
        local menuJanitor = u1.menuJanitor;
        local v4 = #u1.menuIcons;

        if u3 then
            if v4 <= 0 then
                menuJanitor:clean();
                u3 = false;
            end;

            return;
        end;

        u3 = true;
        menuJanitor:add(u1.toggled:Connect(function() -- Line: 53
            -- upvalues: u1 (ref)
            if #u1.menuIcons > 0 then
                u1.updateSize:Fire();
            end;
        end));
        local _, u5 = u1:modifyTheme({ { "Menu", "Active", true } });
        task.defer(function() -- Line: 63
            -- upvalues: menuJanitor (copy), u1 (ref), u5 (copy)
            menuJanitor:add(function() -- Line: 64
                -- upvalues: u1 (ref), u5 (ref)
                u1:removeModification(u5);
            end);
        end);
        local X = ScrollingFrame.AbsoluteCanvasSize.X;

        local function rightAlignCanvas() -- Line: 73
            -- upvalues: u1 (ref), ScrollingFrame (ref), X (ref)
            if u1.alignment == "Right" then
                local X2 = ScrollingFrame.AbsoluteCanvasSize.X;
                local v6 = X - X2;
                X = X2;
                ScrollingFrame.CanvasPosition = Vector2.new(ScrollingFrame.CanvasPosition.X - v6, 0);
            end;
        end;

        menuJanitor:add(u1.selected:Connect(rightAlignCanvas));
        menuJanitor:add(ScrollingFrame:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(rightAlignCanvas));
        local StateGroup = u1:getStateGroup();

        if Themes.getThemeValue(StateGroup, "IconImage", "Image", "Deselected") == Themes.getThemeValue(StateGroup, "IconImage", "Image", "Selected") then
            local Font_new_ret = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Light, Enum.FontStyle.Normal);
            u1:removeModificationWith("IconLabel", "Text", "Viewing");
            u1:removeModificationWith("IconLabel", "Image", "Viewing");
            u1:modifyTheme({
                {
                    "IconLabel",
                    "FontFace",
                    Font_new_ret,
                    "Selected"
                },
                { "IconLabel", "Text", "X", "Selected" },
                { "IconLabel", "TextSize", 20, "Selected" },
                { "IconLabel", "TextStrokeTransparency", 0.8, "Selected" },
                { "IconImage", "Image", "", "Selected" }
            });
        end;

        local Instance2 = u1:getInstance("MenuGap");
        menuJanitor:add(u1.alignmentChanged:Connect(function() -- Line: 104, Name: updateAlignent
            -- upvalues: u1 (ref), Instance2 (copy)
            local v7, v8;

            if u1.alignment == "Right" then
                v7 = 99999;
                v8 = 99998;
            else
                v7 = -99999;
                v8 = -99998;
            end;

            u1:modifyTheme({ "IconSpot", "LayoutOrder", v7 });
            Instance2.LayoutOrder = v8;
        end));
        local v9, v10;

        if u1.alignment == "Right" then
            v9 = 99999;
            v10 = 99998;
        else
            v9 = -99999;
            v10 = -99998;
        end;

        u1:modifyTheme({ "IconSpot", "LayoutOrder", v9 });
        Instance2.LayoutOrder = v10;
        ScrollingFrame:GetAttributeChangedSignal("MenuCanvasWidth"):Connect(function() -- Line: 120
            -- upvalues: ScrollingFrame (ref)
            local Attribute = ScrollingFrame:GetAttribute("MenuCanvasWidth");
            local Y = ScrollingFrame.CanvasSize.Y;
            ScrollingFrame.CanvasSize = UDim2.new(0, Attribute, Y.Scale, Y.Offset);
        end);
        menuJanitor:add(u1.updateMenu:Connect(function() -- Line: 125
            -- upvalues: ScrollingFrame (ref), u2 (ref)
            local Attribute = ScrollingFrame:GetAttribute("MaxIcons");

            if not Attribute then
                return;
            end;

            local v11 = {};

            for _, child in pairs(ScrollingFrame:GetChildren()) do
                if child:GetAttribute("WidgetUID") and child.Visible then
                    table.insert(v11, { child, child.AbsolutePosition.X });
                end;
            end;

            table.sort(v11, function(p12, p13) -- Line: 137
                return p12[2] < p13[2];
            end);
            local v14 = 0;

            for i = 1, Attribute do
                local v15 = v11[i];

                if not v15 then
                    break;
                end;

                v14 = v14 + (v15[1].AbsoluteSize.X + u2.Padding.Offset);
                local _ = i;
            end;

            ScrollingFrame:SetAttribute("MenuWidth", v14);
        end));

        local function startMenuUpdate() -- Line: 152
            -- upvalues: u1 (ref)
            task.delay(0.1, function() -- Line: 153
                -- upvalues: u1 (ref)
                u1.startMenuUpdate:Fire();
            end);
        end;

        menuJanitor:add(ScrollingFrame.ChildAdded:Connect(startMenuUpdate));
        menuJanitor:add(ScrollingFrame.ChildRemoved:Connect(startMenuUpdate));
        menuJanitor:add(ScrollingFrame:GetAttributeChangedSignal("MaxIcons"):Connect(startMenuUpdate));
        menuJanitor:add(ScrollingFrame:GetAttributeChangedSignal("MaxWidth"):Connect(startMenuUpdate));
        task.delay(0.1, function() -- Line: 153
            -- upvalues: u1 (ref)
            u1.startMenuUpdate:Fire();
        end);
    end);
    u1.menuSet:Connect(function(p16) -- Line: 165
        -- upvalues: u1 (copy), iconModule (copy)
        for _, v in pairs(u1.menuIcons) do
            iconModule.getIconByUID(v):destroy();
        end;

        if type(p16) == "table" then
            for _, v in pairs(p16) do
                v:joinMenu(u1);
            end;
        end;
    end);

    return ScrollingFrame;
end;
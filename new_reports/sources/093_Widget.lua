-- Decompiled with Potassium's decompiler.

return function(u1, u2) -- Line: 6
    local Frame = Instance.new("Frame");
    Frame:SetAttribute("WidgetUID", u1.UID);
    Frame.Name = "Widget";
    Frame.BackgroundTransparency = 1;
    Frame.Visible = true;
    Frame.ZIndex = 20;
    Frame.Active = false;
    Frame.ClipsDescendants = true;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "IconButton";
    Frame2.Visible = true;
    Frame2.ZIndex = 2;
    Frame2.BorderSizePixel = 0;
    Frame2.Parent = Frame;
    Frame2.ClipsDescendants = true;
    Frame2.Active = false;
    u1.deselected:Connect(function() -- Line: 25
        -- upvalues: Frame2 (copy), u1 (copy)
        Frame2.ClipsDescendants = true;
        task.delay(0.2, function() -- Line: 27
            -- upvalues: u1 (ref), Frame2 (ref)
            if u1.isSelected then
                Frame2.ClipsDescendants = false;
            end;
        end);
    end);
    local GuiService = game:GetService("GuiService");
    u1:setBehaviour("IconButton", "BackgroundTransparency", function(p3) -- Line: 36
        -- upvalues: GuiService (copy)
        if p3 == 1 then
            return p3;
        end;

        return p3 * GuiService.PreferredTransparency;
    end);
    u1.janitor:add(GuiService:GetPropertyChangedSignal("PreferredTransparency"):Connect(function() -- Line: 44
        -- upvalues: u1 (copy), Frame2 (copy)
        u1:refreshAppearance(Frame2, "BackgroundTransparency");
    end));
    local UICorner = Instance.new("UICorner");
    UICorner:SetAttribute("Collective", "IconCorners");
    UICorner.Name = "UICorner";
    UICorner.Parent = Frame2;
    local u4 = require(script.Parent.Menu)(u1);
    local MenuUIListLayout = u4.MenuUIListLayout;
    local MenuGap = u4.MenuGap;
    u4.Parent = Frame2;
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "IconSpot";
    Frame3.BackgroundColor3 = Color3.fromRGB(225, 225, 225);
    Frame3.BackgroundTransparency = 0.9;
    Frame3.Visible = true;
    Frame3.AnchorPoint = Vector2.new(0, 0.5);
    Frame3.ZIndex = 5;
    Frame3.Parent = u4;
    UICorner:Clone().Parent = Frame3;
    local v5 = Frame3:Clone();
    v5.UICorner.Name = "OverlayUICorner";
    v5.Name = "IconOverlay";
    v5.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    v5.ZIndex = Frame3.ZIndex + 1;
    v5.Size = UDim2.new(1, 0, 1, 0);
    v5.Position = UDim2.new(0, 0, 0, 0);
    v5.AnchorPoint = Vector2.new(0, 0);
    v5.Visible = false;
    v5.Parent = Frame3;
    local TextButton = Instance.new("TextButton");
    TextButton:SetAttribute("CorrespondingIconUID", u1.UID);
    TextButton.Name = "ClickRegion";
    TextButton.BackgroundTransparency = 1;
    TextButton.Visible = true;
    TextButton.Text = "";
    TextButton.ZIndex = 20;
    TextButton.Selectable = true;
    TextButton.SelectionGroup = true;
    TextButton.Parent = Frame3;
    require(script.Parent.Parent.Features.Gamepad).registerButton(TextButton);
    UICorner:Clone().Parent = TextButton;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Contents";
    Frame4.BackgroundTransparency = 1;
    Frame4.Size = UDim2.fromScale(1, 1);
    Frame4.Parent = Frame3;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.Name = "ContentsList";
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalFlex = Enum.UIFlexAlignment.SpaceEvenly;
    UIListLayout.Padding = UDim.new(0, 3);
    UIListLayout.Parent = Frame4;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "PaddingLeft";
    Frame5.LayoutOrder = 1;
    Frame5.ZIndex = 5;
    Frame5.BorderColor3 = Color3.fromRGB(0, 0, 0);
    Frame5.BackgroundTransparency = 1;
    Frame5.BorderSizePixel = 0;
    Frame5.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    Frame5.Parent = Frame4;
    local Frame6 = Instance.new("Frame");
    Frame6.Name = "PaddingCenter";
    Frame6.LayoutOrder = 3;
    Frame6.ZIndex = 5;
    Frame6.Size = UDim2.new(0, 0, 1, 0);
    Frame6.BorderColor3 = Color3.fromRGB(0, 0, 0);
    Frame6.BackgroundTransparency = 1;
    Frame6.BorderSizePixel = 0;
    Frame6.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    Frame6.Parent = Frame4;
    local Frame7 = Instance.new("Frame");
    Frame7.Name = "PaddingRight";
    Frame7.LayoutOrder = 5;
    Frame7.ZIndex = 5;
    Frame7.BorderColor3 = Color3.fromRGB(0, 0, 0);
    Frame7.BackgroundTransparency = 1;
    Frame7.BorderSizePixel = 0;
    Frame7.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    Frame7.Parent = Frame4;
    local Frame8 = Instance.new("Frame");
    Frame8.Name = "IconLabelContainer";
    Frame8.LayoutOrder = 4;
    Frame8.ZIndex = 3;
    Frame8.AnchorPoint = Vector2.new(0, 0.5);
    Frame8.Size = UDim2.new(0, 0, 0.5, 0);
    Frame8.BackgroundTransparency = 1;
    Frame8.Position = UDim2.new(0.5, 0, 0.5, 0);
    Frame8.Parent = Frame4;
    local TextLabel = Instance.new("TextLabel");
    local u6 = workspace.CurrentCamera.ViewportSize.X + 200;
    TextLabel.Name = "IconLabel";
    TextLabel.LayoutOrder = 4;
    TextLabel.ZIndex = 15;
    TextLabel.AnchorPoint = Vector2.new(0, 0);
    TextLabel.Size = UDim2.new(0, u6, 1, 0);
    TextLabel.ClipsDescendants = false;
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Position = UDim2.fromScale(0, 0);
    TextLabel.RichText = true;
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255);
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.Text = "";
    TextLabel.TextWrapped = true;
    TextLabel.TextWrap = true;
    TextLabel.TextScaled = false;
    TextLabel.Active = false;
    TextLabel.AutoLocalize = true;
    TextLabel.Parent = Frame8;
    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "IconImage";
    ImageLabel.LayoutOrder = 2;
    ImageLabel.ZIndex = 15;
    ImageLabel.AnchorPoint = Vector2.new(0, 0.5);
    ImageLabel.Size = UDim2.new(0, 0, 0.5, 0);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.Position = UDim2.new(0, 11, 0.5, 0);
    ImageLabel.ScaleType = Enum.ScaleType.Stretch;
    ImageLabel.Active = false;
    ImageLabel.Parent = Frame4;
    local v7 = UICorner:Clone();
    v7:SetAttribute("Collective", nil);
    v7.CornerRadius = UDim.new(0, 0);
    v7.Name = "IconImageCorner";
    v7.Parent = ImageLabel;
    local TweenService = game:GetService("TweenService");
    local u8 = 0;

    local function handleLabelAndImageChangesUnstaggered(p9) -- Line: 195
        -- upvalues: u1 (copy), TextLabel (copy), ImageLabel (copy), Frame8 (copy), Frame5 (copy), Frame6 (copy), Frame7 (copy), Frame2 (copy), UIListLayout (copy), Frame4 (copy), Frame (copy), u6 (copy), u4 (copy), Frame3 (copy), MenuUIListLayout (copy), MenuGap (copy), TweenService (copy), TextButton (copy), u8 (ref), u2 (copy)
        task.defer(function() -- Line: 202
            -- upvalues: u1 (ref), TextLabel (ref), ImageLabel (ref), Frame8 (ref), Frame5 (ref), Frame6 (ref), Frame7 (ref), Frame2 (ref), UIListLayout (ref), Frame4 (ref), Frame (ref), u6 (ref), u4 (ref), Frame3 (ref), MenuUIListLayout (ref), MenuGap (ref), TweenService (ref), TextButton (ref), u8 (ref), u2 (ref)
            local indicator = u1.indicator;

            if indicator then
                indicator = indicator.Visible;
            end;

            local v10 = indicator or TextLabel.Text ~= "";
            local v11;

            if ImageLabel.Image == "" then
                v11 = false;
            else
                v11 = ImageLabel.Image ~= nil;
            end;

            local _ = Enum.HorizontalAlignment.Center;
            local UDim2_fromScale_ret = UDim2.fromScale(1, 1);

            if v11 and not v10 then
                Frame8.Visible = false;
                ImageLabel.Visible = true;
                Frame5.Visible = false;
                Frame6.Visible = false;
                Frame7.Visible = false;
            elseif v11 or not v10 then
                if v11 and v10 then
                    Frame8.Visible = true;
                    ImageLabel.Visible = true;
                    Frame5.Visible = true;
                    Frame6.Visible = not indicator;
                    Frame7.Visible = not indicator;
                    local _ = Enum.HorizontalAlignment.Left;
                end;
            else
                Frame8.Visible = true;
                ImageLabel.Visible = false;
                Frame5.Visible = true;
                Frame6.Visible = false;
                Frame7.Visible = true;
            end;

            Frame2.Size = UDim2_fromScale_ret;

            local function getItemWidth(p12) -- Line: 232
                return p12:GetAttribute("TargetWidth") or p12.AbsoluteSize.X;
            end;

            local Offset = UIListLayout.Padding.Offset;
            Frame8.Size = UDim2.new(0, TextLabel.TextBounds.X, TextLabel.Size.Y.Scale, 0);
            local v13 = Offset;

            for _, child in pairs(Frame4:GetChildren()) do
                if child:IsA("GuiObject") and child.Visible == true then
                    v13 = v13 + ((child:GetAttribute("TargetWidth") or child.AbsoluteSize.X) + Offset);
                end;
            end;

            local Attribute = Frame:GetAttribute("MinimumWidth");
            local Attribute2 = Frame:GetAttribute("MinimumHeight");
            local Attribute3 = Frame:GetAttribute("BorderSize");
            local math_clamp_ret = math.clamp(v13, Attribute, u6);
            local v14 = 0;
            local v15 = #u1.menuIcons > 0 and u1.isSelected;

            if v15 then
                for _, child in pairs(u4:GetChildren()) do
                    if child ~= Frame3 and (child:IsA("GuiObject") and child.Visible) then
                        v14 = v14 + ((child:GetAttribute("TargetWidth") or child.AbsoluteSize.X) + MenuUIListLayout.Padding.Offset);
                    end;
                end;

                if not Frame3.Visible then
                    local v16 = Frame3;
                    math_clamp_ret = math_clamp_ret - ((v16:GetAttribute("TargetWidth") or v16.AbsoluteSize.X) + MenuUIListLayout.Padding.Offset * 2 + Attribute3);
                end;

                v14 = v14 - Attribute3 * 0.5;
                math_clamp_ret = math_clamp_ret + (v14 - Attribute3 * 0.75);
            end;

            if v15 then
                v15 = Frame3.Visible;
            end;

            MenuGap.Visible = v15;
            local Attribute4 = Frame:GetAttribute("DesiredWidth");

            if Attribute4 then
                if math_clamp_ret >= Attribute4 then
                    Attribute4 = math_clamp_ret;
                end;
            else
                Attribute4 = math_clamp_ret;
            end;

            u1.updateMenu:Fire();
            local v17 = math.max(Attribute4 - v14, Attribute) - Attribute3 * 2;
            local Attribute5 = u4:GetAttribute("MenuWidth");

            if Attribute5 then
                Attribute5 = Attribute5 + v17 + MenuUIListLayout.Padding.Offset + 10;
            end;

            if Attribute5 then
                local Attribute6 = u4:GetAttribute("MaxWidth");

                if Attribute6 then
                    Attribute5 = math.max(Attribute6, Attribute);
                end;

                u4:SetAttribute("MenuCanvasWidth", Attribute4);

                if Attribute5 >= Attribute4 then
                    Attribute5 = Attribute4;
                end;
            else
                Attribute5 = Attribute4;
            end;

            local Quint = Enum.EasingStyle.Quint;
            local Out = Enum.EasingDirection.Out;
            local v18 = Frame3;
            local v19 = v18:GetAttribute("TargetWidth") or v18.AbsoluteSize.X;
            local math_max_ret = math.max(v17, v19, Frame3.AbsoluteSize.X);
            local v20 = Frame;
            local v21 = v20:GetAttribute("TargetWidth") or v20.AbsoluteSize.X;
            local math_max_ret2 = math.max(Attribute5, v21, Frame.AbsoluteSize.X);
            local TweenInfo_new_ret = TweenInfo.new(math_max_ret / 750, Quint, Out);
            local TweenInfo_new_ret2 = TweenInfo.new(math_max_ret2 / 750, Quint, Out);
            TweenService:Create(Frame3, TweenInfo_new_ret, {
                Position = UDim2.new(0, Attribute3, 0.5, 0),
                Size = UDim2.new(0, v17, 1, -Attribute3 * 2)
            }):Play();
            TweenService:Create(TextButton, TweenInfo_new_ret, {
                Size = UDim2.new(0, v17, 1, 0)
            }):Play();
            local UDim2_fromOffset_ret = UDim2.fromOffset(Attribute5, Attribute2);

            if Frame.Size.Y.Offset ~= Attribute2 then
                Frame.Size = UDim2_fromOffset_ret;
            end;

            Frame:SetAttribute("TargetWidth", UDim2_fromOffset_ret.X.Offset);
            TweenService:Create(Frame, TweenInfo_new_ret2, {
                Size = UDim2_fromOffset_ret
            }):Play();
            u8 = u8 + 1;

            for i = 1, TweenInfo_new_ret2.Time * 100 do
                task.delay(i / 100, function() -- Line: 314
                    -- upvalues: u2 (ref), u1 (ref)
                    u2.iconChanged:Fire(u1);
                end);
                local _ = i;
            end;

            task.delay(TweenInfo_new_ret2.Time - 0.2, function() -- Line: 318
                -- upvalues: u8 (ref), u1 (ref)
                u8 = u8 - 1;
                task.defer(function() -- Line: 320
                    -- upvalues: u8 (ref), u1 (ref)
                    if u8 == 0 then
                        u1.resizingComplete:Fire();
                    end;
                end);
            end);
            u1:updateParent();
        end);
    end;

    local u22 = require(script.Parent.Parent.Utility).createStagger(0.01, handleLabelAndImageChangesUnstaggered);
    local u23 = true;
    u1:setBehaviour("IconLabel", "Text", u22);
    u1:setBehaviour("IconLabel", "FontFace", function(p24) -- Line: 333
        -- upvalues: TextLabel (copy), u22 (copy), u23 (ref)
        if TextLabel.FontFace == p24 then
            return;
        end;

        task.spawn(function() -- Line: 338
            -- upvalues: u22 (ref), u23 (ref)
            u22();

            if u23 then
                u23 = false;

                for i = 1, 10 do
                    task.wait(1);
                    u22();
                    local _ = i;
                end;
            end;
        end);
    end);

    local function updateBorderSize() -- Line: 360
        -- upvalues: Frame (copy), u1 (copy), Frame3 (copy), u4 (copy), MenuGap (copy), MenuUIListLayout (copy), u22 (copy)
        task.defer(function() -- Line: 361
            -- upvalues: Frame (ref), u1 (ref), Frame3 (ref), u4 (ref), MenuGap (ref), MenuUIListLayout (ref), u22 (ref)
            local Attribute = Frame:GetAttribute("BorderSize");
            local alignment = u1.alignment;
            local v25;

            if Frame3.Visible == false then
                v25 = 0;
            elseif alignment == "Right" then
                v25 = -Attribute or Attribute;
            else
                v25 = Attribute;
            end;

            u4.Position = UDim2.new(0, v25, 0, 0);
            MenuGap.Size = UDim2.fromOffset(Attribute, 0);
            MenuUIListLayout.Padding = UDim.new(0, 0);
            u22();
        end);
    end;

    u1:setBehaviour("Widget", "BorderSize", updateBorderSize);
    u1:setBehaviour("IconSpot", "Visible", updateBorderSize);
    u1.startMenuUpdate:Connect(u22);
    u1.updateSize:Connect(u22);
    u1:setBehaviour("ContentsList", "HorizontalAlignment", u22);
    u1:setBehaviour("Widget", "Visible", u22);
    u1:setBehaviour("Widget", "DesiredWidth", u22);
    u1:setBehaviour("Widget", "MinimumWidth", u22);
    u1:setBehaviour("Widget", "MinimumHeight", u22);
    u1:setBehaviour("Indicator", "Visible", u22);
    u1:setBehaviour("IconImageRatio", "AspectRatio", u22);
    u1:setBehaviour("IconImage", "Image", function(p26) -- Line: 382
        -- upvalues: ImageLabel (copy), u22 (copy)
        local v27 = tonumber(p26) and "http://www.roblox.com/asset/?id=" .. p26 or (p26 or "");

        if ImageLabel.Image ~= v27 then
            u22();
        end;

        return v27;
    end);
    u1.alignmentChanged:Connect(function(p28) -- Line: 389
        -- upvalues: MenuUIListLayout (copy), Frame (copy), u1 (copy), Frame3 (copy), u4 (copy), MenuGap (copy), u22 (copy)
        MenuUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment[p28 == "Center" and "Left" or p28];
        task.defer(function() -- Line: 361
            -- upvalues: Frame (ref), u1 (ref), Frame3 (ref), u4 (ref), MenuGap (ref), MenuUIListLayout (ref), u22 (ref)
            local Attribute = Frame:GetAttribute("BorderSize");
            local alignment = u1.alignment;
            local v29;

            if Frame3.Visible == false then
                v29 = 0;
            elseif alignment == "Right" then
                v29 = -Attribute or Attribute;
            else
                v29 = Attribute;
            end;

            u4.Position = UDim2.new(0, v29, 0, 0);
            MenuGap.Size = UDim2.fromOffset(Attribute, 0);
            MenuUIListLayout.Padding = UDim.new(0, 0);
            u22();
        end);
    end);
    local LocalPlayer = game:GetService("Players").LocalPlayer;
    local LocaleId = LocalPlayer.LocaleId;
    u1.janitor:add(LocalPlayer:GetPropertyChangedSignal("LocaleId"):Connect(function() -- Line: 401
        -- upvalues: LocalPlayer (copy), LocaleId (ref), u1 (copy)
        task.delay(0.2, function() -- Line: 402
            -- upvalues: LocalPlayer (ref), LocaleId (ref), u1 (ref)
            local LocaleId2 = LocalPlayer.LocaleId;

            if LocaleId2 ~= LocaleId then
                LocaleId = LocaleId2;
                u1:refresh();
                task.wait(0.5);
                u1:refresh();
            end;
        end);
    end));
    local NumberValue = Instance.new("NumberValue");
    NumberValue.Name = "IconImageScale";
    NumberValue.Parent = ImageLabel;
    NumberValue:GetPropertyChangedSignal("Value"):Connect(function() -- Line: 416
        -- upvalues: ImageLabel (copy), NumberValue (copy)
        ImageLabel.Size = UDim2.new(NumberValue.Value, 0, NumberValue.Value, 0);
    end);
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.Name = "IconImageRatio";
    UIAspectRatioConstraint.AspectType = Enum.AspectType.FitWithinMaxSize;
    UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height;
    UIAspectRatioConstraint.Parent = ImageLabel;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "IconGradient";
    UIGradient.Enabled = true;
    UIGradient.Parent = Frame2;
    local UIGradient2 = Instance.new("UIGradient");
    UIGradient2.Name = "IconSpotGradient";
    UIGradient2.Enabled = true;
    UIGradient2.Parent = Frame3;

    return Frame;
end;
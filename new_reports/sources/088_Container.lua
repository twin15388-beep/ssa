-- Decompiled with Potassium's decompiler.

local u1 = false;
local u2 = 0;

return function(u3) -- Line: 3
    -- upvalues: u1 (ref), u2 (ref)
    local GuiService = game:GetService("GuiService");
    local Players = game:GetService("Players");
    local UserInputService = game:GetService("UserInputService");
    local v4 = {};
    local u5 = require(script.Parent.Parent.Packages.GoodSignal).new();
    local GuiInset = GuiService:GetGuiInset();
    local u6 = 0;
    local u7 = 0;
    local u8 = 0;
    local u9 = 0;
    local u10 = false;
    local u11 = false;

    local function checkInset(p12) -- Line: 20
        -- upvalues: GuiService (copy), u10 (ref), u11 (ref), UserInputService (copy), u3 (copy), u9 (ref), checkInset (copy), Players (copy), u1 (ref), GuiInset (ref), u6 (ref), u7 (ref), u8 (ref), u5 (copy), u2 (ref)
        local Height = GuiService.TopbarInset.Height;
        local v13 = Height <= 36;
        u10 = GuiService:IsTenFootInterface();
        u11 = UserInputService.VREnabled;
        u3.isOldTopbar = v13;
        u9 = u9 + 1;

        if Height == 0 and p12 == nil then
            task.defer(function() -- Line: 33
                -- upvalues: checkInset (ref)
                task.wait(8);
                checkInset("ForceConvertToOld");
            end);
        elseif u9 == 1 then
            task.delay(5, function() -- Line: 38
                -- upvalues: Players (ref), u9 (ref), checkInset (ref)
                Players.LocalPlayer:WaitForChild("PlayerGui");

                if u9 == 1 then
                    checkInset();
                end;
            end);
        end;

        if u3.isOldTopbar and not (u10 or (u11 or (u1 ~= false or Height == 0 and p12 ~= "ForceConvertToOld"))) then
            u1 = true;
            task.defer(function() -- Line: 50
                -- upvalues: u3 (ref), GuiService (ref)
                local Classic = require(script.Parent.Parent.Features.Themes.Classic);
                u3.modifyBaseTheme(Classic);

                local function decideToHideTopbar() -- Line: 57
                    -- upvalues: GuiService (ref), u3 (ref)
                    if GuiService.MenuIsOpen then
                        u3.setTopbarEnabled(false, true);

                        return;
                    end;

                    u3.setTopbarEnabled();
                end;

                GuiService:GetPropertyChangedSignal("MenuIsOpen"):Connect(decideToHideTopbar);

                if GuiService.MenuIsOpen then
                    u3.setTopbarEnabled(false, true);

                    return;
                end;

                u3.setTopbarEnabled();
            end);
        end;

        GuiInset = GuiService:GetGuiInset();
        u6 = v13 and 12 or GuiInset.Y - 50;
        u7 = v13 and 2 or 0;
        u8 = -2;

        if u10 then
            u6 = 10;
            u7 = 0;
        end;

        if GuiService.TopbarInset.Height == 0 and not u1 then
            u7 = u7 + 13;
            u8 = 50;
        end;

        u5:Fire(GuiInset);
        local Y = GuiInset.Y;

        if Y ~= u2 then
            u2 = Y;
            task.defer(function() -- Line: 88
                -- upvalues: u3 (ref), Y (copy)
                u3.insetHeightChanged:Fire(Y);
            end);
        end;
    end;

    GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(checkInset);
    checkInset("FirstTime");
    local ScreenGui = Instance.new("ScreenGui");
    u5:Connect(function() -- Line: 98
        -- upvalues: ScreenGui (copy), u6 (ref)
        ScreenGui:SetAttribute("StartInset", u6);
    end);
    ScreenGui.Name = "TopbarStandard";
    ScreenGui.Enabled = true;
    ScreenGui.DisplayOrder = u3.baseDisplayOrder;
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.ScreenInsets = Enum.ScreenInsets.TopbarSafeInsets;
    v4[ScreenGui.Name] = ScreenGui;
    u3.baseDisplayOrderChanged:Connect(function() -- Line: 109
        -- upvalues: ScreenGui (copy), u3 (copy)
        ScreenGui.DisplayOrder = u3.baseDisplayOrder;
    end);
    local Frame = Instance.new("Frame");
    Frame.Name = "Holders";
    Frame.BackgroundTransparency = 1;
    u5:Connect(function() -- Line: 116
        -- upvalues: u11 (ref), u10 (ref), u8 (ref), Frame (copy), u7 (ref)
        local v14 = u11 and 36 or 56;
        local v15;

        if u10 then
            v15 = UDim2.new(1, 0, 0, v14);
        else
            v15 = UDim2.new(1, 0, 1, u8);
        end;

        Frame.Position = UDim2.new(0, 0, 0, u7);
        Frame.Size = v15;
    end);
    Frame.Visible = true;
    Frame.ZIndex = 1;
    Frame.Parent = ScreenGui;
    local u16 = ScreenGui:Clone();
    local Holders = u16.Holders;

    local function updateCenteredHoldersHeight() -- Line: 128
        -- upvalues: Holders (copy), GuiService (copy), u8 (ref)
        Holders.Size = UDim2.new(1, 0, 0, GuiService.TopbarInset.Height + u8);
    end;

    u16.Name = "TopbarCentered";
    u16.DisplayOrder = u3.baseDisplayOrder;
    u16.ScreenInsets = Enum.ScreenInsets.None;
    u3.baseDisplayOrderChanged:Connect(function() -- Line: 134
        -- upvalues: u16 (copy), u3 (copy)
        u16.DisplayOrder = u3.baseDisplayOrder;
    end);
    v4[u16.Name] = u16;
    u5:Connect(updateCenteredHoldersHeight);
    Holders.Size = UDim2.new(1, 0, 0, GuiService.TopbarInset.Height + u8);
    local u17 = ScreenGui:Clone();
    u17.Name = u17.Name .. "Clipped";
    u17.DisplayOrder = u3.baseDisplayOrder + 1;
    u3.baseDisplayOrderChanged:Connect(function() -- Line: 145
        -- upvalues: u17 (copy), u3 (copy)
        u17.DisplayOrder = u3.baseDisplayOrder + 1;
    end);
    v4[u17.Name] = u17;
    local u18 = u16:Clone();
    u18.Name = u18.Name .. "Clipped";
    u18.DisplayOrder = u3.baseDisplayOrder + 1;
    u3.baseDisplayOrderChanged:Connect(function() -- Line: 153
        -- upvalues: u18 (copy), u3 (copy)
        u18.DisplayOrder = u3.baseDisplayOrder + 1;
    end);
    v4[u18.Name] = u18;
    local ScrollingFrame = Instance.new("ScrollingFrame");
    ScrollingFrame:SetAttribute("IsAHolder", true);
    ScrollingFrame.Name = "Left";
    u5:Connect(function() -- Line: 162
        -- upvalues: ScrollingFrame (copy), u6 (ref)
        ScrollingFrame.Position = UDim2.fromOffset(u6, 0);
    end);
    ScrollingFrame.Size = UDim2.new(1, -24, 1, 0);
    ScrollingFrame.BackgroundTransparency = 1;
    ScrollingFrame.Visible = true;
    ScrollingFrame.ZIndex = 1;
    ScrollingFrame.Active = false;
    ScrollingFrame.ClipsDescendants = true;
    ScrollingFrame.HorizontalScrollBarInset = Enum.ScrollBarInset.None;
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 1, -1);
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.X;
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X;
    ScrollingFrame.ScrollBarThickness = 0;
    ScrollingFrame.BorderSizePixel = 0;
    ScrollingFrame.Selectable = false;
    ScrollingFrame.ScrollingEnabled = false;
    ScrollingFrame.ElasticBehavior = Enum.ElasticBehavior.Never;
    ScrollingFrame.Parent = Frame;
    local UIListLayout = Instance.new("UIListLayout");
    u5:Connect(function() -- Line: 183
        -- upvalues: UIListLayout (copy), u6 (ref)
        UIListLayout.Padding = UDim.new(0, u6);
    end);
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal;
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom;
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left;
    UIListLayout.Parent = ScrollingFrame;
    local u19 = ScrollingFrame:Clone();
    u5:Connect(function() -- Line: 193
        -- upvalues: u19 (copy), u6 (ref)
        u19.UIListLayout.Padding = UDim.new(0, u6);
    end);
    u19.ScrollingEnabled = false;
    u19.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center;
    u19.Name = "Center";
    u19.Parent = Holders;
    local u20 = ScrollingFrame:Clone();
    u5:Connect(function() -- Line: 202
        -- upvalues: u20 (copy), u6 (ref)
        u20.UIListLayout.Padding = UDim.new(0, u6);
    end);
    u20.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right;
    u20.Name = "Right";
    u20.AnchorPoint = Vector2.new(1, 0);
    u20.Position = UDim2.new(1, -12, 0, 0);
    u20.Parent = Frame;
    u5:Fire(GuiInset);

    return v4;
end;
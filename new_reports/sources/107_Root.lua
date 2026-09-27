-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Types);

return function(u1, u2) -- Line: 3
    local u3 = 0;
    u1.WidgetConstructor("Root", {
        hasState = false,
        hasChildren = true,
        Args = {},
        Events = {},

        Generate = function(p4) -- Line: 11, Name: Generate
            -- upvalues: u1 (copy), u2 (copy)
            local Folder = Instance.new("Folder");
            Folder.Name = "Iris_Root";
            local v5;

            if u1._config.UseScreenGUIs then
                v5 = Instance.new("ScreenGui");
                v5.ResetOnSpawn = false;
                v5.DisplayOrder = u1._config.DisplayOrderOffset;
                v5.IgnoreGuiInset = u1._config.IgnoreGuiInset;
            else
                v5 = Instance.new("Folder");
            end;

            v5.Name = "PseudoWindowScreenGui";
            v5.Parent = Folder;
            local v6;

            if u1._config.UseScreenGUIs then
                v6 = Instance.new("ScreenGui");
                v6.ResetOnSpawn = false;
                v6.DisplayOrder = u1._config.DisplayOrderOffset + 1024;
                v6.IgnoreGuiInset = u1._config.IgnoreGuiInset;
                local Frame = Instance.new("Frame");
                Frame.Name = "TooltipContainer";
                Frame.AutomaticSize = Enum.AutomaticSize.XY;
                Frame.Size = UDim2.fromOffset(0, 0);
                Frame.BackgroundTransparency = 1;
                Frame.BorderSizePixel = 0;
                u2.UIListLayout(Frame, Enum.FillDirection.Vertical, UDim.new(0, u1._config.PopupBorderSize));
                Frame.Parent = v6;
                local Frame2 = Instance.new("Frame");
                Frame2.Name = "MenuBarContainer";
                Frame2.AutomaticSize = Enum.AutomaticSize.Y;
                Frame2.Size = UDim2.fromScale(1, 0);
                Frame2.BackgroundTransparency = 1;
                Frame2.BorderSizePixel = 0;
                Frame2.Parent = v6;
            else
                v6 = Instance.new("Folder");
            end;

            v6.Name = "PopupScreenGui";
            v6.Parent = Folder;
            local Frame = Instance.new("Frame");
            Frame.Name = "PseudoWindow";
            Frame.Size = UDim2.new(0, 0, 0, 0);
            Frame.Position = UDim2.fromOffset(0, 22);
            Frame.AutomaticSize = Enum.AutomaticSize.XY;
            Frame.BackgroundTransparency = u1._config.WindowBgTransparency;
            Frame.BackgroundColor3 = u1._config.WindowBgColor;
            Frame.BorderSizePixel = u1._config.WindowBorderSize;
            Frame.BorderColor3 = u1._config.BorderColor;
            Frame.Selectable = false;
            Frame.SelectionGroup = true;
            Frame.SelectionBehaviorUp = Enum.SelectionBehavior.Stop;
            Frame.SelectionBehaviorDown = Enum.SelectionBehavior.Stop;
            Frame.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop;
            Frame.SelectionBehaviorRight = Enum.SelectionBehavior.Stop;
            Frame.Visible = false;
            u2.UIPadding(Frame, u1._config.WindowPadding);
            u2.UIListLayout(Frame, Enum.FillDirection.Vertical, UDim.new(0, u1._config.ItemSpacing.Y));
            Frame.Parent = v5;

            return Folder;
        end,

        Update = function(p7) -- Line: 85, Name: Update
            -- upvalues: u3 (ref)
            if u3 > 0 then
                p7.Instance.PseudoWindowScreenGui.PseudoWindow.Visible = true;
            end;
        end,

        Discard = function(p8) -- Line: 93, Name: Discard
            -- upvalues: u3 (ref)
            u3 = 0;
            p8.Instance:Destroy();
        end,

        ChildAdded = function(p9, p10) -- Line: 97, Name: ChildAdded
            -- upvalues: u3 (ref)
            local Instance2 = p9.Instance;

            if p10.type == "Window" then
                return p9.Instance;
            end;

            if p10.type == "Tooltip" then
                return Instance2.PopupScreenGui.TooltipContainer;
            end;

            if p10.type == "MenuBar" then
                return Instance2.PopupScreenGui.MenuBarContainer;
            end;

            local PseudoWindow = Instance2.PseudoWindowScreenGui.PseudoWindow;
            u3 = u3 + 1;
            PseudoWindow.Visible = true;

            return PseudoWindow;
        end,

        ChildDiscarded = function(p11, p12) -- Line: 116, Name: ChildDiscarded
            -- upvalues: u3 (ref)
            if p12.type ~= "Window" and (p12.type ~= "Tooltip" and p12.type ~= "MenuBar") then
                u3 = u3 - 1;

                if u3 == 0 then
                    p11.Instance.PseudoWindowScreenGui.PseudoWindow.Visible = false;
                end;
            end;
        end
    });
end;
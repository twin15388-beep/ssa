-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 1
    local Frame = Instance.new("Frame");
    Frame.Name = "SelectionContainer";
    Frame.Visible = false;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "Selection";
    Frame2.BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    Frame2.BackgroundTransparency = 1;
    Frame2.BorderColor3 = Color3.fromRGB(0, 0, 0);
    Frame2.BorderSizePixel = 0;
    Frame2.Parent = Frame;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "UIStroke";
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke.Color = Color3.fromRGB(255, 255, 255);
    UIStroke.Thickness = 3;
    UIStroke.Parent = Frame2;
    local UIGradient = Instance.new("UIGradient");
    UIGradient.Name = "SelectionGradient";
    UIGradient.Parent = UIStroke;
    local UICorner = Instance.new("UICorner");
    UICorner:SetAttribute("Collective", "IconCorners");
    UICorner.Name = "UICorner";
    UICorner.CornerRadius = UDim.new(1, 0);
    UICorner.Parent = Frame2;
    local RunService = game:GetService("RunService");
    local GuiService = game:GetService("GuiService");
    local u2 = 1;
    Frame2:GetAttributeChangedSignal("RotationSpeed"):Connect(function() -- Line: 37
        -- upvalues: u2 (ref), Frame2 (copy)
        u2 = Frame2:GetAttribute("RotationSpeed");
    end);
    RunService.Heartbeat:Connect(function() -- Line: 40
        -- upvalues: GuiService (copy), UIGradient (copy), u2 (ref)
        if not GuiService.SelectedObject then
            return;
        end;

        UIGradient.Rotation = os.clock() * u2 * 100 % 360;
    end);

    return Frame;
end;
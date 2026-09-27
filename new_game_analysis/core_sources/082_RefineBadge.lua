-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Packages.faye);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);

return function(p1: any, u2: function) -- Line: 9
    -- upvalues: gameSettings (copy)
    local preferedFont = gameSettings.preferedFont;

    return p1:Create("TextLabel")({
        Name = "Refine",
        ZIndex = 3,
        Visible = p1:Do(function(p3) -- Line: 15
            -- upvalues: u2 (copy)
            return (u2(p3) or 0) > 0;
        end),
        AnchorPoint = Vector2.new(0, 0),
        Position = UDim2.new(0, 4, 0, 1),
        Size = UDim2.fromScale(0.42, 0.34),
        BackgroundTransparency = 1,
        Text = p1:Do(function(p4) -- Line: 22
            -- upvalues: u2 (copy)
            return `+{u2(p4) or 0}`;
        end),
        TextXAlignment = Enum.TextXAlignment.Left,
        FontFace = Font.new(preferedFont.Family, Enum.FontWeight.Bold, Enum.FontStyle.Normal),
        TextScaled = true,
        TextColor3 = Color3.new(1, 1, 1),
        p1:Create("UIStroke")({
            Thickness = 1,
            Color = Color3.fromRGB(85, 170, 255),
            p1:Create("UIGradient")({
                Rotation = 90,
                Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(155, 220, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 95, 200)) }),
                Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.5, 0.3), NumberSequenceKeypoint.new(1, 0.85) })
            })
        })
    });
end;
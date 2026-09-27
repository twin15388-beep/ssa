-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Packages.faye);

return function(p1: any, p2: string, p3: string, p4) -- Line: 11
    return p1:Create("Frame")({
        Name = "Header",
        Size = UDim2.fromScale(1, 0.12),
        BackgroundTransparency = 1,
        p1:Create("TextLabel")({
            Name = "Title",
            BackgroundTransparency = 1,
            TextScaled = true,
            Size = UDim2.fromScale(1, 0.467),
            Font = Enum.Font.SourceSansBold,
            Text = p2,
            TextColor3 = Color3.new(1, 1, 1),
            TextXAlignment = Enum.TextXAlignment.Left
        }),
        p1:Create("TextLabel")({
            Name = "Subtitle",
            BackgroundTransparency = 1,
            TextTransparency = 0.15,
            TextScaled = true,
            Position = UDim2.fromScale(0, 0.467),
            Size = UDim2.fromScale(1, 0.455),
            Font = Enum.Font.SourceSansSemibold,
            Text = p3,
            TextColor3 = p4:Lerp(Color3.new(1, 1, 1), 0.45),
            TextXAlignment = Enum.TextXAlignment.Left
        }),
        p1:Create("Frame")({
            Name = "Underline",
            AnchorPoint = Vector2.new(0, 1),
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.new(0.385, 0, 0, 2),
            BackgroundColor3 = p4,
            p1:Create("UIGradient")({
                Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) })
            }),
            p1:Create("UIShadow")({
                Transparency = 0.6,
                BlurRadius = UDim.new(1),
                Color = p4
            })
        })
    });
end;
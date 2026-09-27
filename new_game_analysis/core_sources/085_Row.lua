-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Packages.faye);
local Tile = require(script.Parent.Tile);

return function(p1: any, p2: number, p3: string, p4: table, u5: any) -- Line: 8
    -- upvalues: Tile (copy)
    return p1:Create("Frame")({
        Name = p3,
        LayoutOrder = p2,
        Size = UDim2.fromScale(1, 0.48),
        BackgroundTransparency = 1,
        p1:Create("TextLabel")({
            Name = "Label",
            BackgroundTransparency = 1,
            TextTransparency = 0.25,
            TextScaled = true,
            Size = UDim2.fromScale(1, 0.18),
            Font = Enum.Font.SourceSansSemibold,
            Text = p3,
            TextColor3 = Color3.new(1, 1, 1),
            TextXAlignment = Enum.TextXAlignment.Left
        }),
        p1:Create("Frame")({
            Name = "Tiles",
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 1),
            Size = UDim2.fromScale(1, 0.8),
            BackgroundTransparency = 1,
            p1:Create("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0.012)
            }),
            p1:Iterate(p4, function(p6, p7, p8) -- Line: 38
                -- upvalues: Tile (ref), u5 (copy)
                return Tile(p8, p6, p7, u5);
            end)
        })
    });
end;
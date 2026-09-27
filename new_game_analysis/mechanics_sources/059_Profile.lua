-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Types);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
require(ReplicatedStorage.Packages.faye);

return function(p1: any, p2: any, p3: number) -- Line: 15
    -- upvalues: gameSettings (copy)
    local v4 = p1:Create("Frame");
    local v5 = {
        Name = "ATitleHolder",
        Size = UDim2.fromScale(1, 0.4),
        BackgroundTransparency = 1
    };
    local v6 = p1:Create("UIListLayout")({
        Name = "List",
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Left
    });
    local v7;

    if p2.Icon then
        v7 = p1:Create("Frame")({
            Name = "AAImageHolder",
            Size = UDim2.fromScale(1, 1),
            Instance.new("UIAspectRatioConstraint"),
            BackgroundTransparency = 1,
            p1:Create("UICorner")({
                CornerRadius = UDim.new(1)
            }),
            p1:Create("ImageLabel")({
                Name = "Img",
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Image = p2.Icon
            }),
            p1:Create("UIShadow")({
                Transparency = 0.5,
                BlurRadius = UDim.new(0.5),
                Spread = UDim2.fromScale(-0.3, -0.3),
                Color = Color3.new(0.1, 0.1, 0.1)
            })
        });
    else
        v7 = nil;
    end;

    v5[1], v5[2], v5[3] = v6, v7, p1:Create("TextLabel")({
    BackgroundTransparency = 1,
    RichText = true,
    TextScaled = true,
    Size = UDim2.fromScale(2, 0.9),
    Text = `Escort and protect <b><font {gameSettings.RichTextPopularConfigs.SoroundColorRBX} >{p2.Title}!</font></b>`,
    TextColor3 = Color3.new(1, 1, 1),
    TextXAlignment = Enum.TextXAlignment.Left,
    Font = Enum.Font.SourceSansSemibold
});

    return v4(v5);
end;
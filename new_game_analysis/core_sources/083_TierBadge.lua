-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Packages.faye);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local Color3_fromRGB_ret = Color3.fromRGB(255, 200, 80);
local Color3_fromRGB_ret2 = Color3.fromRGB(120, 80, 10);

return function(p1: any, p2: number) -- Line: 11
    -- upvalues: gameSettings (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy)
    local preferedFont = gameSettings.preferedFont;

    return p1:Create("TextLabel")({
        Name = "Tier",
        ZIndex = 3,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -4, 0, 1),
        Size = UDim2.fromScale(0.42, 0.34),
        BackgroundTransparency = 1,
        Text = `T{p2}`,
        TextXAlignment = Enum.TextXAlignment.Right,
        FontFace = Font.new(preferedFont.Family, Enum.FontWeight.Bold, Enum.FontStyle.Normal),
        TextScaled = true,
        TextColor3 = Color3_fromRGB_ret,
        p1:Create("UIStroke")({
            Thickness = 1,
            Transparency = 0.3,
            Color = Color3_fromRGB_ret2
        })
    });
end;
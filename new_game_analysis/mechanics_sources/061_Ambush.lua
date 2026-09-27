-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
require(script.Parent.Parent.Types);
require(ReplicatedStorage.Packages.faye);
local Color3_fromRGB_ret = Color3.fromRGB(88, 199, 108);
local Color3_new_ret = Color3.new(0.1, 0.1, 0.1);
local Color3_fromRGB_ret2 = Color3.fromRGB(120, 25, 25);

return function(p1: any, u2: any, u3: number) -- Line: 19
    -- upvalues: Color3_fromRGB_ret2 (copy), Color3_new_ret (copy), BunchaIcons (copy), Color3_fromRGB_ret (copy)
    local Legs = u2.Legs;

    return p1:Create("Frame")({
        Name = "Ambush" .. u3,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromScale(1, 2.2),
        Position = p1:Do(function(p4: any, p5: any, p6: userdata?) -- Line: 72
            -- upvalues: u3 (copy), Legs (copy), u2 (copy)
            return UDim2.fromScale((u3 - 1) / Legs, u2.IsLive(p4, u3) and 2.2 or 0.5);
        end),
        BackgroundTransparency = 1,
        Instance.new("UIAspectRatioConstraint"),
        p1:Create("Frame")({
            Name = "Disc",
            Size = UDim2.fromScale(2, 2),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            p1:Create("UIShadow")({
                Transparency = 0.3,
                BlurRadius = UDim.new(1),
                Spread = UDim2.fromScale(-0.2, -0.2),
                Color = p1:Do(function(p7: any, p8: any, p9: userdata?) -- Line: 90
                    -- upvalues: u2 (copy), u3 (copy), Color3_fromRGB_ret2 (ref), Color3_new_ret (ref)
                    if u2.IsLive(p7, u3) then
                        return Color3_fromRGB_ret2;
                    end;

                    return Color3_new_ret;
                end)
            }),
            BackgroundTransparency = 0.75,
            BackgroundColor3 = Color3.new(0.15, 0.15, 0.15),
            p1:Create("UICorner")({
                CornerRadius = UDim.new(1)
            }),
            p1:Create("ImageLabel")({
                Name = "Icon",
                ZIndex = 2,
                BackgroundTransparency = 1,
                ImageTransparency = 0,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(1, 1),
                Image = p1:Do(function(p10: any, p11: any, p12: userdata?) -- Line: 106
                    -- upvalues: u2 (copy), u3 (copy), BunchaIcons (ref)
                    if u2.IsCleared(p10, u3) then
                        return BunchaIcons.Checkmark;
                    end;

                    return BunchaIcons.Combat;
                end),
                ImageColor3 = p1:Do(function(p13: any, p14: any, p15: userdata?) -- Line: 110
                    -- upvalues: u2 (copy), u3 (copy), Color3_fromRGB_ret (ref)
                    if u2.IsCleared(p13, u3) then
                        return Color3_fromRGB_ret;
                    end;

                    return Color3.new(1, 1, 1);
                end)
            })
        })
    });
end;
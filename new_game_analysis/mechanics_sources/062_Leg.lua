-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types);
require(ReplicatedStorage.Packages.faye).Info(0.2);

return function(p1: any, p2: any, u3: number, u4: any) -- Line: 20
    local Legs = p2.Legs;

    return p1:Create("Frame")({
        Name = "Leg" .. u3,
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.fromScale((u3 - 1) / Legs, 0.5),
        Size = UDim2.new(1 / Legs, -4, 1, 0),
        BackgroundColor3 = Color3.new(),
        BackgroundTransparency = 0.75,
        p1:Create("UICorner")({
            CornerRadius = UDim.new(1)
        }),
        p1:Create("UIShadow")({
            Transparency = 0.85,
            BlurRadius = UDim.new(1),
            Spread = UDim2.fromScale(0.2, 0.2)
        }),
        p1:Create("Frame")({
            Name = "bar",
            ZIndex = 2,
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 0,
            Size = p1:Do(function(p5: any, p6: any, p7: userdata?) -- Line: 44
                -- upvalues: u4 (copy), Legs (copy), u3 (copy)
                local UDim2_fromScale = UDim2.fromScale;
                local v8 = p5(u4) * Legs - (u3 - 1);

                return UDim2_fromScale(math.clamp(v8, 0, 1), 1);
            end),
            p1:Create("UICorner")({
                CornerRadius = UDim.new(0.4)
            }),
            p1:Create("ImageLabel")({
                Name = "Inner",
                BackgroundTransparency = 1,
                Image = "rbxassetid://96840853773997",
                ImageTransparency = 0.855,
                Size = UDim2.fromScale(1, 1),
                ImageColor3 = Color3.new()
            })
        })
    });
end;
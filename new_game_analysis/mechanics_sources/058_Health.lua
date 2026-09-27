-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Types);
local u1 = require(ReplicatedStorage.Packages.faye).Info(0.4);
local Color3_fromRGB_ret = Color3.fromRGB(88, 199, 108);
local Color3_fromRGB_ret2 = Color3.fromRGB(199, 72, 72);

return function(p2: any, u3: any, p4: number) -- Line: 31
    -- upvalues: Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy), u1 (copy)
    local function healthColor(p5) -- Line: 36
        -- upvalues: Color3_fromRGB_ret (ref), Color3_fromRGB_ret2 (ref), u3 (copy)
        return Color3_fromRGB_ret:Lerp(Color3_fromRGB_ret2, 1 - p5(u3.HealthPercent));
    end;

    return p2:Create("Frame")({
        Name = "AHealthHolder",
        LayoutOrder = 2,
        Size = UDim2.fromScale(0.4, 0.1),
        BackgroundTransparency = 0.5,
        BackgroundColor3 = Color3.new(0.2, 0.2, 0.2),
        p2:Create("UIShadow")({
            Transparency = 0.8,
            BlurRadius = UDim.new(1)
        }),
        p2:Create("UIAspectRatioConstraint")({
            AspectRatio = 25
        }),
        p2:Create("UIStroke")({
            Transparency = p2:Animation(u3.StrokeTransparency, u1, {
                AlwaysFrom = 0,
                From = u3.StrokeTransparency.Value
            }),
            Color = Color3.new(1, 1, 1),
            Thickness = p2:Animation(u3.StrokeThickness, u1, {
                AlwaysFrom = 2,
                From = u3.StrokeThickness.Value
            })
        }),
        p2:Create("Frame")({
            Name = "bar",
            ZIndex = 2,
            BackgroundColor3 = p2:Do(function(p6: any, p7: any, p8: userdata?) -- Line: 72
                -- upvalues: healthColor (copy)
                return healthColor(p6);
            end),
            BackgroundTransparency = 0,
            Size = p2:Lerp(u3.HealthSize, 0.1),
            p2:Create("UICorner")({
                CornerRadius = UDim.new(1)
            }),
            p2:Create("ImageLabel")({
                Name = "Inner",
                BackgroundTransparency = 1,
                Image = "rbxassetid://96840853773997",
                ImageTransparency = 0.855,
                Size = UDim2.fromScale(1, 1),
                ImageColor3 = Color3.new()
            })
        }),
        p2:Create("Frame")({
            Name = "barwhite",
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 0,
            Size = p2:Lerp(u3.HealthSize, 0.05),
            p2:Create("UICorner")({
                CornerRadius = UDim.new(1)
            })
        }),
        p2:Create("TextLabel")({
            Name = "HealthText",
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.fromScale(1.045, 0.2),
            Size = UDim2.fromScale(0.7, 3),
            BackgroundTransparency = 1,
            Text = u3.HealthText,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextScaled = true,
            Font = Enum.Font.SourceSansSemibold,
            TextColor3 = p2:Do(function(p9: any, p10: any, p11: userdata?) -- Line: 120
                -- upvalues: Color3_fromRGB_ret (ref), Color3_fromRGB_ret2 (ref), u3 (copy)
                return Color3_fromRGB_ret:Lerp(Color3_fromRGB_ret2, 1 - p9(u3.HealthPercent)):Lerp(Color3.new(1, 1, 1), 0.55);
            end),
            p2:Create("UIStroke")({
                Thickness = 2,
                Transparency = 0.875
            })
        })
    });
end;
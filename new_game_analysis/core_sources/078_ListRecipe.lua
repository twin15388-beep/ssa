-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local faye = require(ReplicatedStorage.Packages.faye);
require(ReplicatedStorage.CAM.Global.Types.CraftingTypes);
local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);
local Rarities = require(ReplicatedStorage.CAM.Global.Rarities);
local ScreenEffects = require(ReplicatedStorage.CAM.Client.Components.Misc.ScreenEffects);
local TierBadge = require(script.Parent.TierBadge);
local u1 = faye.Info(0.2);
local u2 = faye.Info(0.2, Enum.EasingStyle.Back);

return function(p3: any, p4: any, u5: any, u6: string, p7: any, p8: any) -- Line: 38
    -- upvalues: Items (copy), Rarities (copy), u1 (copy), ScreenEffects (copy), u2 (copy), TierBadge (copy)
    local v9 = Items[p7.result];

    if v9 == nil then
        return nil;
    end;

    local v10 = Rarities.Colors[v9.Rarity] or Color3.new(1, 1, 1);
    local Icon = v9.Icon;
    local v11;

    if #p7.result > 20 then
        v11 = `{string.sub(p7.result, 1, 18)}..`;
    else
        v11 = p7.result;
    end;

    local u12 = {
        Id = u6,
        In = p3:Value(false),
        BgColor = p3:Value(Color3.new(0.1, 0.1, 0.1)),
        BgTransparency = p3:Value(0.7),
        StrokeTransparency = p3:Value(0.9),
        StrokeThickness = p3:Value(1),
        NameGlowTransparency = p3:Value(0.8),
        TextPosition = p3:Value(UDim2.fromScale(0.5, 0.5)),
        IconSize = p3:Value(UDim2.fromScale(1.2, 1.2)),
        IconBgRotation = p3:Value(45)
    };
    p4:Add(u12, p3, true):Call():Connect(u12.In.Changed);
    local v13 = p3:Create("Frame");
    local v14 = {
        Name = u6,
        Size = p8,
        p3:Create("UICorner")({
            CornerRadius = UDim.new(0.2)
        }),
        BackgroundColor3 = p3:Animation(u12.BgColor, u1),
        BackgroundTransparency = p3:Animation(u12.BgTransparency, u1)
    };
    local v15 = p3:Create("UIStroke")({
        Color = Color3.new(1, 1, 1),
        BorderOffset = UDim.new(0, -4),
        Transparency = p3:Animation(u12.StrokeTransparency, u1),
        Thickness = p3:Animation(u12.StrokeThickness, u1)
    });
    local v17 = p3:Create("TextButton")({
        Name = "Hitbox",
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 5,
        Size = UDim2.fromScale(1, 1),

        MouseButton1Click = function(p16: userdata) -- Line: 84, Name: MouseButton1Click
            -- upvalues: ScreenEffects (ref), u5 (copy), u6 (copy)
            ScreenEffects.StrokeClick(p16.Parent, UDim.new(0.2));
            u5:Set(u5:Compare(u6) and "" or u6);
        end,

        MouseEnter = function() -- Line: 89, Name: MouseEnter
            -- upvalues: u12 (copy)
            u12.In:Set(true);
        end,

        MouseLeave = function() -- Line: 92, Name: MouseLeave
            -- upvalues: u12 (copy)
            if not u12.In:Compare(true) then
                return;
            end;

            u12.In:Set(false);
        end
    });
    local v18 = p3:Create("Frame")({
        Name = "NameHolder",
        Size = UDim2.fromScale(0.75, 1),
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.fromScale(0.24, 0.5),
        BackgroundTransparency = 1,
        p3:Create("TextLabel")({
            BackgroundTransparency = 1,
            TextScaled = true,
            Font = Enum.Font.SourceSansSemibold,
            Size = UDim2.fromScale(1, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = p3:Animation(u12.TextPosition, u1),
            Text = v11,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextColor3 = Color3.new(1, 1, 1)
        }),
        p3:Create("Frame")({
            Name = "Bg",
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(-0.05, 0, 0.5),
            Size = UDim2.fromScale(1, 0.5),
            ZIndex = -1,
            p3:Create("UICorner")({
                CornerRadius = UDim.new(1)
            }),
            BackgroundColor3 = v10,
            p3:Create("UIGradient")({
                Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.9), NumberSequenceKeypoint.new(1, 1) })
            }),
            p3:Create("UIShadow")({
                BlurRadius = UDim.new(1),
                Color = v10,
                Transparency = p3:Animation(u12.NameGlowTransparency, u1),
                Spread = UDim2.fromScale(-0.5, -0.5)
            })
        })
    });
    local v19 = p3:Create("Frame");
    local v20 = {
        Name = "IconHolder",
        Size = UDim2.fromScale(0.75, 0.75),
        Instance.new("UIAspectRatioConstraint"),
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 4, 0.5),
        ZIndex = 3,
        BackgroundTransparency = 1
    };
    local v21 = p3:Create("ImageLabel")({
        BackgroundTransparency = 1,
        ZIndex = 2,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Image = Icon,
        Size = p3:Animation(u12.IconSize, u2)
    });
    local v22;

    if p7.tier == nil then
        v22 = nil;
    else
        v22 = TierBadge(p3, p7.tier) or nil;
    end;

    v20[2], v20[3], v20[4] = v21, v22, p3:Create("Frame")({
    Name = "Bg",
    AnchorPoint = Vector2.new(0, 0.5),
    Position = UDim2.new(0, 4, 0.5),
    Size = UDim2.fromScale(0.6, 0.6),
    p3:Create("UICorner")({
        CornerRadius = UDim.new(0.2)
    }),
    BackgroundColor3 = v10,
    p3:Create("UIGradient")({
        Rotation = -90,
        Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.6), NumberSequenceKeypoint.new(1, 1) })
    }),
    p3:Create("UIShadow")({
        BlurRadius = UDim.new(1),
        Color = v10,
        Spread = UDim2.fromScale(-0.5, -0.5)
    }),
    Rotation = p3:Animation(u12.IconBgRotation, u2)
});
    v14[2], v14[3], v14[4], v14[5] = v15, v17, v18, v19(v20);

    return v13(v14);
end;
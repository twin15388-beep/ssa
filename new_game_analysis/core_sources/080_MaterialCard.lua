-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local faye = require(ReplicatedStorage.Packages.faye);
require(ReplicatedStorage.CAM.Global.Types.CraftingTypes);
local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);
local Rarities = require(ReplicatedStorage.CAM.Global.Rarities);
local RefineBadge = require(script.Parent.RefineBadge);
local TierBadge = require(script.Parent.TierBadge);
local u1 = faye.Info(0.2);
local Color3_fromRGB_ret = Color3.fromRGB(255, 95, 95);
local Color3_new_ret = Color3.new(1, 1, 1);

return function(u2: any, u3: any, u4: function, u5: function?, p6: number?) -- Line: 28
    -- upvalues: Items (copy), Rarities (copy), RefineBadge (copy), TierBadge (copy), Color3_new_ret (copy), Color3_fromRGB_ret (copy), u1 (copy)
    local v7 = Items[u3.name];
    local v8 = v7 ~= nil and Rarities.Colors[v7.Rarity] or Color3.new(1, 1, 1);
    local v9;

    if #u3.name > 16 then
        v9 = `{string.sub(u3.name, 1, 14)}..`;
    else
        v9 = u3.name;
    end;

    local v10 = u2:Create("Frame");
    local v11 = {
        Name = u3.name,
        Size = UDim2.fromScale(1, 0.3),
        BackgroundColor3 = Color3.new(0.1, 0.1, 0.1),
        BackgroundTransparency = 0.5
    };
    local v12 = u2:Create("UICorner")({
        CornerRadius = UDim.new(0.2)
    });
    local v13 = u2:Create("UIStroke")({
        Transparency = 0.9,
        Color = Color3.new(1, 1, 1),
        BorderOffset = UDim.new(0, -4)
    });
    local v14 = u2:Create("Frame");
    local v15 = {
        Name = "IconHolder",
        Size = UDim2.fromScale(0.75, 0.75),
        Instance.new("UIAspectRatioConstraint"),
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 6, 0.5),
        BackgroundTransparency = 1
    };
    local v16 = u2:Create("ImageLabel")({
        BackgroundTransparency = 1,
        ZIndex = 2,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1.1, 1.1),
        Image = v7 == nil and "" or (v7.Icon or "")
    });
    local v17;

    if u5 == nil then
        v17 = nil;
    else
        v17 = RefineBadge(u2, function(p18) -- Line: 61
            -- upvalues: u5 (copy), u3 (copy)
            return u5(p18, u3.name);
        end) or nil;
    end;

    local v19;

    if p6 == nil then
        v19 = nil;
    else
        v19 = TierBadge(u2, p6) or nil;
    end;

    v15[2], v15[3], v15[4], v15[5] = v16, v17, v19, u2:Create("Frame")({
    Name = "Bg",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromScale(0.6, 0.6),
    Rotation = 45,
    BackgroundColor3 = v8,
    u2:Create("UICorner")({
        CornerRadius = UDim.new(0.2)
    }),
    u2:Create("UIGradient")({
        Rotation = -90,
        Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.6), NumberSequenceKeypoint.new(1, 1) })
    }),
    u2:Create("UIShadow")({
        BlurRadius = UDim.new(1),
        Color = v8,
        Spread = UDim2.fromScale(-0.5, -0.5)
    })
});
    v11[1], v11[2], v11[3], v11[4], v11[5] = v12, v13, v14(v15), u2:Create("TextLabel")({
    Name = "ItemName",
    BackgroundTransparency = 1,
    TextScaled = true,
    AnchorPoint = Vector2.new(0, 1),
    Position = UDim2.fromScale(0.36, 0.52),
    Size = UDim2.fromScale(0.6, 0.32),
    Font = Enum.Font.SourceSansSemibold,
    Text = v9,
    TextColor3 = Color3.new(1, 1, 1),
    TextXAlignment = Enum.TextXAlignment.Left
}), u2:Create("TextLabel")({
    Name = "Count",
    BackgroundTransparency = 1,
    TextTransparency = 0.15,
    TextScaled = true,
    TextStrokeTransparency = 0.8,
    Position = UDim2.fromScale(0.36, 0.54),
    Size = UDim2.fromScale(0.6, 0.338),
    Font = Enum.Font.SourceSansBold,
    Text = u2:Do(function(p20) -- Line: 107
        -- upvalues: u4 (copy), u3 (copy)
        return `{u4(p20, u3.name)}/{u3.amount}`;
    end),
    TextColor3 = u2:Do(function(p21) -- Line: 110
        -- upvalues: u2 (copy), u4 (copy), u3 (copy), Color3_new_ret (ref), Color3_fromRGB_ret (ref), u1 (ref)
        local v22;

        if u4(p21, u3.name) >= u3.amount then
            v22 = Color3_new_ret;
        else
            v22 = Color3_fromRGB_ret;
        end;

        return u2:Animation(v22, u1);
    end),
    TextXAlignment = Enum.TextXAlignment.Left
});

    return v10(v11);
end;
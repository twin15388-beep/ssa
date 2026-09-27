-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local faye = require(ReplicatedStorage.Packages.faye);
require(ReplicatedStorage.CAM.Global.Types.CraftingTypes);
local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);
local Rarities = require(ReplicatedStorage.CAM.Global.Rarities);
require(script.Parent.MaterialCard);
local u1 = faye.Info(0.2);
local Color3_fromRGB_ret = Color3.fromRGB(255, 95, 95);
local Color3_new_ret = Color3.new(1, 1, 1);

return function(u2, u3, u4) -- Line: 19
    -- upvalues: Items (copy), Rarities (copy), Color3_new_ret (copy), Color3_fromRGB_ret (copy), u1 (copy)
    local v5 = Items[u3.name];
    local v6 = v5 ~= nil and Rarities.Colors[v5.Rarity] or Color3.new(1, 1, 1);
    local v7;

    if #u3.name > 10 then
        v7 = `{string.sub(u3.name, 1, 8)}..`;
    else
        v7 = u3.name;
    end;

    return u2:Create("Frame")({
        Name = u3.name,
        Size = UDim2.fromScale(1, 1),
        u2:Create("UIAspectRatioConstraint")({
            DominantAxis = Enum.DominantAxis.Height
        }),
        BackgroundColor3 = Color3.new(0.1, 0.1, 0.1),
        BackgroundTransparency = 0.5,
        u2:Create("UICorner")({
            CornerRadius = UDim.new(0.15)
        }),
        u2:Create("UIStroke")({
            Transparency = 0.9,
            Color = Color3.new(1, 1, 1),
            BorderOffset = UDim.new(0, -4)
        }),
        u2:Create("Frame")({
            Name = "Glow",
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 1),
            Size = UDim2.fromScale(1, 0.5),
            BackgroundColor3 = v6,
            ZIndex = 0,
            u2:Create("UICorner")({
                CornerRadius = UDim.new(0.15)
            }),
            u2:Create("UIGradient")({
                Rotation = -90,
                Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.7), NumberSequenceKeypoint.new(1, 1) })
            })
        }),
        u2:Create("ImageLabel")({
            Name = "Icon",
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.06),
            Size = UDim2.fromScale(0.5, 0.5),
            Image = v5 == nil and "" or (v5.Icon or "")
        }),
        u2:Create("TextLabel")({
            Name = "ItemName",
            BackgroundTransparency = 1,
            TextScaled = true,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.56),
            Size = UDim2.fromScale(0.9, 0.18),
            Font = Enum.Font.SourceSansSemibold,
            Text = v7,
            TextColor3 = Color3.new(1, 1, 1)
        }),
        u2:Create("TextLabel")({
            Name = "Count",
            BackgroundTransparency = 1,
            TextScaled = true,
            TextStrokeTransparency = 0.8,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.75),
            Size = UDim2.fromScale(0.9, 0.221),
            Font = Enum.Font.SourceSansBold,
            Text = u2:Do(function(p8) -- Line: 85
                -- upvalues: u4 (copy), u3 (copy)
                return `{u4(p8, u3.name)}/{u3.amount}`;
            end),
            TextColor3 = u2:Do(function(p9) -- Line: 88
                -- upvalues: u2 (copy), u4 (copy), u3 (copy), Color3_new_ret (ref), Color3_fromRGB_ret (ref), u1 (ref)
                local v10;

                if u4(p9, u3.name) >= u3.amount then
                    v10 = Color3_new_ret;
                else
                    v10 = Color3_fromRGB_ret;
                end;

                return u2:Animation(v10, u1);
            end)
        })
    });
end;
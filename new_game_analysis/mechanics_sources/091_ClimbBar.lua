-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local faye = require(ReplicatedStorage.Packages.faye);
local Color3_new_ret = Color3.new(1, 0.121569, 0.121569);
local Color3_new_ret2 = Color3.new(0.435294, 1, 0.435294);
local u1 = faye.Info(0.3);

return function(p2: userdata, p3, p4) -- Line: 11
    -- upvalues: faye (copy), u1 (copy), Utility (copy), Color3_new_ret2 (copy), Color3_new_ret (copy)
    local u5 = faye.new();
    local u6 = u5:Value(1);
    local u7 = u5:Value(0);
    local u8 = u5:Value(p3 or UDim2.fromScale(0.1, 0.25));
    u5:Create("CanvasGroup")({
        Parent = p2,
        GroupTransparency = u5:Animation(0, u1, {
            From = 1
        }),

        OnClean = function() -- Line: 21, Name: OnClean
            -- upvalues: u5 (copy), u1 (ref)
            return {
                GroupTransparency = u5:Animation(1, u1)
            };
        end,

        AnchorPoint = p4 or Vector2.new(0, 0.5),
        Size = UDim2.fromScale(0.2, 0.2),
        Position = u8,
        Instance.new("UIAspectRatioConstraint"),
        BackgroundTransparency = 1,
        u5:Create("ImageLabel")({
            Image = "rbxassetid://123372383123665",
            BackgroundTransparency = 1,
            ImageTransparency = 0.4,
            Size = UDim2.fromScale(1, 1),
            ImageColor3 = Color3.new(0.15, 0.15, 0.15)
        }),
        u5:Create("Frame")({
            Size = UDim2.fromScale(0.5, 1),
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.fromScale(0, 0.5),
            ClipsDescendants = true,
            ZIndex = 2,
            BackgroundTransparency = 1,
            u5:Create("ImageLabel")({
                Size = UDim2.fromScale(2, 1),
                BackgroundTransparency = 1,
                ImageColor3 = u5:Do(function(p9: function, p10: any, p11: userdata?) -- Line: 49
                    -- upvalues: u6 (copy), u7 (copy), u8 (copy), Utility (ref), Color3_new_ret2 (ref), Color3_new_ret (ref)
                    local v12 = p9(u6);

                    if p9(u7) == 1 and v12 >= 0.65 then
                        local v13 = 1 - (1 - v12) / 0.35;
                        u8:Set(u8.Initial + UDim2.fromOffset(math.random(-10, 10) * v13, math.random(-10, 10) * v13));
                    end;

                    return Utility.Lerp_Color2(Color3_new_ret2, Color3_new_ret, v12);
                end),
                Image = "rbxassetid://70625589865840",
                u5:Create("UIGradient")({
                    Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 0),
                        NumberSequenceKeypoint.new(0.499, 0),
                        NumberSequenceKeypoint.new(0.501, 1),
                        NumberSequenceKeypoint.new(1, 1)
                    }),
                    Rotation = u5:Do(function(p14: function, p15: any, p16: userdata?) -- Line: 66
                        -- upvalues: u6 (copy)
                        local v17 = p14(u6) * 360 - 180;

                        return math.clamp(v17, 0, 180);
                    end)
                })
            })
        }),
        u5:Create("Frame")({
            Size = UDim2.fromScale(0.5, 1),
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            ClipsDescendants = true,
            ZIndex = 2,
            BackgroundTransparency = 1,
            u5:Create("ImageLabel")({
                Size = UDim2.fromScale(2, 1),
                Position = UDim2.fromScale(-1, 0),
                BackgroundTransparency = 1,
                ImageColor3 = u5:Do(function(p18: function, p19: any, p20: userdata?) -- Line: 83
                    -- upvalues: Utility (ref), Color3_new_ret2 (ref), Color3_new_ret (ref), u6 (copy)
                    return Utility.Lerp_Color2(Color3_new_ret2, Color3_new_ret, p18(u6));
                end),
                Image = "rbxassetid://70625589865840",
                u5:Create("UIGradient")({
                    Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 1),
                        NumberSequenceKeypoint.new(0.499, 1),
                        NumberSequenceKeypoint.new(0.501, 0),
                        NumberSequenceKeypoint.new(1, 0)
                    }),
                    Rotation = u5:Do(function(p21: function, p22: any, p23: userdata?) -- Line: 94
                        -- upvalues: u6 (copy)
                        local v24 = p21(u6) * 360;

                        return math.clamp(v24, 0, 180);
                    end)
                })
            })
        })
    });

    return function() -- Line: 103
        -- upvalues: u5 (copy)
        u5:Destroy();
    end, u6, u7;
end;
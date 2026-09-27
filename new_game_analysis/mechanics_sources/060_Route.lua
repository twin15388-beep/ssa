-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local script_Ambush = require(script.Ambush);
local script_Leg = require(script.Leg);
require(script.Parent.Types);
require(ReplicatedStorage.Packages.faye).Info(0.2);

return function(p1: any, u2: any, p3: number) -- Line: 20
    -- upvalues: script_Leg (copy), script_Ambush (copy)
    if u2.Legs < 1 then
        return nil;
    end;

    local u4 = p1:Create("NumberValue")({
        Value = p1:Lerp(u2.Progress, 0.12)
    });

    return p1:Create("Frame")({
        u4,
        Name = "CRoute",
        LayoutOrder = 3,
        Size = UDim2.fromScale(0.75, 0.075),
        BackgroundTransparency = 1,
        p1:Create("ImageLabel")({
            Name = "Bg",
            BackgroundTransparency = 1,
            Image = "rbxassetid://96840853773997",
            ImageTransparency = 0.855,
            Size = UDim2.fromScale(1.08, 1.8),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            ImageColor3 = Color3.new()
        }),
        p1:Iterate(u2.Legs, function(p5: any, p6: any, p7: any, p8: userdata) -- Line: 45
            -- upvalues: script_Leg (ref), u2 (copy), u4 (copy)
            return script_Leg(p7, u2, p5, u4);
        end),
        p1:Iterate(u2.Ambushes, function(p9: any, p10: any, p11: any, p12: userdata) -- Line: 48
            -- upvalues: script_Ambush (ref), u2 (copy)
            return script_Ambush(p11, u2, p10);
        end)
    });
end;
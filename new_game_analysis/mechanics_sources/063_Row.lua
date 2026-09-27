-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Health = require(script.Parent.Health);
local Profile = require(script.Parent.Profile);
local Route = require(script.Parent.Route);
require(script.Parent.Types);
local u1 = require(ReplicatedStorage.Packages.faye).Info(0.2);

return function(u2: any, p3: any, p4: number) -- Line: 20
    -- upvalues: u1 (copy), Profile (copy), Health (copy), Route (copy)
    return u2:Create("CanvasGroup")({
        Size = UDim2.fromScale(1, 1.3),
        Name = "Holder",
        BackgroundTransparency = 1,
        GroupTransparency = u2:Animation(0, u1, {
            From = 1
        }),

        OnClean = function() -- Line: 33, Name: OnClean
            -- upvalues: u2 (copy), u1 (ref)
            return {
                GroupTransparency = u2:Animation(1, u1)
            };
        end,

        u2:Create("Frame")({
            Name = "Actual",
            Size = UDim2.fromScale(1, 0.7692307692307692),
            BackgroundColor3 = Color3.new(),
            u2:Create("UIGradient")({
                Rotation = 90,
                Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.4), NumberSequenceKeypoint.new(0.7, 0.8), NumberSequenceKeypoint.new(1, 0.95) })
            }),
            u2:Create("UICorner")({
                CornerRadius = UDim.new(0.2)
            }),
            u2:Create("Frame")({
                Name = "ActualHolder",
                Size = UDim2.fromScale(1, 1),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 4, 0.5),
                BackgroundTransparency = 1,
                u2:Create("UIListLayout")({
                    Name = "List",
                    FillDirection = Enum.FillDirection.Vertical,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    HorizontalAlignment = Enum.HorizontalAlignment.Left,
                    Padding = UDim.new(0, 2)
                }),
                Profile(u2, p3, p4),
                Health(u2, p3, p4),
                Route(u2, p3, p4)
            })
        })
    });
end;
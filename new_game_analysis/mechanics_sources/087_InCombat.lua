-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local faye = require(ReplicatedStorage.Packages.faye);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local u1 = faye.Info(0.65, Enum.EasingStyle.Back);
local u2 = faye.Info(0.85, Enum.EasingStyle.Back);
local u3 = faye.Info(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true);

return function(p4, u5) -- Line: 7
    -- upvalues: u3 (copy), u1 (copy), u2 (copy), Utility (copy)
    return p4:Create("Frame")({
        Size = UDim2.fromScale(0.8, 1),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        BackgroundColor3 = Color3.new(0.2, 0.2, 0.2),
        p4:Create("UIGradient")({
            Rotation = 210,
            Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.55), NumberSequenceKeypoint.new(1, 0.9) })
        }),
        p4:Create("Frame")({
            Name = "TopHolder",
            Position = UDim2.fromScale(0, 0.1),
            Size = UDim2.fromScale(1, 0.5),
            BackgroundTransparency = 1,
            p4:Create("UIListLayout")({
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = UDim.new(0.05, 0)
            }),
            p4:Create("Frame")({
                Name = "ImageHolder",
                Size = UDim2.fromScale(1, 1),
                Instance.new("UIAspectRatioConstraint"),
                BackgroundTransparency = 1,
                p4:Create("ImageLabel")({
                    Name = "Bg",
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://134657809787110",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromScale(2, 2),
                    ImageColor3 = p4:Animation(Color3.new(1, 0.25, 0.25), u3, {
                        From = Color3.new(0.25, 0.25, 0.25)
                    })
                }),
                p4:Create("ImageLabel")({
                    Name = "Left",
                    Image = "rbxassetid://135958450156694",
                    BackgroundTransparency = 1,
                    Position = p4:Animation(UDim2.fromScale(0.5, 0.5), u1, {
                        From = UDim2.fromScale(-0.5, -0.5)
                    }),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Size = UDim2.fromScale(2, 2)
                }),
                p4:Create("ImageLabel")({
                    Name = "Right",
                    Image = "rbxassetid://100349697664920",
                    BackgroundTransparency = 1,
                    Position = p4:Animation(UDim2.fromScale(0.5, 0.5), u2, {
                        From = UDim2.fromScale(1.5, -0.5)
                    }),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Size = UDim2.fromScale(2, 2)
                })
            }),
            p4:Create("Frame")({
                Name = "TextHolder",
                Size = UDim2.fromScale(0.65, 0.9),
                p4:Create("UIAspectRatioConstraint")({
                    AspectRatio = 3.35
                }),
                BackgroundTransparency = 1,
                p4:Create("TextLabel")({
                    BackgroundTransparency = 1,
                    Text = "In Combat",
                    TextScaled = true,
                    Size = UDim2.fromScale(15, 1),
                    Font = Enum.Font.SourceSansSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextColor3 = p4:Animation(Color3.new(1, 0, 0), u3, {
                        From = Color3.new(1, 1, 1)
                    })
                })
            })
        }),
        p4:Create("Frame")({
            Name = "BottomHolder",
            Position = UDim2.fromScale(0.05, 0.485),
            Size = UDim2.fromScale(1, 0.55),
            BackgroundTransparency = 1,
            p4:Create("UIListLayout")({
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = UDim.new(0.015, 0)
            }),
            p4:Create("Frame")({
                Name = "IconHolder",
                Size = UDim2.fromScale(1, 0.8),
                Instance.new("UIAspectRatioConstraint"),
                BackgroundTransparency = 1,
                p4:Create("ImageLabel")({
                    Name = "Clock",
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://120352136875263",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromScale(1, 1),
                    ImageColor3 = Color3.new(1, 1, 1)
                })
            }),
            p4:Create("Frame")({
                Name = "TextHolder",
                Size = UDim2.fromScale(0.2, 0.95),
                p4:Create("UIAspectRatioConstraint")({
                    AspectRatio = 1.5
                }),
                BackgroundTransparency = 1,
                p4:Create("TextLabel")({
                    Name = "Timer",
                    BackgroundTransparency = 1,
                    TextScaled = true,
                    Size = UDim2.fromScale(1, 1),
                    Font = Enum.Font.SourceSansSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextColor3 = Color3.new(1, 1, 1),
                    Text = p4:Do(function(p6: function) -- Line: 134
                        -- upvalues: Utility (ref), u5 (copy)
                        return Utility.formatTime(p6(u5) or 200);
                    end)
                })
            })
        }),
        p4:Create("UICorner")({
            CornerRadius = UDim.new(1)
        })
    });
end;
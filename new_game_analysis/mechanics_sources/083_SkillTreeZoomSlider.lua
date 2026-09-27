-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Packages.faye);
local uidragger = require(ReplicatedStorage.Packages.uidragger);

local function keyHint(p1: any, p2: string, p3, p4: number) -- Line: 21
    return p1:Create("Frame")({
        Name = p2,
        AnchorPoint = p3,
        Position = UDim2.fromScale(p4, 0.5),
        SizeConstraint = Enum.SizeConstraint.RelativeYY,
        Size = UDim2.fromScale(0.8, 0.8),
        BackgroundTransparency = 1,

        function(p5: userdata) -- Line: 29
            p5:SetAttribute("OnlyOn", "Xbox,Playstation");
            p5:AddTag("UIkey");
        end
    });
end;

return function(p6, u7) -- Line: 35
    -- upvalues: uidragger (copy), keyHint (copy)
    local u8 = p6:Add(uidragger.new());
    u8.Changed:Connect(function(p9: table, p10: table?) -- Line: 38
        -- upvalues: u8 (copy), u7 (copy)
        if p10 ~= nil then
            return;
        end;

        u7:Set((math.clamp((p9.X - u8.CurrentValues.Position.X) / u8.CurrentValues.Size.X, 0, 1)));
    end);

    return {
        keyHint(p6, "Zoom_Out", Vector2.new(1, 0.5), -0.05),
        keyHint(p6, "Zoom_In", Vector2.new(0, 0.5), 1.28),
        p6:Create("TextButton")({
            ZIndex = 2,
            BackgroundTransparency = 1,
            AutoButtonColor = false,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1.1, 1.5),

            MouseButton1Down = function(p11) -- Line: 63, Name: MouseButton1Down
                -- upvalues: u8 (copy), u7 (copy)
                u8.UI = p11;
                local v12, v13 = u8:Start();

                if v13 ~= nil then
                    return;
                end;

                u7:Set((math.clamp((v12.X - u8.CurrentValues.Position.X) / u8.CurrentValues.Size.X, 0, 1)));
            end
        }),
        p6:Create("TextLabel")({
            BackgroundTransparency = 1,
            TextScaled = true,
            Size = UDim2.fromScale(0.45, 0.76),
            Position = UDim2.fromScale(0, -0.1),
            TextXAlignment = Enum.TextXAlignment.Left,
            Font = Enum.Font.SourceSansSemibold,
            TextColor3 = Color3.new(1, 1, 1),
            Text = p6:Do(function(p14: function, p15: any, p16: userdata?) -- Line: 76
                -- upvalues: u7 (copy)
                local v17 = p14(u7) * 100;

                return `{math.floor(v17)}%`;
            end)
        }),
        p6:Create("ImageLabel")({
            Size = UDim2.fromScale(0.2, 1),
            Instance.new("UIAspectRatioConstraint"),
            BackgroundTransparency = 1,
            Image = "rbxassetid://107407898800229",
            Position = UDim2.fromScale(1.015)
        }),
        p6:Create("ImageLabel")({
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Image = "rbxassetid://77927274401557",
            ImageTransparency = 0,
            ImageColor3 = Color3.new(0.25, 0.25, 0.25),
            p6:Create("ImageLabel")({
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Image = "rbxassetid://77927274401557",
                p6:Create("UIGradient")({
                    Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 0),
                        NumberSequenceKeypoint.new(0.495, 0),
                        NumberSequenceKeypoint.new(0.505, 1),
                        NumberSequenceKeypoint.new(1, 1)
                    }),
                    Offset = p6:Do(function(p18: function, p19: any, p20: userdata?) -- Line: 104
                        -- upvalues: u7 (copy)
                        return Vector2.new(p18(u7) - 0.5, 0);
                    end)
                })
            })
        })
    };
end;
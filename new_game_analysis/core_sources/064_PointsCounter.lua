-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local faye = require(ReplicatedStorage.Packages.faye);
local Wen = ReplicatedStorage.CAM.Client.Components.Layout.ResetOnSpawn.HUD.HudBottomRight.FirstVertical.Wen;
local LocalPlayer = Players.LocalPlayer;
local Color3_new_ret = Color3.new(1, 1, 1);
local Color3_new_ret2 = Color3.new(1, 0.0745098, 0.0901961);
local u1 = faye.Info(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In);

return function(u2) -- Line: 22
    -- upvalues: LocalPlayer (copy), Utility (copy), Color3_new_ret (copy), Wen (copy), Color3_new_ret2 (copy), u1 (copy), BunchaIcons (copy)
    local function total() -- Line: 23
        -- upvalues: LocalPlayer (ref)
        return tonumber(LocalPlayer:GetAttribute("RunPoints")) or 0;
    end;

    local u3 = u2:Value(tonumber(LocalPlayer:GetAttribute("RunPoints")) or 0);
    u2:Connect(LocalPlayer:GetAttributeChangedSignal("RunPoints"), function() -- Line: 27
        -- upvalues: u3 (copy), LocalPlayer (ref)
        u3:Set(tonumber(LocalPlayer:GetAttribute("RunPoints")) or 0);
    end);
    local u4 = tonumber(LocalPlayer:GetAttribute("RunPoints")) or 0;
    local u5 = u2:Value();
    local u6 = 0;

    local function UpdValue(p7: number, p8: boolean?) -- Line: 37
        -- upvalues: u6 (ref), u4 (ref), u5 (copy), Utility (ref), LocalPlayer (ref), u2 (copy), UpdValue (copy)
        local math_random_ret = math.random(1, 999);
        u6 = math_random_ret;

        if p8 then
            u4 = p7;
        elseif p7 ~= 0 then
            local math_sign_ret = math.sign(p7);
            local v9 = math.abs(p7) * 0.5;
            local math_floor_ret = math.floor(v9);
            u4 = u4 + math.max(math_floor_ret, 1) * math_sign_ret;
        end;

        u5:Set(Utility.addCommasToNumber(u4));

        if u4 ~= (tonumber(LocalPlayer:GetAttribute("RunPoints")) or 0) then
            task.delay(0.05, function() -- Line: 48
                -- upvalues: u6 (ref), math_random_ret (copy), u2 (ref), UpdValue (ref), LocalPlayer (ref), u4 (ref)
                if u6 ~= math_random_ret or not u2.IsActive then
                    return;
                end;

                UpdValue((tonumber(LocalPlayer:GetAttribute("RunPoints")) or 0) - u4);
            end);
        end;
    end;

    UpdValue(tonumber(LocalPlayer:GetAttribute("RunPoints")) or 0, true);
    local v19 = u2:Create("Frame")({
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.fromScale(-0.3, 0.5),
        Size = UDim2.fromScale(10, 0.85),
        BackgroundTransparency = 1,
        u2:Create("TextLabel")({
            Name = "Txt",
            Size = UDim2.fromScale(1, 0.8),
            Text = u5,
            BackgroundTransparency = 1,
            TextScaled = true,
            TextXAlignment = Enum.TextXAlignment.Right,
            TextColor3 = Color3_new_ret,
            FontFace = Font.fromEnum(Enum.Font.SourceSansBold),
            u2:Create("UIStroke")({
                Thickness = 2,
                u2:Create("UIGradient")({
                    Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) })
                })
            })
        }),
        u2:Do(function(p10, p11, p12) -- Line: 80
            -- upvalues: u3 (copy), u4 (ref), Color3_new_ret (ref), Wen (ref), Color3_new_ret2 (ref), Utility (ref), UpdValue (copy), u1 (ref)
            local v13 = p10(u3);

            if u4 ~= nil and u4 ~= v13 then
                local v14 = v13 - u4;
                local u15 = Color3_new_ret;

                if math.sign(v14) < 0 then
                    Wen.Diplete:Play();
                    u15 = Color3_new_ret2;
                else
                    Wen.Gain:Play();
                end;

                local u16;

                if v14 >= 0 then
                    u16 = "+" .. Utility.addCommasToNumber(v14);
                else
                    u16 = Utility.addCommasToNumber(v14);
                end;

                UpdValue(v13 - u4);

                return p11:SpecialThread(function(p17, p18) -- Line: 93
                    -- upvalues: u16 (copy), u15 (ref), u1 (ref)
                    return p17:Create("TextLabel")({
                        Text = u16,
                        Size = UDim2.fromScale(1, 1),
                        Position = UDim2.fromScale(0, -1),
                        BackgroundTransparency = 1,
                        TextScaled = true,
                        TextXAlignment = Enum.TextXAlignment.Right,
                        TextColor3 = u15,
                        TextTransparency = p17:Animation(1, u1),
                        FontFace = Font.fromEnum(Enum.Font.SourceSansBold),
                        p17:Create("UIStroke")({
                            Thickness = 1,
                            Transparency = p17:Animation(1, u1, {
                                From = 0.25
                            })
                        })
                    });
                end, {
                    Lifetime = 1
                });
            end;

            if u4 ~= nil then
                v13 = v13 - u4 or v13;
            end;

            UpdValue(v13);
        end)
    });

    return u2:Create("Frame")({
        Name = "PointsFrame",
        Size = UDim2.fromScale(0.6, 0.6),
        AnchorPoint = Vector2.new(0, 1),
        u2:Create("UIAspectRatioConstraint")({}),
        Position = UDim2.fromScale(0.05, 0.65),
        BackgroundTransparency = 1,
        u2:Create("Frame")({
            Name = "Bg",
            Size = UDim2.fromScale(3, 1),
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.fromScale(1, 0.5),
            BackgroundColor3 = Color3.new(),
            u2:Create("UIGradient")({
                Rotation = 180,
                Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) })
            }),
            u2:Create("UICorner")({
                CornerRadius = UDim.new(1)
            })
        }),
        u2:Create("Frame")({
            Name = "InnerBg",
            Size = UDim2.new(3, -6, 1, -6),
            Position = UDim2.fromScale(-0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            u2:Create("UIStroke")({
                Color = Color3.new(1, 1, 1),
                u2:Create("UIGradient")({
                    Rotation = 180,
                    Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 1) })
                })
            }),
            u2:Create("UICorner")({
                CornerRadius = UDim.new(1)
            })
        }),
        u2:Create("ImageLabel")({
            Name = "Icon",
            BackgroundTransparency = 1,
            ZIndex = 2,
            Size = UDim2.fromScale(0.975, 0.975),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Image = BunchaIcons.OuwigaharaPoints
        }),
        v19
    });
end;
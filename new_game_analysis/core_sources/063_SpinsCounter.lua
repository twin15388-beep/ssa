-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local SpinBalance = require(ReplicatedStorage.CAM.Global.SpinBalance);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local faye = require(ReplicatedStorage.Packages.faye);
local Wen = ReplicatedStorage.CAM.Client.Components.Layout.ResetOnSpawn.HUD.HudBottomRight.FirstVertical.Wen;
local Data = Utility.GetData(Players.LocalPlayer, true);
local Color3_new_ret = Color3.new(1, 1, 1);
local Color3_new_ret2 = Color3.new(1, 0.0745098, 0.0901961);
local u1 = faye.Info(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In);

return function(u2) -- Line: 24
    -- upvalues: SpinBalance (copy), Data (copy), Utility (copy), Color3_new_ret (copy), Wen (copy), Color3_new_ret2 (copy), u1 (copy), BunchaIcons (copy)
    local function total() -- Line: 25
        -- upvalues: SpinBalance (ref), Data (ref)
        return SpinBalance.Total(Data, false);
    end;

    local u3 = SpinBalance.Total(Data, false);
    local u4 = u2:Value();
    local u5 = 0;

    local function UpdValue(p6: number, p7: boolean?) -- Line: 34
        -- upvalues: u5 (ref), u3 (ref), u4 (copy), Utility (ref), SpinBalance (ref), Data (ref), u2 (copy), UpdValue (copy)
        local math_random_ret = math.random(1, 999);
        u5 = math_random_ret;

        if p7 then
            u3 = p6;
        elseif p6 ~= 0 then
            local math_sign_ret = math.sign(p6);
            local v8 = math.abs(p6) * 0.5;
            local math_floor_ret = math.floor(v8);
            u3 = u3 + math.max(math_floor_ret, 1) * math_sign_ret;
        end;

        u4:Set((`{Utility.addCommasToNumber(u3)} Spins`));

        if u3 ~= SpinBalance.Total(Data, false) then
            task.delay(0.05, function() -- Line: 45
                -- upvalues: u5 (ref), math_random_ret (copy), u2 (ref), UpdValue (ref), SpinBalance (ref), Data (ref), u3 (ref)
                if u5 ~= math_random_ret or not u2.IsActive then
                    return;
                end;

                UpdValue(SpinBalance.Total(Data, false) - u3);
            end);
        end;
    end;

    UpdValue(SpinBalance.Total(Data, false), true);
    local v18 = u2:Create("Frame")({
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.fromScale(-0.3, 0.5),
        Size = UDim2.fromScale(10, 0.85),
        BackgroundTransparency = 1,
        u2:Create("TextLabel")({
            Name = "Txt",
            Size = UDim2.fromScale(1, 0.8),
            Text = u4,
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
        u2:Do(function(p9, p10, p11) -- Line: 80
            -- upvalues: SpinBalance (ref), Data (ref), u3 (ref), Color3_new_ret (ref), Wen (ref), Color3_new_ret2 (ref), Utility (ref), UpdValue (copy), u1 (ref)
            local v12 = 0;

            for _, v in SpinBalance.Values(Data, false) do
                v12 = v12 + p9(v);
            end;

            if u3 ~= nil and u3 ~= v12 then
                local v13 = v12 - u3;
                local u14 = Color3_new_ret;

                if math.sign(v13) < 0 then
                    Wen.Diplete:Play();
                    u14 = Color3_new_ret2;
                else
                    Wen.Gain:Play();
                end;

                local u15;

                if v13 >= 0 then
                    u15 = "+" .. Utility.addCommasToNumber(v13);
                else
                    u15 = Utility.addCommasToNumber(v13);
                end;

                UpdValue(v12 - u3);

                return p10:SpecialThread(function(p16, p17) -- Line: 96
                    -- upvalues: u15 (copy), u14 (ref), u1 (ref)
                    return p16:Create("TextLabel")({
                        Text = u15,
                        Size = UDim2.fromScale(1, 1),
                        Position = UDim2.fromScale(0, -1),
                        BackgroundTransparency = 1,
                        TextScaled = true,
                        TextXAlignment = Enum.TextXAlignment.Right,
                        TextColor3 = u14,
                        TextTransparency = p16:Animation(1, u1),
                        FontFace = Font.fromEnum(Enum.Font.SourceSansBold),
                        p16:Create("UIStroke")({
                            Thickness = 1,
                            Transparency = p16:Animation(1, u1, {
                                From = 0.25
                            })
                        })
                    });
                end, {
                    Lifetime = 1
                });
            end;

            if u3 ~= nil then
                v12 = v12 - u3 or v12;
            end;

            UpdValue(v12);
        end)
    });

    return u2:Create("Frame")({
        Name = "SpinsFrame",
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
            Image = BunchaIcons.Spins3D
        }),
        v18
    });
end;
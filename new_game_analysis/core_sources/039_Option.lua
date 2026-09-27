-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local faye = require(ReplicatedStorage.Packages.faye);
local _ = faye.SpringInfo;
local Info = faye.Info;
local ScreenEffects = require(ReplicatedStorage.CAM.Client.Components.Misc.ScreenEffects);
local DialogueUtility = require(ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.DialogueUtility);
local u1 = Info(0.2);
local _ = typeof;
local u2 = Info(0.1, Enum.EasingStyle.Sine);

return function(u3: any, u4: string, u5: string, p6: number, p7: any) -- Line: 14
    -- upvalues: ScreenEffects (copy), DialogueUtility (copy), u2 (copy), u1 (copy)
    local v8 = (p6 - 1) * 0.025;
    local v9 = u3:Value(Color3.new(0.15, 0.15, 0.15));
    local v10 = u3:Value(Color3.new());
    local v11 = u3:Value(Color3.new(1, 1, 1));
    local v12 = u3:Value(UDim2.fromScale(1, 1));
    local v13 = u3:Value(1);
    local u14 = p7:Add({
        In = false,
        S = v12,
        ST = v13,
        Fg = v9,
        Bg = v10,
        Txt = v11
    }, u3, true);

    return u3:Create("TextButton")({
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        AutoButtonColor = false,

        MouseEnter = function() -- Line: 27, Name: MouseEnter
            -- upvalues: u14 (copy)
            u14.In = true;
            u14:Call();
        end,

        MouseLeave = function() -- Line: 31, Name: MouseLeave
            -- upvalues: u14 (copy)
            u14.In = false;
            u14:Call();
        end,

        MouseButton1Click = function(p15) -- Line: 35, Name: MouseButton1Click
            -- upvalues: ScreenEffects (ref), DialogueUtility (ref), u5 (copy), u4 (copy)
            ScreenEffects.CircleClick();
            DialogueUtility.DoAll(u5, u4);
        end,

        u3:Create("TextLabel")({
            Name = "Copytxtforbounds",
            TextScaled = true,
            BackgroundTransparency = 1,
            TextTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(15, 0.7),
            Text = u4,
            Font = Enum.Font.SourceSansSemibold
        }),
        After = { function(p16) -- Line: 51
                local math_max_ret = math.max((p16.Copytxtforbounds.TextBounds.X + 25) / p16.AbsoluteSize.X, 1);
                p16.Size = UDim2.fromScale(math_max_ret, 1);
                p16.Copytxtforbounds:Destroy();
            end },
        CleanDelay = 0.25,
        u3:Create("Frame")({
            Name = "Actual",
            Size = u3:Animation(v12, u2, {
                FirstDelayTime = v8,
                From = UDim2.fromScale(0.75, 0.75)
            }),
            BackgroundColor3 = u3:Animation(v9, u1),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Visible = u3:DelayProperty(true, v8, false),
            BackgroundTransparency = 0.1,
            u3:Create("UICorner")({
                CornerRadius = UDim.new(1)
            }),

            CleanFunction = function() -- Line: 72, Name: CleanFunction
                -- upvalues: u3 (copy), u1 (ref)
                return {
                    BackgroundTransparency = u3:Animation(1, u1)
                };
            end,

            u3:Create("TextLabel")({
                TextScaled = true,
                BackgroundTransparency = 1,
                ZIndex = 2,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(15, 0.7),
                TextColor3 = u3:Animation(v11, u1),
                Text = u4,
                Font = Enum.Font.SourceSansSemibold,

                CleanFunction = function() -- Line: 87, Name: CleanFunction
                    -- upvalues: u3 (copy), u1 (ref)
                    return {
                        TextTransparency = u3:Animation(1, u1)
                    };
                end
            }),
            u3:Create("Frame")({
                Name = "Inner",
                Size = UDim2.new(1, -6, 1, -6),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                u3:Create("UICorner")({
                    CornerRadius = UDim.new(1)
                }),
                BackgroundTransparency = 1,
                u3:Create("UIStroke")({
                    Thickness = 1,

                    CleanFunction = function() -- Line: 104, Name: CleanFunction
                        -- upvalues: u14 (copy), u3 (copy), u1 (ref)
                        if u14.In then
                            return {
                                Transparency = u3:Animation(1, u1)
                            };
                        end;
                    end,

                    Transparency = u3:Animation(v13, u1)
                })
            }),
            u3:Create("Frame")({
                Name = "Bg",
                Size = UDim2.new(1, -5, 1, -5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                BackgroundColor3 = u3:Animation(v10, u1),
                u3:Create("UIGradient")({
                    Rotation = 90,
                    Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.9), NumberSequenceKeypoint.new(1, 1) })
                }),
                u3:Create("UICorner")({
                    CornerRadius = UDim.new(1)
                }),

                CleanFunction = function() -- Line: 130, Name: CleanFunction
                    -- upvalues: u3 (copy), u1 (ref)
                    return {
                        BackgroundTransparency = u3:Animation(1, u1)
                    };
                end
            })
        })
    });
end;
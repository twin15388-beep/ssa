-- Decompiled with Potassium's decompiler.

local GuiService = game:GetService("GuiService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local GradientButton = require(ReplicatedStorage.CAM.Client.Components.Misc.Buttons.GradientButton);
local faye = require(ReplicatedStorage.Packages.faye);
local TrainingUiScale = require(ReplicatedStorage.CAM.Client.Modules.GamePlay.TrainingUiScale);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local PlatformLeniency = require(ReplicatedStorage.CAM.Client.Modules.GamePlay.PlatformLeniency);
local Training = ReplicatedStorage.Assets.Sounds.Training;

local function PlayTrainingSound(p1: string) -- Line: 13
    -- upvalues: Training (copy)
    local v2 = Training:FindFirstChild(p1);

    if v2 == nil then
        return;
    end;

    local u3 = v2:Clone();
    u3.Parent = script;
    u3:Play();
    u3.Ended:Once(function() -- Line: 19
        -- upvalues: u3 (copy)
        u3:Destroy();
    end);
end;

local UDim2_fromScale_ret = UDim2.fromScale(1.2, 0.1);
local u4 = faye.Info(0.35);
local Color3_new_ret = Color3.new(1, 1, 1);
local Color3_new_ret2 = Color3.new(1, 0, 0);
local Color3_new_ret3 = Color3.new(1, 0.901961, 0);
local Color3_new_ret4 = Color3.new(0.368627, 1, 0);

return function(p5: any, p6: table?) -- Line: 67
    -- upvalues: faye (copy), UDim2_fromScale_ret (copy), u4 (copy), Color3_new_ret (copy), Color3_new_ret2 (copy), Color3_new_ret4 (copy), Color3_new_ret3 (copy), GuiService (copy), TrainingUiScale (copy), GradientButton (copy), PlayTrainingSound (copy), PlatformLeniency (copy), RunService (copy), Utility (copy)
    local v7 = p6 or {};
    local Stop = v7.Stop;
    local u8 = v7.Thread and v7.Thread:Extend() or faye.new();
    local v9 = v7.TrackerSize or UDim2_fromScale_ret;
    local u10 = v7.TransitionInfo or u4;
    local u11 = v7.ColorStart or Color3_new_ret;
    local u12 = v7.ColorEnd or Color3_new_ret2;
    local u13 = v7.InsideColor or Color3_new_ret4;
    local v14 = v7.OutsideColor or Color3_new_ret3;
    local GuiInset = GuiService:GetGuiInset();
    local u15 = false;
    local v16 = v7.StartingPercent or 50;
    local u17 = v7.WinPercent or 100;
    local u18 = v7.LosePercent or 0;
    local u19 = 0;
    local u20 = u8:Value(UDim2.new(0.5, 0, 1 - v9.Y.Scale / 2, 0));
    local u21 = v16;
    local u22 = u8:Value(math.floor(v16) .. "%");
    local u23 = u8:Value(false);
    local u24 = u8:Value(v14);
    local u25 = u8:Value(u11);
    local u26 = u8:Value(UDim2.fromScale(0.5, 0.5));
    u23.Changed:Connect(function(p27) -- Line: 95
        -- upvalues: u24 (copy), u13 (copy)
        if p27 then
            u24:Set(u13);

            return;
        end;

        u24:Reset();
    end);
    local u28 = 0;
    local u29 = 0;
    local u30 = u8:Value(UDim2.new(0.5, 0, 1, 0));
    local u31 = nil;
    local u32 = nil;
    local v33 = u8:Create("CanvasGroup");
    local v39 = {
        Parent = p5,
        Size = UDim2.new(1, 0, 1, GuiInset.Y),
        Position = UDim2.new(0, 0, 0, -GuiInset.Y),
        BackgroundTransparency = 1,
        GroupTransparency = u8:Animation(0, u10, {
            From = 1
        }),

        OnClean = function(p34) -- Line: 123, Name: OnClean
            -- upvalues: u10 (copy)
            return {
                GroupTransparency = p34:Animation(1, u10)
            };
        end,

        InputBegan = function(p35: userdata, p36: userdata) -- Line: 128, Name: InputBegan
            -- upvalues: u15 (ref)
            if p36.UserInputType ~= Enum.UserInputType.MouseButton1 and p36.UserInputType ~= Enum.UserInputType.Touch then
                return;
            end;

            u15 = true;
        end,

        InputEnded = function(p37: userdata, p38: userdata) -- Line: 133, Name: InputEnded
            -- upvalues: u15 (ref)
            if p38.UserInputType ~= Enum.UserInputType.MouseButton1 and p38.UserInputType ~= Enum.UserInputType.Touch then
                return;
            end;

            u15 = false;
        end
    };
    local v42 = u8:Create("Frame")({
        Size = TrainingUiScale.Size(UDim2.fromScale(0.025, 0.5)),
        u8:Create("UIAspectRatioConstraint")({
            AspectRatio = 0.125
        }),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.75, 0.5),
        u8:Create("UICorner")({
            CornerRadius = UDim.new(0.2)
        }),
        BackgroundColor3 = Color3.new(0.1, 0.1, 0.1),
        BackgroundTransparency = 0,
        u8:Create("UIGradient")({
            Rotation = -90,
            Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.25), NumberSequenceKeypoint.new(1, 0.75) })
        }),
        u8:Create("UIStroke")({
            Thickness = 1,
            Color = Color3.new(1, 1, 1),
            BorderOffset = UDim.new(0, 2),
            u8:Create("UIGradient")({
                Rotation = 160,
                Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0.75) })
            })
        }),
        u8:Create("Frame")({
            Name = "tracker",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = v9,
            BackgroundTransparency = 0.8,
            u8:Create("UICorner")({
                CornerRadius = UDim.new(0.2)
            }),
            ZIndex = 3,
            Position = u20,
            BackgroundColor3 = u8:Animation(u24, u10),

            After = function(p40) -- Line: 183, Name: After
                -- upvalues: u31 (ref)
                u31 = p40;
            end,

            u8:Create("UIStroke")({
                Thickness = 1,
                Color = u8:Animation(u24, u10)
            })
        }),
        u8:Create("Frame")({
            Name = "Bar",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = u30,
            ZIndex = 2,
            Size = UDim2.fromScale(0.5, 0.5),
            Instance.new("UIAspectRatioConstraint"),

            After = function(p41) -- Line: 196, Name: After
                -- upvalues: u32 (ref)
                u32 = p41;
            end,

            u8:Create("UICorner")({
                CornerRadius = UDim.new(0.2)
            }),
            u8:Create("UIGradient")({
                Rotation = 160,
                Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0.5) })
            }),
            u8:Create("UIStroke")({
                Thickness = 1,
                Color = Color3.new(1, 1, 1),
                BorderOffset = UDim.new(0, 2),
                u8:Create("UIGradient")({
                    Rotation = 160,
                    Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.65), NumberSequenceKeypoint.new(1, 0.8) })
                })
            })
        }),
        u8:Create("Frame")({
            Size = UDim2.new(1, -8, 1, -8),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            u8:Create("UICorner")({
                CornerRadius = UDim.new(0.2)
            }),
            u8:Create("ImageLabel")({
                Size = UDim2.fromScale(3.5, 1),
                Image = "rbxassetid://119835436329241",
                BackgroundTransparency = 1,
                ScaleType = Enum.ScaleType.Tile,
                TileSize = UDim2.fromScale(1, 0.4),
                u8:Create("UIGradient")({
                    Rotation = 160,
                    Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0.85) })
                })
            }),
            BackgroundColor3 = Color3.new(),
            u8:Create("UIGradient")({
                Rotation = 230,
                Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.75), NumberSequenceKeypoint.new(1, 1) })
            }),
            u8:Create("UIStroke")({
                Thickness = 1,
                Color = Color3.new(1, 1, 1),
                BorderOffset = UDim.new(0, 2),
                u8:Create("UIGradient")({
                    Rotation = 160,
                    Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.65), NumberSequenceKeypoint.new(1, 0.8) })
                })
            })
        })
    });
    local v43 = u8:Create("Frame");
    local v44 = {
        Name = "Progressholder",
        Size = UDim2.fromScale(0.2, 0.3),
        Position = UDim2.fromScale(0.5, 0.98),
        AnchorPoint = Vector2.new(0.5, 1),
        u8:Create("UIAspectRatioConstraint")({
            AspectRatio = 3
        }),
        BackgroundTransparency = 1
    };
    local v45 = u8:Create("TextLabel")({
        BackgroundTransparency = 1,
        ZIndex = 2,
        TextScaled = true,
        Size = UDim2.fromScale(1, 0.2),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = u26,
        Font = Enum.Font.SourceSansSemibold,
        Text = u22,
        TextColor3 = u25
    });
    local v46 = u8:Create("ImageLabel")({
        Name = "Bg",
        Image = "rbxassetid://134657809787110",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 1),
        ImageColor3 = Color3.new(0.05, 0.05, 0.05)
    });
    local v47;

    if v7.NoExit == true then
        v47 = nil;
    else
        v47 = u8:Create("Frame")({
            Size = UDim2.fromScale(0.3, 0.27),
            u8:Create("UIAspectRatioConstraint")({
                AspectRatio = 3
            }),
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 1.05),
            GradientButton(u8, {
                Text = "Exit",
                TextXAlignment = Enum.TextXAlignment.Center,
                GradientTransparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.75), NumberSequenceKeypoint.new(1, 0.3) }),

                Clicked = function() -- Line: 319, Name: Clicked
                    -- upvalues: Stop (copy), PlayTrainingSound (ref)
                    if Stop ~= nil then
                        PlayTrainingSound("TrainingExit");
                        Stop(false);
                    end;
                end,

                Properties = {
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.fromScale(0.5, 0)
                }
            })
        });
    end;

    v44[2], v44[3], v44[4] = v45, v46, v47;
    v39[1], v39[2] = v42, v43(v44);
    v33(v39);
    local u48 = 0;
    local u49 = 0;
    local u50 = 0;
    local u51 = 0;
    local v52 = PlatformLeniency();
    local u53 = (v7.MinSpeed or 0.08) / v52;
    local u54 = (v7.MaxSpeed or 0.48) / v52;
    local u55 = (v7.MinCommit or 0.25) * v52;
    local u56 = (v7.MaxCommit or 1) * v52;
    local u57 = (v7.Smoothing or 4) / v52;
    local u58 = u54 * (v7.BarSpeedMult or 1.5);
    local u59 = (v7.BarSizeScale or 0.55) * (v7.ParentAspect or 0.125) / 2;
    local u60 = v7.PercentStep or 1;
    local u61 = v7.PercentGainTick or 0.1;
    local u62 = u61 * (v7.PercentLossMult or 0.65);
    local u63 = 0;
    local u64 = false;
    local u65 = v7.ShakeThreshold or 30;
    local u66 = v7.ShakeAmplitude or 8;
    local u67 = v7.ShakeFrequency or 25;
    local u68 = 0;
    local u69 = v9.Y.Scale / 2;

    local function rollVelocity() -- Line: 383
        -- upvalues: u49 (ref), u53 (copy), u54 (copy), u51 (ref), u55 (copy), u56 (copy), u50 (ref)
        u49 = (u53 + math.random() * (u54 - u53)) * (math.random() < 0.5 and -1 or 1);
        u51 = u55 + math.random() * (u56 - u55);
        u50 = 0;
    end;

    u49 = (u53 + math.random() * (u54 - u53)) * (math.random() < 0.5 and -1 or 1);
    u51 = u55 + math.random() * (u56 - u55);
    u50 = 0;
    local u79 = RunService.RenderStepped:Connect(function(p70) -- Line: 391
        -- upvalues: u64 (ref), u50 (ref), u51 (ref), u49 (ref), u53 (copy), u54 (copy), u55 (copy), u56 (copy), u57 (copy), u48 (ref), u19 (ref), u20 (copy), u69 (copy), u15 (ref), u58 (copy), u29 (ref), u28 (ref), u30 (copy), u59 (copy), u31 (ref), u32 (ref), u23 (copy), u61 (copy), u62 (copy), u63 (ref), u21 (ref), u60 (copy), u17 (copy), u22 (copy), u25 (copy), Utility (ref), u12 (copy), u11 (copy), Stop (copy), u8 (copy), u18 (copy), u65 (copy), u68 (ref), u67 (copy), u66 (copy), u26 (copy)
        if u64 then
            return;
        end;

        u50 = u50 + p70;

        if u51 <= u50 then
            u49 = (u53 + math.random() * (u54 - u53)) * (math.random() < 0.5 and -1 or 1);
            u51 = u55 + math.random() * (u56 - u55);
            u50 = 0;
        end;

        local math_min_ret = math.min(u57 * p70, 1);
        u48 = u48 + (u49 - u48) * math_min_ret;
        u19 = u19 + u48 * p70;

        if u19 >= 1 then
            u19 = 1;
            u48 = -math.abs(u48);
            u49 = -math.abs(u49);
        elseif u19 <= 0 then
            u19 = 0;
            u48 = math.abs(u48);
            u49 = math.abs(u49);
        end;

        u20:Set(UDim2.new(0.5, 0, u69 + (1 - 2 * u69) * (1 - u19), 0));
        local math_min_ret2 = math.min(u57 * p70, 1);
        u29 = u29 + ((u15 and u58 or -u58) - u29) * math_min_ret2;
        u28 = u28 + u29 * p70;

        if u28 >= 1 then
            u28 = 1;
            u29 = math.min(0, u29);
        elseif u28 <= 0 then
            u28 = 0;
            u29 = math.max(0, u29);
        end;

        u30:Set(UDim2.new(0.5, 0, u59 + (1 - 2 * u59) * (1 - u28), 0));
        local v71;

        if u31 and (u32 and u31.AbsoluteSize.Y > 0) then
            local Y = u31.AbsolutePosition.Y;
            local v72 = Y + u31.AbsoluteSize.Y;
            local Y2 = u32.AbsolutePosition.Y;

            if Y <= Y2 + u32.AbsoluteSize.Y then
                v71 = Y2 <= v72;
            else
                v71 = false;
            end;
        else
            v71 = false;
        end;

        u23:Set(v71);
        local v73 = v71 and u61 or u62;
        u63 = u63 + p70;

        while v73 <= u63 do
            u63 = u63 - v73;
            local v74 = u21 + (v71 and u60 or -u60);

            if u17 <= v74 then
                u21 = u17;
                u22:Set(math.floor(u17) .. "%");
                u25:Set(Utility.Lerp_Color2(u12, u11, 1));
                u64 = true;

                if Stop then
                    Stop(true);
                end;

                u8:Destroy();
                break;
            end;

            if v74 <= u18 then
                u21 = u18;
                u22:Set(math.floor(u18) .. "%");
                u25:Set(Utility.Lerp_Color2(u12, u11, 0));
                u64 = true;

                if Stop then
                    Stop(false);
                end;

                u8:Destroy();
                break;
            end;

            u21 = v74;
            u22:Set(math.floor(v74) .. "%");
            u25:Set(Utility.Lerp_Color2(u12, u11, (v74 - u18) / (u17 - u18)));
        end;

        if u21 >= u65 then
            u68 = 0;
            u26:Reset();

            return;
        end;

        u68 = u68 + p70;
        local v75 = (u65 - u21) / u65;
        local v76 = u68 * u67;
        local v77 = math.noise(v76, 0, 0) * u66 * v75;
        local v78 = math.noise(0, v76, 7.3) * u66 * v75;
        u26:Set(UDim2.fromScale(0.5, 0.5) + UDim2.fromOffset(v77, v78));
    end);

    return function() -- Line: 488
        -- upvalues: u79 (ref), u8 (copy)
        if u79 then
            u79:Disconnect();
            u79 = nil;
        end;

        u8:Destroy();
    end, u22;
end;
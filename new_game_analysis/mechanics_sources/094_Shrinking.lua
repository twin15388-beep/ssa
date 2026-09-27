-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local faye = require(ReplicatedStorage.Packages.faye);
local TrainingUiScale = require(ReplicatedStorage.CAM.Client.Modules.GamePlay.TrainingUiScale);
local GradientButton = require(ReplicatedStorage.CAM.Client.Components.Misc.Buttons.GradientButton);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local PlatformLeniency = require(ReplicatedStorage.CAM.Client.Modules.GamePlay.PlatformLeniency);
local Training = ReplicatedStorage.Assets.Sounds.Training;

local function PlayTrainingSound(p1: string) -- Line: 11
    -- upvalues: Training (copy)
    local v2 = Training:FindFirstChild(p1);

    if v2 == nil then
        return;
    end;

    local u3 = v2:Clone();
    u3.Parent = script;
    u3:Play();
    u3.Ended:Once(function() -- Line: 17
        -- upvalues: u3 (copy)
        u3:Destroy();
    end);
end;

local Random_new_ret = Random.new();
local TweenService = game:GetService("TweenService");
local Out = Enum.EasingDirection.Out;
local Linear = Enum.EasingStyle.Linear;
local Color3_new_ret = Color3.new(0.14902, 0.894118, 0.14902);
local Color3_new_ret2 = Color3.new(1, 0, 0);
local Color3_new_ret3 = Color3.new(1, 1, 1);
local Color3_new_ret4 = Color3.new(1, 0, 0);
local u4 = faye.Info(0.3);

return function(p5: any, p6: table?) -- Line: 87
    -- upvalues: faye (copy), PlatformLeniency (copy), Out (copy), Linear (copy), Color3_new_ret (copy), Color3_new_ret2 (copy), u4 (copy), Color3_new_ret3 (copy), Color3_new_ret4 (copy), TrainingUiScale (copy), Utility (copy), GradientButton (copy), PlayTrainingSound (copy), RunService (copy), Random_new_ret (copy), TweenService (copy)
    local v7 = p6 or {};
    local u8 = v7.Thread and v7.Thread:Extend() or faye.new();
    local Stop = v7.Stop;
    local v9 = PlatformLeniency();
    local u10 = (v7.AppearTime or 1.5) * v9;
    local u11 = (v7.LifeTime or 3) * v9;
    local u12 = v7.EasingDirection or Out;
    local u13 = v7.EasingStyle or Linear;
    local u14 = v7.StartShrinking or 1.5;
    local u15 = v7.EndShrinking or 0;
    local u16 = (v7.ShrinkCycle or 1) * v9;
    local u17 = v7.DiffAccepted or 0.125;
    local u18 = v7.ShakeStart or 0.4;
    local u19 = v7.ShakeAmplitude or 6;
    local u20 = v7.ShakeFrequency or 35;
    local u21 = v7.SuccessColor or Color3_new_ret;
    local u22 = v7.FailColor or Color3_new_ret2;
    local u23 = v7.TransitionInfo or u4;
    local v24 = v7.CounterStart or 50;
    local u25 = v7.CounterWin or 100;
    local u26 = v7.CounterLose or 0;
    local u27 = v7.CounterGain or 25;
    local u28 = v7.CounterLoss or 10;
    local u29 = v7.CounterDrain or 1;
    local u30 = (v7.CounterTick or 0.1) * v9;
    local u31 = v7.CounterColorStart or Color3_new_ret3;
    local u32 = v7.CounterColorEnd or Color3_new_ret4;
    local u33 = v7.CounterShakeThreshold or 30;
    local u34 = v7.CounterShakeAmplitude or 8;
    local u35 = v7.CounterShakeFrequency or 25;
    local Instance2 = u8:Create("Frame")({
        ZIndex = 2,
        BackgroundTransparency = 1,
        Parent = p5,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = TrainingUiScale.Size(UDim2.fromScale(0.6, 0.5)),
        CleanDelay = u23.Time,

        OnClean = function(p36) -- Line: 139, Name: OnClean
            -- upvalues: u23 (copy)
            return {
                BackgroundTransparency = p36:Animation(1, u23)
            };
        end
    }).Instance;
    local u37 = v24;
    local u38 = u8:Value(math.floor(u37) .. "%");
    local u39 = u8:Value(u31);
    local u40 = u8:Value(UDim2.fromScale(0.5, 0.5));
    local u41 = false;

    local function finish(p42: boolean) -- Line: 153
        -- upvalues: u41 (ref), Stop (copy), u8 (copy)
        if u41 then
            return;
        end;

        u41 = true;

        if Stop then
            Stop(p42);
        end;

        u8:Destroy();
    end;

    local function adjustCounter(p43: number) -- Line: 159
        -- upvalues: u41 (ref), u37 (ref), u26 (copy), u25 (copy), u38 (copy), u39 (copy), Utility (ref), u32 (copy), u31 (copy), Stop (copy), u8 (copy)
        if u41 then
            return;
        end;

        u37 = math.clamp(u37 + p43, u26, u25);
        u38:Set(math.floor(u37) .. "%");
        u39:Set(Utility.Lerp_Color2(u32, u31, (u37 - u26) / (u25 - u26)));

        if u25 > u37 then
            if u37 <= u26 then
                if u41 then
                    return;
                end;

                u41 = true;

                if Stop then
                    Stop(false);
                end;

                u8:Destroy();
            end;

            return;
        end;

        if u41 then
            return;
        end;

        u41 = true;

        if Stop then
            Stop(true);
        end;

        u8:Destroy();
    end;

    u8:Create("Frame")({
        Parent = p5,
        Name = "Progressholder",
        Size = TrainingUiScale.Size(UDim2.fromScale(0.2, 0.3)),
        Position = UDim2.fromScale(0.5, TrainingUiScale.Factor() > 1 and 0.95 or 0.98),
        AnchorPoint = Vector2.new(0.5, 1),
        u8:Create("UIAspectRatioConstraint")({
            AspectRatio = 3
        }),
        BackgroundTransparency = 1,
        u8:Create("TextLabel")({
            BackgroundTransparency = 1,
            ZIndex = 2,
            TextScaled = true,
            Size = UDim2.fromScale(1, 0.2),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = u40,
            Font = Enum.Font.SourceSansSemibold,
            Text = u38,
            TextColor3 = u39
        }),
        u8:Create("ImageLabel")({
            Name = "Bg",
            Image = "rbxassetid://134657809787110",
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1),
            ImageColor3 = Color3.new(0.05, 0.05, 0.05)
        }),
        u8:Create("Frame")({
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

                Clicked = function() -- Line: 221, Name: Clicked
                    -- upvalues: PlayTrainingSound (ref), u41 (ref), Stop (copy), u8 (copy)
                    PlayTrainingSound("TrainingExit");

                    if u41 then
                        return;
                    end;

                    u41 = true;

                    if Stop then
                        Stop(false);
                    end;

                    u8:Destroy();
                end,

                Properties = {
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.fromScale(0.5, 0)
                }
            })
        })
    });
    local u44 = 0;
    u8:Add(RunService.RenderStepped:Connect(function(p45) -- Line: 236
        -- upvalues: u37 (ref), u33 (copy), u44 (ref), u35 (copy), u34 (copy), u40 (copy)
        if u37 >= u33 then
            u44 = 0;
            u40:Reset();

            return;
        end;

        u44 = u44 + p45;
        local v46 = (u33 - u37) / u33;
        local v47 = u44 * u35;
        local v48 = math.noise(v47, 0, 0) * u34 * v46;
        local v49 = math.noise(0, v47, 7.3) * u34 * v46;
        u40:Set(UDim2.fromScale(0.5, 0.5) + UDim2.fromOffset(v48, v49));
    end));
    task.spawn(function() -- Line: 252
        -- upvalues: u8 (copy), u30 (copy), adjustCounter (copy), u29 (copy)
        while u8.IsActive and task.wait(u30) do
            adjustCounter(-u29);
        end;
    end);
    task.spawn(function() -- Line: 258
        -- upvalues: u8 (copy), PlayTrainingSound (ref), adjustCounter (copy), u27 (copy), u28 (copy), u17 (copy), Random_new_ret (ref), Instance2 (copy), u14 (copy), u23 (copy), u21 (copy), u22 (copy), RunService (ref), u16 (copy), TweenService (ref), u13 (copy), u12 (copy), u15 (copy), u11 (copy), u18 (copy), u20 (copy), u19 (copy), u10 (copy)
        while u8.IsActive do
            local u50 = u8:Extend();
            local u51 = nil;
            local u52 = nil;
            local u53 = nil;
            local u54 = false;

            local function Complete(p55: boolean) -- Line: 268
                -- upvalues: u54 (ref), PlayTrainingSound (ref), adjustCounter (ref), u27 (ref), u28 (ref)
                u54 = p55;
                PlayTrainingSound(p55 and "TrainingCompleteTRUE" or "TrainingCompleteFALSE");
                adjustCounter(p55 and u27 or -u28);
            end;

            local function v57() -- Line: 274
                -- upvalues: u51 (ref), u52 (ref), u53 (ref), u17 (ref), u54 (ref), PlayTrainingSound (ref), adjustCounter (ref), u27 (ref), u28 (ref), u50 (copy)
                if u51 then
                    u51:Disconnect();
                    u51 = nil;
                end;

                local v56 = math.abs(u52.Size.X.Scale - u53.Size.X.Scale) < u17;
                u54 = v56;
                PlayTrainingSound(v56 and "TrainingCompleteTRUE" or "TrainingCompleteFALSE");
                adjustCounter(v56 and u27 or -u28);
                u50:Destroy();
            end;

            local UDim2_fromScale_ret = UDim2.fromScale(Random_new_ret:NextNumber(), Random_new_ret:NextNumber());
            local Instance3 = u50:Create("Frame")({
                Parent = Instance2,
                Position = UDim2_fromScale_ret,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Size = UDim2.fromScale(0.15, 0.15),
                Instance.new("UIAspectRatioConstraint"),
                BackgroundTransparency = 1,
                Name = "Pod",
                u8:Create("TextButton")({
                    BackgroundTransparency = 1,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromScale(u14, u14),
                    MouseButton1Up = v57
                }),
                CleanDelay = u23.Time,
                u50:Create("Frame")({
                    Size = UDim2.fromScale(1, 1),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.5),
                    BackgroundTransparency = 1,
                    Name = "Holder",
                    u50:Create("UICorner")({
                        CornerRadius = UDim.new(1)
                    }),
                    u50:Create("ImageLabel")({
                        BackgroundTransparency = 1,
                        Image = "rbxassetid://134657809787110",
                        Size = UDim2.fromScale(1.5, 1.5),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.fromScale(0.5, 0.5),
                        ImageTransparency = u8:Animation(0, u23, {
                            From = 1
                        }),

                        OnClean = function(p58) -- Line: 317, Name: OnClean
                            -- upvalues: u23 (ref), u54 (ref), u21 (ref), u22 (ref)
                            return {
                                ImageTransparency = p58:Animation(1, u23),
                                ImageColor3 = p58:Animation(u54 and u21 or u22, u23)
                            };
                        end
                    }),
                    u50:Create("UIStroke")({
                        Thickness = 3,
                        Color = Color3.new(1, 1, 1),
                        Transparency = u8:Animation(0, u23, {
                            From = 1
                        }),

                        OnClean = function(p59) -- Line: 328, Name: OnClean
                            -- upvalues: u23 (ref), u54 (ref), u21 (ref), u22 (ref)
                            return {
                                Transparency = p59:Animation(1, u23),
                                Color = p59:Animation(u54 and u21 or u22, u23)
                            };
                        end
                    })
                }),
                u50:Create("Frame")({
                    Name = "Shrink",
                    Size = UDim2.fromScale(u14, u14),
                    Position = UDim2.fromScale(0.5, 0.5),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 1,
                    u50:Create("UICorner")({
                        CornerRadius = UDim.new(1)
                    }),
                    u50:Create("UIStroke")({
                        Thickness = 2,
                        Color = Color3.new(1, 1, 1),
                        Transparency = u8:Animation(0, u23, {
                            From = 1
                        }),

                        OnClean = function(p60) -- Line: 349, Name: OnClean
                            -- upvalues: u23 (ref), u54 (ref), u21 (ref), u22 (ref)
                            return {
                                Transparency = p60:Animation(1, u23),
                                Color = p60:Animation(u54 and u21 or u22, u23)
                            };
                        end
                    })
                })
            }).Instance;
            u52 = Instance3:FindFirstChild("Shrink");
            u53 = Instance3:FindFirstChild("Holder");
            local u61 = 0;
            u51 = RunService.RenderStepped:Connect(function(p62: number) -- Line: 362
                -- upvalues: u8 (ref), u50 (copy), u51 (ref), u61 (ref), u16 (ref), TweenService (ref), u13 (ref), u12 (ref), u14 (ref), u15 (ref), u52 (ref), u11 (ref), u18 (ref), u20 (ref), u19 (ref), Instance3 (copy), UDim2_fromScale_ret (copy)
                if not (u8.IsActive and u50.IsActive) then
                    u51:Disconnect();
                    u51 = nil;

                    return;
                end;

                u61 = u61 + p62;
                local Value = TweenService:GetValue(1 - math.abs(1 - u61 % (u16 * 2) / u16), u13, u12);
                local v63 = u14 + (u15 - u14) * Value;
                u52.Size = UDim2.fromScale(v63, v63);
                local v64 = u11 * u18;

                if v64 <= u61 then
                    local math_clamp_ret = math.clamp((u61 - v64) / (u11 - v64), 0, 1);
                    local v65 = u61 * u20;
                    local v66 = math.noise(v65, 0, 0) * u19 * math_clamp_ret;
                    local v67 = math.noise(0, v65, 7.3) * u19 * math_clamp_ret;
                    Instance3.Position = UDim2_fromScale_ret + UDim2.fromOffset(v66, v67);
                end;
            end);
            task.delay(u11, function() -- Line: 392
                -- upvalues: u8 (ref), u50 (copy), u54 (ref), PlayTrainingSound (ref), adjustCounter (ref), u28 (ref)
                if not u8.IsActive then
                    return;
                end;

                if u50.IsActive then
                    u54 = false;
                    PlayTrainingSound("TrainingCompleteFALSE");
                    adjustCounter(-u28);
                    u50:Destroy();
                end;
            end);
            task.wait(u10);
        end;
    end);

    return function() -- Line: 408
        -- upvalues: u8 (copy)
        u8:Destroy();
    end, u38;
end;
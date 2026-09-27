-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local GuiService = game:GetService("GuiService");
local GradientButton = require(ReplicatedStorage.CAM.Client.Components.Misc.Buttons.GradientButton);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local TrainingUiScale = require(ReplicatedStorage.CAM.Client.Modules.GamePlay.TrainingUiScale);
local PlatformLeniency = require(ReplicatedStorage.CAM.Client.Modules.GamePlay.PlatformLeniency);
local faye = require(ReplicatedStorage.Packages.faye);
local Random_new_ret = Random.new();
local TweenService = game:GetService("TweenService");
local Training = ReplicatedStorage.Assets.Sounds.Training;

local function PlayTrainingSound(p1: string) -- Line: 16
    -- upvalues: Training (copy)
    local v2 = Training:FindFirstChild(p1);

    if v2 == nil then
        return;
    end;

    local u3 = v2:Clone();
    u3.Parent = script;
    u3:Play();
    u3.Ended:Once(function() -- Line: 22
        -- upvalues: u3 (copy)
        u3:Destroy();
    end);
end;

local InOut = Enum.EasingDirection.InOut;
local Sine = Enum.EasingStyle.Sine;
local u4 = { 0.025, 0.125 };
local Color3_new_ret = Color3.new(0.14902, 0.894118, 0.14902);
local Color3_new_ret2 = Color3.new(1, 0, 0);
local Color3_new_ret3 = Color3.new(1, 1, 1);
local Color3_new_ret4 = Color3.new(1, 0, 0);
local u5 = faye.Info(0.1);
local u6 = faye.Info(0.3);

return function(p7: any, p8: table?) -- Line: 77
    -- upvalues: faye (copy), PlatformLeniency (copy), u4 (copy), Sine (copy), InOut (copy), Color3_new_ret (copy), Color3_new_ret2 (copy), u5 (copy), u6 (copy), Color3_new_ret3 (copy), Color3_new_ret4 (copy), Utility (copy), GuiService (copy), PlayTrainingSound (copy), TrainingUiScale (copy), GradientButton (copy), RunService (copy), TweenService (copy), Random_new_ret (copy)
    local v9 = p8 or {};
    local u10 = v9.Thread and v9.Thread:Extend() or faye.new();
    local Stop = v9.Stop;
    local v11 = PlatformLeniency();
    local u12 = (v9.SlideCycle or 2) * v11;
    local u13 = v9.Size or u4;
    local u14 = v9.GraceHitbox or 0.025;
    local u15 = v9.EasingStyle or Sine;
    local u16 = v9.EasingDirection or InOut;
    local u17 = v9.SuccessColor or Color3_new_ret;
    local u18 = v9.FailColor or Color3_new_ret2;
    local u19 = v9.BubbleTransitionInfo or u5;
    local u20 = v9.TransitionInfo or u6;
    local u21 = v9.CounterWin or 100;
    local u22 = v9.CounterLose or 0;
    local u23 = v9.CounterGain or 12;
    local u24 = v9.CounterLoss or 5;
    local u25 = v9.CounterDrain or 1;
    local u26 = (v9.CounterTick or 0.2) * v11;
    local u27 = v9.CounterColorStart or Color3_new_ret3;
    local u28 = v9.CounterColorEnd or Color3_new_ret4;
    local u29 = v9.CounterShakeThreshold or 30;
    local u30 = v9.CounterShakeAmplitude or 8;
    local u31 = v9.CounterShakeFrequency or 25;
    local u32 = nil;
    local u33 = nil;
    local u34 = nil;
    local u35 = nil;
    local u36 = false;
    local u37 = nil;
    local u38 = nil;
    local u39 = v9.CounterStart or 50;
    local u40 = u10:Value(math.floor(u39) .. "%");
    local u41 = u10:Value(u27);
    local u42 = u10:Value(UDim2.fromScale(0.5, 0.5));
    local u43 = false;

    local function finish(p44: boolean) -- Line: 128
        -- upvalues: u43 (ref), Stop (copy), u10 (copy)
        if u43 then
            return;
        end;

        u43 = true;

        if Stop then
            Stop(p44);
        end;

        u10:Destroy();
    end;

    local function adjustCounter(p45: number) -- Line: 134
        -- upvalues: u43 (ref), u39 (ref), u22 (copy), u21 (copy), u40 (copy), u41 (copy), Utility (ref), u28 (copy), u27 (copy), Stop (copy), u10 (copy)
        if u43 then
            return;
        end;

        u39 = math.clamp(u39 + p45, u22, u21);
        u40:Set(math.floor(u39) .. "%");
        u41:Set(Utility.Lerp_Color2(u28, u27, (u39 - u22) / (u21 - u22)));

        if u21 > u39 then
            if u39 <= u22 then
                if u43 then
                    return;
                end;

                u43 = true;

                if Stop then
                    Stop(false);
                end;

                u10:Destroy();
            end;

            return;
        end;

        if u43 then
            return;
        end;

        u43 = true;

        if Stop then
            Stop(true);
        end;

        u10:Destroy();
    end;

    local GuiInset = GuiService:GetGuiInset();
    local Instance = u10:Create("CanvasGroup")({
        Name = "Hitbox",
        BackgroundTransparency = 1,
        Parent = p7,
        Size = UDim2.new(1, 0, 1, GuiInset.Y),
        Position = UDim2.new(0, 0, 0, -GuiInset.Y),
        GroupTransparency = u10:Animation(0, u20, {
            From = 1
        }),
        CleanDelay = u20.Time,

        OnClean = function(p46) -- Line: 160, Name: OnClean
            -- upvalues: u20 (copy)
            return {
                GroupTransparency = p46:Animation(1, u20)
            };
        end,

        InputBegan = function(p47: any, p48: userdata) -- Line: 165, Name: InputBegan
            -- upvalues: u32 (ref), u38 (ref), u34 (ref), u35 (ref), u14 (copy), u36 (ref), PlayTrainingSound (ref), adjustCounter (copy), u23 (copy), u24 (copy), u43 (ref), u37 (ref)
            if p48.UserInputType ~= Enum.UserInputType.MouseButton1 and p48.UserInputType ~= Enum.UserInputType.Touch then
                return;
            end;

            if u38 == nil or ((u32 and u32.Instance) == nil or u34 == nil) then
                return;
            end;

            local v49 = math.abs(u38.Position.X.Scale - u34) <= u35 + u14;
            u36 = v49;
            PlayTrainingSound(v49 and "TrainingCompleteTRUE" or "TrainingCompleteFALSE");
            adjustCounter(v49 and u23 or -u24);

            if not u43 then
                u37();
            end;
        end
    }).Instance;
    local Instance2 = u10:Create("Frame")({
        Name = "Bg",
        Parent = Instance,
        Size = UDim2.fromScale(1, TrainingUiScale.Of(0.15)),
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.fromScale(0, 1),
        BackgroundColor3 = Color3.new(),
        CleanDelay = u20.Time,
        u10:Create("UIGradient")({
            Rotation = -90,
            Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(0.75, 0.925), NumberSequenceKeypoint.new(1, 1) })
        }),
        u10:Create("Frame")({
            Name = "BarHolder",
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 0.15),
            Size = UDim2.fromScale(0.15, 0.15),
            BackgroundTransparency = 0,
            BackgroundColor3 = Color3.new(0.1, 0.1, 0.1),
            u10:Create("UIGradient")({
                Rotation = 170,
                Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 0.8) })
            }),
            u10:Create("UIStroke")({
                BorderOffset = UDim.new(0, 2),
                Thickness = 1,
                Color = Color3.new(1, 1, 1),
                u10:Create("UIGradient")({
                    Rotation = 10,
                    Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.75), NumberSequenceKeypoint.new(1, 0.9) })
                })
            }),
            u10:Create("UICorner")({
                CornerRadius = UDim.new(1)
            }),
            u10:Create("Frame")({
                Name = "Slider",
                ZIndex = 2,
                BorderSizePixel = 1,
                Size = UDim2.new(0, 2, 1, 0),
                AnchorPoint = Vector2.new(0.5, 0),
                BackgroundColor3 = Color3.new(1, 0.901961, 0)
            })
        }),
        u10:Create("Frame")({
            Size = UDim2.fromScale(0.3, 0.27),
            u10:Create("UIAspectRatioConstraint")({
                AspectRatio = 3
            }),
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 0.925),
            GradientButton(u10, {
                Text = "Exit",
                TextXAlignment = Enum.TextXAlignment.Center,
                GradientTransparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.75), NumberSequenceKeypoint.new(1, 0.3) }),

                Clicked = function() -- Line: 260, Name: Clicked
                    -- upvalues: PlayTrainingSound (ref), u43 (ref), Stop (copy), u10 (copy)
                    PlayTrainingSound("TrainingExit");

                    if u43 then
                        return;
                    end;

                    u43 = true;

                    if Stop then
                        Stop(false);
                    end;

                    u10:Destroy();
                end,

                Properties = {
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.fromScale(0.5, 0)
                }
            })
        }),
        u10:Create("Frame")({
            Name = "Progressholder",
            ZIndex = -1,
            Size = UDim2.fromScale(0.2, 1),
            Position = UDim2.fromScale(0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0),
            u10:Create("UIAspectRatioConstraint")({
                AspectRatio = 3
            }),
            BackgroundTransparency = 1,
            u10:Create("TextLabel")({
                BackgroundTransparency = 1,
                ZIndex = 2,
                TextScaled = true,
                Size = UDim2.fromScale(1, 0.2),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = u42,
                Font = Enum.Font.SourceSansSemibold,
                Text = u40,
                TextColor3 = u41
            }),
            u10:Create("ImageLabel")({
                Name = "Bg",
                Image = "rbxassetid://134657809787110",
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(1, 1),
                ImageColor3 = Color3.new(0.05, 0.05, 0.05)
            })
        })
    }).Instance;
    u38 = Instance2.BarHolder.Slider;
    local u50 = 0;
    local u51 = 0;
    local u52 = nil;
    u52 = RunService.RenderStepped:Connect(function(p53: number) -- Line: 309
        -- upvalues: u10 (copy), u52 (ref), u50 (ref), u12 (copy), TweenService (ref), u15 (copy), u16 (copy), u38 (ref), u39 (ref), u29 (copy), u51 (ref), u31 (copy), u30 (copy), u42 (copy)
        if not u10.IsActive then
            u52:Disconnect();
            u52 = nil;

            return;
        end;

        u50 = u50 + p53;
        local Value = TweenService:GetValue(1 - math.abs(1 - u50 % (u12 * 2) / u12), u15, u16);
        u38.Position = UDim2.fromScale(Value, 0);

        if u39 >= u29 then
            u51 = 0;
            u42:Reset();

            return;
        end;

        u51 = u51 + p53;
        local v54 = (u29 - u39) / u29;
        local v55 = u51 * u31;
        local v56 = math.noise(v55, 0, 0) * u30 * v54;
        local v57 = math.noise(0, v55, 7.3) * u30 * v54;
        u42:Set(UDim2.fromScale(0.5, 0.5) + UDim2.fromOffset(v56, v57));
    end);
    task.spawn(function() -- Line: 341
        -- upvalues: u10 (copy), u26 (copy), adjustCounter (copy), u25 (copy)
        while u10.IsActive and task.wait(u26) do
            adjustCounter(-u25);
        end;
    end);

    u37 = function() -- Line: 348
        -- upvalues: u33 (ref), Random_new_ret (ref), u13 (copy), u34 (ref), u35 (ref), u10 (copy), u32 (ref), u19 (copy), Instance2 (copy), u20 (copy), u36 (ref), u17 (copy), u18 (copy)
        if u33 then
            u33:Destroy();
        end;

        local v58 = Random_new_ret:NextNumber() * (u13[2] - u13[1]) + u13[1];
        local v59 = v58 / 2 + Random_new_ret:NextNumber() * (1 - v58);
        u34 = v59;
        u35 = v58 / 2;
        u33 = u10:Extend();
        u32 = u33:Create("Frame")({
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = u33:Animation(UDim2.fromScale(v58, 1), u19, {
                From = UDim2.fromScale(0, 1)
            }),
            Position = UDim2.fromScale(v59, 0.5),
            Parent = Instance2.BarHolder,
            BackgroundColor3 = Color3.new(0.729412, 0.839216, 1),
            CleanDelay = u20.Time,
            u33:Create("UICorner")({
                CornerRadius = UDim.new(1)
            }),

            OnClean = function(p60) -- Line: 374, Name: OnClean
                -- upvalues: u36 (ref), u17 (ref), u18 (ref), u20 (ref)
                return {
                    BackgroundColor3 = p60:Animation(u36 and u17 or u18, u20),
                    BackgroundTransparency = p60:Animation(1, u20)
                };
            end
        });
    end;

    u37();

    return function() -- Line: 386
        -- upvalues: u10 (copy)
        u10:Destroy();
    end, u40;
end;
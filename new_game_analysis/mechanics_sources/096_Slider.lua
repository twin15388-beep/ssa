-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local GradientButton = require(ReplicatedStorage.CAM.Client.Components.Misc.Buttons.GradientButton);
local DebrisModule = require(ReplicatedStorage.CAM.DebrisModule);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local TrainingUiScale = require(ReplicatedStorage.CAM.Client.Modules.GamePlay.TrainingUiScale);
local PlatformLeniency = require(ReplicatedStorage.CAM.Client.Modules.GamePlay.PlatformLeniency);
local faye = require(ReplicatedStorage.Packages.faye);
local Random_new_ret = Random.new();
local LocalPlayer = Players.LocalPlayer;
local Mouse = LocalPlayer:GetMouse();
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local TweenInfo_new_ret = TweenInfo.new(gameSettings.lifeLostFadeTime);
local Training = ReplicatedStorage.Assets.Sounds.Training;

local function PlayTrainingSound(p1: string) -- Line: 21
    -- upvalues: Training (copy)
    local v2 = Training:FindFirstChild(p1);

    if v2 == nil then
        return;
    end;

    local u3 = v2:Clone();
    u3.Parent = script;
    u3:Play();
    u3.Ended:Once(function() -- Line: 27
        -- upvalues: u3 (copy)
        u3:Destroy();
    end);
end;

local u4 = { 0.15, 0.375 };
local u5 = { 0.1, 0.25 };
local u6 = faye.Info(0.3);
local u7 = faye.Info(0.125, Enum.EasingStyle.Sine);
local u8 = faye.Info(0.5);
local u9 = TrainingUiScale.Size(UDim2.fromScale(0.75, 0.85));
local Color3_new_ret = Color3.new(0.615686, 1, 0.615686);
local u10 = faye.Info(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true);
local u11 = faye.SpringInfo(0.3, 1, 0.5);

return function(p12: any, p13: table?) -- Line: 85
    -- upvalues: faye (copy), PlatformLeniency (copy), u9 (copy), u4 (copy), u5 (copy), u6 (copy), u7 (copy), u8 (copy), Random_new_ret (copy), PlayTrainingSound (copy), u11 (copy), Mouse (copy), TrainingUiScale (copy), LocalPlayer (copy), TweenService (copy), TweenInfo_new_ret (copy), DebrisModule (copy), GradientButton (copy), ReplicatedStorage (copy), Color3_new_ret (copy), u10 (copy), Utility (copy)
    local v14 = p13 or {};
    local Stop = v14.Stop;
    local OnComplete = v14.OnComplete;
    local u15 = v14.Thread and v14.Thread:Extend() or faye.new();
    local u16 = v14.Timer or 30;
    local u17 = v14.MaxHearts or 3;
    local v18 = PlatformLeniency();
    local u19 = (v14.Lifetime or 4) * v18;
    local u20 = (v14.AppearanceTime or 2) * v18;
    local v21 = v14.HolderSize or u9;
    local u22 = v14.BarSizeX or u4;
    local u23 = v14.BarSizeY or 0.1;
    local u24 = v14.Radius or u5;
    local u25 = v14.DraggerXOffset or 7;
    local u26 = v14.HitboxPadding or 20;
    local u27 = v14.TransitionInfo or u6;
    local u28 = v14.HeartTween or u7;
    local u29 = v14.OutInfo or u8;
    local u30 = v14.LerpBackRate or 10;
    local u31 = v14.ShakeStart or 0.5;
    local u32 = v14.ShakeAmplitude or 6;
    local u33 = v14.ShakeFrequency or 35;
    local u34 = v14.LowThreshold or 10;
    local Instance2 = u15:Create("CanvasGroup")({
        BackgroundTransparency = 1,
        Size = v21,
        Parent = p12,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        CleanDelay = u27.Time,
        GroupTransparency = u15:Animation(0, u27, {
            From = 1
        }),

        OnClean = function(p35) -- Line: 129, Name: OnClean
            -- upvalues: u27 (copy)
            return {
                GroupTransparency = p35:Animation(1, u27)
            };
        end
    }).Instance;
    local os_clock_ret = os.clock();
    local u36 = u15:Value(u16);
    local u37 = {};
    local u38 = false;

    for i = 1, u17 do
        u37[i] = u15:Value(true);
        local _ = i;
    end;

    task.spawn(function() -- Line: 146
        -- upvalues: u15 (copy), u16 (copy), os_clock_ret (copy), u36 (copy), Stop (copy)
        while u15.IsActive and task.wait(0.5) do
            local v39 = u16 - (os.clock() - os_clock_ret);
            local math_floor_ret = math.floor(v39);
            u36:Set(math_floor_ret);

            if math_floor_ret <= 0 then
                if Stop ~= nil then
                    Stop(true);
                end;

                u15:Destroy();

                return;
            end;
        end;
    end);
    u15:Spawn(function() -- Line: 158
        -- upvalues: Instance2 (copy), u15 (copy), Random_new_ret (ref), u24 (copy), PlayTrainingSound (ref), OnComplete (copy), u17 (ref), u37 (copy), Stop (copy), u22 (copy), u23 (copy), u26 (copy), u27 (copy), u11 (ref), u25 (copy), u31 (copy), u19 (copy), u33 (copy), u32 (copy), Mouse (ref), u30 (copy), u20 (copy)
        while Instance2 ~= nil and Instance2.Parent ~= nil do
            local u40 = u15:Extend();
            local v41 = 6.283185307179586 * Random_new_ret:NextNumber();
            local v42 = Random_new_ret:NextNumber() * (u24[2] - u24[1]) + u24[1];
            local v43 = math.cos(v41) * v42;
            local v44 = math.sin(v41) * v42;
            local v45 = Random_new_ret:NextInteger(1, 2) == 1;
            local u46 = false;
            local u47 = false;
            local u48 = nil;
            local u49 = nil;
            local os_clock_ret2 = os.clock();
            local UDim2_fromScale_ret = UDim2.fromScale(v43 + 0.5, v44 + 0.5);
            local u50 = false;

            local function Complete(p51: boolean) -- Line: 173
                -- upvalues: u50 (ref), PlayTrainingSound (ref), OnComplete (ref), u17 (ref), u37 (ref), Stop (ref), u15 (ref)
                u50 = p51;
                PlayTrainingSound(p51 and "TrainingCompleteTRUE" or "TrainingCompleteFALSE");

                if OnComplete then
                    OnComplete(p51);
                end;

                if not p51 and u17 > 0 then
                    u37[u17]:Set(false);
                    u17 = u17 - 1;

                    if u17 == 0 then
                        if Stop then
                            Stop(false);
                        end;

                        u15:Destroy();
                    end;
                end;
            end;

            local UDim2_fromScale_ret2 = UDim2.fromScale(Random_new_ret:NextNumber() * (u22[2] - u22[1]) + u22[1], u23);
            local v52 = (Random_new_ret:NextNumber() - 0.5) * 2 * 4 * 15 + (v45 and 0 or 180);
            local u53 = nil;
            local Instance3 = u40:Create("Frame")({
                Name = "Wrapper",
                Parent = Instance2,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(v43 + 0.5, v44 + 0.5),
                Size = UDim2_fromScale_ret2 + UDim2.fromOffset(u26 * 2, u26 * 2),
                Rotation = v52,
                BackgroundTransparency = 1,
                CleanDelay = u27.Time,

                MouseEnter = function() -- Line: 207, Name: MouseEnter
                    -- upvalues: u47 (ref)
                    u47 = true;
                end,

                MouseLeave = function() -- Line: 210, Name: MouseLeave
                    -- upvalues: u47 (ref), u46 (ref)
                    u47 = false;
                    u46 = false;
                end,

                u40:Create("CanvasGroup")({
                    Name = "MainHolder",
                    ZIndex = 2,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.new(1, -u26 * 2, 1, -u26 * 2),
                    BackgroundTransparency = 1,
                    GroupTransparency = u15:Animation(0, u27, {
                        From = 1
                    }),

                    OnClean = function(p54, p55) -- Line: 223, Name: OnClean
                        -- upvalues: u27 (ref), u50 (ref)
                        if p55.Parent ~= nil then
                            local Actual = p55:FindFirstChild("Actual");

                            if Actual then
                                Actual.BackgroundColor3 = Color3.new(1, 1, 1);
                            end;

                            return {
                                GroupTransparency = p54:Animation(1, u27),
                                GroupColor3 = p54:Animation(u50 and Color3.new(0.14902, 0.894118, 0.14902) or Color3.new(1, 0, 0), u27)
                            };
                        end;
                    end,

                    After = function(p56) -- Line: 236, Name: After
                        -- upvalues: u53 (ref)
                        u53 = p56;
                    end,

                    u15:Create("UICorner")({
                        CornerRadius = UDim.new(1)
                    }),
                    u15:Create("Frame")({
                        u15:Create("UIStroke")({
                            Thickness = 1,
                            Color = Color3.new(1, 1, 1),
                            BorderOffset = UDim.new(0, 2),
                            Transparency = 0.5,
                            u15:Create("UIGradient")({
                                Rotation = 160,
                                Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0.75) })
                            })
                        }),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.fromScale(0.5, 0.5),
                        Size = u15:Animation(UDim2.new(1, -3, 1, -3), u11, {
                            From = UDim2.new(0.5, -3, 0.5, -3)
                        }),
                        Name = "Actual",
                        u15:Create("UICorner")({
                            CornerRadius = UDim.new(1)
                        }),
                        BackgroundColor3 = Color3.new(0.15, 0.15, 0.15),
                        BackgroundTransparency = 0.25,
                        u15:Create("UIGradient")({
                            Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0.65) })
                        }),
                        u15:Create("ImageLabel")({
                            Name = "Arrows",
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            Position = UDim2.fromScale(0.5, 0.5),
                            Size = UDim2.fromScale(0.3, 1.2),
                            Rotation = 90,
                            BackgroundTransparency = 1,
                            Image = "rbxassetid://93693040307287",
                            u15:Create("UIGradient")({
                                Rotation = 90,
                                Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.65), NumberSequenceKeypoint.new(1, 1) })
                            })
                        }),
                        u15:Create("Frame")({
                            Name = "Dragger",
                            Size = UDim2.new(1, -15, 1, -15),
                            AnchorPoint = Vector2.new(0, 0.5),
                            ZIndex = 2,
                            Position = UDim2.new(0, u25, 0.5, 0),
                            Instance.new("UIAspectRatioConstraint"),
                            u15:Create("UICorner")({
                                CornerRadius = UDim.new(1)
                            }),
                            u15:Create("UIStroke")({
                                Thickness = 1,
                                BorderOffset = UDim.new(0, 4),
                                Color = Color3.new(1, 1, 1),
                                u15:Create("UIGradient")({
                                    Rotation = 180,
                                    Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.1, 0.7), NumberSequenceKeypoint.new(1, 1) })
                                })
                            }),
                            u15:Create("UIGradient")({
                                Rotation = 180,
                                Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0.5) })
                            }),
                            u15:Create("TextButton")({
                                Name = "Hitbox",
                                Text = "",
                                BackgroundTransparency = 1,
                                ZIndex = 3,
                                Size = UDim2.new(1.2, 15, 1.2, 15),
                                AnchorPoint = Vector2.new(0.5, 0.5),
                                Position = UDim2.fromScale(0.5, 0.5),

                                MouseButton1Down = function() -- Line: 337, Name: MouseButton1Down
                                    -- upvalues: u46 (ref)
                                    u46 = true;
                                end,

                                MouseButton1Up = function() -- Line: 340, Name: MouseButton1Up
                                    -- upvalues: u46 (ref)
                                    u46 = false;
                                end
                            })
                        }),
                        u15:Create("Frame")({
                            Name = "Final",
                            Size = UDim2.new(1, -6, 1, -6),
                            AnchorPoint = Vector2.new(1, 0.5),
                            Position = UDim2.new(1, -3, 0.5, 0),
                            Instance.new("UIAspectRatioConstraint"),
                            u15:Create("UICorner")({
                                CornerRadius = UDim.new(1)
                            }),
                            BackgroundTransparency = 0,
                            BackgroundColor3 = Color3.new(0.615686, 1, 0.615686),

                            OnClean = function(p57) -- Line: 358, Name: OnClean
                                if p57 ~= nil and p57.Parent ~= nil then
                                    return {
                                        BackgroundColor3 = Color3.new(1, 1, 1)
                                    };
                                end;
                            end,

                            u15:Create("UIGradient")({
                                Rotation = 170,
                                Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.85), NumberSequenceKeypoint.new(1, 0.95) })
                            }),
                            u15:Create("UIStroke")({
                                Thickness = 1,
                                Color = Color3.new(1, 1, 1),
                                Transparency = 0.5,
                                BorderOffset = UDim.new(0, 2),
                                u15:Create("UIGradient")({
                                    Rotation = 160,
                                    Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0.75) })
                                })
                            })
                        })
                    })
                })
            }).Instance;
            task.spawn(function() -- Line: 390
                -- upvalues: u40 (copy), u53 (ref), os_clock_ret2 (copy), u31 (ref), u19 (ref), u33 (ref), u32 (ref), Instance3 (copy), UDim2_fromScale_ret (copy), u46 (ref), u47 (ref), Mouse (ref), u48 (ref), u49 (ref), u25 (ref), u50 (ref), PlayTrainingSound (ref), OnComplete (ref), u30 (ref)
                while u40.IsActive do
                    local task_wait_ret = task.wait();

                    if u53.Parent == nil then
                        break;
                    end;

                    local Actual = u53:FindFirstChild("Actual");
                    local v58;

                    if Actual then
                        v58 = Actual:FindFirstChild("Dragger");
                    else
                        v58 = Actual;
                    end;

                    local v59;

                    if Actual then
                        v59 = Actual:FindFirstChild("Final");
                    else
                        v59 = Actual;
                    end;

                    if Actual and (v58 and (v59 and Actual.AbsoluteSize.X > 0)) then
                        local v60 = os.clock() - os_clock_ret2;

                        if u31 <= v60 then
                            local math_clamp_ret = math.clamp((v60 - u31) / (u19 - u31), 0, 1);
                            local v61 = v60 * u33;
                            local v62 = math.noise(v61, 0, 0) * u32 * math_clamp_ret;
                            local v63 = math.noise(0, v61, 7.3) * u32 * math_clamp_ret;
                            Instance3.Position = UDim2_fromScale_ret + UDim2.fromOffset(v62, v63);
                        end;

                        local v64 = 1 - (6 + v59.AbsoluteSize.X) / Actual.AbsoluteSize.X;

                        if u46 and u47 then
                            local v65 = u53.AbsolutePosition + u53.AbsoluteSize / 2;
                            local v66 = Vector2.new(Mouse.X, Mouse.Y) - v65;
                            local math_rad_ret = math.rad(u53.AbsoluteRotation);
                            local v67 = (v66.X * math.cos(math_rad_ret) + v66.Y * math.sin(math_rad_ret) + u53.AbsoluteSize.X / 2) / u53.AbsoluteSize.X;

                            if u48 == nil then
                                u48 = v67;
                                u49 = v58.Position.X.Scale;
                            end;

                            local math_clamp_ret = math.clamp(u49 + (v67 - u48), 0, v64);
                            v58.Position = UDim2.new(math_clamp_ret, u25, 0.5, 0);

                            if v64 <= math_clamp_ret then
                                u50 = true;
                                PlayTrainingSound("TrainingCompleteTRUE");

                                if OnComplete then
                                    OnComplete(true);
                                end;

                                u40:Destroy();

                                return;
                            end;
                        else
                            u48 = nil;
                            u49 = nil;
                            local Scale = v58.Position.X.Scale;
                            local math_min_ret = math.min(1, u30 * task_wait_ret);
                            v58.Position = UDim2.new(Scale * (1 - math_min_ret), u25, 0.5, 0);
                        end;
                    end;
                end;
            end);
            task.delay(u19, function() -- Line: 463
                -- upvalues: u15 (ref), u40 (copy), u50 (ref), PlayTrainingSound (ref), OnComplete (ref), u17 (ref), u37 (ref), Stop (ref)
                if not u15.IsActive then
                    return;
                end;

                if u40.IsActive then
                    u50 = false;
                    PlayTrainingSound("TrainingCompleteFALSE");

                    if OnComplete then
                        OnComplete(false);
                    end;

                    if u17 > 0 then
                        u37[u17]:Set(false);
                        u17 = u17 - 1;

                        if u17 == 0 then
                            if Stop then
                                Stop(false);
                            end;

                            u15:Destroy();
                        end;
                    end;

                    u40:Destroy();
                end;
            end);
            task.wait(u20);
        end;
    end);
    u15:Create("CanvasGroup")({
        Size = UDim2.fromScale(1, TrainingUiScale.Of(0.2)),
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.fromScale(0, 1),
        Parent = p12,
        BackgroundTransparency = 1,
        u15:Create("Frame")({
            Name = "Bg",
            ZIndex = -1,
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.new(),
            u15:Create("UIGradient")({
                Rotation = -90,
                Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) })
            })
        }),
        GroupTransparency = u15:Animation(0, u27, {
            From = 1
        }),

        OnClean = function() -- Line: 503, Name: OnClean
            -- upvalues: u15 (copy), u27 (copy)
            return {
                GroupTransparency = u15:Animation(1, u27)
            };
        end,

        u15:Create("Frame")({
            Size = UDim2.fromScale(0.2, 0.225),
            Instance.new("UIAspectRatioConstraint"),
            Position = UDim2.new(0.5, 0, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            u15:Create("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = UDim.new(0.15)
            }),
            u15:Iterate(u37, function(p68: any, p69: any, p70: any, p71: userdata?) -- Line: 520
                -- upvalues: u15 (copy), LocalPlayer (ref), TweenService (ref), TweenInfo_new_ret (ref), DebrisModule (ref), u29 (copy), u28 (copy)
                local u72 = u15:Value(UDim2.fromScale(1, 1));
                local u73 = u15:Value(UDim2.fromScale(1.2, 1.2));
                p69.Changed:Connect(function() -- Line: 523
                    -- upvalues: u73 (copy), u72 (copy), LocalPlayer (ref), TweenService (ref), TweenInfo_new_ret (ref), DebrisModule (ref)
                    u73:Set(UDim2.fromScale(0.85, 0.85));
                    u72:Set(UDim2.fromScale());

                    if LocalPlayer:FindFirstChild("PlayerGui") then
                        local ImageLabel = Instance.new("ImageLabel");
                        ImageLabel.Image = "rbxassetid://101053692073571";
                        ImageLabel.BackgroundTransparency = 1;
                        ImageLabel.Size = UDim2.fromScale(1, 1);
                        ImageLabel.ImageColor3 = Color3.new(1);
                        ImageLabel.Parent = LocalPlayer.PlayerGui.Misc;
                        TweenService:Create(ImageLabel, TweenInfo_new_ret, {
                            ImageTransparency = 1
                        }):Play();
                        DebrisModule:AddItem(ImageLabel, 0.3);
                    end;
                end);

                return u15:Create("Frame")({
                    CleanDelay = u29.Time,
                    Size = UDim2.fromScale(1, 1),
                    Name = "heart" .. p68,
                    BackgroundTransparency = 1,
                    u15:Create("ImageLabel")({
                        BackgroundTransparency = 1,
                        Name = "Bg",
                        Image = "rbxassetid://14484728741",
                        ImageTransparency = 0.35,
                        Size = u15:Animation(u73, u28),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.fromScale(0.5, 0.5),
                        ImageColor3 = Color3.new(0.45, 0.2, 0.2)
                    }),
                    u15:Create("ImageLabel")({
                        BackgroundTransparency = 1,
                        Name = "Fg",
                        Image = "rbxassetid://14484728741",
                        ImageTransparency = 0,
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.fromScale(0.5, 0.5),
                        ImageColor3 = Color3.new(1, 0, 0),
                        Size = u15:Animation(u72, u28)
                    })
                });
            end)
        }),
        u15:Create("Frame")({
            Size = UDim2.fromScale(0.3, 0.27),
            u15:Create("UIAspectRatioConstraint")({
                AspectRatio = 3
            }),
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 0.95),
            GradientButton(u15, {
                Text = "Exit",
                TextXAlignment = Enum.TextXAlignment.Center,
                GradientTransparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.75), NumberSequenceKeypoint.new(1, 0.3) }),

                Clicked = function() -- Line: 581, Name: Clicked
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
        }),
        u15:Create("Frame")({
            Size = UDim2.fromScale(0.2, 0.25),
            Position = UDim2.new(1, -15, 1, -15),
            AnchorPoint = Vector2.new(1, 1),
            BackgroundTransparency = 1,
            u15:Create("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = UDim.new(0.005, 0),
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                VerticalAlignment = Enum.VerticalAlignment.Center
            }),
            u15:Create("Frame")({
                Name = "bIcon",
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Instance.new("UIAspectRatioConstraint"),
                u15:Create("ImageLabel")({
                    Name = "Main",
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://120352136875263",
                    Size = UDim2.fromScale(1, 1),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.5)
                })
            }),
            u15:Create("TextLabel")({
                Name = "aTxt",
                BackgroundTransparency = 1,
                TextScaled = true,
                TextTransparency = 0,
                Size = UDim2.fromScale(1, 0.7),
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.fromScale(0.0375, 0.5),
                Font = Enum.Font.SourceSansSemibold,
                TextXAlignment = Enum.TextXAlignment.Right,
                TextColor3 = Color3.new(1, 1, 1),
                Text = u15:Do(function(p74: function, p75: any, p76: userdata?) -- Line: 632
                    -- upvalues: u36 (copy), u34 (copy), ReplicatedStorage (ref), u38 (ref), Color3_new_ret (ref), u10 (ref), Utility (ref)
                    local v77 = p74(u36);

                    if v77 <= u34 then
                        ReplicatedStorage.Assets.Sounds.Misc.FriendlierCountdown.TimePosition = 0;
                        ReplicatedStorage.Assets.Sounds.Misc.FriendlierCountdown:Play();

                        if not u38 then
                            u38 = true;
                            p76.Parent.bIcon.Main.Rotation = -15;
                            p75:LoadAnimation(p76, {
                                TextColor3 = Color3_new_ret
                            }, u10):Play();
                            p75:LoadAnimation(p76.Parent.bIcon.Main, {
                                Rotation = 15,
                                ImageColor3 = Color3_new_ret
                            }, u10):Play();
                        end;
                    end;

                    return `Survive {Utility.formatTime(v77)}`;
                end)
            })
        })
    });

    return function() -- Line: 652
        -- upvalues: u15 (copy)
        u15:Destroy();
    end, u36;
end;
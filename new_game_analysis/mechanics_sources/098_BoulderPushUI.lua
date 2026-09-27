-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local GradientButton = require(ReplicatedStorage.CAM.Client.Components.Misc.Buttons.GradientButton);
local PopUpCreator = require(ReplicatedStorage.CAM.Global.Subsets.Classes.PopUpCreator);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local TrainingUiScale = require(ReplicatedStorage.CAM.Client.Modules.GamePlay.TrainingUiScale);
local faye = require(ReplicatedStorage.Packages.faye);
local Color3_new_ret = Color3.new(1, 0, 0);
local u1 = faye.Info(0.3);
local u2 = faye.Info(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true);
local Training = ReplicatedStorage.Assets.Sounds.Training;

local function PlayTrainingSound(p3: string) -- Line: 17
    -- upvalues: Training (copy)
    local v4 = Training:FindFirstChild(p3);

    if v4 == nil then
        return;
    end;

    local u5 = v4:Clone();
    u5.Parent = script;
    u5:Play();
    u5.Ended:Once(function() -- Line: 23
        -- upvalues: u5 (copy)
        u5:Destroy();
    end);
end;

return function(p6: any, u7: function) -- Line: 30
    -- upvalues: faye (copy), TrainingUiScale (copy), u1 (copy), GradientButton (copy), PopUpCreator (copy), PlayTrainingSound (copy), ReplicatedStorage (copy), Color3_new_ret (copy), u2 (copy), Utility (copy)
    local u8 = faye.new();
    local u9 = false;
    local os_clock_ret = os.clock();
    local u10 = u8:Value(150);
    local u11 = false;
    u8:Spawn(function() -- Line: 37
        -- upvalues: os_clock_ret (copy), u10 (copy), u7 (copy)
        while task.wait(0.5) do
            local v12 = 150 - (os.clock() - os_clock_ret);
            local math_floor_ret = math.floor(v12);
            u10:Set(math_floor_ret);

            if math_floor_ret <= 0 then
                if u7 ~= nil then
                    u7();

                    return;
                end;

                break;
            end;
        end;
    end);
    u8:Create("CanvasGroup")({
        Name = "BoulderPushUI",
        Size = UDim2.fromScale(1, TrainingUiScale.Of(0.2)),
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.fromScale(0, 1),
        Parent = p6,
        BackgroundTransparency = 1,
        u8:Create("Frame")({
            Name = "Bg",
            ZIndex = -1,
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.new(),
            u8:Create("UIGradient")({
                Rotation = -90,
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(0.6, 0.7),
                    NumberSequenceKeypoint.new(0.8, 0.9),
                    NumberSequenceKeypoint.new(1, 1)
                })
            })
        }),
        GroupTransparency = u8:Animation(0, u1, {
            From = 1
        }),

        OnClean = function() -- Line: 76, Name: OnClean
            -- upvalues: u8 (copy), u1 (ref)
            return {
                GroupTransparency = u8:Animation(1, u1)
            };
        end,

        u8:Create("Frame")({
            Size = UDim2.fromScale(0.3, 0.27),
            u8:Create("UIAspectRatioConstraint")({
                AspectRatio = 3
            }),
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 0.95),
            GradientButton(u8, {
                Text = "Exit",
                TextXAlignment = Enum.TextXAlignment.Center,
                GradientTransparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.75), NumberSequenceKeypoint.new(1, 0.3) }),

                Clicked = function() -- Line: 96, Name: Clicked
                    -- upvalues: u9 (ref), u7 (copy), PopUpCreator (ref), PlayTrainingSound (ref)
                    if u9 or u7 == nil then
                        return;
                    end;

                    u9 = true;

                    if PopUpCreator.new({
                        Type = "Question",
                        Content = "Are you sure you want to leave?"
                    }).Result:Wait(5) == "Yes" then
                        PlayTrainingSound("TrainingExit");
                        u7();
                    end;

                    u9 = false;
                end,

                Properties = {
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.fromScale(0.5, 0)
                }
            })
        }),
        u8:Create("Frame")({
            Size = UDim2.fromScale(0.2, 0.25),
            Position = UDim2.new(1, -15, 1, -15),
            AnchorPoint = Vector2.new(1, 1),
            BackgroundTransparency = 1,
            u8:Create("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = UDim.new(0.005, 0),
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                VerticalAlignment = Enum.VerticalAlignment.Center
            }),
            u8:Create("Frame")({
                Name = "bIcon",
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Instance.new("UIAspectRatioConstraint"),
                u8:Create("ImageLabel")({
                    Name = "Main",
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://120352136875263",
                    Size = UDim2.fromScale(1, 1),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.5)
                })
            }),
            u8:Create("TextLabel")({
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
                Text = u8:Do(function(p13: function, p14: any, p15: userdata?) -- Line: 151
                    -- upvalues: u10 (copy), ReplicatedStorage (ref), u11 (ref), Color3_new_ret (ref), u2 (ref), Utility (ref)
                    local v16 = p13(u10);

                    if v16 <= 10 then
                        ReplicatedStorage.Assets.Sounds.Misc.countDown.TimePosition = 0;
                        ReplicatedStorage.Assets.Sounds.Misc.countDown:Play();

                        if not u11 then
                            u11 = true;
                            p15.Parent.bIcon.Main.Rotation = -15;
                            p14:LoadAnimation(p15, {
                                TextColor3 = Color3_new_ret
                            }, u2):Play();
                            p14:LoadAnimation(p15.Parent.bIcon.Main, {
                                Rotation = 15,
                                ImageColor3 = Color3_new_ret
                            }, u2):Play();
                        end;
                    end;

                    return Utility.formatTime(v16);
                end)
            })
        })
    });

    return function() -- Line: 168
        -- upvalues: u8 (copy)
        u8:Destroy();
    end;
end;
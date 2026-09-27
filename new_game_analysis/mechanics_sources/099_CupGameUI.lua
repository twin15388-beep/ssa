-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local GradientButton = require(ReplicatedStorage.CAM.Client.Components.Misc.Buttons.GradientButton);
local DebrisModule = require(ReplicatedStorage.CAM.DebrisModule);
local faye = require(ReplicatedStorage.Packages.faye);
local TrainingUiScale = require(ReplicatedStorage.CAM.Client.Modules.GamePlay.TrainingUiScale);
local LocalPlayer = Players.LocalPlayer;
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local TweenInfo_new_ret = TweenInfo.new(gameSettings.lifeLostFadeTime);
local u1 = faye.Info(0.3);
local u2 = faye.Info(0.125, Enum.EasingStyle.Sine);
local u3 = faye.Info(0.5);
local u4 = faye.Info(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
local Color3_fromRGB_ret = Color3.fromRGB(80, 255, 120);
local Color3_fromRGB_ret2 = Color3.fromRGB(255, 80, 80);
local Color3_new_ret = Color3.new(1, 1, 1);
local Training = ReplicatedStorage.Assets.Sounds.Training;

local function PlayTrainingSound(p5: string) -- Line: 34
    -- upvalues: Training (copy)
    local v6 = Training:FindFirstChild(p5);

    if v6 == nil then
        return;
    end;

    local u7 = v6:Clone();
    u7.Parent = script;
    u7:Play();
    u7.Ended:Once(function() -- Line: 40
        -- upvalues: u7 (copy)
        u7:Destroy();
    end);
end;

return function(p8: any, u9: function?) -- Line: 45
    -- upvalues: faye (copy), Color3_new_ret (copy), u4 (copy), Color3_fromRGB_ret (copy), TrainingUiScale (copy), u1 (copy), Color3_fromRGB_ret2 (copy), LocalPlayer (copy), TweenService (copy), TweenInfo_new_ret (copy), DebrisModule (copy), u3 (copy), u2 (copy), GradientButton (copy), PlayTrainingSound (copy)
    local u10 = faye.new();
    local v11 = {};
    local u12 = u10:Value(0);
    v11[1] = u10:Value(true);
    v11[2] = u10:Value(true);
    v11[3] = u10:Value(true);
    local u13 = nil;

    local function flash(p14) -- Line: 61
        -- upvalues: u13 (ref), u10 (copy), Color3_new_ret (ref), u4 (ref)
        if u13 == nil then
            return;
        end;

        u13.TextColor3 = p14;
        u10:LoadAnimation(u13, {
            TextColor3 = Color3_new_ret
        }, u4):Play();
    end;

    u12.Changed:Connect(function() -- Line: 66
        -- upvalues: Color3_fromRGB_ret (ref), u13 (ref), u10 (copy), Color3_new_ret (ref), u4 (ref)
        if u13 == nil then
            return;
        end;

        u13.TextColor3 = Color3_fromRGB_ret;
        u10:LoadAnimation(u13, {
            TextColor3 = Color3_new_ret
        }, u4):Play();
    end);
    u10:Create("CanvasGroup")({
        Size = UDim2.fromScale(1, TrainingUiScale.Of(0.2)),
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.fromScale(0, 1),
        Parent = p8,
        BackgroundTransparency = 1,
        u10:Create("Frame")({
            Name = "Bg",
            ZIndex = -1,
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.new(),
            u10:Create("UIGradient")({
                Rotation = -90,
                Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.7, 0.85), NumberSequenceKeypoint.new(1, 1) })
            })
        }),
        GroupTransparency = u10:Animation(0, u1, {
            From = 1
        }),

        OnClean = function() -- Line: 93, Name: OnClean
            -- upvalues: u10 (copy), u1 (ref)
            return {
                GroupTransparency = u10:Animation(1, u1)
            };
        end,

        u10:Create("TextLabel")({
            Name = "aTxt",
            BackgroundTransparency = 1,
            TextScaled = true,
            TextTransparency = 0,
            Size = UDim2.fromScale(1, 0.2),
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 0.35),
            Font = Enum.Font.SourceSansSemibold,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextColor3 = Color3.new(1, 1, 1),

            After = function(p15) -- Line: 109, Name: After
                -- upvalues: u13 (ref)
                u13 = p15;
            end,

            Text = u10:Do(function(p16: function, p17: any, p18: userdata?) -- Line: 110
                -- upvalues: u12 (copy)
                return `{p16(u12)} / {10}`;
            end)
        }),
        u10:Create("Frame")({
            Size = UDim2.fromScale(0.2, 0.225),
            Instance.new("UIAspectRatioConstraint"),
            Position = UDim2.new(0.5, 0, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            u10:Create("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = UDim.new(0.15)
            }),
            u10:Iterate(v11, function(p19: any, p20: any, p21: any, p22: userdata?) -- Line: 128
                -- upvalues: u10 (copy), Color3_fromRGB_ret2 (ref), u13 (ref), Color3_new_ret (ref), u4 (ref), LocalPlayer (ref), TweenService (ref), TweenInfo_new_ret (ref), DebrisModule (ref), u3 (ref), u2 (ref)
                local u23 = u10:Value(UDim2.fromScale(1, 1));
                local u24 = u10:Value(UDim2.fromScale(1.2, 1.2));
                p20.Changed:Connect(function() -- Line: 131
                    -- upvalues: Color3_fromRGB_ret2 (ref), u13 (ref), u10 (ref), Color3_new_ret (ref), u4 (ref), u24 (copy), u23 (copy), LocalPlayer (ref), TweenService (ref), TweenInfo_new_ret (ref), DebrisModule (ref)
                    local v25 = Color3_fromRGB_ret2;

                    if u13 ~= nil then
                        u13.TextColor3 = v25;
                        u10:LoadAnimation(u13, {
                            TextColor3 = Color3_new_ret
                        }, u4):Play();
                    end;

                    u24:Set(UDim2.fromScale(0.85, 0.85));
                    u23:Set(UDim2.fromScale());

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

                return u10:Create("Frame")({
                    CleanDelay = u3.Time,
                    Size = UDim2.fromScale(1, 1),
                    Name = "heart" .. p19,
                    BackgroundTransparency = 1,
                    u10:Create("ImageLabel")({
                        BackgroundTransparency = 1,
                        Name = "Bg",
                        Image = "rbxassetid://14484728741",
                        ImageTransparency = 0.35,
                        Size = u10:Animation(u24, u2),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.fromScale(0.5, 0.5),
                        ImageColor3 = Color3.new(0.45, 0.2, 0.2)
                    }),
                    u10:Create("ImageLabel")({
                        BackgroundTransparency = 1,
                        Name = "Fg",
                        Image = "rbxassetid://14484728741",
                        ImageTransparency = 0,
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.fromScale(0.5, 0.5),
                        ImageColor3 = Color3.new(1, 0, 0),
                        Size = u10:Animation(u23, u2)
                    })
                });
            end)
        }),
        u10:Create("Frame")({
            Size = UDim2.fromScale(0.3, 0.27),
            u10:Create("UIAspectRatioConstraint")({
                AspectRatio = 3
            }),
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 0.95),
            GradientButton(u10, {
                Text = "Exit",
                TextXAlignment = Enum.TextXAlignment.Center,
                GradientTransparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.75), NumberSequenceKeypoint.new(1, 0.3) }),

                Clicked = function() -- Line: 192, Name: Clicked
                    -- upvalues: u9 (copy), PlayTrainingSound (ref)
                    if u9 ~= nil then
                        PlayTrainingSound("TrainingExit");
                        u9(false);
                    end;
                end,

                Properties = {
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.fromScale(0.5, 0)
                }
            })
        })
    });

    return function() -- Line: 209
        -- upvalues: u10 (copy)
        u10:Destroy();
    end, v11, 3, u12, 10;
end;
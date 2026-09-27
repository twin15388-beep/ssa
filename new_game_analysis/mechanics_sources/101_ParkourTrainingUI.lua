-- Decompiled with Potassium's decompiler.

local GuiService = game:GetService("GuiService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local TweenInfo_new_ret = TweenInfo.new(gameSettings.lifeLostFadeTime);
local LocalPlayer = Players.LocalPlayer;
local GradientButton = require(ReplicatedStorage.CAM.Client.Components.Misc.Buttons.GradientButton);
local DebrisModule = require(ReplicatedStorage.CAM.DebrisModule);
local PopUpCreator = require(ReplicatedStorage.CAM.Global.Subsets.Classes.PopUpCreator);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local TrainingUiScale = require(ReplicatedStorage.CAM.Client.Modules.GamePlay.TrainingUiScale);
local faye = require(ReplicatedStorage.Packages.faye);
local u1 = faye.Info(0.2);
local u2 = faye.Info(0.125, Enum.EasingStyle.Sine);
local u3 = faye.Info(0.5);
local u4 = {
    Mobile = 6,
    Xbox = 5
};
local u5 = faye.Info(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true);
local Training = ReplicatedStorage.Assets.Sounds.Training;

local function PlayTrainingSound(p6: string) -- Line: 46
    -- upvalues: Training (copy)
    local v7 = Training:FindFirstChild(p6);

    if v7 == nil then
        return;
    end;

    local u8 = v7:Clone();
    u8.Parent = script;
    u8:Play();
    u8.Ended:Once(function() -- Line: 52
        -- upvalues: u8 (copy)
        u8:Destroy();
    end);
end;

return function(p9: any, u10: function) -- Line: 56
    -- upvalues: faye (copy), GuiService (copy), LocalPlayer (copy), u4 (copy), u1 (copy), u3 (copy), TrainingUiScale (copy), ReplicatedStorage (copy), u5 (copy), Utility (copy), TweenService (copy), TweenInfo_new_ret (copy), DebrisModule (copy), u2 (copy), GradientButton (copy), PopUpCreator (copy), PlayTrainingSound (copy)
    local u11 = faye.new();
    local Y = GuiService:GetGuiInset().Y;
    local os_clock_ret = os.clock();
    local u12 = (LocalPlayer == nil or LocalPlayer:GetAttribute("Device") ~= "Mobile") and 360 or 503.99999999999994;
    local u13 = u11:Value(u12);
    local v14 = LocalPlayer == nil and 4 or (u4[LocalPlayer:GetAttribute("Device")] or 4);
    local v15 = {};
    local u16 = false;

    for i = 1, v14 do
        v15[i] = u11:Value(true);
        local _ = i;
    end;

    u11:Spawn(function(...) -- Line: 78
        -- upvalues: u12 (ref), os_clock_ret (copy), u13 (copy), u10 (copy)
        while task.wait(0.5) do
            local v17 = u12 - (os.clock() - os_clock_ret);
            local math_floor_ret = math.floor(v17);
            u13:Set(math_floor_ret);

            if math_floor_ret <= 0 and u10 ~= nil then
                u10();

                return;
            end;
        end;
    end);
    local u18 = false;
    u11:Create("CanvasGroup")({
        Name = "ParkourTrainingUI",
        ZIndex = -10,
        Size = UDim2.new(1, 0, 1, Y),
        Position = UDim2.fromOffset(0, -Y),
        Parent = p9,
        BackgroundTransparency = 1,
        GroupTransparency = u11:Animation(0, u1, {
            From = 1
        }),

        OnClean = function() -- Line: 97, Name: OnClean
            -- upvalues: u11 (copy), u3 (ref)
            return {
                GroupTransparency = u11:Animation(1, u3)
            };
        end,

        u11:Create("Frame")({
            Name = "Top",
            Size = UDim2.fromScale(1, 0.35),
            BackgroundColor3 = Color3.new(),
            BackgroundTransparency = 0.15,
            u11:Create("UIGradient")({
                Rotation = 90,
                Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) })
            })
        }),
        u11:Create("Frame")({
            Size = TrainingUiScale.Size(UDim2.fromScale(0.2, 0.045)),
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0.05, 0, 0.05, Y),
            BackgroundTransparency = 1,
            u11:Create("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = UDim.new(0.005, 0),
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                VerticalAlignment = Enum.VerticalAlignment.Center
            }),
            u11:Create("Frame")({
                Name = "Icon",
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Instance.new("UIAspectRatioConstraint"),
                u11:Create("ImageLabel")({
                    Name = "Main",
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://120352136875263",
                    Size = UDim2.fromScale(1, 1),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.5)
                })
            }),
            u11:Create("TextLabel")({
                Name = "Txt",
                BackgroundTransparency = 1,
                TextScaled = true,
                Size = UDim2.fromScale(1, 0.7),
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.fromScale(0.0375, 0.5),
                Font = Enum.Font.SourceSansSemibold,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextColor3 = Color3.new(1, 1, 1),
                Text = u11:Do(function(p19: function, p20: any, p21: userdata?) -- Line: 154
                    -- upvalues: u13 (copy), ReplicatedStorage (ref), u18 (ref), u5 (ref), Utility (ref)
                    local v22 = p19(u13);

                    if v22 <= 30 then
                        ReplicatedStorage.Assets.Sounds.Misc.countDown.TimePosition = 0;
                        ReplicatedStorage.Assets.Sounds.Misc.countDown:Play();

                        if not u18 then
                            u18 = true;
                            p21.Parent.Icon.Main.Rotation = -15;
                            p20:LoadAnimation(p21, {
                                TextColor3 = Color3.new(1, 0, 0)
                            }, u5):Play();
                            p20:LoadAnimation(p21.Parent.Icon.Main, {
                                Rotation = 15,
                                ImageColor3 = Color3.new(1, 0, 0)
                            }, u5):Play();
                        end;
                    end;

                    return Utility.formatTime(v22);
                end)
            })
        }),
        u11:Create("Frame")({
            Size = UDim2.fromScale(0.04, 0.04),
            AnchorPoint = Vector2.new(0.5, 0),
            Instance.new("UIAspectRatioConstraint"),
            Position = UDim2.new(0.5, 0, 0.015, Y),
            BackgroundTransparency = 1,
            u11:Create("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = UDim.new(0.15)
            }),
            u11:Iterate(v15, function(p23: any, p24: any, p25: any, p26: userdata?) -- Line: 184
                -- upvalues: u11 (copy), LocalPlayer (ref), TweenService (ref), TweenInfo_new_ret (ref), DebrisModule (ref), u3 (ref), u2 (ref)
                local u27 = u11:Value(UDim2.fromScale(1, 1));
                local u28 = u11:Value(UDim2.fromScale(1.2, 1.2));
                p24.Changed:Connect(function() -- Line: 187
                    -- upvalues: u28 (copy), u27 (copy), LocalPlayer (ref), TweenService (ref), TweenInfo_new_ret (ref), DebrisModule (ref)
                    u28:Set(UDim2.fromScale(0.85, 0.85));
                    u27:Set(UDim2.fromScale());

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

                return u11:Create("Frame")({
                    CleanDelay = u3.Time,
                    Size = UDim2.fromScale(1, 1),
                    Name = "heart" .. p23,
                    BackgroundTransparency = 1,
                    u11:Create("ImageLabel")({
                        BackgroundTransparency = 1,
                        Name = "Bg",
                        Image = "rbxassetid://14484728741",
                        ImageTransparency = 0.35,
                        Size = u11:Animation(u28, u2),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.fromScale(0.5, 0.5),
                        ImageColor3 = Color3.new(0.45, 0.2, 0.2)
                    }),
                    u11:Create("ImageLabel")({
                        BackgroundTransparency = 1,
                        Name = "Fg",
                        Image = "rbxassetid://14484728741",
                        ImageTransparency = 0,
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.fromScale(0.5, 0.5),
                        ImageColor3 = Color3.new(1, 0, 0),
                        Size = u11:Animation(u27, u2)
                    })
                });
            end)
        }),
        u11:Create("Frame")({
            Name = "Bottom",
            Size = UDim2.fromScale(1, 0.1),
            BackgroundColor3 = Color3.new(),
            BackgroundTransparency = 0.5,
            Position = UDim2.fromScale(0, 1),
            AnchorPoint = Vector2.new(0, 1),
            u11:Create("UIGradient")({
                Rotation = -90,
                Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.5, 0.65), NumberSequenceKeypoint.new(1, 1) })
            }),
            u11:Create("Frame")({
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0.5, 0.6),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Size = UDim2.fromScale(0.095, 0.5),
                Name = "ButtonHolder",
                u11:Create("UIAspectRatioConstraint")({
                    AspectRatio = 4
                }),
                GradientButton(u11, {
                    Text = "Exit",
                    TextXAlignment = Enum.TextXAlignment.Center,
                    GradientTransparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.75), NumberSequenceKeypoint.new(1, 0.3) }),

                    Clicked = function() -- Line: 261, Name: Clicked
                        -- upvalues: u16 (ref), PopUpCreator (ref), PlayTrainingSound (ref), u10 (copy)
                        if u16 == false then
                            u16 = true;

                            if PopUpCreator.new({
                                Type = "Question",
                                Content = "Are you sure you want to leave the Dungeon?"
                            }).Result:Wait(5) == "Yes" then
                                PlayTrainingSound("TrainingExit");
                                u10();
                            end;

                            u16 = false;
                        end;
                    end,

                    Properties = {
                        AnchorPoint = Vector2.new(0.5, 0),
                        Position = UDim2.fromScale(0.5, 0)
                    }
                })
            })
        })
    });

    return function() -- Line: 285
        -- upvalues: u11 (copy)
        u11:Destroy();
    end, v15, v14;
end;
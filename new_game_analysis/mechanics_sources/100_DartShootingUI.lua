-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local faye = require(ReplicatedStorage.Packages.faye);
local TrainingUiScale = require(ReplicatedStorage.CAM.Client.Modules.GamePlay.TrainingUiScale);
local GradientButton = require(ReplicatedStorage.CAM.Client.Components.Misc.Buttons.GradientButton);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local PlatformLeniency = require(ReplicatedStorage.CAM.Client.Modules.GamePlay.PlatformLeniency);
local Color3_new_ret = Color3.new(1, 1, 1);
local Color3_new_ret2 = Color3.new(1, 0, 0);
local Training = ReplicatedStorage.Assets.Sounds.Training;

local function PlayTrainingSound(p1: string) -- Line: 54
    -- upvalues: Training (copy)
    local v2 = Training:FindFirstChild(p1);

    if v2 == nil then
        return;
    end;

    local u3 = v2:Clone();
    u3.Parent = script;
    u3:Play();
    u3.Ended:Once(function() -- Line: 60
        -- upvalues: u3 (copy)
        u3:Destroy();
    end);
end;

return function(p4: any, p5: table?) -- Line: 65
    -- upvalues: faye (copy), PlatformLeniency (copy), Color3_new_ret (copy), Color3_new_ret2 (copy), Utility (copy), TrainingUiScale (copy), GradientButton (copy), PlayTrainingSound (copy), RunService (copy)
    local v6 = p5 or {};
    local u7 = v6.Thread and v6.Thread:Extend() or faye.new();
    local Stop = v6.Stop;
    local v8 = v6.CounterStart or 50;
    local u9 = v6.CounterWin or 100;
    local u10 = v6.CounterLose or 0;
    local u11 = v6.CounterGain or 8;
    local u12 = v6.CounterLoss or 10;
    local u13 = v6.CounterDrain or 0.7;
    local u14 = (v6.CounterTick or 0.1) * PlatformLeniency();
    local u15 = v6.CounterColorStart or Color3_new_ret;
    local u16 = v6.CounterColorEnd or Color3_new_ret2;
    local u17 = v6.CounterShakeThreshold or 30;
    local u18 = v6.CounterShakeAmplitude or 8;
    local u19 = v6.CounterShakeFrequency or 25;
    local u20 = v8;
    local u21 = u7:Value(math.floor(u20) .. "%");
    local u22 = u7:Value(u15);
    local u23 = u7:Value(UDim2.fromScale(0.5, 0.5));
    local u24 = false;

    local function finish(p25: boolean) -- Line: 91
        -- upvalues: u24 (ref), Stop (copy), u7 (copy)
        if u24 then
            return;
        end;

        u24 = true;

        if Stop then
            Stop(p25);
        end;

        u7:Destroy();
    end;

    local function adjustCounter(p26: number) -- Line: 98
        -- upvalues: u24 (ref), u20 (ref), u10 (copy), u9 (copy), u21 (copy), u22 (copy), Utility (ref), u16 (copy), u15 (copy), Stop (copy), u7 (copy)
        if u24 then
            return;
        end;

        u20 = math.clamp(u20 + p26, u10, u9);
        u21:Set(math.floor(u20) .. "%");
        u22:Set(Utility.Lerp_Color2(u16, u15, (u20 - u10) / (u9 - u10)));

        if u9 > u20 then
            if u20 <= u10 then
                if u24 then
                    return;
                end;

                u24 = true;

                if Stop then
                    Stop(false);
                end;

                u7:Destroy();
            end;

            return;
        end;

        if u24 then
            return;
        end;

        u24 = true;

        if Stop then
            Stop(true);
        end;

        u7:Destroy();
    end;

    u7:Create("Frame")({
        Parent = p4,
        Name = "Progressholder",
        Size = TrainingUiScale.Size(UDim2.fromScale(0.2, 0.3)),
        Position = UDim2.fromScale(0.5, TrainingUiScale.Factor() > 1 and 0.95 or 0.98),
        AnchorPoint = Vector2.new(0.5, 1),
        u7:Create("UIAspectRatioConstraint")({
            AspectRatio = 3
        }),
        BackgroundTransparency = 1,
        u7:Create("TextLabel")({
            BackgroundTransparency = 1,
            ZIndex = 2,
            TextScaled = true,
            Size = UDim2.fromScale(1, 0.2),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = u23,
            Font = Enum.Font.SourceSansSemibold,
            Text = u21,
            TextColor3 = u22
        }),
        u7:Create("ImageLabel")({
            Name = "Bg",
            Image = "rbxassetid://134657809787110",
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1),
            ImageColor3 = Color3.new(0.05, 0.05, 0.05)
        }),
        u7:Create("Frame")({
            Size = UDim2.fromScale(0.3, 0.27),
            u7:Create("UIAspectRatioConstraint")({
                AspectRatio = 3
            }),
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 1.05),
            GradientButton(u7, {
                Text = "Exit",
                TextXAlignment = Enum.TextXAlignment.Center,
                GradientTransparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.75), NumberSequenceKeypoint.new(1, 0.3) }),

                Clicked = function() -- Line: 161, Name: Clicked
                    -- upvalues: PlayTrainingSound (ref), u24 (ref), Stop (copy), u7 (copy)
                    PlayTrainingSound("TrainingExit");

                    if u24 then
                        return;
                    end;

                    u24 = true;

                    if Stop then
                        Stop(false);
                    end;

                    u7:Destroy();
                end,

                Properties = {
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.fromScale(0.5, 0)
                }
            })
        })
    });
    local u27 = 0;
    u7:Add(RunService.RenderStepped:Connect(function(p28) -- Line: 176
        -- upvalues: u20 (ref), u17 (copy), u27 (ref), u19 (copy), u18 (copy), u23 (copy)
        if u20 >= u17 then
            u27 = 0;
            u23:Reset();

            return;
        end;

        u27 = u27 + p28;
        local v29 = (u17 - u20) / u17;
        local v30 = u27 * u19;
        local v31 = math.noise(v30, 0, 0) * u18 * v29;
        local v32 = math.noise(0, v30, 7.3) * u18 * v29;
        u23:Set(UDim2.fromScale(0.5, 0.5) + UDim2.fromOffset(v31, v32));
    end));
    task.spawn(function() -- Line: 192
        -- upvalues: u7 (copy), u14 (copy), adjustCounter (copy), u13 (copy)
        while u7.IsActive and task.wait(u14) do
            adjustCounter(-u13);
        end;
    end);

    return {
        Hit = function() -- Line: 199, Name: Hit
            -- upvalues: adjustCounter (copy), u11 (copy)
            adjustCounter(u11);
        end,

        Miss = function() -- Line: 200, Name: Miss
            -- upvalues: adjustCounter (copy), u12 (copy)
            adjustCounter(-u12);
        end,

        Destroy = function() -- Line: 201, Name: Destroy
            -- upvalues: u7 (copy)
            u7:Destroy();
        end,

        Counter = u21
    };
end;
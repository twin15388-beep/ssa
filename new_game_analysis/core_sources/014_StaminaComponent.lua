-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u1 = game:GetService("RunService"):IsRunning();
local faye = require(ReplicatedStorage.Packages.faye);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local Info = faye.Info;
local u2 = Info(0.3);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local LocalPlayer = game:GetService("Players").LocalPlayer;
local Stamina = Utility.getvaluesfolder(LocalPlayer, true):WaitForChild("Stamina");
local math_max = math.max;
local math_min = math.min;
local u3 = NumberSequence;
local u4 = NumberSequenceKeypoint;
local TweenService = game:GetService("TweenService");
local TweenInfo_new_ret = TweenInfo.new(0.1);
local TweenInfo_new_ret2 = TweenInfo.new(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
local u5 = Info(0.75);

function actuateProg(p6: any, p7: number)
    -- upvalues: u3 (copy), u4 (copy), math_max (copy), math_min (copy)
    if p6 ~= nil then
        local v8 = p7 or 1;
        p6:Set(u3.new(v8 == 0 and 1 or {
            u4.new(0, 1),
            u4.new(math_max(0.5 - v8 * 0.5 - 0.0002 - 0.0002, 0.0002), 1),
            u4.new(math_max(0.5 - v8 * 0.5 - 0.0002, 0.0004), 0),
            u4.new(0.5, 0),
            u4.new(math_min(v8 * 0.5 + 0.5 + 0.0002, 0.9996), 0),
            u4.new(math_min(v8 * 0.5 + 0.5 + 0.0002 + 0.0002, 0.9998), 1),
            u4.new(1, 1)
        }));

        return p6;
    end;
end;

return function(p9) -- Line: 35
    -- upvalues: faye (copy), Stamina (copy), TweenService (copy), TweenInfo_new_ret (copy), TweenInfo_new_ret2 (copy), u1 (copy), u2 (copy), gameSettings (copy), u5 (copy)
    local u10 = nil;
    local u11 = faye.new();
    local u12 = u11:Value(1);
    local u13 = u11:Value(1);
    local u14 = u11:Value(1);
    local u15 = actuateProg(u11:Value(), 0);
    local u16 = u11:Value(1);
    u11:Connect(game.ReplicatedStorage.Communication.CnC.NotEnoughStamina.Event, function(p17) -- Line: 45
        -- upvalues: u15 (copy), u16 (copy)
        actuateProg(u15, p17);
        u16:Refresh();
    end);
    local u18 = u11:Value();
    local u19 = u11:Create("NumberValue")({
        Value = Stamina.Value / Stamina.MaxValue
    });
    local u20 = u11:Value();
    local u21 = u11:Create("NumberValue")({
        Value = Stamina.Value / Stamina.MaxValue
    });

    local function updateTransparent(p22: boolean) -- Line: 58
        -- upvalues: u12 (copy), u13 (copy), u14 (copy)
        if p22 == false then
            u12:Reset();
            u13:Reset();
            u14:Reset();

            return;
        end;

        u12:Set(0.5);
        u13:Set(0.75);
        u14:Set(0);
    end;

    local u23 = false;

    local function setProg() -- Line: 71
        -- upvalues: Stamina (ref), TweenService (ref), u19 (copy), TweenInfo_new_ret (ref), u21 (copy), TweenInfo_new_ret2 (ref), u10 (ref), u11 (copy), u12 (copy), u13 (copy), u14 (copy), u23 (ref), updateTransparent (copy)
        local math_random_ret = math.random(1, 999);
        local v24 = Stamina.Value / Stamina.MaxValue;
        TweenService:Create(u19, TweenInfo_new_ret, {
            Value = v24
        }):Play();
        TweenService:Create(u21, TweenInfo_new_ret2, {
            Value = v24
        }):Play();
        local v25 = true;

        if u10 == nil then
            v25 = v24 ~= 1;
        elseif v24 == 1 then
            task.delay(1, function() -- Line: 82
                -- upvalues: u10 (ref), math_random_ret (copy), u11 (ref), u12 (ref), u13 (ref), u14 (ref), u23 (ref)
                if u10 == math_random_ret and u11.IsActive then
                    u12:Reset();
                    u13:Reset();
                    u14:Reset();
                    u23 = false;
                end;
            end);
        else
            v25 = true;
        end;

        if v25 ~= u23 then
            updateTransparent(v25);
            u23 = v25;
        end;

        u10 = math_random_ret;
    end;

    local u26 = nil;
    local u27 = nil;
    u11:Reactive(function(p28) -- Line: 108
        -- upvalues: u19 (copy), u21 (copy), u26 (ref), u18 (copy), u27 (ref), u20 (copy)
        local v29 = p28(u19);
        local v30 = p28(u21);

        if u26 ~= v29 then
            actuateProg(u18, v29);
            u26 = v29;
        end;

        if u27 ~= v30 then
            actuateProg(u20, v30);
            u27 = v30;
        end;
    end);
    setProg();
    u11:Connect(Stamina.Changed, setProg);
    u11:Create("Frame")({
        Size = u1 and UDim2.fromScale(1, 1) or UDim2.fromScale(0.95, 0.65),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Parent = p9,
        BackgroundTransparency = 1,
        u11:Create("ImageLabel")({
            Name = "Bg\'sBg",
            ZIndex = -1,
            Image = "rbxassetid://110106230312715",
            BackgroundTransparency = 1,
            ImageColor3 = Color3.new(),
            ImageTransparency = u11:Animation(u12, u2),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1.065, 1.3)
        }),
        u11:Create("ImageLabel")({
            Name = "Bg",
            Image = "rbxassetid://89528550122959",
            BackgroundTransparency = 1,
            ImageColor3 = Color3.new(),
            ImageTransparency = u11:Animation(u13, u2),
            Size = UDim2.fromScale(1, 1)
        }),
        u11:Create("ImageLabel")({
            Name = "Fg",
            ImageColor3 = gameSettings.staminaColor,
            ImageTransparency = u11:Animation(u14, u2),
            ZIndex = 3,
            Image = "rbxassetid://89528550122959",
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            u11:Create("UIGradient")({
                Transparency = u18
            })
        }),
        u11:Create("ImageLabel")({
            Name = "RedStaminaMissingBar",
            ImageColor3 = Color3.new(1, 0, 0),
            ImageTransparency = u11:Animation(u16, u5, {
                AlwaysFrom = 0
            }),
            ZIndex = 1,
            Image = "rbxassetid://89528550122959",
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            u11:Create("UIGradient")({
                Transparency = u15
            })
        }),
        u11:Create("ImageLabel")({
            Name = "Fg",
            ImageColor3 = Color3.new(1, 1, 1),
            ImageTransparency = u11:Animation(u14, u2),
            ZIndex = 2,
            Image = "rbxassetid://89528550122959",
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            u11:Create("UIGradient")({
                Transparency = u20
            })
        })
    });

    return function() -- Line: 194
        -- upvalues: u11 (copy)
        u11:Destroy();
    end;
end;
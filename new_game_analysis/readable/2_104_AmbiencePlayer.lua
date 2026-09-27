-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local DataValue = require(ReplicatedStorage.CAM.Client.Modules.DataValue);
local SettingsKeys = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.SettingsKeys);
local AreaLocator = ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Subsets"):WaitForChild("Areas"):WaitForChild("AreaLocator");
local u1 = require(AreaLocator);
local DayAndNightHandler = require(ReplicatedStorage.CAM.Global.DayAndNightHandler);
local u2 = DataValue.new(SettingsKeys.AmbienceVolume.Path, SettingsKeys.AmbienceVolume.Default, SettingsKeys.Scope);

local function VolumeShare() -- Line: 45
    -- upvalues: u2 (copy)
    local v3 = u2:Get();

    return type(v3) ~= "number" and 1 or math.clamp(v3, 0, 1);
end;

local function CategoryFor() -- Line: 50
    -- upvalues: u1 (copy), DayAndNightHandler (copy)
    local AreaEquipped = u1.AreaEquipped;

    return AreaEquipped.Cave and "Cave" or (AreaEquipped.Village and "Village" or (DayAndNightHandler.IsEnabled() and DayAndNightHandler.IsNight() and "Night" or "Outside"));
end;

local u4 = {};

for _, v in { "Cave", "Village", "Outside", "Night" } do
    local v5 = script:FindFirstChild(v .. "_Ambience");

    if v5 == nil or not v5:IsA("Sound") then
        warn("[Ambience] no " .. v .. "_Ambience Sound under this script");
    else
        if v5:GetAttribute("DV") == nil then
            v5:SetAttribute("DV", v5.Volume);
        end;

        u4[v] = v5;
    end;
end;

local u6 = nil;
local u7 = nil;

local function Swap(p8: string) -- Line: 84
    -- upvalues: u7 (ref), u6 (ref), u4 (copy), TweenService (copy), u2 (copy)
    if u7 == p8 then
        return;
    end;

    u7 = p8;
    local u9 = u6;
    local v10 = u4[p8];
    u6 = v10;

    if u9 ~= nil and u9 ~= v10 then
        TweenService:Create(u9, TweenInfo.new(1), {
            Volume = 0
        }):Play();
        task.delay(1, function() -- Line: 94
            -- upvalues: u6 (ref), u9 (copy)
            if u6 ~= u9 then
                u9:Stop();
            end;
        end);
    end;

    if v10 == nil or u9 == v10 then
        return;
    end;

    v10.Looped = true;
    v10.Volume = 0;
    v10:Play();
    local TweenInfo_new_ret = TweenInfo.new(1);
    local v11 = {};
    local v12 = v10:GetAttribute("DV") or 1;
    local v13 = u2:Get();
    v11.Volume = v12 * (type(v13) ~= "number" and 1 or math.clamp(v13, 0, 1));
    TweenService:Create(v10, TweenInfo_new_ret, v11):Play();
end;

u2.Changed:Connect(function() -- Line: 110
    -- upvalues: u6 (ref), u2 (copy)
    if u6 ~= nil and u6.IsPlaying then
        local v14 = u6:GetAttribute("DV") or 1;
        local v15 = u2:Get();
        u6.Volume = v14 * (type(v15) ~= "number" and 1 or math.clamp(v15, 0, 1));
    end;
end);
local AreaEquipped = u1.AreaEquipped;
Swap(AreaEquipped.Cave and "Cave" or (AreaEquipped.Village and "Village" or (DayAndNightHandler.IsEnabled() and DayAndNightHandler.IsNight() and "Night" or "Outside")));
u1.AreaEquipped.Update:Connect(function() -- Line: 116, Name: Update
    -- upvalues: Swap (copy), u1 (copy), DayAndNightHandler (copy)
    local AreaEquipped2 = u1.AreaEquipped;
    Swap(AreaEquipped2.Cave and "Cave" or (AreaEquipped2.Village and "Village" or (DayAndNightHandler.IsEnabled() and DayAndNightHandler.IsNight() and "Night" or "Outside")));
end);

if DayAndNightHandler.IsEnabled() then
    task.spawn(function() -- Line: 128
        -- upvalues: DayAndNightHandler (copy), Swap (copy), u1 (copy)
        while true do
            local task_wait = task.wait;
            local v16 = DayAndNightHandler.SecondsUntilPhaseChange();
            task_wait((math.max(v16, 1)));
            local AreaEquipped2 = u1.AreaEquipped;
            Swap(AreaEquipped2.Cave and "Cave" or (AreaEquipped2.Village and "Village" or (DayAndNightHandler.IsEnabled() and DayAndNightHandler.IsNight() and "Night" or "Outside")));
        end;
    end);
end;
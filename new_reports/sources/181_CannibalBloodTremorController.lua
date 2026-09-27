-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local BloodDrinkConfig = require(ReplicatedStorage:WaitForChild("Funções"):WaitForChild("BloodDrinkConfig"));
local v1 = tonumber(BloodDrinkConfig.CannibalShakeFeedsToMax) or 10;
local math_floor_ret = math.floor(v1);
local math_max_ret = math.max(1, math_floor_ret);
local v2 = tonumber(BloodDrinkConfig.CannibalShakeMaxPosition) or 0.018;
local math_max_ret2 = math.max(0, v2);
local v3 = tonumber(BloodDrinkConfig.CannibalShakeMaxRotationDegrees) or 0.9;
local math_max_ret3 = math.max(0, v3);
local math_rad_ret = math.rad(math_max_ret3);
local v4 = tonumber(BloodDrinkConfig.CannibalShakeFrequency) or 12;
local math_max_ret4 = math.max(0.1, v4);
local u5 = {};

local function isCannibalVampire(p6) -- Line: 25
    if p6:GetAttribute("CannibalVampire") ~= true then
        return false;
    end;

    local Team = p6.Team;
    local v7;

    if Team == nil then
        v7 = false;
    else
        v7 = Team.Name == "Vampires" and true or Team.Name == "Cannibal Raised";
    end;

    return v7;
end;

local function intensityFor(p8) -- Line: 33
    -- upvalues: math_max_ret (copy)
    local v9 = tonumber(p8:GetAttribute("CannibalBloodFeeds")) or 0;
    local math_floor_ret2 = math.floor(v9);
    local math_clamp_ret = math.clamp(math_floor_ret2, 0, math_max_ret);

    return math_clamp_ret <= 0 and 0 or math_clamp_ret / math_max_ret * 0.75 + 0.25;
end;

local function motorSeed(p10, p11) -- Line: 45
    local v12 = p10.UserId % 997;

    for i = 1, #p11.Name do
        v12 = v12 + string.byte(p11.Name, i) * i;
        local _ = i;
    end;

    return v12;
end;

local function isBodyMotor(p13, p14) -- Line: 53
    if p14.Name == "RightGrip" or p14.Name == "LeftGrip" then
        return false;
    end;

    local Part0 = p14.Part0;
    local Part1 = p14.Part1;

    if Part0 and (Part1 and (Part0:IsDescendantOf(p13) and Part1:IsDescendantOf(p13))) then
        return not (Part0:FindFirstAncestorOfClass("Tool") or Part1:FindFirstAncestorOfClass("Tool"));
    end;

    return false;
end;

local function applyTremor(p15, p16, p17, p18) -- Line: 68
    -- upvalues: math_max_ret4 (copy), isBodyMotor (copy), math_max_ret2 (copy), math_rad_ret (copy), u5 (copy)
    local v19 = p16:FindFirstChildOfClass("Humanoid");

    if not v19 or v19.Health <= 0 then
        return;
    end;

    local v20 = p18 * math_max_ret4;

    for _, descendant in ipairs(p16:GetDescendants()) do
        if descendant:IsA("Motor6D") and isBodyMotor(p16, descendant) then
            local v21 = p15.UserId % 997;
            local v22 = descendant;

            for i = 1, #descendant.Name do
                v21 = v21 + string.byte(v22.Name, i) * i;
                local _ = i;
            end;

            local v23 = math_max_ret2 * p17;
            local v24 = math_rad_ret * p17;
            local v25 = v21 * 0.017 + 0.13;
            local math_noise_ret = math.noise(v20, v25, 0.37);
            local math_noise_ret2 = math.noise(v20, v25 + 3.11, 7.23);
            local math_noise_ret3 = math.noise(v20, v25 + 6.29, 13.47);
            local math_noise_ret4 = math.noise(v20, v25 + 9.41, 19.61);
            local math_noise_ret5 = math.noise(v20, v25 + 12.53, 25.79);
            local math_noise_ret6 = math.noise(v20, v25 + 15.67, 31.97);

            if v22.Name == "RootJoint" or v22.Name == "Root" then
                v23 = v23 * 0.35;
                v24 = v24 * 0.55;
            end;

            local v26 = CFrame.new(math_noise_ret * v23, math_noise_ret2 * v23, math_noise_ret3 * v23) * CFrame.Angles(math_noise_ret4 * v24, math_noise_ret5 * v24, math_noise_ret6 * v24);
            v22.Transform = v22.Transform * v26;
            u5[v22] = v26;
        end;
    end;
end;

RunService.PreAnimation:Connect(function() -- Line: 16, Name: removeAppliedOffsets
    -- upvalues: u5 (copy)
    for i, v in pairs(u5) do
        if i.Parent then
            i.Transform = i.Transform * v:Inverse();
        end;

        u5[i] = nil;
    end;
end);
RunService.PreSimulation:Connect(function() -- Line: 116
    -- upvalues: Players (copy), math_max_ret (copy), applyTremor (copy)
    local v27 = workspace:GetServerTimeNow() % 10000;

    for _, v in ipairs(Players:GetPlayers()) do
        local v28;

        if v:GetAttribute("CannibalVampire") == true then
            local Team = v.Team;

            if Team == nil then
                v28 = false;
            else
                v28 = Team.Name == "Vampires" and true or Team.Name == "Cannibal Raised";
            end;
        else
            v28 = false;
        end;

        if v28 then
            local v29 = tonumber(v:GetAttribute("CannibalBloodFeeds")) or 0;
            local math_floor_ret2 = math.floor(v29);
            local math_clamp_ret = math.clamp(math_floor_ret2, 0, math_max_ret);
            local v30 = math_clamp_ret <= 0 and 0 or math_clamp_ret / math_max_ret * 0.75 + 0.25;
            local Character = v.Character;

            if v30 > 0 and Character then
                applyTremor(v, Character, v30, v27);
            end;
        end;
    end;
end);
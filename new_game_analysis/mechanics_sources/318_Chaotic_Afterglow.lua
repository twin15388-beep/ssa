-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local _ = ReplicatedStorage.CAM;
local Skills = ReplicatedStorage.Skills;
local u1 = require(ReplicatedStorage.Packages.cleanit).new();
local u2 = {
    Id = 0
};
local skill_stand_still = Skills.holder.skill_stand_still;
local script_ChaoticAfterglowStartup = script.ChaoticAfterglowStartup;
local script_ChaoticAfterglowLoop = script.ChaoticAfterglowLoop;
local script_ChaoticAfterglowFinish = script.ChaoticAfterglowFinish;

function u2.Hold(p3: userdata) -- Line: 17
    -- upvalues: u1 (copy), u2 (copy), skill_stand_still (copy), script_ChaoticAfterglowStartup (copy), script_ChaoticAfterglowLoop (copy)
    u1:Clean();
    local Humanoid = p3.Character:FindFirstChild("Humanoid");
    local RootPart = Humanoid.RootPart;
    local Animator = Humanoid:FindFirstChild("Animator");
    local Id = u2.Id;
    local v4 = skill_stand_still:Clone();
    v4.LinearVelocity.VectorVelocity = Vector3.new(0, 0, 0);
    u1:Add(v4);
    v4.Parent = RootPart;
    local v5 = Animator:LoadAnimation(script_ChaoticAfterglowStartup);
    u1:Add(v5);
    v5:Play();
    task.wait(0.92);

    if Id ~= u2.Id then
        return;
    end;

    local v6 = Animator:LoadAnimation(script_ChaoticAfterglowLoop);
    u1:Add(v6);
    v6:Play();
    v6:AdjustSpeed(0.1);
    task.wait(0.8);

    if Id ~= u2.Id then
        return;
    end;

    v6:AdjustSpeed(1);
end;

function u2.UnHold(p7: userdata) -- Line: 48
    -- upvalues: u1 (copy), u2 (copy), script_ChaoticAfterglowFinish (copy)
    u1:Clean();
    local Animator = p7.Character:FindFirstChild("Humanoid"):FindFirstChild("Animator");
    local Id = u2.Id;
    Animator:LoadAnimation(script_ChaoticAfterglowFinish):Play();
    task.wait(0.93);

    if Id ~= u2.Id then
        return;
    end;

    u2.Cancel(p7);
end;

function u2.Cancel(p8: userdata?) -- Line: 64
    -- upvalues: u1 (copy)
    u1:Clean();
end;

return u2;
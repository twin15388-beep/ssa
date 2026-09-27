-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local _ = ReplicatedStorage.CAM;
local Skills = ReplicatedStorage.Skills;
local u1 = require(ReplicatedStorage.Packages.cleanit).new();
local Platform_Handler = require(ReplicatedStorage.CAM.Client.Controllers.Platform_Handler);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local Config = require(script.Parent.Config);
local u2 = {
    Id = 0
};
local u3 = {
    mover = nil,
    startupTrack = nil,
    loopTrack = nil,
    hitTrack = nil
};
local skill_stand_still = Skills.holder.skill_stand_still;
local script_CompassNeedleStartup = script.CompassNeedleStartup;
local script_CompassNeedleLoop = script.CompassNeedleLoop;
local script_CompassNeedleHit = script.CompassNeedleHit;

function u2.Hold(p4: userdata, u5: vector) -- Line: 33
    -- upvalues: u1 (copy), u2 (copy), u3 (copy), script_CompassNeedleStartup (copy), skill_stand_still (copy), Utility (copy), RunService (copy), Platform_Handler (copy), script_CompassNeedleLoop (copy)
    u1:Clean();
    local Character = p4.Character;
    local Humanoid = Character:FindFirstChild("Humanoid");
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
    local Animator = Humanoid:FindFirstChild("Animator");
    local Id = u2.Id;
    u3.startupTrack = Animator:LoadAnimation(script_CompassNeedleStartup);
    u1:Add(u3.startupTrack);
    u3.startupTrack:Play();
    local u6 = skill_stand_still:Clone();
    u1:Add(u6);
    u6.LinearVelocity.VectorVelocity = Vector3.new(0, 0, 0);
    u6.Parent = HumanoidRootPart;
    local u7, v8 = Utility.CreateAlignOrientationWithAttachment(HumanoidRootPart, "skill_look_at", {
        Responsiveness = 70,
        MaxTorque = 500000,
        AlignType = Enum.AlignType.PrimaryAxisParallel,
        CFrame = Utility.SafeLookAt(HumanoidRootPart.Position, u5, HumanoidRootPart.CFrame)
    });
    u1:Add(u7);
    u1:Add(v8);
    u1:Connect(RunService.PostSimulation, function() -- Line: 59
        -- upvalues: u5 (ref), Platform_Handler (ref), u7 (copy), Utility (ref), HumanoidRootPart (copy)
        u5 = Platform_Handler.mousepos();
        u7.CFrame = Utility.SafeLookAt(HumanoidRootPart.Position, u5, u7.CFrame);
    end);
    task.delay(1.13, function() -- Line: 70
        -- upvalues: Id (copy), u2 (ref), u6 (copy), u3 (ref), Animator (copy), script_CompassNeedleLoop (ref), u1 (ref)
        if Id ~= u2.Id then
            return;
        end;

        if u6.Parent == nil then
            return;
        end;

        u3.startupTrack:Stop();
        u3.loopTrack = Animator:LoadAnimation(script_CompassNeedleLoop);
        u1:Add(u3.loopTrack);
        u3.loopTrack:Play();
    end);
end;

function u2.UnHold(p9: userdata) -- Line: 82
    -- upvalues: u2 (copy)
    u2.Cancel(p9);
end;

function u2.Cancel(p10: userdata) -- Line: 86
    -- upvalues: u1 (copy)
    u1:Clean();
end;

function u2.Counter(u11: userdata, p12: vector, p13: userdata) -- Line: 96
    -- upvalues: u1 (copy), u2 (copy), u3 (copy), script_CompassNeedleHit (copy), Config (copy)
    u1:Clean();
    local Character = u11.Character;
    local Humanoid = Character:FindFirstChild("Humanoid");
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
    local Animator = Humanoid:FindFirstChild("Animator");
    local Position = p13:GetPivot().Position;

    if (Position - HumanoidRootPart.Position).Magnitude > 0.01 then
        HumanoidRootPart.CFrame = CFrame.lookAt(HumanoidRootPart.Position, Position);
    end;

    local Id = u2.Id;
    u3.hitTrack = Animator:LoadAnimation(script_CompassNeedleHit);
    u3.hitTrack:Play();
    task.delay(Config.COUNTER_ANIM_LENGTH, function() -- Line: 116
        -- upvalues: Id (copy), u2 (ref), u11 (copy)
        if Id ~= u2.Id then
            return;
        end;

        u2.Cancel(u11);
    end);
end;

return u2;
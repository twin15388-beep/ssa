-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local CAM = ReplicatedStorage.CAM;
local Client = CAM.Client;
local Global = CAM.Global;
local Skills = ReplicatedStorage.Skills;
local u1 = require(ReplicatedStorage.Packages.cleanit).new();
local Platform_Handler = require(Client.Controllers.Platform_Handler);
local Utility = require(Global.Utility);
local ManuelCancel = require(Global.Subsets.Gameplay.ManuelCancel);
local Config = require(script.Parent.Config);
local u2 = {
    Id = 0
};
local u3 = {
    startupTrack = nil,
    loopTrack = nil,
    furyTrack = nil
};
local skill_stand_still = Skills.holder.skill_stand_still;
local script_ExplosiveFuryStart = script.ExplosiveFuryStart;
local script_ExplosiveFuryLoop = script.ExplosiveFuryLoop;
local script_ExplosiveFuryHit = script.ExplosiveFuryHit;

function u2.Hold(p4: userdata) -- Line: 35
    -- upvalues: u1 (copy), Utility (copy), u2 (copy), u3 (copy), script_ExplosiveFuryStart (copy), Config (copy), skill_stand_still (copy), Platform_Handler (copy), script_ExplosiveFuryLoop (copy), RunService (copy)
    u1:Clean();
    local Character = p4.Character;
    local Humanoid = Character:FindFirstChild("Humanoid");
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
    local Animator = Humanoid:FindFirstChild("Animator");
    local valuesfolder = Utility.getvaluesfolder(Character);
    local Id = u2.Id;
    u3.startupTrack = Animator:LoadAnimation(script_ExplosiveFuryStart);
    u1:Add(u3.startupTrack);
    u3.startupTrack:Play();
    u3.startupTrack:AdjustSpeed(Config.DASH_START_ANIM_SPEED);
    u1:Add(Utility.AddValue(valuesfolder, "NR", 6));
    local u5 = skill_stand_still:Clone();
    u1:Add(u5);
    u5.LinearVelocity.ForceLimitMode = Enum.ForceLimitMode.PerAxis;
    u5.LinearVelocity.MaxAxesForce = Vector3.new(20000, 0, 20000);
    u5.LinearVelocity.VectorVelocity = Vector3.new(0, 0, 0);
    u5.Parent = HumanoidRootPart;
    local u6, v7 = Utility.CreateAlignOrientationWithAttachment(HumanoidRootPart, "skill_look_at", {
        Responsiveness = 70,
        MaxTorque = 500000,
        AlignType = Enum.AlignType.PrimaryAxisParallel,
        CFrame = Utility.SafeLookAt(HumanoidRootPart.Position, Platform_Handler.mousepos(Config.MOUSE_RANGE), HumanoidRootPart.CFrame)
    });
    u1:Add(u6);
    u1:Add(v7);
    task.delay(Config.DASH_STARTUP_DURATION, function() -- Line: 77
        -- upvalues: u2 (ref), Id (copy), u5 (copy), HumanoidRootPart (copy), u3 (ref), Animator (copy), script_ExplosiveFuryLoop (ref), u1 (ref), RunService (ref), Platform_Handler (ref), Config (ref), u6 (copy)
        if u2.Id ~= Id then
            return;
        end;

        if u5.Parent == nil or HumanoidRootPart.Parent == nil then
            return;
        end;

        u3.startupTrack:Stop();
        u3.loopTrack = Animator:LoadAnimation(script_ExplosiveFuryLoop);
        u1:Add(u3.loopTrack);
        u3.loopTrack:Play();
        u1:Connect(RunService.PostSimulation, function() -- Line: 87
            -- upvalues: Id (ref), u2 (ref), Platform_Handler (ref), Config (ref), HumanoidRootPart (ref), u6 (ref), u5 (ref)
            if Id ~= u2.Id then
                return;
            end;

            local v8 = Platform_Handler.mousepos(Config.MOUSE_RANGE);
            local CFrame_new_ret = CFrame.new(HumanoidRootPart.Position, v8);
            u6.CFrame = CFrame_new_ret;
            u5.LinearVelocity.VectorVelocity = CFrame_new_ret.LookVector * Config.DASH_SPEED;
        end);
    end);
end;

function u2.UnHold(u9: userdata) -- Line: 98
    -- upvalues: u1 (copy), Utility (copy), u2 (copy), Platform_Handler (copy), Config (copy), RunService (copy), ManuelCancel (copy), u3 (copy), script_ExplosiveFuryHit (copy)
    u1:Clean();
    local Character = u9.Character;
    local Animator = Character:FindFirstChild("Humanoid"):FindFirstChild("Animator");
    local valuesfolder = Utility.getvaluesfolder(Character);
    local Id = u2.Id;
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
    u1:Add(Utility.AddValue(valuesfolder, "NR", 3));
    u1:Add(Utility.AddValue(valuesfolder, "pause_gameplay", 3));
    local u10, v11 = Utility.CreateAlignOrientationWithAttachment(HumanoidRootPart, "skill_look_at", {
        Responsiveness = 70,
        MaxTorque = 500000,
        AlignType = Enum.AlignType.PrimaryAxisParallel,
        CFrame = Utility.SafeLookAt(HumanoidRootPart.Position, Platform_Handler.mousepos(Config.MOUSE_RANGE), HumanoidRootPart.CFrame)
    });
    u1:Add(v11);
    u1:Connect(RunService.PostSimulation, function() -- Line: 126
        -- upvalues: u2 (ref), Id (copy), Platform_Handler (ref), Config (ref), u10 (copy), Utility (ref), HumanoidRootPart (copy)
        if u2.Id ~= Id then
            return;
        end;

        local v12 = Platform_Handler.mousepos(Config.MOUSE_RANGE);
        u10.CFrame = Utility.SafeLookAt(HumanoidRootPart.Position, Vector3.new(v12.X, HumanoidRootPart.Position.Y, v12.Z), u10.CFrame);
    end);
    local v13, v14 = ManuelCancel.new(u9, 3);
    v13:Connect(function() -- Line: 135
        -- upvalues: u2 (ref), u9 (copy)
        u2.Id = -1;
        u2.Cancel(u9);
    end);
    u3.hitTrack = Animator:LoadAnimation(script_ExplosiveFuryHit);
    u1:Add(u3.hitTrack);
    u3.hitTrack:Play();
    task.wait(1.75);

    if u2.Id ~= Id then
        return;
    end;

    v14();
    u2.Cancel(u9);
end;

function u2.Cancel(p15: userdata) -- Line: 149
    -- upvalues: u1 (copy)
    u1:Clean();
end;

return u2;
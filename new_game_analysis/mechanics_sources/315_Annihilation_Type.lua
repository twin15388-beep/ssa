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
local Config = require(script.Parent.Config);
local u2 = {
    Id = 0
};
local skill_stand_still = Skills.holder.skill_stand_still;
local script_AnnihilationTypeStart = script.AnnihilationTypeStart;
local script_AnnihilationTypeLoop = script.AnnihilationTypeLoop;

function u2.Hold(p3: userdata) -- Line: 25
    -- upvalues: u1 (copy), Utility (copy), u2 (copy), script_AnnihilationTypeStart (copy), skill_stand_still (copy), Platform_Handler (copy), Config (copy), script_AnnihilationTypeLoop (copy), RunService (copy)
    u1:Clean();
    local Character = p3.Character;
    local Humanoid = Character:FindFirstChild("Humanoid");
    local RootPart = Humanoid.RootPart;
    local Animator = Humanoid:FindFirstChild("Animator");
    local valuesfolder = Utility.getvaluesfolder(Character);
    local Id = u2.Id;
    u1:Add(Utility.AddValue(valuesfolder, "NR", 3));
    u1:Add(Utility.AddValue(valuesfolder, "pause_gameplay", 3));
    local v4 = Animator:LoadAnimation(script_AnnihilationTypeStart);
    u1:Add(v4);
    v4:Play();
    local u5 = skill_stand_still:Clone();
    u1:Add(u5);
    u5.LinearVelocity.ForceLimitMode = Enum.ForceLimitMode.PerAxis;
    u5.LinearVelocity.MaxAxesForce = Vector3.new(20000, 0, 20000);
    u5.LinearVelocity.VectorVelocity = Vector3.new(0, 0, 0);
    u5.Parent = RootPart;
    u1:Add(Utility.AddValue(valuesfolder, "NOMouvementlines", 7));
    u1:Add(function() -- Line: 50
        -- upvalues: RootPart (copy)
        RootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
        RootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
    end);
    local u6, v7 = Utility.CreateAlignOrientationWithAttachment(RootPart, "skill_look_at", {
        Responsiveness = 80,
        MaxTorque = 500000,
        AlignType = Enum.AlignType.PrimaryAxisParallel,
        CFrame = Utility.SafeLookAt(RootPart.Position, Platform_Handler.mousepos(Config.MOUSE_RANGE), RootPart.CFrame)
    });
    u1:Add(u6);
    u1:Add(v7);
    task.wait(Config.STARTUP_LOOP_DURATION);

    if Id ~= u2.Id then
        return;
    end;

    local v8 = Animator:LoadAnimation(script_AnnihilationTypeLoop);
    u1:Add(v8);
    v8:Play();
    u1:Connect(RunService.PostSimulation, function() -- Line: 75
        -- upvalues: Id (copy), u2 (ref), Platform_Handler (ref), Config (ref), RootPart (copy), u6 (copy), u5 (copy)
        if Id ~= u2.Id then
            return;
        end;

        local v9 = Platform_Handler.mousepos(Config.MOUSE_RANGE);
        local CFrame_new_ret = CFrame.new(RootPart.Position, v9);
        u6.CFrame = CFrame_new_ret;
        u5.LinearVelocity.VectorVelocity = CFrame_new_ret.LookVector * Config.DASH_SPEED;
    end);
end;

function u2.UnHold(p10: userdata, p11: vector?) -- Line: 85
    -- upvalues: u2 (copy)
    u2.Cancel(p10);
end;

function u2.Cancel(p12: userdata?) -- Line: 89
    -- upvalues: u1 (copy)
    u1:Clean();
end;

return u2;
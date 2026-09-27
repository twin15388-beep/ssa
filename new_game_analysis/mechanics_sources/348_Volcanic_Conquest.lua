-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
game:GetService("TweenService");
game:GetService("CollectionService");
local CAM = ReplicatedStorage.CAM;
local Global = CAM.Global;
local Platform_Handler = require(CAM.Client.Controllers.Platform_Handler);
require(Global.Subsets.Gameplay.ManuelCancel);
local u1 = require(game.ReplicatedStorage.Packages.cleanit).new();
local Utility = require(Global.Utility);
local DebrisModule = require(CAM.DebrisModule);
local Config = require(script.Parent.Config);
local u2 = {
    Id = 0
};
local u3 = {};

function u2.Hold(p4: userdata) -- Line: 36
    -- upvalues: u3 (copy), Platform_Handler (copy), Config (copy), Utility (copy), u1 (copy), DebrisModule (copy), u2 (copy), RunService (copy)
    local Character = p4.Character;

    if not Character then
        return;
    end;

    local Humanoid = Character:FindFirstChild("Humanoid");

    if not Humanoid then
        return;
    end;

    local RootPart = Humanoid.RootPart;

    if not RootPart then
        return;
    end;

    local Animator = Humanoid:FindFirstChild("Animator");

    if not Animator then
        return;
    end;

    local v5 = Animator:LoadAnimation(script.User);
    v5:Play();
    u3.User_Animation = v5;
    local v6 = Platform_Handler.mousepos(Config.MOUSE_RANGE);
    local u7, v8 = Utility.CreateAlignOrientationWithAttachment(RootPart, "skill_look_at", {
        Responsiveness = 75,
        MaxTorque = 3000,
        AlignType = Enum.AlignType.PrimaryAxisParallel,
        CFrame = Utility.SafeLookAt(RootPart.Position, v6, RootPart.CFrame)
    });
    u1:Add(v8);
    u7.CFrame = Utility.SafeLookAt(RootPart.Position, v6, u7.CFrame);
    local v9 = script.Parent.Parent.Parent.holder.skill_stand_still:Clone();
    v9.Parent = RootPart;
    DebrisModule:AddItem(v9, Config.MOVER_LIFETIME);
    u3.mover = v9;
    local LinearVelocity = v9.LinearVelocity;
    local _ = u2.Id;
    LinearVelocity.VectorVelocity = RootPart.CFrame.LookVector;
    u1:Connect(RunService.Heartbeat, function(p10: number) -- Line: 75
        -- upvalues: Platform_Handler (ref), Config (ref), u7 (copy), Utility (ref), RootPart (copy), LinearVelocity (copy)
        local v11 = Platform_Handler.mousepos(Config.MOUSE_RANGE);
        u7.CFrame = Utility.SafeLookAt(RootPart.Position, v11, u7.CFrame);
        LinearVelocity.VectorVelocity = LinearVelocity.VectorVelocity:Lerp(RootPart.CFrame.LookVector * Config.DRIVE_SPEED * Vector3.new(1, 0, 1), 0.2);
    end);
end;

function u2.UnHold(p12: userdata) -- Line: 82
    -- upvalues: u1 (copy), u3 (copy)
    u1:Clean();

    if u3.User_Animation then
        u3.User_Animation:Stop();
        u3.User_Animation:Destroy();
    end;

    if u3.mover then
        u3.mover:Destroy();
        u3.mover = nil;
    end;
end;

function u2.Cancel(p13: userdata) -- Line: 96
    -- upvalues: u1 (copy), u3 (copy)
    u1:Clean();

    if u3.User_Animation then
        u3.User_Animation:Stop();
        u3.User_Animation:Destroy();
    end;

    if u3.mover then
        u3.mover:Destroy();
        u3.mover = nil;
    end;

    local Character = p13.Character;

    if not Character then
        return;
    end;

    local PrimaryPart = Character.PrimaryPart;

    if not PrimaryPart then
        return;
    end;

    PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
    PrimaryPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
end;

return u2;
-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("RunService");
local CAM = ReplicatedStorage:WaitForChild("CAM");
local Client = CAM:WaitForChild("Client");
local Global = CAM:WaitForChild("Global");
local Platform_Handler = require(Client:WaitForChild("Controllers"):WaitForChild("Platform_Handler"));
local Utility = require(Global:WaitForChild("Utility"));
local DebrisModule = require(CAM:FindFirstChild("DebrisModule"));
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Checker"));
require(game.ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
local Config = require(script.Parent.Config);
local gameSettings = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("gameSettings"));
local u1 = {
    Id = 0
};
local u2 = {};
local u3 = nil;

function u1.Hold(p4) -- Line: 27
    -- upvalues: u1 (copy), u3 (ref), Utility (copy), gameSettings (copy), DebrisModule (copy), Config (copy), u2 (copy), Platform_Handler (copy)
    local Id = u1.Id;
    local Character = p4.Character;
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
    local Humanoid = Character:FindFirstChild("Humanoid");

    if u3 then
        u3:Stop();
        u3 = nil;
    end;

    local Id2 = u1.Id;
    local valuesfolder = Utility.getvaluesfolder(Character);
    local Attachment = Instance.new("Attachment", HumanoidRootPart);
    Attachment.Name = "skill_stand_still";
    local LinearVelocity = Instance.new("LinearVelocity");
    LinearVelocity.Attachment0 = Attachment;
    LinearVelocity.MaxForce = gameSettings.skillStandStillForce;
    LinearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector;
    LinearVelocity.VectorVelocity = Vector3.new(0, 0, 0);
    LinearVelocity.Parent = Attachment;
    local BoolValue = Instance.new("BoolValue");
    BoolValue.Name = "NR";
    BoolValue.Parent = valuesfolder;
    DebrisModule:AddItem(BoolValue, Config.HOLD_NR_DURATION);
    table.insert(u2, BoolValue);
    table.insert(u2, Attachment);
    local u5 = Platform_Handler.mousepos(Config.MOUSE_RANGE);
    local u6, v7 = Utility.CreateAlignOrientationWithAttachment(HumanoidRootPart, "skill_look_at", {
        Responsiveness = 45,
        MaxTorque = 3000,
        AlignType = Enum.AlignType.PrimaryAxisParallel,
        CFrame = Utility.SafeLookAt(HumanoidRootPart.Position, u5, HumanoidRootPart.CFrame)
    });
    table.insert(u2, v7);
    task.spawn(function() -- Line: 66
        -- upvalues: Attachment (copy), HumanoidRootPart (copy), LinearVelocity (copy), Id (copy), u1 (ref), u5 (ref), Platform_Handler (ref), Config (ref), u6 (copy), Utility (ref)
        while Attachment ~= nil and (HumanoidRootPart and (LinearVelocity ~= nil and (Attachment.Parent == HumanoidRootPart and (LinearVelocity.Parent == Attachment and (Attachment.Name == "skill_stand_still" and Id == u1.Id))))) do
            u5 = Platform_Handler.mousepos(Config.MOUSE_RANGE);
            u6.CFrame = Utility.SafeLookAt(HumanoidRootPart.Position, u5, u6.CFrame);
            task.wait();
        end;
    end);
    u3 = Humanoid.Animator:LoadAnimation(script.Startup);
    u3:Play(nil, nil, Config.STARTUP_ANIM_SPEED);
    task.delay(Config.HOLD_FREEZE_AT, function() -- Line: 77
        -- upvalues: u1 (ref), Id2 (copy), u3 (ref)
        if u1.Id == Id2 then
            u3:AdjustSpeed(0);
        end;
    end);
end;

function u1.UnHold(p8: userdata) -- Line: 86
    -- upvalues: u3 (ref), Config (copy), u2 (copy)
    if u3 then
        if u3.TimePosition <= Config.HOLD_FREEZE_AT then
            u3.TimePosition = Config.HOLD_FREEZE_AT;
        end;

        u3:AdjustSpeed(1);
        u3 = nil;
    end;

    for _, v in pairs(u2) do
        v:Destroy();
    end;
end;

function u1.Cancel(p9) -- Line: 102
    -- upvalues: u3 (ref), u2 (copy)
    if u3 then
        u3:Stop();
        u3 = nil;
    end;

    for _, v in pairs(u2) do
        v:Destroy();
    end;
end;

return u1;
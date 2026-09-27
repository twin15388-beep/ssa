-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
game:GetService("TweenService");
game:GetService("CollectionService");
local CAM = ReplicatedStorage.CAM;
local Global = CAM.Global;
local Platform_Handler = require(CAM.Client.Controllers.Platform_Handler);
local ManuelCancel = require(Global.Subsets.Gameplay.ManuelCancel);
local u1 = require(game.ReplicatedStorage.Packages.cleanit).new();
local Utility = require(Global.Utility);
require(CAM.DebrisModule);
local Config = require(script.Parent.Config);
local u2 = {
    Id = 0
};
local u3 = {};
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;

function u2.Hold(p9: userdata) -- Line: 38
    -- upvalues: u3 (copy), u2 (copy), u6 (ref), Platform_Handler (copy), Config (copy), u4 (ref), u5 (ref), Utility (copy), u1 (copy), RunService (copy)
    local Character = p9.Character;

    if not Character then
        return;
    end;

    local Humanoid = Character:FindFirstChild("Humanoid");
    local RootPart = Humanoid.RootPart;

    if not RootPart then
        return;
    end;

    if not Humanoid then
        return;
    end;

    local Animator = Humanoid:FindFirstChild("Animator");

    if not Animator then
        return;
    end;

    u3.startClock = os.clock();
    local u10 = Animator:LoadAnimation(script.Activate);
    u10:Play();
    u3.activateAnimation = u10;
    local Id = u2.Id;
    u6 = script.Parent.Parent.Parent.holder.skill_stand_still:Clone();
    u6.Parent = RootPart;
    local u11 = Platform_Handler.mousepos(Config.MOUSE_RANGE);
    local v12, v13 = Utility.CreateAlignOrientationWithAttachment(RootPart, "skill_look_at", {
        Responsiveness = 75,
        MaxTorque = 3000,
        AlignType = Enum.AlignType.PrimaryAxisParallel,
        CFrame = Utility.SafeLookAt(RootPart.Position, u11, RootPart.CFrame)
    });
    u4 = v12;
    u5 = v13;
    u1:Connect(RunService.Heartbeat, function(p14: number) -- Line: 70
        -- upvalues: u11 (ref), Platform_Handler (ref), Config (ref), u4 (ref), Utility (ref), RootPart (copy)
        u11 = Platform_Handler.mousepos(Config.MOUSE_RANGE);
        u4.CFrame = Utility.SafeLookAt(RootPart.Position, u11, u4.CFrame);
    end);
    task.delay(Config.HOLD_FREEZE_AT, function() -- Line: 74
        -- upvalues: u2 (ref), Id (copy), u10 (copy)
        if u2.Id == Id then
            u10:AdjustSpeed(0);
        end;
    end);
    task.wait(Config.MIN_HOLD_DUR);
end;

function u2.UnHold(u15: userdata) -- Line: 82
    -- upvalues: u2 (copy), ManuelCancel (copy), Utility (copy), u3 (copy), u7 (ref), Config (copy), u8 (ref), u1 (copy), u6 (ref), u5 (ref)
    local Id = u2.Id;
    local Humanoid = u15.Character:FindFirstChild("Humanoid");

    if not Humanoid.RootPart then
        return;
    end;

    if not Humanoid then
        return;
    end;

    if not Humanoid:FindFirstChild("Animator") then
        return;
    end;

    local v16, _ = ManuelCancel.new(u15, 1.5);
    v16:Connect(function() -- Line: 99
        -- upvalues: Id (ref), u2 (ref), u15 (copy)
        Id = -1;
        u2.Cancel(u15);
    end);
    local valuesfolder = Utility.getvaluesfolder(u15);
    local _ = os.clock() - u3.startClock;
    u7 = Utility.AddValue(valuesfolder, "pause_gameplay", Config.RELEASE_LOCK_DURATION);
    u8 = Utility.AddValue(valuesfolder, "NR", Config.RELEASE_LOCK_DURATION);
    u1:Clean();
    u3.activateAnimation:AdjustSpeed(1);
    task.wait(Config.RELEASE_WAIT);

    if u6 ~= nil then
        u6:Destroy();
        u6 = nil;
    end;

    if u5 ~= nil then
        u5:Destroy();
        u5 = nil;
    end;

    if u8 ~= nil then
        u8:Destroy();
        u8 = nil;
    end;

    if u7 ~= nil then
        u7:Destroy();
        u8 = nil;
    end;
end;

function u2.Cancel(p17: userdata) -- Line: 131
    -- upvalues: u1 (copy), u6 (ref), u5 (ref), u8 (ref), u7 (ref), u3 (copy)
    u1:Clean();

    if u6 ~= nil then
        u6:Destroy();
        u6 = nil;
    end;

    if u5 ~= nil then
        u5:Destroy();
        u5 = nil;
    end;

    if u8 ~= nil then
        u8:Destroy();
        u8 = nil;
    end;

    if u7 ~= nil then
        u7:Destroy();
        u8 = nil;
    end;

    if u3.activateAnimation then
        u3.activateAnimation:Stop();
        u3.activateAnimation:Destroy();
    end;

    if u3.Release_Animation then
        u3.Release_Animation:Stop();
        u3.Release_Animation:Destroy();
    end;
end;

return u2;
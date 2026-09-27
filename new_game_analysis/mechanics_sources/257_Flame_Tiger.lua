-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local CAM = ReplicatedStorage.CAM;
local Global = CAM.Global;
local Platform_Handler = require(CAM.Client.Controllers.Platform_Handler);
local ManuelCancel = require(Global.Subsets.Gameplay.ManuelCancel);
local u1 = require(game.ReplicatedStorage.Packages.cleanit).new();
local Utility = require(Global.Utility);
local Config = require(script.Parent.Config);
local u2 = {
    Id = 0
};
local u3 = {};
Random.new();
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;

function u2.Hold(p9: userdata) -- Line: 36
    -- upvalues: u2 (copy), u3 (copy), u4 (ref), Platform_Handler (copy), Config (copy), u5 (ref), u6 (ref), Utility (copy), u1 (copy), RunService (copy)
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

    local Id = u2.Id;
    u3.startClock = os.clock();
    local v10 = Animator:LoadAnimation(script.Activate);
    v10:Play(nil, nil, 1.3);
    u3.activateAnimation = v10;
    u4 = script.Parent.Parent.Parent.holder.skill_stand_still:Clone();
    u4.Parent = RootPart;
    local u11 = Platform_Handler.mousepos(Config.MOUSE_RANGE);
    local v12, v13 = Utility.CreateAlignOrientationWithAttachment(RootPart, "skill_look_at", {
        Responsiveness = 75,
        MaxTorque = 3000,
        AlignType = Enum.AlignType.PrimaryAxisParallel,
        CFrame = Utility.SafeLookAt(RootPart.Position, u11, RootPart.CFrame)
    });
    u5 = v12;
    u6 = v13;
    local u14 = false;
    u1:Connect(RunService.Heartbeat, function(p15: number) -- Line: 66
        -- upvalues: u11 (ref), Platform_Handler (ref), Config (ref), u5 (ref), Utility (ref), RootPart (copy), u14 (ref), u4 (ref)
        u11 = Platform_Handler.mousepos(Config.MOUSE_RANGE);
        u5.CFrame = Utility.SafeLookAt(RootPart.Position, u11, u5.CFrame);

        if u14 then
            local LookVector = u5.CFrame.LookVector;
            local v16 = LookVector - vector.create(0, LookVector.Y, 0);
            u4.LinearVelocity.VectorVelocity = u4.LinearVelocity.VectorVelocity:Lerp(v16 * Config.HOLD_DRIFT_SPEED, 0.15);
        end;
    end);
    task.delay(Config.HOLD_DURATION, function() -- Line: 75
        -- upvalues: Id (copy), u2 (ref), u3 (ref), Animator (copy), Config (ref), u14 (ref)
        if Id ~= u2.Id then
            return;
        end;

        u3.activateAnimation:Stop();
        local v17 = Animator:LoadAnimation(script.Hold);
        u3.activateAnimation = v17;
        v17:Play(nil, nil, Config.HOLD_ANIM_SPEED);
        u14 = true;
        task.wait(Config.GAP_START);

        if Id ~= u2.Id then
            return;
        end;

        v17:AdjustSpeed(Config.GAP_ANIM_SPEED);
        task.wait(Config.GAP_END - Config.GAP_START);

        if Id ~= u2.Id then
            return;
        end;

        v17:AdjustSpeed(Config.HOLD_ANIM_SPEED);
    end);
end;

function u2.UnHold(u18: userdata, p19: any) -- Line: 91
    -- upvalues: u2 (copy), ManuelCancel (copy), Utility (copy), u3 (copy), u7 (ref), Config (copy), u8 (ref), u4 (ref), u1 (copy), u5 (ref), TweenService (copy), u6 (ref)
    local Id = u2.Id;
    local Humanoid = u18.Character:FindFirstChild("Humanoid");
    local RootPart = Humanoid.RootPart;

    if not RootPart then
        return;
    end;

    if not Humanoid then
        return;
    end;

    if not Humanoid:FindFirstChild("Animator") then
        return;
    end;

    ManuelCancel.new(u18, 3):Connect(function() -- Line: 108
        -- upvalues: Id (ref), u2 (ref), u18 (copy)
        Id = -1;
        u2.Cancel(u18);
    end);
    local valuesfolder = Utility.getvaluesfolder(u18);
    local v20 = os.clock() - u3.startClock;
    u7 = Utility.AddValue(valuesfolder, "pause_gameplay", Config.RELEASE_LOCK_DURATION);
    u8 = Utility.AddValue(valuesfolder, "NR", Config.RELEASE_LOCK_DURATION);
    local v21 = u4;

    if v20 < Config.HOLD_DURATION then
        u1:Clean();
        u3.activateAnimation.TimePosition = Config.HOLD_DURATION;
        local CFrame_lookAt_ret = CFrame.lookAt(RootPart.Position, (vector.create(p19.X, RootPart.Position.Y, p19.Z)));
        u5.CFrame = CFrame_lookAt_ret;
        task.wait(Config.TAP_DASH_DELAY);

        if v21 ~= nil and v21.Parent ~= nil then
            v21.LinearVelocity.VectorVelocity = CFrame_lookAt_ret.LookVector * Config.TAP_DASH_SPEED;
            TweenService:Create(v21.LinearVelocity, TweenInfo.new(Config.TAP_DASH_DECAY), {
                VectorVelocity = Vector3.new(0, 0, 0)
            }):Play();
            task.wait(Config.TAP_DASH_DECAY);
        end;
    else
        u1:Clean();
        u3.activateAnimation:Stop(0.25);

        if v21 ~= nil and v21.Parent ~= nil then
            TweenService:Create(v21.LinearVelocity, TweenInfo.new(Config.HELD_RELEASE_DECAY), {
                VectorVelocity = Vector3.new(0, 0, 0)
            }):Play();
            task.wait(Config.HELD_RELEASE_DECAY);
        end;
    end;

    if u6 ~= nil then
        u6:Destroy();
        u6 = nil;
    end;

    if u4 ~= nil then
        u4:Destroy();
        u4 = nil;
    end;

    if u8 ~= nil then
        u8:Destroy();
        u8 = nil;
    end;

    if u7 ~= nil then
        u7:Destroy();
        u7 = nil;
    end;
end;

function u2.Cancel(p22: userdata) -- Line: 164
    -- upvalues: u1 (copy), u4 (ref), u6 (ref), u3 (copy), u8 (ref), u7 (ref)
    u1:Clean();

    if u4 ~= nil then
        u4:Destroy();
        u4 = nil;
    end;

    if u6 ~= nil then
        u6:Destroy();
        u6 = nil;
    end;

    if u3.activateAnimation then
        u3.activateAnimation:Stop();
        u3.activateAnimation:Destroy();
    end;

    if u8 ~= nil then
        u8:Destroy();
        u8 = nil;
    end;

    if u7 ~= nil then
        u7:Destroy();
        u7 = nil;
    end;
end;

return u2;
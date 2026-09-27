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
local SkillAimMarker = require(Client.Modules.Effects.SkillAimMarker);
local RaycastHelper = require(Global.RaycastHelper);
local ManuelCancel = require(Global.Subsets.Gameplay.ManuelCancel);
local Config = require(script.Parent.Config);
local u2 = {
    Id = 0
};
local u3 = {
    aimMarker = nil,
    startupTrack = nil,
    released = false
};
local skill_stand_still = Skills.holder.skill_stand_still;
local script_DemonCore = script.DemonCore;

local function updateAim(p4: userdata, p5: userdata, p6: userdata?) -- Line: 38
    -- upvalues: Platform_Handler (copy), RaycastHelper (copy), Config (copy), Utility (copy), u3 (copy)
    local v7 = Platform_Handler.mousepos();
    local v8, _, _, v9 = RaycastHelper.MaximizeRayClient(p5.Position, v7, Config.MOUSE_RANGE, true, 3);
    local v10 = v8 or v7;
    local v11;

    if v9 then
        v11 = v9:GetPivot().Position;
    else
        v11 = v10;
    end;

    if p6 then
        p6.CFrame = Utility.SafeLookAt(p5.Position, v11, p6.CFrame);
    else
        p5.CFrame = Utility.SafeLookAt(p5.Position, v11, p5.CFrame);
    end;

    local v12 = p4:FindFirstChild(Config.POS_PART_NAME);

    if v12 then
        v12.Position = v10;
        v12.bp.Position = v10;
    end;

    if u3.aimMarker then
        u3.aimMarker:Update({
            position = v10,
            target = v9
        });
    end;

    return v10, v9;
end;

function u2.Hold(p13: userdata) -- Line: 68
    -- upvalues: u1 (copy), u3 (copy), u2 (copy), script_DemonCore (copy), Config (copy), skill_stand_still (copy), Utility (copy), SkillAimMarker (copy), updateAim (copy), RunService (copy)
    u1:Clean();

    if u3.startupTrack ~= nil then
        u3.startupTrack:Stop(0);
        u3.startupTrack:Destroy();
        u3.startupTrack = nil;
    end;

    u3.released = false;
    local Character = p13.Character;
    local Humanoid = Character:FindFirstChild("Humanoid");
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
    local Animator = Humanoid:FindFirstChild("Animator");
    local Id = u2.Id;
    u3.startupTrack = Animator:LoadAnimation(script_DemonCore);
    u3.startupTrack:Play();
    u3.startupTrack:AdjustSpeed(Config.STARTUP_SPEED);
    local v14 = skill_stand_still:Clone();
    v14.LinearVelocity.VectorVelocity = Vector3.new(0, 0, 0);
    v14.Parent = HumanoidRootPart;
    u1:Add(v14);
    local valuesfolder = Utility.getvaluesfolder(Character);
    u1:Add(Utility.AddValue(valuesfolder, "NR", 6));
    u3.aimMarker = SkillAimMarker.new({
        Dot = true,
        Highlight = true
    });
    u1:Add(u3.aimMarker);
    local v15, v16 = updateAim(Character, HumanoidRootPart);
    local CreateAlignOrientationWithAttachment = Utility.CreateAlignOrientationWithAttachment;
    local v17 = {
        Responsiveness = 70,
        MaxTorque = 500000
    };

    if v16 and v16.PrimaryPart then
        v15 = v16.PrimaryPart.Position or v15;
    end;

    v17.CFrame = CFrame.lookAt(HumanoidRootPart.Position, v15);
    local u18, v19 = CreateAlignOrientationWithAttachment(HumanoidRootPart, "skill_look_at", v17);
    u1:Add(v19);
    u1:Add(u18);
    u1:Connect(RunService.PostSimulation, function() -- Line: 119
        -- upvalues: updateAim (ref), Character (copy), HumanoidRootPart (copy), u18 (copy)
        updateAim(Character, HumanoidRootPart, u18);
    end);
    local v20 = Config.FREEZE_MARK / Config.STARTUP_SPEED;
    task.wait(v20);
    task.delay(v20, function() -- Line: 125
        -- upvalues: u2 (ref), Id (copy), u3 (ref)
        if u2.Id ~= Id then
            return;
        end;

        u3.startupTrack:AdjustSpeed(0);
    end);
end;

function u2.UnHold(u21: userdata) -- Line: 131
    -- upvalues: u2 (copy), u3 (copy), Config (copy), ManuelCancel (copy), Utility (copy), u1 (copy), RunService (copy), updateAim (copy)
    local Id = u2.Id;
    u3.released = true;

    if u3.startupTrack then
        if u3.startupTrack.TimePosition < 0.74 then
            u3.startupTrack.TimePosition = 0.74;
        end;

        u3.startupTrack:AdjustSpeed(Config.STARTUP_SPEED);
    end;

    local RELEASE_DELAY = Config.RELEASE_DELAY;
    local v22, v23 = ManuelCancel.new(u21, RELEASE_DELAY);
    v22:Connect(function() -- Line: 145
        -- upvalues: u2 (ref), u3 (ref), u21 (copy)
        u2.Id = -1;

        if u3.startupTrack then
            u3.startupTrack:Stop();
            u3.startupTrack:Destroy();
            u3.startupTrack = nil;
        end;

        u2.Cancel(u21);
    end);
    task.wait(RELEASE_DELAY);

    if u2.Id ~= Id then
        return;
    end;

    u2.Cancel(u21);
    v23();
    local Character = u21.Character;
    local u24;

    if Character then
        u24 = Character:FindFirstChild("HumanoidRootPart");
    else
        u24 = Character;
    end;

    if u24 == nil then
        return;
    end;

    local u25, u26 = Utility.CreateAlignOrientationWithAttachment(u24, "skill_look_at", {
        Responsiveness = 70,
        MaxTorque = 500000,
        CFrame = u24.CFrame
    });
    u1:Add(u26);
    game:GetService("Debris"):AddItem(u26, Config.BARRAGE_AIM_DURATION);
    local u27 = nil;
    u27 = RunService.PostSimulation:Connect(function() -- Line: 185
        -- upvalues: u2 (ref), Id (copy), u26 (copy), u27 (ref), updateAim (ref), Character (copy), u24 (copy), u25 (copy)
        if u2.Id == Id and u26.Parent ~= nil then
            updateAim(Character, u24, u25);

            return;
        end;

        u27:Disconnect();
    end);
    u1:Add(function() -- Line: 193
        -- upvalues: u27 (ref)
        u27:Disconnect();
    end);
end;

function u2.Cancel(p28: userdata) -- Line: 198
    -- upvalues: u3 (copy), u1 (copy)
    if u3.startupTrack ~= nil and not u3.released then
        u3.startupTrack:Stop(0);
        u3.startupTrack:Destroy();
        u3.startupTrack = nil;
    end;

    u1:Clean();
    local HumanoidRootPart = p28.Character:FindFirstChild("HumanoidRootPart");
    HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
    HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
end;

return u2;
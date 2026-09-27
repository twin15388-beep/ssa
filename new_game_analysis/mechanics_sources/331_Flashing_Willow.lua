-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local CAM = ReplicatedStorage.CAM;
local Client = CAM.Client;
local Global = CAM.Global;
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
    startupTrack = nil,
    aimMarker = nil,
    mover = nil
};
local script_FlashingWillowGroundVariant = script.FlashingWillowGroundVariant;

local function updateAim(p4: userdata, p5: userdata, p6: userdata?) -- Line: 34
    -- upvalues: Platform_Handler (copy), Config (copy), RaycastHelper (copy), Utility (copy), u3 (copy)
    local v7 = Platform_Handler.mousepos();
    local math_min_ret = math.min(Config.MOUSE_RANGE, (v7 - p5.Position).Magnitude);
    local v8, v9 = RaycastHelper.MaximizeRayClient(p5.Position, v7, math_min_ret, false, 3);

    if not v9 then
        v8, v9 = RaycastHelper.MaximizeRayClient(p5.Position, v7, math_min_ret, false, 3, 18, nil, RaycastHelper.Crater);

        if not v9 then
            return v7;
        end;
    end;

    local v10 = v8 or v7;

    if p6 then
        p6.CFrame = Utility.SafeLookAt(p5.Position, v10, p6.CFrame);
    else
        p5.CFrame = Utility.SafeLookAt(p5.Position, v10, p5.CFrame);
    end;

    local v11 = p4:FindFirstChild(Config.POS_PART_NAME);

    if v11 then
        v11.CFrame = CFrame.lookAt(v10, v10 + v9.Unit);
        v11.bp.Position = v10;
    end;

    if u3.aimMarker then
        u3.aimMarker:Update({
            position = v10
        });
    end;

    return v10;
end;

function u2.Hold(p12: userdata) -- Line: 69
    -- upvalues: u1 (copy), u2 (copy), u3 (copy), script_FlashingWillowGroundVariant (copy), Utility (copy), SkillAimMarker (copy), updateAim (copy), RunService (copy), Config (copy)
    u1:Clean();
    local Character = p12.Character;
    local v13;

    if Character then
        v13 = Character:FindFirstChild("Humanoid");
    else
        v13 = Character;
    end;

    local u14;

    if v13 then
        u14 = v13.RootPart;
    else
        u14 = v13;
    end;

    if v13 then
        v13 = v13:FindFirstChild("Animator");
    end;

    local Id = u2.Id;
    u3.startupTrack = v13:LoadAnimation(script_FlashingWillowGroundVariant);
    u1:Add(u3.startupTrack);
    u3.startupTrack:Play();
    local valuesfolder = Utility.getvaluesfolder(Character);
    u1:Add(Utility.AddValue(valuesfolder, "NR", 5));
    u1:Add(Utility.AddValue(valuesfolder, "pause_gameplay", 5));
    u1:Add(Utility.AddValue(valuesfolder, "skill_stand_still", 5));
    u3.aimMarker = SkillAimMarker.new({
        Dot = true
    });
    u1:Add(u3.aimMarker);
    local v15 = updateAim(Character, u14);
    local u16, v17 = Utility.CreateAlignOrientationWithAttachment(u14, "skill_look_at", {
        Responsiveness = 70,
        MaxTorque = 500000,
        CFrame = Utility.SafeLookAt(u14.Position, v15, u14.CFrame)
    });
    u1:Add(v17);
    u1:Add(u16);
    u1:Connect(RunService.PostSimulation, function() -- Line: 106
        -- upvalues: updateAim (ref), Character (copy), u14 (copy), u16 (copy)
        updateAim(Character, u14, u16);
    end);
    task.wait(Config.FREEZE_MARK);

    if u2.Id ~= Id then
        return;
    end;

    u3.startupTrack:AdjustSpeed(0);
end;

local Players = game:GetService("Players");
local valuesfolder = Utility.getvaluesfolder(Players.LocalPlayer, true);

function u2.UnHold(u18: userdata) -- Line: 117
    -- upvalues: u2 (copy), u3 (copy), Config (copy), u1 (copy), Utility (copy), valuesfolder (copy), ManuelCancel (copy)
    local Id = u2.Id;

    if u3.startupTrack then
        u3.startupTrack:AdjustSpeed(1);
    end;

    u3.aimMarker:Destroy();
    u3.aimMarker = nil;
    local RELEASE_DELAY = Config.RELEASE_DELAY;
    u1:Add(Utility.AddValue(valuesfolder, "NR", RELEASE_DELAY));
    local v19, v20 = ManuelCancel.new(u18, RELEASE_DELAY);
    v19:Connect(function() -- Line: 130
        -- upvalues: u2 (ref), u18 (copy)
        u2.Id = -1;
        u2.Cancel(u18);
    end);
    task.wait(RELEASE_DELAY);

    if u2.Id ~= Id then
        return;
    end;

    v20();
    u2.Cancel(u18);
end;

function u2.Cancel(p21: userdata) -- Line: 141
    -- upvalues: u1 (copy)
    u1:Clean();
    local HumanoidRootPart = p21.Character:FindFirstChild("HumanoidRootPart");
    HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
    HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
end;

return u2;
-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local CAM = ReplicatedStorage.CAM;
local SAM = ServerStorage.SAM;
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);
local Checker = require(CAM.Global.Checker);
local Utility = require(CAM.Global.Utility);
local CharGrabPosCorrector = require(CAM.Global.Subsets.Gameplay.CharGrabPosCorrector);
local Combat_Util = require(SAM.Services.Combat_Util);
local u1 = require(SAM.Game_Play.hit_priority_handler).new(script);
local cleanit = require(ReplicatedStorage.Packages.cleanit);
local Config = require(script.Parent.Config);
local u2 = {
    Id = {}
};
local Name = script.Parent.Name;

function u2.Hold(p3: userdata, p4: vector?, p5: table) -- Line: 38
    -- upvalues: cleanit (copy), u2 (copy), Utility (copy), Config (copy), EffectsEvent (copy), Checker (copy), u1 (copy), Combat_Util (copy), CharGrabPosCorrector (copy), Name (copy)
    local v6 = p5.CleanIt or cleanit.new();
    p5.CleanIt = v6;
    v6:Clean();
    local v7 = u2.Id[p3.UserId];
    local Character = p3.Character;
    local Animator = Character.Humanoid.Animator;
    local HumanoidRootPart = Character.HumanoidRootPart;
    local valuesfolder = Utility.getvaluesfolder(Character);
    v6:Add(Utility.AddValue(valuesfolder, "pause_gameplay", 1.25));
    v6:Add(Utility.AddValue(valuesfolder, "iframe", 1.25));
    v6:Add(Utility.AddValue(valuesfolder, "WalkSpeed", 1.25, "NumberValue", Config.WALK_SPEED));
    EffectsEvent.ToAllInRange(HumanoidRootPart, "GauntletInit", Character);
    task.wait(0.6833333333333333);

    if u2.Id[p3.UserId] ~= v7 then
        return;
    end;

    local CFrame = HumanoidRootPart.CFrame;
    EffectsEvent.ToAllInRange(HumanoidRootPart, "Shoulder Throw VFX", Character, "Grab", CFrame);
    local u8 = {};
    Utility.CreateHitbox({
        caster = Character,
        hitboxCFrame = CFrame * Config.GRAB_HITBOX_OFFSET,
        hitboxSize = Config.GRAB_HITBOX_SIZE,
        checker = Checker,
        hitPriorityHandler = {
            data = "Choosing_1",
            callback = u1.Exists
        },

        hitDetected = function(p9: userdata, p10: userdata, p11: any) -- Line: 72, Name: hitDetected
            -- upvalues: Combat_Util (ref), Character (copy), u8 (copy)
            local Humanoid = p9:FindFirstChild("Humanoid");
            local HumanoidRootPart2 = p9:FindFirstChild("HumanoidRootPart");

            if Humanoid == nil or HumanoidRootPart2 == nil then
                return;
            end;

            if p11 == "Perfect" then
                Combat_Util.Perfect(script, Character, p9);

                return;
            end;

            if p11 == true or p11 == "Blocking" then
                local v12 = {
                    model = p9,
                    values = p10,
                    root = HumanoidRootPart2,
                    animator = Humanoid:FindFirstChild("Animator")
                };
                table.insert(u8, v12);
            end;
        end
    });

    if #u8 == 0 then
        task.wait(0.5666666666666667);

        if u2.Id[p3.UserId] ~= v7 then
            return;
        end;

        v6:Clean();

        return;
    end;

    v6:Add(Utility.AddValue(valuesfolder, "skill_stand_still", 0.5833333333333334));
    v6:Add(Utility.AddValue(valuesfolder, "NR", 0.5833333333333334));
    v6:Add(Utility.lock(HumanoidRootPart, CFrame, 0.5833333333333334));

    for _, v in u8 do
        v6:Add(Utility.AddValue(v.values, "iframe", 0.5833333333333334, "StringValue", Character.Name));
        v6:Add(Utility.AddValue(v.values, "pause_gameplay", 0.5833333333333334));
        v6:Add(Utility.AddValue(v.values, "skill_stand_still", 0.5833333333333334));
        v6:Add(Utility.AddValue(v.values, "NR", 0.5833333333333334));
        v6:Add(Utility.lock(v.root, CFrame, 0.55));

        if v.animator and (v.animator.Parent ~= nil and v.model.Parent ~= nil) then
            local v13 = v.animator:LoadAnimation(script.ShoulderThrowVictim);
            v6:Add(v13);
            v13:Play();
            CharGrabPosCorrector.Do(v.model, v13, 0.6333333333333334, Character);
        end;
    end;

    local v14 = Animator:LoadAnimation(script.ShoulderThrowUser);
    v6:Add(v14);
    v14:Play();
    task.wait(0.5833333333333334);

    if u2.Id[p3.UserId] ~= v7 then
        return;
    end;

    EffectsEvent.ToAllInRange(HumanoidRootPart, "Shoulder Throw VFX", Character, "Throw", CFrame);
    task.wait();

    if u2.Id[p3.UserId] ~= v7 then
        return;
    end;

    for _, v in u8 do
        if Checker.check_victim(script, Character, v.model) ~= nil then
            Combat_Util.Damage(script, Character, v.model, {
                Base = Config.SLAM_DAMAGE,
                Skill = Name
            });
            Combat_Util.AddStun(script, Character, v.values, Config.SLAM_STUN);
            Combat_Util.RagDoll(script, Character, v.values, Config.RAGDOLL_DURATION);
            Combat_Util.Knockback(script, Character, v.root, CFrame.LookVector * Config.SLAM_FORWARD + Vector3.new(0, -Config.SLAM_DOWNWARD, 0), 0.2);
        end;
    end;

    task.wait(0.8);

    if u2.Id[p3.UserId] ~= v7 then
        return;
    end;

    v6:Clean();
end;

function u2.UnHold(p15: userdata, p16: vector?, p17: table) -- Line: 156
end;

function u2.Cancel(p18: userdata, p19: vector?, p20: table) -- Line: 158
    -- upvalues: cleanit (copy), EffectsEvent (copy)
    local v21 = p20.CleanIt or cleanit.new();
    p20.CleanIt = v21;
    local Character = p18.Character;
    local v22;

    if Character then
        v22 = Character:FindFirstChild("HumanoidRootPart");
    else
        v22 = Character;
    end;

    if v22 and Character then
        EffectsEvent.ToAllInRange(v22, "Shoulder Throw VFX", Character, "Cancel");
    end;

    v21:Clean();
end;

return u2;
-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local CAM = ReplicatedStorage.CAM;
local SAM = ServerStorage.SAM;
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);
local ManuelCancel = require(CAM.Global.Subsets.Gameplay.ManuelCancel);
local Checker = require(CAM.Global.Checker);
local Utility = require(CAM.Global.Utility);
local Combat_presets = require(CAM.Global.Combat_presets);
local Combat_Util = require(SAM.Services.Combat_Util);
local u1 = require(SAM.Game_Play.hit_priority_handler).new(script);
local Config = require(script.Parent.Config);
local u2 = {
    Id = {}
};

local function spawnBarrageWave(u3: userdata, u4: userdata, u5: vector, p6: userdata?) -- Line: 24
    -- upvalues: Utility (copy), Config (copy), Checker (copy), u1 (copy), Combat_Util (copy), EffectsEvent (copy), Combat_presets (copy)
    local u7 = {};
    local v8 = CFrame.lookAt(u4.Position, u4.Position + u5) * CFrame.new(0, 0, -6.5);
    Utility.CreateHitbox({
        caster = u3,
        hitboxCFrame = v8,
        hitboxSize = Config.BARRAGE_HITBOX_SIZE,
        targets = p6,
        checker = Checker,
        hitPriorityHandler = {
            data = "Choosing_1",
            callback = u1.Exists
        },

        hitDetected = function(p9: userdata, p10: userdata, p11: any) -- Line: 35, Name: hitDetected
            -- upvalues: u7 (copy), Combat_Util (ref), u3 (copy), EffectsEvent (ref), u4 (copy), Config (ref), u5 (copy), Combat_presets (ref)
            if u7[p9] then
                return;
            end;

            u7[p9] = true;
            local Humanoid = p9:FindFirstChild("Humanoid");
            local v12;

            if Humanoid then
                v12 = Humanoid.RootPart;
            else
                v12 = Humanoid;
            end;

            if p11 == "Perfect" then
                Combat_Util.Perfect(script, u3, p9);

                return;
            end;

            if p11 == "Blocking" then
                Combat_Util.Block(script, u3, p9, 0.25);

                return;
            end;

            if p11 == true then
                EffectsEvent.ToAllInRange(u4, "Normal_Punch_Effect", v12, -1);
                Combat_Util.Damage(script, u3, p9, {
                    Base = Config.BARRAGE_DAMAGE,
                    Skill = script.Parent.Name
                });
                Combat_Util.AddStun(script, u3, p10, Config.BARRAGE_STUN);
                Combat_Util.Knockback(script, u3, v12, u5 * Config.BARRAGE_KNOCKBACK + Vector3.new(0, 0.1, 0), 0.5);
                Combat_presets.PlayReactAnim(Humanoid);
            end;
        end
    });
    EffectsEvent.ToAllInRange(u4, "Explosive Fury VFX", u3, "Wave", u5, false);
end;

local function spawnFinisherWave(u13: userdata, u14: userdata, u15: table, u16) -- Line: 59
    -- upvalues: Utility (copy), Config (copy), Checker (copy), u1 (copy), Combat_Util (copy), EffectsEvent (copy)
    Utility.CreateHitbox({
        caster = u13,
        hitboxCFrame = u16,
        hitboxSize = Config.BARRAGE_FINISH_HITBOX_SIZE,
        checker = Checker,
        hitPriorityHandler = {
            data = "Choosing_1",
            callback = u1.Exists
        },

        hitDetected = function(p17: userdata, p18: userdata, p19: any) -- Line: 67, Name: hitDetected
            -- upvalues: u15 (copy), Combat_Util (ref), u13 (copy), EffectsEvent (ref), u14 (copy), Config (ref), u16 (copy)
            if u15[p17] then
                return;
            end;

            u15[p17] = true;
            local Humanoid = p17:FindFirstChild("Humanoid");

            if Humanoid then
                Humanoid = Humanoid.RootPart;
            end;

            if p19 == "Perfect" then
                Combat_Util.Perfect(script, u13, p17);

                return;
            end;

            if p19 == "Blocking" then
                Combat_Util.Block(script, u13, p17, 1);

                return;
            end;

            if p19 == true then
                EffectsEvent.ToAllInRange(u14, "Normal_Punch_Effect", Humanoid, -1);
                Combat_Util.Damage(script, u13, p17, {
                    Base = Config.BARRAGE_FINISH_DAMAGE,
                    Skill = script.Parent.Name
                });
                Combat_Util.AddStun(script, u13, p18, Config.BARRAGE_FINISH_STUN);
                Combat_Util.Knockback(script, u13, Humanoid, u16.lookVector * Config.BARRAGE_FINISH_KNOCKBACK, 0.15);
                Combat_Util.RagDoll(script, u13, p18, 1.5);
            end;
        end
    });
end;

function u2.Hold(p20: userdata, p21: vector, p22: table) -- Line: 89
    -- upvalues: u2 (copy), EffectsEvent (copy), Config (copy), Utility (copy)
    local Character = p20.Character;
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
    local v23 = u2.Id[p20.UserId];
    EffectsEvent.ToAllInRange(HumanoidRootPart, "Explosive Fury VFX", Character, "Start", HumanoidRootPart.CFrame);
    local v24 = `{p20.Name}-{script.Parent.Name}-{math.random(1, 99)}`;
    task.wait(Config.PROBE_START_AT);

    if u2.Id[p20.UserId] ~= v23 then
        return;
    end;

    p22.probeVictim = nil;

    while u2.Id[p20.UserId] == v23 do
        local v25 = Utility.SinglePartHitbox({
            Caster = Character,
            ParamsName = v24,
            Origin = HumanoidRootPart.CFrame * CFrame.new(Config.FRONT_STOP_OFFSET),
            BoxSize = Config.FRONT_STOP_SIZE
        });

        if v25 then
            p22.probeVictim = Utility.find_character_from_descendant(v25);
            EffectsEvent.ToClient(p20, "force_skill_actions_server", script.Parent.Name, "UnHold", nil);
        end;

        task.wait(0.1);
    end;
end;

function u2.UnHold(u26: userdata, u27: vector, u28: table) -- Line: 128
    -- upvalues: Utility (copy), u2 (copy), Config (copy), ManuelCancel (copy), Combat_Util (copy), EffectsEvent (copy), spawnBarrageWave (copy), spawnFinisherWave (copy)
    local Character = u26.Character;
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
    local valuesfolder = Utility.getvaluesfolder(Character);
    local v29 = u2.Id[u26.UserId];
    local v30 = 1.15 / Config.BARRAGE_HIT_COUNT;
    local v31, v32 = ManuelCancel.new(u26, 1.75);
    v31:Connect(function() -- Line: 142
        -- upvalues: u2 (ref), u26 (copy), u27 (copy), u28 (copy)
        u2.Id[u26.UserId] = -1;
        u2.Cancel(u26, u27, u28);
    end);
    u28.airHold = Combat_Util.Add_air_combo_bp(HumanoidRootPart, nil, 0, nil, 1.75);

    if valuesfolder then
        Utility.AddValue(valuesfolder, "skill_stand_still", 1.75);
        Utility.AddValue(valuesfolder, "pause_gameplay", 1.75);
        Utility.AddValue(valuesfolder, "NR", 1.75);
    end;

    local function currentDirection() -- Line: 160
        -- upvalues: HumanoidRootPart (copy), u27 (copy)
        local v33 = HumanoidRootPart.CFrame.LookVector * Vector3.new(1, 0, 1);

        if v33.Magnitude >= 0.01 then
            return v33.Unit;
        end;

        local v34 = (u27 - HumanoidRootPart.Position) * Vector3.new(1, 0, 1);

        if v34.Magnitude < 0.01 then
            return HumanoidRootPart.CFrame.LookVector;
        end;

        return v34.Unit;
    end;

    EffectsEvent.ToAllInRange(HumanoidRootPart, "Explosive Fury VFX", Character, "Fury");
    task.wait(0.1);

    if u2.Id[u26.UserId] ~= v29 then
        return;
    end;

    for i = 1, Config.BARRAGE_HIT_COUNT do
        if u2.Id[u26.UserId] ~= v29 then
            return;
        end;

        local v35 = HumanoidRootPart.CFrame.LookVector * Vector3.new(1, 0, 1);
        local v36;

        if v35.Magnitude >= 0.01 then
            v36 = v35.Unit;
        else
            local v37 = (u27 - HumanoidRootPart.Position) * Vector3.new(1, 0, 1);

            if v37.Magnitude < 0.01 then
                v36 = HumanoidRootPart.CFrame.LookVector;
            else
                v36 = v37.Unit;
            end;
        end;

        local v38;

        if i == 1 then
            v38 = u28.probeVictim;
        else
            v38 = nil;
        end;

        spawnBarrageWave(Character, HumanoidRootPart, v36, v38);
        local v39;

        if i < Config.BARRAGE_HIT_COUNT then
            task.wait(v30);
            v39 = i;
        else
            v39 = i;
        end;
    end;

    task.wait(0.10000000000000009);

    if u2.Id[u26.UserId] ~= v29 then
        return;
    end;

    local v40 = {};
    local v41 = HumanoidRootPart.CFrame.LookVector * Vector3.new(1, 0, 1);
    local v42;

    if v41.Magnitude >= 0.01 then
        v42 = v41.Unit;
    else
        local v43 = (u27 - HumanoidRootPart.Position) * Vector3.new(1, 0, 1);

        if v43.Magnitude < 0.01 then
            v42 = HumanoidRootPart.CFrame.LookVector;
        else
            v42 = v43.Unit;
        end;
    end;

    EffectsEvent.ToAllInRange(HumanoidRootPart, "Explosive Fury VFX", Character, "Wave", v42, true);
    local CFrame_lookAt_ret = CFrame.lookAt(HumanoidRootPart.Position, HumanoidRootPart.Position + v42);
    local Z = Config.BARRAGE_FINISH_HITBOX_SIZE.Z;

    for i = 0, 2 do
        if u2.Id[u26.UserId] ~= v29 then
            return;
        end;

        spawnFinisherWave(Character, HumanoidRootPart, v40, CFrame_lookAt_ret * CFrame.new(0, 0, -Z * i - 5));
        task.wait(0.19999999999999996);
        local _ = i;
    end;

    if u2.Id[u26.UserId] ~= v29 then
        return;
    end;

    v32();

    if u28.airHold then
        u28.airHold:Destroy();
        u28.airHold = nil;
    end;
end;

function u2.Cancel(p44: userdata, p45: vector?, p46: table) -- Line: 216
    -- upvalues: EffectsEvent (copy)
    EffectsEvent.ToAllInRange(p44, "Explosive Fury VFX", p44.Character, "Cancel");

    if p46.airHold then
        p46.airHold:Destroy();
        p46.airHold = nil;
    end;

    if p46.aimAttachment then
        p46.aimAttachment:Destroy();
        p46.aimAttachment = nil;
    end;
end;

return u2;
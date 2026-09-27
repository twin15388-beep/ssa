-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local ReplicatedStorage2 = game:GetService("ReplicatedStorage");
game:GetService("CollectionService");
local EffectsEvent = require(ReplicatedStorage2.Communication.ServerAndClient.Effects.EffectsEvent);
local CAM = ReplicatedStorage.CAM;
local SAM = ServerStorage.SAM;
local Checker = require(CAM.Global.Checker);
local Utility = require(CAM.Global.Utility);
local Combat_presets = require(CAM.Global.Combat_presets);
require(CAM.DebrisModule);
require(SAM.Utility.SkillStorage);
local Combat_Util = require(SAM.Services.Combat_Util);
local ImpactSounds = require(SAM.Utility.ImpactSounds);
local u1 = require(SAM.Game_Play.hit_priority_handler).new(script);
local Config = require(script.Parent.Config);
local _ = script;
local u2 = {
    Id = {}
};

function u2.Hold(u3: userdata, p4: vector, p5: table) -- Line: 41
    -- upvalues: u2 (copy), EffectsEvent (copy), Config (copy), Utility (copy), Checker (copy), u1 (copy), Combat_Util (copy), Combat_presets (copy), ImpactSounds (copy)
    local Character = u3.Character;
    local RootPart = Character:FindFirstChild("Humanoid").RootPart;
    local v6 = u2.Id[u3.UserId];
    EffectsEvent.ToAllInRange(u3, "Seismic BurstVFX", Character, "Start");
    task.wait(Config.SLICE1_AT);

    if u2.Id[u3.UserId] ~= v6 then
        return;
    end;

    EffectsEvent.ToAllInRange(u3, "StoneConquestVFX", u3.Character, "Slice1");
    local u7 = {};
    Utility.CreateHitbox({
        caster = Character,
        hitboxCFrame = RootPart.CFrame * Config.SLICE1_HITBOX_OFFSET,
        hitboxSize = Config.SLICE1_HITBOX_SIZE,
        checker = Checker,
        hitPriorityHandler = {
            data = "Choosing_1",
            callback = u1.Exists
        },

        hitDetected = function(p8: userdata, p9: any, p10: any) -- Line: 60, Name: hitDetected
            -- upvalues: Combat_Util (ref), Character (copy), Config (ref), RootPart (copy), u7 (copy), EffectsEvent (ref), u3 (copy), Combat_presets (ref)
            if p8 then
                local Humanoid = p8:FindFirstChild("Humanoid");
                local RootPart2 = Humanoid.RootPart;

                if p10 == "Blocking" then
                    Combat_Util.Block(script, Character, p8, Config.HIT_BLOCK_BREAK);
                    Combat_Util.Knockback(script, Character, RootPart2, RootPart.CFrame.lookVector * Config.HIT_BLOCK_KNOCKBACK, 0.2);

                    return;
                end;

                if p10 == "Perfect" then
                    Combat_Util.Perfect(script, Character, p8);

                    return;
                end;

                if p10 == true then
                    if table.find(u7, p8) == nil then
                        table.insert(u7, p8);
                    end;

                    local v11 = RootPart.CFrame.LookVector * Config.HIT_KNOCKBACK + vector.create(0, Config.HIT_KNOCKUP, 0);
                    EffectsEvent.ToAllInRange(u3, "Normal_Sword_Slash_Effect", RootPart2, -1);
                    Combat_Util.AddStun(script, Character, p9, Config.HIT_STUN);
                    Combat_Util.Damage(script, Character, p8, {
                        Base = Config.HIT_DAMAGE,
                        Skill = script.Parent.Name
                    });
                    Combat_Util.Knockback(script, Character, RootPart2, v11, Config.HIT_KNOCKBACK_DURATION);
                    Combat_presets.PlayReactAnim(Humanoid);
                end;
            end;
        end,

        After = function(p12, p13) -- Line: 84, Name: After
            -- upvalues: ImpactSounds (ref), Character (copy)
            if p12 then
                ImpactSounds.Play(Character, script.Parent.Name, p13[1]);
            end;
        end
    });
    task.wait(Config.SLICE2_AT - Config.SLICE1_AT);

    if u2.Id[u3.UserId] ~= v6 then
        return;
    end;

    EffectsEvent.ToAllInRange(u3, "StoneConquestVFX", u3.Character, "Slice2");
    Utility.CreateHitbox({
        caster = Character,
        hitboxCFrame = RootPart.CFrame * Config.SLICE2_HITBOX_OFFSET,
        hitboxSize = Config.SLICE2_HITBOX_SIZE,
        targets = u7,
        checker = Checker,
        hitPriorityHandler = {
            data = "Choosing_1",
            callback = u1.Exists
        },

        hitDetected = function(p14: userdata, p15: any, p16: any) -- Line: 99, Name: hitDetected
            -- upvalues: Combat_Util (ref), Character (copy), Config (ref), RootPart (copy), u7 (copy), EffectsEvent (ref), u3 (copy), Combat_presets (ref)
            if p14 then
                local Humanoid = p14:FindFirstChild("Humanoid");
                local RootPart2 = Humanoid.RootPart;

                if p16 == "Blocking" then
                    Combat_Util.Block(script, Character, p14, Config.HIT_BLOCK_BREAK);
                    Combat_Util.Knockback(script, Character, RootPart2, RootPart.CFrame.lookVector * Config.HIT_BLOCK_KNOCKBACK, 0.2);

                    return;
                end;

                if p16 == "Perfect" then
                    Combat_Util.Perfect(script, Character, p14);

                    return;
                end;

                if p16 == true then
                    if table.find(u7, p14) == nil then
                        table.insert(u7, p14);
                    end;

                    local v17 = RootPart.CFrame.LookVector * Config.HIT_KNOCKBACK + vector.create(0, Config.HIT_KNOCKUP, 0);
                    EffectsEvent.ToAllInRange(u3, "Normal_Sword_Slash_Effect", RootPart2, -1);
                    Combat_Util.AddStun(script, Character, p15, Config.HIT_STUN);
                    Combat_Util.Damage(script, Character, p14, {
                        Base = Config.HIT_DAMAGE,
                        Skill = script.Parent.Name
                    });
                    Combat_Util.Knockback(script, Character, RootPart2, v17, Config.HIT_KNOCKBACK_DURATION);
                    Combat_presets.PlayReactAnim(Humanoid);
                end;
            end;
        end,

        After = function(p18, p19) -- Line: 122, Name: After
            -- upvalues: ImpactSounds (ref), Character (copy)
            if p18 then
                ImpactSounds.Play(Character, script.Parent.Name, p19[1]);
            end;
        end
    });
    task.wait(Config.SPIN_AT - Config.SLICE2_AT);

    if u2.Id[u3.UserId] ~= v6 then
        return;
    end;

    EffectsEvent.ToAllInRange(u3, "StoneConquestVFX", u3.Character, "Spin");
    Utility.CreateHitbox({
        caster = Character,
        hitboxCFrame = RootPart.CFrame * Config.SPIN_HITBOX_OFFSET,
        hitboxSize = Config.SPIN_HITBOX_SIZE,
        targets = u7,
        checker = Checker,
        hitPriorityHandler = {
            data = "Choosing_1",
            callback = u1.Exists
        },

        hitDetected = function(p20: userdata, p21: any, p22: any) -- Line: 138, Name: hitDetected
            -- upvalues: Combat_Util (ref), Character (copy), Config (ref), RootPart (copy), u7 (copy), EffectsEvent (ref), u3 (copy), Combat_presets (ref)
            if p20 then
                local Humanoid = p20:FindFirstChild("Humanoid");
                local RootPart2 = Humanoid.RootPart;

                if p22 == "Blocking" then
                    Combat_Util.Block(script, Character, p20, Config.HIT_BLOCK_BREAK);
                    Combat_Util.Knockback(script, Character, RootPart2, RootPart.CFrame.lookVector * Config.HIT_BLOCK_KNOCKBACK, 0.2);

                    return;
                end;

                if p22 == "Perfect" then
                    Combat_Util.Perfect(script, Character, p20);

                    return;
                end;

                if p22 == true then
                    if table.find(u7, p20) == nil then
                        table.insert(u7, p20);
                    end;

                    local v23 = RootPart.CFrame.LookVector * Config.HIT_KNOCKBACK + vector.create(0, Config.HIT_KNOCKUP, 0);
                    EffectsEvent.ToAllInRange(u3, "Normal_Sword_Slash_Effect", RootPart2, -1);
                    Combat_Util.AddStun(script, Character, p21, Config.HIT_STUN);
                    Combat_Util.Damage(script, Character, p20, {
                        Base = Config.HIT_DAMAGE,
                        Skill = script.Parent.Name
                    });
                    Combat_Util.Knockback(script, Character, RootPart2, v23, Config.HIT_KNOCKBACK_DURATION);
                    Combat_presets.PlayReactAnim(Humanoid);
                end;
            end;
        end,

        After = function(p24, p25) -- Line: 161, Name: After
            -- upvalues: ImpactSounds (ref), Character (copy)
            if p24 then
                ImpactSounds.Play(Character, script.Parent.Name, p25[1]);
            end;
        end
    });
    task.wait(Config.SLICE3_AT - Config.SPIN_AT);

    if u2.Id[u3.UserId] ~= v6 then
        return;
    end;

    EffectsEvent.ToAllInRange(u3, "StoneConquestVFX", u3.Character, "Slice3");
    Utility.CreateHitbox({
        caster = Character,
        hitboxCFrame = RootPart.CFrame * Config.SLICE3_HITBOX_OFFSET,
        hitboxSize = Config.SLICE3_HITBOX_SIZE,
        checker = Checker,
        hitPriorityHandler = {
            data = "Choosing_1",
            callback = u1.Exists
        },
        targets = u7,

        hitDetected = function(p26: userdata, p27: any, p28: any) -- Line: 176, Name: hitDetected
            -- upvalues: Combat_Util (ref), Character (copy), Config (ref), RootPart (copy), EffectsEvent (ref), u3 (copy)
            if p26 then
                local RootPart2 = p26:FindFirstChild("Humanoid").RootPart;

                if p28 == "Blocking" then
                    Combat_Util.Block(script, Character, p26, Config.HIT_BLOCK_BREAK);
                    Combat_Util.Knockback(script, Character, RootPart2, RootPart.CFrame.lookVector * Config.HIT_BLOCK_KNOCKBACK, 0.2);

                    return;
                end;

                if p28 == "Perfect" then
                    Combat_Util.Perfect(script, Character, p26);

                    return;
                end;

                if p28 == true then
                    local v29 = RootPart.CFrame.LookVector * Config.FINAL_KNOCKBACK;
                    EffectsEvent.ToAllInRange(u3, "Normal_Sword_Slash_Effect", RootPart2, -1);
                    Combat_Util.AddStun(script, Character, p27, Config.FINAL_STUN);
                    Combat_Util.Damage(script, Character, p26, {
                        Base = Config.FINAL_DAMAGE,
                        Skill = script.Parent.Name
                    });
                    Combat_Util.Knockback(script, Character, RootPart2, v29, Config.FINAL_KNOCKBACK_DURATION);
                    Combat_Util.RagDoll(script, Character, p27, Config.FINAL_RAGDOLL);
                end;
            end;
        end,

        After = function(p30, p31) -- Line: 196, Name: After
            -- upvalues: ImpactSounds (ref), Character (copy)
            if p30 then
                ImpactSounds.Play(Character, script.Parent.Name, p31[1]);
            end;
        end
    });
end;

function u2.UnHold(p32: userdata, p33: vector, p34: table) -- Line: 202
end;

function u2.Cancel(p35: userdata, p36: vector, p37: table) -- Line: 207
end;

return u2;
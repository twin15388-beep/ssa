-- Decompiled with Potassium's decompiler.

game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("CollectionService");
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
local ManuelCancel = require(CAM.Global.Subsets.Gameplay.ManuelCancel);
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);
local Config = require(script.Parent.Config);
local u5 = {
    Id = {},

    Hold = function(p2: userdata, p3: vector, p4: table) -- Line: 38, Name: Hold
        -- upvalues: EffectsEvent (copy)
        local Character = p2.Character;
        local _ = Character:FindFirstChild("Humanoid").RootPart;
        EffectsEvent.ToAllInRange(p2, "Seismic BurstVFX", Character, "Start", "InitSound2");
        p4.startClock = os.clock();
    end
};

function u5.UnHold(u6: userdata, u7: vector, u8: table) -- Line: 49
    -- upvalues: Utility (copy), u5 (copy), ManuelCancel (copy), Config (copy), EffectsEvent (copy), Checker (copy), u1 (copy), Combat_Util (copy), Combat_presets (copy), ImpactSounds (copy)
    local Character = u6.Character;
    Utility.getvaluesfolder(Character);
    local RootPart = Character:FindFirstChild("Humanoid").RootPart;
    local _ = os.clock() - u8.startClock;
    local u9 = u5.Id[u6.UserId];
    local v10, v11 = ManuelCancel.new(u6, 1);
    v10:Connect(function() -- Line: 64
        -- upvalues: u9 (ref), u5 (ref), u6 (copy), u7 (copy), u8 (copy)
        u9 = -1;
        u5.Cancel(u6, u7, u8);
    end);
    task.wait(Config.THROW_AT);

    if u5.Id[u6.UserId] ~= u9 then
        return;
    end;

    EffectsEvent.ToAllInRange(u6, "Upper SmashVFX", Character, "Throw");
    task.wait(Config.EXPLODE_DELAY);

    if u5.Id[u6.UserId] ~= u9 then
        return;
    end;

    EffectsEvent.ToAllInRange(u6, "Upper SmashVFX", Character, "Explode");
    local u12 = RootPart.CFrame * Config.EXPLODE_HITBOX_OFFSET;
    local u13 = {};
    Utility.CreateHitbox({
        caster = Character,
        hitboxCFrame = u12,
        hitboxSize = Config.EXPLODE_HITBOX_SIZE,
        checker = Checker,
        hitPriorityHandler = {
            data = "Choosing_1",
            callback = u1.Exists
        },

        hitDetected = function(p14: userdata, p15: any, p16: any) -- Line: 87, Name: hitDetected
            -- upvalues: Combat_Util (ref), Character (copy), Config (ref), u13 (copy), RootPart (copy), Combat_presets (ref)
            if p14 then
                local Humanoid = p14:FindFirstChild("Humanoid");
                local RootPart2 = Humanoid.RootPart;

                if p16 == "Blocking" then
                    Combat_Util.Block(script, Character, p14, Config.EXPLODE_BLOCK_BREAK);

                    return;
                end;

                if p16 == "Perfect" then
                    Combat_Util.Perfect(script, Character, p14);

                    return;
                end;

                if p16 == true then
                    table.insert(u13, p14);
                    local v17 = RootPart.CFrame.LookVector * Config.EXPLODE_KNOCKBACK + vector.create(0, Config.EXPLODE_KNOCKUP, 0);
                    Combat_Util.AddStun(script, Character, p15, Config.EXPLODE_STUN);
                    Combat_Util.Damage(script, Character, p14, {
                        Base = Config.EXPLODE_DAMAGE,
                        Skill = script.Parent.Name
                    });
                    Combat_Util.Knockback(script, Character, RootPart2, v17, Config.EXPLODE_KNOCKBACK_DURATION);
                    Combat_presets.PlayReactAnim(Humanoid);
                end;
            end;
        end,

        After = function(p18, p19) -- Line: 108, Name: After
            -- upvalues: ImpactSounds (ref), Character (copy)
            if p18 then
                ImpactSounds.Play(Character, script.Parent.Name, p19[1]);
            end;
        end
    });
    task.wait(Config.LAUNCH_DELAY);

    if u5.Id[u6.UserId] ~= u9 then
        return;
    end;

    Utility.CreateHitbox({
        caster = Character,
        hitboxCFrame = u12,
        hitboxSize = Config.LAUNCH_HITBOX_SIZE,
        checker = Checker,
        hitPriorityHandler = {
            data = "Choosing_1",
            callback = u1.Exists
        },
        targets = u13,

        hitDetected = function(p20: userdata, p21: any, p22: any) -- Line: 124, Name: hitDetected
            -- upvalues: Combat_Util (ref), Character (copy), Config (ref), u12 (copy)
            if p20 then
                local RootPart2 = p20:FindFirstChild("Humanoid").RootPart;

                if p22 == "Blocking" then
                    Combat_Util.Block(script, Character, p20, Config.LAUNCH_BLOCK_BREAK);

                    return;
                end;

                if p22 == "Perfect" then
                    Combat_Util.Perfect(script, Character, p20);

                    return;
                end;

                if p22 == true then
                    local v23 = vector.normalize(RootPart2.Position - u12.Position) * Config.LAUNCH_KNOCKBACK + vector.create(0, Config.LAUNCH_KNOCKUP, 0);
                    Combat_Util.AddStun(script, Character, p21, Config.LAUNCH_STUN);
                    Combat_Util.Damage(script, Character, p20, {
                        Base = Config.LAUNCH_DAMAGE,
                        Skill = script.Parent.Name
                    });
                    Combat_Util.Knockback(script, Character, RootPart2, v23, Config.LAUNCH_KNOCKBACK_DURATION);
                    Combat_Util.RagDoll(script, Character, p21, Config.LAUNCH_RAGDOLL);
                end;
            end;
        end,

        After = function(p24, p25) -- Line: 143, Name: After
            -- upvalues: ImpactSounds (ref), Character (copy)
            if p24 then
                ImpactSounds.Play(Character, script.Parent.Name, p25[1]);
            end;
        end
    });
    v11();
end;

function u5.Cancel(p26: userdata, p27: vector, p28: table) -- Line: 152
end;

return u5;
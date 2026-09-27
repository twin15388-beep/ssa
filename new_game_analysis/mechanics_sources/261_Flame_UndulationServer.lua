-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local u1 = {
    Id = {}
};
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);
local Checker = require(ReplicatedStorage.CAM.Global.Checker);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
require(ReplicatedStorage.CAM.Global.Combat_presets);
local u2 = require(ServerStorage.SAM.Game_Play.hit_priority_handler).new(script);
local Combat_Util = require(ServerStorage.SAM.Services.Combat_Util);
local ImpactSounds = require(ServerStorage.SAM.Utility.ImpactSounds);
local ManuelCancel = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.ManuelCancel);
local SkillStats = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.StatsFetch.Modules.SkillStats);
local Config = require(script.Parent.Config);

local function interrupted(p3: userdata?) -- Line: 20
    -- upvalues: SkillStats (copy), Utility (copy)
    if p3 == nil then
        return false;
    end;

    local v4 = SkillStats.Get(script.Parent.Name);

    if v4 ~= nil and v4.cancel_bypass then
        return false;
    end;

    for _, child in ipairs(p3:GetChildren()) do
        if Utility.Cancel_Values[child.Name] then
            return true;
        end;
    end;

    return false;
end;

function u1.Hold(p5, p6, p7) -- Line: 32
    -- upvalues: EffectsEvent (copy)
    EffectsEvent.ToAllInRange(p5, "Flame UdulationVFX", p5.Character, "Start");
end;

function u1.UnHold(u8, u9, u10) -- Line: 36
    -- upvalues: Utility (copy), interrupted (copy), u1 (copy), ManuelCancel (copy), Config (copy), EffectsEvent (copy), Checker (copy), u2 (copy), Combat_Util (copy), ImpactSounds (copy)
    local Character = u8.Character;

    if Character == nil then
        return;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart == nil then
        return;
    end;

    if interrupted((Utility.getvaluesfolder(Character))) then
        return;
    end;

    local u11 = u1.Id[u8.UserId];
    local v12, u13 = ManuelCancel.new(u8, Config.RELEASE_HIT_AT, nil, script.Parent.Name);
    v12:Connect(function() -- Line: 50
        -- upvalues: u11 (ref), u1 (ref), u8 (copy), u9 (copy), u10 (copy), u13 (copy)
        u11 = -1;
        u1.Cancel(u8, u9, u10);
        u13();
    end);
    task.wait(Config.RELEASE_HIT_AT);

    if u11 ~= u1.Id[u8.UserId] or HumanoidRootPart.Parent == nil then
        u13();

        return;
    end;

    u13();
    EffectsEvent.ToAllInRange(u8, "Flame UdulationVFX", Character, "Release");
    Utility.CreateHitbox({
        TreeDestruction = true,
        caster = Character,
        hitboxCFrame = HumanoidRootPart.CFrame * Config.RELEASE_HITBOX_OFFSET,
        hitboxSize = Config.RELEASE_HITBOX_SIZE,
        checker = Checker,
        hitPriorityHandler = {
            data = "Choosing_1",
            callback = u2.Exists
        },

        hitDetected = function(p14: userdata, p15: any, p16: any) -- Line: 73, Name: hitDetected
            -- upvalues: Combat_Util (ref), Character (copy), Config (ref), HumanoidRootPart (copy)
            if p14 then
                local RootPart = p14:FindFirstChild("Humanoid").RootPart;

                if p16 == "Blocking" then
                    Combat_Util.Block(script, Character, p14, Config.RELEASE_BLOCK_BREAK);

                    return;
                end;

                if p16 == "Perfect" then
                    Combat_Util.Perfect(script, Character, p14);

                    return;
                end;

                if p16 == true then
                    local v17 = HumanoidRootPart.CFrame.LookVector * Config.RELEASE_KNOCKBACK + vector.create(0, Config.RELEASE_KNOCKUP, 0);
                    Combat_Util.AddStun(script, Character, p15, Config.RELEASE_STUN);
                    Combat_Util.Damage(script, Character, p14, {
                        Base = Config.RELEASE_DAMAGE,
                        Skill = script.Parent.Name
                    });
                    Combat_Util.Knockback(script, Character, RootPart, v17, 0.2);
                    Combat_Util.RagDoll(script, Character, p15, Config.RELEASE_RAGDOLL);
                end;
            end;
        end,

        After = function(p18, p19) -- Line: 94, Name: After
            -- upvalues: ImpactSounds (ref), Character (copy)
            if p18 then
                ImpactSounds.Play(Character, script.Parent.Name, p19[1]);
            end;
        end
    });
end;

function u1.Cancel(p20, p21, p22) -- Line: 100
end;

function u1.Counter(p23, p24, p25) -- Line: 102
    -- upvalues: Utility (copy), Config (copy), Combat_Util (copy), Checker (copy), EffectsEvent (copy), ImpactSounds (copy)
    local Character = p23.Character;
    local valuesfolder = Utility.getvaluesfolder(p25);
    Utility.AddValue(valuesfolder, "pause_gameplay", Config.COUNTER_VICTIM_PAUSE);
    Combat_Util.Cancel(script, valuesfolder);
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
    local HumanoidRootPart2 = p25:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart2 == nil or HumanoidRootPart == nil then
        return;
    end;

    task.wait(Config.COUNTER_HIT_AT);

    if Checker.check_victim(script, Character, p25) == nil then
        return;
    end;

    EffectsEvent.ToAllInRange(p23, "Flame UdulationVFX", Character, "Counter");
    local v26 = HumanoidRootPart.CFrame.LookVector * Config.COUNTER_KNOCKBACK + vector.create(0, Config.COUNTER_KNOCKUP, 0);
    Combat_Util.AddStun(script, Character, valuesfolder, Config.COUNTER_STUN);
    Combat_Util.Damage(script, Character, p25, {
        Base = Config.COUNTER_DAMAGE,
        Skill = script.Parent.Name
    });
    ImpactSounds.Play(Character, script.Parent.Name, p25);
    Combat_Util.Knockback(script, Character, HumanoidRootPart2, v26, 0.2);
    Combat_Util.RagDoll(script, Character, valuesfolder, Config.COUNTER_RAGDOLL);
end;

return u1;
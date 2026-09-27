-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local CAM = ReplicatedStorage.CAM;
local SAM = ServerStorage.SAM;
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);
local Utility = require(CAM.Global.Utility);
local Combat_Util = require(SAM.Services.Combat_Util);
local Combat_Util2 = require(ServerStorage.SAM.Services.Combat_Util);
local Checker = require(CAM.Global.Checker);
local u1 = require(SAM.Game_Play.hit_priority_handler).new(script);
local StatTypes = require(CAM.Global.Types.StatTypes);
local Config = require(script.Parent.Config);
local SkillStorage = require(game:GetService("ServerStorage").SAM.Utility.SkillStorage);
local u2 = {
    Id = {}
};

local function grantSurge(p3: userdata) -- Line: 30
    -- upvalues: Config (copy), Utility (copy), StatTypes (copy)
    if p3 == nil then
        return;
    end;

    local v4 = p3:FindFirstChild(Config.BUFF_VALUE_NAME);

    if v4 ~= nil then
        v4:Destroy();
    end;

    local v5 = Utility.AddValue(p3, Config.BUFF_VALUE_NAME, Config.BUFF_DURATION);
    v5:AddTag(StatTypes.ValueStatTag);
    v5:SetAttribute(StatTypes.StatToAttribute("Movement Speed Factor"), Config.BUFF_MOVEMENT_FACTOR);
    v5:SetAttribute(StatTypes.StatToAttribute("Additional Damage Factor"), Config.BUFF_DAMAGE_FACTOR);
end;

function u2.Hold(p6: userdata) -- Line: 45
    -- upvalues: u2 (copy), EffectsEvent (copy), Config (copy), Utility (copy), Checker (copy), u1 (copy), SkillStorage (copy)
    local Character = p6.Character;
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
    local v7 = u2.Id[p6.UserId];
    EffectsEvent.ToAllInRange(HumanoidRootPart, "Compass Needle VFX", Character, "Start");
    task.wait(Config.SWEEP_AT);

    if u2.Id[p6.UserId] ~= v7 or HumanoidRootPart.Parent == nil then
        return;
    end;

    local u8 = nil;
    Utility.CreateHitbox({
        caster = Character,
        hitboxCFrame = HumanoidRootPart.CFrame * Config.SWEEP_HITBOX_OFFSET,
        hitboxSize = Config.SWEEP_HITBOX_SIZE,
        checker = Checker,
        hitPriorityHandler = {
            data = "Choosing_1",
            callback = u1.Exists
        },

        hitDetected = function(p9: userdata, p10: userdata, p11: any) -- Line: 65, Name: hitDetected
            -- upvalues: u8 (ref)
            if u8 == nil and p11 == true then
                u8 = p9;
            end;
        end
    });

    if u8 then
        SkillStorage.GetID(p6, script.Parent.Name).CounterTarget = u8;
        EffectsEvent.ToClient(p6, "force_skill_actions_server", script.Parent.Name, "Counter", nil, true, u8);
    end;
end;

function u2.UnHold(p12: userdata) -- Line: 82
    -- upvalues: Utility (copy), Combat_Util (copy), Config (copy), grantSurge (copy)
    local valuesfolder = Utility.getvaluesfolder(p12.Character);
    Combat_Util.AddCustomSkillState(valuesfolder, Config.BUFF_SKILL_NAME, Config.BUFF_STATE_VALUE, Config.BUFF_DURATION);
    grantSurge(valuesfolder);
end;

function u2.Counter(p13: userdata, p14: vector, p15: userdata) -- Line: 90
    -- upvalues: Checker (copy), Utility (copy), Config (copy), Combat_Util2 (copy), EffectsEvent (copy), Combat_Util (copy), grantSurge (copy)
    local Character = p13.Character;
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
    local HumanoidRootPart2 = p15:FindFirstChild("HumanoidRootPart");

    if not Checker.check_victim(script, Character, p15) then
        return;
    end;

    local valuesfolder = Utility.getvaluesfolder(Character);
    local valuesfolder2 = Utility.getvaluesfolder(p15);
    Utility.AddValue(valuesfolder2, "pause_gameplay", Config.COUNTER_LOCK_DURATION);
    Utility.AddValue(valuesfolder2, "NR", Config.COUNTER_LOCK_DURATION);
    Combat_Util2.Cancel(script, valuesfolder2);
    Utility.AddValue(valuesfolder, "pause_gameplay", Config.COUNTER_CASTER_LOCK);
    Utility.AddValue(valuesfolder, "NR", Config.COUNTER_CASTER_LOCK);
    Utility.AddValue(valuesfolder, "skill_stand_still", Config.COUNTER_CASTER_LOCK);
    task.wait(Config.COUNTER_TELEPORT_AT);
    HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
    HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
    local Pivot = p15:GetPivot();
    HumanoidRootPart:PivotTo(CFrame.lookAt((Pivot * CFrame.new(0, 0, 3)).Position, HumanoidRootPart2.Position));
    EffectsEvent.ToAllInRange(HumanoidRootPart, "Compass Needle VFX", Character, "Counter");
    Combat_Util.Add_air_combo_bp(HumanoidRootPart2, HumanoidRootPart);
    Combat_Util.Add_air_combo_bp(HumanoidRootPart, HumanoidRootPart);
    Combat_Util.Damage(script, Character, p15, {
        Base = Config.COUNTER_DAMAGE,
        Skill = script.Parent.Name
    });
    Combat_Util.Add_Strict_Stun(script, Character, valuesfolder2, Config.COUNTER_STUN_DURATION, true);
    Combat_Util.AddCustomSkillState(valuesfolder, Config.BUFF_SKILL_NAME, Config.BUFF_STATE_VALUE, Config.BUFF_DURATION);
    grantSurge(valuesfolder);
end;

function u2.Cancel(p16: userdata) -- Line: 142
    -- upvalues: EffectsEvent (copy)
    local Character = p16.Character;
    local v17;

    if Character then
        v17 = Character:FindFirstChild("HumanoidRootPart");
    else
        v17 = Character;
    end;

    if v17 then
        EffectsEvent.ToAllInRange(v17, "Compass Needle VFX", Character, "Cancel");
    end;
end;

return u2;
-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
game:GetService("RunService");
game:GetService("CollectionService");
local ReplicatedStorage2 = game:GetService("ReplicatedStorage");
local CAM = ReplicatedStorage:WaitForChild("CAM");
local SAM = ServerStorage:WaitForChild("SAM");
local Global = CAM:WaitForChild("Global");
local Services = SAM:WaitForChild("Services");
local Utility = require(Global.Utility);
local Checker = require(Global.Checker);
local Combat_Util = require(Services.Combat_Util);
local ImpactSounds = require(SAM.Utility.ImpactSounds);
local Combat_presets = require(CAM.Global.Combat_presets);
local u1 = require(SAM.Game_Play.hit_priority_handler).new(script);
local ManuelCancel = require(Global.Subsets.Gameplay.ManuelCancel);
local AppliedTicks = require(Global.Subsets.Gameplay.AppliedTicks);
local Clans = require(CAM.Clans);
local DebrisModule = require(CAM:FindFirstChild("DebrisModule"));
require(ReplicatedStorage2.CAM.Global.Character_info_provider);
local EffectsEvent = require(ReplicatedStorage2.Communication.ServerAndClient.Effects.EffectsEvent);
local Config = require(script.Parent.Config);
ReplicatedStorage:FindFirstChild("Assets"):FindFirstChild("Animations");
local u2 = {
    Id = {}
};
local u3 = script;

function u2.Hold(u4: userdata, p5: any, p6: any) -- Line: 38
    -- upvalues: Utility (copy), u2 (copy), EffectsEvent (copy), Combat_Util (copy), u3 (copy), Config (copy), Clans (copy), AppliedTicks (copy), Combat_presets (copy), Checker (copy), u1 (copy)
    if not u4 then
        return;
    end;

    local Character = u4.Character;

    if not Character then
        return;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    if not Character:FindFirstChild("Animator", true) then
        return;
    end;

    Utility.getvaluesfolder(Character);
    local v7 = u2.Id[u4.UserId];
    EffectsEvent.ToAllInRange(u4, "Compound_Eye_Hexagon_VFX", Character, "Loop");

    local function v14(p8: userdata, p9: any, p10: any, p11: any) -- Line: 55
        -- upvalues: Combat_Util (ref), u3 (ref), Character (copy), Config (ref), EffectsEvent (ref), u4 (copy), Clans (ref), Utility (ref), AppliedTicks (ref), Combat_presets (ref)
        if p8 then
            local Humanoid = p8:FindFirstChild("Humanoid");
            local RootPart = Humanoid.RootPart;

            if p10 == "Blocking" then
                Combat_Util.Block(u3, Character, p8, Config.LOOP_BLOCK_BREAK);

                return;
            end;

            if p10 == "Perfect" then
                Combat_Util.Perfect(u3, Character, p8);

                return;
            end;

            if p10 == true then
                local v12 = CFrame.new(RootPart.Position).UpVector * Config.LOOP_KNOCKUP;
                EffectsEvent.ToAllInRange(u4, "Normal_Sword_Slash_Effect", RootPart, -1);
                Combat_Util.AddStun(u3, Character, p9, Config.LOOP_STUN, true);
                Combat_Util.Damage(u3, Character, p8, {
                    Base = Config.LOOP_DAMAGE,
                    Skill = script.Parent.Name
                });

                if Clans.HasPassive(Character:GetAttribute("Clan"), "Insect Affinity") then
                    local v13 = Utility.AddValue(p9, AppliedTicks.ByName.Poison.Value, Config.POISON_DURATION, "ObjectValue", Character);
                    v13:SetAttribute("Damage", Config.POISON_TICK_DAMAGE);
                    v13:SetAttribute("Skill", script.Parent.Name);
                end;

                Combat_Util.Knockback(u3, Character, RootPart, v12, Config.LOOP_KNOCKBACK_DUR);

                if Humanoid then
                    local math_random_ret = math.random(1, 4);
                    Combat_presets.PlayReactAnim(Humanoid, math_random_ret);
                end;
            end;
        end;
    end;

    task.wait(Config.WINDUP);
    local Position = HumanoidRootPart.Position;

    while HumanoidRootPart:IsDescendantOf(workspace) and u2.Id[u4.UserId] == v7 do
        Utility.CreateHitbox({
            visualize = false,
            caster = Character,
            hitboxCFrame = CFrame.new(Position.X, HumanoidRootPart.Position.Y, Position.Z) * HumanoidRootPart.CFrame.Rotation * Config.LOOP_HITBOX_OFFSET,
            hitboxSize = Config.LOOP_HITBOX_SIZE,
            checker = Checker,
            hitPriorityHandler = {
                data = "Choosing_1",
                callback = u1.Exists
            },
            hitDetected = v14
        });
        task.wait(Config.LOOP_TICK_INTERVAL);
    end;
end;

function u2.UnHold(u15: userdata, u16: any, u17: any) -- Line: 115
    -- upvalues: Utility (copy), ManuelCancel (copy), Config (copy), u2 (copy), DebrisModule (copy), EffectsEvent (copy), Combat_Util (copy), u3 (copy), Checker (copy), u1 (copy), ImpactSounds (copy)
    if not u15 then
        return;
    end;

    local Character = u15.Character;

    if not Character then
        return;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    if not Character:FindFirstChild("Animator", true) then
        return;
    end;

    local valuesfolder = Utility.getvaluesfolder(Character);
    local v18, _ = ManuelCancel.new(Character, Config.UNHOLD_CANCEL_WINDOW);
    local u19 = u2.Id[u15.UserId];
    v18:Connect(function() -- Line: 128
        -- upvalues: u19 (ref), u2 (ref), u15 (copy), u16 (copy), u17 (copy)
        u19 = -1;
        u2.Cancel(u15, u16, u17);
    end);
    u17.Value_Table = {};
    local BoolValue = Instance.new("BoolValue");
    BoolValue.Name = "pause_gameplay";
    BoolValue.Parent = valuesfolder;
    DebrisModule:AddItem(BoolValue, Config.UNHOLD_LOCK_DURATION);
    table.insert(u17.Value_Table, BoolValue);
    local BoolValue2 = Instance.new("BoolValue");
    BoolValue2.Name = "NR";
    BoolValue2.Parent = valuesfolder;
    table.insert(u17.Value_Table, BoolValue2);
    DebrisModule:AddItem(BoolValue2, Config.UNHOLD_LOCK_DURATION);
    EffectsEvent.ToAllInRange(u15, "Compound_Eye_Hexagon_VFX", Character, "End");
    task.wait(Config.DASH_START_AT);

    local function v25(p20: userdata, p21: any, p22: any, p23: any) -- Line: 152
        -- upvalues: Combat_Util (ref), u3 (ref), Character (copy), Config (ref), EffectsEvent (ref), u15 (copy)
        if p20 then
            local RootPart = p20:FindFirstChild("Humanoid").RootPart;

            if p22 == "Perfect" then
                Combat_Util.Perfect(u3, Character, p20);

                return;
            end;

            if p22 == "Blocking" then
                Combat_Util.Block(u3, Character, p20, Config.DASH_BLOCK_BREAK);

                return;
            end;

            if p22 == true then
                local v24 = p23.lookVector * Config.DASH_KNOCKBACK;
                EffectsEvent.ToAllInRange(u15, "Normal_Sword_Slash_Effect", RootPart, -1);
                Combat_Util.AddStun(u3, Character, p21, Config.DASH_STUN, true);
                Combat_Util.Damage(u3, Character, p20, {
                    Base = Config.DASH_DAMAGE,
                    Skill = script.Parent.Name
                });
                Combat_Util.RagDoll(u3, Character, p21, Config.DASH_RAGDOLL);
                Combat_Util.Knockback(u3, Character, RootPart, Vector3.new(v24.X, Config.DASH_KNOCKUP, v24.Z), Config.DASH_KNOCKBACK_DUR);
            end;
        end;
    end;

    local v26 = HumanoidRootPart.CFrame * Config.DASH_HITBOX_START_OFFSET * CFrame.new(0, 0, -(Config.DASH_DISTANCE / 2));
    Utility.CreateHitbox({
        caster = Character,
        hitboxCFrame = v26,
        hitboxSize = Vector3.new(Config.DASH_HITBOX_SIZE.X, Config.DASH_HITBOX_SIZE.Y, Config.DASH_DISTANCE + Config.DASH_HITBOX_SIZE.Z),
        checker = Checker,
        hitPriorityHandler = {
            data = "Choosing_1",
            callback = u1.Exists
        },
        hitDetected = v25,
        extraArgs = v26,

        After = function(p27, p28) -- Line: 193, Name: After
            -- upvalues: ImpactSounds (ref), Character (copy)
            if p27 then
                ImpactSounds.Play(Character, script.Parent.Name, p28[1]);
            end;
        end
    });
    task.wait(Config.DASH_SWEEP_DURATION);
end;

function u2.Cancel(p29, p30, p31) -- Line: 201
    -- upvalues: EffectsEvent (copy)
    if not p29 then
        return;
    end;

    local Character = p29.Character;

    if not Character then
        return;
    end;

    EffectsEvent.ToAllInRange(p29, "Compound_Eye_Hexagon_VFX", Character, "Cancel");

    if p31.Value_Table then
        for _, v in p31.Value_Table do
            v:Destroy();
        end;
    end;
end;

return u2;
-- Decompiled with Potassium's decompiler.

game:GetService("Debris");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local CAM = ReplicatedStorage.CAM;
local SAM = ServerStorage.SAM;
local Combat_presets = require(ReplicatedStorage.CAM.Global.Combat_presets);
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);
local ManuelCancel = require(CAM.Global.Subsets.Gameplay.ManuelCancel);
local u1 = require(SAM.Game_Play.hit_priority_handler).new(script);
local Utility = require(CAM.Global.Utility);
local Checker = require(CAM.Global.Checker);
local Combat_Util = require(SAM.Services.Combat_Util);
local cleanit = require(ReplicatedStorage.Packages.cleanit);
local vfxUtility = require(CAM.Client.Modules.Effects.vfxUtility);
local Config = require(script.Parent.Config);
local u2 = {
    Id = {}
};

function u2.Hold(p3: userdata, p4: vector?, p5: table) -- Line: 25
    -- upvalues: cleanit (copy), u2 (copy), Utility (copy), EffectsEvent (copy), Config (copy), vfxUtility (copy), Checker (copy), u1 (copy), Combat_Util (copy), Combat_presets (copy)
    local v6 = p5.CleanIt or cleanit.new();
    p5.CleanIt = v6;
    v6:Clean();
    local v7 = u2.Id[p3.UserId];
    local Character = p3.Character;
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
    local valuesfolder = Utility.getvaluesfolder(Character);
    EffectsEvent.ToAllInRange(HumanoidRootPart, "Chaotic Afterglow VFX", Character, "Start", HumanoidRootPart.CFrame);

    for _, v in { "pause_gameplay", "NR", "skill_stand_still", "iframe" } do
        v6:Add(Utility.AddValue(valuesfolder, v, Config.AFTERGLOW_CAST_LOCK));
    end;

    task.wait(0.8);

    if v7 ~= u2.Id[p3.UserId] then
        return;
    end;

    vfxUtility.PlaySound(script, "PS2akazaULTIMATE2explo", HumanoidRootPart);
    EffectsEvent.ToAllInRange(HumanoidRootPart, "Chaotic Afterglow VFX", Character, "Pulse", HumanoidRootPart.CFrame);
    local Position = HumanoidRootPart.Position;
    local v8 = 0;

    while v7 == u2.Id[p3.UserId] and HumanoidRootPart.Parent ~= nil do
        v8 = v8 + 1;
        Utility.CreateHitbox({
            caster = Character,
            hitboxCFrame = CFrame.new(Position.X, HumanoidRootPart.Position.Y, Position.Z) * HumanoidRootPart.CFrame.Rotation,
            hitboxSize = Config.AFTERGLOW_HITBOX_SIZE * (math.max(v8 - 4, 1) / 15 + 1),
            checker = Checker,
            hitPriorityHandler = {
                data = "Choosing_1",
                callback = u1.Exists
            },

            hitDetected = function(p9: userdata, p10: userdata, p11: any) -- Line: 54, Name: hitDetected
                -- upvalues: Combat_Util (ref), Character (copy), Config (ref), HumanoidRootPart (copy), Combat_presets (ref), EffectsEvent (ref)
                local Humanoid = p9:FindFirstChild("Humanoid");
                local RootPart = Humanoid.RootPart;

                if p11 == "Perfect" then
                    Combat_Util.Perfect(script, Character, p9);
                elseif p11 == "Blocking" and not Combat_Util.Block(script, Character, p9, Config.AFTERGLOW_TICK_BLOCK_BREAK) then
                    return;
                end;

                Combat_Util.Knockback(script, Character, RootPart, (RootPart.Position - HumanoidRootPart.Position).Unit * Config.AFTERGLOW_TICK_KNOCKBACK + vector.create(0, Config.AFTERGLOW_TICK_UPWARD, 0), 0.3);
                Combat_Util.Damage(script, Character, p9, {
                    Base = Config.AFTERGLOW_DAMAGE,
                    Skill = script.Parent.Name
                });
                Combat_Util.AddStun(script, Character, p10, Config.AFTERGLOW_FINAL_STUN);
                Combat_presets.PlayReactAnim(Humanoid);
                EffectsEvent.ToAllInRange(HumanoidRootPart, "Normal_Punch_Effect", RootPart, -1);
            end
        });
        task.wait(0.2);
    end;
end;

function u2.UnHold(u12: userdata, u13: vector?, u14: table) -- Line: 85
    -- upvalues: cleanit (copy), u2 (copy), Utility (copy), Config (copy), ManuelCancel (copy), EffectsEvent (copy), Checker (copy), u1 (copy), Combat_Util (copy)
    local v15 = u14.CleanIt or cleanit.new();
    u14.CleanIt = v15;
    local v16 = u2.Id[u12.UserId];
    local Character = u12.Character;
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
    local valuesfolder = Utility.getvaluesfolder(Character);

    for _, v in { "pause_gameplay", "NR", "skill_stand_still", "iframe" } do
        v15:Add(Utility.AddValue(valuesfolder, v, Config.AFTERGLOW_FINISH_LOCK));
    end;

    local v17, v18 = ManuelCancel.new(u12, 0.93);
    v17:Connect(function() -- Line: 102
        -- upvalues: u2 (ref), u12 (copy), u13 (copy), u14 (copy)
        u2.Id[u12.UserId] = -1;
        u2.Cancel(u12, u13, u14);
    end);
    EffectsEvent.ToAllInRange(HumanoidRootPart, "Chaotic Afterglow VFX", Character, "PulseFinal", HumanoidRootPart.CFrame);
    task.wait(0.4);

    if u2.Id[u12.UserId] ~= v16 then
        return;
    end;

    Utility.CreateHitbox({
        caster = Character,
        hitboxCFrame = HumanoidRootPart.CFrame,
        hitboxSize = Config.AFTERGLOW_FINAL_HITBOX_SIZE,
        checker = Checker,
        hitPriorityHandler = {
            data = "Choosing_1",
            callback = u1.Exists
        },

        hitDetected = function(p19: userdata, p20: userdata, p21: any) -- Line: 118, Name: hitDetected
            -- upvalues: Combat_Util (ref), Character (copy), Config (ref), EffectsEvent (ref), HumanoidRootPart (copy)
            local RootPart = p19:FindFirstChild("Humanoid").RootPart;

            if p21 == "Perfect" then
                Combat_Util.Perfect(script, Character, p19);
            elseif p21 == "Blocking" and not Combat_Util.Block(script, Character, p19, Config.AFTERGLOW_FINAL_BLOCK_BREAK) then
                return;
            end;

            Combat_Util.Damage(script, Character, p19, {
                Base = Config.AFTERGLOW_FINAL_DAMAGE,
                Skill = script.Parent.Name
            });
            Combat_Util.AddStun(script, Character, p20, Config.AFTERGLOW_STUN);
            EffectsEvent.ToAllInRange(HumanoidRootPart, "Normal_Punch_Effect", RootPart, -1);
            Combat_Util.RagDoll(script, Character, p20, Config.AFTERGLOW_FINAL_STUN);
            Combat_Util.Knockback(script, Character, RootPart, (RootPart.Position - HumanoidRootPart.Position).Unit * Config.AFTERGLOW_FINAL_KNOCKBACK + vector.create(0, Config.AFTERGLOW_FINAL_UPWARD, 0), 0.45);
        end
    });
    v18();
    v15:Clean();
end;

function u2.Cancel(p22: userdata, p23: vector?, p24: table) -- Line: 149
    -- upvalues: cleanit (copy), EffectsEvent (copy)
    local v25 = p24.CleanIt or cleanit.new();
    p24.CleanIt = v25;
    EffectsEvent.ToAllInRange(p22, "Chaotic Afterglow VFX", p22.Character, "Cancel");
    v25:Clean();
end;

return u2;
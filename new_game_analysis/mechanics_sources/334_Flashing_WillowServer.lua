-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local CAM = ReplicatedStorage.CAM;
local SAM = ServerStorage.SAM;
local Combat_presets = require(ReplicatedStorage.CAM.Global.Combat_presets);
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);
local ManuelCancel = require(CAM.Global.Subsets.Gameplay.ManuelCancel);
local Server_Mouse_Pos = require(SAM.Services.Server_Mouse_Pos);
local Checker = require(CAM.Global.Checker);
local Utility = require(CAM.Global.Utility);
local Combat_Util = require(SAM.Services.Combat_Util);
local u1 = require(SAM.Game_Play.hit_priority_handler).new(script);
local cleanit = require(ReplicatedStorage.Packages.cleanit);
local DebrisModule = require(CAM.DebrisModule);
local Config = require(script.Parent.Config);
local u2 = {
    Id = {}
};

function u2.Hold(u3: userdata, p4: vector?, u5: table) -- Line: 30
    -- upvalues: cleanit (copy), Server_Mouse_Pos (copy), u2 (copy), Config (copy), Combat_Util (copy), EffectsEvent (copy)
    local u6 = u5.CleanIt or cleanit.new();
    u5.CleanIt = u6;
    u6:Clean();
    local Character = u3.Character;
    local RootPart = Character:FindFirstChild("Humanoid").RootPart;
    Server_Mouse_Pos.Create_Pos_Part(Character, script.Parent.Name, 4);
    u6:Add(function() -- Line: 40
        -- upvalues: Server_Mouse_Pos (ref), Character (copy)
        Server_Mouse_Pos.Delete_Pos_Part(Character, script.Parent.Name);
    end);
    local u7 = u2.Id[u3.UserId];
    u5.released = false;
    task.delay(Config.TAP_THRESHOLD, function() -- Line: 49
        -- upvalues: u2 (ref), u3 (copy), u7 (copy), u5 (copy), RootPart (copy), Combat_Util (ref), Config (ref), u6 (copy)
        if u2.Id[u3.UserId] ~= u7 then
            return;
        end;

        if u5.released then
            return;
        end;

        if RootPart == nil or RootPart.Parent == nil then
            return;
        end;

        u5.airHold = Combat_Util.Add_air_combo_bp(RootPart, nil, Config.UPDRAFT_HEIGHT, nil, Config.UPDRAFT_DURATION);
        u6:Add(u5.airHold);
    end);
    EffectsEvent.ToAllInRange(RootPart, "Flashing Willow Ground VFX", Character, "Start", RootPart.CFrame);
end;

function u2.UnHold(u8: userdata, u9: vector?, u10: table) -- Line: 59
    -- upvalues: cleanit (copy), u2 (copy), Utility (copy), Config (copy), ManuelCancel (copy), Server_Mouse_Pos (copy), DebrisModule (copy), EffectsEvent (copy), Checker (copy), u1 (copy), Combat_Util (copy), Combat_presets (copy)
    local v11 = u10.CleanIt or cleanit.new();
    u10.CleanIt = v11;
    u10.released = true;
    local v12 = u2.Id[u8.UserId];
    local Character = u8.Character;
    local Humanoid = Character:FindFirstChild("Humanoid");
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
    local valuesfolder = Utility.getvaluesfolder(Character);
    local RELEASE_DELAY = Config.RELEASE_DELAY;
    local v13, v14 = ManuelCancel.new(u8, 1.6);
    v13:Connect(function() -- Line: 77
        -- upvalues: u2 (ref), u8 (copy), u9 (copy), u10 (copy)
        u2.Id[u8.UserId] = -1;
        u2.Cancel(u8, u9, u10);
    end);
    Utility.AddValue(valuesfolder, "pause_gameplay", RELEASE_DELAY);
    Utility.AddValue(valuesfolder, "NR", RELEASE_DELAY);
    Utility.AddValue(valuesfolder, "skill_stand_still", RELEASE_DELAY);

    if u10.airHold then
        v11:Remove(u10.airHold);
        u10.airHold:Destroy();
        u10.airHold = nil;
    end;

    local _, v15 = Server_Mouse_Pos.Aim(Character, script.Parent.Name, Config.MOUSE_RANGE);

    if v15 == nil then
        return;
    end;

    local v16 = v15.Position + Vector3.new(0, Humanoid.HipHeight + HumanoidRootPart.Size.Y / 2, 0);
    local Attachment = Instance.new("Attachment");
    Attachment.Name = "air_combo_bp";
    v11:Add(Attachment);
    DebrisModule:AddItem(Attachment, Config.RELEASE_DELAY);
    local AlignPosition = Instance.new("AlignPosition");
    AlignPosition.Mode = Enum.PositionAlignmentMode.OneAttachment;
    AlignPosition.MaxAxesForce = Vector3.new(20000, 20000, 20000);
    AlignPosition.Responsiveness = 45;
    AlignPosition.Attachment0 = Attachment;
    AlignPosition.Parent = Attachment;
    AlignPosition.Position = v16;
    v11:Add(AlignPosition);
    DebrisModule:AddItem(AlignPosition, Config.RELEASE_DELAY);
    Attachment.Parent = HumanoidRootPart;
    v11:Add(function() -- Line: 115
        -- upvalues: HumanoidRootPart (copy)
        if HumanoidRootPart then
            HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
            HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
        end;
    end);
    task.wait(0.25);

    if u2.Id[u8.UserId] ~= v12 then
        return;
    end;

    EffectsEvent.ToAllInRange(HumanoidRootPart, "Flashing Willow Ground VFX", Character, "Pulse", v15);
    Utility.CreateHitbox({
        caster = Character,
        hitboxCFrame = v15,
        hitboxSize = Config.PULSE_HITBOX_SIZE,
        checker = Checker,
        hitPriorityHandler = {
            data = "Choosing_1",
            callback = u1.Exists
        },

        hitDetected = function(p17: userdata, p18: userdata, p19: any) -- Line: 131, Name: hitDetected
            -- upvalues: Combat_Util (ref), Character (copy), Config (ref), EffectsEvent (ref), HumanoidRootPart (copy), Combat_presets (ref)
            local Humanoid2 = p17:FindFirstChild("Humanoid");
            local v20;

            if Humanoid2 then
                v20 = Humanoid2.RootPart;
            else
                v20 = Humanoid2;
            end;

            if p19 == "Perfect" then
                Combat_Util.Perfect(script, Character, p17);

                return true;
            end;

            if p19 == "Blocking" and not Combat_Util.Block(script, Character, p17, Config.PULSE_BLOCK_BREAK) then
                return;
            end;

            Combat_Util.Knockback(script, Character, v20, Vector3.new(0, 5, 0), 0.75);
            EffectsEvent.ToAllInRange(HumanoidRootPart, "Normal_Punch_Effect", v20, -1);
            Combat_Util.Damage(script, Character, p17, {
                Base = Config.PULSE_DAMAGE,
                Skill = script.Parent.Name
            });
            Combat_Util.AddStun(script, Character, p18, Config.PULSE_STUN);
            Combat_presets.PlayReactAnim(Humanoid2, nil, 0.5);
        end
    });
    task.wait(0.6);

    if u2.Id[u8.UserId] ~= v12 then
        return;
    end;

    EffectsEvent.ToAllInRange(HumanoidRootPart, "Flashing Willow Ground VFX", Character, "PulseFinal", v15);

    for i = 1, 4 do
        if u2.Id[u8.UserId] ~= v12 then
            return;
        end;

        Utility.CreateHitbox({
            caster = Character,
            hitboxCFrame = v15,
            hitboxSize = Config.PULSE_FINISH_HITBOX_SIZE * (i / 16 + 1),
            checker = Checker,
            hitPriorityHandler = {
                data = "Choosing_1",
                callback = u1.Exists
            },

            hitDetected = function(p21: userdata, p22: userdata, p23: any) -- Line: 164, Name: hitDetected
                -- upvalues: Combat_Util (ref), Character (copy), Config (ref), EffectsEvent (ref), HumanoidRootPart (copy), i (copy), Combat_presets (ref)
                local Humanoid2 = p21:FindFirstChild("Humanoid");
                local v24;

                if Humanoid2 then
                    v24 = Humanoid2.RootPart;
                else
                    v24 = Humanoid2;
                end;

                if p23 == "Perfect" then
                    Combat_Util.Perfect(script, Character, p21);

                    return true;
                end;

                if p23 == "Blocking" and not Combat_Util.Block(script, Character, p21, Config.PULSE_FINISH_BLOCK_BREAK) then
                    return;
                end;

                EffectsEvent.ToAllInRange(HumanoidRootPart, "Normal_Punch_Effect", v24, -1);
                Combat_Util.AddStun(script, Character, p22, Config.PULSE_FINISH_STUN);
                local Unit = (v24.Position - HumanoidRootPart.Position).Unit;

                if i == 4 then
                    Combat_Util.Damage(script, Character, p21, {
                        Base = Config.PULSE_FINISH_DAMAGE,
                        Skill = script.Parent.Name
                    });
                    Combat_Util.Knockback(script, Character, v24, Unit * Config.PULSE_FINISH_KNOCKBACK, 0.2);
                    Combat_Util.RagDoll(script, Character, p22, Config.PULSE_FINISH_STUN);

                    return;
                end;

                Combat_presets.PlayReactAnim(Humanoid2);
                Combat_Util.Damage(script, Character, p21, {
                    Base = Config.PULSE_DAMAGE,
                    Skill = script.Parent.Name
                });
                Combat_Util.Knockback(script, Character, v24, Unit * 2 + Vector3.new(0, 0.1, 0), 0.2);
            end
        });
        task.wait(0.18);
        local _ = i;
    end;

    if v12 ~= u2.Id[u8.UserId] then
        return;
    end;

    v14();
    v11:Clean();
end;

function u2.Cancel(p25: userdata, p26: vector?, p27: table) -- Line: 200
    -- upvalues: cleanit (copy), EffectsEvent (copy)
    local v28 = p27.CleanIt or cleanit.new();
    p27.CleanIt = v28;
    EffectsEvent.ToAllInRange(p25, "Flashing Willow Ground VFX", p25.Character, "Cancel");
    v28:Clean();
end;

return u2;
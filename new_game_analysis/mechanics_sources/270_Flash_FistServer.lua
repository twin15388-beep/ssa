-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local CAM = ReplicatedStorage.CAM;
local SAM = ServerStorage.SAM;
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);
local ManuelCancel = require(CAM.Global.Subsets.Gameplay.ManuelCancel);
local Checker = require(CAM.Global.Checker);
local Utility = require(CAM.Global.Utility);
local Combat_Util = require(SAM.Services.Combat_Util);
local Combat_presets = require(CAM.Global.Combat_presets);
local u1 = require(SAM.Game_Play.hit_priority_handler).new(script);
local cleanit = require(ReplicatedStorage.Packages.cleanit);
local Config = require(script.Parent.Config);
local u2 = {
    Id = {}
};
local Name = script.Parent.Name;

function u2.Hold(p3: userdata, p4: vector?, p5: table) -- Line: 31
    -- upvalues: EffectsEvent (copy)
    local Character = p3.Character;
    local v6;

    if Character then
        v6 = Character:FindFirstChild("HumanoidRootPart");
    else
        v6 = Character;
    end;

    if v6 == nil then
        return;
    end;

    p5.holdStart = os.clock();
    EffectsEvent.ToAllInRange(v6, "GauntletInit", Character);
end;

function u2.UnHold(u7: userdata, u8: vector?, u9: table) -- Line: 41
    -- upvalues: cleanit (copy), u2 (copy), Utility (copy), Config (copy), ManuelCancel (copy), EffectsEvent (copy), Checker (copy), u1 (copy), Combat_Util (copy), Name (copy), Combat_presets (copy)
    local v10 = u9.CleanIt or cleanit.new();
    u9.CleanIt = v10;
    v10:Clean();
    local v11 = u2.Id[u7.UserId];
    local Character = u7.Character;
    local u12;

    if Character then
        u12 = Character:FindFirstChild("HumanoidRootPart");
    else
        u12 = Character;
    end;

    if u12 == nil then
        return;
    end;

    local valuesfolder = Utility.getvaluesfolder(Character);
    local v13 = Config.HOLD_PAUSE - (os.clock() - (u9.holdStart or 0));
    local math_max_ret = math.max(0, v13);
    local v14, v15 = ManuelCancel.new(u7, math_max_ret + Config.END_AT + 0.5);
    v14:Connect(function() -- Line: 57
        -- upvalues: u2 (ref), u7 (copy), u8 (copy), u9 (copy)
        u2.Id[u7.UserId] = -1;
        u2.Cancel(u7, u8, u9);
    end);
    v10:Add(v15);
    v10:Add(Utility.AddValue(valuesfolder, "pause_gameplay", math_max_ret + Config.END_AT));
    v10:Add(Utility.AddValue(valuesfolder, "iframe", math_max_ret + Config.END_AT));
    v10:Add(Utility.AddValue(valuesfolder, "WalkSpeed", math_max_ret + Config.END_AT, "NumberValue", Config.WALK_SPEED));
    task.wait(math_max_ret + Config.PUNCH_AT);

    if u2.Id[u7.UserId] ~= v11 then
        return;
    end;

    EffectsEvent.ToAllInRange(u12, "Flash Fist VFX", Character, "FlashFist", u12.CFrame);
    local u16 = {};
    Utility.CreateHitbox({
        caster = Character,
        hitboxCFrame = u12.CFrame * Config.PUNCH_HITBOX_OFFSET,
        hitboxSize = Config.PUNCH_HITBOX_SIZE,
        checker = Checker,
        hitPriorityHandler = {
            data = "Choosing_1",
            callback = u1.Exists
        },

        hitDetected = function(p17: userdata, p18: userdata, p19: any) -- Line: 80, Name: hitDetected
            -- upvalues: Combat_Util (ref), Character (copy), Config (ref), u16 (copy), u12 (copy), Name (ref), Combat_presets (ref)
            local Humanoid = p17:FindFirstChild("Humanoid");
            local HumanoidRootPart = p17:FindFirstChild("HumanoidRootPart");

            if Humanoid == nil or HumanoidRootPart == nil then
                return;
            end;

            if p19 == "Perfect" then
                Combat_Util.Perfect(script, Character, p17);

                return;
            end;

            if p19 == "Blocking" then
                Combat_Util.Block(script, Character, p17, Config.PUNCH_BLOCK_BREAK);

                return;
            end;

            if p19 == true then
                table.insert(u16, {
                    model = p17,
                    root = HumanoidRootPart,
                    values = p18
                });
                local LookVector = u12.CFrame.LookVector;
                Combat_Util.Damage(script, Character, p17, {
                    Base = Config.PUNCH_DAMAGE,
                    Skill = Name
                });
                Combat_Util.Add_Strict_Stun(script, Character, p18, Config.PUNCH_STUN);
                Combat_Util.Knockback(script, Character, HumanoidRootPart, Vector3.new(LookVector.X, 0.01, LookVector.Z), Config.PUNCH_STUN);
                Combat_presets.PlayReactAnim(Humanoid, nil, nil);
            end;
        end
    });

    if #u16 == 0 then
        task.wait(Config.END_AT - Config.PUNCH_AT);

        if u2.Id[u7.UserId] ~= v11 then
            return;
        end;

        v10:Clean();

        return;
    end;

    local v20 = Config.END_AT - Config.PUNCH_AT;
    v10:Add(Utility.AddValue(valuesfolder, "skill_stand_still", v20));
    v10:Add(Utility.AddValue(valuesfolder, "NR", v20));
    task.wait(Config.BARRAGE_AT - Config.PUNCH_AT);

    if u2.Id[u7.UserId] ~= v11 then
        return;
    end;

    EffectsEvent.ToAllInRange(u12, "Flash Fist VFX", Character, "Barrage", u12.CFrame);
    local BARRAGE_INTERVAL = Config.BARRAGE_INTERVAL;

    for i = 1, Config.BARRAGE_HIT_COUNT do
        if u2.Id[u7.UserId] ~= v11 then
            return;
        end;

        local v21 = i == Config.BARRAGE_HIT_COUNT;
        local _ = i;

        for _, v in u16 do
            local Humanoid = v.model:FindFirstChild("Humanoid");

            if Humanoid ~= nil and v.root.Parent ~= nil then
                Combat_Util.Damage(script, Character, v.model, {
                    Base = Config.BARRAGE_DAMAGE,
                    Skill = Name
                });
                Combat_presets.PlayReactAnim(Humanoid, nil, nil);

                if v21 then
                    Combat_Util.AddStun(script, Character, v.values, Config.BARRAGE_FINAL_STUN, true);
                    Combat_Util.RagDoll(script, Character, v.values, Config.BARRAGE_FINAL_STUN);
                    Combat_Util.Knockback(script, Character, v.root, u12.CFrame.LookVector * Config.BARRAGE_KNOCKBACK + Vector3.new(0, Config.BARRAGE_KNOCKUP, 0), 0.3);
                else
                    Combat_Util.AddStun(script, Character, v.values, Config.BARRAGE_STUN, true);
                    Combat_Util.Knockback(script, Character, v.root, u12.CFrame.LookVector * 3 + Vector3.new(0, 1, 0), BARRAGE_INTERVAL);
                end;
            end;
        end;

        task.wait(BARRAGE_INTERVAL);
    end;

    if u2.Id[u7.UserId] ~= v11 then
        return;
    end;

    v10:Clean();
end;

function u2.Cancel(p22: userdata, p23: vector?, p24: table) -- Line: 147
    -- upvalues: cleanit (copy), EffectsEvent (copy)
    local v25 = p24.CleanIt or cleanit.new();
    p24.CleanIt = v25;
    local Character = p22.Character;
    local v26;

    if Character then
        v26 = Character:FindFirstChild("HumanoidRootPart");
    else
        v26 = Character;
    end;

    if v26 and Character then
        EffectsEvent.ToAllInRange(v26, "Flash Fist VFX", Character, "Cancel");
    end;

    v25:Clean();
end;

return u2;
-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local CAM = ReplicatedStorage.CAM;
local SAM = ServerStorage.SAM;
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);
local ManuelCancel = require(CAM.Global.Subsets.Gameplay.ManuelCancel);
local Skill_Switch_Adder = require(CAM.Global.Subsets.Gameplay.Skill_Switch_Adder);
local Checker = require(CAM.Global.Checker);
local Utility = require(CAM.Global.Utility);
local RaycastHelper = require(CAM.Global.RaycastHelper);
local Server_Mouse_Pos = require(SAM.Services.Server_Mouse_Pos);
local Combat_Util = require(SAM.Services.Combat_Util);
local Combat_presets = require(CAM.Global.Combat_presets);
local u1 = require(SAM.Game_Play.hit_priority_handler).new(script);
local cleanit = require(ReplicatedStorage.Packages.cleanit);
local Config = require(script.Parent.Config);
local u2 = {
    Id = {}
};
local Name = script.Parent.Name;

function u2.Hold(p3: userdata, p4: vector?, p5: table) -- Line: 34
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

    EffectsEvent.ToAllInRange(v6, "GauntletInit", Character);
end;

function u2.UnHold(u7: userdata, u8: vector?, u9: table) -- Line: 43
    -- upvalues: cleanit (copy), u2 (copy), Utility (copy), ManuelCancel (copy), Config (copy), Name (copy), EffectsEvent (copy), Checker (copy), u1 (copy), Combat_Util (copy), Combat_presets (copy), Skill_Switch_Adder (copy)
    local v10 = u9.CleanIt or cleanit.new();
    u9.CleanIt = v10;
    v10:Clean();
    local v11 = u2.Id[u7.UserId];
    local Character = u7.Character;
    local HumanoidRootPart = Character.HumanoidRootPart;
    local valuesfolder = Utility.getvaluesfolder(Character);
    local v12, v13 = ManuelCancel.new(u7, Config.STAGE1_END + 0.5);
    v12:Connect(function() -- Line: 55
        -- upvalues: u2 (ref), u7 (copy), u8 (copy), u9 (copy)
        u2.Id[u7.UserId] = -1;
        u2.Cancel(u7, u8, u9);
    end);
    v10:Add(v13);
    v10:Add(Utility.AddValue(valuesfolder, "skillsdisabled", Config.STAGE1_END, "StringValue", (`all,except{Name}`)));
    v10:Add(Utility.AddValue(valuesfolder, "iframe", Config.STAGE1_END));
    v10:Add(Utility.AddValue(valuesfolder, "WalkSpeed", Config.STAGE1_END, "NumberValue", Config.WALK_SPEED));
    task.wait(Config.PUNCH_AT);

    if u2.Id[u7.UserId] ~= v11 then
        return;
    end;

    EffectsEvent.ToAllInRange(HumanoidRootPart, "Shatter Step VFX", Character, "Punch", HumanoidRootPart.CFrame);
    local u14 = nil;
    local u15 = {};
    Utility.CreateHitbox({
        caster = Character,
        hitboxCFrame = HumanoidRootPart.CFrame * Config.PUNCH_HITBOX_OFFSET,
        hitboxSize = Config.PUNCH_HITBOX_SIZE,
        checker = Checker,
        hitPriorityHandler = {
            data = "Choosing_1",
            callback = u1.Exists
        },

        hitDetected = function(p16: userdata, p17: userdata, p18: any) -- Line: 78, Name: hitDetected
            -- upvalues: Combat_Util (ref), Character (copy), Config (ref), u14 (ref), u15 (copy), Name (ref), HumanoidRootPart (copy), Combat_presets (ref), EffectsEvent (ref)
            local Humanoid = p16:FindFirstChild("Humanoid");
            local HumanoidRootPart2 = p16:FindFirstChild("HumanoidRootPart");

            if Humanoid == nil or HumanoidRootPart2 == nil then
                return;
            end;

            if p18 == "Perfect" then
                Combat_Util.Perfect(script, Character, p16);

                return;
            end;

            if p18 == "Blocking" then
                Combat_Util.Block(script, Character, p16, Config.PUNCH_BLOCK_BREAK);

                return;
            end;

            if p18 == true then
                u14 = u14 or p16;
                table.insert(u15, p16);
                Combat_Util.Damage(script, Character, p16, {
                    Base = Config.PUNCH_DAMAGE,
                    Skill = Name
                });
                Combat_Util.AddStun(script, Character, p17, Config.PUNCH_STUN);
                Combat_Util.RagDoll(script, Character, p17, Config.PUNCH_RAGDOLL);
                Combat_Util.Knockback(script, Character, HumanoidRootPart2, HumanoidRootPart.CFrame.LookVector * Config.PUNCH_KNOCKBACK + Vector3.new(0, Config.PUNCH_UPWARD, 0), 0.25);
                Combat_presets.PlayReactAnim(Humanoid, nil, nil);
                EffectsEvent.ToAllInRange(HumanoidRootPart, "Normal_Punch_Effect", HumanoidRootPart2, -1);
            end;
        end
    });
    u9.diveTarget = u14;
    u9.capturedTargets = u15;
    local ShatterStepTarget = valuesfolder:FindFirstChild("ShatterStepTarget");

    if ShatterStepTarget then
        ShatterStepTarget:Destroy();
    end;

    if u14 then
        Utility.AddValue(valuesfolder, "ShatterStepTarget", Config.SWITCH_WINDOW + 1, "ObjectValue", u14);
        Skill_Switch_Adder.Add(u7, Name, Config.SWITCH_WINDOW);
    end;

    task.wait(Config.STAGE1_END - Config.PUNCH_AT);

    if u2.Id[u7.UserId] ~= v11 then
        return;
    end;

    v10:Clean();
end;

function u2.Switch(u19: userdata, p20: vector?, u21: table) -- Line: 125
    -- upvalues: cleanit (copy), u2 (copy), Utility (copy), ManuelCancel (copy), Config (copy), Server_Mouse_Pos (copy), Name (copy), EffectsEvent (copy), RaycastHelper (copy), Combat_Util (copy), Checker (copy), u1 (copy)
    local v22 = u21.CleanIt or cleanit.new();
    u21.CleanIt = v22;
    v22:Clean();
    local v23 = u2.Id[u19.UserId];
    local Character = u19.Character;
    local Humanoid = Character.Humanoid;
    local HumanoidRootPart = Character.HumanoidRootPart;
    local valuesfolder = Utility.getvaluesfolder(Character);
    local v24, v25 = ManuelCancel.new(u19, 1.7833333333333334 + Config.SWITCH_ENDLAG + 0.5);
    v24:Connect(function() -- Line: 136
        -- upvalues: u2 (ref), u19 (copy), u21 (copy)
        u2.Id[u19.UserId] = -1;
        u2.Cancel(u19, nil, u21);
    end);
    v22:Add(v25);
    v22:Add(Utility.AddValue(valuesfolder, "pause_gameplay", 1.7833333333333334 + Config.SWITCH_ENDLAG));
    v22:Add(Utility.AddValue(valuesfolder, "iframe", 1.0333333333333334));
    v22:Add(Utility.AddValue(valuesfolder, "skill_stand_still", 1.0333333333333334));
    v22:Add(Utility.AddValue(valuesfolder, "NR", 1.0333333333333334));
    local CFrame2 = HumanoidRootPart.CFrame;
    Server_Mouse_Pos.Create_Pos_Part(Character, Name, 2);
    v22:Add(function() -- Line: 153
        -- upvalues: Server_Mouse_Pos (ref), Character (copy), Name (ref)
        Server_Mouse_Pos.Delete_Pos_Part(Character, Name);
    end);

    local function aimPosition() -- Line: 156
        -- upvalues: u21 (copy), Server_Mouse_Pos (ref), Character (copy), Name (ref)
        local diveTarget = u21.diveTarget;

        if diveTarget then
            diveTarget = diveTarget:FindFirstChild("HumanoidRootPart");
        end;

        if diveTarget then
            return diveTarget.Position;
        end;

        return Server_Mouse_Pos.Find(Character, Name).Position;
    end;

    task.wait(0.03333333333333333);

    if u2.Id[u19.UserId] ~= v23 then
        return;
    end;

    EffectsEvent.ToAllInRange(HumanoidRootPart, "Shatter Step VFX", Character, "Jump", CFrame2);
    task.wait(0.9333333333333333);

    if u2.Id[u19.UserId] ~= v23 then
        return;
    end;

    local function diveDirection() -- Line: 171
        -- upvalues: Utility (ref), CFrame2 (copy), u21 (copy), Server_Mouse_Pos (ref), Character (copy), Name (ref)
        local SafeDirection = Utility.SafeDirection;
        local v26 = CFrame2.Position * Vector3.new(1, 0, 1);
        local diveTarget = u21.diveTarget;

        if diveTarget then
            diveTarget = diveTarget:FindFirstChild("HumanoidRootPart");
        end;

        local v27;

        if diveTarget then
            v27 = diveTarget.Position;
        else
            v27 = Server_Mouse_Pos.Find(Character, Name).Position;
        end;

        return SafeDirection(v26, v27 * Vector3.new(1, 0, 1)) or (CFrame2.LookVector * Vector3.new(1, 0, 1)).Unit;
    end;

    local SafeDirection = Utility.SafeDirection;
    local v28 = CFrame2.Position * Vector3.new(1, 0, 1);
    local diveTarget = u21.diveTarget;

    if diveTarget then
        diveTarget = diveTarget:FindFirstChild("HumanoidRootPart");
    end;

    local v29;

    if diveTarget then
        v29 = diveTarget.Position;
    else
        v29 = Server_Mouse_Pos.Find(Character, Name).Position;
    end;

    local v30 = SafeDirection(v28, v29 * Vector3.new(1, 0, 1)) or (CFrame2.LookVector * Vector3.new(1, 0, 1)).Unit;
    EffectsEvent.ToAllInRange(HumanoidRootPart, "Shatter Step VFX", Character, "Air", CFrame.lookAt(CFrame2.Position, CFrame2.Position + v30));
    task.wait(0.06666666666666667);

    if u2.Id[u19.UserId] ~= v23 then
        return;
    end;

    local SafeDirection2 = Utility.SafeDirection;
    local v31 = CFrame2.Position * Vector3.new(1, 0, 1);
    local diveTarget2 = u21.diveTarget;

    if diveTarget2 then
        diveTarget2 = diveTarget2:FindFirstChild("HumanoidRootPart");
    end;

    local v32;

    if diveTarget2 then
        v32 = diveTarget2.Position;
    else
        v32 = Server_Mouse_Pos.Find(Character, Name).Position;
    end;

    local v33 = SafeDirection2(v31, v32 * Vector3.new(1, 0, 1)) or (CFrame2.LookVector * Vector3.new(1, 0, 1)).Unit;
    local u34 = CFrame2.Position + Vector3.new(0, Config.JUMP_HEIGHT, 0);
    local u35 = CFrame2.Position.Y - Config.DIVE_MAX_DROP;

    local function groundGoal(p36: vector) -- Line: 190
        -- upvalues: u34 (copy), RaycastHelper (ref), Config (ref), Humanoid (copy), HumanoidRootPart (copy), u35 (copy)
        local v37 = workspace:Raycast(Vector3.new(p36.X, u34.Y, p36.Z), Vector3.new(0, -80, 0), RaycastHelper.Crater);
        local v38 = (v37 and v37.Position or p36 - Vector3.new(0, Config.JUMP_HEIGHT, 0)) + Vector3.new(0, Humanoid.HipHeight + HumanoidRootPart.Size.Y / 2, 0);

        if v38.Y < u35 then
            v38 = Vector3.new(v38.X, u35, v38.Z);
        end;

        return v38;
    end;

    local v39 = groundGoal(CFrame2.Position + v33 * Config.DIVE_FORWARD);
    local v40 = workspace:Spherecast(u34, Config.DIVE_PROBE_RADIUS, v39 - u34, RaycastHelper.Crater);

    if v40 then
        v39 = groundGoal(v40.Position + v40.Normal * Config.DIVE_WALL_OFFSET);
    end;

    local CFrame_lookAt_ret = CFrame.lookAt(v39, v39 + v33);
    EffectsEvent.ToAllInRange(HumanoidRootPart, "Shatter Step VFX", Character, "End", CFrame_lookAt_ret);
    local u41 = {};

    local function applyCrash(p42: userdata, p43: userdata, p44: userdata) -- Line: 213
        -- upvalues: u41 (copy), Combat_Util (ref), Character (copy), Config (ref), Name (ref), CFrame_lookAt_ret (copy), EffectsEvent (ref), HumanoidRootPart (copy)
        if u41[p42] then
            return;
        end;

        u41[p42] = true;
        Combat_Util.Damage(script, Character, p42, {
            Base = Config.CRASH_DAMAGE,
            Skill = Name
        });
        Combat_Util.AddStun(script, Character, p44, Config.CRASH_STUN);
        Combat_Util.RagDoll(script, Character, p44, Config.CRASH_RAGDOLL);
        Combat_Util.Knockback(script, Character, p43, CFrame_lookAt_ret.LookVector * Config.CRASH_KNOCKBACK + Vector3.new(0, Config.CRASH_UPWARD, 0), 0.25);
        EffectsEvent.ToAllInRange(HumanoidRootPart, "Normal_Punch_Effect", p43, -1);
    end;

    Utility.CreateHitbox({
        caster = Character,
        hitboxCFrame = CFrame_lookAt_ret * Config.CRASH_HITBOX_OFFSET,
        hitboxSize = Config.CRASH_HITBOX_SIZE,
        checker = Checker,
        hitPriorityHandler = {
            data = "Choosing_1",
            callback = u1.Exists
        },

        hitDetected = function(p45: userdata, p46: userdata, p47: any) -- Line: 235, Name: hitDetected
            -- upvalues: Combat_Util (ref), Character (copy), Config (ref), applyCrash (copy)
            local Humanoid2 = p45:FindFirstChild("Humanoid");
            local HumanoidRootPart2 = p45:FindFirstChild("HumanoidRootPart");

            if Humanoid2 == nil or HumanoidRootPart2 == nil then
                return;
            end;

            if p47 == "Perfect" then
                Combat_Util.Perfect(script, Character, p45);

                return;
            end;

            if p47 == "Blocking" then
                Combat_Util.Block(script, Character, p45, Config.CRASH_BLOCK_BREAK);

                return;
            end;

            if p47 == true then
                applyCrash(p45, HumanoidRootPart2, p46);
            end;
        end
    });

    for _, v in u21.capturedTargets or {} do
        if v.Parent ~= nil then
            local Humanoid2 = v:FindFirstChild("Humanoid");
            local HumanoidRootPart2 = v:FindFirstChild("HumanoidRootPart");
            local valuesfolder2 = Utility.getvaluesfolder(v);

            if Humanoid2 and (HumanoidRootPart2 and valuesfolder2) then
                applyCrash(v, HumanoidRootPart2, valuesfolder2);
            end;
        end;
    end;

    task.wait(Config.SWITCH_ENDLAG);

    if u2.Id[u19.UserId] ~= v23 then
        return;
    end;

    v22:Clean();
end;

function u2.Cancel(p48: userdata, p49: vector?, p50: table) -- Line: 267
    -- upvalues: cleanit (copy), EffectsEvent (copy)
    local v51 = p50.CleanIt or cleanit.new();
    p50.CleanIt = v51;
    local Character = p48.Character;
    local v52;

    if Character then
        v52 = Character:FindFirstChild("HumanoidRootPart");
    else
        v52 = Character;
    end;

    if v52 and Character then
        EffectsEvent.ToAllInRange(v52, "Shatter Step VFX", Character, "Cancel");
    end;

    v51:Clean();
end;

return u2;
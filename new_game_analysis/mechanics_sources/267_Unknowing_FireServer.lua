-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));
local u1 = {
    Id = {}
};
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Utility"));
local Checker = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Checker"));
require(game.ServerStorage:WaitForChild("SAM"):WaitForChild("Services"):WaitForChild("Server_Mouse_Pos"));
local u2 = require(game.ServerStorage:WaitForChild("SAM"):WaitForChild("Game_Play"):WaitForChild("hit_priority_handler")).new(script);
local ManuelCancel = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.ManuelCancel);
local Combat_Util = require(ServerStorage.SAM.Services.Combat_Util);
local ImpactSounds = require(ServerStorage.SAM.Utility.ImpactSounds);
local Config = require(script.Parent.Config);
game:GetService("CollectionService");
local ReplicatedStorage2 = game:GetService("ReplicatedStorage");
local Combat_presets = require(ReplicatedStorage2.CAM.Global.Combat_presets);
local _ = table.find;
local _ = table.remove;
local _ = Vector3.new;
local _ = tick;
local EffectsEvent = require(ReplicatedStorage2.Communication.ServerAndClient.Effects.EffectsEvent);
local Utility = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Utility"));
local _ = table.find;
local _ = table.remove;

function u1.Hold(p3) -- Line: 31
    -- upvalues: u1 (copy), EffectsEvent (copy)
    local Character = p3.Character;
    Character:FindFirstChild("HumanoidRootPart");
    Character:FindFirstChild("Humanoid");
    local v4 = u1.Id[p3.UserId];
    task.wait(0.13);

    if v4 == u1.Id[p3.UserId] then
        EffectsEvent.ToAllInRange(p3, "Unknowing FireVFX", p3.Character, "Start");
    end;
end;

local RaycastHelper = require(ReplicatedStorage2.CAM.Global.RaycastHelper);

function u1.UnHold(u5, u6, u7) -- Line: 47
    -- upvalues: u1 (copy), Utility (copy), RaycastHelper (copy), Config (copy), EffectsEvent (copy), ManuelCancel (copy), Checker (copy), u2 (copy), Combat_Util (copy), Combat_presets (copy), ImpactSounds (copy)
    if u5.Character == nil then
        return;
    end;

    local v8 = u1.Id[u5.UserId];
    local Character = u5.Character;

    if Character == nil then
        return;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
    local Humanoid = Character:FindFirstChild("Humanoid");

    if HumanoidRootPart == nil or (Humanoid == nil or u6 == nil) then
        return;
    end;

    local valuesfolder = Utility.getvaluesfolder(Character);
    local CFrame = HumanoidRootPart.CFrame;
    local Position = CFrame.Position;
    local v9, _, _, _ = RaycastHelper.MaximizeRayServer(Character, Position, u6, Config.AIM_RANGE, true, 5, 7, 3);
    local _ = (v9 - Position).unit;
    local BoolValue = Instance.new("BoolValue");
    BoolValue.Name = "NOMouvementlines";
    BoolValue.Parent = valuesfolder;
    EffectsEvent.ToAllInRange(u5, "Unknowing FireVFX", u5.Character, "Release", CFrame);
    u7.NR = Utility.AddValue(valuesfolder, "NR", Config.CAST_LOCK_DURATION);
    u7.pause_gameplay = Utility.AddValue(valuesfolder, "pause_gameplay", Config.CAST_LOCK_DURATION);
    local v10, v11 = ManuelCancel.new(u5, Config.CAST_LOCK_DURATION, nil, script.Parent.Name);
    v10:Connect(function() -- Line: 72
        -- upvalues: u1 (ref), u5 (copy), u6 (copy), u7 (copy)
        u1.Id[u5.UserId] = -1;
        u1.Cancel(u5, u6, u7);
    end);
    task.wait(Config.SLASH_AT);
    BoolValue:Destroy();

    if u1.Id[u5.UserId] ~= v8 then
        return;
    end;

    EffectsEvent.ToAllInRange(u5, "Unknowing FireVFX", u5.Character, "Slash");
    local u12 = false;
    local u13 = {};
    Utility.CreateHitbox({
        TreeDestruction = true,
        caster = Character,
        hitboxCFrame = HumanoidRootPart.CFrame,
        hitboxSize = Config.SLASH_HITBOX_SIZE,
        checker = Checker,
        hitPriorityHandler = {
            data = "Choosing_1",
            callback = u2.Exists
        },

        hitDetected = function(p14: userdata, p15: any, p16: any) -- Line: 92, Name: hitDetected
            -- upvalues: Combat_Util (ref), Character (copy), Config (ref), u13 (copy), HumanoidRootPart (copy), u12 (ref), Combat_presets (ref)
            if p14 then
                local Humanoid2 = p14:FindFirstChild("Humanoid");
                local RootPart = Humanoid2.RootPart;

                if p16 == "Blocking" then
                    Combat_Util.Block(script, Character, p14, Config.SLASH_BLOCK_BREAK);

                    return;
                end;

                if p16 == "Perfect" then
                    Combat_Util.Perfect(script, Character, p14);

                    return;
                end;

                if p16 == true then
                    table.insert(u13, p14);
                    local v17 = HumanoidRootPart.CFrame.LookVector * Config.SLASH_KNOCKBACK + vector.create(0, Config.SLASH_KNOCKUP, 0);
                    u12 = true;
                    Combat_Util.AddStun(script, Character, p15, Config.SLASH_STUN);
                    Combat_Util.Damage(script, Character, p14, {
                        Base = Config.SLASH_DAMAGE,
                        Skill = script.Parent.Name
                    });
                    Combat_Util.Knockback(script, Character, RootPart, v17, 1);
                    Combat_presets.PlayReactAnim(Humanoid2);
                end;
            end;
        end,

        After = function(p18, p19) -- Line: 113, Name: After
            -- upvalues: ImpactSounds (ref), Character (copy)
            if p18 then
                ImpactSounds.Play(Character, script.Parent.Name, p19[1]);
            end;
        end
    });
    task.wait(Config.COMBO_START_DELAY);

    if u1.Id[u5.UserId] ~= v8 then
        return;
    end;

    if u12 == false then
        u1.Cancel(u5, u6, u7);

        return;
    end;

    local Position2 = HumanoidRootPart.Position;
    u7.Anim = Humanoid.Animator:LoadAnimation(script.Connect);
    u7.Anim:Play();
    task.wait(Config.UPSLASH1_DELAY);

    if u1.Id[u5.UserId] ~= v8 then
        return;
    end;

    EffectsEvent.ToAllInRange(u5, "Unknowing FireVFX", u5.Character, "UpSlash1");
    u12 = false;
    local u20 = {};
    Utility.CreateHitbox({
        caster = Character,
        hitboxCFrame = HumanoidRootPart.CFrame * Config.UPSLASH_HITBOX_OFFSET,
        hitboxSize = Config.UPSLASH1_HITBOX_SIZE,
        checker = Checker,
        hitPriorityHandler = {
            data = "Choosing_1",
            callback = u2.Exists
        },

        hitDetected = function(p21: userdata, p22: any, p23: any) -- Line: 138, Name: hitDetected
            -- upvalues: Combat_Util (ref), Character (copy), Config (ref), u12 (ref), u20 (copy), HumanoidRootPart (copy), Position2 (copy), Combat_presets (ref)
            if p21 then
                local Humanoid2 = p21:FindFirstChild("Humanoid");
                local RootPart = Humanoid2.RootPart;

                if p23 == "Blocking" then
                    Combat_Util.Block(script, Character, p21, Config.UPSLASH_BLOCK_BREAK);

                    return;
                end;

                if p23 == "Perfect" then
                    Combat_Util.Perfect(script, Character, p21);

                    return;
                end;

                if p23 == true then
                    u12 = true;
                    u20[p21] = true;
                    Combat_Util.Add_air_combo_bp(RootPart, HumanoidRootPart, Config.UPDRAFT_HEIGHT, Position2);
                    Combat_Util.AddStun(script, Character, p22, Config.UPSLASH_STUN);
                    Combat_Util.Damage(script, Character, p21, {
                        Base = Config.UPSLASH_DAMAGE,
                        Skill = script.Parent.Name
                    });
                    Combat_presets.PlayReactAnim(Humanoid2);
                end;
            end;
        end,

        After = function(p24, p25) -- Line: 159, Name: After
            -- upvalues: u13 (copy), u20 (copy), Checker (ref), Character (copy), Utility (ref), u12 (ref), Combat_Util (ref), HumanoidRootPart (copy), Config (ref), Position2 (copy), Combat_presets (ref), ImpactSounds (ref)
            local v26 = p25[1];

            for _, v in ipairs(u13) do
                local HumanoidRootPart2 = v:FindFirstChild("HumanoidRootPart");

                if u20[v] == nil and (HumanoidRootPart2 ~= nil and Checker.check_victim(script, Character, v) == true) then
                    local valuesfolder2 = Utility.getvaluesfolder(v);
                    u12 = true;
                    u20[v] = true;
                    Combat_Util.Add_air_combo_bp(HumanoidRootPart2, HumanoidRootPart, Config.UPDRAFT_HEIGHT, Position2);
                    Combat_Util.AddStun(script, Character, valuesfolder2, Config.UPSLASH_STUN);
                    Combat_Util.Damage(script, Character, v, {
                        Base = Config.UPSLASH_DAMAGE,
                        Skill = script.Parent.Name
                    });
                    v26 = v26 or v;
                    local Humanoid2 = v:FindFirstChild("Humanoid");

                    if Humanoid2 then
                        Combat_presets.PlayReactAnim(Humanoid2);
                    end;
                end;
            end;

            if v26 ~= nil then
                ImpactSounds.Play(Character, script.Parent.Name, v26);
            end;

            if u12 == true then
                Combat_Util.Add_air_combo_bp(HumanoidRootPart, HumanoidRootPart, Config.UPDRAFT_HEIGHT, Position2);
            end;
        end
    });
    task.wait(Config.UPSLASH2_DELAY);

    if u1.Id[u5.UserId] ~= v8 then
        return;
    end;

    if u12 == false then
        u1.Cancel(u5, u6, u7);

        return;
    end;

    EffectsEvent.ToAllInRange(u5, "Unknowing FireVFX", u5.Character, "UpSlash2");
    u12 = false;
    local u27 = {};
    Utility.CreateHitbox({
        caster = Character,
        hitboxCFrame = HumanoidRootPart.CFrame * Config.UPSLASH_HITBOX_OFFSET,
        hitboxSize = Config.UPSLASH2_HITBOX_SIZE,
        checker = Checker,
        hitPriorityHandler = {
            data = "Choosing_1",
            callback = u2.Exists
        },

        hitDetected = function(p28: userdata, p29: any, p30: any) -- Line: 203, Name: hitDetected
            -- upvalues: Combat_Util (ref), Character (copy), Config (ref), u12 (ref), u27 (copy), HumanoidRootPart (copy), Combat_presets (ref)
            if p28 then
                local Humanoid2 = p28:FindFirstChild("Humanoid");
                local RootPart = Humanoid2.RootPart;

                if p30 == "Blocking" then
                    Combat_Util.Block(script, Character, p28, Config.UPSLASH_BLOCK_BREAK);

                    return;
                end;

                if p30 == "Perfect" then
                    Combat_Util.Perfect(script, Character, p28);

                    return;
                end;

                if p30 == true then
                    u12 = true;
                    u27[p28] = true;
                    Combat_Util.Add_air_combo_bp(RootPart, HumanoidRootPart, Config.UPDRAFT_HEIGHT);
                    Combat_Util.AddStun(script, Character, p29, Config.UPSLASH_STUN);
                    Combat_Util.Damage(script, Character, p28, {
                        Base = Config.UPSLASH_DAMAGE,
                        Skill = script.Parent.Name
                    });
                    Combat_presets.PlayReactAnim(Humanoid2);
                end;
            end;
        end,

        After = function(p31, p32) -- Line: 224, Name: After
            -- upvalues: u13 (copy), u27 (copy), Checker (ref), Character (copy), Utility (ref), u12 (ref), Combat_Util (ref), HumanoidRootPart (copy), Config (ref), Combat_presets (ref), ImpactSounds (ref)
            local v33 = p32[1];

            for _, v in ipairs(u13) do
                local HumanoidRootPart2 = v:FindFirstChild("HumanoidRootPart");

                if u27[v] == nil and (HumanoidRootPart2 ~= nil and Checker.check_victim(script, Character, v) == true) then
                    local valuesfolder2 = Utility.getvaluesfolder(v);
                    u12 = true;
                    u27[v] = true;
                    Combat_Util.Add_air_combo_bp(HumanoidRootPart2, HumanoidRootPart, Config.UPDRAFT_HEIGHT);
                    Combat_Util.AddStun(script, Character, valuesfolder2, Config.UPSLASH_STUN);
                    Combat_Util.Damage(script, Character, v, {
                        Base = Config.UPSLASH_DAMAGE,
                        Skill = script.Parent.Name
                    });
                    v33 = v33 or v;
                    local Humanoid2 = v:FindFirstChild("Humanoid");

                    if Humanoid2 then
                        Combat_presets.PlayReactAnim(Humanoid2);
                    end;
                end;
            end;

            if v33 ~= nil then
                ImpactSounds.Play(Character, script.Parent.Name, v33);
            end;

            if u12 == true then
                Combat_Util.Add_air_combo_bp(HumanoidRootPart, HumanoidRootPart, Config.UPDRAFT_HEIGHT);
            end;
        end
    });
    task.wait(Config.RECOVERY_DUR);

    if u1.Id[u5.UserId] ~= v8 then
        return;
    end;

    u7.NR:Destroy();
    u7.pause_gameplay:Destroy();
    v11();
end;

function u1.Cancel(p34, p35, p36) -- Line: 261
    if p34.Character == nil then
        return;
    end;

    if p36.NR ~= nil then
        p36.NR:Destroy();
        p36.NR = nil;
    end;

    if p36.Anim then
        p36.Anim:Stop();
        p36.Anim = nil;
    end;

    if p36.pause_gameplay ~= nil then
        p36.pause_gameplay:Destroy();
        p36.pause_gameplay = nil;
    end;
end;

return u1;
-- Decompiled with Potassium's decompiler.

game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("CollectionService");
local CAM = ReplicatedStorage.CAM;
local SAM = ServerStorage.SAM;
local Checker = require(CAM.Global.Checker);
local Utility = require(CAM.Global.Utility);
local RaycastHelper = require(CAM.Global.RaycastHelper);
local Combat_presets = require(CAM.Global.Combat_presets);
require(CAM.DebrisModule);
require(SAM.Utility.SkillStorage);
local Combat_Util = require(SAM.Services.Combat_Util);
local ImpactSounds = require(SAM.Utility.ImpactSounds);
local u1 = require(SAM.Game_Play.hit_priority_handler).new(script);
local ManuelCancel = require(CAM.Global.Subsets.Gameplay.ManuelCancel);
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);
local Config = require(script.Parent.Config);
local u2 = {
    Id = {}
};

function u2.Hold(u3: userdata, p4: vector, p5: table) -- Line: 36
    -- upvalues: u2 (copy), Config (copy), EffectsEvent (copy)
    local Character = u3.Character;
    local _ = Character:FindFirstChild("Humanoid").RootPart;
    local u6 = u2.Id[u3.UserId];
    p5.startClock = os.clock();
    task.delay(Config.HOLD_DURATION, function() -- Line: 45
        -- upvalues: u2 (ref), u3 (copy), u6 (copy), EffectsEvent (ref), Character (copy)
        if u2.Id[u3.UserId] == u6 then
            EffectsEvent.ToAllInRange(u3, "Stone GrabVfx", Character, "Start");
        end;
    end);
end;

require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.CharGrabPosCorrector);

function u2.Counter(u7, p8, u9) -- Line: 53
    -- upvalues: Utility (copy), RaycastHelper (copy), Config (copy), EffectsEvent (copy), Checker (copy), Combat_Util (copy)
    if u7 == nil or u7.Character == nil then
        return;
    end;

    local Character = u7.Character;
    local HumanoidRootPart = u7.Character.HumanoidRootPart;
    local _ = HumanoidRootPart.CFrame;
    local HumanoidRootPart2 = u9.HumanoidRootPart;
    local valuesfolder = Utility.getvaluesfolder(u9);
    local valuesfolder2 = Utility.getvaluesfolder(u7);
    local Humanoid = Character:FindFirstChild("Humanoid");
    local Humanoid2 = u9:FindFirstChild("Humanoid");
    local u10 = RaycastHelper.ResolveGrabPin(HumanoidRootPart.Position, HumanoidRootPart.CFrame, Config.GRAB_WALL_CLEARANCE);
    EffectsEvent.ToAllInRange(u7, "Stone GrabVfx", Character, "Hit", u9);
    Utility.lock(HumanoidRootPart, u10, Config.GRAB_DURATION);
    Humanoid.Animator:LoadAnimation(script.StoneGrabUser):Play();
    Utility.AddValue(valuesfolder2, "pause_gameplay", Config.GRAB_DURATION);
    Utility.AddValue(valuesfolder2, "iframe", Config.GRAB_DURATION);
    task.delay(Config.SLAM_VFX_AT, function() -- Line: 75
        -- upvalues: Character (copy), HumanoidRootPart (copy), EffectsEvent (ref), u7 (copy)
        if Character == nil or (HumanoidRootPart == nil or HumanoidRootPart.Parent == nil) then
            return;
        end;

        EffectsEvent.ToAllInRange(u7, "Stone GrabVfx", Character, "Slam");
    end);
    local Animator = Humanoid2:FindFirstChild("Animator");

    if Animator then
        Animator:LoadAnimation(script.StoneGrabTarget):Play();
    end;

    local u11 = Utility.AddValue(valuesfolder, "noragdoll", Config.GRAB_DURATION);
    local u12 = Utility.lock(HumanoidRootPart2, u10 * Config.GRAB_VICTIM_OFFSET, Config.GRAB_DURATION);
    local u13 = Utility.AddValue(valuesfolder, "pause_gameplay", Config.GRAB_DURATION);
    local u14 = Utility.AddValue(valuesfolder, "iframe", Config.GRAB_DURATION, "StringValue", u7.Name);
    local u15 = Utility.AddValue(valuesfolder, "InvisibleItem", Config.GRAB_DURATION, "StringValue", "all");
    task.delay(Config.SLAM_AT, function() -- Line: 92
        -- upvalues: Checker (ref), Character (copy), u9 (copy), u10 (ref), Config (ref), u12 (ref), u13 (ref), u14 (ref), u11 (ref), u15 (ref), Combat_Util (ref), valuesfolder (copy), HumanoidRootPart2 (copy)
        if Checker.check_victim(script, Character, u9) ~= nil then
            local v16 = u10.lookVector * Config.SLAM_KNOCKBACK + vector.create(0, Config.SLAM_KNOCKUP, 0);

            if u12 ~= nil then
                u12:Destroy();
                u12 = nil;
            end;

            if u13 ~= nil then
                u13:Destroy();
                u13 = nil;
            end;

            if u14 ~= nil then
                u14:Destroy();
                u14 = nil;
            end;

            if u11 ~= nil then
                u11:Destroy();
                u11 = nil;
            end;

            if u15 ~= nil then
                u15:Destroy();
                u15 = nil;
            end;

            Combat_Util.AddStun(script, Character, valuesfolder, Config.SLAM_STUN);
            Combat_Util.Damage(script, Character, u9, {
                Base = Config.SLAM_DAMAGE,
                Skill = script.Parent.Name
            });
            Combat_Util.RagDoll(script, Character, valuesfolder, Config.SLAM_RAGDOLL);
            Combat_Util.Knockback(script, Character, HumanoidRootPart2, v16, Config.SLAM_KNOCKBACK_DURATION);
        end;
    end);
end;

function u2.UnHold(u17: userdata, u18: vector, u19: table) -- Line: 126
    -- upvalues: Utility (copy), u2 (copy), ManuelCancel (copy), Config (copy), EffectsEvent (copy), Checker (copy), u1 (copy), Combat_Util (copy), Combat_presets (copy), ImpactSounds (copy), RaycastHelper (copy)
    local Character = u17.Character;
    local valuesfolder = Utility.getvaluesfolder(Character);
    local Humanoid = Character:FindFirstChild("Humanoid");
    local RootPart = Humanoid.RootPart;
    local v20 = os.clock() - u19.startClock;
    local u21 = u2.Id[u17.UserId];
    local v22, v23 = ManuelCancel.new(u17, 1.5);
    v22:Connect(function() -- Line: 141
        -- upvalues: u21 (ref), u2 (ref), u17 (copy), u18 (copy), u19 (copy)
        u21 = -1;
        u2.Cancel(u17, u18, u19);
    end);

    if v20 < Config.HOLD_DURATION then
        task.wait(Config.WALL_STARTUP);

        if u2.Id[u17.UserId] ~= u21 then
            return;
        end;

        EffectsEvent.ToAllInRange(u17, "Stone WallVFX", Character, "Wall");
        local v24 = RootPart.CFrame * Config.WALL_HITBOX_OFFSET;
        local u25 = {};
        Utility.CreateHitbox({
            caster = Character,
            hitboxCFrame = v24,
            hitboxSize = Config.WALL_HITBOX_SIZE,
            checker = Checker,
            hitPriorityHandler = {
                data = "Choosing_1",
                callback = u1.Exists
            },

            hitDetected = function(p26: userdata, p27: any, p28: any) -- Line: 161, Name: hitDetected
                -- upvalues: Combat_Util (ref), Character (copy), Config (ref), RootPart (copy), u25 (copy), Combat_presets (ref)
                if p26 then
                    local Humanoid2 = p26:FindFirstChild("Humanoid");
                    local RootPart2 = Humanoid2.RootPart;

                    if p28 == "Blocking" then
                        Combat_Util.Block(script, Character, p26, Config.WALL_BLOCK_BREAK);
                        Combat_Util.Knockback(script, Character, RootPart2, RootPart.CFrame.lookVector * Config.WALL_BLOCK_KNOCKBACK, 0.2);

                        return;
                    end;

                    if p28 == "Perfect" then
                        Combat_Util.Perfect(script, Character, p26);

                        return;
                    end;

                    if p28 == true then
                        table.insert(u25, p26);
                        local v29 = RootPart.CFrame.LookVector * Config.WALL_KNOCKBACK + vector.create(0, Config.WALL_KNOCKUP, 0);
                        Combat_Util.AddStun(script, Character, p27, Config.WALL_STUN);
                        Combat_Util.Damage(script, Character, p26, {
                            Base = Config.WALL_DAMAGE,
                            Skill = script.Parent.Name
                        });
                        Combat_Util.Knockback(script, Character, RootPart2, v29, Config.WALL_KNOCKBACK_DURATION);
                        Combat_presets.PlayReactAnim(Humanoid2);
                    end;
                end;
            end,

            After = function(p30, p31) -- Line: 183, Name: After
                -- upvalues: ImpactSounds (ref), Character (copy)
                if p30 then
                    ImpactSounds.Play(Character, script.Parent.Name, p31[1]);
                end;
            end
        });
        task.wait(Config.BREAK_DELAY);

        if u2.Id[u17.UserId] ~= u21 then
            return;
        end;

        EffectsEvent.ToAllInRange(u17, "Stone WallVFX", Character, "Break");
        Utility.CreateHitbox({
            caster = Character,
            hitboxCFrame = v24 * Config.BREAK_HITBOX_OFFSET,
            hitboxSize = Config.BREAK_HITBOX_SIZE,
            targets = u25,
            checker = Checker,
            hitPriorityHandler = {
                data = "Choosing_1",
                callback = u1.Exists
            },

            hitDetected = function(p32: userdata, p33: any, p34: any) -- Line: 199, Name: hitDetected
                -- upvalues: Combat_Util (ref), Character (copy), Config (ref), RootPart (copy), u25 (copy), Utility (ref)
                if p32 then
                    local RootPart2 = p32:FindFirstChild("Humanoid").RootPart;

                    if p34 == "Blocking" then
                        Combat_Util.Block(script, Character, p32, Config.BREAK_BLOCK_BREAK);
                        Combat_Util.Knockback(script, Character, RootPart2, RootPart.CFrame.lookVector * Config.BREAK_BLOCK_KNOCKBACK, 0.2);

                        return;
                    end;

                    if p34 == "Perfect" then
                        Combat_Util.Perfect(script, Character, p32);

                        return;
                    end;

                    if p34 == true then
                        table.insert(u25, p32);
                        local v35 = RootPart.CFrame.LookVector * Config.BREAK_KNOCKBACK + vector.create(0, Config.BREAK_KNOCKUP, 0);
                        Combat_Util.AddStun(script, Character, p33, Config.BREAK_STUN);
                        Combat_Util.Damage(script, Character, p32, {
                            Base = Config.BREAK_DAMAGE,
                            Skill = script.Parent.Name
                        });
                        Combat_Util.Knockback(script, Character, RootPart2, v35, Config.BREAK_KNOCKBACK_DURATION);
                        Combat_Util.RagDoll(script, Character, p33, Config.BREAK_RAGDOLL);
                        Utility.AddTimedValue(p33, "PierceBlock", Config.BREAK_PIERCE_DURATION):SetAttribute("Skill", script.Parent.Name);
                    end;
                end;
            end,

            After = function(p36, p37) -- Line: 222, Name: After
                -- upvalues: ImpactSounds (ref), Character (copy)
                if p36 then
                    ImpactSounds.Play(Character, script.Parent.Name, p37[1]);
                end;
            end
        });
    else
        local u38 = nil;
        local u39 = 0;
        Utility.CreateHitbox({
            caster = Character,
            hitboxCFrame = RootPart.CFrame * Config.GRAB_HITBOX_OFFSET,
            hitboxSize = Config.GRAB_HITBOX_SIZE,

            After = function() -- Line: 233, Name: After
                -- upvalues: u39 (ref), EffectsEvent (ref), u17 (copy), Character (copy)
                if u39 == 0 then
                    EffectsEvent.ToAllInRange(u17, "Stone GrabVfx", Character, "Miss");
                end;
            end,

            checker = Checker,
            hitPriorityHandler = {
                data = "Choosing_1",
                callback = u1.Exists
            },

            hitDetected = function(u40: userdata, u41: any, p42: any, p43: any) -- Line: 241, Name: hitDetected
                -- upvalues: Combat_Util (ref), Character (copy), Config (ref), u39 (ref), u38 (ref), RaycastHelper (ref), RootPart (copy), EffectsEvent (ref), u17 (copy), Utility (ref), Humanoid (copy), valuesfolder (copy), Checker (ref)
                if u40 then
                    local Humanoid2 = u40:FindFirstChild("Humanoid");
                    local RootPart2 = Humanoid2.RootPart;

                    if p42 == "Blocking" then
                        Combat_Util.Block(script, Character, u40, Config.GRAB_BLOCK_BREAK);

                        return;
                    end;

                    if p42 == "Perfect" then
                        Combat_Util.Perfect(script, Character, u40);

                        return;
                    end;

                    if p42 == true then
                        u39 = u39 + 1;

                        if u39 == 1 then
                            u38 = RaycastHelper.ResolveGrabPin(RootPart.Position, RootPart.CFrame, Config.GRAB_WALL_CLEARANCE);
                            EffectsEvent.ToAllInRange(u17, "Stone GrabVfx", Character, "Hit", u40);
                            Utility.lock(RootPart, u38, Config.GRAB_DURATION);
                            Humanoid.Animator:LoadAnimation(script.StoneGrabUser):Play();
                            Utility.AddValue(valuesfolder, "pause_gameplay", Config.GRAB_DURATION);
                            Utility.AddValue(valuesfolder, "iframe", Config.GRAB_DURATION);
                            task.delay(Config.SLAM_VFX_AT, function() -- Line: 266
                                -- upvalues: Character (ref), RootPart (ref), EffectsEvent (ref), u17 (ref)
                                if Character == nil or (RootPart == nil or RootPart.Parent == nil) then
                                    return;
                                end;

                                EffectsEvent.ToAllInRange(u17, "Stone GrabVfx", Character, "Slam");
                            end);
                        end;

                        local Animator = Humanoid2:FindFirstChild("Animator");

                        if Animator then
                            Animator:LoadAnimation(script.StoneGrabTarget):Play();
                        end;

                        local u44 = Utility.AddValue(u41, "noragdoll", Config.GRAB_DURATION);
                        local u45 = Utility.AddValue(u41, "InvisibleItem", Config.GRAB_DURATION, "StringValue", "all");
                        local u46 = Utility.lock(RootPart2, u38 * Config.GRAB_VICTIM_OFFSET, Config.GRAB_DURATION);
                        local u47 = Utility.AddValue(u41, "pause_gameplay", Config.GRAB_DURATION);
                        local u48 = Utility.AddValue(u41, "iframe", Config.GRAB_DURATION, "StringValue", u17.Name);
                        task.delay(Config.SLAM_AT, function() -- Line: 283
                            -- upvalues: Checker (ref), Character (ref), u40 (copy), u38 (ref), Config (ref), u46 (ref), u45 (copy), u47 (ref), u48 (ref), u44 (ref), Combat_Util (ref), u41 (copy), RootPart2 (copy)
                            if Checker.check_victim(script, Character, u40) ~= nil then
                                local v49 = u38.lookVector * Config.SLAM_KNOCKBACK + vector.create(0, Config.SLAM_KNOCKUP, 0);

                                if u46 ~= nil then
                                    u46:Destroy();
                                    u46 = nil;
                                end;

                                if u45 ~= nil then
                                    u45:Destroy();
                                end;

                                if u47 ~= nil then
                                    u47:Destroy();
                                    u47 = nil;
                                end;

                                if u48 ~= nil then
                                    u48:Destroy();
                                    u48 = nil;
                                end;

                                if u44 ~= nil then
                                    u44:Destroy();
                                    u44 = nil;
                                end;

                                Combat_Util.AddStun(script, Character, u41, Config.SLAM_STUN);
                                Combat_Util.Damage(script, Character, u40, {
                                    Base = Config.SLAM_DAMAGE,
                                    Skill = script.Parent.Name
                                });
                                Combat_Util.RagDoll(script, Character, u41, Config.SLAM_RAGDOLL);
                                Combat_Util.Knockback(script, Character, RootPart2, v49, Config.SLAM_KNOCKBACK_DURATION);
                            end;
                        end);
                    end;
                end;
            end
        });
    end;

    v23();
end;

function u2.Cancel(p50: userdata, p51: vector, p52: table) -- Line: 326
    -- upvalues: EffectsEvent (copy)
    if p50.Character == nil then
        return;
    end;

    EffectsEvent.ToAllInRange(p50, "Stone GrabVfx", p50.Character, "Cancel");
end;

return u2;
-- Decompiled with Potassium's decompiler.

game:GetService("ReplicatedStorage");
game:GetService("ServerStorage");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
game:GetService("CollectionService");
local CAM = ReplicatedStorage.CAM;
local SAM = ServerStorage.SAM;
local Checker = require(CAM.Global.Checker);
local Utility = require(CAM.Global.Utility);
local Combat_presets = require(CAM.Global.Combat_presets);
local DebrisModule = require(CAM.DebrisModule);
require(SAM.Utility.SkillStorage);
local Combat_Util = require(SAM.Services.Combat_Util);
local u1 = require(SAM.Game_Play.hit_priority_handler).new(script);
local ManuelCancel = require(CAM.Global.Subsets.Gameplay.ManuelCancel);
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);
local Config = require(script.Parent.Config);
local u2 = {
    Id = {}
};

function u2.Hold(u3: userdata, p4: vector, p5: table) -- Line: 35
    -- upvalues: u2 (copy), Config (copy), EffectsEvent (copy), Utility (copy), Checker (copy), u1 (copy), Combat_Util (copy), Combat_presets (copy)
    local Character = u3.Character;
    local RootPart = Character:FindFirstChild("Humanoid").RootPart;
    local u6 = u2.Id[u3.UserId];
    p5.startClock = os.clock();
    task.delay(Config.HOLD_STARTUP, function() -- Line: 43
        -- upvalues: u2 (ref), u3 (copy), u6 (copy), EffectsEvent (ref), Character (copy), Utility (ref), RootPart (copy), Config (ref), Checker (ref), u1 (ref), Combat_Util (ref), Combat_presets (ref)
        if u2.Id[u3.UserId] == u6 then
            EffectsEvent.ToAllInRange(u3, "Arcs Of JustiveVFX", Character, "Start");
        end;

        while u2.Id[u3.UserId] == u6 do
            Utility.CreateHitbox({
                caster = Character,
                hitboxCFrame = RootPart.CFrame,
                hitboxSize = Config.TICK_HITBOX_SIZE,
                checker = Checker,
                hitPriorityHandler = {
                    data = "Choosing_1",
                    callback = u1.Exists
                },

                hitDetected = function(p7: userdata, p8: any, p9: any) -- Line: 57, Name: hitDetected
                    -- upvalues: Combat_Util (ref), Character (ref), Config (ref), RootPart (ref), EffectsEvent (ref), u3 (ref), Combat_presets (ref)
                    if p7 then
                        local Humanoid = p7:FindFirstChild("Humanoid");
                        local RootPart2 = Humanoid.RootPart;

                        if p9 == "Blocking" then
                            Combat_Util.Block(script, Character, p7, Config.TICK_BLOCK_BREAK);
                            Combat_Util.Knockback(script, Character, RootPart2, RootPart.CFrame.lookVector * Config.TICK_BLOCK_KNOCKBACK, 0.2);

                            return;
                        end;

                        if p9 == "Perfect" then
                            Combat_Util.Perfect(script, Character, p7);

                            return;
                        end;

                        if p9 == true then
                            local v10 = RootPart.CFrame.LookVector * Config.TICK_KNOCKBACK + vector.create(0, Config.TICK_KNOCKUP, 0);
                            EffectsEvent.ToAllInRange(u3, "Normal_Sword_Slash_Effect", RootPart2, -1);
                            Combat_Util.AddStun(script, Character, p8, Config.TICK_STUN);
                            Combat_Util.Damage(script, Character, p7, {
                                Base = Config.TICK_DAMAGE,
                                Skill = script.Parent.Name
                            });
                            Combat_Util.Knockback(script, Character, RootPart2, v10, Config.TICK_KNOCKBACK_DURATION);
                            Combat_presets.PlayReactAnim(Humanoid);
                        end;
                    end;
                end
            });
            task.wait(Config.TICK_INTERVAL);
        end;
    end);
end;

local CharGrabPosCorrector = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.CharGrabPosCorrector);
local Cutscene_camera_handler = require(ServerStorage.SAM.Game_Play.Cutscene_camera_handler);

function u2.UnHold(u11: userdata, u12: vector, u13: table) -- Line: 86
    -- upvalues: Utility (copy), u2 (copy), ManuelCancel (copy), Config (copy), Checker (copy), EffectsEvent (copy), u1 (copy), Combat_Util (copy), DebrisModule (copy), Cutscene_camera_handler (copy), CharGrabPosCorrector (copy), CAM (copy)
    local Character = u11.Character;
    local valuesfolder = Utility.getvaluesfolder(Character);
    local Humanoid = Character:FindFirstChild("Humanoid");
    local RootPart = Humanoid.RootPart;
    local _ = os.clock() - u13.startClock;
    local u14 = u2.Id[u11.UserId];
    local v15, v16 = ManuelCancel.new(u11, 1.5);
    v15:Connect(function() -- Line: 101
        -- upvalues: u14 (ref), u2 (ref), u11 (copy), u12 (copy), u13 (copy)
        u14 = -1;
        u2.Cancel(u11, u12, u13);
    end);
    local u17 = nil;
    local u18 = 0;
    local u19 = nil;
    Utility.CreateHitbox({
        caster = Character,
        hitboxCFrame = RootPart.CFrame,
        hitboxSize = Config.GRAB_HITBOX_SIZE,
        checker = Checker,

        After = function() -- Line: 114, Name: After
            -- upvalues: u18 (ref), EffectsEvent (ref), u11 (copy), Character (copy)
            if u18 == 0 then
                EffectsEvent.ToAllInRange(u11, "Arcs Of JustiveVFX", Character, "Cancel");
            end;
        end,

        hitPriorityHandler = {
            data = "Choosing_1",
            callback = u1.Exists
        },

        hitDetected = function(u20: userdata, u21: any, p22: any, p23: any) -- Line: 120, Name: hitDetected
            -- upvalues: Combat_Util (ref), Character (copy), Config (ref), u18 (ref), u17 (ref), RootPart (copy), u19 (ref), DebrisModule (ref), EffectsEvent (ref), u11 (copy), Utility (ref), Humanoid (copy), Cutscene_camera_handler (ref), valuesfolder (copy), CharGrabPosCorrector (ref), CAM (ref), u14 (ref), u2 (ref), Checker (ref)
            if u20 then
                local Humanoid2 = u20:FindFirstChild("Humanoid");
                local RootPart2 = Humanoid2.RootPart;

                if p22 == "Blocking" then
                    Combat_Util.Block(script, Character, u20, Config.GRAB_BLOCK_BREAK);

                    return;
                end;

                if p22 == "Perfect" then
                    Combat_Util.Perfect(script, Character, u20);

                    return;
                end;

                if p22 == true then
                    u18 = u18 + 1;

                    if u18 == 1 then
                        u17 = RootPart.CFrame;
                        u19 = script.CamReAdd:Clone();
                        u19:PivotTo(u17);
                        u19.Parent = workspace.Debree;
                        u19.H.RootWeld.Part0 = RootPart;
                        DebrisModule:AddItem(u19, Config.GRAB_DURATION);
                        u19.AnimationController.Animator:LoadAnimation(script.StoneUltCamera):Play();
                        EffectsEvent.ToAllInRange(u11, "Arcs Of JustiveVFX", Character, "Cutscene", u20);
                        Utility.lock(RootPart, u17, Config.GRAB_DURATION);
                        Humanoid.Animator:LoadAnimation(script.StoneUltPlayer):Play();
                        Cutscene_camera_handler.Regular(u11, u19.Cam);
                        Utility.AddValue(valuesfolder, "pause_gameplay", Config.GRAB_DURATION);
                        Utility.AddValue(valuesfolder, "iframe", Config.GRAB_DURATION);
                    end;

                    local Animator = Humanoid2:FindFirstChild("Animator");
                    local v24;

                    if Animator then
                        v24 = Animator:LoadAnimation(script.StoneUltVictim);
                        v24:Play();
                    else
                        v24 = nil;
                    end;

                    local u25 = Utility.AddValue(u21, "noragdoll", Config.GRAB_DURATION);
                    local u26 = Utility.lock(RootPart2, u17, Config.VICTIM_LOCK_DURATION);
                    CharGrabPosCorrector.Do(u20, v24, Config.CORRECTOR_DURATION, Character);
                    local u27 = Utility.AddValue(u21, "pause_gameplay", Config.GRAB_DURATION);
                    local u28 = Utility.AddValue(u21, "iframe", Config.GRAB_DURATION, "StringValue", u11.Name);
                    local u29 = Utility.AddValue(u21, "InvisibleItem", Config.GRAB_DURATION, "StringValue", "all");

                    if CAM ~= nil then
                        local PlayerFromCharacter = game.Players:GetPlayerFromCharacter(u20);

                        if PlayerFromCharacter ~= nil then
                            Cutscene_camera_handler.Regular(PlayerFromCharacter, u19.Cam);
                        end;
                    end;

                    task.delay(Config.HIT1_AT, function() -- Line: 172
                        -- upvalues: u14 (ref), u2 (ref), u11 (ref), u20 (copy), Humanoid2 (copy), Checker (ref), Character (ref), Combat_Util (ref), Config (ref), u17 (ref), u26 (ref), u29 (ref), u27 (ref), u28 (ref), u25 (ref), u21 (copy), RootPart2 (copy)
                        if u14 ~= u2.Id[u11.UserId] or (u20 == nil or (u20.Parent == nil or (Humanoid2 == nil or (Humanoid2.Parent == nil or Checker.check_victim(script, Character, u20) == nil)))) then
                            return;
                        end;

                        Combat_Util.Damage(script, Character, u20, {
                            Base = Config.HIT1_DAMAGE,
                            Skill = script.Parent.Name
                        });
                        task.wait(Config.HIT2_AT - Config.HIT1_AT);

                        if u14 ~= u2.Id[u11.UserId] or (u20 == nil or (u20.Parent == nil or (Humanoid2 == nil or (Humanoid2.Parent == nil or Checker.check_victim(script, Character, u20) == nil)))) then
                            return;
                        end;

                        Combat_Util.Damage(script, Character, u20, {
                            Base = Config.HIT2_DAMAGE,
                            Skill = script.Parent.Name
                        });
                        task.wait(Config.HIT3_AT - Config.HIT2_AT);

                        if u14 ~= u2.Id[u11.UserId] or (u20 == nil or (u20.Parent == nil or (Humanoid2 == nil or (Humanoid2.Parent == nil or Checker.check_victim(script, Character, u20) == nil)))) then
                            return;
                        end;

                        Combat_Util.Damage(script, Character, u20, {
                            Base = Config.HIT3_DAMAGE,
                            Skill = script.Parent.Name
                        });
                        task.wait(Config.FINISHER_AT - Config.HIT3_AT);

                        if u14 ~= u2.Id[u11.UserId] or (u20 == nil or (u20.Parent == nil or (Humanoid2 == nil or (Humanoid2.Parent == nil or Checker.check_victim(script, Character, u20) == nil)))) then
                            return;
                        end;

                        local v30 = u17.lookVector * Config.FINISHER_KNOCKBACK + vector.create(0, Config.FINISHER_KNOCKUP, 0);

                        if u26 ~= nil then
                            u26:Destroy();
                            u26 = nil;
                        end;

                        if u29 ~= nil then
                            u29:Destroy();
                            u29 = nil;
                        end;

                        if u27 ~= nil then
                            u27:Destroy();
                            u27 = nil;
                        end;

                        if u28 ~= nil then
                            u28:Destroy();
                            u28 = nil;
                        end;

                        if u25 ~= nil then
                            u25:Destroy();
                            u25 = nil;
                        end;

                        Combat_Util.AddStun(script, Character, u21, Config.FINISHER_STUN);
                        Combat_Util.Damage(script, Character, u20, {
                            Base = Config.FINISHER_DAMAGE,
                            Skill = script.Parent.Name
                        });
                        Combat_Util.RagDoll(script, Character, u21, Config.FINISHER_RAGDOLL);
                        Combat_Util.Knockback(script, Character, RootPart2, v30, Config.FINISHER_KNOCKBACK_DURATION);
                    end);
                end;
            end;
        end
    });
    v16();
end;

function u2.Cancel(p31: userdata, p32: vector, p33: table) -- Line: 222
    -- upvalues: EffectsEvent (copy)
    if p31.Character == nil then
        return;
    end;

    EffectsEvent.ToAllInRange(p31, "Arcs Of JustiveVFX", p31.Character, "Cancel");
end;

return u2;
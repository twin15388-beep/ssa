-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local CAM = ReplicatedStorage.CAM;
local SAM = ServerStorage.SAM;
local EffectsEvent = require(ReplicatedStorage.Communication.ServerAndClient.Effects.EffectsEvent);
local ManuelCancel = require(CAM.Global.Subsets.Gameplay.ManuelCancel);
local Checker = require(CAM.Global.Checker);
local Combat_Util = require(SAM.Services.Combat_Util);
local Utility = require(CAM.Global.Utility);
local Cutscene_camera_handler = require(SAM.Game_Play.Cutscene_camera_handler);
local CharGrabPosCorrector = require(CAM.Global.Subsets.Gameplay.CharGrabPosCorrector);
local cleanit = require(ReplicatedStorage.Packages.cleanit);
local PartBox = require(CAM.Global.PartBox);
local Config = require(script.Parent.Config);
local u1 = require(SAM.Game_Play.hit_priority_handler).new(script);
local u2 = {
    Id = {}
};
local u3 = Config.DASH_DURATION + Config.CUTSCENE_DURATION + Config.MANUAL_CANCEL_BUFFER;
local script_AnnihilationTypeCamera = script.AnnihilationTypeCamera;
local script_AnnihilationTypeUser = script.AnnihilationTypeUser;
local script_AnnihilationTypeVictim = script.AnnihilationTypeVictim;

function u2.Hold(p4: userdata, p5: vector?, p6: table) -- Line: 35
    -- upvalues: u2 (copy), EffectsEvent (copy), cleanit (copy), PartBox (copy), Config (copy), Checker (copy), u1 (copy), Combat_Util (copy), Utility (copy)
    local Character = p4.Character;
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
    local v7 = u2.Id[p4.UserId];
    EffectsEvent.ToAllInRange(HumanoidRootPart, "Annihilation Type VFX", Character, "Start", HumanoidRootPart.CFrame);
    local v8 = p6.CleanIt or cleanit.new();
    p6.CleanIt = v8;
    v8:Add(PartBox.new({
        Shape = "Cylinder",
        Center = HumanoidRootPart.CFrame,
        Size = Config.UPDRAFT_ZONE_SIZE,
        MaxDuration = Config.UPDRAFT_DURATION,
        caster = Character,
        checker = Checker,
        hitPriorityHandler = {
            data = "Choosing_1",
            callback = u1.Exists
        },

        hitDetected = function(p9: userdata, p10: userdata, p11: any) -- Line: 58, Name: hitDetected
            -- upvalues: Combat_Util (ref), Character (copy), Config (ref)
            if p11 == "Perfect" then
                Combat_Util.Perfect(script, Character, p9);

                return;
            end;

            if p11 == "Blocking" then
                Combat_Util.Block(script, Character, p9, Config.UPDRAFT_BLOCK_BREAK);

                return;
            end;

            if p11 == true then
                local Humanoid = p9:FindFirstChild("Humanoid");

                if Humanoid then
                    Humanoid = Humanoid.RootPart;
                end;

                if Humanoid == nil then
                    return;
                end;

                Combat_Util.Knockback(script, Character, Humanoid, Vector3.new(0, Config.UPDRAFT_KNOCKBACK, 0), Config.UPDRAFT_LIFT_TIME);
                Combat_Util.AddStun(script, Character, p10, Config.UPDRAFT_STUN);
            end;
        end
    }));
    task.wait(Config.STARTUP_LOOP_DURATION);

    if u2.Id[p4.UserId] ~= v7 then
        return;
    end;

    local v12 = `{p4.Name}-{script.Parent.Name}-{math.random(1, 99)}`;
    p6.probeVictim = nil;

    while u2.Id[p4.UserId] == v7 do
        local v13 = Utility.SinglePartHitbox({
            Caster = Character,
            ParamsName = v12,
            Origin = HumanoidRootPart.CFrame * CFrame.new(Config.FRONT_STOP_OFFSET),
            BoxSize = Config.FRONT_STOP_SIZE
        });

        if v13 then
            p6.probeVictim = Utility.find_character_from_descendant(v13);
            EffectsEvent.ToClient(p4, "force_skill_actions_server", script.Parent.Name, "UnHold", nil);

            return;
        end;

        task.wait(0.1);
    end;
end;

function u2.UnHold(u14: userdata, u15: vector?, u16: table) -- Line: 97
    -- upvalues: cleanit (copy), Utility (copy), u2 (copy), ManuelCancel (copy), u3 (copy), Config (copy), Checker (copy), u1 (copy), Combat_Util (copy), script_AnnihilationTypeCamera (copy), Cutscene_camera_handler (copy), script_AnnihilationTypeUser (copy), CharGrabPosCorrector (copy), Players (copy), script_AnnihilationTypeVictim (copy), EffectsEvent (copy)
    local u17 = u16.CleanIt or cleanit.new();
    u16.CleanIt = u17;
    u17:Clean();
    local Character = u14.Character;
    local Humanoid = Character:FindFirstChild("Humanoid");
    local RootPart = Humanoid.RootPart;
    local Animator = Humanoid:FindFirstChild("Animator");
    local valuesfolder = Utility.getvaluesfolder(Character);
    local u18 = u2.Id[u14.UserId];
    local v19, v20 = ManuelCancel.new(u14, u3);
    v19:Connect(function() -- Line: 111
        -- upvalues: u2 (ref), u14 (copy), u15 (copy), u16 (copy)
        u2.Id[u14.UserId] = -1;
        u2.Cancel(u14, u15, u16);
    end);
    local Unit = (u15 - RootPart.Position).Unit;
    local CFrame2 = RootPart.CFrame;
    local u21 = nil;
    local u22 = {};
    local u23 = nil;
    Utility.CreateHitbox({
        caster = Character,
        hitboxCFrame = CFrame2 * CFrame.new(Config.FRONT_STOP_OFFSET),
        hitboxSize = Config.FRONT_STOP_SIZE,
        targets = u16.probeVictim,
        checker = Checker,
        hitPriorityHandler = {
            data = "Choosing_1",
            callback = u1.Exists
        },

        hitDetected = function(u24: userdata, u25: userdata, p26: any) -- Line: 130, Name: hitDetected
            -- upvalues: Combat_Util (ref), Character (copy), Config (ref), RootPart (copy), u22 (copy), u17 (copy), Utility (ref), CFrame2 (copy), u21 (ref), u23 (ref), u18 (copy), u2 (ref), u14 (copy), script_AnnihilationTypeCamera (ref), Cutscene_camera_handler (ref), valuesfolder (copy), Animator (copy), script_AnnihilationTypeUser (ref), CharGrabPosCorrector (ref), Players (ref), script_AnnihilationTypeVictim (ref), Checker (ref), Unit (copy)
            local Humanoid2 = u24:FindFirstChild("Humanoid");
            local RootPart2 = Humanoid2.RootPart;

            if p26 == "Perfect" then
                Combat_Util.Perfect(script, Character, u24);

                return;
            end;

            if p26 ~= "Blocking" then
                if p26 == true then
                    table.insert(u22, u24);
                    u17:Add(Utility.AddValue(u25, "iframe", Config.CUTSCENE_DURATION, "StringValue", Character.Name));
                    u17:Add(Utility.AddValue(u25, "pause_gameplay", Config.CUTSCENE_DURATION));
                    u17:Add(Utility.AddValue(u25, "skill_stand_still", Config.CUTSCENE_DURATION));
                    u17:Add(Utility.lock(RootPart2, CFrame2, 2.62));

                    if #u22 == 1 then
                        u21 = u24;
                        u23 = script.Camera:Clone();
                        u17:Add(u23);
                        u23:PivotTo(RootPart.CFrame * CFrame.new(0, -3, 0));
                        u17:Add(task.delay(1.3333333333333333, function() -- Line: 155
                            -- upvalues: u18 (ref), u2 (ref), u14 (ref), u23 (ref), RootPart (ref)
                            if u18 ~= u2.Id[u14.UserId] then
                                return;
                            end;

                            if u23.Parent == nil then
                                return;
                            end;

                            u23:PivotTo(RootPart.CFrame * CFrame.new(0, -2, 0));
                        end));
                        u23.Parent = workspace.Debree;
                        local v27 = u23.AnimationController.Animator:LoadAnimation(script_AnnihilationTypeCamera);
                        u17:Add(v27);
                        v27:Play();
                        Cutscene_camera_handler.Regular(u14, u23.Camera);
                        u17:Add(task.delay(3.4, function() -- Line: 167
                            -- upvalues: u23 (ref)
                            if u23.Parent ~= nil then
                                u23:Destroy();
                            end;
                        end));
                        u17:Add(Utility.AddValue(valuesfolder, "iframe", Config.CUTSCENE_DURATION));
                        u17:Add(Utility.AddValue(valuesfolder, "pause_gameplay", Config.CUTSCENE_DURATION));
                        u17:Add(Utility.AddValue(valuesfolder, "skill_stand_still", Config.CUTSCENE_DURATION));
                        u17:Add(Utility.lock(RootPart, CFrame2, Config.CUTSCENE_DURATION));
                        local v28 = Animator:LoadAnimation(script_AnnihilationTypeUser);
                        u17:Add(v28);
                        v28:Play();
                        CharGrabPosCorrector.Do(Character, v28, Config.CUTSCENE_DURATION, Character);
                    end;

                    local v29 = u23 and Players:GetPlayerFromCharacter(u24);

                    if v29 then
                        Cutscene_camera_handler.Regular(v29, u23.Camera);
                    end;

                    local v30 = Humanoid2:FindFirstChild("Animator"):LoadAnimation(script_AnnihilationTypeVictim);
                    u17:Add(v30);
                    v30:Play();
                    CharGrabPosCorrector.Do(u24, v30, 3.4, Character);
                    task.delay(3.4, function() -- Line: 196
                        -- upvalues: u18 (ref), u2 (ref), u14 (ref), Checker (ref), Character (ref), u24 (copy), Combat_Util (ref), Config (ref), u25 (copy), RootPart2 (copy), Unit (ref)
                        if u18 ~= u2.Id[u14.UserId] then
                            return;
                        end;

                        if Checker.check_victim(script, Character, u24) == nil then
                            return;
                        end;

                        Combat_Util.Damage(script, Character, u24, {
                            Base = Config.CUTSCENE_DAMAGE,
                            Skill = script.Parent.Name
                        });
                        Combat_Util.AddStun(script, Character, u25, Config.CUTSCENE_STUN);
                        Combat_Util.RagDoll(script, Character, u25, Config.CUTSCENE_STUN);
                        Combat_Util.Knockback(script, Character, RootPart2, Unit * Config.CUTSCENE_KNOCKBACK, Config.CUTSCENE_TIME);
                    end);
                end;

                return;
            end;

            Combat_Util.Block(script, Character, u24, Config.CATCH_BLOCK_BREAK);
            Combat_Util.Knockback(script, Character, RootPart2, RootPart.CFrame.LookVector.Unit * Config.BLOCK_KNOCKBACK, 0.2);
        end,

        After = function() -- Line: 206, Name: After
            -- upvalues: u18 (copy), u2 (ref), u14 (copy), u22 (copy), Character (copy), EffectsEvent (ref), RootPart (copy), u23 (ref), u15 (copy), u16 (copy)
            if u18 ~= u2.Id[u14.UserId] then
                return;
            end;

            if #u22 > 0 then
                local table_clone_ret = table.clone(u22);
                table.insert(table_clone_ret, Character);
                EffectsEvent.ToAllInRange(RootPart, "Annihilation Type VFX", Character, "Cutscene", RootPart.CFrame, table_clone_ret);

                if u23 and u23.Parent ~= nil then
                    EffectsEvent.ToAllInRange(RootPart, "Annihilation Type VFX", Character, "UltimateCamera", u23, table_clone_ret);
                end;
            else
                u2.Cancel(u14, u15, u16);
            end;
        end
    });
    task.wait(Config.CUTSCENE_DURATION);

    if u18 ~= u2.Id[u14.UserId] then
        return;
    end;

    v20();
    u17:Clean();
end;

function u2.Cancel(p31: userdata, p32: vector?, p33: table) -- Line: 233
    -- upvalues: cleanit (copy), EffectsEvent (copy)
    local v34 = p33.CleanIt or cleanit.new();
    p33.CleanIt = v34;
    EffectsEvent.ToAllInRange(p31, "Annihilation Type VFX", p31.Character, "Cancel");
    v34:Clean();
end;

return u2;
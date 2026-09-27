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
ReplicatedStorage:WaitForChild("Communication");
local Utility = require(Global.Utility);
local Checker = require(Global.Checker);
local Combat_Util = require(Services.Combat_Util);
require(CAM.Global.Combat_presets);
local u1 = require(SAM.Game_Play.hit_priority_handler).new(script);
local DebrisModule = require(CAM:FindFirstChild("DebrisModule"));
require(SAM.Services.Server_Mouse_Pos);
local Cutscene_camera_handler = require(SAM:FindFirstChild("Game_Play"):FindFirstChild("Cutscene_camera_handler"));
local EffectsEvent = require(ReplicatedStorage2.Communication.ServerAndClient.Effects.EffectsEvent);
local CharGrabPosCorrector = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Subsets"):WaitForChild("Gameplay"):WaitForChild("CharGrabPosCorrector"));
local Config = require(script.Parent.Config);
local v5 = {
    Id = {},

    Hold = function(p2: userdata, p3: any, p4: any) -- Line: 37, Name: Hold
        -- upvalues: EffectsEvent (copy)
        if not p2 then
            return;
        end;

        if not p2.Character then
            return;
        end;

        EffectsEvent.ToAllInRange(p2, "Unknowing FireVFX", p2.Character, "Start");
    end
};
local u6 = script;

function v5.UnHold(u7: userdata, p8: any, p9: any) -- Line: 47
    -- upvalues: Utility (copy), DebrisModule (copy), Config (copy), Combat_Util (copy), Cutscene_camera_handler (copy), CharGrabPosCorrector (copy), Checker (copy), u6 (copy), EffectsEvent (copy), u1 (copy)
    if not u7 then
        return;
    end;

    local Character = u7.Character;

    if not Character then
        return;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
    local valuesfolder = Utility.getvaluesfolder(Character);

    if not HumanoidRootPart then
        return;
    end;

    p9[Character.Name .. script.Parent.Name] = {};
    local BoolValue = Instance.new("BoolValue");
    BoolValue.Name = "NR";
    BoolValue.Parent = valuesfolder;
    DebrisModule:AddItem(BoolValue, Config.CAST_NR_DUR);
    local u10 = 0;
    local u11 = nil;
    local u12 = nil;
    local u13 = nil;
    local u14 = {};

    local function v23(u15: userdata, u16: any, p17: any, p18: any) -- Line: 69
        -- upvalues: Combat_Util (ref), Character (copy), Config (ref), u10 (ref), u11 (ref), HumanoidRootPart (copy), u12 (ref), DebrisModule (ref), Utility (ref), valuesfolder (copy), u13 (ref), Cutscene_camera_handler (ref), u7 (copy), CharGrabPosCorrector (ref), u14 (copy), Checker (ref), u6 (ref)
        if u15 then
            local RootPart = u15:FindFirstChild("Humanoid").RootPart;

            if p17 == "Blocking" then
                Combat_Util.Block(script, Character, u15, Config.BLOCK_BREAK);

                return;
            end;

            if p17 == "Perfect" then
                Combat_Util.Perfect(script, Character, u15);

                return;
            end;

            if p17 == true then
                u10 = u10 + 1;

                if u10 == 1 then
                    u11 = HumanoidRootPart.CFrame;
                    u12 = script.DragonModel:Clone();
                    u12.RootPart.RootWeld.Part0 = HumanoidRootPart;
                    u12.Parent = workspace.Debree;
                    DebrisModule:AddItem(u12, Config.CUTSCENE_DUR);
                    Utility.AddValue(valuesfolder, "camsubject", Config.CASTER_LOCK_DUR, "ObjectValue", Character:FindFirstChild("Head"));
                    u12.AnimationController.Animator:LoadAnimation(script.Dragon):Play();
                    Utility.lock(HumanoidRootPart, u11, Config.CASTER_LOCK_DUR);
                    Utility.AddValue(valuesfolder, "pause_gameplay", Config.CASTER_LOCK_DUR);
                    Utility.AddValue(valuesfolder, "iframe", Config.CASTER_LOCK_DUR);
                    u13 = script.CameraModel:Clone();
                    u13.RootPart.RootWeld.Part0 = HumanoidRootPart;
                    u13.Parent = workspace.Debree;
                    u13.AnimationController:LoadAnimation(script.Camera):Play();
                    Cutscene_camera_handler.Regular(u7, u13.camera);
                    DebrisModule:AddItem(u13, Config.CAMERA_DUR);
                    local Animator = Character:FindFirstChild("Humanoid"):FindFirstChild("Animator");

                    if Animator then
                        local v19 = Animator:LoadAnimation(script.User);
                        v19:Play();
                        CharGrabPosCorrector.Do(Character, v19, Config.CASTER_LOCK_DUR, Character, true);
                    end;

                    table.insert(u14, u15);
                end;

                local PlayerFromCharacter = game.Players:GetPlayerFromCharacter(u15);

                if PlayerFromCharacter ~= nil then
                    Cutscene_camera_handler.Regular(PlayerFromCharacter, u13.camera);
                end;

                local Animator = u15:FindFirstChild("Humanoid"):FindFirstChild("Animator");

                if Animator then
                    local v20 = Animator:LoadAnimation(script.Victim);
                    v20:Play();
                    CharGrabPosCorrector.Do(u15, v20, Config.VICTIM_ANIM_DUR, Character);
                end;

                Utility.AddValue(u16, "pause_gameplay", Config.VICTIM_ANIM_DUR);
                Utility.AddValue(u16, "noragdoll", Config.VICTIM_ANIM_DUR);
                Utility.AddValue(u16, "iframe", Config.VICTIM_ANIM_DUR, "StringValue", Character.Name);
                Combat_Util.Cancel(script, u16);
                local u21 = Utility.lock(RootPart, u11, Config.VICTIM_ANIM_DUR);
                task.delay(Config.HIT1_AT, function() -- Line: 126
                    -- upvalues: Checker (ref), u6 (ref), Character (ref), u15 (copy), Combat_Util (ref), Config (ref), u16 (copy), u21 (ref), u11 (ref), HumanoidRootPart (ref), RootPart (copy)
                    if Checker.check_victim(u6, Character, u15) == nil then
                        return;
                    end;

                    Combat_Util.Damage(script, Character, u15, {
                        Base = Config.HIT1_DAMAGE,
                        Skill = script.Parent.Name
                    });
                    task.wait(Config.HIT2_AT - Config.HIT1_AT);

                    if Checker.check_victim(u6, Character, u15) == nil then
                        return;
                    end;

                    Combat_Util.Damage(script, Character, u15, {
                        Base = Config.HIT2_DAMAGE,
                        Skill = script.Parent.Name
                    });
                    task.wait(Config.VICTIM_ANIM_DUR - Config.HIT2_AT + 0.15);
                    Combat_Util.Damage(script, Character, u15, {
                        Base = Config.FINAL_DAMAGE,
                        Skill = script.Parent.Name
                    });
                    Combat_Util.AddStun(script, Character, u16, Config.FINAL_STUN);
                    Combat_Util.RagDoll(script, Character, u16, Config.FINAL_RAGDOLL);

                    if u21 ~= nil then
                        u21:Destroy();
                        u21 = nil;
                    end;

                    local v22 = (u11 or HumanoidRootPart.CFrame).LookVector * Config.FINAL_KNOCKBACK + vector.create(0, Config.FINAL_KNOCKUP, 0);
                    Combat_Util.Knockback(script, Character, RootPart, v22, 0.2);
                end);
            end;
        end;
    end;

    os.clock();
    local Position = HumanoidRootPart.Position;
    local v24 = Utility.SafeLookAt(Position, p8 + vector.create(0, -p8.Y + Position.Y, 0), HumanoidRootPart.CFrame);
    Utility.CreateHitbox({
        TreeDestruction = true,
        caster = Character,
        hitboxCFrame = v24 * Config.HITBOX_OFFSET,
        hitboxSize = Config.HITBOX_SIZE,
        checker = Checker,

        After = function() -- Line: 169, Name: After
            -- upvalues: u10 (ref), EffectsEvent (ref), u7 (copy), Character (copy), u14 (copy)
            if u10 > 0 then
                EffectsEvent.ToAllInRange(u7, "PurgatoryVFX", Character, "Cutscene", u14);

                return;
            end;

            EffectsEvent.ToAllInRange(u7, "PurgatoryVFX", Character, "Jump");
        end,

        hitPriorityHandler = {
            data = "Choosing_1",
            callback = u1.Exists
        },
        hitDetected = v23
    });
end;

function v5.Cancel(p25, p26, p27) -- Line: 183
    -- upvalues: EffectsEvent (copy)
    if not p25 then
        return;
    end;

    local Character = p25.Character;

    if not Character then
        return;
    end;

    EffectsEvent.ToAllInRange(p25, "Flaming_Thunder_God_VFX", Character, "Cancel");
end;

return v5;
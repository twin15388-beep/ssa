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
local EffectsEvent = require(ReplicatedStorage2.Communication.ServerAndClient.Effects.EffectsEvent);
local Utility = require(Global.Utility);
local Checker = require(Global.Checker);
local Combat_Util = require(Services.Combat_Util);
require(CAM.Global.Combat_presets);
local u1 = require(SAM.Game_Play.hit_priority_handler).new(script);
require(Global.Subsets.Gameplay.ManuelCancel);
local AppliedTicks = require(Global.Subsets.Gameplay.AppliedTicks);
local Clans = require(CAM.Clans);
local DebrisModule = require(CAM:FindFirstChild("DebrisModule"));
require(SAM.Services.Server_Mouse_Pos);
local Cutscene_camera_handler = require(SAM:FindFirstChild("Game_Play"):FindFirstChild("Cutscene_camera_handler"));
local CharGrabPosCorrector = require(Global.Subsets.Gameplay.CharGrabPosCorrector);
local Config = require(script.Parent.Config);
local u5 = {
    Id = {},

    Hold = function(p2: userdata, p3: any, p4: any) -- Line: 37, Name: Hold
        -- upvalues: Utility (copy), EffectsEvent (copy)
        if not p2 then
            return;
        end;

        local Character = p2.Character;

        if not Character then
            return;
        end;

        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

        if not HumanoidRootPart then
            return;
        end;

        Utility.getvaluesfolder(Character);

        if not HumanoidRootPart then
            return;
        end;

        EffectsEvent.ToAllInRange(p2, "Illusory_Light_VFX", Character, "Hold");
    end
};

function u5.UnHold(u6: userdata, p7: any, p8: any) -- Line: 56
    -- upvalues: Utility (copy), u5 (copy), Config (copy), Combat_Util (copy), DebrisModule (copy), Cutscene_camera_handler (copy), CharGrabPosCorrector (copy), Clans (copy), AppliedTicks (copy), Checker (copy), u1 (copy), EffectsEvent (copy)
    if u6 == nil or (u6.Character == nil or (u6.Character.PrimaryPart == nil or u6.Character:FindFirstChild("Humanoid") == nil)) then
        return;
    end;

    local Character = u6.Character;
    local Humanoid = Character.Humanoid;
    local RootPart = Humanoid.RootPart;
    local _ = Humanoid.Animator;
    local valuesfolder = Utility.getvaluesfolder(Character);
    local v9 = u5.Id[u6.UserId];
    task.wait(Config.RELEASE_DELAY);

    if u5.Id[u6.UserId] ~= v9 then
        return;
    end;

    local u10 = 0;
    local u11 = script.Parent.Name .. Character.Name .. "Camera";
    local u12 = { Character };
    local u13 = nil;
    local CFrame = RootPart.CFrame;

    local function v23(u14: userdata, u15: any, p16: any, p17: any) -- Line: 76
        -- upvalues: Combat_Util (ref), Character (copy), Config (ref), CFrame (copy), u12 (copy), u10 (ref), DebrisModule (ref), Utility (ref), u13 (ref), u11 (copy), RootPart (copy), Cutscene_camera_handler (ref), u6 (copy), CharGrabPosCorrector (ref), Clans (ref), AppliedTicks (ref), valuesfolder (copy)
        if u14 then
            local RootPart2 = u14:FindFirstChild("Humanoid").RootPart;

            if p16 == "Blocking" or p16 == "Perfect" then
                Combat_Util.Block(script, Character, u14, Config.BLOCK_BREAK);
                local v18 = vector.normalize(CFrame.Position - RootPart2.Position) * -Config.BLOCK_KNOCKBACK;
                Combat_Util.Knockback(script, Character, RootPart2, Vector3.new(v18.X, 0, v18.Z), Config.BLOCK_KNOCKBACK_DUR);

                return;
            end;

            if p16 == true then
                table.insert(u12, u14);
                u10 = u10 + 1;
                local NumberValue = Instance.new("NumberValue");
                NumberValue.Value = Config.CUTSCENE_FOV;
                NumberValue.Name = "FOV";
                NumberValue.Parent = u15;
                DebrisModule:AddItem(NumberValue, Config.CUTSCENE_DURATION - 0.1);

                for _, v in ipairs({ "pause_gameplay", "iframe" }) do
                    Utility.AddValue(u15, v, Config.CUTSCENE_DURATION);
                end;

                local u19 = Utility.lock(RootPart2, CFrame, Config.CUTSCENE_DURATION);

                if u13 == nil and u10 == 1 then
                    u13 = script.CameraRig:Clone();
                    u13.Name = u11;
                    u13.RootPart.RootPart.Part0 = RootPart;
                    u13.Parent = workspace.Debree;
                    u13.AnimationController:LoadAnimation(script.Camera):Play();
                    DebrisModule:AddItem(u13, Config.CUTSCENE_DURATION - 0.6);
                    Cutscene_camera_handler.Regular(u6, u13.Bone);
                end;

                if u13 ~= nil then
                    local PlayerFromCharacter = game.Players:GetPlayerFromCharacter(u14);

                    if PlayerFromCharacter ~= nil then
                        Cutscene_camera_handler.Regular(PlayerFromCharacter, u13.Bone);
                    end;
                end;

                local Animator = u14:FindFirstChild("Humanoid"):FindFirstChild("Animator");

                if Animator then
                    local v20 = Animator:LoadAnimation(script.Victim);
                    v20:Play();
                    CharGrabPosCorrector.Do(u14, v20, Config.FINISHER_AT - 0.05, Character);
                end;

                task.delay(Config.FINISHER_AT, function() -- Line: 128
                    -- upvalues: RootPart2 (copy), RootPart (ref), u19 (ref), Combat_Util (ref), Character (ref), u15 (copy), Config (ref), u14 (copy), Clans (ref), Utility (ref), AppliedTicks (ref)
                    if RootPart2 == nil or (RootPart2.Parent == nil or (RootPart == nil or RootPart.Parent == nil)) then
                        return;
                    end;

                    if u19 ~= nil then
                        u19:Destroy();
                        u19 = nil;
                    end;

                    Combat_Util.AddStun(script, Character, u15, Config.FINISHER_STUN);
                    Combat_Util.RagDoll(script, Character, u15, Config.FINISHER_RAGDOLL);
                    task.wait(Config.FINISHER_DAMAGE_DELAY);

                    if RootPart2 == nil or (RootPart2.Parent == nil or (RootPart == nil or RootPart.Parent == nil)) then
                        return;
                    end;

                    Combat_Util.Damage(script, Character, u14, {
                        Base = Config.FINISHER_DAMAGE,
                        Skill = script.Parent.Name
                    });

                    if Clans.HasPassive(Character:GetAttribute("Clan"), "Insect Affinity") then
                        local v21 = Utility.AddValue(u15, AppliedTicks.ByName.Poison.Value, Config.POISON_DURATION, "ObjectValue", Character);
                        v21:SetAttribute("Damage", Config.POISON_TICK_DAMAGE);
                        v21:SetAttribute("Skill", script.Parent.Name);
                    end;
                end);

                if u10 == 1 then
                    local Animator2 = Character:FindFirstChild("Humanoid"):FindFirstChild("Animator");
                    Utility.lock(RootPart, CFrame, Config.CUTSCENE_DURATION);

                    if Animator2 then
                        local v22 = Animator2:LoadAnimation(script.User);
                        v22:Play();
                        CharGrabPosCorrector.Do(Character, v22, Config.CUTSCENE_DURATION, Character);
                    end;

                    for _, v in ipairs({ "pause_gameplay", "iframe" }) do
                        Utility.AddValue(valuesfolder, v, Config.CUTSCENE_DURATION);
                    end;

                    local NumberValue2 = Instance.new("NumberValue");
                    NumberValue2.Value = Config.CUTSCENE_FOV;
                    NumberValue2.Name = "FOV";
                    NumberValue2.Parent = valuesfolder;
                    DebrisModule:AddItem(NumberValue2, Config.CUTSCENE_DURATION - 0.1);
                end;
            end;
        end;
    end;

    os.clock();
    Utility.CreateHitbox({
        visualize = false,
        caster = Character,
        hitboxCFrame = RootPart.CFrame * Config.HITBOX_OFFSET,
        hitboxSize = Config.HITBOX_SIZE,
        checker = Checker,
        hitPriorityHandler = {
            data = "Choosing_1",
            callback = u1.Exists
        },
        hitDetected = v23
    });

    if u10 == 0 then
        EffectsEvent.ToAllInRange(u6, "Illusory_Light_VFX", Character, "Thrust", u10);
    else
        EffectsEvent.ToAllInRange(u6, "Illusory_Light_VFX", Character, "Cutscene", { u11, Config.CUTSCENE_DURATION, u12 });
    end;
end;

function u5.Cancel(p24, p25, p26) -- Line: 189
    -- upvalues: EffectsEvent (copy)
    if not p24 then
        return;
    end;

    local Character = p24.Character;

    if not Character then
        return;
    end;

    EffectsEvent.ToAllInRange(p24, "Illusory_Light_VFX", Character, "Cancel");
end;

return u5;
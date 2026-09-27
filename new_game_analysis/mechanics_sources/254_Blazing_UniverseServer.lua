-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
game:GetService("RunService");
game:GetService("TweenService");
game:GetService("CollectionService");
local ReplicatedStorage2 = game:GetService("ReplicatedStorage");
local CAM = ReplicatedStorage:WaitForChild("CAM");
local SAM = ServerStorage:WaitForChild("SAM");
local Global = CAM:WaitForChild("Global");
local Services = SAM:WaitForChild("Services");
local EffectsEvent = require(ReplicatedStorage2.Communication.ServerAndClient.Effects.EffectsEvent);
local Utility = require(Global.Utility);
require(Global.Checker);
local RaycastHelper = require(Global.RaycastHelper);
local Combat_Util = require(Services.Combat_Util);
local ImpactSounds = require(SAM.Utility.ImpactSounds);
require(CAM.Global.Combat_presets);
local u1 = require(SAM.Game_Play.hit_priority_handler).new(script);
require(Global.Subsets.Gameplay.ManuelCancel);
require(CAM.Client.Modules.Effects.vfxUtility);
require(CAM:FindFirstChild("DebrisModule"));
require(SAM:FindFirstChild("Game_Play"):FindFirstChild("Cutscene_camera_handler"));
require(Global.Subsets.Gameplay.CharGrabPosCorrector);
local Checker = require(ReplicatedStorage2.CAM.Global.Checker);
local Config = require(script.Parent.Config);
local Server_Mouse_Pos = require(game:GetService("ServerStorage").SAM.Services.Server_Mouse_Pos);
local _ = Vector3.new;
local _ = tick;

return {
    Id = {},

    Hold = function(p2: userdata, p3: any, p4: any) -- Line: 46, Name: Hold
        -- upvalues: EffectsEvent (copy)
        if not p2 then
            return;
        end;

        local Character = p2.Character;

        if not Character then
            return;
        end;

        EffectsEvent.ToAllInRange(p2, "Blazing UniverseVFX", Character, "Start");
    end,

    UnHoldAfterClient = function(p5, p6, p7, p8, p9) -- Line: 54, Name: UnHoldAfterClient
        -- upvalues: Server_Mouse_Pos (copy), Config (copy), EffectsEvent (copy), Utility (copy), Checker (copy), u1 (copy), Combat_Util (copy), ImpactSounds (copy)
        if not p5 then
            return;
        end;

        local Character = p5.Character;

        if not Character then
            return;
        end;

        if typeof(p8) ~= "CFrame" then
            return;
        end;

        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

        if not HumanoidRootPart then
            return;
        end;

        local v10 = Server_Mouse_Pos.Clamp(Character, p8.Position, Config.AIM_RANGE + 15);

        if v10 == nil then
            return;
        end;

        local v11 = p8.Rotation + v10;
        Character:WaitForChild("Humanoid");
        EffectsEvent.ToAllInRange(p5, "Blazing UniverseVFX", Character, "Slam", v11);
        Utility.CreateHitbox({
            TreeDestruction = true,
            caster = Character,
            hitboxCFrame = v11 * Config.SLAM_HITBOX_OFFSET,
            hitboxSize = Config.SLAM_HITBOX_SIZE,
            checker = Checker,
            hitPriorityHandler = {
                data = "Choosing_1",
                callback = u1.Exists
            },

            hitDetected = function(p12: userdata, p13: any, p14: any) -- Line: 84, Name: hitDetected
                -- upvalues: Combat_Util (ref), Character (copy), Config (ref), HumanoidRootPart (copy)
                if p12 then
                    local RootPart = p12:FindFirstChild("Humanoid").RootPart;

                    if p14 == "Blocking" then
                        Combat_Util.Block(script, Character, p12, Config.SLAM_BLOCK_BREAK);

                        return;
                    end;

                    if p14 == "Perfect" then
                        Combat_Util.Perfect(script, Character, p12);

                        return;
                    end;

                    if p14 == true then
                        local v15 = HumanoidRootPart.CFrame.LookVector * Config.SLAM_KNOCKBACK + vector.create(0, Config.SLAM_KNOCKUP, 0);
                        Combat_Util.AddStun(script, Character, p13, Config.SLAM_STUN);
                        Combat_Util.Damage(script, Character, p12, {
                            Base = Config.SLAM_DAMAGE,
                            Skill = script.Parent.Name
                        });
                        Combat_Util.Knockback(script, Character, RootPart, v15, 0.2);
                        Combat_Util.RagDoll(script, Character, p13, Config.SLAM_RAGDOLL);
                    end;
                end;
            end,

            After = function(p16, p17) -- Line: 105, Name: After
                -- upvalues: ImpactSounds (ref), Character (copy)
                if p16 then
                    ImpactSounds.Play(Character, script.Parent.Name, p17[1]);
                end;
            end
        });
    end,

    UnHold = function(p18: userdata, p19: any, p20: any) -- Line: 111, Name: UnHold
        -- upvalues: RaycastHelper (copy), EffectsEvent (copy)
        if not p18 then
            return;
        end;

        local Character = p18.Character;

        if not Character then
            return;
        end;

        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

        if not HumanoidRootPart then
            return;
        end;

        if not Character:FindFirstChild("Animator", true) then
            return;
        end;

        local CFrame2 = HumanoidRootPart.CFrame;
        local v21 = workspace:Raycast(HumanoidRootPart.Position, Vector3.new(0, -15, 0), RaycastHelper.Crater);

        if v21 ~= nil then
            CFrame2 = CFrame.lookAlong(v21.Position + Vector3.new(0, 3, 0), HumanoidRootPart.CFrame.LookVector);
        end;

        EffectsEvent.ToAllInRange(p18, "Blazing UniverseVFX", Character, "Jump", CFrame2);
    end,

    Cancel = function(p22, p23, p24) -- Line: 133, Name: Cancel
        if not p22 then
            return;
        end;

        local Character = p22.Character;

        if not Character then
            return;
        end;

        if Character:FindFirstChild("HumanoidRootPart") then
        end;
    end
};
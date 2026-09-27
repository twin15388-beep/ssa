-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local DebrisModule = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));
local v1 = {
    Id = 0
};
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local workspace_CurrentCamera = workspace.CurrentCamera;
local Checker = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Checker"));
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Combat_presets"));
game.ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Animations"):WaitForChild("Dashes"):WaitForChild("Air");
game.ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Animations"):WaitForChild("Dashes"):WaitForChild("Land");
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
RaycastParams_new_ret.FilterDescendantsInstances = { workspace.Map };
local Combat_presets = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Combat_presets"));
local u2 = false;
local Character_info_provider = require(ReplicatedStorage.CAM.Global.Character_info_provider);
local PlayerStatResolver = require(ReplicatedStorage.CAM.Global.PlayerStatResolver);
local Config = require(script.Parent.Config);

function v1.Hold(p3) -- Line: 21
    -- upvalues: Checker (copy), PlayerStatResolver (copy), Config (copy), gameSettings (copy), DebrisModule (copy), workspace_CurrentCamera (copy), RaycastParams_new_ret (copy), Combat_presets (copy), Character_info_provider (copy), u2 (ref)
    if p3 ~= nil and p3.Character ~= nil then
        local HumanoidRootPart = p3.Character:FindFirstChild("HumanoidRootPart");
        local v4 = game.ReplicatedStorage.Player_Service.Values:FindFirstChild(p3.Name) or p3.Character;
        local SHC = p3.Character:FindFirstChild("SHC");

        if SHC ~= nil and (v4 ~= nil and (HumanoidRootPart ~= nil and p3.Character:FindFirstChild("Humanoid") ~= nil)) then
            if HumanoidRootPart:FindFirstChild("combat_knockback") then
                for _, child in pairs(HumanoidRootPart:GetChildren()) do
                    if child.Name == "combat_knockback" then
                        child:Destroy();
                    end;
                end;
            end;

            local Attribute = SHC:GetAttribute(not SHC:GetAttribute("LastCkType") and "CK" or SHC:GetAttribute("LastCkType"));
            Checker.Dashing = true;
            local BoolValue = Instance.new("BoolValue");
            BoolValue.Name = "NR";
            BoolValue.Parent = v4;
            local MovementMultiplier = PlayerStatResolver.GetMovementMultiplier(p3);
            local v5 = 1 + (PlayerStatResolver.GetStat(p3, "Dash Speed Factor") or 0) * Config.DASH_FACTOR_SCALE;
            local math_max_ret = math.max(0.1, v5);
            local v6 = Config.DASH_SPEED * MovementMultiplier * math_max_ret;
            local DASH_FORCE_DURATION = Config.DASH_FORCE_DURATION;
            local v7 = DASH_FORCE_DURATION + (Config.DASH_DURATION - DASH_FORCE_DURATION) / math_max_ret;

            if v4:FindFirstChild("Blocking") then
                v6 = v6 * gameSettings.BlockingSpeedMult;
            end;

            DebrisModule:AddItem(BoolValue, v7);
            local Position = HumanoidRootPart.Position;
            local v8 = HumanoidRootPart.Position + workspace_CurrentCamera.CFrame.LookVector * 5;
            local Vector3_new_ret = Vector3.new(v8.X, Position.Y, v8.Z);
            HumanoidRootPart.CFrame = CFrame.new(Position, Vector3_new_ret);
            local Attachment = Instance.new("Attachment", HumanoidRootPart);
            DebrisModule:AddItem(Attachment, v7);
            local AlignOrientation = Instance.new("AlignOrientation");
            AlignOrientation.MaxTorque = 10000;
            AlignOrientation.Responsiveness = 30;
            AlignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment;
            AlignOrientation.Attachment0 = Attachment;
            AlignOrientation.CFrame = CFrame.new(Position, Vector3_new_ret);
            AlignOrientation.Parent = Attachment;
            local lookVector = HumanoidRootPart.CFrame.lookVector;

            if Attribute == "S" then
                lookVector = lookVector * -1;
            end;

            if Attribute == "A" then
                lookVector = HumanoidRootPart.CFrame.rightVector * -1;
            end;

            if Attribute == "D" then
                lookVector = HumanoidRootPart.CFrame.rightVector;
            end;

            local Attachment2 = Instance.new("Attachment");
            local LinearVelocity = Instance.new("LinearVelocity");
            LinearVelocity.Parent = Attachment2;
            Attachment2.Name = "dash_thang_123asd";
            LinearVelocity.Attachment0 = Attachment2;
            LinearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Line;
            LinearVelocity.MaxForce = 10000;
            LinearVelocity.LineDirection = lookVector;
            LinearVelocity.LineVelocity = v6;
            Attachment2.Parent = HumanoidRootPart;
            DebrisModule:AddItem(Attachment2, DASH_FORCE_DURATION);
            local v9 = workspace:Raycast(HumanoidRootPart.Position, Vector3.new(0, -10, 0), RaycastParams_new_ret);
            local v10;

            if v9 == nil or v9.Instance == nil then
                local BoolValue2 = Instance.new("BoolValue");
                BoolValue2.Name = "AIRDASHASD123";
                BoolValue2.Parent = v4;
                DebrisModule:AddItem(BoolValue2, Config.AIR_DASH_FLAG_DURATION);
                v10 = "Air";
            else
                v10 = "Land";
            end;

            game.ReplicatedStorage.Communication.CnC.ClientEffects:Fire("dash_effect", HumanoidRootPart, lookVector, v10 == "Air", Config.ResolveCustomDash(p3));

            if os.clock() - Combat_presets.lastRunHit > Combat_presets.slow_walk_duration then
                local v11 = Character_info_provider.get_core_anim(p3, "Dash_" .. Attribute) or game.ReplicatedStorage.Assets.Animations.Dashes[v10]:FindFirstChild("Dash_" .. Attribute);

                if v10 == "Land" and (Attribute == "W" and v11.Parent.Parent.Name == "Dashes") then
                    u2 = not u2;

                    if u2 == true then
                        v11 = game.ReplicatedStorage.Assets.Animations.Dashes.Land.Dash_W_Inverted;
                    end;
                end;

                local v12 = nil;

                if p3.Character and (p3.Character:FindFirstChild("Accessories") and p3.Character.Accessories:FindFirstChild("CustomRig")) then
                    local AnimController = p3.Character.Accessories.CustomRig:FindFirstChild("AnimController");

                    if AnimController then
                        Combat_presets.stop_extra_anims(AnimController, { "Swing_6", "Swing_7" });
                        v12 = AnimController.Animator:LoadAnimation(v11);
                    end;
                else
                    Combat_presets.stop_extra_anims(p3.Character.Humanoid, { "Swing_6", "Swing_7" });
                    v12 = p3.Character.Humanoid.Animator:LoadAnimation(v11);
                end;

                if v12 ~= nil then
                    v12:Play();

                    if math_max_ret ~= 1 then
                        v12:AdjustSpeed(math_max_ret);
                    end;
                end;
            end;

            task.delay(v7, function() -- Line: 156
                -- upvalues: Checker (ref)
                Checker.Dashing = false;
            end);
        end;
    end;
end;

function v1.UnHold(p13) -- Line: 162
end;

function v1.Cancel(p14) -- Line: 165
end;

return v1;
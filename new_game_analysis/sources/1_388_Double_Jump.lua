-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local DebrisModule = require(ReplicatedStorage.CAM.DebrisModule);
local v1 = {
    Id = 0
};
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local Combat_presets = require(ReplicatedStorage.CAM.Global.Combat_presets);
game.ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Animations"):WaitForChild("Dashes"):WaitForChild("Air");
game.ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Animations"):WaitForChild("Dashes"):WaitForChild("Land");
local Character_info_provider = require(ReplicatedStorage.CAM.Global.Character_info_provider);
local RaycastHelper = require(ReplicatedStorage.CAM.Global.RaycastHelper);
local PlayerStatResolver = require(ReplicatedStorage.CAM.Global.PlayerStatResolver);

function v1.Hold(p2) -- Line: 15
    -- upvalues: PlayerStatResolver (copy), gameSettings (copy), DebrisModule (copy), RaycastHelper (copy), Combat_presets (copy), Character_info_provider (copy)
    if p2 ~= nil and p2.Character ~= nil then
        local HumanoidRootPart = p2.Character:FindFirstChild("HumanoidRootPart");
        local v3 = game.ReplicatedStorage.Player_Service.Values:FindFirstChild(p2.Name) or p2.Character;

        if p2.Character:FindFirstChild("SHC") ~= nil and (v3 ~= nil and (HumanoidRootPart ~= nil and p2.Character:FindFirstChild("Humanoid") ~= nil)) then
            if HumanoidRootPart:FindFirstChild("combat_knockback") or HumanoidRootPart:FindFirstChild("combat_knockbackLast") then
                for _, child in pairs(HumanoidRootPart:GetChildren()) do
                    if child.Name == "combat_knockback" or child.Name == "combat_knockbackLast" then
                        child:Destroy();
                    end;
                end;
            end;

            local v4 = 50 * PlayerStatResolver.GetMovementMultiplier(p2);

            if v3:FindFirstChild("Blocking") then
                v4 = v4 * gameSettings.BlockingSpeedMult;
            end;

            local UpVector = HumanoidRootPart.CFrame.UpVector;
            local Attachment = Instance.new("Attachment");
            local LinearVelocity = Instance.new("LinearVelocity");
            LinearVelocity.Parent = Attachment;
            Attachment.Name = "dash_thang_123asd";
            LinearVelocity.Attachment0 = Attachment;
            LinearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Line;
            LinearVelocity.MaxForce = 20000;
            LinearVelocity.LineDirection = UpVector;
            LinearVelocity.LineVelocity = v4;
            Attachment.Parent = HumanoidRootPart;
            DebrisModule:AddItem(Attachment, 0.165);
            game.ReplicatedStorage.Communication.CnC.ClientEffects:Fire("Double_Jump_Effect", HumanoidRootPart, UpVector);
            local v5 = workspace:Raycast(HumanoidRootPart.Position, Vector3.new(0, -10, 0), RaycastHelper.Crater);
            local v6 = (v5 == nil or v5.Instance == nil) and "Air" or "Land";
            Combat_presets.stop_extra_anims(p2.Character.Humanoid, { "Swing_6", "Swing_7" });
            local v7 = Character_info_provider.get_core_anim(p2, "double_jump") or game.ReplicatedStorage.Assets.Animations.Dashes[v6]:FindFirstChild("Dash_Space");
            p2.Character.Humanoid.Animator:LoadAnimation(v7):Play();
        end;
    end;
end;

function v1.UnHold(p8) -- Line: 66
end;

function v1.Cancel(p9) -- Line: 69
end;

return v1;
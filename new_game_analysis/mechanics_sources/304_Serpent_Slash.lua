-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local DebrisModule = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));
local u1 = {
    Id = 0
};
local _ = Vector3.new;
local Platform_Handler = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Controllers"):WaitForChild("Platform_Handler"));
local Utility = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Utility"));
local SkillAimMarker = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Modules"):WaitForChild("Effects"):WaitForChild("SkillAimMarker"));
local u2 = nil;
local _ = table.find;
local _ = table.remove;
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Checker"));
local Config = require(script.Parent.Config);
local AIM_RADIUS = Config.AIM_RADIUS;
local u3 = nil;
local RaycastHelper = require(ReplicatedStorage.CAM.Global.RaycastHelper);
local gameSettings = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("gameSettings"));

function u1.Hold(p4) -- Line: 22
    -- upvalues: u1 (copy), u2 (ref), u3 (ref), Utility (copy), gameSettings (copy), SkillAimMarker (copy), DebrisModule (copy), RaycastHelper (copy), Platform_Handler (copy), AIM_RADIUS (copy), Config (copy)
    local _ = u1.Id;
    local Character = p4.Character;
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
    local Humanoid = Character:FindFirstChild("Humanoid");

    if u2 then
        u2:Stop();
        u2 = nil;
    end;

    if u3 then
        u3:Destroy();
        u3 = nil;
    end;

    local Id = u1.Id;
    Utility.getvaluesfolder(Character);
    local Attachment = Instance.new("Attachment", HumanoidRootPart);
    Attachment.Name = "skill_stand_still";
    local LinearVelocity = Instance.new("LinearVelocity");
    LinearVelocity.Attachment0 = Attachment;
    LinearVelocity.Name = "bv";
    LinearVelocity.ForceLimitMode = Enum.ForceLimitMode.PerAxis;
    LinearVelocity.MaxAxesForce = Vector3.new(gameSettings.skillStandStillForce, 0, gameSettings.skillStandStillForce);
    LinearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector;
    LinearVelocity.VectorVelocity = Vector3.new(0, 0, 0);
    LinearVelocity.Parent = Attachment;
    local v5, v6 = Utility.CreateAlignOrientationWithAttachment(HumanoidRootPart, "skill_look_at", {
        Responsiveness = 70,
        MaxTorque = 500000
    });
    local u7 = v5;
    local u8 = v6;
    task.spawn(function() -- Line: 56
        -- upvalues: u3 (ref), SkillAimMarker (ref), DebrisModule (ref), Attachment (ref), HumanoidRootPart (copy), LinearVelocity (copy), u8 (ref), RaycastHelper (ref), Platform_Handler (ref), AIM_RADIUS (ref), Character (copy), u7 (ref), Utility (ref)
        u3 = SkillAimMarker.new({
            Dot = true,
            Highlight = true
        });
        DebrisModule:AddItem(u3, 15);

        while Attachment ~= nil and (HumanoidRootPart and (LinearVelocity ~= nil and (Attachment.Parent == HumanoidRootPart and (LinearVelocity.Parent == Attachment and (Attachment.Name == "skill_stand_still" and (u8:FindFirstChild("Cancel") == nil and LinearVelocity:FindFirstChild("Cancel") == nil)))))) do
            local v9, _, _, v10 = RaycastHelper.MaximizeRayClient(HumanoidRootPart.Position, Platform_Handler.mousepos(), AIM_RADIUS, true, 3);

            if u3 then
                u3:Update({
                    position = v9,
                    target = v10
                });
            end;

            local v11 = Character:FindFirstChild("PosPart" .. script.Name .. "Server");

            if v11 then
                v11.Position = v9;
                v11.bp.Position = v9;
            end;

            if v10 ~= nil then
                v9 = v10.PrimaryPart.Position or v9;
            end;

            u7.CFrame = Utility.SafeLookAt(HumanoidRootPart.Position, v9, u7.CFrame);
            task.wait();
        end;

        task.wait(0.2);

        if u3 then
            u3:Destroy();
            u3 = nil;
        end;
    end);
    u2 = Humanoid.Animator:LoadAnimation(script.SerpentSlash_Start);
    u2:Play(0.1, 1, 1);
    task.wait(Config.HOLD_FREEZE_AT);

    if u1.Id ~= Id then
        return;
    end;

    u2:AdjustSpeed(0);
end;

local function destroyBodyMovers(p12) -- Line: 102
    -- upvalues: u3 (ref)
    if u3 then
        u3:Destroy();
        u3 = nil;
    end;

    if p12 then
        local HumanoidRootPart = p12:FindFirstChild("HumanoidRootPart");
        p12:FindFirstChild("Humanoid");

        if HumanoidRootPart ~= nil and (HumanoidRootPart:FindFirstChild("skill_stand_still") ~= nil or HumanoidRootPart:FindFirstChild("skill_look_at") ~= nil) then
            for _, child in pairs(HumanoidRootPart:GetChildren()) do
                if child.Name == "skill_stand_still" or child.Name == "skill_look_at" then
                    child:Destroy();
                end;
            end;
        end;
    end;
end;

function u1.UnHold(p13) -- Line: 124
    -- upvalues: u1 (copy), u2 (ref), Config (copy), destroyBodyMovers (copy)
    local _ = u1.Id;
    local Character = p13.Character;
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
    Character:FindFirstChild("Humanoid");

    if u2 then
        u2:AdjustSpeed(1);
    end;

    if HumanoidRootPart:FindFirstChild("skill_look_at") ~= nil then
        Instance.new("BoolValue", HumanoidRootPart:FindFirstChild("skill_look_at")).Name = "Cancel";
    end;

    task.wait(Config.UNHOLD_RELEASE_DUR);
    destroyBodyMovers(Character);
end;

function u1.Cancel(p14) -- Line: 141
    -- upvalues: u2 (ref), destroyBodyMovers (copy)
    local Character = p14.Character;
    Character:FindFirstChild("HumanoidRootPart");
    Character:FindFirstChild("Humanoid");

    if u2 then
        u2:Stop();
        u2 = nil;
    end;

    destroyBodyMovers(Character);
end;

return u1;
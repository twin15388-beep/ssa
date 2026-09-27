-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("RunService");
game:GetService("TweenService");
game:GetService("CollectionService");
local CAM = ReplicatedStorage.CAM;
local Global = CAM.Global;
require(CAM.Client.Controllers.Platform_Handler);
local DebrisModule = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));
local Platform_Handler = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Controllers"):WaitForChild("Platform_Handler"));
require(game.ReplicatedStorage.Packages.cleanit).new();
local Utility = require(Global.Utility);
require(CAM.DebrisModule);
require(Global.Subsets.Gameplay.ManuelCancel);
local Config = require(script.Parent.Config);
local u1 = {
    Id = 0
};
local u2 = {};
local u3 = nil;
local u4 = false;
local Vector3_new = Vector3.new;
local TweenService = game:GetService("TweenService");

local function canceleverything(p5, p6, p7) -- Line: 38
    -- upvalues: u4 (ref), TweenService (copy), Vector3_new (copy), DebrisModule (copy)
    if u4 == true then
        return;
    end;

    local Character = p5.Character;

    if Character == nil then
        return;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
    local Humanoid = Character:FindFirstChild("Humanoid");

    if HumanoidRootPart == nil or Humanoid == nil then
        return;
    end;

    if HumanoidRootPart:FindFirstChild("skill_stand_still") ~= nil or HumanoidRootPart:FindFirstChild("skill_look_at") then
        for _, child in pairs(HumanoidRootPart:GetChildren()) do
            if child.Name == "skill_stand_still" or child.Name == "skill_look_at" then
                if child.Name == "skill_stand_still" then
                    if p6 == "customtimer" then
                        task.delay(0.1, function() -- Line: 51
                            -- upvalues: child (copy), TweenService (ref), Vector3_new (ref)
                            if child ~= nil and child:FindFirstChild("bp") ~= nil then
                                TweenService:Create(child.bp, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
                                    VectorVelocity = Vector3_new()
                                }):Play();
                            end;
                        end);
                    else
                        TweenService:Create(child.bp, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
                            VectorVelocity = Vector3_new()
                        }):Play();
                    end;
                end;

                local BoolValue = Instance.new("BoolValue");
                BoolValue.Name = "Cancel";
                BoolValue.Parent = child;
                DebrisModule:AddItem(child, p6 == "customtimer" and p7 and p7 or 0.25);
            end;
        end;
    end;
end;

function u1.Hold(p8: userdata) -- Line: 68
    -- upvalues: u4 (ref), u1 (copy), u3 (ref), u2 (copy), Utility (copy), DebrisModule (copy), Platform_Handler (copy), Config (copy), Vector3_new (copy)
    local Humanoid = p8.Character:FindFirstChild("Humanoid");
    local _ = Humanoid.RootPart;
    Humanoid:FindFirstChild("Animator");
    u4 = false;
    local Character = p8.Character;
    local HumanoidRootPart = Character.HumanoidRootPart;
    local Humanoid2 = Character.Humanoid;
    local _ = u1.Id;

    if u3 then
        u3:Stop();
        u3 = nil;
    end;

    for _, v in pairs(u2) do
        v:Destroy();
    end;

    local valuesfolder = Utility.getvaluesfolder(Character);
    local BoolValue = Instance.new("BoolValue");
    BoolValue.Name = "NOMouvementlines";
    BoolValue.Parent = valuesfolder;
    DebrisModule:AddItem(BoolValue, 5);
    table.insert(u2, BoolValue);
    local Attachment = Instance.new("Attachment", HumanoidRootPart);
    Attachment.Name = "skill_stand_still";
    local LinearVelocity = Instance.new("LinearVelocity");
    LinearVelocity.Attachment0 = Attachment;
    LinearVelocity.Name = "bp";
    LinearVelocity.ForceLimitMode = Enum.ForceLimitMode.PerAxis;
    LinearVelocity.MaxAxesForce = Vector3.new(10000, 0, 10000);
    LinearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector;
    local u9 = Platform_Handler.mousepos(Config.MOUSE_RANGE);
    LinearVelocity.VectorVelocity = (Vector3_new(u9.X, HumanoidRootPart.Position.Y, u9.Z) - HumanoidRootPart.Position).Unit * 0;
    LinearVelocity.Parent = Attachment;
    local u10, u11 = Utility.CreateAlignOrientationWithAttachment(HumanoidRootPart, "skill_look_at", {
        Responsiveness = 45,
        MaxTorque = 1000,
        AlignType = Enum.AlignType.PrimaryAxisParallel,
        CFrame = Utility.SafeLookAt(HumanoidRootPart.Position, u9, HumanoidRootPart.CFrame)
    });
    u3 = Humanoid2.Animator:LoadAnimation(script.anim);
    u3:Play();
    task.delay(Config.DASH_START_DELAY, function() -- Line: 117
        -- upvalues: u4 (ref), Attachment (copy), HumanoidRootPart (copy), LinearVelocity (copy), u11 (copy), u9 (ref), Platform_Handler (ref), Config (ref), Vector3_new (ref), u10 (copy), Utility (ref)
        if u4 == true then
            return;
        end;

        while Attachment ~= nil and (HumanoidRootPart and (LinearVelocity ~= nil and (Attachment.Parent == HumanoidRootPart and (LinearVelocity.Parent == Attachment and (Attachment.Name == "skill_stand_still" and (u11:FindFirstChild("Cancel") == nil and LinearVelocity:FindFirstChild("Cancel") == nil)))))) do
            u9 = Platform_Handler.mousepos(Config.MOUSE_RANGE);
            local v12 = (Vector3_new(u9.X, HumanoidRootPart.Position.Y, u9.Z) - HumanoidRootPart.Position).Unit * Config.DASH_SPEED;
            LinearVelocity.VectorVelocity = LinearVelocity.VectorVelocity:Lerp(v12, 0.15);
            u10.CFrame = Utility.SafeLookAt(HumanoidRootPart.Position, u9, u10.CFrame);
            task.wait();
        end;
    end);
end;

function u1.UnHold(u13) -- Line: 134
    -- upvalues: u4 (ref), canceleverything (copy), u3 (ref), Config (copy)
    task.spawn(function() -- Line: 135
        -- upvalues: u4 (ref), canceleverything (ref), u13 (copy)
        if u4 then
            return;
        end;

        canceleverything(u13, "customtimer", 0.35);
    end);
    local Character = u13.Character;

    if Character == nil then
        return;
    end;

    if Character:FindFirstChild("Humanoid") == nil then
        return;
    end;

    u4 = true;

    if u3 ~= nil and u3.TimePosition < Config.RELEASE_ANIM_TIME then
        u3.TimePosition = Config.RELEASE_ANIM_TIME;
    end;
end;

function u1.Cancel(p14) -- Line: 152
    -- upvalues: canceleverything (copy), u4 (ref), u3 (ref)
    canceleverything(p14, "customtimer", 0.35);
    u4 = true;

    if u3 then
        u3:Stop();
        u3 = nil;
    end;
end;

return u1;
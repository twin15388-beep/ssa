-- Decompiled with Potassium's decompiler.

local DebrisModule = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));
local u1 = {
    Id = 0
};
local _ = Vector3.new;
local Platform_Handler = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Controllers"):WaitForChild("Platform_Handler"));
local u2 = nil;
local _ = os.clock;
local Debris = game:GetService("Debris");
game:GetService("TweenService");
TweenInfo.new(0.115, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0);
local u3 = {};
local Utility = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Utility"));
local Config = require(script.Parent.Config);
local gameSettings = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("gameSettings"));

function u1.Hold(p4) -- Line: 15
    -- upvalues: u1 (copy), u2 (ref), u3 (copy), gameSettings (copy), Platform_Handler (copy), Utility (copy), Config (copy)
    local Character = p4.Character;
    local HumanoidRootPart = Character.HumanoidRootPart;
    local Humanoid = Character.Humanoid;
    local _ = u1.Id;

    if u2 then
        u2:Stop();
        u2 = nil;
    end;

    for _, v in pairs(u3) do
        v:Destroy();
    end;

    u2 = Humanoid.Animator:LoadAnimation(script.coilchoke_start_up_anim);
    u2:Play();
    u2:AdjustSpeed(0);
    local Attachment = Instance.new("Attachment", HumanoidRootPart);
    Attachment.Name = "skill_stand_still";
    local LinearVelocity = Instance.new("LinearVelocity");
    LinearVelocity.Attachment0 = Attachment;
    LinearVelocity.MaxForce = gameSettings.skillStandStillForce;
    LinearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector;
    local u5 = Platform_Handler.mousepos(1500);
    LinearVelocity.VectorVelocity = Vector3.new(0, 0, 0);
    LinearVelocity.Parent = Attachment;
    local u6, u7 = Utility.CreateAlignOrientationWithAttachment(HumanoidRootPart, "skill_look_at", {
        Responsiveness = 20,
        MaxTorque = 10000,
        AlignType = Enum.AlignType.PrimaryAxisParallel,
        CFrame = Utility.SafeLookAt(HumanoidRootPart.Position, u5, HumanoidRootPart.CFrame)
    });
    task.spawn(function() -- Line: 51
        -- upvalues: Attachment (copy), HumanoidRootPart (copy), LinearVelocity (copy), u7 (copy), u5 (ref), Platform_Handler (ref), Config (ref), u6 (copy), Utility (ref)
        while Attachment ~= nil and (HumanoidRootPart and (LinearVelocity ~= nil and (Attachment.Parent == HumanoidRootPart and (LinearVelocity.Parent == Attachment and (Attachment.Name == "skill_stand_still" and (u7:FindFirstChild("Cancel") == nil and LinearVelocity:FindFirstChild("Cancel") == nil)))))) do
            u5 = Platform_Handler.mousepos(Config.MOUSE_RANGE);
            u6.CFrame = Utility.SafeLookAt(HumanoidRootPart.Position, u5, u6.CFrame);
            task.wait();
        end;

        if u6 and u7:FindFirstChild("Cancel") ~= nil then
            LinearVelocity.VectorVelocity = Vector3.new(0, 0, 0);
        end;
    end);
end;

local ManuelCancel = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Subsets"):WaitForChild("Gameplay"):WaitForChild("ManuelCancel"));

function u1.UnHold(p8) -- Line: 69
    -- upvalues: u3 (copy), Debris (copy), Config (copy), u1 (copy), u2 (ref), Utility (copy), DebrisModule (copy), ManuelCancel (copy)
    for _, v in pairs(u3) do
        Debris:AddItem(v, Config.UNHOLD_LOCK_DUR);
    end;

    local _ = u1.Id;
    local Character = p8.Character;

    if Character == nil then
        return;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
    local Humanoid = Character:FindFirstChild("Humanoid");

    if HumanoidRootPart == nil or Humanoid == nil then
        return;
    end;

    if u2 then
        u2:AdjustSpeed(1);
    end;

    if HumanoidRootPart:FindFirstChild("skill_stand_still") ~= nil or HumanoidRootPart:FindFirstChild("skill_look_at") then
        for _, child in pairs(HumanoidRootPart:GetChildren()) do
            if child.Name == "skill_stand_still" or child.Name == "skill_look_at" then
                local BoolValue = Instance.new("BoolValue");
                BoolValue.Name = "Cancel";
                BoolValue.Parent = child;
                Debris:AddItem(child, Config.UNHOLD_LOCK_DUR);
            end;
        end;
    end;

    local valuesfolder = Utility.getvaluesfolder(Character);
    local StringValue = Instance.new("StringValue");
    StringValue.Name = "NR";
    StringValue.Value = script.Parent.Name;
    StringValue.Parent = valuesfolder;
    DebrisModule:AddItem(StringValue, Config.UNHOLD_LOCK_DUR);
    table.insert(u3, StringValue);
    local v9, _ = ManuelCancel.new(p8, Config.UNHOLD_CANCEL_WINDOW);
    v9:Connect(function() -- Line: 102
        -- upvalues: u1 (ref), u2 (ref), u3 (ref), HumanoidRootPart (copy)
        u1.Id = math.random(1, 9999999);

        if u2 and u2.IsPlaying then
            u2:Stop();
            u2:Destroy();
        end;

        for _, v in pairs(u3) do
            if v:IsDescendantOf(workspace) then
                v:Destroy();
            end;

            if HumanoidRootPart:FindFirstChild("skill_stand_still") ~= nil or HumanoidRootPart:FindFirstChild("skill_look_at") then
                for _, child in pairs(HumanoidRootPart:GetChildren()) do
                    if child.Name == "skill_stand_still" or child.Name == "skill_look_at" then
                        child:Destroy();
                    end;
                end;
            end;
        end;
    end);
    task.wait(Config.UNHOLD_LOCK_DUR);
end;

function u1.Cancel(p10) -- Line: 126
    -- upvalues: u3 (copy), u1 (copy), u2 (ref)
    for _, v in pairs(u3) do
        v:Destroy();
    end;

    local Id = u1.Id;
    local Character = p10.Character;

    if Character == nil then
        return;
    end;

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
    local Humanoid = Character:FindFirstChild("Humanoid");

    if HumanoidRootPart == nil or Humanoid == nil then
        return;
    end;

    if u1.Id == Id and u2 then
        u2:Stop();
        u2 = nil;
    end;

    if HumanoidRootPart:FindFirstChild("skill_stand_still") ~= nil or HumanoidRootPart:FindFirstChild("skill_look_at") then
        for _, child in pairs(HumanoidRootPart:GetChildren()) do
            if child.Name == "skill_stand_still" or child.Name == "skill_look_at" then
                local BoolValue = Instance.new("BoolValue");
                BoolValue.Name = "Cancel";
                BoolValue.Parent = child;
                child:Destroy();
            end;
        end;
    end;
end;

return u1;
-- Decompiled with Potassium's decompiler.

local DebrisModule = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));
local u1 = {
    Id = 0
};
game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u2 = nil;
local Platform_Handler = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Controllers"):WaitForChild("Platform_Handler"));
local Utility = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Utility"));
local _ = table.find;
local _ = table.remove;
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Checker"));
local Config = require(script.Parent.Config);
local u3 = {};
local RaycastHelper = require(ReplicatedStorage.CAM.Global.RaycastHelper);

function u1.Hold(p4) -- Line: 20
    -- upvalues: u2 (ref), u1 (copy), Utility (copy), u3 (copy), DebrisModule (copy), Config (copy), RaycastHelper (copy), Platform_Handler (copy)
    if u2 then
        u2:Stop();
        u2 = nil;
    end;

    local Id = u1.Id;
    local Character = p4.Character;
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
    local Humanoid = Character:FindFirstChild("Humanoid");
    local Attachment = Instance.new("Attachment", HumanoidRootPart);
    Attachment.Name = "skill_stand_still";
    local LinearVelocity = Instance.new("LinearVelocity");
    LinearVelocity.Attachment0 = Attachment;
    LinearVelocity.MaxForce = 10000;
    LinearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector;
    LinearVelocity.VectorVelocity = Vector3.new();
    LinearVelocity.Parent = Attachment;
    local u5, u6 = Utility.CreateAlignOrientationWithAttachment(HumanoidRootPart, "skill_look_at", {
        Responsiveness = 80,
        MaxTorque = 3000
    });
    local valuesfolder = Utility.getvaluesfolder(Character);
    local v7 = script.ground_ef:Clone();
    v7.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, -2.5, 0);
    v7.Parent = workspace.Debree;
    v7.base_ef123asd:Emit(1);
    table.insert(u3, v7);
    DebrisModule:AddItem(v7, 6);
    local BoolValue = Instance.new("BoolValue");
    BoolValue.Name = "NR";
    BoolValue.Parent = valuesfolder;
    DebrisModule:AddItem(BoolValue, Config.HOLD_NR_DURATION);
    table.insert(u3, BoolValue);
    local Highlight = Instance.new("Highlight");
    Highlight.FillColor = Color3.fromRGB(255, 101, 29);
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded;
    Highlight.OutlineColor = Color3.fromRGB(255, 25, 25);
    DebrisModule:AddItem(Highlight, 15);
    table.insert(u3, Highlight);
    task.spawn(function() -- Line: 68
        -- upvalues: Attachment (copy), HumanoidRootPart (copy), LinearVelocity (copy), u6 (copy), RaycastHelper (ref), Platform_Handler (ref), Config (ref), Highlight (copy), u5 (copy), Utility (ref)
        while Attachment ~= nil and (HumanoidRootPart and (LinearVelocity ~= nil and (Attachment.Parent == HumanoidRootPart and (LinearVelocity.Parent == Attachment and (Attachment.Name == "skill_stand_still" and (u6:FindFirstChild("Cancel") == nil and LinearVelocity:FindFirstChild("Cancel") == nil)))))) do
            local v8, _, _, v9 = RaycastHelper.MaximizeRayClient(HumanoidRootPart.Position, Platform_Handler.mousepos(), Config.AIM_RANGE, true, 5, 7, 3);

            if v9 == nil then
                if Highlight then
                    Highlight.Parent = workspace.Debree;
                end;
            elseif Highlight and v9:FindFirstChild("HumanoidRootPart") then
                Highlight.Parent = v9;
            end;

            u5.CFrame = Utility.SafeLookAt(HumanoidRootPart.Position, v8, u5.CFrame);
            task.wait();
        end;

        task.wait(0.2);
        Highlight:Destroy();
    end);
    u2 = Humanoid.Animator:LoadAnimation(script.Initiate);
    u2:Play(nil, nil, Config.HOLD_ANIM_SPEED);
    task.wait(Config.HOLD_FREEZE_AT);

    if Id == u1.Id then
        u2:AdjustSpeed(0);
    end;
end;

function u1.UnHold(p10, p11) -- Line: 101
    -- upvalues: u1 (copy), u3 (copy), DebrisModule (copy), Config (copy), u2 (ref), RaycastHelper (copy)
    local _ = u1.Id;
    local Character = p10.Character;

    for _, v in pairs(u3) do
        if v.Name == "NR" then
            DebrisModule:AddItem(v, Config.RELEASE_NR_DURATION);
        else
            v:Destroy();
        end;
    end;

    if Character ~= nil then
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
        Character:FindFirstChild("Humanoid");

        if u2 then
            u2:AdjustSpeed(Config.INITIATE_ANIM_SPEED);
        end;

        if HumanoidRootPart ~= nil then
            local v12 = nil;

            if HumanoidRootPart:FindFirstChild("skill_stand_still") ~= nil or HumanoidRootPart:FindFirstChild("skill_look_at") then
                for _, child in pairs(HumanoidRootPart:GetChildren()) do
                    if child.Name == "skill_look_at" then
                        local BoolValue = Instance.new("BoolValue");
                        BoolValue.Name = "Cancel";
                        BoolValue.Parent = child;
                        DebrisModule:AddItem(child, Config.DASH_DURATION);
                    elseif child.Name == "skill_stand_still" then
                        child:ClearAllChildren();
                        DebrisModule:AddItem(child, Config.DASH_DURATION);
                        local u13 = {};
                        table.insert(u13, child.AncestryChanged:Connect(function() -- Line: 135, Name: cleanUp
                            -- upvalues: u13 (copy)
                            for _, v in pairs(u13) do
                                v:Disconnect();
                            end;
                        end));
                        table.insert(u13, Character.AttributeChanged:Connect(function(p14: string) -- Line: 142
                            -- upvalues: u13 (copy), child (copy)
                            if p14 ~= script.Parent.Name:gsub(" ", "") .. "UpDrafted" then
                                return;
                            end;

                            for _, v in pairs(u13) do
                                v:Disconnect();
                            end;

                            child:Destroy();
                        end));
                        v12 = child;
                    end;
                end;
            end;

            if HumanoidRootPart:FindFirstChild("air_combo_bp") ~= nil then
                HumanoidRootPart.air_combo_bp:Destroy();
            end;

            local v15, _, _, _ = RaycastHelper.MaximizeRayClient(HumanoidRootPart.Position, p11, Config.AIM_RANGE, true, 5, 7, 2.5);
            local AlignPosition = Instance.new("AlignPosition");
            AlignPosition.Attachment0 = v12;
            AlignPosition.Mode = Enum.PositionAlignmentMode.OneAttachment;
            AlignPosition.Position = v15;
            AlignPosition.MaxForce = Config.DASH_MAX_FORCE;
            AlignPosition.Responsiveness = Config.DASH_RESPONSIVENESS;
            AlignPosition.MaxVelocity = Config.DASH_MAX_VELOCITY;
            AlignPosition.Parent = v12;
            v12.Destroying:Connect(function() -- Line: 168
                -- upvalues: HumanoidRootPart (copy)
                if HumanoidRootPart ~= nil and HumanoidRootPart.Parent ~= nil then
                    HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
                    HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
                end;
            end);
        end;
    end;

    task.wait(Config.DASH_DURATION);
    local v16 = Character ~= nil and Character:FindFirstChild("HumanoidRootPart") or nil;

    if v16 ~= nil then
        v16.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
        v16.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
    end;
end;

function u1.Cancel(p17) -- Line: 188
    -- upvalues: u2 (ref), u3 (copy)
    if u2 then
        u2:Stop();
        u2 = nil;
    end;

    for _, v in pairs(u3) do
        v:Destroy();
    end;

    local Character = p17.Character;

    if Character ~= nil then
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");
        Character:FindFirstChild("Humanoid");

        if HumanoidRootPart ~= nil and (HumanoidRootPart:FindFirstChild("skill_stand_still") ~= nil or HumanoidRootPart:FindFirstChild("skill_look_at")) then
            for _, child in pairs(HumanoidRootPart:GetChildren()) do
                if child.Name == "skill_stand_still" or child.Name == "skill_look_at" then
                    child:Destroy();
                end;
            end;
        end;
    end;
end;

return u1;
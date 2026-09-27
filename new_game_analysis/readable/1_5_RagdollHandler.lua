-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local u1 = {
    [Enum.HumanoidStateType.Physics] = true
};
local u2 = {};
local u3 = {};

function setRagdollEnabled(p4, p5)
    -- upvalues: u3 (copy)
    if u3[p4] == nil then
        u3[p4] = not p5;
    end;

    if u3[p4] ~= p5 then
        u3[p4] = p5;
        local RagdollConstraints = p4.Parent:FindFirstChild("RagdollConstraints");

        if RagdollConstraints ~= nil then
            for _, child in pairs(RagdollConstraints:GetChildren()) do
                if child:IsA("Constraint") and child:FindFirstChild("RigidJoint") ~= nil then
                    local Value = child.RigidJoint.Value;
                    local v6;

                    if p5 or (child == nil or (child.Attachment1 == nil or child.Attachment1.Parent == nil)) then
                        v6 = nil;
                    else
                        v6 = child.Attachment1.Parent or nil;
                    end;

                    if Value ~= nil and Value.Part1 ~= v6 then
                        Value.Part1 = v6;
                    end;
                end;
            end;
        end;
    end;
end;

function hasRagdollOwnership(p7)
    -- upvalues: RunService (copy), Players (copy)
    return RunService:IsServer() and true or Players:GetPlayerFromCharacter(p7.Parent) == Players.LocalPlayer;
end;

function ragdollAdded(u8)
    -- upvalues: u2 (copy), u1 (copy)
    u2[u8] = u8.StateChanged:Connect(function(p9, p10) -- Line: 54
        -- upvalues: u8 (copy), u1 (ref)
        local v11 = setRagdollEnabled;
        local v12;

        if u1[u8:GetState()] == nil then
            v12 = false;
        else
            v12 = u1[u8:GetState()] == true;
        end;

        v11(u8, v12);
    end);
end;

function ragdollRemoved(p13)
    -- upvalues: u2 (copy)
    u2[p13]:Disconnect();
    u2[p13] = nil;
end;

CollectionService:GetInstanceAddedSignal("Ragdoll"):Connect(ragdollAdded);
CollectionService:GetInstanceRemovedSignal("Ragdoll"):Connect(ragdollRemoved);

for _, v in pairs(CollectionService:GetTagged("Ragdoll")) do
    ragdollAdded(v);
end;

return nil;
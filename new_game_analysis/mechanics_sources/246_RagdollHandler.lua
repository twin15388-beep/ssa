-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u1 = game:GetService("RunService"):IsServer();
local u2 = {
    [Enum.HumanoidStateType.Physics] = true
};
local u3 = {};
local u4 = {};

function setRagdollEnabled(p5, p6)
    -- upvalues: u4 (copy)
    if u4[p5] == nil then
        u4[p5] = not p6;
    end;

    if u4[p5] ~= p6 then
        u4[p5] = p6;
        local RagdollConstraints = p5.Parent:FindFirstChild("RagdollConstraints");

        if RagdollConstraints ~= nil then
            for _, child in pairs(RagdollConstraints:GetChildren()) do
                if child:IsA("Constraint") and child:FindFirstChild("RigidJoint") ~= nil then
                    local Value = child.RigidJoint.Value;
                    local v7;

                    if p6 or (child == nil or (child.Attachment1 == nil or child.Attachment1.Parent == nil)) then
                        v7 = nil;
                    else
                        v7 = child.Attachment1.Parent or nil;
                    end;

                    if Value ~= nil and Value.Part1 ~= v7 then
                        Value.Part1 = v7;
                    end;
                end;
            end;
        end;
    end;
end;

local u8 = { "RagDoll", "ragdoll", "Ragdoll", "ragDoll" };

local function followsState(p9, p10) -- Line: 48
    -- upvalues: Players (copy), u1 (copy), ReplicatedStorage (copy), u8 (copy)
    local PlayerFromCharacter = Players:GetPlayerFromCharacter(p9.Parent);

    if PlayerFromCharacter == nil then
        return true;
    end;

    if not u1 then
        return PlayerFromCharacter == Players.LocalPlayer;
    end;

    if not p10 then
        return true;
    end;

    local Player_Service = ReplicatedStorage:FindFirstChild("Player_Service");
    local v11 = Player_Service ~= nil and Player_Service.Values:FindFirstChild(PlayerFromCharacter.Name) or nil;

    if v11 == nil or v11:FindFirstChild("noragdoll") ~= nil then
        return false;
    end;

    for _, v in u8 do
        if v11:FindFirstChild(v) ~= nil then
            return true;
        end;
    end;

    return false;
end;

function ragdollAdded(u12)
    -- upvalues: u3 (copy), u2 (copy), followsState (copy)
    u3[u12] = u12.StateChanged:Connect(function() -- Line: 63
        -- upvalues: u2 (ref), u12 (copy), followsState (ref)
        local v13 = u2[u12:GetState()] == true;

        if followsState(u12, v13) then
            setRagdollEnabled(u12, v13);
        end;
    end);
end;

function ragdollRemoved(p14)
    -- upvalues: u3 (copy), u4 (copy)
    u3[p14]:Disconnect();
    u3[p14] = nil;
    u4[p14] = nil;
end;

CollectionService:GetInstanceAddedSignal("Ragdoll"):Connect(ragdollAdded);
CollectionService:GetInstanceRemovedSignal("Ragdoll"):Connect(ragdollRemoved);

for _, v in pairs(CollectionService:GetTagged("Ragdoll")) do
    ragdollAdded(v);
end;

return nil;
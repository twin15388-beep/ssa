-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local ChapeuMeshSkinning = require(ReplicatedStorage:WaitForChild("ChapeuMeshSkinning"));

for _, descendant in workspace:GetDescendants() do
    if descendant:IsA("MeshPart") and descendant:GetAttribute("ProceduralHatSkinning") == true then
        CollectionService:RemoveTag(descendant, "SmartBone");
        local success, result = pcall(ChapeuMeshSkinning.Build, descendant);

        if not success then
            warn("ChapeuMesh skinning: " .. tostring(result));
        end;
    end;
end;

local VampireCapeSkinning = require(ReplicatedStorage:WaitForChild("VampireCapeSkinning"));

for _, descendant in workspace:GetDescendants() do
    if descendant:IsA("MeshPart") and descendant:GetAttribute("ProceduralCapeSkinning") == true then
        CollectionService:RemoveTag(descendant, "SmartBone");
        local success, result = pcall(VampireCapeSkinning.Build, descendant);

        if not success then
            warn("VampireCape skinning: " .. tostring(result));
        end;
    end;
end;

script:SetAttribute("CapeSkinningInitialized", true);
script:SetAttribute("HatSkinningInitialized", true);
require(ReplicatedStorage:WaitForChild("SmartBone")).Start();
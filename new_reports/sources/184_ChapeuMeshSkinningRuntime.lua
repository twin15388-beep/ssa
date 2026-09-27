-- Decompiled with Potassium's decompiler.

local SmartBoneRuntime = script.Parent:WaitForChild("SmartBoneRuntime");

while SmartBoneRuntime:GetAttribute("HatSkinningInitialized") ~= true do
    task.wait();
end;

local ChapeuMeshSkinning = require(game:GetService("ReplicatedStorage"):WaitForChild("ChapeuMeshSkinning"));
local u1 = setmetatable({}, {
    __mode = "k"
});

local function prepare(u2) -- Line: 5
    -- upvalues: u1 (copy), ChapeuMeshSkinning (copy)
    if not (u2:IsA("MeshPart") and (u2:GetAttribute("ProceduralHatSkinning") == true and not u1[u2])) then
        return;
    end;

    u1[u2] = true;
    task.spawn(function() -- Line: 8
        -- upvalues: ChapeuMeshSkinning (ref), u2 (copy), u1 (ref)
        local success, result = pcall(ChapeuMeshSkinning.Build, u2);

        if not success then
            u1[u2] = nil;
            warn("ChapeuMesh: failed to create skinning: " .. tostring(result));
        end;
    end);
end;

for _, descendant in workspace:GetDescendants() do
    prepare(descendant);
end;

workspace.DescendantAdded:Connect(prepare);
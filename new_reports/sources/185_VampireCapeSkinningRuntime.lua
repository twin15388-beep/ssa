-- Decompiled with Potassium's decompiler.

local SmartBoneRuntime = script.Parent:WaitForChild("SmartBoneRuntime");

while SmartBoneRuntime:GetAttribute("CapeSkinningInitialized") ~= true do
    task.wait();
end;

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CollectionService = game:GetService("CollectionService");
local VampireCapeSkinning = require(ReplicatedStorage:WaitForChild("VampireCapeSkinning"));
local u1 = setmetatable({}, {
    __mode = "k"
});
local u2 = setmetatable({}, {
    __mode = "k"
});
local u3 = setmetatable({}, {
    __mode = "k"
});

local function isReady(p4) -- Line: 12
    -- upvalues: CollectionService (copy)
    local CapeAnchor = p4:FindFirstChild("CapeAnchor", true);
    local v5;

    if p4:GetAttribute("CapeSkinningReady") == true then
        v5 = CapeAnchor and CapeAnchor:IsA("Bone") and CollectionService:HasTag(p4, "SmartBone");
    else
        v5 = false;
    end;

    return v5;
end;

local function prepare(u6) -- Line: 19
    -- upvalues: CollectionService (copy), u2 (copy), u1 (copy), VampireCapeSkinning (copy)
    if not u6:IsA("MeshPart") or u6:GetAttribute("ProceduralCapeSkinning") ~= true then
        return;
    end;

    if not u6:IsDescendantOf(workspace) then
        return;
    end;

    local CapeAnchor = u6:FindFirstChild("CapeAnchor", true);
    local v7;

    if u6:GetAttribute("CapeSkinningReady") == true then
        v7 = CapeAnchor and CapeAnchor:IsA("Bone") and CollectionService:HasTag(u6, "SmartBone");
    else
        v7 = false;
    end;

    if v7 then
        u2[u6] = nil;

        return;
    end;

    u2[u6] = true;

    if u1[u6] then
        return;
    end;

    u1[u6] = true;
    task.spawn(function() -- Line: 29
        -- upvalues: u6 (copy), VampireCapeSkinning (ref), CollectionService (ref), u2 (ref), u1 (ref)
        local v8 = nil;

        for i = 1, 4 do
            if not u6:IsDescendantOf(workspace) or u6:GetAttribute("ProceduralCapeSkinning") ~= true then
                break;
            end;

            local success, result = pcall(VampireCapeSkinning.Build, u6);

            if success then
                local v9 = u6;
                local CapeAnchor2 = v9:FindFirstChild("CapeAnchor", true);
                local v10;

                if v9:GetAttribute("CapeSkinningReady") == true then
                    v10 = CapeAnchor2 and CapeAnchor2:IsA("Bone") and CollectionService:HasTag(v9, "SmartBone");
                else
                    v10 = false;
                end;

                if v10 then
                    u2[u6] = nil;
                    u1[u6] = nil;

                    return;
                end;
            end;

            if success then
                result = v8;
            end;

            task.wait(i * 0.35);
            v8 = result;
            local _ = i;
        end;

        u1[u6] = nil;

        if v8 then
            warn("VampireCape skinning: " .. tostring(v8));
        end;
    end);
end;

local function observe(u11) -- Line: 47
    -- upvalues: u3 (copy), prepare (copy), u2 (copy)
    if not u11:IsA("MeshPart") or u3[u11] then
        return;
    end;

    u3[u11] = u11:GetAttributeChangedSignal("ProceduralCapeSkinning"):Connect(function() -- Line: 49
        -- upvalues: u11 (copy), prepare (ref), u2 (ref)
        if u11:GetAttribute("ProceduralCapeSkinning") == true then
            prepare(u11);

            return;
        end;

        u2[u11] = nil;
    end);
    prepare(u11);
end;

for _, descendant in ipairs(workspace:GetDescendants()) do
    observe(descendant);
end;

workspace.DescendantAdded:Connect(observe);
workspace.DescendantRemoving:Connect(function(p12) -- Line: 61
    -- upvalues: u3 (copy), u2 (copy), u1 (copy)
    if p12:IsA("MeshPart") then
        local v13 = u3[p12];

        if v13 then
            v13:Disconnect();
        end;

        u3[p12] = nil;
        u2[p12] = nil;
        u1[p12] = nil;
    end;
end);
task.spawn(function() -- Line: 71
    -- upvalues: u2 (copy), prepare (copy)
    while true do
        task.wait(3);

        for i in pairs(u2) do
            if i:IsDescendantOf(workspace) then
                prepare(i);
            else
                u2[i] = nil;
            end;
        end;
    end;
end);
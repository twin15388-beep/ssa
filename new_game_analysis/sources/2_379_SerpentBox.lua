-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Inventory = require(ReplicatedStorage.CAM.Global.Utility).GetData(Players.LocalPlayer, true):WaitForChild("Inventory"):WaitForChild("Inventory");

local function gate(p1: userdata) -- Line: 17
    -- upvalues: Inventory (copy)
    local v2 = p1:FindFirstChildWhichIsA("ProximityPrompt", true);

    if v2 == nil then
        return;
    end;

    local v3 = Inventory:FindFirstChild("Serpent Key") ~= nil;

    if p1:HasTag("SerpentBox") then
        if v3 then
            v3 = Inventory:FindFirstChild("Nightfall Serpent Katana Schematic") == nil;
        end;
    else
        v3 = not v3;
    end;

    v2.Enabled = v3;
end;

local function refresh() -- Line: 26
    -- upvalues: CollectionService (copy), gate (copy)
    for _, v in { "SerpentKey", "SerpentBox" } do
        for _, v2 in CollectionService:GetTagged(v) do
            gate(v2);
        end;
    end;
end;

Inventory.ChildAdded:Connect(refresh);
Inventory.ChildRemoved:Connect(refresh);

local function track(u4: userdata) -- Line: 34
    -- upvalues: gate (copy)
    gate(u4);
    u4.DescendantAdded:Connect(function(p5) -- Line: 36
        -- upvalues: gate (ref), u4 (copy)
        if p5:IsA("ProximityPrompt") then
            gate(u4);
        end;
    end);
end;

for _, v in { "SerpentKey", "SerpentBox" } do
    for _, v2 in CollectionService:GetTagged(v) do
        gate(v2);
        v2.DescendantAdded:Connect(function(p6) -- Line: 36
            -- upvalues: gate (copy), v2 (copy)
            if p6:IsA("ProximityPrompt") then
                gate(v2);
            end;
        end);
    end;

    CollectionService:GetInstanceAddedSignal(v):Connect(track);
end;
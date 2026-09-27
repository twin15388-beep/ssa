-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Inventory = require(ReplicatedStorage.CAM.Global.Utility).GetData(Players.LocalPlayer, true):WaitForChild("Inventory"):WaitForChild("Inventory");

local function gate(p1: userdata) -- Line: 14
    -- upvalues: Inventory (copy)
    local Attribute = p1:GetAttribute("Item");
    local v2 = p1:FindFirstChildWhichIsA("ProximityPrompt", true);

    if type(Attribute) ~= "string" or v2 == nil then
        return;
    end;

    local v3 = not p1:GetAttribute("Locked") and Inventory:FindFirstChild(Attribute .. " Schematic") == nil;
    v2.Enabled = v3;
end;

local function refresh() -- Line: 21
    -- upvalues: CollectionService (copy), gate (copy)
    for _, v in CollectionService:GetTagged("StudyProp") do
        gate(v);
    end;
end;

Inventory.ChildAdded:Connect(refresh);
Inventory.ChildRemoved:Connect(refresh);

local function track(u4: userdata) -- Line: 27
    -- upvalues: gate (copy)
    gate(u4);
    u4.DescendantAdded:Connect(function(p5) -- Line: 29
        -- upvalues: gate (ref), u4 (copy)
        if p5:IsA("ProximityPrompt") then
            gate(u4);
        end;
    end);
    u4:GetAttributeChangedSignal("Locked"):Connect(function() -- Line: 32
        -- upvalues: gate (ref), u4 (copy)
        gate(u4);
    end);
end;

for _, v in CollectionService:GetTagged("StudyProp") do
    track(v);
end;

CollectionService:GetInstanceAddedSignal("StudyProp"):Connect(track);
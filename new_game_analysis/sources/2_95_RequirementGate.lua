-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ItemRequirements = require(ReplicatedStorage.CAM.Global.Collectibles.ItemRequirements);
local PlayerProgression = require(ReplicatedStorage.CAM.Global.PlayerProgression);
local Regions = require(ReplicatedStorage.Regions);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local LocalPlayer = Players.LocalPlayer;
local Data = Utility.GetData(LocalPlayer, true);
local u1 = {};

local function apply(p2: userdata) -- Line: 30
    -- upvalues: Regions (copy), ItemRequirements (copy), Data (copy), PlayerProgression (copy), LocalPlayer (copy)
    local Attribute = p2:GetAttribute("Npc");
    local Attribute2 = p2:GetAttribute("Side");

    if typeof(Attribute) ~= "string" and typeof(Attribute2) ~= "string" then
        return;
    end;

    local v3;

    if typeof(Attribute) == "string" then
        v3 = Regions.NpcRequirements[Attribute];
    else
        v3 = nil;
    end;

    local v4 = typeof(Attribute) ~= "string" and true or ItemRequirements.Passes(Data, v3);

    if typeof(Attribute2) == "string" then
        if v4 then
            v4 = table.find(PlayerProgression.SidesFor(LocalPlayer), Attribute2) ~= nil;
        end;
    end;

    if p2:IsA("ProximityPrompt") then
        p2.Enabled = v4;

        return;
    end;

    if p2:IsA("GuiObject") then
        p2.Visible = not v4;

        if p2:IsA("TextLabel") then
            p2.Text = ItemRequirements.Describe(v3, Data);
        end;
    end;
end;

local function refresh() -- Line: 51
    -- upvalues: u1 (copy), apply (copy)
    for i in u1 do
        if i.Parent == nil then
            u1[i] = nil;
        else
            apply(i);
        end;
    end;
end;

local function track(u5: userdata) -- Line: 61
    -- upvalues: u1 (copy), apply (copy)
    u1[u5] = true;
    apply(u5);

    if u5:IsA("ProximityPrompt") then
        u5:GetPropertyChangedSignal("Enabled"):Connect(function() -- Line: 66
            -- upvalues: u5 (copy), u1 (ref), apply (ref)
            if u5.Enabled and u1[u5] then
                apply(u5);
            end;
        end);
    end;
end;

local u6 = {};

local function watch(p7: string) -- Line: 75
    -- upvalues: u6 (copy), Data (copy), refresh (copy), ItemRequirements (copy)
    if u6[p7] then
        return;
    end;

    u6[p7] = true;

    if p7 ~= "Items" then
        local v8 = ItemRequirements.Resolve(Data, p7 == "Level" and "Exp.Goal" or p7);

        if v8 ~= nil then
            v8.Changed:Connect(refresh);
        end;

        return;
    end;

    local Inventory = Data:WaitForChild("Inventory"):WaitForChild("Inventory");
    Inventory.ChildAdded:Connect(refresh);
    Inventory.ChildRemoved:Connect(refresh);
end;

if not u6.Race then
    u6.Race = true;
    local v9 = ItemRequirements.Resolve(Data, "Race");

    if v9 ~= nil then
        v9.Changed:Connect(refresh);
    end;
end;

for _, v in Regions.NpcRequirements do
    for i in v do
        watch(i);
    end;
end;

for _, v in CollectionService:GetTagged("RequirementGate") do
    track(v);
end;

CollectionService:GetInstanceAddedSignal("RequirementGate"):Connect(track);
CollectionService:GetInstanceRemovedSignal("RequirementGate"):Connect(function(p10) -- Line: 103
    -- upvalues: u1 (copy)
    u1[p10] = nil;
end);
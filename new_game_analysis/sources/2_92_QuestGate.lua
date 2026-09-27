-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local LocalPlayer = Players.LocalPlayer;
local Quests2 = Utility.GetData(LocalPlayer, true):WaitForChild("Quests");
local u1 = {};

local function apply(p2: userdata) -- Line: 25
    -- upvalues: Quests (copy), LocalPlayer (copy)
    local Attribute = p2:GetAttribute("RequiresQuestDone");

    if typeof(Attribute) ~= "string" then
        return;
    end;

    local v3 = Quests.GetPlayerQuestState(LocalPlayer, Attribute) == "Done";

    if p2:IsA("ProximityPrompt") then
        p2.Enabled = v3;
    end;
end;

local function track(p4: userdata) -- Line: 34
    -- upvalues: u1 (copy), Quests (copy), LocalPlayer (copy)
    u1[p4] = true;
    local Attribute = p4:GetAttribute("RequiresQuestDone");

    if typeof(Attribute) ~= "string" then
        return;
    end;

    local v5 = Quests.GetPlayerQuestState(LocalPlayer, Attribute) == "Done";

    if p4:IsA("ProximityPrompt") then
        p4.Enabled = v5;
    end;
end;

for _, v in ipairs(CollectionService:GetTagged("QuestGate")) do
    u1[v] = true;
    local Attribute = v:GetAttribute("RequiresQuestDone");

    if typeof(Attribute) == "string" then
        local v6 = Quests.GetPlayerQuestState(LocalPlayer, Attribute) == "Done";

        if v:IsA("ProximityPrompt") then
            v.Enabled = v6;
        end;
    end;
end;

CollectionService:GetInstanceAddedSignal("QuestGate"):Connect(track);
CollectionService:GetInstanceRemovedSignal("QuestGate"):Connect(function(p7) -- Line: 43
    -- upvalues: u1 (copy)
    u1[p7] = nil;
end);

local function refresh() -- Line: 50
    -- upvalues: u1 (copy), Quests (copy), LocalPlayer (copy)
    for i in pairs(u1) do
        if i.Parent == nil then
            u1[i] = nil;
        else
            local Attribute = i:GetAttribute("RequiresQuestDone");

            if typeof(Attribute) == "string" then
                local v8 = Quests.GetPlayerQuestState(LocalPlayer, Attribute) == "Done";

                if i:IsA("ProximityPrompt") then
                    i.Enabled = v8;
                end;
            end;
        end;
    end;
end;

Quests2.DescendantAdded:Connect(refresh);
Quests2.DescendantRemoving:Connect(function() -- Line: 60
    -- upvalues: refresh (copy)
    task.defer(refresh);
end);
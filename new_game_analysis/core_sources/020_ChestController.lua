-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
require(ReplicatedStorage.CAM.Global.Types.ChestTypes);
local LiveConfig = require(ReplicatedStorage.CAM.Global.LiveConfig);
local script_ChestAnimations = require(script.ChestAnimations);
local script_ChestSeal = require(script.ChestSeal);
local Chest = gameSettings.Tags.Chest;
local v1 = {};
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = nil;
local u6 = false;

local function onChestAdded(p7: userdata) -- Line: 34
    -- upvalues: u2 (ref), script_ChestAnimations (copy), script_ChestSeal (copy)
    local Attribute = p7:GetAttribute("ChestGuid");

    if typeof(Attribute) == "string" then
        local v8 = u2[Attribute];

        if v8 and v8.state == "Opened" then
            p7:SetAttribute("IsOpen", true);
        end;
    end;

    task.spawn(script_ChestAnimations.track, p7);
    task.spawn(script_ChestSeal.track, p7);
end;

function v1.handleState(p9) -- Line: 52
    -- upvalues: u2 (ref)
    if p9.state == "Despawned" then
        u2[p9.chestGuid] = nil;

        return;
    end;

    u2[p9.chestGuid] = p9;
end;

function v1.start() -- Line: 60
    -- upvalues: u6 (ref), u3 (ref), u5 (ref), LiveConfig (copy), CollectionService (copy), Chest (copy), onChestAdded (copy), u4 (copy)
    if u6 then
        return;
    end;

    u6 = true;

    local function applyIds(p10: table?) -- Line: 72
        -- upvalues: u3 (ref)
        local v11 = {};

        if p10 then
            for i in p10 do
                v11[#v11 + 1] = i;
            end;

            table.sort(v11);
        end;

        u3 = v11;
    end;

    u5 = LiveConfig.listen("ChestsLootTable", applyIds);
    applyIds(LiveConfig.get("ChestsLootTable"));

    for _, v in CollectionService:GetTagged(Chest) do
        if v:IsA("Model") then
            onChestAdded(v);
        end;
    end;

    u4[#u4 + 1] = CollectionService:GetInstanceAddedSignal(Chest):Connect(function(p12) -- Line: 91
        -- upvalues: onChestAdded (ref)
        if p12:IsA("Model") then
            onChestAdded(p12);
        end;
    end);
end;

function v1.teardown() -- Line: 99
    -- upvalues: u6 (ref), u5 (ref), u4 (copy), u2 (ref), u3 (ref), script_ChestAnimations (copy), script_ChestSeal (copy)
    u6 = false;

    if u5 then
        u5();
        u5 = nil;
    end;

    for _, v in u4 do
        v:Disconnect();
    end;

    table.clear(u4);
    u2 = {};
    u3 = {};
    script_ChestAnimations.teardown();
    script_ChestSeal.teardown();
end;

function v1.getChestIds() -- Line: 115
    -- upvalues: u3 (ref)
    return u3;
end;

return v1;
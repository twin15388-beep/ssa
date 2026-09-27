-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);
local Breathings = require(ReplicatedStorage.CAM.Global.Powers.Breathings);
local DemonArts = require(ReplicatedStorage.CAM.Global.Powers.DemonArts);
local FightingStyles = require(ReplicatedStorage.CAM.Global.Powers.FightingStyles);
local Clans = require(ReplicatedStorage.CAM.Clans);
local PlayerProgression = require(ReplicatedStorage.CAM.Global.PlayerProgression);
local table_freeze_ret = table.freeze({
    Mastery = false
});
local table_freeze_ret2 = table.freeze({
    Mastery = false
});

return function(p1: string?) -- Line: 38
    -- upvalues: Items (copy), Breathings (copy), DemonArts (copy), FightingStyles (copy), Clans (copy), table_freeze_ret (copy), PlayerProgression (copy), table_freeze_ret2 (copy)
    if p1 == nil then
        return nil;
    end;

    local v2 = Items[p1] or Breathings[p1] or (DemonArts[p1] or FightingStyles[p1]);

    if v2 ~= nil then
        return v2;
    end;

    if Clans.GetClan(p1) ~= nil then
        return table_freeze_ret;
    end;

    if PlayerProgression.GrantedSkills[p1] == nil then
        return nil;
    end;

    return table_freeze_ret2;
end;
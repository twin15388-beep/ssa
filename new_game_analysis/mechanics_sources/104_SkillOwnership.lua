-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Character_info_provider = require(ReplicatedStorage.CAM.Global.Character_info_provider);
local Skill_Info = require(ReplicatedStorage.CAM.Global.PlayerProfile.Skill_Info);

return function(p1: table, p2: table) -- Line: 7
    -- upvalues: Players (copy), Character_info_provider (copy), Skill_Info (copy)
    if typeof(p1) ~= "table" then
        return;
    end;

    local LocalPlayer = Players.LocalPlayer;

    if LocalPlayer == nil then
        return;
    end;

    local _, v3 = Character_info_provider.HasUnlockedSkills(LocalPlayer, p1);

    for _, v in v3 do
        local v4 = Skill_Info[v];
        local v5 = {
            Text = `Requires {v}`,
            Image = v4 and v4.Icon or nil
        };
        table.insert(p2, v5);
    end;
end;
-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);
local PlayerProfile = require(ReplicatedStorage.CAM.Global.PlayerProfile);

return function(p1: userdata, p2: string) -- Line: 5
    -- upvalues: PlayerProfile (copy), Items (copy)
    local Character = p1.Character;

    if Character == nil then
        return 0;
    end;

    local v3 = Character:FindFirstChild("SHCS") or Character:FindFirstChild("SHC");

    if v3 == nil or v3.Value == "" then
        return 0;
    end;

    local Value = v3.Value;
    local v4 = PlayerProfile.skill_info[Value];

    if v4 == nil then
        return 0;
    end;

    local v5 = Items[v4.Category];

    if v5 == nil or v5.Skills == nil then
        return 0;
    end;

    for _, v in ipairs(v5.Skills) do
        if v.Name == Value and v.PerformanceStats then
            return v.PerformanceStats[p2] or 0;
        end;
    end;

    return 0;
end;
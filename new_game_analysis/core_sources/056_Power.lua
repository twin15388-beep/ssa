-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Character_info_provider = require(ReplicatedStorage.CAM.Global.Character_info_provider);
local Breathings = require(ReplicatedStorage.CAM.Global.Powers.Breathings);
local DemonArts = require(ReplicatedStorage.CAM.Global.Powers.DemonArts);

return function(p1: userdata, p2: string) -- Line: 11
    -- upvalues: Character_info_provider (copy), Breathings (copy), DemonArts (copy)
    local v3 = 0;

    for _, v in Character_info_provider.GetEquippedPowers(p1) do
        local v4 = Breathings[v] or DemonArts[v];
        local v5;

        if v4 == nil or v4.Stats == nil then
            v5 = nil;
        else
            v5 = v4.Stats[p2] or nil;
        end;

        if v5 == true then
            return true;
        end;

        if typeof(v5) == "number" then
            v3 = v3 + v5;
        end;
    end;

    return v3;
end;
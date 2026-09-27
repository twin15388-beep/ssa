-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);
local Refinement = require(ReplicatedStorage.CAM.Global.Refinement);
local Series = require(ReplicatedStorage.CAM.Global.Series);
local StatTypes = require(ReplicatedStorage.CAM.Global.Types.StatTypes);

return function(p1: userdata, p2: string, p3: table) -- Line: 8
    -- upvalues: StatTypes (copy), Items (copy), Series (copy), Refinement (copy)
    local v4 = StatTypes.HighestOnlyStats[p2] == true;
    local v5 = 0;

    for _, v in ipairs(p3) do
        local v6 = Items[v];

        if v6 and v6.Stats then
            local v7 = v6.Stats[p2];

            if v7 == true then
                return true;
            end;

            if typeof(v7) == "number" then
                if Series.SetOf(v) ~= nil or v6.Refinable == true then
                    local v8 = Series.WornEntry(p1, v);
                    v7 = v7 * Series.Multiplier(v8);
                    local v9;

                    if v8 == nil then
                        v9 = nil;
                    else
                        v9 = v8:FindFirstChild("RefineLevel");
                    end;

                    if v9 ~= nil then
                        v7 = v7 * Refinement.GetStatMultiplier(v, p2, v9.Value);
                    end;
                end;

                if v4 then
                    v5 = math.max(v5, v7);
                else
                    v5 = v5 + v7;
                end;
            end;
        end;
    end;

    return v5;
end;
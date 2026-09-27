-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);
local StatTypes = require(ReplicatedStorage.CAM.Global.Types.StatTypes);
local Refinement = require(ReplicatedStorage.CAM.Global.Refinement);
local Series = require(ReplicatedStorage.CAM.Global.Series);

return function(p1: userdata, p2: string, p3: any) -- Line: 12
    -- upvalues: StatTypes (copy), Items (copy), Refinement (copy), Series (copy)
    local u4 = StatTypes.HighestOnlyStats[p2] == true;
    local u5 = 0;
    local u6 = false;

    local function add(p7) -- Line: 17
        -- upvalues: u6 (ref), u5 (ref), u4 (copy)
        if p7 == true then
            u6 = true;

            return;
        end;

        if typeof(p7) == "number" then
            local v8;

            if u4 then
                v8 = math.max(u5, p7);
            else
                v8 = u5 + p7;
            end;

            u5 = v8;
        end;
    end;

    for _, v in ipairs(p3) do
        local v9 = Items[v];

        if v9 then
            if v9.ActiveToolStats then
                local v10 = v9.ActiveToolStats[p2];

                if typeof(v10) == "number" and v10 ~= 0 then
                    local Entry = p3.Entry;

                    if Entry ~= nil and Entry.Name == v then
                        if table.find(Refinement.GetRefineStats(v), p2) ~= nil then
                            local RefineLevel = Entry:FindFirstChild("RefineLevel");

                            if RefineLevel ~= nil then
                                v10 = v10 * Refinement.GetStatMultiplier(v, p2, RefineLevel.Value);
                            end;
                        end;

                        v10 = v10 * Series.Multiplier(Entry);
                    end;
                end;

                if v10 == true then
                    u6 = true;
                elseif typeof(v10) == "number" then
                    if u4 then
                        u5 = math.max(u5, v10);
                    else
                        u5 = u5 + v10;
                    end;
                end;
            end;

            if v9.Skills then
                for _, v2 in ipairs(v9.Skills) do
                    if v2.ActiveToolStats then
                        local v11 = v2.ActiveToolStats[p2];

                        if v11 == true then
                            u6 = true;
                        elseif typeof(v11) == "number" then
                            if u4 then
                                u5 = math.max(u5, v11);
                            else
                                u5 = u5 + v11;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    return u6 and true or u5;
end;
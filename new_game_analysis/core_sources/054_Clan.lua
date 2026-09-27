-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Clans = require(ReplicatedStorage.CAM.Clans);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);

return function(p1: userdata, p2: string) -- Line: 8
    -- upvalues: Utility (copy), Clans (copy)
    local Data = Utility.GetData(p1);
    local v3;

    if Data == nil then
        v3 = nil;
    else
        v3 = Data:FindFirstChild("Clan") or nil;
    end;

    local v4;

    if v3 == nil then
        v4 = nil;
    else
        v4 = Clans.GetClan(v3.Value) or nil;
    end;

    local v5;

    if v4 == nil then
        v5 = nil;
    else
        v5 = v4.stats ~= nil and v4.stats[p2] or nil;
    end;

    return v5 == true and true or (typeof(v5) ~= "number" and 0 or v5);
end;
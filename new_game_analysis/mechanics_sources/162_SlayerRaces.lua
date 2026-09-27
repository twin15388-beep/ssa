-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Utility = require(ReplicatedStorage.CAM.Global.Utility);

return function(p1: userdata) -- Line: 9
    -- upvalues: Players (copy), Utility (copy)
    local PlayerFromCharacter = Players:GetPlayerFromCharacter(p1);

    if PlayerFromCharacter == nil then
        return false;
    end;

    local Data = Utility.GetData(PlayerFromCharacter);
    local v2 = Data ~= nil and Data:FindFirstChild("Race") or nil;
    local v3;

    if v2 == nil then
        v3 = false;
    else
        v3 = v2.Value == "Slayer" and true or v2.Value == "Hybrid";
    end;

    return v3;
end;
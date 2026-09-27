-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);

return function(p1: userdata, p2: string, p3: any) -- Line: 6
    -- upvalues: gameSettings (copy), Utility (copy)
    local v4;

    if type(p3) == "table" then
        v4 = p3.name or p3;
    else
        v4 = p3;
    end;

    local v5 = type(p3) == "table" and p3.incrementAmount or gameSettings.expPerMasteryDefault;
    local Data = Utility.GetData(p1);

    if Data == nil then
        return 0;
    end;

    local v6 = Data.MasteryProgressionList:FindFirstChild(v4);

    if v6 == nil then
        return 0;
    end;

    local Goal = v6:FindFirstChild("Goal");

    return Goal == nil and 0 or math.floor(Goal.Value / v5);
end;
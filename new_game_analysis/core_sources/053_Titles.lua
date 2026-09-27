-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Titles = require(ReplicatedStorage.CAM.Global.Titles);

return function(p1: userdata, p2: string) -- Line: 5
    -- upvalues: Titles (copy)
    return Titles.GetStatBonus(p1, p2);
end;
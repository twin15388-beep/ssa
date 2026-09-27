-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PlayerProgression = require(ReplicatedStorage.CAM.Global.PlayerProgression);

return function(p1: userdata, p2: string) -- Line: 9
    -- upvalues: PlayerProgression (copy)
    return PlayerProgression.GetStatTotal(p1, p2);
end;
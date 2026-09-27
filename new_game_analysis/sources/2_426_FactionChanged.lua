-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FactionState = require(ReplicatedStorage.CAM.Client.Modules.FactionState);

return function(p1) -- Line: 7
    -- upvalues: FactionState (copy)
    local Apply = FactionState.Apply;

    if type(p1) ~= "table" then
        p1 = nil;
    end;

    Apply(p1);
end;
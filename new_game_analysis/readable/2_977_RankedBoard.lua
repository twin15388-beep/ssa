-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RankedController = require(ReplicatedStorage.CAM.Client.Controllers.RankedController);

return function(p1) -- Line: 6
    -- upvalues: RankedController (copy)
    RankedController.handleBoard(p1);
end;
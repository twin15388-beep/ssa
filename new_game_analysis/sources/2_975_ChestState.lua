-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ChestController = require(ReplicatedStorage.CAM.Client.Controllers.ChestController);
require(ReplicatedStorage.CAM.Global.Types.ChestTypes);

return function(p1) -- Line: 6
    -- upvalues: ChestController (copy)
    ChestController.handleState(p1);
end;
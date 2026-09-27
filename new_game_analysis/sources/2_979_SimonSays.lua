-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SimonSaysController = require(ReplicatedStorage.CAM.Client.Controllers.SimonSaysController);

return function(p1) -- Line: 5
    -- upvalues: SimonSaysController (copy)
    SimonSaysController.handle(p1);
end;
-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerBrowserController = require(ReplicatedStorage.CAM.Client.Controllers.ServerBrowserController);

return function(p1) -- Line: 5
    -- upvalues: ServerBrowserController (copy)
    ServerBrowserController.applyState(p1);
end;
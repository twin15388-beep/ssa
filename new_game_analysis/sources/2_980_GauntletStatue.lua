-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local GauntletStatuesController = require(ReplicatedStorage.CAM.Client.Controllers.GauntletStatuesController);

return function(p1) -- Line: 5
    -- upvalues: GauntletStatuesController (copy)
    GauntletStatuesController.handle(p1);
end;
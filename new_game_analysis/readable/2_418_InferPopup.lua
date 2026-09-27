-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PopUpCreator = require(ReplicatedStorage.CAM.Global.Subsets.Classes.PopUpCreator);

return function(p1) -- Line: 7
    -- upvalues: PopUpCreator (copy)
    return PopUpCreator.new(p1):WaitResult(true);
end;
-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local StatTypes = require(ReplicatedStorage.CAM.Global.Types.StatTypes);

return function(p1: userdata, p2: string) -- Line: 9
    -- upvalues: StatTypes (copy)
    local Attribute = p1:GetAttribute(StatTypes.StatToAttribute(p2));

    return typeof(Attribute) ~= "number" and (Attribute == true and true or 0) or Attribute;
end;
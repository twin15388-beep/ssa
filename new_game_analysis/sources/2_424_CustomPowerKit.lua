-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CustomPower = require(ReplicatedStorage.CAM.Global.CustomPower);
local Skills_Provider = require(ReplicatedStorage.CAM.Client.Controllers.Skills_Provider);

return function(p1: table) -- Line: 10
    -- upvalues: CustomPower (copy), Skills_Provider (copy)
    if p1 == nil or (p1.Name == nil or p1.Picks == nil) then
        return;
    end;

    CustomPower.Install(p1.Name, p1.Picks);
    Skills_Provider.Keys_Changed:Fire(Skills_Provider.get_current_keys());
end;
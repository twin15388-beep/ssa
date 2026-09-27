-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Regions = require(ReplicatedStorage.Regions);

return function(p1: table) -- Line: 9
    -- upvalues: Regions (copy)
    if typeof(p1) ~= "table" then
        return;
    end;

    if p1.Icon == nil and p1.Npc ~= nil then
        p1 = table.clone(p1);
        p1.Icon = Regions.GetNpcIcon(p1.Npc);
    end;

    game.ReplicatedStorage.Communication.CnC.Notifications.CenterLeft:Fire("Npc", p1);
end;
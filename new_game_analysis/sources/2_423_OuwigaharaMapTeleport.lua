-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SequenceTeleport = require(ReplicatedStorage.CAM.Client.Modules.SequenceTeleport);

return function(p1: table) -- Line: 11
    -- upvalues: SequenceTeleport (copy)
    if p1 == nil or typeof(p1.Destination) ~= "CFrame" then
        return;
    end;

    SequenceTeleport.Start({
        FallLength = 1,
        TeleportAtFall = 0.5,
        RiseLength = 1,
        Destination = p1.Destination
    });
end;
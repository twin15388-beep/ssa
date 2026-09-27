-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);

return {
 WarFansClue2 = function(p1, p2) -- Line: 7, Name: WarFansClue2
 -- upvalues: SignalEvent (copy)
 SignalEvent.ToServer("WarFansClue", 2);

 return "Sofen_Rumour2";
 end
};
-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);

return {
 WarFansClue1 = function(p1, p2) -- Line: 7, Name: WarFansClue1
 -- upvalues: SignalEvent (copy)
 SignalEvent.ToServer("WarFansClue", 1);

 return "Shiori_Rumour2";
 end
};
-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);

return {
 WarFansClue3 = function(p1, p2) -- Line: 7, Name: WarFansClue3
 -- upvalues: SignalEvent (copy)
 SignalEvent.ToServer("WarFansClue", 3);

 return "Retsu_Rumour2";
 end,

 WarFansClue4 = function(p3, p4) -- Line: 11, Name: WarFansClue4
 -- upvalues: SignalEvent (copy)
 SignalEvent.ToServer("WarFansClue", 4);

 return "Lynx_Rumour2";
 end
};
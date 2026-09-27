-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);

return {
 CleaverChallenge = function(p1, p2) -- Line: 8, Name: CleaverChallenge
 -- upvalues: SignalEvent (copy)
 SignalEvent.ToServer("CleaverDuel");

 return "";
 end
};
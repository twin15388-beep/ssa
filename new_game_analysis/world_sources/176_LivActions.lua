-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);

return {
 LivGamble = function(p1, p2) -- Line: 13, Name: LivGamble
 -- upvalues: Utility (copy), Players (copy), SignalEvent (copy)
 local Data = Utility.GetData(Players.LocalPlayer);

 if Data == nil or Data.Wen.Value <= 0 then
 return "Liv_GambleBroke";
 end;

 SignalEvent.ToServer("LivGamble");

 return "";
 end
};
-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);

return {
 WagasaTakeSchematic = function(p1, p2) -- Line: 13, Name: WagasaTakeSchematic
 -- upvalues: Utility (copy), Players (copy), SignalEvent (copy)
 local Data = Utility.GetData(Players.LocalPlayer);

 if Data == nil then
 return "Wagasa_Done";
 end;

 local WorldEvents = Data:FindFirstChild("WorldEvents");

 if WorldEvents ~= nil and WorldEvents:FindFirstChild("FirstlightWagasa_Schematic") ~= nil then
 return "Wagasa_Done";
 end;

 SignalEvent.ToServer("WagasaGiveSchematic");

 return "Wagasa_Given";
 end
};
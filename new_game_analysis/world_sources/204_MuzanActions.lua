-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);

return {
 MuzanGiveBell = function(p1, p2) -- Line: 12, Name: MuzanGiveBell
 -- upvalues: Utility (copy), Players (copy), SignalEvent (copy)
 local Data = Utility.GetData(Players.LocalPlayer);

 if Data ~= nil and Data.Inventory.Inventory:FindFirstChild("Biwa Bell") ~= nil then
 return "Muzan_HasBell";
 end;

 SignalEvent.ToServer("MuzanGiveBell");

 return "";
 end
};
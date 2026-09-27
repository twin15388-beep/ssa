-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);

return {
 StatuesHeard = function(p1, p2) -- Line: 12, Name: StatuesHeard
 -- upvalues: SignalEvent (copy)
 SignalEvent.ToServer("GauntletStatuesBegin");

 return "Statues_4";
 end,

 GauntletTakeSchematic = function(p3, p4) -- Line: 16, Name: GauntletTakeSchematic
 -- upvalues: Utility (copy), Players (copy), SignalEvent (copy)
 local Data = Utility.GetData(Players.LocalPlayer);

 if Data ~= nil and Data.Inventory.Inventory:FindFirstChild("Nightfall Gauntlet Schematic") ~= nil then
 return "Statues_Done";
 end;

 SignalEvent.ToServer("GauntletGiveSchematic");

 return "Statues_Given";
 end
};
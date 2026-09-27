-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Series = require(ReplicatedStorage.CAM.Global.Series);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);

local function claim(p1: string) -- Line: 10
 -- upvalues: Utility (copy), Players (copy), Series (copy), SignalEvent (copy)
 local Data = Utility.GetData(Players.LocalPlayer);
 local v2;

 if Data == nil then
 v2 = nil;
 else
 v2 = Data.Inventory.Inventory;
 end;

 if v2 == nil then
 return "Togane_SetsMissing";
 end;

 for _, v in Series.Capstones(p1) do
 if v2:FindFirstChild(v .. " Schematic") ~= nil then
 return "Togane_SetsDone";
 end;
 end;

 for _, v in Series.CapstoneGate(p1) do
 if v2:FindFirstChild(v) == nil then
 return "Togane_SetsMissing";
 end;
 end;

 SignalEvent.ToServer("SeriesCapstone", p1);

 return "Togane_SetsGiven";
end;

return {
 SeriesCapstoneFirstlight = function(p3, p4) -- Line: 25, Name: SeriesCapstoneFirstlight
 -- upvalues: claim (copy)
 return claim("Firstlight");
 end,

 SeriesCapstoneNightfall = function(p5, p6) -- Line: 28, Name: SeriesCapstoneNightfall
 -- upvalues: claim (copy)
 return claim("Nightfall");
 end
};
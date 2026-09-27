-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);

local function trade(p1: string, p2: string, p3: string) -- Line: 10
 -- upvalues: Utility (copy), Players (copy), SignalEvent (copy)
 local Data = Utility.GetData(Players.LocalPlayer);
 local v4;

 if Data == nil then
 v4 = nil;
 else
 v4 = Data.Inventory.Inventory;
 end;

 if v4 == nil then
 return p1 .. "_NoPiece";
 end;

 if v4:FindFirstChild(p3) ~= nil then
 return p1 .. "_Done";
 end;

 if v4:FindFirstChild(p2) == nil then
 return p1 .. "_NoPiece";
 end;

 SignalEvent.ToServer("SeriesTrade", p1);

 return p1 .. "_Given";
end;

return {
 CapeTrade = function(p5, p6) -- Line: 21, Name: CapeTrade
 -- upvalues: trade (copy)
 return trade("Cape", "Lost Cape", "Nightfall Cape Schematic");
 end,

 HaoriTrade = function(p7, p8) -- Line: 24, Name: HaoriTrade
 -- upvalues: trade (copy)
 return trade("Haori", "Lost Outfit", "Firstlight Haori Schematic");
 end
};
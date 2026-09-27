-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local DayAndNightHandler = require(ReplicatedStorage.CAM.Global.DayAndNightHandler);
local PlayerStatResolver = require(ReplicatedStorage.CAM.Global.PlayerStatResolver);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);

local function owns(p1) -- Line: 17
 local v2;

 if p1 == nil then
 v2 = false;
 else
 v2 = p1.Inventory.Inventory:FindFirstChild("Mushroom Lit Lantern") ~= nil;
 end;

 return v2;
end;

return {
 RetsuLanternEntry = function(p3, p4) -- Line: 27, Name: RetsuLanternEntry
 -- upvalues: Utility (copy), Players (copy)
 local Data = Utility.GetData(Players.LocalPlayer);
 local v5;

 if Data == nil then
 v5 = false;
 else
 v5 = Data.Inventory.Inventory:FindFirstChild("Mushroom Lit Lantern") ~= nil;
 end;

 return v5 and "Retsu_Lantern_Wearing" or "Retsu_Lantern";
 end,

 RetsuTellFoxfire = function(p6, p7) -- Line: 31, Name: RetsuTellFoxfire
 -- upvalues: Utility (copy), Players (copy), DayAndNightHandler (copy), PlayerStatResolver (copy), SignalEvent (copy)
 local Data = Utility.GetData(Players.LocalPlayer);

 if Data == nil then
 return "Retsu_Lantern_Quiet";
 end;

 local v8;

 if Data == nil then
 v8 = false;
 else
 v8 = Data.Inventory.Inventory:FindFirstChild("Mushroom Lit Lantern") ~= nil;
 end;

 if v8 then
 return "Retsu_Lantern_Wearing";
 end;

 if DayAndNightHandler.IsEnabled() and not DayAndNightHandler.IsNight() then
 return "Retsu_Lantern_Daylight";
 end;

 if (PlayerStatResolver.GetStatExcept(Players.LocalPlayer, "Illumination", "Progression") or 0) > 0 then
 return "Retsu_Lantern_Lit";
 end;

 if Data.Wen.Value < 2500 then
 return "Retsu_Lantern_Broke";
 end;

 SignalEvent.ToServer("RetsuTellFoxfire");

 return "Retsu_Lantern_Told";
 end
};
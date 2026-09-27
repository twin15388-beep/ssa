-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local DayAndNightHandler = require(ReplicatedStorage.CAM.Global.DayAndNightHandler);
local DeliverAction = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests.DeliverAction);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);

return {
 DeliverPermitStampToSofen = DeliverAction("Ill find the permit stamp(Lv 45)", "Return to Sofen", "Sofen_Thanks", "Sofen_NoStamp"),
 DeliverHaulToRuno = DeliverAction("Ill fill your crates(Lv 45)", "Return to Runo", "Runo_Thanks", "Runo_Short"),
 DeliverGoodCatchToRuno = DeliverAction("Ill land the good catch(Lv 60)", "Return to Runo", "Runo_CatchThanks", "Runo_CatchShort"),
 ReportSupplyBoxToNiko = DeliverAction("Ill deliver the supply box(Lv 70)", "Report back to Niko", "Niko_Thanks", "Niko_Waiting"),

 SofenPullLedger = function(p1, p2) -- Line: 18, Name: SofenPullLedger
 -- upvalues: Utility (copy), Players (copy), SignalEvent (copy)
 local Data = Utility.GetData(Players.LocalPlayer);

 if Data == nil or Data.Wen.Value < 2500 then
 return "Sofen_LedgerBroke";
 end;

 SignalEvent.ToServer("SofenPullLedger");

 return "Sofen_LedgerDone";
 end,

 IsaoTakeToll = function(p3, p4) -- Line: 26, Name: IsaoTakeToll
 -- upvalues: DayAndNightHandler (copy), SignalEvent (copy)
 if DayAndNightHandler.IsEnabled() and not DayAndNightHandler.IsNight() then
 return "Isao_Silent";
 end;

 SignalEvent.ToServer("IsaoTakeToll");

 return "Isao_Toll";
 end
};
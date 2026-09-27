-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Utility = require(ReplicatedStorage.CAM.Global.Utility);

return {
 ["Duelist Hibiki"] = {
 Text = "Hear that? No? Then nobody has drawn on me yet today. Stand there and listen a while.",
 Answers = true,
 IfTrue = "Duel_2",

 BeforeRun = function(p1, p2) -- Line: 14, Name: BeforeRun
 -- upvalues: Utility (copy), Players (copy)
 local Data = Utility.GetData(Players.LocalPlayer);
 local v3;

 if Data == nil then
 v3 = nil;
 else
 v3 = Data.Inventory.Inventory;
 end;

 return v3 ~= nil and v3:FindFirstChild("Firstlight Sound Cleavers Schematic") ~= nil and "Duel_Done" or nil;
 end
 },
 Duel_2 = {
 Text = "These cleavers were mine, and they stay mine until somebody makes me put them down. One on one, nobody steps in, nobody steps out. Just you, me, and the noise.",
 Answers = {
 ["Challenge him"] = "CleaverChallenge",
 ["Not yet"] = ""
 }
 },
 Duel_Done = {
 Text = `You carry the {Utility.NameTag("drawings")}. I drew them once, and once was loud enough. Go and have them made.`,
 Answers = {
 Close = ""
 }
 }
};
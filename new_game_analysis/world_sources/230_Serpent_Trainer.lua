-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local Character_info_provider = require(ReplicatedStorage.CAM.Global.Character_info_provider);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);

return {
 ["Serpent Trainer Obari"] = {
 Text = "So. You want to learn the Serpent\'s way.",
 Answers = true,
 IfTrue = "SerpentTrainer_2",

 BeforeRun = function(p1, p2) -- Line: 13, Name: BeforeRun
 -- upvalues: Quests (copy), Players (copy), Utility (copy), Character_info_provider (copy)
 if Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill learn Serpent Breathing(Lv 25)") == "Doing" then
 return "SerpentTrainer_Doing";
 end;

 local Data = Utility.GetData(Players.LocalPlayer);
 local v3 = Data ~= nil and Data.Powers.Breathing.Value or "";

 if v3 == "Serpent" then
 return "SerpentTrainer_Done";
 end;

 if v3 ~= "" then
 return "SerpentTrainer_HasStyle";
 end;

 if not Character_info_provider.HasPowerAccess(Players.LocalPlayer, "Serpent") then
 return "SerpentTrainer_NoAccess";
 end;
 end
 },
 SerpentTrainer_2 = {
 Text = "A serpent does not strike blindly. It waits, it coils, it finds the one true opening.",
 Answers = {
 ["Not yet"] = "",
 ["Ill learn Serpent Breathing(Lv 25)"] = "AddQuest"
 }
 },
 SerpentTrainer_Doing = {
 Text = "Coiling tighter each time. Good, that patience will keep you alive.",
 Answers = true
 },
 SerpentTrainer_Done = {
 Answers = true,
 IfTrue = "SerpentTrainer_Done2",
 Text = `You struck without hesitation, and without wasting a single movement. [The one true opening.]<Style=Rainbow> That is {Utility.NameTag("Serpent Breathing")}.`
 },
 SerpentTrainer_Done2 = {
 Text = "You have earned my respect. Do not give me a reason to take it back.",
 Answers = true
 },
 SerpentTrainer_NoAccess = {
 Text = "Breathing is not in you. Seek a different kind of teacher.",
 Answers = true
 },
 SerpentTrainer_HasStyle = {
 Text = "You already carry a Breathing. I will not teach over it.",
 Answers = true
 }
};
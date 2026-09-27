-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local Character_info_provider = require(ReplicatedStorage.CAM.Global.Character_info_provider);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);

return {
 ["Insect Trainer Shinora"] = {
 Text = "Oh, how nice. A new little student.",
 Answers = true,
 IfTrue = "InsectTrainer_2",

 BeforeRun = function(p1, p2) -- Line: 13, Name: BeforeRun
 -- upvalues: Quests (copy), Players (copy), Utility (copy), Character_info_provider (copy)
 if Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill learn Insect Breathing(Lv 25)") == "Doing" then
 return "InsectTrainer_Doing";
 end;

 local Data = Utility.GetData(Players.LocalPlayer);
 local v3 = Data ~= nil and Data.Powers.Breathing.Value or "";

 if v3 == "Insect" then
 return "InsectTrainer_Done";
 end;

 if v3 ~= "" then
 return "InsectTrainer_HasStyle";
 end;

 if not Character_info_provider.HasPowerAccess(Players.LocalPlayer, "Insect") then
 return "InsectTrainer_NoAccess";
 end;
 end
 },
 InsectTrainer_2 = {
 Text = "Insect Breathing is elegance and precision, not brute strength. Do try to keep up.",
 Answers = {
 ["Not yet"] = "",
 ["Ill learn Insect Breathing(Lv 25)"] = "AddQuest"
 }
 },
 InsectTrainer_Doing = {
 Text = "Tired already? That is alright. Just do not let it become a habit.",
 Answers = true
 },
 InsectTrainer_Done = {
 Answers = true,
 IfTrue = "InsectTrainer_Done2",
 Text = `My my, you really did it. [Deadly, and never once looking like it.]<Style=Rainbow> That is {Utility.NameTag("Insect Breathing")}.`
 },
 InsectTrainer_Done2 = {
 Text = "Welcome to the club. Smile more, it unsettles people.",
 Answers = true
 },
 InsectTrainer_NoAccess = {
 Text = "Breathing is not in you. Seek a different kind of teacher.",
 Answers = true
 },
 InsectTrainer_HasStyle = {
 Text = "You already carry a Breathing. I will not teach over it.",
 Answers = true
 }
};
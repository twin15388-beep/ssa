-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local NameTag = Utility.NameTag;

return {
 ["Estate Worker Niko"] = {
 Text = "Hey.",
 Answers = true,
 IfTrue = "Niko_2",

 BeforeRun = function(p1, p2) -- Line: 13, Name: BeforeRun
 -- upvalues: Quests (copy), Players (copy), Utility (copy)
 if Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill deliver the supply box(Lv 70)") == "Doing" then
 local v3 = Utility.GetData(Players.LocalPlayer).Quests.Holder:FindFirstChild(Quests.Holder["Ill deliver the supply box(Lv 70)"].QuestInstance.Name);

 if v3 then
 v3 = v3.Tasks:FindFirstChild("Deliver to Shiori");
 end;

 return v3 and v3.Value.Value >= v3.Max.Value and "Niko_Return" or "Niko_Waiting";
 end;
 end
 },
 Niko_2 = {
 Answers = true,
 IfTrue = "Niko_3",
 Text = `I've got a shipment off the morning boat that needs to go down to the {NameTag("Butterfly Estate")}.`
 },
 Niko_3 = {
 Answers = true,
 IfTrue = "Niko_4",
 Text = `Medicine, mostly. {NameTag("Shiori")} has been asking after it for a week.`
 },
 Niko_4 = {
 Text = "Normally I\'d run it down myself, but I\'m buried in work.",
 Answers = true,
 IfTrue = "Niko_5"
 },
 Niko_5 = {
 Text = "[It\'s right here]<Color=(1,.85,.3)>, packed and ready. Mind helping me out?",
 Answers = {
 Close = "",
 ["Ill deliver the supply box(Lv 70)"] = "AddQuest",
 ["Where is the estate?"] = "Niko_Way"
 }
 },
 Niko_Way = {
 Text = "Head east out of the harbour and follow the river down. The estate sits at the bottom of it.",
 Answers = true,
 IfTrue = "Niko_Way2"
 },
 Niko_Way2 = {
 Text = "Set your spawn at their crystal while you\'re down there. Saves you the climb back.",
 Answers = true,
 IfTrue = "Niko_5"
 },
 Niko_Waiting = {
 Text = "You\'ve still got the box. Don\'t keep them waiting.",
 Answers = true
 },
 Niko_Return = {
 Text = "Back already. Did it get down there in one piece?",
 Answers = {
 Close = "",
 ["Shiori says thank you"] = "ReportSupplyBoxToNiko"
 }
 },
 Niko_Thanks = {
 Text = "Looks like it arrived safely. Appreciate the help.",
 Answers = true,
 IfTrue = "Niko_Thanks2"
 },
 Niko_Thanks2 = {
 Text = "There\'ll be another boat in before long. Come find me.",
 Answers = true
 }
};
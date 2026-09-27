-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);

return {
 ["Lamplighter Isamu"] = {
 Text = "Mind the floor. Those plates were laid by the lamplighters before me, and they still keep count.",
 Answers = true,
 IfTrue = "Lantern_2",

 BeforeRun = function(p1, p2) -- Line: 16, Name: BeforeRun
 -- upvalues: Quests (copy), Players (copy)
 local PlayerQuestState = Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill walk the order");

 return PlayerQuestState == "Done" and "Lantern_Done" or (PlayerQuestState == "Doing" and "Lantern_Doing" or nil);
 end
 },
 Lantern_2 = {
 Text = "They light in an order. Hold it in your head, then walk it back. Jump from plate to plate, and land square.",
 Answers = true,
 IfTrue = "Lantern_3"
 },
 Lantern_3 = {
 Text = "Five rounds. Each adds a plate to the last, and the lights come quicker the further you get.",
 Answers = true,
 IfTrue = "Lantern_4"
 },
 Lantern_4 = {
 Text = "Miss one and the whole floor goes dark, and you start over from the first. Walk all five, and I will draw you what the old keepers carried.",
 Answers = {
 ["Ill walk the order"] = "AddQuest",
 ["Not yet"] = ""
 }
 },
 Lantern_Doing = {
 Text = "The floor is lit. Eyes down, and jump clean.",
 Answers = true
 },
 Lantern_Done = {
 Text = `You walked every round. The {require(ReplicatedStorage.CAM.Global.Utility).NameTag("drawings")} are yours, and I only draw them once.`,
 Answers = {
 Close = ""
 }
 }
};
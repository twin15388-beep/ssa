-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local NameTag = require(ReplicatedStorage.CAM.Global.Utility).NameTag;

return {
 Elara = {
 Text = "I only do business with a certain caliber of customer. You are not it.",
 Answers = true,
 IfTrue = "Elara_Idle2",

 BeforeRun = function(p1, p2) -- Line: 11, Name: BeforeRun
 -- upvalues: Quests (copy), Players (copy)
 local PlayerQuestState = Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill deliver the package");

 if PlayerQuestState == "Doing" then
 return "Elara_Delivery";
 end;

 if PlayerQuestState == "Done" then
 return "Elara_Welcome";
 end;
 end
 },
 Elara_Idle2 = {
 Text = "If you want my attention, make yourself useful to someone I trust.",
 Answers = true,
 IfTrue = "Elara_Idle3"
 },
 Elara_Idle3 = {
 Answers = true,
 Text = `Farmer {NameTag("MoldySugar")} in {NameTag("Windy Peak")} always needs a hand.`
 },
 Elara_Delivery = {
 Text = `...That {NameTag("Package")}. Is that the farmer's handwriting on it?`,
 Answers = {
 Close = "",
 ["Hand over the package"] = "DeliverPackageToElara"
 }
 },
 Elara_Thanks = {
 Answers = true,
 IfTrue = "Elara_Thanks2",
 Text = `Ah, Farmer {NameTag("Moldy")}'s acquaintance.`
 },
 Elara_Thanks2 = {
 Text = "Anyone who earns that old farmer\'s trust is welcome in my shop.",
 Answers = true,
 IfTrue = "Elara_Thanks3"
 },
 Elara_Thanks3 = {
 Text = "Feel free to browse.",
 Answers = 1
 },
 Elara_NoPackage = {
 Text = "You\'re not carrying anything for me.",
 Answers = true
 },
 Elara_Welcome = {
 Text = "A pleasure doing business with you. Stop by anytime.",
 Answers = true
 }
};
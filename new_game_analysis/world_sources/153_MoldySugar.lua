-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local NameTag = require(ReplicatedStorage.CAM.Global.Utility).NameTag;

return {
 MoldySugar = {
 Answers = true,
 IfTrue = "MoldySugar_2",

 BeforeRun = function(p1, p2) -- Line: 11, Name: BeforeRun
 -- upvalues: Quests (copy), Players (copy)
 local PlayerQuestState = Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill deliver the package");

 if PlayerQuestState == "Doing" then
 return "MoldySugar_Doing";
 end;

 if PlayerQuestState == "Done" then
 return "MoldySugar_Done";
 end;
 end,

 Text = `Hey, could you deliver this {NameTag("Package")} to the Tailor {NameTag("Elara")}?`
 },
 MoldySugar_2 = {
 Text = "She\'s not exactly the friendliest person around.",
 Answers = true,
 IfTrue = "MoldySugar_3"
 },
 MoldySugar_3 = {
 Text = "She usually only does business with a certain caliber of customer.",
 Answers = true,
 IfTrue = "MoldySugar_4"
 },
 MoldySugar_4 = {
 Text = "Who knows? This might be your chance to get on her good side.",
 Answers = {
 Close = "",
 ["Ill deliver the package"] = "AddQuest"
 }
 },
 MoldySugar_Doing = {
 Text = "hm…",
 Answers = true
 },
 MoldySugar_Done = {
 Text = "She took the package [AND]<Color=(1,.85,.3)> let you in the shop? Ha! Told you it was worth it.",
 Answers = true
 }
};
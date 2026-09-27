-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local NameTag = require(ReplicatedStorage.CAM.Global.Utility).NameTag;

return {
 Chaka = {
 Text = "The bears were never my concern.",
 Answers = true,
 IfTrue = "Chaka_2",

 BeforeRun = function(p1, p2) -- Line: 13, Name: BeforeRun
 -- upvalues: Quests (copy), Players (copy)
 if Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill clear out his subordinates(Lv 26)") == "Doing" then
 return "Chaka_SubsDoing";
 end;

 if Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill deal with Kaiden(Lv 34)") == "Doing" then
 return "Chaka_Doing";
 end;

 local PlayerQuestState = Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill get this letter delivered");

 if PlayerQuestState == "Doing" then
 return "Chaka_Delivery";
 end;

 if PlayerQuestState ~= "Done" then
 return "Chaka_Idle";
 end;
 end
 },
 Chaka_2 = {
 Text = "[Kaiden]<Color=(1,.3,.3)> is.",
 Answers = true,
 IfTrue = "Chaka_3"
 },
 Chaka_3 = {
 Text = "I\'ve watched him long enough, and he\'s become a threat.",
 Answers = true,
 IfTrue = "Chaka_4"
 },
 Chaka_4 = {
 Text = "It\'s time he [disappeared.]<Style=Fade,Color=(1,.3,.3)>",
 Answers = {
 Close = "",
 ["Ill clear out his subordinates(Lv 26)"] = "AddQuest",
 ["Ill deal with Kaiden(Lv 34)"] = "AddQuest"
 }
 },
 Chaka_Idle = {
 Answers = true,
 Text = `You should speak with {NameTag("Kazu")} in {NameTag("Windy Peak")} before coming here...`
 },
 Chaka_Delivery = {
 Text = "You look like you\'re carrying something for me.",
 Answers = {
 Close = "",
 ["Hand over the letter"] = "DeliverLetterToChaka"
 }
 },
 Chaka_Thanks = {
 Answers = true,
 IfTrue = "Chaka",
 Text = `From {NameTag("Noote")}? ...I see. So the bandits have eyes inside the village now.`
 },
 Chaka_NoLetter = {
 Answers = true,
 Text = `You don't seem to have the {NameTag("Letter")} on you.`
 },
 Chaka_Doing = {
 Text = "Have you gotten rid of the threat yet?",
 Answers = true
 },
 Chaka_SubsDoing = {
 Text = "His [subordinates]<Color=(1,.3,.3)> are still standing. Thin his ranks.",
 Answers = true
 }
};
-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);

return {
 ["Wounded Slayer Tomoi"] = {
 Text = "[High Demons]<Color=(1,.3,.3)> invaded here a couple of weeks ago. I was told to help protect the village.",
 Answers = true,
 IfTrue = "Tomoi_2",

 BeforeRun = function(p1, p2) -- Line: 13, Name: BeforeRun
 -- upvalues: Quests (copy), Players (copy)
 if Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill help you defeat them(Lv 90)") == "Doing" then
 return "Tomoi_Doing";
 end;
 end
 },
 Tomoi_2 = {
 Text = "My time here is slowly coming to an end. [Help me defeat these creatures.]<Color=(1,.85,.3)>",
 Answers = {
 Close = "",
 ["Ill help you defeat them(Lv 90)"] = "AddQuest"
 }
 },
 Tomoi_Doing = {
 Text = "Have you gotten rid of the threat yet?",
 Answers = true
 }
};
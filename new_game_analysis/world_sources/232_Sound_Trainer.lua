-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local Character_info_provider = require(ReplicatedStorage.CAM.Global.Character_info_provider);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);

return {
 ["Sound Trainer Tengai"] = {
 Text = "WELL WELL WELL! Look who wandered in!",
 Answers = true,
 IfTrue = "SoundTrainer_2",

 BeforeRun = function(p1, p2) -- Line: 13, Name: BeforeRun
 -- upvalues: Quests (copy), Players (copy), Utility (copy), Character_info_provider (copy)
 if Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill learn Sound Breathing(Lv 25)") == "Doing" then
 return "SoundTrainer_Doing";
 end;

 local Data = Utility.GetData(Players.LocalPlayer);
 local v3 = Data ~= nil and Data.Powers.Breathing.Value or "";

 if v3 == "Sound" then
 return "SoundTrainer_Done";
 end;

 if v3 ~= "" then
 return "SoundTrainer_HasStyle";
 end;

 if not Character_info_provider.HasPowerAccess(Players.LocalPlayer, "Sound") then
 return "SoundTrainer_NoAccess";
 end;
 end
 },
 SoundTrainer_2 = {
 Text = "You get to be trained by the flashiest Sound Breather in the Corps. Sound Breathing is a performance: explosive, rhythmic, dazzling. Try to keep up with the beat!",
 Answers = {
 ["Not yet"] = "",
 ["Ill learn Sound Breathing(Lv 25)"] = "AddQuest"
 }
 },
 SoundTrainer_Doing = {
 Text = "Still going? Good. Feel that rhythm yet?",
 Answers = true
 },
 SoundTrainer_Done = {
 Answers = true,
 IfTrue = "SoundTrainer_Done2",
 Text = `MAGNIFICENT! An explosive finish! [Flashy is non negotiable.]<Style=Rainbow> That is {Utility.NameTag("Sound Breathing")}.`
 },
 SoundTrainer_Done2 = {
 Text = "Now go be dazzling. Anything less and I will pretend I never taught you.",
 Answers = true
 },
 SoundTrainer_NoAccess = {
 Text = "Breathing is not in you. Seek a different kind of teacher.",
 Answers = true
 },
 SoundTrainer_HasStyle = {
 Text = "You already carry a Breathing. I will not teach over it.",
 Answers = true
 }
};
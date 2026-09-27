-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local Character_info_provider = require(ReplicatedStorage.CAM.Global.Character_info_provider);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);

return {
 ["Wind Trainer Saneri"] = {
 Text = "Tch. Another one who thinks Wind Breathing is just swinging fast.",
 Answers = true,
 IfTrue = "WindTrainer_2",

 BeforeRun = function(p1, p2) -- Line: 13, Name: BeforeRun
 -- upvalues: Quests (copy), Players (copy), Utility (copy), Character_info_provider (copy)
 if Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill learn Wind Breathing(Lv 25)") == "Doing" then
 return "WindTrainer_Doing";
 end;

 local Data = Utility.GetData(Players.LocalPlayer);
 local v3 = Data ~= nil and Data.Powers.Breathing.Value or "";

 if v3 == "Wind" then
 return "WindTrainer_Done";
 end;

 if v3 ~= "" then
 return "WindTrainer_HasStyle";
 end;

 if not Character_info_provider.HasPowerAccess(Players.LocalPlayer, "Wind") then
 return "WindTrainer_NoAccess";
 end;
 end
 },
 WindTrainer_2 = {
 Text = "It is cutting through anything in your way, hesitation included. Do not waste my time.",
 Answers = {
 ["Not yet"] = "",
 ["Ill learn Wind Breathing(Lv 25)"] = "AddQuest"
 }
 },
 WindTrainer_Doing = {
 Text = "You look like you want to quit. Prove me wrong.",
 Answers = true
 },
 WindTrainer_Done = {
 Answers = true,
 IfTrue = "WindTrainer_Done2",
 Text = `Hah. You did not hold back. [A storm that does not stop.]<Style=Rainbow> That is {Utility.NameTag("Wind Breathing")}.`
 },
 WindTrainer_Done2 = {
 Text = "Now go make some noise out there. Do not embarrass me.",
 Answers = true
 },
 WindTrainer_NoAccess = {
 Text = "Breathing is not in you. Seek a different kind of teacher.",
 Answers = true
 },
 WindTrainer_HasStyle = {
 Text = "You already carry a Breathing. I will not teach over it.",
 Answers = true
 }
};
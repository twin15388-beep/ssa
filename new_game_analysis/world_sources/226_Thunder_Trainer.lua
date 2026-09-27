-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local Character_info_provider = require(ReplicatedStorage.CAM.Global.Character_info_provider);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);

return {
 ["Thunder Trainer Zentaro"] = {
 Text = "H-hey! Wait, don\'t... actually, stay! You want to learn something?",
 Answers = true,
 IfTrue = "ThunderTrainer_2",

 BeforeRun = function(p1, p2) -- Line: 16, Name: BeforeRun
 -- upvalues: Quests (copy), Players (copy), Utility (copy), Character_info_provider (copy)
 if Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill learn Thunder Breathing(Lv 25)") == "Doing" then
 return "ThunderTrainer_Doing";
 end;

 local Data = Utility.GetData(Players.LocalPlayer);
 local v3 = Data ~= nil and Data.Powers.Breathing.Value or "";

 if v3 == "Thunder" then
 return "ThunderTrainer_Done";
 end;

 if v3 ~= "" then
 return "ThunderTrainer_HasStyle";
 end;

 if not Character_info_provider.HasPowerAccess(Players.LocalPlayer, "Thunder") then
 return "ThunderTrainer_NoAccess";
 end;
 end
 },
 ThunderTrainer_2 = {
 Answers = true,
 IfTrue = "ThunderTrainer_3",
 Text = `{Utility.NameTag("Thunder Breathing")}? I'm the fastest thing you'll ever see, promise!`
 },
 ThunderTrainer_3 = {
 Text = "Let\'s start with some meditation. Easing into terrifying is fine, right?",
 Answers = {
 ["Not yet"] = "",
 ["Ill learn Thunder Breathing(Lv 25)"] = "AddQuest"
 }
 },
 ThunderTrainer_Doing = {
 Text = "You\'re still here? Good! Keep going!",
 Answers = true
 },
 ThunderTrainer_Done = {
 Text = "Y-YOU DID IT?! One clean strike, no hesitation.",
 Answers = true,
 IfTrue = "ThunderTrainer_Done2"
 },
 ThunderTrainer_Done2 = {
 Text = "[Speed really can make up for everything.]<Style=Rainbow> I\'ve taught you all I know. Go be terrifying!",
 Answers = true
 },
 ThunderTrainer_NoAccess = {
 Text = "Oh. You\'re not the breathing kind, are you? I, um, can\'t help with that.",
 Answers = true
 },
 ThunderTrainer_HasStyle = {
 Text = "W-wait, you already have a Breathing? Then you don\'t need me! Two at once is how people explode.",
 Answers = true
 }
};
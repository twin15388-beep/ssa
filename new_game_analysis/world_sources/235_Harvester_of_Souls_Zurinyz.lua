-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local NameTag = Utility.NameTag;

return {
 ["Harvester of Souls Zurinyz"] = {
 Text = "Most people come seeking answers before they\'ve earned them.",
 Answers = true,
 IfTrue = "Zurinyz_2",

 BeforeRun = function(p1, p2) -- Line: 18, Name: BeforeRun
 -- upvalues: Quests (copy), Players (copy), Utility (copy)
 if Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill learn the Reaping Blades Style(Lv 100)") == "Doing" then
 local Data = Utility.GetData(Players.LocalPlayer);
 local v3 = Quests.Holder["Ill learn the Reaping Blades Style(Lv 100)"];
 local v4;

 if Data == nil then
 v4 = nil;
 else
 v4 = v3 ~= nil and Data.Quests.Holder:FindFirstChild(v3.QuestInstance.Name) or nil;
 end;

 local v5 = v4 ~= nil and v4.Tasks:FindFirstChild("Common Fish") or nil;

 return (v5 == nil or v5.Value.Value >= v5.Max.Value) and "Zurinyz_Doing" or "Zurinyz_DoingFish";
 end;

 local Data = Utility.GetData(Players.LocalPlayer);
 local v6 = Data ~= nil and Data.Powers.FightingStyle.Value or "";

 if v6 ~= "" then
 return v6 == "Reaping Blades" and "Zurinyz_Done" or "Zurinyz_HasStyle";
 end;
 end
 },
 Zurinyz_2 = {
 Answers = true,
 IfTrue = "Zurinyz_3",
 Text = `So, you've decided to walk the path of the {NameTag("Reaper")}. Understand this: strength alone will not earn you this fighting style.`
 },
 Zurinyz_3 = {
 Text = "Before I can teach you, you must prove it. Bring me the catch, the scroll, and my student\'s defeat.",
 Answers = {
 ["Not yet"] = "",
 ["Ill learn the Reaping Blades Style(Lv 100)"] = "AddQuest"
 }
 },
 Zurinyz_Doing = {
 Text = "Just give up..",
 Answers = true
 },
 Zurinyz_DoingFish = {
 Text = "Just give up..",
 Answers = {
 ["Ill hand over the catch"] = "ZurinyzTakeCatch",
 ["Not yet"] = ""
 }
 },
 Zurinyz_Catch = {
 Text = "Good. The cold will keep them.",
 Answers = true
 },
 Zurinyz_NoCatch = {
 Text = "You bring me nothing. Do not make a habit of it.",
 Answers = true
 },
 Zurinyz_HasStyle = {
 Text = "You already walk another path. I will not braid the two.",
 Answers = true
 },
 Zurinyz_Done = {
 Text = "You\'ve done well. The scroll, the training, and Kuzan. You\'ve proven yourself worthy.",
 Answers = true,
 IfTrue = "Zurinyz_Done2"
 },
 Zurinyz_Done2 = {
 Answers = true,
 Text = `[Nothing wasted. Nothing spared.]<Style=Rainbow> That is what the {NameTag("Reaping Blades")} are for.`
 }
};
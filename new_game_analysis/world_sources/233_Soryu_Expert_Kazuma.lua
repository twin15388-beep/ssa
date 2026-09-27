-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local NameTag = Utility.NameTag;

return {
 ["Soryu Expert Kazuma"] = {
 Text = "Most people come seeking answers before they\'ve earned them.",
 Answers = true,
 IfTrue = "Kazuma_2",

 BeforeRun = function(p1, p2) -- Line: 17, Name: BeforeRun
 -- upvalues: Quests (copy), Players (copy), Utility (copy)
 if Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill learn the Soryu Style(Lv 62)") == "Doing" then
 local Data = Utility.GetData(Players.LocalPlayer);
 local v3 = Quests.Holder["Ill learn the Soryu Style(Lv 62)"];
 local v4;

 if Data == nil then
 v4 = nil;
 else
 v4 = v3 ~= nil and Data.Quests.Holder:FindFirstChild(v3.QuestInstance.Name) or nil;
 end;

 local v5 = v4 ~= nil and v4.Tasks:FindFirstChild("Common Fish") or nil;

 return (v5 == nil or v5.Value.Value >= v5.Max.Value) and "Kazuma_Doing" or "Kazuma_DoingFish";
 end;

 local Data = Utility.GetData(Players.LocalPlayer);
 local v6 = Data ~= nil and Data.Powers.FightingStyle.Value or "";

 if v6 ~= "" then
 return v6 == "Soryu" and "Kazuma_Done" or "Kazuma_HasStyle";
 end;
 end
 },
 Kazuma_2 = {
 Text = `I can teach you {NameTag("Soryu")}, but it won't be easy.`,
 Answers = {
 ["Not yet"] = "",
 ["Ill learn the Soryu Style(Lv 62)"] = "AddQuest"
 }
 },
 Kazuma_Doing = {
 Text = "Just give up..",
 Answers = true
 },
 Kazuma_DoingFish = {
 Text = "Just give up..",
 Answers = {
 ["Ill hand over the catch"] = "KazumaTakeCatch",
 ["Not yet"] = ""
 }
 },
 Kazuma_Catch = {
 Text = "Hm. They will do. I am keeping count.",
 Answers = true
 },
 Kazuma_NoCatch = {
 Text = "You are holding nothing. Come back with fish.",
 Answers = true
 },
 Kazuma_HasStyle = {
 Text = "You already carry a style. I do not teach over another master\'s work.",
 Answers = true
 },
 Kazuma_Done = {
 Text = "You\'ve done well. You\'ve proven yourself worthy.",
 Answers = true,
 IfTrue = "Kazuma_Done2"
 },
 Kazuma_Done2 = {
 Answers = true,
 Text = `[Earned, not given.]<Style=Rainbow> That is what {NameTag("Soryu")} is. Keep it that way.`
 }
};
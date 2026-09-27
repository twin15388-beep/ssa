-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local NameTag = Utility.NameTag;

return {
 ["Tai Chi Expert Renjiro"] = {
 Text = "You came in loud. Everyone does, at first.",
 Answers = true,
 IfTrue = "Renjiro_2",

 BeforeRun = function(p1, p2) -- Line: 19, Name: BeforeRun
 -- upvalues: Quests (copy), Players (copy), Utility (copy)
 if Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill learn the Tai Chi Style(Lv 65)") == "Doing" then
 local Data = Utility.GetData(Players.LocalPlayer);
 local v3 = Quests.Holder["Ill learn the Tai Chi Style(Lv 65)"];
 local v4;

 if Data == nil then
 v4 = nil;
 else
 v4 = v3 ~= nil and Data.Quests.Holder:FindFirstChild(v3.QuestInstance.Name) or nil;
 end;

 local v5 = v4 ~= nil and v4.Tasks:FindFirstChild("Common Fish") or nil;

 return (v5 == nil or v5.Value.Value >= v5.Max.Value) and "Renjiro_Doing" or "Renjiro_DoingFish";
 end;

 local Data = Utility.GetData(Players.LocalPlayer);
 local v6 = Data ~= nil and Data.Powers.FightingStyle.Value or "";

 if v6 ~= "" then
 return v6 == "Tai Chi" and "Renjiro_Done" or "Renjiro_HasStyle";
 end;
 end
 },
 Renjiro_2 = {
 Text = `{NameTag("Tai Chi")} is not something I hand over. Earn it, and it will already be yours by the time I say so.`,
 Answers = {
 ["Not yet"] = "",
 ["Ill learn the Tai Chi Style(Lv 65)"] = "AddQuest"
 }
 },
 Renjiro_Doing = {
 Text = "Still forcing it. Come back when you stop.",
 Answers = true
 },
 Renjiro_DoingFish = {
 Text = "Still forcing it. Come back when you stop.",
 Answers = {
 ["Ill hand over the catch"] = "RenjiroTakeCatch",
 ["Not yet"] = ""
 }
 },
 Renjiro_Catch = {
 Text = "Set them down. I will keep the count.",
 Answers = true
 },
 Renjiro_NoCatch = {
 Text = "You brought nothing. Notice that before you walk in next time.",
 Answers = true
 },
 Renjiro_HasStyle = {
 Text = "You have a style already. Set it down before you ask for mine.",
 Answers = true
 },
 Renjiro_Done = {
 Text = "You finished. Quietly, which is the part that matters.",
 Answers = true,
 IfTrue = "Renjiro_Done2"
 },
 Renjiro_Done2 = {
 Answers = true,
 Text = `[Yield, then answer.]<Style=Rainbow> That is {NameTag("Tai Chi")}. Do not turn it into a hammer.`
 }
};
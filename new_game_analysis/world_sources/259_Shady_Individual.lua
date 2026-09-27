-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);

return {
 ["Shady Individual Rooyi"] = {
 Text = "The Demon King has taken notice of five promising Mizunoto Demon Slayers.",
 Answers = true,
 IfTrue = "Shady Individual_2",

 BeforeRun = function(p1, p2) -- Line: 14, Name: BeforeRun
 -- upvalues: Quests (copy), Players (copy)
 if Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill eliminate the Mizunoto(Lv 62)") == "Doing" then
 return "Shady Individual_Doing";
 end;
 end
 },
 ["Shady Individual_2"] = {
 Text = "They survived encounters that should have killed them.",
 Answers = true,
 IfTrue = "Shady Individual_3"
 },
 ["Shady Individual_3"] = {
 Text = "Before they grow stronger, they must be [eliminated.]<Style=Fade,Color=(1,.3,.3)>",
 Answers = {
 Close = "",
 ["Ill eliminate the Mizunoto(Lv 62)"] = "AddQuest"
 }
 },
 ["Shady Individual_Doing"] = {
 Text = "Have you gotten rid of the threat yet?",
 Answers = {
 Close = "",
 ["Hand over the katanas"] = "DeliverKatanasToRooyi"
 }
 },
 ["Shady Individual_Thanks"] = {
 Text = "Good job. I see why you were acknowledged.",
 Answers = true
 },
 ["Shady Individual_NotEnough"] = {
 Answers = true,
 Text = `Five broken blades. Bring me every {require(ReplicatedStorage.CAM.Global.Utility).NameTag("Broken Nichirin Katana")} they carry.`
 }
};
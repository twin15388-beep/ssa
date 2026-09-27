-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local NameTag = require(ReplicatedStorage.CAM.Global.Utility).NameTag;

return {
 Betty = {
 Text = "Oh no... this is terrible!",
 Answers = true,
 IfTrue = "Betty_2",

 BeforeRun = function(p1, p2) -- Line: 11, Name: BeforeRun
 -- upvalues: Quests (copy), Players (copy)
 if Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill look for it(Lv 10)") == "Doing" then
 return "Betty_Doing";
 end;

 if Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill look for it(Lv 10)") == "Done" then
 return "Betty_Done";
 end;
 end
 },
 Betty_2 = {
 Answers = true,
 IfTrue = "Betty_3",
 Text = `My favorite {NameTag("gemstone")} slipped from my pocket and fell into the [river below]<Color=(.4,.85,1)>.`
 },
 Betty_3 = {
 Text = "Could you help me look for it?",
 Answers = {
 Close = "",
 ["Ill look for it(Lv 10)"] = "AddQuest"
 }
 },
 Betty_Doing = {
 Text = "Did you find it yet? It\'s small, but it\'s shiny!",
 Answers = true
 },
 Betty_Done = {
 Answers = true,
 Text = `My {NameTag("gemstone")} is back where it belongs, and it's staying in my pocket this time. Thank you!`
 }
};
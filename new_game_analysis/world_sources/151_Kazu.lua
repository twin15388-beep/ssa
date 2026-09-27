-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local NameTag = Utility.NameTag;

local function hasNote() -- Line: 10
 -- upvalues: Utility (copy), Players (copy)
 local Data = Utility.GetData(Players.LocalPlayer);
 local v1;

 if Data == nil then
 v1 = false;
 else
 v1 = Data.Inventory.Inventory:FindFirstChild("Suspicious Note") ~= nil;
 end;

 return v1;
end;

return {
 Kazu = {
 Text = "We\'ve got people acting strange around the village. I don\'t trust them.",
 Answers = true,
 IfTrue = "Kazu_2",

 BeforeRun = function(p2, p3) -- Line: 17, Name: BeforeRun
 -- upvalues: Quests (copy), Players (copy), Utility (copy)
 if Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill help clear them out") == "Doing" then
 return "Kazu_Doing";
 end;

 local Data = Utility.GetData(Players.LocalPlayer);
 local v4;

 if Data == nil then
 v4 = false;
 else
 v4 = Data.Inventory.Inventory:FindFirstChild("Suspicious Note") ~= nil;
 end;

 if v4 then
 return Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill bring him the notes") == "None" and "Kazu_Done" or "Kazu_Nudge";
 end;
 end
 },
 Kazu_2 = {
 Text = "Help me clear out a few of these [\"villagers.\"]<Style=Fade,Color=(1,.3,.3)>",
 Answers = {
 Close = "",
 ["Ill help clear them out"] = "AddQuest"
 }
 },
 Kazu_Doing = {
 Text = "Have you cleared out those [\"villagers\"]<Color=(1,.3,.3)> yet?",
 Answers = true
 },
 Kazu_Done = {
 Text = "You see this? These notes...",
 Answers = true,
 IfTrue = "Kazu_Done2"
 },
 Kazu_Done2 = {
 Text = "They\'re not random. I can\'t decode it all, but someone is giving orders.",
 Answers = true,
 IfTrue = "Kazu_Done3"
 },
 Kazu_Done3 = {
 Text = `Take them to {NameTag("Noote")}, the chief's nephew. Codes are his thing.`,
 Answers = {
 Close = "",
 ["Ill bring him the notes"] = "AddQuest"
 }
 },
 Kazu_Nudge = {
 Answers = true,
 Text = `You're still carrying those notes. {NameTag("Noote")} is the one who can read them.`
 }
};
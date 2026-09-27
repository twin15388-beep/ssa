-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local NameTag = Utility.NameTag;

local function bladeFound() -- Line: 33
 -- upvalues: Utility (copy), Players (copy), Quests (copy)
 local Data = Utility.GetData(Players.LocalPlayer);
 local v1 = Quests.Holder["Ill look for your blade(Lv 75)"];
 local v2;

 if Data == nil then
 v2 = nil;
 else
 v2 = v1 ~= nil and Data.Quests.Holder:FindFirstChild(v1.QuestInstance.Name) or nil;
 end;

 if v2 == nil then
 return false;
 end;

 local v3 = v2.Tasks:FindFirstChild("Nichirin Blade found");
 local v4;

 if v3 == nil then
 v4 = false;
 else
 v4 = v3.Value.Value >= v3.Max.Value;
 end;

 return v4;
end;

return {
 Ren = {
 Text = "Ugh...",
 Answers = true,
 IfTrue = "Ren_2",

 BeforeRun = function(p5, p6) -- Line: 44, Name: BeforeRun
 -- upvalues: Quests (copy), Players (copy), bladeFound (copy)
 local PlayerQuestState = Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill look for your blade(Lv 75)");

 if PlayerQuestState == "Doing" then
 return bladeFound() and "Ren_Return" or "Ren_Waiting";
 end;

 if PlayerQuestState == "Done" then
 return "Ren_Done";
 end;
 end
 },
 Ren_2 = {
 Text = "My head still hurts.",
 Answers = true,
 IfTrue = "Ren_3"
 },
 Ren_3 = {
 Text = "I was returning from a mission when I slipped near the [river]<Color=(1,.85,.3)>.",
 Answers = true,
 IfTrue = "Ren_4"
 },
 Ren_4 = {
 Answers = true,
 IfTrue = "Ren_5",
 Text = `When I woke up, my {NameTag("Nichirin Blade")} was gone.`
 },
 Ren_5 = {
 Text = "Can you help me find it?",
 Answers = {
 Close = "",
 ["Ill look for your blade(Lv 75)"] = "AddQuest",
 ["Where exactly did you slip?"] = "Ren_Where"
 }
 },
 Ren_Where = {
 Text = "The road back from a mission runs up the river gorge, [northwest]<Color=(1,.85,.3)> of here. The bank gave under me.",
 Answers = true,
 IfTrue = "Ren_Where2"
 },
 Ren_Where2 = {
 Text = "I came round on the stones with the water at my back and my hand empty.",
 Answers = true,
 IfTrue = "Ren_Where2b"
 },
 Ren_Where2b = {
 Text = "The current only runs one way down there, toward the [falls]<Color=(1,.85,.3)>.",
 Answers = true,
 IfTrue = "Ren_Where3"
 },
 Ren_Where3 = {
 Answers = true,
 IfTrue = "Ren_Where3b",
 Text = `I'd go myself, but {NameTag("Shiori")} won't have me off the grounds until my head clears.`
 },
 Ren_Where3b = {
 Text = "A slow lap of the lawn is the whole of my day.",
 Answers = true,
 IfTrue = "Ren_5"
 },
 Ren_Waiting = {
 Text = "That blade means everything to a Demon Slayer.",
 Answers = {
 Close = "",
 ["Where exactly did you slip?"] = "Ren_WaitingWhere"
 }
 },
 Ren_WaitingWhere = {
 Text = "Go [northwest]<Color=(1,.85,.3)> and keep heading downhill until you meet the river, then follow it to the [falls]<Color=(1,.85,.3)>.",
 Answers = true,
 IfTrue = "Ren_WaitingWhere2"
 },
 Ren_WaitingWhere2 = {
 Text = "It\'ll be at the foot of them, on the bank.",
 Answers = true
 },
 Ren_Return = {
 Text = "You came back. Please tell me you found it.",
 Answers = {
 Close = "",
 ["I found your blade"] = "ReturnNichirinToRen"
 }
 },
 Ren_Thanks = {
 Text = "You found it...",
 Answers = true,
 IfTrue = "Ren_Thanks2"
 },
 Ren_Thanks2 = {
 Text = "Thank goodness.",
 Answers = true,
 IfTrue = "Ren_Thanks3"
 },
 Ren_Thanks3 = {
 Text = "I thought I\'d never see it again.",
 Answers = true
 },
 Ren_Done = {
 Text = "Head\'s still ringing, but I\'ve got my blade back. I won\'t forget that. The gourds by my post are yours to buy. No slayer should train their breathing dry.",
 Answers = true
 },
 Ren_GourdSuccess = {
 Text = "Fill your lungs with it. That\'s what it\'s for.",
 Answers = 1
 },
 Ren_GourdFail = {
 Answers = true,

 Text = function(p7, p8) -- Line: 155, Name: Text
 return `No sale yet -- you'll want {p8.PurchaseReason}. I'm not going anywhere; Shiori's orders.`;
 end
 },
 Ren_NoBlade = {
 Text = "You\'ve come back with nothing. It\'s still out there, at the foot of the falls.",
 Answers = true
 }
};
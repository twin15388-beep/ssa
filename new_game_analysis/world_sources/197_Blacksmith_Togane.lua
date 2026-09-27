-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local v1;

if RunService:IsClient() then
 v1 = require(ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.Blacksmith);
else
 v1 = nil;
end;

local v2;

if RunService:IsClient() then
 v2 = require(ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.Exchange);
else
 v2 = nil;
end;

local v3;

if v1 == nil then
 v3 = nil;
else
 v3 = v1({
 Station = "Ouwland"
 }) or nil;
end;

local v4;

if v2 == nil then
 v4 = nil;
else
 v4 = v2() or nil;
end;

return {
 ["Blacksmith Togane"] = {
 Text = "Mind the slag. Show me what you\'ve brought.",
 Content = v3,
 Answers = {
 ["Your other forge"] = "Togane_Pattern",
 ["The climb"] = "Togane_Climb",
 ["The set drawings"] = "Togane_Sets",
 ["Swap materials"] = "Togane_Exchange",
 Farewell = ""
 }
 },
 Togane_Exchange = {
 Text = "Any of the six for any other, one for one. Pick both sides.",
 Content = v4,
 Answers = {
 ["Make the exchange"] = "ToganeExchangeReview",
 Back = "Blacksmith Togane",
 Farewell = ""
 }
 },
 Togane_ExchangeNothing = {
 Text = "Pick what you\'re giving and what you want first.",
 Answers = true,
 IfTrue = "Togane_Exchange"
 },
 Togane_ExchangeConfirm = {
 Text = function(p5, p6) -- Line: 62, Name: Text
 -- upvalues: Utility (copy)
 local Exchange = p6.Exchange;

 return `{Exchange.Amount} {Utility.NameTag(Exchange.Give)} for {Exchange.Amount} {Utility.NameTag(Exchange.Take)}. Fair enough?`;
 end,

 Answers = {
 Deal = "ToganeExchange",
 ["Let me look again"] = "Togane_Exchange"
 }
 },
 Togane_ExchangeDone = {
 Text = "There. Weighed it out even, which is rare for me.",
 Answers = {
 ["Swap more"] = "Togane_Exchange",
 Back = "Blacksmith Togane",
 Farewell = ""
 }
 },
 Togane_ExchangeFail = {
 Text = "That\'s more than you\'re carrying. Count again.",
 Answers = true,
 IfTrue = "Togane_Exchange"
 },
 Togane_Sets = {
 Text = "Bring me a whole set of drawings and I\'ll draw the last two myself.",
 Answers = {
 Firstlight = "SeriesCapstoneFirstlight",
 Nightfall = "SeriesCapstoneNightfall",
 Back = "Blacksmith Togane"
 }
 },
 Togane_SetsMissing = {
 Text = "You\'re a drawing or two short. Come back with the lot.",
 Answers = {
 Back = "Blacksmith Togane",
 Farewell = ""
 }
 },
 Togane_SetsGiven = {
 Text = "There. The top and the bottom, drawn to match the rest.",
 Answers = {
 Back = "Blacksmith Togane",
 Farewell = ""
 }
 },
 Togane_SetsDone = {
 Text = "You\'ve had those two off me already. Go and cut them.",
 Answers = {
 Back = "Blacksmith Togane",
 Farewell = ""
 }
 },
 Togane_Pattern = {
 Text = "Up in [Ouwigahara]<Color=(.8,.7,1)>. Bring a blade you own and it goes up a tier.",
 Answers = true,
 IfTrue = "Togane_Pattern2",

 BeforeRun = function() -- Line: 121, Name: BeforeRun
 -- upvalues: Quests (copy), Players (copy)
 local PlayerQuestState = Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill find the forge(Lv 65)");

 if PlayerQuestState == "Done" then
 return "Togane_PatternDone";
 end;

 if PlayerQuestState == "Doing" then
 return "Togane_PatternDoing";
 end;
 end
 },
 Togane_Pattern2 = {
 Text = "Trouble is the portal past the plains. Shut for years. Go and open it.",
 Answers = {
 ["Ill find the forge(Lv 65)"] = "AddQuest",
 Back = "Blacksmith Togane",
 Farewell = ""
 }
 },
 Togane_PatternDoing = {
 Text = "Still here? It\'s past the plains. Go on.",
 Answers = {
 Back = "Blacksmith Togane",
 Farewell = ""
 }
 },
 Togane_PatternDone = {
 Text = "You got it open. Come and find me up there.",
 Answers = {
 Back = "Blacksmith Togane",
 Farewell = ""
 }
 },
 Togane_Climb = {
 Text = "I managed forty floors once. My knees still bring it up.",
 Answers = true,
 IfTrue = "Togane_Climb2"
 },
 Togane_Climb2 = {
 Text = "Knew a man who did ninety. He came back different.",
 Answers = {
 Back = "Blacksmith Togane",
 Farewell = ""
 }
 }
};
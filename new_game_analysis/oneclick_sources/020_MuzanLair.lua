-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local MuzanSettings = require(ReplicatedStorage.CAM.Global.MuzanSettings);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local v1;

if RunService:IsClient() then
 v1 = require(ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.EvilArtSpinning);
else
 v1 = nil;
end;

local v2;

if RunService:IsClient() then
 v2 = require(ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.Shop);
else
 v2 = nil;
end;

local v3;

if RunService:IsClient() then
 v3 = require(ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.SpinsCounter);
else
 v3 = nil;
end;

local Spinners = require(ReplicatedStorage.CAM.Global.Spinners);
local v4 = {};

for _, v in Spinners.EvilArt.Pool() do
 local v5 = `{v} Orb`;
 table.insert(v4, v5);
end;

local v6 = (Spinners.EvilArt.Odds().Nothing or 0) * 100;
local math_round_ret = math.round(v6);

local function fireAssign() -- Line: 52
 -- upvalues: Players (copy), Utility (copy), MuzanSettings (copy), Quests (copy), SignalEvent (copy)
 local LocalPlayer = Players.LocalPlayer;
 local Data = Utility.GetData(LocalPlayer);

 if Data == nil or Data.Race.Value ~= "Human" then
 return;
 end;

 if LocalPlayer:GetAttribute(MuzanSettings.LairAttribute) ~= true then
 return;
 end;

 if Data.Inventory.Inventory:FindFirstChild("Muzan\'s Blood") ~= nil then
 return;
 end;

 if Quests.GetPlayerQuestState(LocalPlayer, "Muzan Quest") == "Doing" then
 return;
 end;

 SignalEvent.ToServer("MuzanLairAssign");
end;

local v11 = {
 MuzanLair = {
 Text = "[So. You made it to me.]<Style=Fade,Color=(.8,.7,1)>",
 Answers = true,
 IfTrue = "MuzanLair_2",

 BeforeRun = function(p7, p8) -- Line: 66, Name: BeforeRun
 -- upvalues: Utility (copy), Players (copy), Quests (copy)
 local Data = Utility.GetData(Players.LocalPlayer);

 if Data == nil then
 return "MuzanLair_Dismiss";
 end;

 if Data.Race.Value == "Demon" or Data.Race.Value == "Hybrid" then
 return "MuzanLair_Demon";
 end;

 if Data.Race.Value ~= "Human" then
 return "MuzanLair_Dismiss";
 end;

 if Data.Inventory.Inventory:FindFirstChild("Muzan\'s Blood") ~= nil then
 return "MuzanLair_Drink";
 end;

 if Quests.GetPlayerQuestState(Players.LocalPlayer, "Muzan Quest") == "Doing" then
 return "MuzanLair_Busy";
 end;
 end,

 OnShow = function(p9, p10) -- Line: 84, Name: OnShow
 -- upvalues: fireAssign (copy)
 fireAssign();
 end
 },
 MuzanLair_2 = {
 Text = "You rang that bell [like it means something.]<Style=Fade,Color=(.8,.7,1)>",
 Answers = true,
 IfTrue = "MuzanLair_3"
 },
 MuzanLair_3 = {
 Text = "Prove you\'re worth more than [the rest who\'ve knelt here and failed.]<Style=Fade,Color=(1,.3,.3)>",
 Answers = true
 },
 MuzanLair_Busy = {
 Text = "[Finish your task.]<Color=(1,.3,.3)>",
 Answers = true
 },
 MuzanLair_Drink = {
 Text = "You have what you need. [Drink, and shed that fragile, dying shell for good.]<Style=Fade,Color=(.8,.7,1)>",
 Answers = true
 },
 MuzanLair_Demon = {
 Text = "...",
 Answers = {
 ["Give me your power"] = "MuzanLair_DemonPower",
 ["Give me a task"] = "MuzanLair_DemonTask"
 }
 },
 MuzanLair_DemonPower = {
 Content = v1,
 Text = `[You have {math_round_ret}% chance of rolling nothing, and {100 - math_round_ret}% chance of rolling a random Evil Art, good luck.]<Style=Fade,Color=(.8,.7,1)>`,
 Answers = {
 ["I don\'t want to roll"] = "MuzanLair_DemonBuy",
 Farewell = ""
 }
 }
};
local v14 = {
 Text = "…",

 OnShow = function(p12, p13) -- Line: 129, Name: OnShow
 p13.CartShopNode = "MuzanLair_DemonBuy";
 end
};
local v15;

if v2 == nil then
 v15 = nil;
else
 v15 = v2(v4, {
 Single = true,
 Counter = v3
 });
end;

v14.Content = v15;
v14.Answers = {
 ["Buy the selection"] = "ReviewCartPurchase",
 Back = "MuzanLair_DemonPower",
 Farewell = ""
};
v11.MuzanLair_DemonBuy = v14;
v11.MuzanLair_DemonTask = {
 Text = "Slayers grow bold when I\'m not watching. [Go remind them why they should be afraid.]<Style=Fade,Color=(1,.3,.3)>",
 Answers = {
 Cancel = ""
 },

 Content = function(p16, p17, p18, p19) -- Line: 150, Name: Content
 -- upvalues: ReplicatedStorage (copy)
 return require(ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.Quests)(p16, p17, p18, p19, "MuzanLair_DemonTask_Denied");
 end
};
v11.MuzanLair_DemonTask_Denied = {
 Answers = true,
 IfTrue = "MuzanLair_DemonTask",
 ContinueContent = true,
 ContinueIcon = true,

 Text = function(p20, p21) -- Line: 159, Name: Text
 -- upvalues: Utility (copy)
 local v22 = p21 ~= nil and p21.HuntDenial or {};

 return (v22.Blocking == nil or v22.Reason ~= false) and (v22.Reason == true and "[Patience. I will not repeat myself so soon.]<Style=Fade,Color=(1,.3,.3)>" or (v22.Reason == 1 and "That one is already yours. [Go and finish it.]<Color=(1,.3,.3)>" or "[That one is not for you.]<Style=Fade,Color=(1,.3,.3)>")) or `You are already bound to {Utility.NameTag(v22.Blocking)}. [Finish it.]<Color=(1,.3,.3)>`;
 end
};
v11.MuzanLair_Dismiss = {
 Text = "[Get lost.]<Color=(1,.3,.3)>",
 Answers = true
};

return v11;
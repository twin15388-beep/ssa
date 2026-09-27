-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local Shop = require(ReplicatedStorage.CAM.Global.Shop);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local v1;

if RunService:IsClient() then
 v1 = require(ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.Sell);
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

if v1 == nil then
 v3 = nil;
else
 v3 = v1() or nil;
end;

local v6 = {
 Ginzo = {
 Text = "I\'ll buy whatever you\'re selling, human or otherwise. Business is business.",
 Answers = true,
 IfTrue = "Ginzo_Offer",

 BeforeRun = function(p4, p5) -- Line: 28, Name: BeforeRun
 -- upvalues: Quests (copy), Players (copy), Utility (copy)
 local PlayerQuestState = Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill find the jewelry box(Lv 45)");

 if PlayerQuestState == "Done" then
 return "Ginzo_Sell";
 end;

 if PlayerQuestState == "Doing" then
 local Data = Utility.GetData(Players.LocalPlayer);

 return (Data == nil or Data.Inventory.Inventory:FindFirstChild("Jewelry Box") == nil) and "Ginzo_Waiting" or "Ginzo_Return";
 end;
 end
 },
 Ginzo_Offer = {
 Text = "But first, retrieve my Jewelry Box from my home in the Village Hidden in the Mist.",
 Answers = true,
 IfTrue = "Ginzo_Offer2"
 },
 Ginzo_Offer2 = {
 Text = "Bring it back, and we\'ll talk.",
 Answers = {
 Close = "",
 ["Ill find the jewelry box(Lv 45)"] = "AddQuest"
 }
 },
 Ginzo_Waiting = {
 Text = "Well? Where\'s my box?",
 Answers = true
 },
 Ginzo_Return = {
 Text = "That\'s it. That\'s my box.",
 Answers = {
 Close = "",
 ["Hand over the jewelry box"] = "DeliverJewelryBoxToGinzo"
 }
 },
 Ginzo_Thanks = {
 Text = "Excellent. That\'s exactly what I was looking for.",
 Answers = true,
 IfTrue = "Ginzo_Thanks2"
 },
 Ginzo_Thanks2 = {
 Text = "A deal is a deal.",
 Answers = 1
 },
 Ginzo_NoBox = {
 Text = "You\'re not carrying my box.",
 Answers = true
 },
 Ginzo_Sell = {
 Text = "I\'ll buy whatever you sell.",
 Content = v3,
 Answers = {
 ["Sell the selection"] = "GinzoReview",
 ["Show me your stock"] = "Ginzo_Buy",
 Farewell = "Ginzo_Bye"
 }
 }
};
local v9 = {
 Text = "Scrap and thread. Every forge wants both, and nobody wants to go digging for them.",

 OnShow = function(p7, p8) -- Line: 90, Name: OnShow
 p8.CartShopNode = "Ginzo_Buy";
 end
};
local v10;

if v2 == nil then
 v10 = nil;
else
 v10 = v2({ "Metal Scraps", "Silk Thread" }) or nil;
end;

v9.Content = v10;
v9.Answers = {
 ["Buy the selection"] = "ReviewCartPurchase",
 Back = "Ginzo_Sell",
 Farewell = "Ginzo_Bye"
};
v6.Ginzo_Buy = v9;
v6.Ginzo_Confirm = {
 Text = function(p11, p12) -- Line: 102, Name: Text
 -- upvalues: Shop (copy)
 local SellTotals, v13 = Shop.GetSellTotals(p12.SellSelection);
 p12.SellTotals = SellTotals;

 return `{v13} piece(s) then. I will give you {Shop.FormatSellTotalsTextPlus(SellTotals)} for the lot. Deal?`;
 end,

 Answers = {
 Deal = "GinzoSell",
 ["Let me look again"] = "Ginzo_Sell"
 }
};
v6.Ginzo_Sold = {
 Text = function(p14, p15) -- Line: 116, Name: Text
 -- upvalues: Shop (copy)
 return `A pleasure. {Shop.FormatSellTotalsTextPlus(p15.SoldFor or {})}, as promised.`;
 end,

 Answers = {
 ["Sell more"] = "Ginzo_Sell",
 Close = ""
 }
};
v6.Ginzo_Nothing = {
 Text = "You have not picked anything out yet.",
 Answers = true,
 IfTrue = "Ginzo_Sell"
};
v6.Ginzo_NoSale = {
 Text = "Hm. Nothing there I can pay for.",
 Answers = true,
 IfTrue = "Ginzo_Sell"
};
v6.Ginzo_Bye = {
 Text = "Come back when your pockets are heavier.",
 Answers = 1
};

return v6;
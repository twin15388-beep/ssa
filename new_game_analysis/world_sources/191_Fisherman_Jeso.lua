-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local Shop = require(ReplicatedStorage.CAM.Global.Shop);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local NameTag = Utility.NameTag;
local v1;

if RunService:IsClient() then
 v1 = require(ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.Shop);
else
 v1 = nil;
end;

local v2 = { "Worm" };
local v5 = {
 ["Fisherman Jeso"] = {
 Text = "Well now. Come to buy a rod off an old man, have you?",
 Answers = true,
 IfTrue = "Jeso_Regulations",

 BeforeRun = function(p3, p4) -- Line: 28, Name: BeforeRun
 -- upvalues: Utility (copy), Players (copy), Quests (copy)
 local Data = Utility.GetData(Players.LocalPlayer);

 if Data ~= nil and Data.Inventory.Inventory:FindFirstChild("Legendary Fishing Rod") ~= nil then
 return "Jeso_Successor";
 end;

 local PlayerQuestState = Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill find the permit stamp(Lv 45)");

 return PlayerQuestState == "Done" and "Jeso_Approved" or (PlayerQuestState == "Doing" and "Jeso_Waiting" or nil);
 end
 },
 Jeso_Regulations = {
 Text = "I\'d hand you one gladly, but the village won\'t have it. Permits, they want now. Paper, for water.",
 Answers = true,
 IfTrue = "Jeso_SendToSofen"
 },
 Jeso_SendToSofen = {
 Answers = 1,
 Text = `Go see {NameTag("Dock Master Sofen")} about the stamp, and mind your manners with him. Then come back to me.`
 },
 Jeso_Waiting = {
 Text = "No stamp on you yet, young one. These eyes are old, not blind.",
 Answers = true
 },
 Jeso_Approved = {
 Text = "There we are. Stamped and proper. Now the old man can do business with you.",
 Answers = {
 ["The rods?"] = "Jeso_Price",
 ["Got any bait?"] = "Jeso_BaitShopIntro",
 ["Better bait than worms?"] = "Jeso_BaitTip",
 Farewell = ""
 }
 },
 Jeso_BaitShopIntro = {
 Text = "Worms. Dug them fresh this morning, so don\'t go turning your nose up.",
 Answers = true,
 IfTrue = "Jeso_BaitShop"
 }
};
local v8 = {
 OnShow = function(p6, p7) -- Line: 71, Name: OnShow
 p7.CartShopNode = "Jeso_BaitShop";
 end
};
local v9;

if v1 == nil then
 v9 = nil;
else
 v9 = v1(v2) or nil;
end;

v8.Content = v9;
v8.Text = `Anything fancier is {NameTag("Baitmonger Nori")}'s trade.`;
v8.Answers = {
 ["Buy the selection"] = "ReviewCartPurchase",
 ["Who is Nori?"] = "Jeso_BaitTip",
 Farewell = ""
};
v5.Jeso_BaitShop = v8;
v5.Jeso_BaitTip = {
 Text = "Worms pull up weed and small fry, and plenty of both. The rare bites want better than a worm.",
 Answers = true,
 IfTrue = "Jeso_BaitTip2"
};
v5.Jeso_BaitTip2 = {
 Answers = true,
 IfTrue = "Jeso_BaitTip3",

 Text = function() -- Line: 88, Name: Text
 -- upvalues: Quests (copy), Players (copy), NameTag (copy)
 if Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill restock the infirmary(Lv 70)") == "Done" then
 return `{NameTag("Baitmonger Nori")} keeps the proper stuff, up in {NameTag("Hidden Mist Village")}. He knows your name now.`;
 end;

 return `That'd be {NameTag("Baitmonger Nori")}'s trade, up the hill in {NameTag("Hidden Mist Village")}.`;
 end
};
v5.Jeso_BaitTip3 = {
 Text = function() -- Line: 98, Name: Text
 -- upvalues: Quests (copy), Players (copy), NameTag (copy)
 return Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill restock the infirmary(Lv 70)") == "Done" and "Better bait, fuller line. But the rod sets your ceiling, and don\'t let anyone tell you different." or `He'll not deal with strangers, mind. Do right by {NameTag("Shiori")} at the {NameTag("Butterfly Estate")} and word travels. It always does.`;
 end,

 Answers = {
 ["Which bait for which rod?"] = "Jeso_Pairing",
 Farewell = ""
 }
};
v5.Jeso_Pairing = {
 Text = "Sit a moment, this one\'s worth the hearing. Bait decides how often the line comes back full.",
 Answers = true,
 IfTrue = "Jeso_Pairing2"
};
v5.Jeso_Pairing2 = {
 Text = "The rod decides what\'s on it.",
 Answers = true,
 IfTrue = "Jeso_Pairing2b"
};
v5.Jeso_Pairing2b = {
 Answers = true,
 IfTrue = "Jeso_Pairing3",
 Text = `Rich bait on that {NameTag("Basic Fishing Rod")} will keep you hauling all day, and it'll be small fry all day.`
};
v5.Jeso_Pairing3 = {
 Answers = true,
 IfTrue = "Jeso_Pairing4",
 Text = `On the {NameTag("Rare Fishing Rod")}, now, a {NameTag("Fish Head")}. That's the rung where good bait starts paying you back.`
};
v5.Jeso_Pairing4 = {
 Answers = true,
 IfTrue = "Jeso_Pairing5",
 Text = `And the {NameTag("Golden Tentacle")} pulls the deep things up. Only the {NameTag("Legendary Fishing Rod")} will hold them.`
};
v5.Jeso_Pairing5 = {
 Text = "I watched a line go once, hands and all.",
 Answers = {
 Close = "",
 ["Whose hands?"] = "Jeso_Isao"
 }
};
v5.Jeso_Isao = {
 Text = "Ah. I\'ll not make a story out of a man\'s last day, young one.",
 Answers = true,
 IfTrue = "Jeso_Isao2"
};
v5.Jeso_Isao2 = {
 Text = "He fished this harbor before I\'d sold a single rod. Better than me.",
 Answers = true,
 IfTrue = "Jeso_Isao2b"
};
v5.Jeso_Isao2b = {
 Answers = true,
 IfTrue = "Jeso_Isao3",
 Text = `Better than {NameTag("Angler Runo")}, and Runo will not hear that said.`
};
v5.Jeso_Isao3 = {
 Text = "And when I did open, line was the only thing he ever bought off me.",
 Answers = true,
 IfTrue = "Jeso_Isao3b"
};
v5.Jeso_Isao3b = {
 Text = "Made his own hooks, his own lures, every piece of it.",
 Answers = true,
 IfTrue = "Jeso_Isao4"
};
v5.Jeso_Isao4 = {
 Text = "And half those nights he\'d hang none of it. Bare hook, bare line, hours of it.",
 Answers = true,
 IfTrue = "Jeso_Isao4b"
};
v5.Jeso_Isao4b = {
 Text = "Said bait was for men who wanted the fish.",
 Answers = true,
 IfTrue = "Jeso_Isao5"
};
v5.Jeso_Isao5 = {
 Text = "Every fisherman\'s got his nonsense, and his was counting.",
 Answers = true,
 IfTrue = "Jeso_Isao5b"
};
v5.Jeso_Isao5b = {
 Text = "Five casts in one spot, never a sixth. Said the sixth was greed.",
 Answers = true,
 IfTrue = "Jeso_Isao6"
};
v5.Jeso_Isao6 = {
 Text = "Something took his line one night, and he would not let go of it. That\'s the whole of it.",
 Answers = true,
 IfTrue = "Jeso_Isao7"
};
v5.Jeso_Isao7 = {
 Text = "And I\'ll not have you out on that water hunting whatever it was. Buy a worm and be sensible.",
 Answers = true
};
v5.Jeso_Successor = {
 Text = "Well now. That rod worked this water before I had a shop, and I\'d still know it anywhere.",
 Answers = {
 ["You know it?"] = "Jeso_Successor2",
 ["Got any bait?"] = "Jeso_BaitShopIntro",
 Farewell = ""
 }
};
v5.Jeso_Successor2 = {
 Text = "His own make, handle to hook. Once I opened, the only thing he ever took off my shelf was line for it.",
 Answers = true,
 IfTrue = "Jeso_Successor3"
};
v5.Jeso_Successor3 = {
 Text = "I\'ll not make a story of him this time either. But he\'d be glad it came up, and gladder who has it.",
 Answers = true
};
v5.Jeso_Price = {
 Answers = true,
 IfTrue = "Jeso_RarePitch",
 Text = `The basic one runs [3,500]<Color=(1,1,1)> [#]<img={BunchaIcons.WenRaw}>. Honest price, and I'll not budge on it.`
};
v5.Jeso_RarePitch = {
 Text = "The rare rod I\'ll not sell for coin. Any fool can buy a rod. Not every fool can fish.",
 Answers = true,
 IfTrue = "Jeso_RarePrice"
};
v5.Jeso_RarePrice = {
 Answers = 1,

 Text = function() -- Line: 224, Name: Text
 -- upvalues: Shop (copy)
 return `Land me {Shop.GetPrice("Rare Fishing Rod", true)}, and she's yours. No haggling with an old man.`;
 end
};
v5.Jeso_PurchaseSuccess = {
 Text = "She\'ll serve you well. Mind the line, and don\'t yank her.",
 Answers = 1
};
v5.Jeso_PurchaseFail = {
 Text = "Come back when the purse is heavier, young one. I\'m not going anywhere.",
 Answers = true
};
v5.Jeso_RarePurchaseSuccess = {
 Answers = 1,
 Text = `{NameTag("Golden Fish")} on my counter at last. You've earned her, young one.`
};
v5.Jeso_RarePurchaseFail = {
 Answers = true,

 Text = function() -- Line: 242, Name: Text
 -- upvalues: Shop (copy)
 return `Not yet. {Shop.GetPrice("Rare Fishing Rod", true)}, and not a fish less. I've waited longer than you have.`;
 end
};

return v5;
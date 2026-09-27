-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local v1;

if game:GetService("RunService"):IsClient() then
 v1 = require(ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.Shop);
else
 v1 = nil;
end;

local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local NameTag = require(ReplicatedStorage.CAM.Global.Utility).NameTag;
local v2 = { "Worm", "Fish Head", "Golden Tentacle x10", "Golden Tentacle x75" };
local v5 = {
 ["Baitmonger Nori"] = {
 Text = "Don\'t know you. Don\'t sell to strangers.",
 Answers = true,
 IfTrue = "Nori_Locked2",

 BeforeRun = function(p3, p4) -- Line: 34, Name: BeforeRun
 -- upvalues: Quests (copy), Players (copy)
 return Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill restock the infirmary(Lv 70)") == "Done" and "Nori_Unlocked" or nil;
 end
 },
 Nori_Locked2 = {
 Answers = true,
 IfTrue = "Nori_Locked3",
 Text = `Word travels, though. {NameTag("Shiori")} at {NameTag("Butterfly Estate")} is short on medicine.`
 },
 Nori_Locked3 = {
 Text = "Help her, and I\'ll know your name by the time you\'re back.",
 Answers = true
 },
 Nori_Unlocked = {
 Answers = true,
 IfTrue = "Nori_Shop",
 Text = `Heard what you did for {NameTag("Shiori")}. That's good enough for me.`
 }
};
local v8 = {
 Text = "Bait for every depth. Take your pick.",

 OnShow = function(p6, p7) -- Line: 60, Name: OnShow
 p7.CartShopNode = "Nori_Shop";
 end
};
local v9;

if v1 == nil then
 v9 = nil;
else
 v9 = v1(v2) or nil;
end;

v8.Content = v9;
v8.Answers = {
 ["Buy the selection"] = "ReviewCartPurchase",
 ["What\'s the Golden Tentacle?"] = "Nori_Tentacle",
 Farewell = ""
};
v5.Nori_Shop = v8;
v5.Nori_Tentacle = {
 Text = "Comes off something that lives deeper than my line goes.",
 Answers = true,
 IfTrue = "Nori_Tentacle2"
};
v5.Nori_Tentacle2 = {
 Answers = true,
 IfTrue = "Nori_Tentacle3",
 Text = `Worms and {NameTag("Fish Head")} I'll trade for Wen. That one costs more than coin.`
};
v5.Nori_Tentacle3 = {
 Answers = true,
 IfTrue = "Nori_Tentacle4",
 Text = `Or you go take them. A {NameTag("Sealed Chest")} out in the wild will be holding some.`
};
v5.Nori_Tentacle4 = {
 Text = "Sealed until whatever\'s ringed around it stops breathing. That part\'s your problem.",
 Answers = true,
 IfTrue = "Nori_Tentacle5"
};
v5.Nori_Tentacle5 = {
 Text = "Nothing marks where they sit, and they don\'t sit long. Rougher the country, the fatter the haul.",
 Answers = true,
 IfTrue = "Nori_Shop"
};

return v5;
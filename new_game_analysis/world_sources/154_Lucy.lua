-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local NameTag = require(ReplicatedStorage.CAM.Global.Utility).NameTag;

return {
 Lucy = {
 Text = "We\'re out of [meat]<Color=(1,.3,.3)>.",
 Answers = true,
 IfTrue = "Lucy_2",

 BeforeRun = function(p1, p2) -- Line: 11, Name: BeforeRun
 -- upvalues: Quests (copy), Players (copy)
 if Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill restock the pantry(Lv 10)") == "Doing" then
 return "Lucy_Delivery";
 end;
 end
 },
 Lucy_2 = {
 Text = "Could you help me restock the pantry?",
 Answers = true,
 IfTrue = "Lucy_3"
 },
 Lucy_3 = {
 Text = `Go see the hunter {NameTag("Tom")} in {NameTag("Bamboo Grove")} for some {NameTag("Bear Meat")}.`,
 Answers = {
 Close = "",
 ["Ill restock the pantry(Lv 10)"] = "AddQuest"
 }
 },
 Lucy_Delivery = {
 Text = "Got any meat? The hunters by the bamboo say the [bears]<Color=(1,.3,.3)> out there carry plenty.",
 Answers = {
 Close = "",
 ["Hand over the meat"] = "DeliverMeatToLucy"
 }
 },
 Lucy_Thanks = {
 Answers = 1,
 Text = `Thank you… These {NameTag("Cooked Bear Meat")} restore health if you're in trouble.`
 },
 Lucy_NoMeat = {
 Answers = true,
 Text = `That's... not meat. Come back when you've got some {NameTag("Bear Meat")} on you.`
 }
};
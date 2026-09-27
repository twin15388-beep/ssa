-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
require(ReplicatedStorage.CAM.Global.Types.MiscTypes);
local v1 = require(script.Parent.Parent.Parent.Parent.Parent.Npcs["Iceveil Settlement"]["Shrine Messenger Akio"]);

return {
 ["Ill see you to Windy Peak(Lv 105)"] = {
 Category = "Combat",
 Event = "Escort",
 NoSave = true,
 QuestInstance = Quests.Quest("Escort Akio to Windy Peak", { Quests.QuestTask("Fend off the ambushes", 6), Quests.QuestTask("Reach Windy Peak", 34) }),
 Rewards = {
 Exp = 2000,
 Wen = 900
 },
 Requirements = {
 Level = 105
 }
 },
 ["Ill haul in the deep catch(Lv 125)"] = {
 Category = "Fishing",
 QuestInstance = Quests.Quest("The Deep Catch", {
 Quests.QuestTask("Crustadon stocked", 5),
 Quests.QuestTask("Krathulon stocked", 5),
 Quests.QuestTask("Clown Fish stocked", 12),
 Quests.QuestTask("Return to Akio", 1)
 }),
 Rewards = {
 Exp = 4300,
 Wen = 3075
 },
 Requirements = {
 Level = 125
 },
 TaskSpecs = {
 ["Crustadon stocked"] = {
 Type = "Deposit",
 RequiredItem = "Crustadon",
 Position = Vector3.new(-114.398, 1354.044, -2520.924)
 },
 ["Krathulon stocked"] = {
 Type = "Deposit",
 RequiredItem = "Krathulon",
 Position = Vector3.new(-114.398, 1354.044, -2520.924)
 },
 ["Clown Fish stocked"] = {
 Type = "Deposit",
 RequiredItem = "Clown Fish",
 Position = Vector3.new(-114.398, 1354.044, -2520.924)
 },
 ["Return to Akio"] = {
 Type = "Deliver",
 TargetNpc = v1.Name
 }
 },
 Markers = {
 ["Krathulon stocked"] = {
 Icon = "",
 Position = Vector3.new(-114.398, 1354.044, -2520.924)
 },
 ["Return to Akio"] = {
 Npc = v1.Name,
 After = { "Crustadon stocked", "Krathulon stocked", "Clown Fish stocked" }
 }
 }
 }
};
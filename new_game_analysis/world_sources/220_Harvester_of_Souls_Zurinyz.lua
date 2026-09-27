-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
require(ReplicatedStorage.CAM.Global.Types.MiscTypes);
local ActiveNpcs = ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs;
local v1 = require(ReplicatedStorage.Ouwland.Content.Misc.Npcs["Harvester of Souls Zurinyz"]);
local NpcCode = require(ActiveNpcs["Reaper Trainee"]).SendOver.Settings.NpcCode;

return {
 ["Ill learn the Reaping Blades Style(Lv 100)"] = {
 Category = "Combat",
 WenCostOnAccept = 15000,
 OfferNpc = v1.Name,
 QuestInstance = Quests.Quest("The Reaper\'s Trial", {
 Quests.QuestTask("Common Fish", 20),
 Quests.QuestTask("Reaper Scroll", 1),
 Quests.QuestTask("Land 12,000 fist M1 damage", 12000, "FistM1Damage"),
 Quests.QuestTask("Defeat the Reaper Trainee", 1, NpcCode)
 }),
 Rewards = {
 Exp = 3600,
 Wen = 1620,
 Power = {
 Name = "Reaping Blades",
 GrantNotify = {
 Text = "The Reaping Blades are yours. Reap cleanly.",
 Npc = v1.Name
 }
 }
 },
 Requirements = {
 Level = 100,
 Race = { "Demon", "Hybrid" }
 },
 ItemCostOnAccept = {
 ["Demon Horns"] = 20
 },
 TaskSpecs = {
 ["Common Fish"] = {
 Type = "DeliverAny",
 Hint = "Only fish handed to Zurinyz count. Bring the catch back.",
 RequiredItems = { "OuwFish", "Sea Horse", "Coral", "OuwFwesh" },
 TargetNpc = v1.Name
 },
 ["Reaper Scroll"] = {
 Type = "Pickup",
 Hint = "In the lake beneath the falls, on the road to the bamboo sanctuary",
 Positions = { Vector3.new(594.094, 974.151, -589.813) }
 },
 ["Defeat the Reaper Trainee"] = {
 Hint = "A cave where small blue caps grow on the rock and snow"
 }
 }
 }
};
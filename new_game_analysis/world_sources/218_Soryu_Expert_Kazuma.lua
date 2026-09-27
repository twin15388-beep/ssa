-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
require(ReplicatedStorage.CAM.Global.Types.MiscTypes);
local ActiveNpcs = ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs;
local v1 = require(ReplicatedStorage.Ouwland.Content.Misc.Npcs["Soryu Expert Kazuma"]);
local NpcCode = require(ActiveNpcs["Soryu Trainee"]).SendOver.Settings.NpcCode;

return {
 ["Ill learn the Soryu Style(Lv 62)"] = {
 Category = "Combat",
 WenCostOnAccept = 8000,
 OfferNpc = v1.Name,
 QuestInstance = Quests.Quest("The Soryu Trial", {
 Quests.QuestTask("Common Fish", 20),
 Quests.QuestTask("Soryu Scroll", 1),
 Quests.QuestTask("Land 8,000 fist M1 damage", 8000, "FistM1Damage"),
 Quests.QuestTask("Defeat the Soryu Trainee", 1, NpcCode)
 }),
 Rewards = {
 Exp = 2232,
 Wen = 1004,
 Power = {
 Name = "Soryu",
 GrantNotify = {
 Text = "Soryu is yours now. Do not make me regret it.",
 Npc = v1.Name
 }
 }
 },
 Requirements = {
 Level = 62,
 Race = { "Demon", "Hybrid" }
 },
 ItemCostOnAccept = {
 ["Demon Horns"] = 12
 },
 TaskSpecs = {
 ["Common Fish"] = {
 Type = "DeliverAny",
 Hint = "Only fish handed to Kazuma count. Bring the catch back.",
 RequiredItems = { "OuwFish", "Sea Horse", "Coral", "OuwFwesh" },
 TargetNpc = v1.Name
 },
 ["Soryu Scroll"] = {
 Type = "Pickup",
 Hint = "In the flooded cave under Kazuma\'s feet",
 Positions = { Vector3.new(-663.656, 745.75, 114.442) }
 },
 ["Defeat the Soryu Trainee"] = {
 Hint = "In the cave the waterfall hides"
 }
 }
 }
};
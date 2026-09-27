-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
require(ReplicatedStorage.CAM.Global.Types.MiscTypes);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local ActiveNpcs = ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs;
local v1 = require(ReplicatedStorage.Ouwland.Content.Misc.Npcs["Stone Trainer"]);
local v2 = require(ActiveNpcs["Stone Trainee"]);
local NpcCode = v2.SendOver.Settings.NpcCode;
local v3 = {
 CompletionNotify = {
 Npc = v1.Name,
 Text = gameSettings.TrainerCompliments
 }
};

return {
 ["Ill learn Stone Breathing(Lv 25)"] = {
 Category = "Combat",
 WenCostOnAccept = 4000,
 OfferNpc = v1.Name,
 QuestInstance = Quests.Quest("Stone Breathing Training", {
 Quests.QuestTask("Meditate", 1, "Meditation"),
 Quests.QuestTask("Push ups", 1, "Pushups", "Meditate"),
 Quests.QuestTask("Boulder Push", 1, nil, "Push ups"),
 Quests.QuestTask("Boulder Split", 1, nil, "Boulder Push"),
 Quests.QuestTask("Parkour Dungeon", 1, nil, "Boulder Split"),
 Quests.QuestTask("Defeat the Stone Trainee", 1, NpcCode, "Parkour Dungeon")
 }),
 Rewards = {
 Exp = 900,
 Wen = 405,
 Power = "Stone"
 },
 Requirements = {
 Level = 25,
 Items = { "Axe and Mace", "Seismic Axe and Mace", "Nightfall Axe and Mace" }
 },
 ItemCostOnAccept = {
 ["Beast Core"] = 4
 },
 CompletionNotify = {
 Text = "You stood against my student and did not waver. That stillness is the true weight of Stone Breathing.",
 Npc = v1.Name
 },
 TaskSpecs = {
 Meditate = v3,
 ["Push ups"] = v3,
 ["Boulder Push"] = v3,
 ["Boulder Split"] = v3,
 ["Parkour Dungeon"] = {
 Type = "Dungeon",
 Dungeon = "Parkour Dungeon",
 Stage = "Complete",
 CompletionNotify = v3.CompletionNotify
 }
 },
 Markers = {
 ["Defeat the Stone Trainee"] = {
 Icon = "",
 Position = v2.SendOver.Spawning.Locations[1] + Vector3.new(0, 3, 0)
 }
 }
 }
};
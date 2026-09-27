-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
require(ReplicatedStorage.CAM.Global.Types.MiscTypes);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local ActiveNpcs = ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs;
local v1 = require(ReplicatedStorage.Ouwland.Content.Misc.Npcs["Flame Trainer"]);
local v2 = require(ActiveNpcs["Flame Trainee"]);
local NpcCode = v2.SendOver.Settings.NpcCode;
local v3 = {
 CompletionNotify = {
 Npc = v1.Name,
 Text = gameSettings.TrainerCompliments
 }
};

return {
 ["Ill learn Flame Breathing(Lv 25)"] = {
 Category = "Combat",
 WenCostOnAccept = 6000,
 OfferNpc = v1.Name,
 QuestInstance = Quests.Quest("Flame Breathing Training", {
 Quests.QuestTask("Meditate", 1, "Meditation"),
 Quests.QuestTask("Push ups", 1, "Pushups", "Meditate"),
 Quests.QuestTask("Boulder Split", 1, nil, "Push ups"),
 Quests.QuestTask("Aim Training", 1, "Target Shooting", "Boulder Split"),
 Quests.QuestTask("Cup Training", 1, "Cup Game", "Aim Training"),
 Quests.QuestTask("Defeat the Flame Trainee", 1, NpcCode, "Cup Training")
 }),
 Rewards = {
 Exp = 900,
 Wen = 405,
 Power = "Flame"
 },
 Requirements = {
 Level = 25
 },
 ItemCostOnAccept = {
 ["Demon Horns"] = 10
 },
 CompletionNotify = {
 Text = "Magnificent! That is the heart of Flame Breathing.",
 Npc = v1.Name
 },
 TaskSpecs = {
 Meditate = v3,
 ["Push ups"] = v3,
 ["Boulder Split"] = v3,
 ["Aim Training"] = v3,
 ["Cup Training"] = v3
 },
 Markers = {
 ["Defeat the Flame Trainee"] = {
 Icon = "",
 Position = v2.SendOver.Spawning.Locations[1] + Vector3.new(0, 3, 0)
 }
 }
 }
};
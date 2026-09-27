-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
require(ReplicatedStorage.CAM.Global.Types.MiscTypes);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local ActiveNpcs = ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs;
local v1 = require(ReplicatedStorage.Ouwland.Content.Misc.Npcs["Insect Trainer"]);
local v2 = require(ActiveNpcs["Insect Trainee"]);
local NpcCode = v2.SendOver.Settings.NpcCode;
local v3 = {
 CompletionNotify = {
 Npc = v1.Name,
 Text = gameSettings.TrainerCompliments
 }
};

return {
 ["Ill learn Insect Breathing(Lv 25)"] = {
 Category = "Combat",
 WenCostOnAccept = 3500,
 OfferNpc = v1.Name,
 QuestInstance = Quests.Quest("Insect Breathing Training", {
 Quests.QuestTask("Meditate", 1, "Meditation"),
 Quests.QuestTask("Aim Training", 1, "Target Shooting", "Meditate"),
 Quests.QuestTask("Cup Training", 1, "Cup Game", "Aim Training"),
 Quests.QuestTask("Push ups", 1, "Pushups", "Cup Training"),
 Quests.QuestTask("Boulder Split", 1, nil, "Push ups"),
 Quests.QuestTask("Defeat the Insect Trainee", 1, NpcCode, "Boulder Split")
 }),
 Rewards = {
 Exp = 900,
 Wen = 405,
 Power = "Insect"
 },
 Requirements = {
 Level = 25
 },
 ItemCostOnAccept = {
 ["Demon Horns"] = 15,
 ["Beast Core"] = 3
 },
 CompletionNotify = {
 Text = "My my, you really did it. Deadly, and never once looking like it. Welcome to the club.",
 Npc = v1.Name
 },
 TaskSpecs = {
 Meditate = v3,
 ["Aim Training"] = v3,
 ["Cup Training"] = v3,
 ["Push ups"] = v3,
 ["Boulder Split"] = v3
 },
 Markers = {
 ["Defeat the Insect Trainee"] = {
 Icon = "",
 Position = v2.SendOver.Spawning.Locations[1] + Vector3.new(0, 3, 0)
 }
 }
 }
};
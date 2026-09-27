-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
require(ReplicatedStorage.CAM.Global.Types.MiscTypes);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local ActiveNpcs = ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs;
local v1 = require(ReplicatedStorage.Ouwland.Content.Misc.Npcs["Serpent Trainer"]);
local v2 = require(ActiveNpcs["Serpent Trainee"]);
local NpcCode = v2.SendOver.Settings.NpcCode;
local v3 = {
 CompletionNotify = {
 Npc = v1.Name,
 Text = gameSettings.TrainerCompliments
 }
};

return {
 ["Ill learn Serpent Breathing(Lv 25)"] = {
 Category = "Combat",
 WenCostOnAccept = 1000,
 OfferNpc = v1.Name,
 QuestInstance = Quests.Quest("Serpent Breathing Training", {
 Quests.QuestTask("Meditate", 1, "Meditation"),
 Quests.QuestTask("Push ups", 1, "Pushups", "Meditate"),
 Quests.QuestTask("Boulder Split", 1, nil, "Push ups"),
 Quests.QuestTask("Boulder Push", 1, nil, "Boulder Split"),
 Quests.QuestTask("Aim Training", 1, "Target Shooting", "Boulder Push"),
 Quests.QuestTask("Defeat the Serpent Trainee", 1, NpcCode, "Aim Training")
 }),
 Rewards = {
 Exp = 900,
 Wen = 405,
 Power = "Serpent"
 },
 Requirements = {
 Level = 25
 },
 ItemCostOnAccept = {
 ["Demon Horns"] = 20,
 ["Beast Core"] = 5
 },
 CompletionNotify = {
 Text = "You struck without hesitation, and without wasting a single movement. You have earned my respect.",
 Npc = v1.Name
 },
 TaskSpecs = {
 Meditate = v3,
 ["Push ups"] = v3,
 ["Boulder Split"] = v3,
 ["Boulder Push"] = v3,
 ["Aim Training"] = v3
 },
 Markers = {
 ["Defeat the Serpent Trainee"] = {
 Icon = "",
 Position = v2.SendOver.Spawning.Locations[1] + Vector3.new(0, 3, 0)
 }
 }
 }
};
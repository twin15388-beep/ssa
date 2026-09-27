-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
require(ReplicatedStorage.CAM.Global.Types.MiscTypes);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local ActiveNpcs = ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs;
local v1 = require(ReplicatedStorage.Ouwland.Content.Misc.Npcs["Wind Trainer"]);
local v2 = require(ActiveNpcs["Wind Trainee"]);
local NpcCode = v2.SendOver.Settings.NpcCode;
local v3 = {
 CompletionNotify = {
 Npc = v1.Name,
 Text = gameSettings.TrainerCompliments
 }
};

return {
 ["Ill learn Wind Breathing(Lv 25)"] = {
 Category = "Combat",
 WenCostOnAccept = 3000,
 OfferNpc = v1.Name,
 QuestInstance = Quests.Quest("Wind Breathing Training", {
 Quests.QuestTask("Push ups", 1, "Pushups"),
 Quests.QuestTask("Boulder Split", 1, nil, "Push ups"),
 Quests.QuestTask("Boulder Push", 1, nil, "Boulder Split"),
 Quests.QuestTask("Aim Training", 1, "Target Shooting", "Boulder Push"),
 Quests.QuestTask("Meditate", 1, "Meditation", "Aim Training"),
 Quests.QuestTask("Defeat the Wind Trainee", 1, NpcCode, "Meditate")
 }),
 Rewards = {
 Exp = 900,
 Wen = 405,
 Power = "Wind"
 },
 Requirements = {
 Level = 25
 },
 ItemCostOnAccept = {
 ["Demon Horns"] = 50
 },
 CompletionNotify = {
 Text = "Hah. You did not hold back. That is Wind Breathing: a storm that does not stop.",
 Npc = v1.Name
 },
 TaskSpecs = {
 ["Push ups"] = v3,
 ["Boulder Split"] = v3,
 ["Boulder Push"] = v3,
 ["Aim Training"] = v3,
 Meditate = v3
 },
 Markers = {
 ["Defeat the Wind Trainee"] = {
 Icon = "",
 Position = v2.SendOver.Spawning.Locations[1] + Vector3.new(0, 3, 0)
 }
 }
 }
};
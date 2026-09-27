-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
require(ReplicatedStorage.CAM.Global.Types.MiscTypes);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local ActiveNpcs = ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs;
local v1 = require(ReplicatedStorage.Ouwland.Content.Misc.Npcs["Water Trainer"]);
local v2 = require(ActiveNpcs["Water Trainee"]);
local NpcCode = v2.SendOver.Settings.NpcCode;
local v3 = {
 CompletionNotify = {
 Npc = v1.Name,
 Text = gameSettings.TrainerCompliments
 }
};
local v4 = gameSettings.UnderwaterRockSpots[game.PlaceId];

return {
 ["Ill learn Water Breathing(Lv 25)"] = {
 Category = "Combat",
 WenCostOnAccept = 5000,
 OfferNpc = v1.Name,
 QuestInstance = Quests.Quest("Water Breathing Training", {
 Quests.QuestTask("Parkour Dungeon", 1),
 Quests.QuestTask("Push ups", 1, "Pushups", "Parkour Dungeon"),
 Quests.QuestTask("Boulder Push", 1, nil, "Push ups"),
 Quests.QuestTask("Aim Training", 1, "Target Shooting", "Boulder Push"),
 Quests.QuestTask("Underwater Rocks", #v4, nil, "Aim Training"),
 Quests.QuestTask("Defeat the Water Trainee", 1, NpcCode, "Underwater Rocks")
 }),
 Rewards = {
 Exp = 900,
 Wen = 405,
 Power = "Water"
 },
 Requirements = {
 Level = 25
 },
 ItemCostOnAccept = {
 ["Demon Horns"] = 30
 },
 CompletionNotify = {
 Text = "You beat Sabito. Water finds its way through anything, and so did you.",
 Npc = v1.Name
 },
 TaskSpecs = {
 ["Parkour Dungeon"] = {
 Type = "Dungeon",
 Dungeon = "Parkour Dungeon",
 Stage = "Complete",
 CompletionNotify = v3.CompletionNotify
 },
 ["Push ups"] = v3,
 ["Boulder Push"] = v3,
 ["Aim Training"] = v3,
 ["Underwater Rocks"] = {
 Type = "Pickup",
 Positions = v4,
 CompletionNotify = v3.CompletionNotify
 }
 },
 Markers = {
 ["Defeat the Water Trainee"] = {
 Icon = "",
 Position = v2.SendOver.Spawning.Locations[1] + Vector3.new(0, 3, 0)
 }
 }
 }
};
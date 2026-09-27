-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
require(ReplicatedStorage.CAM.Global.Types.MiscTypes);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local ActiveNpcs = ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs;
local v1 = require(ReplicatedStorage.Ouwland.Content.Misc.Npcs["Sound Trainer"]);
local v2 = require(ActiveNpcs["Sound Trainee"]);
local NpcCode = v2.SendOver.Settings.NpcCode;
local v3 = {
 CompletionNotify = {
 Npc = v1.Name,
 Text = gameSettings.TrainerCompliments
 }
};
local v4 = gameSettings.UnderwaterRockSpots[game.PlaceId];

return {
 ["Ill learn Sound Breathing(Lv 25)"] = {
 Category = "Combat",
 WenCostOnAccept = 4000,
 OfferNpc = v1.Name,
 QuestInstance = Quests.Quest("Sound Breathing Training", {
 Quests.QuestTask("Push ups", 1, "Pushups"),
 Quests.QuestTask("Barbell squats", 1, "Squat", "Push ups"),
 Quests.QuestTask("Boulder Split", 1, nil, "Barbell squats"),
 Quests.QuestTask("Cup Training", 1, "Cup Game", "Boulder Split"),
 Quests.QuestTask("Underwater Rocks", #v4, nil, "Cup Training"),
 Quests.QuestTask("Defeat the Sound Trainee", 1, NpcCode, "Underwater Rocks")
 }),
 Rewards = {
 Exp = 900,
 Wen = 405,
 Power = "Sound"
 },
 Requirements = {
 Level = 25
 },
 ItemCostOnAccept = {
 ["Demon Horns"] = 10,
 ["Beast Core"] = 3
 },
 CompletionNotify = {
 Text = "MAGNIFICENT! An explosive finish! Flashy is non negotiable from here on out.",
 Npc = v1.Name
 },
 TaskSpecs = {
 ["Push ups"] = v3,
 ["Barbell squats"] = v3,
 ["Boulder Split"] = v3,
 ["Cup Training"] = v3,
 ["Underwater Rocks"] = {
 Type = "Pickup",
 Positions = v4,
 CompletionNotify = v3.CompletionNotify
 }
 },
 Markers = {
 ["Defeat the Sound Trainee"] = {
 Icon = "",
 Position = v2.SendOver.Spawning.Locations[1] + Vector3.new(0, 3, 0)
 }
 }
 }
};
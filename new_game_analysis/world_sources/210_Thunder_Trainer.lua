-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
require(ReplicatedStorage.CAM.Global.Types.MiscTypes);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local ActiveNpcs = ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs;
local v1 = require(ReplicatedStorage.Ouwland.Content.Misc.Npcs["Thunder Trainer"]);
local v2 = require(ActiveNpcs["Thunder Trainee"]);
local NpcCode = v2.SendOver.Settings.NpcCode;
local v3 = {
 CompletionNotify = {
 Npc = v1.Name,
 Text = gameSettings.TrainerCompliments
 }
};

return {
 ["Ill learn Thunder Breathing(Lv 25)"] = {
 Category = "Combat",
 WenCostOnAccept = 7000,
 OfferNpc = v1.Name,
 QuestInstance = Quests.Quest("Thunder Breathing Training", {
 Quests.QuestTask("Meditate", 1, "Meditation"),
 Quests.QuestTask("Cup Training", 1, "Cup Game", "Meditate"),
 Quests.QuestTask("Push ups", 1, "Pushups", "Cup Training"),
 Quests.QuestTask("Aim Training", 1, "Target Shooting", "Push ups"),
 Quests.QuestTask("Boulder Split", 1, nil, "Aim Training"),
 Quests.QuestTask("Defeat the Thunder Trainee", 1, NpcCode, "Boulder Split")
 }),
 Rewards = {
 Exp = 900,
 Wen = 405,
 Power = "Thunder"
 },
 Requirements = {
 Level = 25
 },
 ItemCostOnAccept = {
 ["Demon Horns"] = 10
 },
 CompletionNotify = {
 Text = "Y-YOU DID IT?! One clean strike, no hesitation.",
 Npc = v1.Name
 },
 TaskSpecs = {
 Meditate = v3,
 ["Cup Training"] = v3,
 ["Push ups"] = v3,
 ["Aim Training"] = v3,
 ["Boulder Split"] = v3
 },
 Markers = {
 ["Defeat the Thunder Trainee"] = {
 Icon = "",
 Position = v2.SendOver.Spawning.Locations[1] + Vector3.new(0, 3, 0)
 }
 }
 }
};
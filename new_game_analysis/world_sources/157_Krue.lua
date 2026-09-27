-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local BanditSettings = require(ReplicatedStorage.Ouwland.Content["Windy Peak"].NpcShared.BanditSettings);
require(ReplicatedStorage.CAM.Global.Types.MiscTypes);

return {
 ["Ill take 3 bandits"] = {
 Category = "Combat",
 Position = Vector3.new(-296.759, 1226.214, -1025.3597),
 QuestInstance = Quests.Quest("Defeat 3 bandits", Quests.QuestTask("Bandits remaining", 3, BanditSettings.Settings.NpcCode)),
 Rewards = {
 Exp = 25,
 Wen = 12
 }
 },
 ["Ill take the bandit boss(Lv 7)"] = {
 Category = "Combat",
 Position = Vector3.new(-296.759, 1226.214, -1025.359),
 QuestInstance = Quests.Quest("Defeat The Bandit Boss", Quests.QuestTask("Defeat Zuko", 1, "Zuko")),
 Rewards = {
 Exp = 168,
 Wen = 76
 },
 Requirements = {
 Level = 7
 }
 }
};
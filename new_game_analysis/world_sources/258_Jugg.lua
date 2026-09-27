-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
require(ReplicatedStorage.CAM.Global.Types.MiscTypes);
local BloodHoundedDemonSettings = require(script.Parent.Parent.Parent.Parent.Parent.NpcShared.BloodHoundedDemonSettings);

return {
 ["Ill clear the cave(Lv 62)"] = {
 Category = "Combat",
 QuestInstance = Quests.Quest("Purge Dreamfall Hollow", Quests.QuestTask("Blood Hounded Demons defeated", 7, BloodHoundedDemonSettings.Settings.NpcCode)),
 Rewards = {
 Exp = 1116,
 Wen = 502
 },
 Requirements = {
 Level = 62,
 Race = { "Slayer", "Hybrid" }
 },
 CompletionNotify = {
 Npc = "Jugg",
 Text = "You\'ve done us a great service. Please, take this reward."
 },
 Markers = {
 ["Blood Hounded Demons defeated"] = {
 Icon = "",
 Position = BloodHoundedDemonSettings.Center + Vector3.new(0, 15, 0)
 }
 }
 }
};
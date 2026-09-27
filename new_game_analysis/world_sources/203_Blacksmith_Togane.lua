-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
require(ReplicatedStorage.CAM.Global.Types.MiscTypes);
local Combat = BunchaIcons.Combat;

return {
 ["Ill find the forge(Lv 65)"] = {
 Category = "Dialogue",
 LogCompletion = true,
 QuestInstance = Quests.Quest("The Forge Above", Quests.QuestTask("Ouwigahara portal opened", 1)),
 Rewards = {
 Exp = 3900,
 Wen = 350
 },
 Requirements = {
 Level = 65
 },
 TaskSpecs = {
 ["Ouwigahara portal opened"] = {
 Type = "Dungeon",
 Dungeon = "Ouwigahara",
 Stage = "Enter"
 }
 },
 Markers = {
 ["Ouwigahara portal opened"] = {
 Position = Vector3.new(-1605.633, 1014.179, 1142.769),
 Icon = Combat
 }
 }
 }
};
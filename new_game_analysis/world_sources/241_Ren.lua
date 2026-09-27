-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
require(ReplicatedStorage.CAM.Global.Types.MiscTypes);

return {
 ["Ill look for your blade(Lv 75)"] = {
 Category = "Dialogue",
 LogCompletion = true,
 QuestInstance = Quests.Quest("Locate Ren\'s Lost Nichirin", { Quests.QuestTask("Nichirin Blade found", 1), Quests.QuestTask("Return to Ren", 1, nil, "Nichirin Blade found") }),
 Rewards = {
 Exp = 4500,
 Wen = 495
 },
 Requirements = {
 Level = 75
 },
 Markers = {
 ["Return to Ren"] = {
 Npc = "Ren"
 }
 },
 TaskSpecs = {
 ["Nichirin Blade found"] = {
 Type = "Pickup",
 MaxDistance = 25,
 Positions = { Vector3.new(-1040.337, 214.035, 588.187) }
 },
 ["Return to Ren"] = {
 Type = "Deliver",
 TargetNpc = "Ren"
 }
 }
 }
};
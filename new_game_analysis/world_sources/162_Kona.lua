-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
require(ReplicatedStorage.CAM.Global.Types.MiscTypes);

return {
 ["Ill find the pages"] = {
 Category = "Dialogue",
 QuestInstance = Quests.Quest("Recover the Lost Pages", Quests.QuestTask("Lost Pages", 5)),
 Rewards = {
 Exp = 20,
 Wen = 10,
 ["Book of Guidance"] = {
 Quantity = 1,
 Unique = true
 }
 },
 CompletionNotify = {
 Npc = "Kona",
 Text = "You found them... The Book of Guidance is yours.",
 Duration = 4
 },
 TaskSpecs = {
 ["Lost Pages"] = {
 Type = "Pickup",
 MaxDistance = 25,
 Positions = { Vector3.new(-726.984, 1243.199, -939.239), Vector3.new(-738, 1258.5, -1264), Vector3.new(-452.039, 1241, -927.139), Vector3.new(-676.415, 1243.399, -1139.289), Vector3.new(-540.68, 1241.31, -928.901) }
 }
 }
 }
};
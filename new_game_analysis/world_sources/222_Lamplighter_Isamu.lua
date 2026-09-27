-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);

return {
 ["Ill walk the order"] = {
 Category = "Dialogue",
 LogCompletion = true,
 NoSave = true,
 Position = Vector3.new(1079, 1422, -781),
 QuestInstance = Quests.Quest("The Plate Trial", Quests.QuestTask("Rounds", 5)),
 Rewards = {
 ["Firstlight Lantern Schematic"] = {
 Quantity = 1
 }
 },
 CompletionNotify = {
 Npc = "Lamplighter Isamu",
 Text = "Every plate, in its order. The drawings are yours."
 }
 }
};
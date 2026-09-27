-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
require(ReplicatedStorage.CAM.Global.Types.MiscTypes);

return {
 ["Ill look for it(Lv 10)"] = {
 Category = "Dialogue",
 LogCompletion = true,
 QuestInstance = Quests.Quest("Find Betty\'s Gemstone", Quests.QuestTask("Gemstone found", 1)),
 Rewards = {
 Exp = 600,
 Wen = 60
 },
 Requirements = {
 Level = 10
 },
 CompletionNotify = {
 Npc = "Betty",
 Text = "You found it! Thank you for bringing it back!"
 },
 TaskSpecs = {
 ["Gemstone found"] = {
 Type = "Pickup",
 MaxDistance = 25,
 Positions = { Vector3.new(682.763, 973.362, -504.465) }
 }
 },
 MarkerData = {
 img = "rbxassetid://127721943897846",
 minDistance = 35,
 margin = 10,
 useName = "Betty-AddedByAreaLocator"
 }
 }
};
-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
require(ReplicatedStorage.CAM.Global.Types.MiscTypes);

return {
 ["Ill help clear them out"] = {
 Category = "Combat",
 NextQuest = "Ill bring him the notes",
 Hint = "They pass for villagers. Nothing will point them out for you.",
 QuestInstance = Quests.Quest("Clear the Village Spies", Quests.QuestTask("Spies remaining", 4, "VillageSpy")),
 Rewards = {
 Exp = 40,
 Wen = 20,
 ["Suspicious Note"] = {
 Quantity = 1,
 Unique = true,
 NoSave = true
 }
 },
 CompletionNotify = {
 Npc = "Kazu",
 Text = "Go see Noote."
 }
 },
 ["Ill bring him the notes"] = {
 Category = "Dialogue",
 NoSave = true,
 LogCompletion = true,
 QuestInstance = Quests.Quest("Report to Noote", Quests.QuestTask("Speak with Noote", 1)),
 TaskSpecs = {
 ["Speak with Noote"] = {
 Type = "Deliver",
 TargetNpc = "Noote"
 }
 },
 MarkerData = {
 img = "rbxassetid://127721943897846",
 minDistance = 35,
 margin = 10,
 useName = "Noote-AddedByAreaLocator"
 }
 }
};
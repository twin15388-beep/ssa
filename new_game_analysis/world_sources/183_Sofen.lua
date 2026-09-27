-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
require(ReplicatedStorage.CAM.Global.Types.MiscTypes);
local Sofen = require(script.Parent.Parent.Parent.Parent.Npcs.Sofen);

return {
 ["Ill find the permit stamp(Lv 45)"] = {
 Category = "Fishing",
 WenCostOnAccept = 5000,
 Hint = "The stamp was left somewhere around the docks.",
 LogCompletion = true,
 QuestInstance = Quests.Quest("Earn a Fishing Permit", { Quests.QuestTask("Permit Stamp found", 1), Quests.QuestTask("Return to Sofen", 1) }),
 OfferNpc = Sofen.Name,
 Rewards = {
 Exp = 2700,
 ["Fishing Permit"] = {
 Quantity = 1
 }
 },
 Requirements = {
 Level = 45
 },
 TaskSpecs = {
 ["Permit Stamp found"] = {
 Type = "Pickup",
 MaxDistance = 25,
 GrantItem = "Permit Stamp",
 Positions = { Vector3.new(-449.76, 800.362, 750.014) },
 CompletionNotify = {
 Text = "That\'s the one. Bring it here.",
 Npc = Sofen.Name
 }
 },
 ["Return to Sofen"] = {
 Type = "Deliver",
 RequiredItem = "Permit Stamp",
 TargetNpc = Sofen.Name
 }
 },
 Markers = {
 ["Return to Sofen"] = {
 Npc = Sofen.Name,
 After = { "Permit Stamp found" }
 }
 }
 }
};
-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
require(ReplicatedStorage.CAM.Global.Types.MiscTypes);

return {
 ["Ill fill your crates(Lv 45)"] = {
 Category = "Fishing",
 QuestInstance = Quests.Quest("The Morning Haul", {
 Quests.QuestTask("OuwFish crated", 2),
 Quests.QuestTask("Sea Horse crated", 2),
 Quests.QuestTask("Coral crated", 2),
 Quests.QuestTask("OuwFwesh crated", 2),
 Quests.QuestTask("Return to Runo", 1)
 }),
 Rewards = {
 Exp = 1750,
 Wen = 790
 },
 Requirements = {
 Level = 45
 },
 TaskSpecs = {
 ["OuwFish crated"] = {
 Type = "Deposit",
 RequiredItem = "OuwFish",
 Position = Vector3.new(-574.2888, 799.6649, 681.69305)
 },
 ["Sea Horse crated"] = {
 Type = "Deposit",
 RequiredItem = "Sea Horse",
 Position = Vector3.new(-574.2888, 799.6649, 681.69305)
 },
 ["Coral crated"] = {
 Type = "Deposit",
 RequiredItem = "Coral",
 Position = Vector3.new(-574.2888, 799.6649, 681.69305)
 },
 ["OuwFwesh crated"] = {
 Type = "Deposit",
 RequiredItem = "OuwFwesh",
 Position = Vector3.new(-574.2888, 799.6649, 681.69305)
 },
 ["Return to Runo"] = {
 Type = "Deliver",
 TargetNpc = "Angler Runo"
 }
 },
 Markers = {
 ["OuwFwesh crated"] = {
 Icon = "",
 Position = Vector3.new(-574.2888, 799.6649, 681.69305)
 },
 ["Return to Runo"] = {
 Npc = "Angler Runo",
 After = { "OuwFish crated", "Sea Horse crated", "Coral crated", "OuwFwesh crated" }
 }
 }
 },
 ["Ill land the good catch(Lv 60)"] = {
 Category = "Fishing",
 QuestInstance = Quests.Quest("The Good Catch", {
 Quests.QuestTask("OuwFish crated", 3),
 Quests.QuestTask("Sea Horse crated", 3),
 Quests.QuestTask("Coral crated", 3),
 Quests.QuestTask("OuwFwesh crated", 3),
 Quests.QuestTask("Clown Fish crated", 1),
 Quests.QuestTask("Zebra Fish crated", 1),
 Quests.QuestTask("Return to Runo", 1)
 }),
 Rewards = {
 Exp = 2300,
 Wen = 1035
 },
 Requirements = {
 Level = 60
 },
 TaskSpecs = {
 ["OuwFish crated"] = {
 Type = "Deposit",
 RequiredItem = "OuwFish",
 Position = Vector3.new(-574.2888, 799.6649, 681.69305)
 },
 ["Sea Horse crated"] = {
 Type = "Deposit",
 RequiredItem = "Sea Horse",
 Position = Vector3.new(-574.2888, 799.6649, 681.69305)
 },
 ["Coral crated"] = {
 Type = "Deposit",
 RequiredItem = "Coral",
 Position = Vector3.new(-574.2888, 799.6649, 681.69305)
 },
 ["OuwFwesh crated"] = {
 Type = "Deposit",
 RequiredItem = "OuwFwesh",
 Position = Vector3.new(-574.2888, 799.6649, 681.69305)
 },
 ["Clown Fish crated"] = {
 Type = "Deposit",
 RequiredItem = "Clown Fish",
 Position = Vector3.new(-574.2888, 799.6649, 681.69305)
 },
 ["Zebra Fish crated"] = {
 Type = "Deposit",
 RequiredItem = "Zebra Fish",
 Position = Vector3.new(-574.2888, 799.6649, 681.69305)
 },
 ["Return to Runo"] = {
 Type = "Deliver",
 TargetNpc = "Angler Runo"
 }
 },
 Markers = {
 ["Zebra Fish crated"] = {
 Icon = "",
 Position = Vector3.new(-574.2888, 799.6649, 681.69305)
 },
 ["Return to Runo"] = {
 Npc = "Angler Runo",
 After = { "OuwFish crated", "Sea Horse crated", "Coral crated", "OuwFwesh crated", "Clown Fish crated", "Zebra Fish crated" }
 }
 }
 }
};
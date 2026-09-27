-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
require(ReplicatedStorage.CAM.Global.Types.MiscTypes);
local ActiveNpcs = ReplicatedStorage.Ouwland.Content.Misc.ActiveNpcs;
local v1 = require(ReplicatedStorage.Ouwland.Content.Misc.Npcs["Tai Chi Expert Renjiro"]);
local NpcCode = require(ActiveNpcs["Tai Chi Trainee"]).SendOver.Settings.NpcCode;

return {
 ["Ill learn the Tai Chi Style(Lv 65)"] = {
 Category = "Combat",
 WenCostOnAccept = 9000,
 OfferNpc = v1.Name,
 QuestInstance = Quests.Quest("The Tai Chi Trial", {
 Quests.QuestTask("Common Fish", 20),
 Quests.QuestTask("Tai Chi Scroll", 1),
 Quests.QuestTask("Land 8,000 fist M1 damage", 8000, "FistM1Damage"),
 Quests.QuestTask("Defeat the Tai Chi Trainee", 1, NpcCode)
 }),
 Rewards = {
 Exp = 2340,
 Wen = 1053,
 Power = {
 Name = "Tai Chi",
 GrantNotify = {
 Text = "Tai Chi is yours. Softness first, the rest follows.",
 Npc = v1.Name
 }
 }
 },
 Requirements = {
 Level = 65,
 Race = { "Slayer", "Hybrid" }
 },
 ItemCostOnAccept = {
 ["Beast Core"] = 5
 },
 TaskSpecs = {
 ["Common Fish"] = {
 Type = "DeliverAny",
 Hint = "Only fish handed to Renjiro count. Bring the catch back.",
 RequiredItems = { "OuwFish", "Sea Horse", "Coral", "OuwFwesh" },
 TargetNpc = v1.Name
 },
 ["Tai Chi Scroll"] = {
 Type = "Pickup",
 Hint = "Deep in the water below Renjiro",
 Positions = { Vector3.new(1989.166, 534.405, -645.663) }
 },
 ["Defeat the Tai Chi Trainee"] = {
 Hint = "In a hidden cave beneath the Stone Hashira\'s retirement home"
 }
 }
 }
};
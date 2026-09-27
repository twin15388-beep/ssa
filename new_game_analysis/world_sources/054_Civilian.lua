-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Menum = require(ReplicatedStorage.CAM.Global.Menum);
require(ReplicatedStorage.CAM.Global.Types.NpcTypes);
local CivilianSettings = require(script.Parent.Parent:WaitForChild("NpcShared"):WaitForChild("CivilianSettings"));

return {
 Name = "Civilian",
 Quantity = 9,
 Type = Menum.npcType.Active,
 SendOver = {
 Profile = "Civilian",
 Spawning = {
 Locations = CivilianSettings.Points,
 SpawnTime = CivilianSettings.SpawnTime,
 DespawnDistance = CivilianSettings.DespawnDistance,
 Center = CivilianSettings.Center,
 Appearance = ReplicatedStorage.Assets.Npcs.Civilians:GetChildren()
 },
 Idling = {
 Enabled = true,
 Positions = CivilianSettings.Points
 },
 Flee = {
 FleeOnHit = true,
 FleeOnNearby = true,
 FleeDuration = 3,
 FleeDistance = 15,
 FleeRequirements = {
 OnHit = {
 Player = {},
 Npc = {
 NearbyNpcTags = { "BeastBorn" },
 NearbyNpcRegions = { "Mistfall Harbor" }
 }
 },
 OnNearby = {
 Npc = {
 NearbyNpcRadius = 15,
 NearbyNpcTags = { "BeastBorn" },
 NearbyNpcRegions = { "Mistfall Harbor" }
 }
 }
 }
 },
 Following = {
 CaptureDistance = 0,
 LetGoDistance = 0
 },
 Settings = {
 NpcCode = "Civilian"
 }
 }
};
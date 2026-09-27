-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Menum = require(ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(ReplicatedStorage.CAM.Global.Types.NpcTypes);

return {
 Name = "Yahari",
 Icon = "rbxassetid://77562210024440",
 Quantity = 1,
 Type = Menum.npcType.Active,
 SendOver = {
 Boss = {
 SpawnCountdown = true,
 DamageLeaderboard = true,
 HealthEvents = "SecondPhase"
 },
 Spawning = {
 SpawnTime = 300,
 DespawnDistance = 250,
 Center = Vector3.new(825.678, 1019.2, -641.335),
 Locations = { Vector3.new(825.678, 1019.2, -641.335) },
 Appearance = ReplicatedStorage.Assets.Npcs.EvilArtDemons.Yahari
 },
 Idling = {
 Enabled = false
 },
 Following = {
 CaptureDistance = 0,
 LetGoDistance = 140
 },
 Settings = {
 NpcCode = "Yahari"
 }
 }
};
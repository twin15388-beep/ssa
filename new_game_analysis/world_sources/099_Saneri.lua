-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Menum = require(ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(ReplicatedStorage.CAM.Global.Types.NpcTypes);

return {
 Name = "Saneri",
 Icon = "rbxassetid://71155084242970",
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
 Center = Vector3.new(-379.108, 1093.531, -422.421),
 Locations = { Vector3.new(-379.108, 1093.531, -422.421) },
 Appearance = ReplicatedStorage.Assets.Npcs.Hashiras.Saneri
 },
 Idling = {
 Enabled = false
 },
 Following = {
 CaptureDistance = 0,
 LetGoDistance = 140
 },
 Settings = {
 NpcCode = "Saneri"
 }
 }
};
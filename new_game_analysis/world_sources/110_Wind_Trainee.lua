-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage.CAM.Global.Types.NpcTypes);

return {
 Name = "Wind Trainee",
 Icon = "rbxassetid://75784714790464",
 Quantity = 1,
 Type = Menum.npcType.Active,
 SendOver = {
 Boss = {
 SpawnCountdown = true,
 DamageLeaderboard = true
 },
 Spawning = {
 SpawnTime = 120,
 DespawnDistance = 250,
 Center = Vector3.new(-941.573, 1381, -2635.568),
 Locations = { Vector3.new(-941.573, 1381, -2635.568) },
 Appearance = game:GetService("ReplicatedStorage").Assets.Npcs.Trainees.WindTrainee
 },
 Idling = {
 Enabled = false
 },
 Following = {
 CaptureDistance = 0,
 LetGoDistance = 140
 },
 Settings = {
 NpcCode = "WindTrainee"
 }
 }
};
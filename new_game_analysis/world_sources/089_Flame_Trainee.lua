-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Types"):WaitForChild("NpcTypes"));

return {
 Name = "Flame Trainee",
 Icon = "rbxassetid://84603644178937",
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
 Center = Vector3.new(-1128.902, 1029.049, 994.42),
 Locations = { Vector3.new(-1128.902, 1029.049, 994.42) },
 Appearance = game:GetService("ReplicatedStorage").Assets.Npcs.Trainees.FlameTrainee
 },
 Idling = {
 Enabled = false
 },
 Following = {
 CaptureDistance = 0,
 LetGoDistance = 140
 },
 Settings = {
 NpcCode = "FlameTrainee"
 }
 }
};
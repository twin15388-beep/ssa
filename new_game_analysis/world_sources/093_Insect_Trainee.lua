-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage.CAM.Global.Types.NpcTypes);

return {
 Name = "Insect Trainee",
 Icon = "rbxassetid://84412720285589",
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
 Center = Vector3.new(-1395.644, 261.5, 69.22),
 Locations = { Vector3.new(-1395.644, 261.5, 69.22) },
 Appearance = game:GetService("ReplicatedStorage").Assets.Npcs.Trainees.InsectTrainee
 },
 Idling = {
 Enabled = false
 },
 Following = {
 CaptureDistance = 0,
 LetGoDistance = 140
 },
 Settings = {
 NpcCode = "InsectTrainee"
 }
 }
};
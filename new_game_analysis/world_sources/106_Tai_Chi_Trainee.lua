-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Types"):WaitForChild("NpcTypes"));

return {
 Name = "Tai Chi Trainee Suzume",
 Icon = "rbxassetid://132888817986073",
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
 Center = Vector3.new(2360.47, 601.991, -642.309),
 Locations = { Vector3.new(2360.47, 601.991, -642.309) },
 Appearance = game:GetService("ReplicatedStorage").Assets.Npcs.Trainees.TaiChiTrainee
 },
 Idling = {
 Enabled = false
 },
 Following = {
 CaptureDistance = 0,
 LetGoDistance = 140
 },
 Settings = {
 NpcCode = "TaiChiTrainee"
 }
 }
};
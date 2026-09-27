-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Types"):WaitForChild("NpcTypes"));

return {
 Name = "Water Trainee Sabito",
 Icon = "rbxassetid://103179547098493",
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
 Center = Vector3.new(815.348, 1018.884, 101.599),
 Locations = { Vector3.new(815.348, 1018.884, 101.599) },
 Appearance = game:GetService("ReplicatedStorage").Assets.Npcs.Trainees.WaterTrainee
 },
 Idling = {
 Enabled = false
 },
 Following = {
 CaptureDistance = 0,
 LetGoDistance = 140
 },
 Settings = {
 NpcCode = "WaterTrainee"
 }
 }
};
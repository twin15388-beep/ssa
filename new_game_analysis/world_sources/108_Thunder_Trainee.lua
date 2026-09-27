-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Types"):WaitForChild("NpcTypes"));

return {
 Name = "Thunder Trainee",
 Icon = "rbxassetid://100715629980691",
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
 Center = Vector3.new(2425.506, 1073.631, -556.788),
 Locations = { Vector3.new(2425.506, 1073.631, -556.788) },
 Appearance = game:GetService("ReplicatedStorage").Assets.Npcs.Trainees.ThunderTrainee
 },
 Idling = {
 Enabled = false
 },
 Following = {
 CaptureDistance = 0,
 LetGoDistance = 140
 },
 Settings = {
 NpcCode = "ThunderTrainee"
 }
 }
};
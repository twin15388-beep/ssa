-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage.CAM.Global.Types.NpcTypes);

return {
 Name = "Serpent Trainee",
 Icon = "rbxassetid://140495004689315",
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
 Center = Vector3.new(-271.378, 1292, -1535.713),
 Locations = { Vector3.new(-271.378, 1292, -1535.713) },
 Appearance = game:GetService("ReplicatedStorage").Assets.Npcs.Trainees.SerpentTrainee
 },
 Idling = {
 Enabled = false
 },
 Following = {
 CaptureDistance = 0,
 LetGoDistance = 140
 },
 Settings = {
 NpcCode = "SerpentTrainee"
 }
 }
};
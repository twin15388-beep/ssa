-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage.CAM.Global.Types.NpcTypes);

return {
 Name = "Sound Trainee",
 Icon = "rbxassetid://103322791656200",
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
 Center = Vector3.new(192.5, 1349, -2581.313),
 Locations = { Vector3.new(192.5, 1349, -2581.313) },
 Appearance = game:GetService("ReplicatedStorage").Assets.Npcs.Trainees.SoundTrainee
 },
 Idling = {
 Enabled = false
 },
 Following = {
 CaptureDistance = 0,
 LetGoDistance = 140
 },
 Settings = {
 NpcCode = "SoundTrainee"
 }
 }
};
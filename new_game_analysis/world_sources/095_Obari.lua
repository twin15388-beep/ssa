-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Menum = require(ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(ReplicatedStorage.CAM.Global.Types.NpcTypes);

return {
 Name = "Obari",
 Icon = "rbxassetid://78844218100909",
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
 Center = Vector3.new(770.518, 1121, -1047.036),
 Locations = { Vector3.new(770.518, 1121, -1047.036) },
 Appearance = ReplicatedStorage.Assets.Npcs.Hashiras.Obari
 },
 Idling = {
 Enabled = false
 },
 Following = {
 CaptureDistance = 0,
 LetGoDistance = 140
 },
 Settings = {
 NpcCode = "Obari"
 }
 }
};
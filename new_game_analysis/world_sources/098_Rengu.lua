-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Menum = require(ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(ReplicatedStorage.CAM.Global.Types.NpcTypes);

return {
 Name = "Rengu",
 Icon = "rbxassetid://83867747088156",
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
 Center = Vector3.new(-712.898, 965, 883.799),
 Locations = { Vector3.new(-712.898, 965, 883.799) },
 Appearance = ReplicatedStorage.Assets.Npcs.Hashiras.Rengu
 },
 Idling = {
 Enabled = false
 },
 Following = {
 CaptureDistance = 0,
 LetGoDistance = 140
 },
 Settings = {
 NpcCode = "Rengu"
 }
 }
};
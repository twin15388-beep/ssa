-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Menum = require(ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(ReplicatedStorage.CAM.Global.Types.NpcTypes);

return {
 Name = "Fujiko",
 Icon = "rbxassetid://136297892050152",
 Quantity = 1,
 Type = Menum.npcType.Active,
 SendOver = {
 Boss = {
 SpawnCountdown = true,
 DamageLeaderboard = true
 },
 Spawning = {
 SpawnTime = 180,
 DespawnDistance = 250,
 Center = Vector3.new(-2459.527, 37.868, 1119.002),
 Locations = { Vector3.new(-2459.527, 37.868, 1119.002) },
 Appearance = ReplicatedStorage.Assets.Npcs["Final Selection Plains"].Fujiko
 },
 Idling = {
 Enabled = false
 },
 Following = {
 CaptureDistance = 0,
 LetGoDistance = 140
 },
 Settings = {
 NpcCode = "Fujiko"
 }
 }
};
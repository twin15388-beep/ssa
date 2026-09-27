-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Menum = require(ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(ReplicatedStorage.CAM.Global.Types.NpcTypes);

return {
 Name = "Hoyuzo",
 Icon = "rbxassetid://78799362242966",
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
 Center = Vector3.new(746.875, 1001, -1413),
 Locations = { Vector3.new(746.875, 1001, -1413) },
 Appearance = ReplicatedStorage.Assets.Npcs["Bamboo Grove"].Hoyuzo
 },
 Idling = {
 Enabled = false
 },
 Following = {
 CaptureDistance = 0,
 LetGoDistance = 140
 },
 Settings = {
 NpcCode = "Hoyuzo"
 }
 }
};
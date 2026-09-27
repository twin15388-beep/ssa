-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local BanditSettings = require(script.Parent.Parent:WaitForChild("NpcShared"):WaitForChild("BanditSettings"));
local Menum = require(ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(ReplicatedStorage.CAM.Global.Types.NpcTypes);

return {
 Name = "Zuko",
 Quantity = 1,
 Type = Menum.npcType.Active,
 SendOver = {
 Boss = {
 SpawnCountdown = true,
 DamageLeaderboard = true
 },
 Spawning = {
 SpawnTime = 135,
 Locations = { Vector3.new(-283.311, 1224.2, -1032.39) },
 DespawnDistance = BanditSettings.DespawnDistance,
 Center = BanditSettings.Center,
 Appearance = ReplicatedStorage.Assets.Npcs["Windy Peak"].Zuko
 },
 Idling = {
 Enabled = false
 },
 Following = {
 CaptureDistance = 0,
 LetGoDistance = 140
 },
 Settings = {
 NpcCode = "Zuko"
 }
 }
};
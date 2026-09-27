-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(ReplicatedStorage.CAM.Global.Types.NpcTypes);
local GreaterDemonSettings = require(script.Parent.Parent.Parent:WaitForChild("NpcShared"):WaitForChild("GreaterDemonSettings"));

return {
 Name = "Greater Demon",
 Quantity = 4,
 Type = Menum.npcType.Active,
 SendOver = {
 Spawning = {
 Locations = GreaterDemonSettings.Spawns,
 SpawnTime = GreaterDemonSettings.SpawnTime,
 DespawnDistance = GreaterDemonSettings.DespawnDistance,
 Center = GreaterDemonSettings.Center,
 Appearance = ReplicatedStorage.Assets.Npcs["Butterfly Estate"].GreaterDemon_ButterflyEstate:GetChildren()
 },
 Idling = {
 Enabled = false
 },
 Following = {
 CaptureDistance = 45,
 LetGoDistance = 140,
 NpcsPerPlayer = 1
 },
 Settings = GreaterDemonSettings.Settings
 }
};
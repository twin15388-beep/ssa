-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(ReplicatedStorage.CAM.Global.Types.NpcTypes);
local HighDemonSettings = require(script.Parent.Parent:WaitForChild("NpcShared"):WaitForChild("HighDemonSettings"));

return {
 Name = "High Demon",
 Quantity = 4,
 Type = Menum.npcType.Active,
 SendOver = {
 Spawning = {
 Locations = HighDemonSettings.Spawns,
 SpawnTime = HighDemonSettings.SpawnTime,
 DespawnDistance = HighDemonSettings.DespawnDistance,
 Center = HighDemonSettings.Center,
 Appearance = ReplicatedStorage.Assets.Npcs["Iceveil Valley"].HighDemon:GetChildren()
 },
 Idling = {
 Enabled = false
 },
 Following = {
 CaptureDistance = 0,
 LetGoDistance = 100
 },
 Settings = HighDemonSettings.Settings
 }
};
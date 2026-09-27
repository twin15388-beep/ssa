-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(ReplicatedStorage.CAM.Global.Types.NpcTypes);
local BloodHoundedDemonSettings = require(script.Parent.Parent.Parent:WaitForChild("NpcShared"):WaitForChild("BloodHoundedDemonSettings"));

return {
 Name = "Blood Hounded Demon",
 Quantity = 5,
 Type = Menum.npcType.Active,
 SendOver = {
 Spawning = {
 Locations = BloodHoundedDemonSettings.Spawns,
 SpawnTime = BloodHoundedDemonSettings.SpawnTime,
 DespawnDistance = BloodHoundedDemonSettings.DespawnDistance,
 Center = BloodHoundedDemonSettings.Center,
 Appearance = ReplicatedStorage.Assets.Npcs["Mistfall Harbor"].BloodHoundedDemon_MistfallHarbor:GetChildren()
 },
 Idling = {
 Enabled = false
 },
 Following = {
 CaptureDistance = 45,
 NpcsPerPlayer = 1,
 LetGoDistance = 140
 },
 Settings = BloodHoundedDemonSettings.Settings
 }
};
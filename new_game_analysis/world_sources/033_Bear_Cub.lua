-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local BearSettings = require(script.Parent.Parent:WaitForChild("NpcShared"):WaitForChild("BearSettings"));
local Menum = require(ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(ReplicatedStorage.CAM.Global.Types.NpcTypes);

return {
 Name = "Bear Cub",
 Quantity = 4,
 Type = Menum.npcType.Active,
 SendOver = {
 Spawning = {
 SpawnTime = 24,
 Locations = BearSettings.Spawns,
 DespawnDistance = BearSettings.DespawnDistance,
 Center = BearSettings.Center,
 Appearance = ReplicatedStorage.Assets.Npcs["Bamboo Grove"].BearCub,
 ModelAttributes = {
 OverheadTopMargin = -2
 }
 },
 Idling = {
 Enabled = false
 },
 Following = {
 CaptureDistance = 0,
 LetGoDistance = 120
 },
 Settings = {
 NpcCode = "BearCub"
 }
 }
};
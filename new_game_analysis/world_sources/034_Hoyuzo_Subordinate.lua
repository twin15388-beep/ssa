-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(ReplicatedStorage.CAM.Global.Types.NpcTypes);

return {
 Name = "Hoyuzo Subordinate",
 Quantity = 4,
 Type = Menum.npcType.Active,
 SendOver = {
 Spawning = {
 SpawnTime = 40,
 DespawnDistance = 495,
 Center = Vector3.new(533, 1001, -1357),
 Locations = { Vector3.new(536, 1001, -1389), Vector3.new(544.019, 1001.519, -1169.504), Vector3.new(596, 1001, -1134), Vector3.new(580, 1001, -1010), Vector3.new(606, 1001, -1071), Vector3.new(672, 1001, -1001) },
 Appearance = ReplicatedStorage.Assets.Npcs["Bamboo Grove"].HoyuzoSub:GetChildren()
 },
 Idling = {
 Enabled = false
 },
 Following = {
 CaptureDistance = 45,
 LetGoDistance = 140
 },
 Settings = {
 NpcCode = "HoyuzoSub"
 }
 }
};
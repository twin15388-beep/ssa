-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(ReplicatedStorage.CAM.Global.Types.NpcTypes);

return {
 Name = "Kaiden Subordinate",
 Quantity = 4,
 Type = Menum.npcType.Active,
 SendOver = {
 Spawning = {
 SpawnTime = 40,
 DespawnDistance = 250,
 Center = Vector3.new(585.712, 1146.547, -1314.887),
 Locations = { Vector3.new(601.3, 1146.547, -1305.887), Vector3.new(581.053, 1146.547, -1297.5), Vector3.new(568.32495, 1146.547, -1319.546), Vector3.new(590.371, 1146.547, -1332.2739) },
 Appearance = ReplicatedStorage.Assets.Npcs["Bamboo Grove"].KaidenSub:GetChildren()
 },
 Idling = {
 Enabled = false
 },
 Following = {
 CaptureDistance = 0,
 LetGoDistance = 140
 },
 Settings = {
 NpcCode = "KaidenSub"
 }
 }
};
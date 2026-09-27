-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CivilianSettings = require(script.Parent.Parent:WaitForChild("NpcShared"):WaitForChild("CivilianSettings"));
local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(ReplicatedStorage.CAM.Global.Types.NpcTypes);

return {
 Name = "*Civilian*",
 Quantity = 2,
 Type = Menum.npcType.Active,
 SendOver = {
 Spawning = {
 SpawnTime = 30,
 Locations = CivilianSettings.Points,
 DespawnDistance = CivilianSettings.DespawnDistance,
 Center = CivilianSettings.Center,
 Appearance = ReplicatedStorage.Assets.Npcs["Windy Peak"].VillageSpy:GetChildren()
 },
 Idling = {
 Enabled = true,
 Positions = CivilianSettings.Points
 },
 Following = {
 CaptureDistance = 0,
 LetGoDistance = 140
 },
 Settings = {
 NpcCode = "VillageSpy"
 }
 }
};
-- Decompiled with Potassium's decompiler.

local CivilianSettings = require(script.Parent:WaitForChild("CivilianSettings"));

return {
 DespawnDistance = 500,
 SpawnTime = 45,
 Spawns = CivilianSettings.Points,
 Settings = {
 NpcCode = "BeastBornDemon_MistfallHarbor"
 },
 Center = CivilianSettings.Center
};
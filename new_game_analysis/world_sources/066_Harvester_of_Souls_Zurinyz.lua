-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Types"):WaitForChild("NpcTypes"));
local v1 = CFrame.new(-1212.575, 1387.474, -2371.557) * CFrame.Angles(0, 1.6535423866319479, 0);

return {
 Name = "Harvester of Souls Zurinyz",
 Icon = "rbxassetid://74259714664576",
 Type = Menum.npcType.Stationary,
 Requirements = {
 Level = 100,
 Race = { "Demon", "Hybrid" }
 },
 Appearance = script:FindFirstChild("Model"),
 Animations = {
 idle = { "rbxassetid://86565852659794" }
 },
 Spawns = { v1 }
};
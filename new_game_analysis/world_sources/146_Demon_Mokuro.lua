-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Types"):WaitForChild("NpcTypes"));
local v1 = CFrame.new(-1948.429, 28.374, 374.307) * CFrame.Angles(0, 1.5707963267948966, 0);

return {
 Icon = "rbxassetid://79867123229621",
 Marker = true,
 Type = Menum.npcType.Stationary,
 Name = script.Name,
 Requirements = {
 Level = 75,
 Race = { "Demon", "Hybrid" }
 },
 Appearance = script:FindFirstChild("Model"),
 Animations = {
 idle = { "rbxassetid://83241418829766" }
 },
 Spawns = { v1 }
};
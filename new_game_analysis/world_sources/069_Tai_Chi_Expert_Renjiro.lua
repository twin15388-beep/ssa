-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Types"):WaitForChild("NpcTypes"));
local v1 = CFrame.new(1883.127, 686.611, -761.04) * CFrame.Angles(0, -0.4363323129985824, 0);

return {
 Name = "Tai Chi Expert Renjiro",
 Icon = "rbxassetid://78189611509266",
 Type = Menum.npcType.Stationary,
 Requirements = {
 Level = 65,
 Race = { "Slayer", "Hybrid" }
 },
 Animations = {
 idle = { "rbxassetid://133202472879408" }
 },
 Appearance = script:FindFirstChild("Model"),
 Spawns = { v1 }
};
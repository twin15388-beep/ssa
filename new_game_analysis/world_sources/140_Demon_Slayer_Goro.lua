-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Types"):WaitForChild("NpcTypes"));
local v1 = CFrame.new(-871.97, 234.75, 318.469) * CFrame.Angles(0, -2.9670597283903604, 0);

return {
 Icon = "rbxassetid://137177540560157",
 Marker = true,
 Type = Menum.npcType.Stationary,
 Name = script.Name,
 Requirements = {
 Level = 75,
 Race = { "Slayer", "Hybrid" }
 },
 Appearance = script:FindFirstChild("Model"),
 Animations = {
 idle = { "rbxassetid://129529377840424" }
 },
 Spawns = { v1 }
};
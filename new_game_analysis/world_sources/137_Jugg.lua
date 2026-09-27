-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Types"):WaitForChild("NpcTypes"));
local CFrame_new_ret = CFrame.new(487.702, 874.066, 1007.795, 0.0614143908, 0, 0.99811244, 0, 1, 0, -0.99811244, 0, 0.0614143908);

return {
 Icon = "rbxassetid://81483381279448",
 Marker = "Mistfall Harbor",
 Type = Menum.npcType.Stationary,
 Name = script.Name,
 Requirements = {
 Level = 62,
 Race = { "Slayer", "Hybrid" }
 },
 Appearance = script:FindFirstChild("Model"),
 Animations = {
 idle = { "rbxassetid://101710928573804" }
 },
 Spawns = { CFrame_new_ret }
};
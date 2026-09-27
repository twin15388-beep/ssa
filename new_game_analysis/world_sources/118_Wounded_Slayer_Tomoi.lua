-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Types"):WaitForChild("NpcTypes"));
local CFrame_new_ret = CFrame.new(485.340332, 1222.61743, -1812.99634, -4.37113883e-8, 0, 1, 0, 1, 0, -1, 0, -4.37113883e-8);

return {
 Icon = "rbxassetid://93885945754716",
 Marker = true,
 Type = Menum.npcType.Stationary,
 Name = script.Name,
 Requirements = {
 Level = 90,
 Race = { "Slayer", "Hybrid" }
 },
 Appearance = script:FindFirstChild("Model"),
 Animations = {
 idle = { "rbxassetid://91826854825928" }
 },
 Spawns = { CFrame_new_ret }
};
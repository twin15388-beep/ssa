-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Types"):WaitForChild("NpcTypes"));
local v1 = CFrame.new(464.881, 1491.122, -3272.797) * CFrame.Angles(0, 0, 0);

return {
 Name = "Sound Trainer Tengai",
 Icon = "rbxassetid://122563809428535",
 Type = Menum.npcType.Stationary,
 Requirements = {
 Level = 25
 },
 Appearance = script:FindFirstChild("Model"),
 Animations = {
 idle = { "rbxassetid://114360490222127" }
 },
 Spawns = { v1 }
};
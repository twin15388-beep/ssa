-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Types"):WaitForChild("NpcTypes"));
local v1 = CFrame.new(2578.583, 1095.806, -828.401) * CFrame.Angles(0, 3.141592653589793, 0);

return {
 Name = "Stone Trainer Gyorei",
 Icon = "rbxassetid://122921780565487",
 Type = Menum.npcType.Stationary,
 Requirements = {
 Level = 25
 },
 Appearance = script:FindFirstChild("Model"),
 Animations = {
 idle = { "rbxassetid://85759143708964" }
 },
 Spawns = { v1 }
};
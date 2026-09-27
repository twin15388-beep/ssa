-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Types"):WaitForChild("NpcTypes"));
local v1 = CFrame.new(-275.576, 1187.487, -3436.653) * CFrame.Angles(0, 3.141592653589793, 0);

return {
 Name = "Wind Trainer Saneri",
 Icon = "rbxassetid://135092880963148",
 Type = Menum.npcType.Stationary,
 Requirements = {
 Level = 25
 },
 Appearance = script:FindFirstChild("Model"),
 Animations = {
 idle = { "rbxassetid://101760068510394" }
 },
 Spawns = { v1 }
};
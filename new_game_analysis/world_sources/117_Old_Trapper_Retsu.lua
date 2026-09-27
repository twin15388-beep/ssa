-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Types"):WaitForChild("NpcTypes"));
local v1 = CFrame.new(440, 1176.976, -1504.011) * CFrame.Angles(0, -1.1780448852186125, 0);

return {
 Name = "Old Trapper Retsu",
 Type = Menum.npcType.Stationary,
 Appearance = script:FindFirstChild("Model"),
 Animations = {
 idle = { "rbxassetid://129529377840424" }
 },
 Spawns = { v1 }
};
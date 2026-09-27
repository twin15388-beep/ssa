-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Types"):WaitForChild("NpcTypes"));
local v1 = CFrame.new(667.174, 1022.688, -228.24) * CFrame.Angles(0, 0, 0);

return {
 Name = "Water Trainer Urokodaki",
 Icon = "rbxassetid://112236447199349",
 PromptRange = 3,
 Type = Menum.npcType.Stationary,
 Requirements = {
 Level = 25
 },
 Appearance = script:FindFirstChild("Model"),
 Animations = {
 idle = { "rbxassetid://94126192827597" }
 },
 Spawns = { v1 }
};
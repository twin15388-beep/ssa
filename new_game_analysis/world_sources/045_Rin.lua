-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Types"):WaitForChild("NpcTypes"));
local CFrame_new_ret = CFrame.new(432.25, 1018, 73.1, 0.998112381, 0, -0.061414022, 0, 1, 0, 0.061414022, 0, 0.998112381);

return {
 Icon = "rbxassetid://122062841564721",
 Marker = true,
 Type = Menum.npcType.Stationary,
 Name = script.Name,
 Requirements = {
 Level = 47
 },
 Appearance = script:FindFirstChild("Model"),
 Spawns = { CFrame_new_ret }
};
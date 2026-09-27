-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Types"):WaitForChild("NpcTypes"));
local CFrame_new_ret = CFrame.new(-561.095398, 796.25, 683.70459, 0.971201539, 0, 0.238259509, 0, 1, 0, -0.238259509, 0, 0.971201539);

return {
 Icon = "rbxassetid://101569067713527",
 Marker = true,
 Type = Menum.npcType.Stationary,
 Name = script.Name,
 Requirements = {
 Level = 45
 },
 Appearance = script:FindFirstChild("Model"),
 Spawns = { CFrame_new_ret }
};
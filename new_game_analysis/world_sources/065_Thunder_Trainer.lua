-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Types"):WaitForChild("NpcTypes"));
local v1 = CFrame.new(1970.18, 1660, -609.811) * CFrame.Angles(0, -0.3490658503988659, 0);

return {
 Name = "Thunder Trainer Zentaro",
 Icon = "rbxassetid://101638265610853",
 Type = Menum.npcType.Stationary,
 Requirements = {
 Level = 25
 },
 Appearance = script:FindFirstChild("Model"),
 Animations = {
 idle = { "rbxassetid://95480077602309" }
 },
 Spawns = { v1 }
};
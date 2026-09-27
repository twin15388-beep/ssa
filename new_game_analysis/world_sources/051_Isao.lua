-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Types"):WaitForChild("NpcTypes"));
local v1 = CFrame.new(-214.577, 797, 61.06) * CFrame.Angles(0, 3.141592653589793, 0);

return {
 Name = "Legendary Fisherman Isao",
 Marker = false,
 NameTag = false,
 NightOnly = true,
 Type = Menum.npcType.Stationary,
 Appearance = script:FindFirstChild("Model"),
 Animations = {
 idle = { "rbxassetid://72297163284833" }
 },
 Spawns = { v1 }
};
-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Types"):WaitForChild("NpcTypes"));
local v1 = CFrame.new(1865.274, 694, -434.26) * CFrame.Angles(0, 1.2217304763960306, 0);

return {
 Name = "Refiner Hagane",
 Icon = "rbxassetid://102795670928539",
 Marker = true,
 Type = Menum.npcType.Stationary,
 Requirements = {
 Level = 65
 },
 ModelAttributes = {
 NoDialogueTurn = true
 },
 Appearance = script:FindFirstChild("Model"),
 Animations = {
 idle = { "rbxassetid://119748631388406" }
 },
 Spawns = { v1 }
};
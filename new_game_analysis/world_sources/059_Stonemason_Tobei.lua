-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Types"):WaitForChild("NpcTypes"));

return {
 Marker = false,
 Type = Menum.npcType.Stationary,
 Name = script.Name,
 Appearance = script:FindFirstChild("Model"),
 Spawns = { CFrame.new(1876, 659.047, -206) },
 WorldEvent = {
 Name = "GauntletStatues"
 }
};
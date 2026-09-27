-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Types"):WaitForChild("NpcTypes"));
local CFrame_new_ret = CFrame.new(-160.805679, 796.25, 703.28772, 0, 0, -1, 0, 1, 0, 1, 0, 0);

return {
 Name = "Dock Master Sofen",
 Icon = "rbxassetid://70568013305797",
 Marker = true,
 Type = Menum.npcType.Stationary,
 Requirements = {
 Level = 45
 },
 Appearance = script:FindFirstChild("Model"),
 ModelAttributes = {
 NoDialogueTurn = true
 },
 Animations = {
 idle = { "rbxassetid://134935226248753" }
 },
 Spawns = { CFrame_new_ret }
};
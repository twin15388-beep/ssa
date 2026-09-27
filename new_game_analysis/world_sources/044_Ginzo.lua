-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Types"):WaitForChild("NpcTypes"));
local CFrame_new_ret = CFrame.new(273.7995, 941.500061, 528.189148);

return {
 Icon = "rbxassetid://134965430765504",
 Marker = true,
 Type = Menum.npcType.Stationary,
 Name = script.Name,
 Requirements = {
 Level = 45
 },
 Appearance = script:FindFirstChild("Model"),
 ModelAttributes = {
 NoDialogueTurn = true,
 NoDialogueAnim = true
 },
 Animations = {
 idle = { "rbxassetid://123294887820062" }
 },
 Spawns = { CFrame_new_ret },
 Shop = {
 ["Metal Scraps"] = {
 Price = {
 Wen = 500
 }
 },
 ["Silk Thread"] = {
 Price = {
 Wen = 350
 }
 }
 }
};
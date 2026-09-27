-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Types"):WaitForChild("NpcTypes"));
local v1 = CFrame.new(-1058.822, 1226.006, -955.657) * CFrame.Angles(0, -1.5707963267948966, 0);

return {
 Name = "Wagasa Maker Genzo",
 Marker = false,
 NameTag = false,
 Type = Menum.npcType.Stationary,
 Appearance = script:FindFirstChild("Model"),
 Animations = {
 idle = { "rbxassetid://116267866253223" }
 },
 ModelAttributes = {
 NoDialogueTurn = true,
 NoDialogueAnim = true
 },
 Spawns = { v1 },
 WorldEvent = {
 Name = "FirstlightWagasa"
 }
};
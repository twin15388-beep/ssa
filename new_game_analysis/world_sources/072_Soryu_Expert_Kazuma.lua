-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Types"):WaitForChild("NpcTypes"));
local v1 = CFrame.new(-769.458, 909.445, 303.346) * CFrame.Angles(0, 3.141592653589793, 0);

return {
 Name = "Soryu Expert Kazuma",
 Icon = "rbxassetid://74259714664576",
 Type = Menum.npcType.Stationary,
 Requirements = {
 Level = 62,
 Race = { "Demon", "Hybrid" }
 },
 Appearance = script:FindFirstChild("Model"),
 ModelAttributes = {
 NoDialogueTurn = true,
 NoDialogueAnim = true
 },
 Animations = {
 idle = { "rbxassetid://133711993244341" }
 },
 Spawns = { v1 }
};
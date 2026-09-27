-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Types"):WaitForChild("NpcTypes"));
local CFrame_new_ret = CFrame.new(427.816, 941.003, 507.446, 0, 0, 1, 0, 1, 0, -1, 0, 0);

return {
 Icon = "rbxassetid://132407850809631",
 Marker = true,
 Type = Menum.npcType.Stationary,
 Name = script.Name,
 Appearance = script:FindFirstChild("Model"),
 Animations = {
 idle = { "rbxassetid://103032167746423" }
 },
 Spawns = { CFrame_new_ret },
 RotatingShop = {
 Name = "Elara",
 Seed = 4201,
 TimedEvent = "TailorRestock",
 SlotCount = 6,
 MannequinTemplateName = "outfit_stand",
 CountdownAt = Vector3.new(396, 950, 525),
 RefreshEffect = "ElaraClothingSwitch",
 RequiresQuestDone = "Ill deliver the package",
 Always = { "Black Amigasa" },
 Slots = {
 CFrame.new(408.735, 941.014, 544.345, -1, 0, 0, 0, 1, 0, 0, 0, -1),
 CFrame.new(408.414, 941.014, 524.377, 0, 0, 1, 0, 1, 0, -1, 0, 0),
 CFrame.new(408.414, 941.014, 529.419, 0, 0, 1, 0, 1, 0, -1, 0, 0),
 CFrame.new(414.235, 941.014, 544.345, -1, 0, 0, 0, 1, 0, 0, 0, -1),
 CFrame.new(419.735, 941.014, 544.345, -1, 0, 0, 0, 1, 0, 0, 0, -1),
 CFrame.new(425.235, 941.014, 544.345, -1, 0, 0, 0, 1, 0, 0, 0, -1),
 CFrame.new(430.938, 941.014, 544.345, -1, 0, 0, 0, 1, 0, 0, 0, -1)
 },
 Pool = { "Wayfarer Mask", "Fern Weave Hakama", "Olive Flower Haori", "Purple Kumo Kesa", "Karakusa Kata-Aki", "Kamon Sodenashi", "Yozakura Yukata", "Azure Cloak", "Yagasuri Koshimaki", "Silent Striker Uniform", "Panther Mask", "Autumn Haori", "Checkered Haori", "Karakusa Cloak", "Silent Vesture", "Hiyozu\'s Scarf", "Feathered Cape" }
 }
};
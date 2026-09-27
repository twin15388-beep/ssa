-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Types"):WaitForChild("NpcTypes"));
local v1 = CFrame.new(1643.237, 669.865, -190.126) * CFrame.Angles(0, -1.5707963267948966, 0);

return {
 Name = "Baitmonger Nori",
 Icon = "rbxassetid://124624579117353",
 Marker = true,
 RequiresQuestDone = "Ill restock the infirmary(Lv 70)",
 Type = Menum.npcType.Stationary,
 Appearance = script:FindFirstChild("Model"),
 Animations = {
 idle = { "rbxassetid://119748631388406" }
 },
 Spawns = { v1 },
 Shop = {
 ["Fish Head"] = {},
 ["Golden Tentacle x10"] = {},
 ["Golden Tentacle x75"] = {}
 }
};
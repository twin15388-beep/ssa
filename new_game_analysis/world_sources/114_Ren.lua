-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Types"):WaitForChild("NpcTypes"));
local Shop = script:FindFirstChild("Shop");
local v1 = { Vector3.new(-1795, 311.8, -85), Vector3.new(-1849.1, 311.8, -91.3), Vector3.new(-1887.3, 311.8, -82.7), Vector3.new(-1834.9, 311.8, -23.7), Vector3.new(-1834.9, 311.8, 75.4), Vector3.new(-1688.3, 286.8, 75.4), Vector3.new(-1609.3, 286.8, 10.2), Vector3.new(-1609.3, 311.8, -80.9), Vector3.new(-1643.2, 311.8, -125.1), Vector3.new(-1707.6, 311.8, -125.1) };
local v2 = {
 Icon = "rbxassetid://71765581781968",
 Marker = true,
 Type = Menum.npcType.Idle,
 Name = script.Name,
 Requirements = {
 Level = 75
 }
};
local v3 = {};
local v4 = {
 RequiresSide = "Slayer",
 SuccessDialogue = "Ren_GourdSuccess",
 FailDialogue = "Ren_GourdFail"
};
local v5;

if Shop then
 v5 = Shop:FindFirstChild("Small Gourd");
else
 v5 = Shop;
end;

v4.Model = v5;
v3["Small Gourd"] = v4;
local v6 = {
 RequiresSide = "Slayer",
 SuccessDialogue = "Ren_GourdSuccess",
 FailDialogue = "Ren_GourdFail"
};
local v7;

if Shop then
 v7 = Shop:FindFirstChild("Medium Gourd");
else
 v7 = Shop;
end;

v6.Model = v7;
v3["Medium Gourd"] = v6;
local v8 = {
 RequiresSide = "Slayer",
 SuccessDialogue = "Ren_GourdSuccess",
 FailDialogue = "Ren_GourdFail"
};

if Shop then
 Shop = Shop:FindFirstChild("Large Gourd");
end;

v8.Model = Shop;
v3["Large Gourd"] = v8;
v2.Shop = v3;
v2.Appearance = script:FindFirstChild("Model");
v2.WaitBeforeChangingDirection = {
 Min = 8,
 Max = 14
};
v2.Spawns = v1;

return v2;
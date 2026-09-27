-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
local v1 = {
 ["Veilfall Cavern"] = {
 Cave = true,
 IndependentMarkers = true,
 Grid = {
 {
 Center = Vector2.new(-600.125, 457.213),
 Radius = Vector2.new(302.155, 184.446),
 Type = Menum.AreaType.Rectangle,
 YLimits = Vector2.new(180, 409)
 }
 }
 }
};
local v2 = {
 Area = {
 Village = true,
 Grid = {
 {
 IsParent = true,
 Center = Vector2.new(-1650.29, 4.24),
 Radius = Vector2.new(476.96, 290.79),
 Type = Menum.AreaType.Rectangle,
 YLimits = Vector2.new(77, 592),
 ChildAreas = v1
 },
 {
 IsParent = true,
 Center = Vector2.new(-612.666, 457.213),
 Radius = Vector2.new(350, 240),
 Type = Menum.AreaType.Rectangle,
 YLimits = Vector2.new(150, 430),
 ChildAreas = v1
 }
 }
 },
 CrystalAt = CFrame.new(-1772.615, 314.607, -120.315, 1, 0, 0, 0, 1, 0, 0, 0, 1),
 Spawns = { Vector3.new(-1771.965, 311.254, -110.905), Vector3.new(-1763.074, 311.324, -118.965) },
 Shrines = {
 {
 Name = "Butterfly Estate Shrine",
 Price = {
 Wen = 15000
 },
 At = CFrame.new(
 -1728.771,
 315.189148,
 126.615662,
 -0.56643182,
 0.0387115963,
 0.823198974,
 1.97105177e-9,
 0.998896062,
 -0.0469738916,
 -0.824108779,
 -0.0266074967,
 -0.565806031
 )
 }
 },
 Npcs = {}
};
local AreaContentLoader = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Subsets"):WaitForChild("Areas"):WaitForChild("AreaContentLoader"));
v2.Npcs = AreaContentLoader.loadNpcs(script, v2.Area);
local NpcContents = script:FindFirstChild("NpcContents");

if NpcContents then
 NpcContents = NpcContents:FindFirstChild("Dialogues");
end;

if NpcContents then
 v2.Dialogues = AreaContentLoader.mergeModules(NpcContents:FindFirstChild("Yap"));
 v2.DialogueFunctions = AreaContentLoader.mergeModules(NpcContents:FindFirstChild("Functions"));
 v2.Quests = AreaContentLoader.mergeModules(NpcContents:FindFirstChild("Quests"));
end;

return v2;
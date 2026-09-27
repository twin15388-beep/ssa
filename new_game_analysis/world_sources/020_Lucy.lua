-- Decompiled with Potassium's decompiler.

return {
 Icon = "rbxassetid://102950460729187",
 Marker = true,
 Type = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum")).npcType.Stationary,
 Name = script.Name,
 Requirements = {
 Level = 10
 },
 Appearance = script:FindFirstChild("Model"),
 Animations = {
 idle = { "rbxassetid://113178351451807" }
 },
 Spawns = { CFrame.new(-615.499939, 1258.5, -1177.49988, -1, 0, 0, 0, 1, 0, 0, 0, -1) }
};
-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Menum = require(ReplicatedStorage.CAM.Global.Menum);
require(ReplicatedStorage.CAM.Global.Types.NpcTypes);
local CivilianSettings = require(script.Parent.Parent:WaitForChild("NpcShared"):WaitForChild("CivilianSettings"));

return {
 Name = "Estate Worker Niko",
 Icon = "rbxassetid://84465224432837",
 Marker = true,
 WalkSpeed = 16,
 Type = Menum.npcType.Idle,
 Requirements = {
 Level = 70
 },
 Appearance = script:FindFirstChild("Model"),
 Spawns = CivilianSettings.Points
};
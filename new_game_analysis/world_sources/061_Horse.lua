-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Types"):WaitForChild("NpcTypes"));

return {
 Name = "Horse",
 Quantity = 1,
 ParentToDebree = true,
 Type = Menum.npcType.Active,
 SendOver = {
 Profile = "Horse",
 Spawning = {
 DespawnDistance = 250,
 TrackedBy = "Horse Locator",
 TrackedIcon = "rbxassetid://130298231932875",
 Locations = { Vector3.new(-1740.47, 311.5, 881.24), Vector3.new(128.307, 827.359, 987.86), Vector3.new(607.25, 1017.5, -224.46), Vector3.new(-1035.752, 1130.074, -718.828), Vector3.new(-299.885, 1307.598, -1775.326), Vector3.new(1165.37, 1102.5, -963.35) },
 Announcement = {
 Npc = "MoldySugar",
 Text = "[One of MoldySugar\'s horses]<Color=(.85,.68,.4)> has escaped… tame it [first.]<Style=Fade,Color=(.7,.6,.45)>",
 Duration = 6
 },
 Appearance = script.Model,
 ModelAttributes = {
 NoOverhead = true
 }
 },
 HumanoidDefaults = {
 WalkSpeed = 4
 },
 Idling = {
 Enabled = true,
 Radius = 60,
 WaitBeforeChangingDirection = {
 Min = 4,
 Max = 10
 }
 },
 Settings = {
 NpcCode = "Horse"
 }
 }
};
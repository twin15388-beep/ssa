-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
require(ReplicatedStorage.CAM.Global.Types.MiscTypes);
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterDescendantsInstances = { workspace.Map };
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;

return {
 ["Ill look for the penny(Lv 14)"] = {
 Category = "Dialogue",
 LogCompletion = true,
 QuestInstance = Quests.Quest("Find the Lucky Penny", Quests.QuestTask("Lucky Penny found", 1)),
 Rewards = {
 Exp = 840,
 Wen = 75
 },
 Requirements = {
 Level = 14
 },
 CompletionNotify = {
 Npc = "Liv",
 Text = "Ah, you found it! Awesome, thanks kid. Here\'s a little something for your time.",
 Duration = 4
 },
 TaskSpecs = {
 ["Lucky Penny found"] = {
 Type = "Pickup",
 Positions = { Vector3.new(554.5, 1010.55, -214.5) }
 }
 }
 },
 ["Ill find the coins(Lv 21)"] = {
 Category = "Dialogue",
 LogCompletion = true,
 QuestInstance = Quests.Quest("Five Hundred Pennies", Quests.QuestTask("Coins collected", 500)),
 Rewards = {
 Exp = 2280,
 Wen = 270
 },
 Requirements = {
 Level = 21
 },
 CompletionNotify = {
 Npc = "Liv",
 Text = "Wow... you actually did it. Alright kid, you\'ve earned yourself a bet. Come talk to me.",
 Duration = 4
 },
 Markers = {
 ["Coins collected"] = {
 Position = Vector3.new(675, 1024.7, 134),
 Icon = BunchaIcons.Coin
 }
 },
 TaskSpecs = {
 ["Coins collected"] = {
 Type = "Pickup",
 SpawnCount = 12,
 RespawnTime = 0,
 Anchor = Vector3.new(675, 1018.7, 134),
 Radius = 15,

 Positions = function(p1: number) -- Line: 19, Name: randomCoinSpot
 -- upvalues: RaycastParams_new_ret (copy)
 for i = 1, 10 do
 local v2 = math.random() * 2 * 3.141592653589793;
 local math_random_ret = math.random();
 local v3 = math.sqrt(math_random_ret) * 15;
 local v4 = math.cos(v2) * v3 + 675;
 local v5 = math.sin(v2) * v3 + 134;
 local Vector3_new_ret = Vector3.new(v4, 1018.7000122070312, v5);
 local v6 = workspace:Raycast(Vector3_new_ret + Vector3.new(0, 10, 0), Vector3.new(0, -50, 0), RaycastParams_new_ret);

 if v6 ~= nil then
 return v6.Position;
 end;

 local _ = i;
 end;

 return nil;
 end
 }
 }
 }
};
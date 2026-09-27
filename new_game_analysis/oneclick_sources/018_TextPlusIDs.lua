-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = game.Players.LocalPlayer;
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local Data = Utility.GetData(LocalPlayer, true);
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);

return {
 timeforquest = function() -- Line: 9, Name: timeforquest
 -- upvalues: Data (copy), Quests (copy), Utility (copy)
 local Quests2 = Data.Quests;
 local QuestCD = Quests.QuestCD;
 local v1 = Utility.Tick() - Quests2.LastTime.Value;

 return QuestCD - math.floor(v1);
 end
};
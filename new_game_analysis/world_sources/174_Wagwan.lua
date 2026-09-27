-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
require(ReplicatedStorage.CAM.Global.Types.MiscTypes);

return {
 ["I will clear out his guards(Lv 40)"] = {
 Category = "Combat",
 Position = Vector3.new(651, 1001, -1023.306),
 QuestInstance = Quests.Quest("Clear Hoyuzo\'s Guard", Quests.QuestTask("Guards defeated", 4, "HoyuzoSub")),
 Rewards = {
 Exp = 720,
 Wen = 324
 },
 Requirements = {
 Level = 40
 },
 CompletionNotify = {
 Npc = "Wagwan",
 Text = "Good… now Hoyuzo stands alone."
 }
 },
 ["I will take care of Hoyuzo(Lv 50)"] = {
 Category = "Combat",
 Position = Vector3.new(746.875, 1001, -1413),
 QuestInstance = Quests.Quest("Defeat Hoyuzo", Quests.QuestTask("Defeat Hoyuzo", 1, "Hoyuzo")),
 Rewards = {
 Exp = 1200,
 Wen = 540
 },
 Requirements = {
 Level = 50
 },
 CompletionNotify = {
 Npc = "Wagwan",
 Text = "It\'s over?! I can finally go find my ring!"
 }
 }
};
-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local NameTag = Utility.NameTag;
local u1 = { "Rare Fishing Rod", "Legendary Fishing Rod" };

local function crated(p2: string) -- Line: 24
 -- upvalues: Utility (copy), Players (copy), Quests (copy)
 local Data = Utility.GetData(Players.LocalPlayer);
 local v3 = Quests.Holder[p2];
 local v4;

 if Data == nil or v3 == nil then
 v4 = nil;
 else
 v4 = Data.Quests.Holder:FindFirstChild(v3.QuestInstance.Name) or nil;
 end;

 if v4 == nil then
 return false;
 end;

 for i, v in v3.TaskSpecs do
 if v.Type == "Deposit" then
 local v5 = v4.Tasks:FindFirstChild(i);

 if v5 == nil or v5.Value.Value < v5.Max.Value then
 return false;
 end;
 end;
 end;

 return true;
end;

local function holdsRod(p6) -- Line: 37
 -- upvalues: u1 (copy)
 if p6 == nil then
 return false;
 end;

 for _, v in u1 do
 if p6.Inventory.Inventory:FindFirstChild(v) ~= nil then
 return true;
 end;
 end;

 return false;
end;

local function rumourOpen() -- Line: 46
 -- upvalues: Utility (copy), Players (copy)
 local Data = Utility.GetData(Players.LocalPlayer);
 local v7;

 if Data == nil then
 v7 = nil;
 else
 v7 = Data:FindFirstChild("WorldEvents");
 end;

 local v8;

 if v7 == nil then
 v8 = false;
 else
 v8 = v7:FindFirstChild("WarFansClue_2") == nil;
 end;

 return v8;
end;

local function exit() -- Line: 52
 -- upvalues: Utility (copy), Players (copy)
 local Data = Utility.GetData(Players.LocalPlayer);
 local v9;

 if Data == nil then
 v9 = nil;
 else
 v9 = Data:FindFirstChild("WorldEvents");
 end;

 local v10;

 if v9 == nil then
 v10 = false;
 else
 v10 = v9:FindFirstChild("WarFansClue_2") == nil;
 end;

 return v10 and "Shiori_Rumour" or nil;
end;

return {
 Shiori = {
 Text = "We\'re running dangerously low on medical supplies.",
 Answers = true,
 IfTrue = "Shiori_2",

 BeforeRun = function(p11, p12) -- Line: 58, Name: BeforeRun
 -- upvalues: Quests (copy), Players (copy), Utility (copy), crated (copy), holdsRod (copy)
 if Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill deliver the supply box(Lv 70)") == "Doing" then
 local Data = Utility.GetData(Players.LocalPlayer);

 if Data ~= nil and Data.Inventory.Inventory:FindFirstChild("Supply Box") ~= nil then
 return "Shiori_Box";
 end;
 end;

 if Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill stock the reserves(Lv 75)") == "Doing" then
 return crated("Ill stock the reserves(Lv 75)") and "Shiori_FoodReturn" or "Shiori_FoodWaiting";
 end;

 local PlayerQuestState = Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill restock the infirmary(Lv 70)");

 if PlayerQuestState == "Doing" then
 return crated("Ill restock the infirmary(Lv 70)") and "Shiori_Return" or "Shiori_Waiting";
 end;

 if PlayerQuestState == "Done" then
 return holdsRod(Utility.GetData(Players.LocalPlayer)) and "Shiori_Food" or "Shiori_FoodNoRod";
 end;
 end
 },
 Shiori_2 = {
 Text = "Every day injured slayers arrive seeking treatment.",
 Answers = true,
 IfTrue = "Shiori_3"
 },
 Shiori_3 = {
 Text = "Without medicine, I [won\'t be able to help them]<Color=(1,.3,.3)>.",
 Answers = true,
 IfTrue = "Shiori_4"
 },
 Shiori_4 = {
 Text = "Bring me elixirs. Ten of each kind.",
 Answers = true,
 IfTrue = "Shiori_5"
 },
 Shiori_5 = {
 Answers = true,
 IfTrue = "Shiori_6",
 Text = `{NameTag("Health Elixir")}, {NameTag("Health Regen Elixir")} and {NameTag("Stamina Regen Elixir")}.`
 },
 Shiori_6 = {
 Answers = true,
 IfTrue = "Shiori_7",
 Text = `{NameTag("Alchemist Meku")} in {NameTag("Mistfall Harbor")} sells them all.`
 },
 Shiori_7 = {
 Text = "Load them into the [infirmary crates]<Color=(1,.85,.3)>, and we can keep treating people.",
 Answers = {
 Close = exit,
 ["Ill restock the infirmary(Lv 70)"] = "AddQuest"
 }
 },
 Shiori_Waiting = {
 Text = "The crates are still standing empty. Load whatever you bring straight in.",
 Answers = true,
 IfTrue = exit
 },
 Shiori_Return = {
 Text = "The crates are full again. [All thirty]<Color=(1,.85,.3)>.",
 Answers = {
 Close = exit,
 ["The infirmary is stocked"] = "DeliverElixirsToShiori"
 }
 },
 Shiori_Thanks = {
 Text = "Perfect.",
 Answers = true,
 IfTrue = "Shiori_Thanks2"
 },
 Shiori_Thanks2 = {
 Text = "This should keep the infirmary running for a while longer. Thank you.",
 Answers = true,
 IfTrue = "Shiori_Thanks3"
 },
 Shiori_Thanks3 = {
 Text = "Word of what you did here has already reached the bait dealer.",
 Answers = true,
 IfTrue = "Shiori_Thanks4"
 },
 Shiori_Thanks4 = {
 Answers = true,
 AutoNext = 1,
 Text = `{NameTag("Baitmonger Nori")}, up in {NameTag("Hidden Mist Village")}. He'll trade with you now.`,
 IfTrue = exit
 },
 Shiori_Food = {
 Text = "The shelves are full again, thanks to you. Now it\'s the food stores I\'m worried about.",
 Answers = true,
 IfTrue = "Shiori_Food2"
 },
 Shiori_Food2 = {
 Text = "The ones recovering here need more than medicine. They need proper food.",
 Answers = true,
 IfTrue = "Shiori_Food3"
 },
 Shiori_Food3 = {
 Text = "Without it, they [stay in those beds twice as long]<Color=(1,.3,.3)>.",
 Answers = true,
 IfTrue = "Shiori_Food4"
 },
 Shiori_Food4 = {
 Text = "Bring me fish. Nine of each kind.",
 Answers = true,
 IfTrue = "Shiori_Food5"
 },
 Shiori_Food5 = {
 Answers = true,
 IfTrue = "Shiori_Food6",
 Text = `{NameTag("Golden Fish")}, {NameTag("Clown Fish")} and {NameTag("Zebra Fish")}.`
 },
 Shiori_Food6 = {
 Answers = true,
 IfTrue = "Shiori_Food7",
 Text = `They run deep, so you'll want {NameTag("Baitmonger Nori")}'s bait for them, up in {NameTag("Hidden Mist Village")}.`
 },
 Shiori_Food7 = {
 Text = "Load them into the same [crates]<Color=(1,.85,.3)>, and we can get people back on their feet.",
 Answers = {
 Close = exit,
 ["Ill stock the reserves(Lv 75)"] = "AddQuest",
 ["Why not the everyday fish?"] = "Shiori_FoodCommon"
 }
 },
 Shiori_FoodCommon = {
 Text = "The common catch is thin. It won\'t put weight back on anyone.",
 Answers = true,
 IfTrue = "Shiori_FoodCommon2"
 },
 Shiori_FoodCommon2 = {
 Answers = true,
 IfTrue = "Shiori_Food7",
 Text = `{NameTag("Angler Runo")} takes those for the village. My patients need better.`
 },
 Shiori_FoodNoRod = {
 Text = "The shelves are full again, thanks to you. I\'d ask one more thing, but you\'d need a better fishing rod for it.",
 Answers = true,
 IfTrue = "Shiori_FoodNoRod2"
 },
 Shiori_FoodNoRod2 = {
 Answers = true,
 IfTrue = "Shiori_FoodNoRod3",
 Text = `{NameTag("Fisherman Jeso")} sells the rod, down on the Mistfall dock, and {NameTag("Baitmonger Nori")} the bait.`
 },
 Shiori_FoodNoRod3 = {
 Text = "Come back when you\'re equipped for it.",
 Answers = true,
 IfTrue = exit
 },
 Shiori_FoodWaiting = {
 Text = "The crates are still short. Load whatever you bring straight in.",
 Answers = true,
 IfTrue = exit
 },
 Shiori_FoodReturn = {
 Text = "The crates are full again. [All 27]<Color=(1,.85,.3)>.",
 Answers = {
 Close = exit,
 ["The stores are stocked"] = "DeliverReservesToShiori"
 }
 },
 Shiori_FoodThanks = {
 Text = "Good.",
 Answers = true,
 IfTrue = "Shiori_FoodThanks2"
 },
 Shiori_FoodThanks2 = {
 Text = "They\'ll eat properly this week. That does more for them than half of what\'s on my shelves.",
 Answers = true,
 IfTrue = "Shiori_FoodThanks3"
 },
 Shiori_FoodThanks3 = {
 Text = "Come find me when the stores run low again.",
 Answers = true,
 IfTrue = exit
 },
 Shiori_Box = {
 Text = "That\'s the crate off the harbour boat. I\'d almost given up on it.",
 Answers = {
 Close = exit,
 ["Niko sent it up"] = "DeliverSupplyBoxToShiori"
 }
 },
 Shiori_BoxThanks = {
 Text = "Finally.",
 Answers = true,
 IfTrue = "Shiori_BoxThanks2"
 },
 Shiori_BoxThanks2 = {
 Answers = true,
 Text = `Half of what's in there I've been rationing for a week. Tell {NameTag("Estate Worker Niko")} I said thank you.`,
 IfTrue = exit
 },
 Shiori_NoBox = {
 Answers = true,
 Text = `You've come back with nothing. {NameTag("Estate Worker Niko")} still has the crate, up at the harbour.`,
 IfTrue = exit
 },
 Shiori_Short = {
 Text = "The crates aren\'t full yet.",
 Answers = true,
 IfTrue = exit
 },
 Shiori_Rumour = {
 Text = "Before you go. A woman came through last month with both hands bandaged to the wrist. Frostbite.",
 Answers = {
 Close = "",
 ["What happened to her?"] = "WarFansClue1"
 }
 },
 Shiori_Rumour2 = {
 Text = "She would not say. Only that she had left something in the snow up north and meant to go back for it, hands or no hands.",
 Answers = true,
 IfTrue = "Shiori_Rumour3"
 },
 Shiori_Rumour3 = {
 Text = "She took the harbour road. Nobody leaves that town without someone writing it down.",
 Answers = true
 }
};
-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local Character_info_provider = require(ReplicatedStorage.CAM.Global.Character_info_provider);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local NameTag = Utility.NameTag;
local u1 = { "Axe and Mace", "Seismic Axe and Mace", "Nightfall Axe and Mace" };

local function holdsWeapon(p2: userdata?) -- Line: 15
 -- upvalues: u1 (copy)
 local v3 = p2 ~= nil and p2:FindFirstChild("Inventory") or nil;
 local v4 = v3 ~= nil and v3:FindFirstChild("Inventory") or nil;

 if v4 == nil then
 return false;
 end;

 for _, v in ipairs(u1) do
 if v4:FindFirstChild(v) ~= nil then
 return true;
 end;
 end;

 return false;
end;

return {
 ["Stone Trainer Gyorei"] = {
 Text = "You have come to train Stone Breathing.",
 Answers = true,
 IfTrue = "StoneTrainer_2",

 BeforeRun = function(p5, p6) -- Line: 27, Name: BeforeRun
 -- upvalues: Quests (copy), Players (copy), Utility (copy), Character_info_provider (copy), holdsWeapon (copy)
 if Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill learn Stone Breathing(Lv 25)") == "Doing" then
 return "StoneTrainer_Doing";
 end;

 local Data = Utility.GetData(Players.LocalPlayer);
 local v7 = Data == nil and "" or (Data.Powers.Breathing.Value or "");

 if v7 == "Stone" then
 return "StoneTrainer_Done";
 end;

 if v7 ~= "" then
 return "StoneTrainer_HasStyle";
 end;

 if not Character_info_provider.HasPowerAccess(Players.LocalPlayer, "Stone") then
 return "StoneTrainer_NoAccess";
 end;

 if not holdsWeapon(Data) then
 return "StoneTrainer_NoWeapon";
 end;
 end
 },
 StoneTrainer_2 = {
 Text = "Even the hardest stone is shaped slowly, by water and time. Breathe with me a moment first.",
 Answers = {
 ["Not yet"] = "",
 ["Ill learn Stone Breathing(Lv 25)"] = "AddQuest"
 }
 },
 StoneTrainer_Doing = {
 Text = "Pain is only stone being shaped. Do not mistake it for failure.",
 Answers = true
 },
 StoneTrainer_Done = {
 Answers = true,
 IfTrue = "StoneTrainer_Done2",
 Text = `You stood against my student and did not waver. [That stillness is the true weight.]<Style=Rainbow> That is {NameTag("Stone Breathing")}.`
 },
 StoneTrainer_Done2 = {
 Text = "Carry it gently. A weight swung carelessly breaks the one holding it.",
 Answers = true
 },
 StoneTrainer_NoAccess = {
 Text = "Breathing is not in you. Seek a different kind of teacher.",
 Answers = true
 },
 StoneTrainer_HasStyle = {
 Text = "You already carry a Breathing. I will not teach over it.",
 Answers = true
 },
 StoneTrainer_NoWeapon = {
 Answers = true,
 Text = `Stone is not taught to empty hands. Find yourself an {NameTag("Axe and Mace")} first, then we will speak.`
 }
};
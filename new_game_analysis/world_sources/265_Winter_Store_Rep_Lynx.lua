-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local NameTag = Utility.NameTag;

local function rumourOpen() -- Line: 27
 -- upvalues: Utility (copy), Players (copy)
 local Data = Utility.GetData(Players.LocalPlayer);
 local v1;

 if Data == nil then
 v1 = nil;
 else
 v1 = Data:FindFirstChild("WorldEvents");
 end;

 local v2;

 if v1 == nil or v1:FindFirstChild("WarFansClue_3") == nil then
 v2 = false;
 else
 v2 = v1:FindFirstChild("ChestMound_Firstlight War Fans Schematic") == nil;
 end;

 return v2;
end;

local function exit() -- Line: 33
 -- upvalues: rumourOpen (copy)
 return rumourOpen() and "Lynx_Rumour" or nil;
end;

return {
 ["Winter Store Rep Lynx"] = {
 Text = "Ah, a traveler. Not many make it this far through the snow.",
 Answers = true,
 IfTrue = "Lynx_2",

 BeforeRun = function(p3, p4) -- Line: 39, Name: BeforeRun
 -- upvalues: Quests (copy), Players (copy)
 if Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill help you survive the winter(Lv 100)") ~= "Done" then
 return "Lynx_Locked";
 end;
 end
 },
 Lynx_2 = {
 Answers = true,
 AutoNext = 1,
 Text = `If you are looking to survive {NameTag("Iceveil Valley")}'s winters, browse the racks. They turn over every hour, so what you see now will not keep.`,
 IfTrue = exit
 },
 Lynx_Locked = {
 Text = "These racks are settlement stock. I cannot sell off them to someone the gate has not let in.",
 Answers = true,
 IfTrue = "Lynx_Locked2"
 },
 Lynx_Locked2 = {
 Answers = true,
 Text = `Help {NameTag("Iceveil Guard Shiro")} see us through the winter first. Then come and warm up.`
 },
 Lynx_PurchaseSuccess = {
 Text = "A wise purchase. Out here, warmth can mean the difference between life and death.",
 Answers = true,
 AutoNext = 1,
 IfTrue = exit
 },
 Lynx_PurchaseFail = {
 Text = "Not enough on you, I am afraid. Come back with a heavier purse -- and mind the racks, they turn over every hour.",
 Answers = true,
 IfTrue = exit
 },
 Lynx_Rumour = {
 Text = "The woman with the wrapped hands? She bought the heaviest coat on the rack and went straight back out into the snow.",
 Answers = {
 Close = "",
 ["Where did she go?"] = "WarFansClue4"
 }
 },
 Lynx_Rumour2 = {
 Text = "She said she had buried a pair of fans out there and would not leave the valley without them.",
 Answers = true,
 IfTrue = "Lynx_Rumour3"
 },
 Lynx_Rumour3 = {
 Text = "Toward the drop, past the last houses. She came back without her shovel and would not say why. If it is still out there, the snow has it.",
 Answers = true
 }
};
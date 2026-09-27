-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local NameTag = Utility.NameTag;

local function hasNote() -- Line: 11
 -- upvalues: Utility (copy), Players (copy)
 local Data = Utility.GetData(Players.LocalPlayer);
 local v1;

 if Data == nil then
 v1 = false;
 else
 v1 = Data.Inventory.Inventory:FindFirstChild("Suspicious Note") ~= nil;
 end;

 return v1;
end;

return {
 Noote = {
 Text = "Oh... what\'s that you\'ve got there? ...A note? Let me see that.",
 Answers = true,
 IfTrue = "Noote_2",

 BeforeRun = function(p2, p3) -- Line: 18, Name: BeforeRun
 -- upvalues: Quests (copy), Players (copy), SignalEvent (copy), Utility (copy)
 if Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill bring him the notes") == "Doing" then
 SignalEvent.ToServer("QuestProgress", "Ill bring him the notes", "Speak with Noote");
 end;

 local PlayerQuestState = Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill get this letter delivered");

 if PlayerQuestState == "Doing" then
 return "Noote_Doing";
 end;

 if PlayerQuestState == "Done" then
 return "Noote_Done";
 end;

 local Data = Utility.GetData(Players.LocalPlayer);
 local v4;

 if Data == nil then
 v4 = false;
 else
 v4 = Data.Inventory.Inventory:FindFirstChild("Suspicious Note") ~= nil;
 end;

 if not v4 then
 return "Noote_Idle";
 end;
 end
 },
 Noote_2 = {
 Text = "Oh wow... this isn\'t random scribbles. This is [coded]<Color=(1,.85,.3)>.",
 Answers = true,
 IfTrue = "Noote_3"
 },
 Noote_3 = {
 Text = "These spies are taking orders from a [bandit group]<Color=(1,.3,.3)> outside the village.",
 Answers = true,
 IfTrue = "Noote_4"
 },
 Noote_4 = {
 Text = "And this part here... [\"Move when the beasts scatter.\"]<Style=Fade,Color=(.8,.7,1)>",
 Answers = true,
 IfTrue = "Noote_5"
 },
 Noote_5 = {
 Text = "...they\'re using the wildlife. This is bigger than a few spies.",
 Answers = true,
 IfTrue = "Noote_6"
 },
 Noote_6 = {
 Answers = true,
 IfTrue = "Noote_7",
 Text = `Take this letter to Windy Peak's escort {NameTag("Chaka")}.`
 },
 Noote_7 = {
 Text = "And next time, don\'t get [Stains]<Color=(1,.3,.3)> all over the evidence. Makes my job harder.",
 Answers = {
 Close = "",
 ["Ill get this letter delivered"] = "AddQuest"
 }
 },
 Noote_Idle = {
 Text = "My uncle runs this village. I just do the thinking.",
 Answers = true
 },
 Noote_Doing = {
 Text = "Hurry up, this is important.",
 Answers = true
 },
 Noote_Done = {
 Answers = true,
 Text = `{NameTag("Chaka")} has the letter? Good. Now we wait and see who moves first.`
 }
};
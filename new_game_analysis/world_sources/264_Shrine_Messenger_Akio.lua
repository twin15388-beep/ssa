-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local NameTag = Utility.NameTag;

local function stocked(p1: string) -- Line: 25
 -- upvalues: Utility (copy), Players (copy), Quests (copy)
 local Data = Utility.GetData(Players.LocalPlayer);
 local v2 = Quests.Holder[p1];
 local v3;

 if Data == nil or v2 == nil then
 v3 = nil;
 else
 v3 = Data.Quests.Holder:FindFirstChild(v2.QuestInstance.Name) or nil;
 end;

 if v3 == nil then
 return false;
 end;

 for i, v in v2.TaskSpecs do
 if v.Type == "Deposit" then
 local v4 = v3.Tasks:FindFirstChild(i);

 if v4 == nil or v4.Value.Value < v4.Max.Value then
 return false;
 end;
 end;
 end;

 return true;
end;

return {
 ["Shrine Messenger Akio"] = {
 Text = "Forgive me. You look like someone who travels armed.",
 Answers = true,
 IfTrue = "Akio_2",

 BeforeRun = function(p5, p6) -- Line: 40, Name: BeforeRun
 -- upvalues: Quests (copy), Players (copy), stocked (copy)
 if Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill help you survive the winter(Lv 100)") ~= "Done" then
 return "Akio_Locked";
 end;

 if Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill haul in the deep catch(Lv 125)") == "Doing" then
 return stocked("Ill haul in the deep catch(Lv 125)") and "Akio_FishReturn" or "Akio_FishWaiting";
 end;

 if Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill see you to Windy Peak(Lv 105)") == "Doing" then
 return "Akio_Doing";
 end;
 end
 },
 Akio_2 = {
 Answers = true,
 IfTrue = "Akio_3",
 Text = `{NameTag("Iceveil Settlement")} cannot survive the winter alone. We trade with {NameTag("Windy Peak")}.`
 },
 Akio_3 = {
 Answers = true,
 IfTrue = "Akio_4",
 Text = `I carry timber down to {NameTag("Village Chief Krue")}. He sends food back.`
 },
 Akio_4 = {
 Text = "[Bandits work that road]<Color=(1,.3,.3)>. The last man they sent down did not return.",
 Answers = true,
 IfTrue = "Akio_5"
 },
 Akio_5 = {
 Text = "Stay at my side and [keep them off the load]<Color=(1,.85,.3)>. Will you see me down?",
 Answers = {
 ["Not yet"] = "",
 ["Ill see you to Windy Peak(Lv 105)"] = "AddQuest",
 ["What else needs doing?"] = "Akio_Fish"
 }
 },
 Akio_Locked = {
 Text = "Forgive me. Settlement business stays inside the walls.",
 Answers = true,
 IfTrue = "Akio_Locked2"
 },
 Akio_Locked2 = {
 Answers = true,
 Text = `Speak to {NameTag("Iceveil Guard Shiro")} at the gate. Then we can talk.`
 },
 Akio_Doing = {
 Text = "The road is waiting on us. Keep close, and I will keep walking.",
 Answers = true
 },
 Akio_Fish = {
 Text = "There is. The road is one way in, and it should not be the only one.",
 Answers = true,
 IfTrue = "Akio_Fish2"
 },
 Akio_Fish2 = {
 Text = "The water keeps giving when the road does not. We could salt what you bring.",
 Answers = true,
 IfTrue = "Akio_Fish3"
 },
 Akio_Fish3 = {
 Answers = true,
 IfTrue = "Akio_Fish4",
 Text = `[Five]<Color=(1,.85,.3)> {NameTag("Crustadon")}, [five]<Color=(1,.85,.3)> {NameTag("Krathulon")}, and a [dozen]<Color=(1,.85,.3)> {NameTag("Clown Fish")} to salt beside them.`
 },
 Akio_Fish4 = {
 Text = "I am told [only the finest rod ever made]<Color=(1,.3,.3)> brings one of those up. I would not know.",
 Answers = true,
 IfTrue = "Akio_Fish5"
 },
 Akio_Fish5 = {
 Text = "Put them in the [gate stores]<Color=(1,.85,.3)>, with the winter supplies. Then find me.",
 Answers = {
 Close = "",
 ["Ill haul in the deep catch(Lv 125)"] = "AddQuest"
 }
 },
 Akio_FishWaiting = {
 Text = "The stores are by the gate. I will be here when they are full.",
 Answers = {
 Close = "",
 ["About the road"] = "Akio_2"
 }
 },
 Akio_FishReturn = {
 Text = "You found them. I did not expect you to.",
 Answers = {
 Close = "",
 ["The stores are full"] = "DeliverDeepCatchToAkio"
 }
 },
 Akio_FishThanks = {
 Text = "That is more than the road has brought us all winter.",
 Answers = true,
 IfTrue = "Akio_FishThanks2"
 },
 Akio_FishThanks2 = {
 Text = "Go back out when you can. I will keep the stores open for you.",
 Answers = true
 },
 Akio_FishShort = {
 Text = "The stores are not full yet.",
 Answers = true
 }
};
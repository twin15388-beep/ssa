-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local NameTag = Utility.NameTag;

local function stocked(p1: string) -- Line: 28
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
 ["Iceveil Guard Shiro"] = {
 Text = "Hold it.",
 Answers = true,
 IfTrue = "Shiro_2",

 BeforeRun = function(p5, p6) -- Line: 43, Name: BeforeRun
 -- upvalues: Quests (copy), Players (copy), stocked (copy)
 if Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill fill the winter stores(Lv 105)") == "Doing" then
 return stocked("Ill fill the winter stores(Lv 105)") and "Shiro_CatchReturn" or "Shiro_CatchWaiting";
 end;

 local PlayerQuestState = Quests.GetPlayerQuestState(Players.LocalPlayer, "Ill help you survive the winter(Lv 100)");

 if PlayerQuestState == "Doing" then
 return stocked("Ill help you survive the winter(Lv 100)") and "Shiro_Return" or "Shiro_Waiting";
 end;

 if PlayerQuestState == "Done" then
 return "Shiro_Catch";
 end;
 end
 },
 Shiro_2 = {
 Text = "Before you go through that gate, there\'s something you should know.",
 Answers = true,
 IfTrue = "Shiro_3"
 },
 Shiro_3 = {
 Answers = true,
 IfTrue = "Shiro_3b",
 Text = `{NameTag("Iceveil Settlement")} is running [dangerously low on supplies]<Color=(1,.3,.3)>.`
 },
 Shiro_3b = {
 Answers = true,
 IfTrue = "Shiro_4",
 Text = `We trade timber down to {NameTag("Windy Peak")} for food. [Bandits work that road]<Color=(1,.3,.3)>.`
 },
 Shiro_4 = {
 Text = "We\'re doing everything we can to keep the people behind these walls alive.",
 Answers = true,
 IfTrue = "Shiro_5"
 },
 Shiro_5 = {
 Text = "You want in, you help us survive the winter.",
 Answers = true,
 IfTrue = "Shiro_6"
 },
 Shiro_6 = {
 Answers = true,
 IfTrue = "Shiro_7",
 Text = `[Nine]<Color=(1,.85,.3)> {NameTag("Cooked Bear Meat")}, to feed the families.`
 },
 Shiro_7 = {
 Answers = true,
 IfTrue = "Shiro_8",
 Text = `[25]<Color=(1,.85,.3)> {NameTag("Health Elixir")}, for the wounded.`
 },
 Shiro_8 = {
 Answers = true,
 IfTrue = "Shiro_9",
 Text = `{NameTag("Lucy")} in {NameTag("Windy Peak")} cooks the meat. Her pantry run earns it.`
 },
 Shiro_9 = {
 Answers = true,
 IfTrue = "Shiro_10",
 Text = `{NameTag("Alchemist Meku")} brews the elixirs in {NameTag("Mistfall Harbor")}. He'll want {NameTag("Demon Horns")}.`
 },
 Shiro_10 = {
 Text = "Fetch it first. I\'m not going anywhere, and the [stores]<Color=(1,.85,.3)> are right behind me when you are.",
 Answers = {
 Close = "",
 ["Ill help you survive the winter(Lv 100)"] = "AddQuest"
 }
 },
 Shiro_Waiting = {
 Answers = true,
 Text = `{NameTag("Lucy")}'s pantry, {NameTag("Alchemist Meku")}'s shop. Load the stores behind me and come tell me.`
 },
 Shiro_Return = {
 Text = "That\'s the stores loaded, then.",
 Answers = {
 Close = "",
 ["The settlement is stocked"] = "DeliverSuppliesToShiro"
 }
 },
 Shiro_Thanks = {
 Text = "You actually brought everything.",
 Answers = true,
 IfTrue = "Shiro_Thanks2"
 },
 Shiro_Thanks2 = {
 Text = "The meat feeds our families. The elixirs keep our wounded alive until the road opens.",
 Answers = true,
 IfTrue = "Shiro_Thanks3"
 },
 Shiro_Thanks3 = {
 Text = "Most travelers would have turned around and left.",
 Answers = true,
 IfTrue = "Shiro_Thanks4"
 },
 Shiro_Thanks4 = {
 Text = "You chose to help.",
 Answers = true,
 IfTrue = "Shiro_Thanks5"
 },
 Shiro_Thanks5 = {
 Text = "[The gates of Iceveil Settlement are open to you.]<Style=Rainbow>",
 Answers = true
 },
 Shiro_Catch = {
 Text = "Gate\'s yours. If you want steady work, the stores still run dry.",
 Answers = true,
 IfTrue = "Shiro_Catch2"
 },
 Shiro_Catch2 = {
 Text = "The river doesn\'t care about bandits. Fish it.",
 Answers = true,
 IfTrue = "Shiro_Catch3"
 },
 Shiro_Catch3 = {
 Answers = true,
 IfTrue = "Shiro_Catch4",
 Text = `[Twelve]<Color=(1,.85,.3)> each of {NameTag("Golden Fish")}, {NameTag("Clown Fish")} and {NameTag("Zebra Fish")}.`
 },
 Shiro_Catch4 = {
 Answers = true,
 IfTrue = "Shiro_Catch5",
 Text = `[Two]<Color=(1,.85,.3)> each of {NameTag("Crustadon")} and {NameTag("Krathulon")}. Those two run deep. [A common line won't reach them]<Color=(1,.3,.3)>.`
 },
 Shiro_Catch5 = {
 Text = "Stores are behind me. Load them, then tell me.",
 Answers = {
 Close = "",
 ["Ill fill the winter stores(Lv 105)"] = "AddQuest"
 }
 },
 Shiro_CatchWaiting = {
 Text = "Stores are behind me. Fill them.",
 Answers = true
 },
 Shiro_CatchReturn = {
 Text = "That\'s a full load of fish, then.",
 Answers = {
 Close = "",
 ["The stores are full"] = "DeliverWinterCatchToShiro"
 }
 },
 Shiro_CatchThanks = {
 Text = "Good. That\'s the pots full a while longer.",
 Answers = true,
 IfTrue = "Shiro_CatchThanks2"
 },
 Shiro_CatchThanks2 = {
 Text = "Come back when you\'ve fished more. The winter isn\'t done with us.",
 Answers = true
 },
 Shiro_Short = {
 Text = "The stores aren\'t full yet.",
 Answers = true
 }
};
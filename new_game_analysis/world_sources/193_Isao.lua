-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local NameTag = Utility.NameTag;

local function holdsToll(p1: userdata) -- Line: 8
 for _, v in { "Crustadon", "Krathulon" } do
 local v2 = p1:FindFirstChild(v);
 local v3;

 if v2 == nil then
 v3 = nil;
 else
 v3 = v2:FindFirstChild("Amount") or nil;
 end;

 if v2 == nil or (v3 == nil and 1 or (v3.Value or 1)) < 2 then
 return false;
 end;
 end;

 return true;
end;

return {
 ["Legendary Fisherman Isao"] = {
 Text = "That\'s my lure in your hand.",
 Answers = true,
 IfTrue = "Isao_2",

 BeforeRun = function(p4, p5) -- Line: 19, Name: BeforeRun
 -- upvalues: Utility (copy), Players (copy), holdsToll (copy)
 local Data = Utility.GetData(Players.LocalPlayer);
 local v6;

 if Data == nil then
 v6 = nil;
 else
 v6 = Data.Inventory.Inventory or nil;
 end;

 if v6 == nil or v6:FindFirstChild("Drowned Lure") == nil then
 return "Isao_Silent";
 end;

 if v6:FindFirstChild("Legendary Fishing Rod") ~= nil then
 return "Isao_Silent";
 end;

 local WorldEvents = Data:FindFirstChild("WorldEvents");

 return WorldEvents ~= nil and WorldEvents:FindFirstChild("DrownedLine_Paid") ~= nil and "Isao_Paid" or (not holdsToll(v6) and (v6:FindFirstChild("Crustadon") == nil and v6:FindFirstChild("Krathulon") == nil and "Isao_Owed" or "Isao_Short") or nil);
 end
 },
 Isao_2 = {
 Text = "I went down with it, twenty years back. Never came up.",
 Answers = true,
 IfTrue = "Isao_3"
 },
 Isao_3 = {
 Text = `And you've brought what took me. Two {NameTag("Crustadon")}, two {NameTag("Krathulon")}.`,
 Answers = {
 Close = "",
 ["What do you want from me?"] = "Isao_4"
 }
 },
 Isao_4 = {
 Text = "Nothing from you. There\'s a debt to the water in my name, and twenty years haven\'t paid it.",
 Answers = true,
 IfTrue = "Isao_5"
 },
 Isao_5 = {
 Text = "Settle it, and I\'ll tell you where my rod went down.",
 Answers = {
 Close = "",
 ["Give the fish to the water"] = "IsaoTakeToll"
 }
 },
 Isao_Toll = {
 Text = "It\'s done. Twenty years.",
 Answers = true,
 IfTrue = "Isao_Toll2"
 },
 Isao_Toll2 = {
 Text = "My rod\'s on the bottom, downriver of where I worked. Past two drops.",
 Answers = true,
 IfTrue = "Isao_Toll3"
 },
 Isao_Toll3 = {
 Text = "There\'s a tree grown out over the ledge there. That\'s where I went in.",
 Answers = true,
 IfTrue = "Isao_Toll4"
 },
 Isao_Toll4 = {
 Text = "Raise it and keep it. I\'ve no hands left for a rod.",
 Answers = true,
 IfTrue = "Isao_Toll5"
 },
 Isao_Toll5 = {
 Text = "The river knows my lure.",
 Answers = true,
 IfTrue = "Isao_Toll6"
 },
 Isao_Toll6 = {
 Text = "But the rod won\'t rise for someone trying to catch a fish. That was always my trouble.",
 Answers = true,
 IfTrue = "Isao_Toll7"
 },
 Isao_Toll7 = {
 Text = "Anything you pull up out there is the water telling you no. Anything at all.",
 Answers = true
 },
 Isao_Short = {
 Text = "That\'s my lure in your hand.",
 Answers = true,
 IfTrue = "Isao_Short2"
 },
 Isao_Short2 = {
 Text = "Two of each. That\'s what took me, and that\'s what the water\'s owed.",
 Answers = true
 },
 Isao_Owed = {
 Text = "That\'s my lure in your hand.",
 Answers = true,
 IfTrue = "Isao_Owed2"
 },
 Isao_Owed2 = {
 Text = "I went down with it, twenty years back. Never came up.",
 Answers = true,
 IfTrue = "Isao_Owed3"
 },
 Isao_Owed3 = {
 Answers = true,
 Text = `Two {NameTag("Crustadon")}, two {NameTag("Krathulon")}. That's what took me, and that's what the water's owed.`
 },
 Isao_Paid = {
 Text = "The water\'s been paid, and I\'ve nothing new to say.",
 Answers = true,
 IfTrue = "Isao_Paid2"
 },
 Isao_Paid2 = {
 Text = "Downriver of where I worked. Past two drops, the tree over the ledge. It hasn\'t moved.",
 Answers = true
 },
 Isao_Silent = {
 Text = "...",
 Answers = 1
 }
};
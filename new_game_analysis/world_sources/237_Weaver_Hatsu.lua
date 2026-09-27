-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Utility = require(ReplicatedStorage.CAM.Global.Utility);

return {
 ["Weaver Hatsu"] = {
 Text = "I cut cloth for people who walk into the dark. Most of it never comes back.",
 Answers = true,
 IfTrue = "Cape_2",

 BeforeRun = function(p1, p2) -- Line: 14, Name: BeforeRun
 -- upvalues: Utility (copy), Players (copy)
 local Data = Utility.GetData(Players.LocalPlayer);
 local v3;

 if Data == nil then
 v3 = nil;
 else
 v3 = Data.Inventory.Inventory;
 end;

 if v3 == nil then
 return nil;
 end;

 return v3:FindFirstChild("Nightfall Cape Schematic") ~= nil and "Cape_Done" or (v3:FindFirstChild("Lost Cape") ~= nil and "Cape_Offer" or nil);
 end
 },
 Cape_2 = {
 Text = "When a cape does come back, it comes back wrong. Torn in ways no blade makes. I have been waiting to hold one.",
 Answers = {
 Close = ""
 }
 },
 Cape_Offer = {
 Text = "That cape. Give it here. I want to draw what it was before the dark got into it.",
 Answers = {
 ["Hand it over"] = "CapeTrade",
 ["Not yet"] = ""
 }
 },
 Cape_Given = {
 Text = "There. Every tear, and the line it should have followed. A smith can cut the rest from that.",
 Answers = {
 Close = ""
 }
 },
 Cape_NoPiece = {
 Text = "That is not the cape. Bring me the cape.",
 Answers = true
 },
 Cape_Done = {
 Text = `I drew it once, and once is what the {Utility.NameTag("drawings")} are for. Go and have it made.`,
 Answers = {
 Close = ""
 }
 }
};
-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Utility = require(ReplicatedStorage.CAM.Global.Utility);

return {
 ["Tailor Omi"] = {
 Text = "Every stitch I know, I learned off a dead man\'s coat.",
 Answers = true,
 IfTrue = "Haori_2",

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

 return v3:FindFirstChild("Firstlight Haori Schematic") ~= nil and "Haori_Done" or (v3:FindFirstChild("Lost Outfit") ~= nil and "Haori_Offer" or nil);
 end
 },
 Haori_2 = {
 Text = "There is one seam I never learned. It only turns up on clothes that came back from somewhere they should not have been.",
 Answers = {
 Close = ""
 }
 },
 Haori_Offer = {
 Text = "Those clothes. Set them on the table. The seam is in there, under all of that.",
 Answers = {
 ["Hand them over"] = "HaoriTrade",
 ["Not yet"] = ""
 }
 },
 Haori_Given = {
 Text = "Fifty years, and there it was. I have put it on paper for you, seam by seam. Find a smith for the rest.",
 Answers = {
 Close = ""
 }
 },
 Haori_NoPiece = {
 Text = "My eyes are old, but not that old. Those are not the clothes.",
 Answers = true
 },
 Haori_Done = {
 Text = `You carry the {Utility.NameTag("drawings")}. My hands would not manage them twice.`,
 Answers = {
 Close = ""
 }
 }
};
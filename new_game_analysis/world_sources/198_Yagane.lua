-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local v1;

if RunService:IsClient() then
 v1 = require(ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.Blacksmith);
else
 v1 = nil;
end;

local v2;

if v1 == nil then
 v2 = nil;
else
 v2 = v1({
 Station = "Hidden Mist"
 }) or nil;
end;

return {
 Yagane = {
 Text = "Armoury. I issue first blades. What do you need?",

 BeforeRun = function(p3, p4) -- Line: 30, Name: BeforeRun
 -- upvalues: Utility (copy), Players (copy)
 local Data = Utility.GetData(Players.LocalPlayer);
 local v5 = Data ~= nil and Data.Inventory.Inventory or nil;

 return (v5 == nil or v5:FindFirstChild("Crude Iron Ingot") == nil) and "Yagane_NoIron" or nil;
 end,

 Answers = {
 ["Forge me a blade"] = "Yagane_Forge",
 Farewell = "Yagane_Bye"
 }
 },
 Yagane_NoIron = {
 Text = "No ingot in your kit. Nothing leaves the rack.",
 Answers = true,
 IfTrue = "Yagane_NoIron2"
 },
 Yagane_NoIron2 = {
 Text = "[Crude Iron]<Color=(.31,.73,1)> is issued at [Final Selection]<Color=(1,.3,.3)>. Not here.",
 Answers = true
 },
 Yagane_Forge = {
 Text = "Choose a pattern. Same weight, same edge.",
 Content = v2,
 Answers = {
 Back = "Yagane",
 Farewell = "Yagane_Bye"
 }
 },
 Yagane_Bye = {
 Text = "Take care with Corps property.",
 Answers = 1
 }
};
-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local v1;

if game:GetService("RunService"):IsClient() then
 v1 = require(ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.Refinement);
else
 v1 = nil;
end;

return {
 ["Refiner Hagane"] = {
 Text = "Steel remembers every strike. Bring me your weapons and rods, and I will draw more out of them.",
 Answers = true,
 IfTrue = "Hagane_Forge"
 },
 Hagane_Forge = {
 Text = "Pick a piece, and we will see what the forge says.",
 Content = v1 ~= nil and v1() or nil,
 Answers = {
 Farewell = "Hagane_Bye"
 }
 },
 Hagane_Bye = {
 Text = "Keep your edge, slayer.",
 Answers = 1
 }
};
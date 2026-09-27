-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local v1;

if game:GetService("RunService"):IsClient() then
 v1 = require(ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.Shop);
else
 v1 = nil;
end;

local v2 = { "Health Elixir", "Stamina Regen Elixir", "Health Regen Elixir", "Underwater Breathing Potion" };
local v3 = {
 ["Alchemist Meku"] = {
 Text = "You interested in [Elixirs]<Color=(1,.85,.3)>?",
 Answers = true,
 IfTrue = "Alchemist Meku_2"
 }
};
local v6 = {
 Text = "Take a look, they are [high quality]<Color=(1,.85,.3)>.",

 OnShow = function(p4, p5) -- Line: 25, Name: OnShow
 p5.CartShopNode = "Alchemist Meku_2";
 end
};
local v7;

if v1 == nil then
 v7 = nil;
else
 v7 = v1(v2) or nil;
end;

v6.Content = v7;
v6.Answers = {
 ["Buy the selection"] = "ReviewCartPurchase",
 Farewell = ""
};
v3["Alchemist Meku_2"] = v6;

return v3;
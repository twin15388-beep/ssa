-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local v1;

if RunService:IsClient() then
 v1 = require(ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.Shop);
else
 v1 = nil;
end;

local v2 = { "Urokodaki\'s Mask", "Stylish Boa", "Sun Eve Drape", "Peppermint Scarf", "Heart of Night Necklace", "Tidal Earrings", "Cherry Blossom Lantern", "Crown of the Brave", "Black Dragon Horns", "Solstice Necklace", "Black-Cord Necklace", "Ivory edge Cloak" };
local v3 = {
 Kuro = {
 Text = "Well now... not many travelers find me out here [after dark]<Style=Fade,Color=(.6,.6,1)>.",
 Answers = true,
 IfTrue = "Kuro_2"
 }
};
local v6 = {
 Text = "Here\'s my [inventory]<Color=(1,.85,.3)>, buy what you think you need.",

 OnShow = function(p4, p5) -- Line: 36, Name: OnShow
 p5.CartShopNode = "Kuro_2";
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
 Farewell = "Kuro_Farewell"
};
v3.Kuro_2 = v6;
v3.Kuro_Farewell = {
 Answers = 1,
 Text = `Keep your coin [#]<img={BunchaIcons.WenRaw}> close… we may meet again [when the moon rises.]<Style=Fade,Color=(.6,.6,1)>`
};

return v3;
-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local TimedVendor = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.TimedVendor);
local u1;

if RunService:IsClient() then
 u1 = require(ReplicatedStorage.CAM.Client.Components.Client.DialogueComponent.Components.Shop);
else
 u1 = nil;
end;

return {
 ["Black Marketer"] = {
 Text = "You look like someone who understands the [true value]<Color=(.8,.7,1)> of things.",
 Answers = true,
 IfTrue = "Black Marketer_2"
 },
 ["Black Marketer_2"] = {
 Text = "See anything you like? I don\'t [stay long]<Style=Fade,Color=(1,.3,.3)>.",

 OnShow = function(p2, p3) -- Line: 19, Name: OnShow
 p3.CartShopNode = "Black Marketer_2";
 end,

 Content = u1 ~= nil and function(p4, p5, p6, p7) -- Line: 23
 -- upvalues: u1 (copy), TimedVendor (copy)
 return u1(TimedVendor.GetStockNames("Black Marketer"))(p4, p5, p6, p7);
 end or nil,
 Answers = {
 ["Buy the selection"] = "ReviewCartPurchase",
 Farewell = "Black Marketer_Farewell"
 }
 },
 ["Black Marketer_Farewell"] = {
 Answers = 1,
 Text = `Keep your coin [#]<img={BunchaIcons.WenRaw}> ready… I move on [before anyone asks questions.]<Style=Fade,Color=(.8,.7,1)>`
 }
};
-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local SpinBalance = require(ReplicatedStorage.CAM.Global.SpinBalance);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local u1;

if RunService:IsServer() then
 u1 = require(game:GetService("ServerStorage").SAM.Services.AnalyticsService);
else
 u1 = nil;
end;

return {
 FormulateTextPlusText = function(p2: number) -- Line: 21, Name: FormulateTextPlusText
 -- upvalues: BunchaIcons (copy), Utility (copy), gameSettings (copy)
 return `[#]<img={BunchaIcons.SpinsIconRaw}> [{Utility.addCommasToNumber(p2)} Spins]<{gameSettings.RichTextPopularConfigs.SoroundColor}>`;
 end,

 FormulateRichText = function(p3: number) -- Line: 25, Name: FormulateRichText
 -- upvalues: gameSettings (copy), Utility (copy)
 return `<font {string.lower(gameSettings.RichTextPopularConfigs.SoroundColorRBX)}>{Utility.addCommasToNumber(p3)} Spins</font>`;
 end,

 GetContent = function(p4: number) -- Line: 30, Name: GetContent
 -- upvalues: BunchaIcons (copy)
 return {
 Icon = BunchaIcons.SpinsIcon,
 Price = p4
 };
 end,

 CanBuy = function(p5: userdata, p6: number) -- Line: 34, Name: CanBuy
 -- upvalues: SpinBalance (copy)
 return p6 <= SpinBalance.Total(p5, false);
 end,

 Buy = function(p7: userdata, p8: number, p9: userdata?, p10: string?) -- Line: 38, Name: Buy
 -- upvalues: SpinBalance (copy), u1 (ref)
 if not SpinBalance.Charge(p7, false, p8) then
 return;
 end;

 if u1 ~= nil and p9 ~= nil then
 u1.Economy(p9, "Spins", "Sink", p8, "ShopPurchase", p10);
 end;
 end
};
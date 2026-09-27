-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local u1, u2;

if RunService:IsServer() then
 u1 = require(game:GetService("ServerStorage").SAM.Services.AnalyticsService);
 u2 = require(game:GetService("ServerStorage").SAM.Services.DiscordLogService);
else
 u2 = nil;
 u1 = nil;
end;

return {
 FormulateTextPlusText = function(p3: number) -- Line: 18, Name: FormulateTextPlusText
 -- upvalues: Utility (copy), BunchaIcons (copy)
 return `${Utility.addCommasToNumber(p3)} [#]<img={BunchaIcons.WenRaw}>`;
 end,

 FormulateRichText = function(p4: number) -- Line: 24, Name: FormulateRichText
 -- upvalues: Utility (copy)
 return `<font color="rgb(214,253,61)">{Utility.addCommasToNumber(p4)} Wen</font>`;
 end,

 GetContent = function(p5: number) -- Line: 29, Name: GetContent
 -- upvalues: BunchaIcons (copy)
 return {
 Icon = BunchaIcons.Wen,
 Price = p5
 };
 end,

 CanBuy = function(p6: userdata, p7: number) -- Line: 33, Name: CanBuy
 return p7 <= p6.Wen.Value;
 end,

 Buy = function(p8: userdata, p9: number, p10: userdata?, p11: string?) -- Line: 40, Name: Buy
 -- upvalues: u2 (ref), u1 (ref)
 if u2 ~= nil and p10 ~= nil then
 u2.ExpectWen(p10);
 end;

 local Wen = p8.Wen;
 Wen.Value = Wen.Value - p9;

 if u1 ~= nil and p10 ~= nil then
 u1.Economy(p10, "Wen", "Sink", p9, "ShopPurchase", p11);
 end;
 end
};
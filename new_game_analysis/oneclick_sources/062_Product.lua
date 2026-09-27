-- Decompiled with Potassium's decompiler.

local MarketplaceService = game:GetService("MarketplaceService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local u1 = {
 Deferred = true
};
local u2 = RunService:IsServer();
local u3 = {};

local function getInfo(p4: number) -- Line: 20
 -- upvalues: u3 (copy), MarketplaceService (copy), u2 (copy)
 local v5 = u3[p4];

 if v5 ~= nil then
 return v5;
 end;

 local success, result = pcall(MarketplaceService.GetProductInfoAsync, MarketplaceService, p4, Enum.InfoType.Product);

 if not (success and (result ~= nil and result.PriceInRobux ~= nil)) then
 return nil;
 end;

 local v6 = tonumber(result.IconImageAssetId);
 local v7 = {
 Price = result.PriceInRobux
 };
 local v8;

 if v6 == nil or v6 <= 0 then
 v8 = nil;
 else
 v8 = `rbxassetid://{v6}`;
 end;

 v7.Icon = v8;
 u3[p4] = v7;

 if u2 then
 script:SetAttribute(`BasePrice_{p4}`, result.PriceInRobux);
 end;

 return v7;
end;

function u1.GetRobuxPrice(p9: number) -- Line: 42
 -- upvalues: getInfo (copy)
 local v10 = getInfo(p9);

 return v10 ~= nil and v10.Price or nil;
end;

function u1.GetBaseRobuxPrice(p11: number) -- Line: 50
 -- upvalues: u2 (copy), u1 (copy)
 if u2 then
 return u1.GetRobuxPrice(p11);
 end;

 return script:GetAttribute((`BasePrice_{p11}`));
end;

function u1.GetProductIcon(p12: number) -- Line: 58
 -- upvalues: getInfo (copy)
 local v13 = getInfo(p12);

 return v13 ~= nil and v13.Icon or nil;
end;

function u1.FormulateTextPlusText(p14: number) -- Line: 63
 -- upvalues: u1 (copy), Utility (copy), BunchaIcons (copy)
 local RobuxPrice = u1.GetRobuxPrice(p14);

 if RobuxPrice == nil then
 return nil;
 end;

 return `{Utility.addCommasToNumber(RobuxPrice)} [#]<img={BunchaIcons.Robux}>`;
end;

function u1.FormulateRichText(p15: number) -- Line: 69
 -- upvalues: u1 (copy), Utility (copy)
 local RobuxPrice = u1.GetRobuxPrice(p15);

 if RobuxPrice == nil then
 return nil;
 end;

 return `<font color="rgb(255,255,255)">{Utility.addCommasToNumber(RobuxPrice)} Robux</font>`;
end;

function u1.GetContent(p16: number) -- Line: 77
 -- upvalues: u1 (copy), BunchaIcons (copy), gameSettings (copy)
 local RobuxPrice = u1.GetRobuxPrice(p16);

 return RobuxPrice ~= nil and {
 Icon = BunchaIcons.Robux,
 Price = RobuxPrice,
 Color = gameSettings.robuxColor
 } or nil;
end;

function u1.CanBuy(p17: userdata, p18: number) -- Line: 85
 return true;
end;

function u1.Buy(p19: userdata, p20: number, p21: userdata?, p22: string?) -- Line: 91
 -- upvalues: MarketplaceService (copy)
 if p21 == nil then
 return;
 end;

 MarketplaceService:PromptProductPurchase(p21, p20);
end;

return u1;
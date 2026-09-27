-- Decompiled with Potassium's decompiler.

local MarketplaceService = game:GetService("MarketplaceService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local u1 = {
 Deferred = true
};
local u2 = {};

function u1.GetRobuxPrice(p3: number) -- Line: 18
 -- upvalues: u2 (copy), MarketplaceService (copy)
 local v4 = u2[p3];

 if v4 ~= nil then
 return v4;
 end;

 local success, result = pcall(MarketplaceService.GetProductInfoAsync, MarketplaceService, p3, Enum.InfoType.GamePass);

 if not (success and (result ~= nil and result.PriceInRobux ~= nil)) then
 return nil;
 end;

 u2[p3] = result.PriceInRobux;

 return result.PriceInRobux;
end;

local u5 = {};

local function ownedKey(p6: number, p7: number) -- Line: 33
 return p6 .. "_" .. p7;
end;

MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(p8: userdata, p9: number, p10: boolean) -- Line: 36
 -- upvalues: u5 (copy)
 if p10 then
 u5[p8.UserId .. "_" .. p9] = true;
 end;
end);

function u1.OwnsGamepass(p11: number, p12: number) -- Line: 41
 -- upvalues: u5 (copy), MarketplaceService (copy)
 local v13 = p11 .. "_" .. p12;

 if u5[v13] then
 return true;
 end;

 local success, result = pcall(MarketplaceService.UserOwnsGamePassAsync, MarketplaceService, p11, p12);

 if not success or result ~= true then
 return false;
 end;

 u5[v13] = true;

 return true;
end;

function u1.FormulateTextPlusText(p14: number) -- Line: 52
 -- upvalues: u1 (copy), Utility (copy), BunchaIcons (copy)
 local RobuxPrice = u1.GetRobuxPrice(p14);

 if RobuxPrice == nil then
 return nil;
 end;

 return `{Utility.addCommasToNumber(RobuxPrice)} [#]<img={BunchaIcons.Robux}>`;
end;

function u1.FormulateRichText(p15: number) -- Line: 58
 -- upvalues: u1 (copy), Utility (copy)
 local RobuxPrice = u1.GetRobuxPrice(p15);

 if RobuxPrice == nil then
 return nil;
 end;

 return `<font color="rgb(255,255,255)">{Utility.addCommasToNumber(RobuxPrice)} Robux</font>`;
end;

function u1.GetContent(p16: number) -- Line: 65
 -- upvalues: u1 (copy), BunchaIcons (copy), gameSettings (copy)
 local RobuxPrice = u1.GetRobuxPrice(p16);

 return RobuxPrice ~= nil and {
 Icon = BunchaIcons.Robux,
 Price = RobuxPrice,
 Color = gameSettings.robuxColor
 } or nil;
end;

function u1.CanBuy(p17: userdata, p18: number) -- Line: 73
 -- upvalues: Players (copy), u1 (copy)
 local v19;

 if p17.Parent == nil then
 v19 = nil;
 else
 v19 = p17.Parent.Parent or nil;
 end;

 local v20;

 if v19 == nil then
 v20 = nil;
 else
 v20 = Players:FindFirstChild(v19.Name);
 end;

 if v20 == nil then
 return false;
 end;

 return not u1.OwnsGamepass(v20.UserId, p18);
end;

function u1.Buy(p21: userdata, p22: number, p23: userdata?, p24: string?) -- Line: 84
 -- upvalues: MarketplaceService (copy)
 if p23 == nil then
 return;
 end;

 MarketplaceService:PromptGamePassPurchase(p23, p22);
end;

return u1;
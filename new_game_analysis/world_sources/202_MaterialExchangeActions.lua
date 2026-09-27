-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local u1;

if RunService:IsClient() then
 u1 = require(ReplicatedStorage.CAM.Global.Subsets.Classes.PopUpCreator);
else
 u1 = nil;
end;

local u2;

if RunService:IsClient() then
 u2 = require(ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
else
 u2 = nil;
end;

local SignalFunction = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalFunction);
local u3 = false;

local function picked(p4) -- Line: 12
 local Exchange = p4.Exchange;
 local v5;

 if typeof(Exchange) == "table" and (Exchange.Give ~= nil and Exchange.Take ~= nil) then
 v5 = Exchange.Amount ~= nil;
 else
 v5 = false;
 end;

 return v5;
end;

return {
 ToganeExchangeReview = function(p6, p7) -- Line: 18, Name: ToganeExchangeReview
 local Exchange = p7.Exchange;
 local v8;

 if typeof(Exchange) == "table" and (Exchange.Give ~= nil and Exchange.Take ~= nil) then
 v8 = Exchange.Amount ~= nil;
 else
 v8 = false;
 end;

 return v8 and "Togane_ExchangeConfirm" or "Togane_ExchangeNothing";
 end,

 ToganeExchange = function(p9, p10) -- Line: 22, Name: ToganeExchange
 -- upvalues: u3 (ref), u1 (copy), SignalFunction (copy), u2 (copy), ReplicatedStorage (copy)
 if u3 then
 return "Togane_ExchangeConfirm";
 end;

 local Exchange = p10.Exchange;
 local v11;

 if typeof(Exchange) == "table" and (Exchange.Give ~= nil and Exchange.Take ~= nil) then
 v11 = Exchange.Amount ~= nil;
 else
 v11 = false;
 end;

 if not v11 then
 return "Togane_ExchangeNothing";
 end;

 u3 = true;
 local v12;

 if u1 == nil then
 v12 = nil;
 else
 v12 = u1.new({
 Type = "LoadingFull"
 }) or nil;
 end;

 local v13 = SignalFunction.ToServer("MaterialExchange", p10.Exchange);

 if v12 ~= nil then
 v12:Destroy();
 end;

 u3 = false;
 p10.Exchange = nil;

 if u2 ~= nil then
 u2.PlaySound(ReplicatedStorage.Assets.Sounds.Misc, v13 == true and "Money_Kaching" or "denied_old", script, true);
 end;

 return v13 == true and "Togane_ExchangeDone" or "Togane_ExchangeFail";
 end
};
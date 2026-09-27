-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local u1;

if RunService:IsClient() then
 u1 = require(ReplicatedStorage.CAM.DebrisModule);
else
 u1 = nil;
end;

local u2;

if RunService:IsClient() then
 u2 = require(ReplicatedStorage.CAM.Global.Subsets.Classes.PopUpCreator);
else
 u2 = nil;
end;

local SignalFunction = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalFunction);
local DeliverAction = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests.DeliverAction);

local function playSound(p3: string) -- Line: 15
 -- upvalues: ReplicatedStorage (copy), u1 (copy)
 local v4 = ReplicatedStorage.Assets.Sounds.Misc:FindFirstChild(p3);

 if v4 == nil or u1 == nil then
 return;
 end;

 local v5 = v4:Clone();
 v5.Parent = script;
 v5:Play();
 u1:AddItem(v5, v5.TimeLength);
end;

local u6 = false;

local function selectionCount(p7) -- Line: 26
 local v8 = 0;

 if typeof(p7.SellSelection) == "table" then
 for _, v in p7.SellSelection do
 v8 = v8 + v;
 end;
 end;

 return v8;
end;

return {
 DeliverJewelryBoxToGinzo = DeliverAction("Ill find the jewelry box(Lv 45)", "Return to Ginzo", "Ginzo_Thanks", "Ginzo_NoBox"),

 GinzoReview = function(p9, p10) -- Line: 40, Name: GinzoReview
 local v11 = 0;

 if typeof(p10.SellSelection) == "table" then
 for _, v in p10.SellSelection do
 v11 = v11 + v;
 end;
 end;

 return v11 < 1 and "Ginzo_Nothing" or "Ginzo_Confirm";
 end,

 GinzoSell = function(p12, p13) -- Line: 49, Name: GinzoSell
 -- upvalues: u6 (ref), u2 (copy), SignalFunction (copy), playSound (copy)
 if u6 then
 return "Ginzo_Confirm";
 end;

 local v14 = 0;

 if typeof(p13.SellSelection) == "table" then
 for _, v in p13.SellSelection do
 v14 = v14 + v;
 end;
 end;

 if v14 < 1 then
 return "Ginzo_Nothing";
 end;

 u6 = true;
 local v15;

 if u2 == nil then
 v15 = nil;
 else
 v15 = u2.new({
 Type = "LoadingFull"
 }) or nil;
 end;

 local v16 = SignalFunction.ToServer("SellItems", p13.SellSelection);

 if v15 ~= nil then
 v15:Destroy();
 end;

 u6 = false;
 p13.SellSelection = nil;

 if typeof(v16) ~= "table" or next(v16) == nil then
 playSound("denied_old");

 return "Ginzo_NoSale";
 end;

 p13.SoldFor = v16;
 playSound("Money_Kaching");

 return "Ginzo_Sold";
 end
};
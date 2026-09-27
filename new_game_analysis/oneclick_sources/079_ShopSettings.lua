-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Menum = require(ReplicatedStorage.CAM.Global.Menum);
local v1 = {};

for _, v in require(ReplicatedStorage.CAM.Global.shopSettings) do
 if typeof(v) == "table" then
 for _, v2 in v do
 if typeof(v2) == "table" and (v2.Name ~= nil and v2.ProductId ~= nil) then
 v1[v2.Name] = {
 Type = Menum.ShopItemType.Product,
 Price = {
 Product = v2.ProductId
 },
 AllowOre = v2.RobuxOnly ~= true,
 Reward = v2.Reward,
 RewardAmount = v2.RewardAmount,
 ListedPrice = v2.ListedPrice,
 RequiresVIP = v2.RequiresVIP,
 RequiresGamepass = v2.RequiresGamepass,
 AskFirst = v2.AskFirst
 };
 end;
 end;
 end;
end;

return v1;
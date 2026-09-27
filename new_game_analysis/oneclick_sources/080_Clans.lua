-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Menum = require(ReplicatedStorage.CAM.Global.Menum);
local Clan = require(ReplicatedStorage.CAM.Global.Spinners).Clan;
local v1 = Clan.Odds();
local v2 = {};

for _, v in Clan.Pool() do
 local v3 = v1[v];

 if v3 ~= nil and v3 > 0 then
 v2[v] = {
 Type = Menum.ShopItemType.Clan,
 Clan = v,
 Price = {
 Spins = math.ceil(Clan.Cost / v3)
 }
 };
 end;
end;

return v2;
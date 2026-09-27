-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Menum = require(ReplicatedStorage.CAM.Global.Menum);
local Spinners = require(ReplicatedStorage.CAM.Global.Spinners);
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local MuzanSettings = require(ReplicatedStorage.CAM.Global.MuzanSettings);
local EvilArt = Spinners.EvilArt;
local v1 = EvilArt.Odds();
local v2 = {};

for _, v in EvilArt.Pool() do
 local v3 = v1[v];

 if v3 ~= nil and v3 > 0 then
 v2[`{v} Orb`] = {
 AutoEquip = true,
 Type = Menum.ShopItemType.IngameItem,
 Price = {
 Spins = math.ceil(EvilArt.Cost / v3 - 1e-6)
 },
 Shout = {
 Icon = BunchaIcons.MuzanIcon,
 Text = MuzanSettings.OrbShoutText,
 Duration = MuzanSettings.GrantShoutDuration
 }
 };
 end;
end;

return v2;
-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local v1 = {};
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);
local Skill_Info = require(ReplicatedStorage.CAM.Global.PlayerProfile.Skill_Info);
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local Resolve = require(ReplicatedStorage.CAM.Global.Powers.Resolve);
local Color3_new_ret = Color3.new(1, 1, 1);
local Color3_new_ret2 = Color3.new(1, 1, 1);
local Color3_new_ret3 = Color3.new(1, 0.85, 0.3);
local u2 = {
 Wen = {
 Icon = "rbxassetid://119954170187936",
 Color = gameSettings.wenColor
 },
 Exp = {
 Icon = BunchaIcons.Exp,
 Color = gameSettings.lvlColor
 },
 FlatMastery = {
 Icon = BunchaIcons.Mastery,
 Color = gameSettings.masteryColor
 },
 Spins = {
 Icon = BunchaIcons.Spins3D,
 Color = Color3.fromRGB(255, 176, 0)
 }
};

function v1.GetIconAndColor(p3: string, p4: any) -- Line: 38
 -- upvalues: Resolve (copy), Color3_new_ret3 (copy), u2 (copy), Items (copy), Color3_new_ret (copy), Skill_Info (copy), Color3_new_ret2 (copy)
 if p3 == nil then
 return;
 end;

 if p3 == "Power" then
 local v5 = Resolve.Icon(Resolve.NameOf(p4));

 if v5 ~= nil then
 return v5, Color3_new_ret3;
 end;
 end;

 if u2[p3] then
 return u2[p3].Icon, u2[p3].Color;
 end;

 if Items[p3] then
 return Items[p3].Icon, Color3_new_ret;
 end;

 if Skill_Info[p3] then
 return Skill_Info[p3].Icon, Color3_new_ret2;
 end;
end;

return v1;
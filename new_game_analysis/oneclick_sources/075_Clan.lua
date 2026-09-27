-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local Clans = require(ReplicatedStorage.CAM.Clans);
local DiscordLogService = require(ServerStorage.SAM.Services.DiscordLogService);

return function(p1: userdata, p2: userdata, p3: string, p4: number, p5: any) -- Line: 13
 -- upvalues: Clans (copy), DiscordLogService (copy)
 local v6;

 if p5 == nil then
 v6 = nil;
 else
 v6 = p5.Clan or nil;
 end;

 if v6 == nil or (Clans.GetClan(v6) == nil or Clans.TestClans[v6] ~= nil) then
 return false, `"{tostring(v6)}" is not a purchasable clan`;
 end;

 local v7;

 if p2 == nil then
 v7 = nil;
 else
 v7 = p2:FindFirstChild("Clan") or nil;
 end;

 if v7 == nil then
 return false, "no Clan value on the slot";
 end;

 local Value = v7.Value;
 v7.Value = v6;
 local v8 = Clans.TierOf(v6);
 DiscordLogService.Send("clans", v8.name .. "Roll", {
 player = p1,
 data = {
 source = "Shop",
 clan = v6,
 rarity = v8.name,
 previous = Value
 }
 });

 return true;
end;
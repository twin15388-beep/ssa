-- Decompiled with Potassium's decompiler.

local ServerStorage = game:GetService("ServerStorage");
local AnalyticsService = require(ServerStorage.SAM.Services.AnalyticsService);

return function(p1: userdata, p2: userdata, p3: string, p4: number?, p5: table?) -- Line: 15
 -- upvalues: AnalyticsService (copy)
 if p1 == nil or p2 == nil then
 return false, "No player";
 end;

 local v6;

 if p5 == nil then
 v6 = nil;
 else
 v6 = tonumber(p5.Spins) or nil;
 end;

 if v6 == nil or v6 <= 0 then
 return false, "Listing has no Spins";
 end;

 local Spinning = p2:FindFirstChild("Spinning");
 local v7;

 if Spinning == nil then
 v7 = nil;
 else
 v7 = Spinning:FindFirstChild("Spins") or nil;
 end;

 if v7 == nil then
 return false, "No Spins counter";
 end;

 local math_floor_ret = math.floor(p4 or 1);
 local v8 = v6 * math.max(math_floor_ret, 1);
 v7.Value = v7.Value + v8;
 AnalyticsService.Economy(p1, "Spins", "Source", v8, "RobuxPurchase", p3);

 return true;
end;
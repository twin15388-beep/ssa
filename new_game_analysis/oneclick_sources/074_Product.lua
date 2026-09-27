-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local u1 = nil;
local u2 = nil;
local u3 = nil;
local u4 = nil;

return function(p5: userdata, p6: userdata, p7: string, p8: number?, p9: table?) -- Line: 26
 -- upvalues: u3 (ref), ServerStorage (copy), u4 (ref), ReplicatedStorage (copy), u2 (ref), u1 (ref)
 if p5 == nil or p6 == nil then
 return false, "No player";
 end;

 if p9 == nil then
 return false, "No listing";
 end;

 local Reward = p9.Reward;

 if Reward == nil then
 local v10;

 if typeof(p9.Price) == "table" then
 v10 = p9.Price.Product or nil;
 else
 v10 = nil;
 end;

 if typeof(v10) ~= "number" then
 return false, "Listing has no product";
 end;

 u1 = u1 or require(ServerStorage.SAM.Services.ProductBehaviours);

 return u1.Run(v10, p5, p6, p9);
 end;

 local v11 = tonumber(p9.RewardAmount) or 1;
 local math_floor_ret = math.floor(v11);
 local math_max_ret = math.max(math_floor_ret, 1);

 if Reward == "Wen" then
 u3 = u3 or require(ServerStorage.SAM.Services.Adders.Wen);
 u3(p5, p6, math_max_ret, "Shop");

 return true;
 end;

 u4 = u4 or require(ReplicatedStorage.CAM.Global.Collectibles.Items);

 if u4[Reward] == nil then
 return false, `Unknown reward item "{tostring(Reward)}"`;
 end;

 u2 = u2 or require(ServerStorage.SAM.Services.Adders.Item);

 return u2(p5, Reward, math_max_ret, nil, nil, nil, "Shop");
end;
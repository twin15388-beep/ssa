-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local u1 = nil;
local u2 = nil;
local u3 = nil;

return function(p4: userdata, p5: userdata, p6: string, p7: number?, p8: table?) -- Line: 15
 -- upvalues: u3 (ref), ServerStorage (copy), u1 (ref), u2 (ref), SignalEvent (copy)
 local v9;

 if p8 == nil then
 v9 = nil;
 else
 v9 = p8.Grant or nil;
 end;

 if p4 == nil or p5 == nil then
 return false, "No player";
 end;

 if type(v9) ~= "table" then
 return false, "Listing grants nothing";
 end;

 local math_floor_ret = math.floor(p7 or 1);
 local math_max_ret = math.max(math_floor_ret, 1);
 local v10 = {};

 if v9.Wen ~= nil then
 u3 = u3 or require(ServerStorage.SAM.Services.Adders.Wen);
 v10[#v10 + 1] = u3(p4, p5, v9.Wen * math_max_ret, "Shop");
 end;

 if v9.Exp ~= nil then
 u1 = u1 or require(ServerStorage.SAM.Services.Adders.Exp);
 v10[#v10 + 1] = u1(p4, p5, v9.Exp * math_max_ret, "Shop");
 end;

 if v9.Mastery ~= nil then
 u2 = u2 or require(ServerStorage.SAM.Services.Adders.Mastery);
 v10[#v10 + 1] = u2(p4, p5, {
 To = { v9.Track },
 Points = v9.Mastery * math_max_ret
 });
 end;

 if #v10 == 0 then
 return false, "Nothing left to credit";
 end;

 SignalEvent.ToClient(p4, "CurrencyNotification", {
 Time = 5,
 Content = v10
 });

 return true;
end;
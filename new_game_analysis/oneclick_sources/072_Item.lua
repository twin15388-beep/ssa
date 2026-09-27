-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local u1 = nil;
local u2 = nil;
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);

return function(p3: userdata, p4: userdata, p5: string, p6: number?, p7: table?) -- Line: 9
 -- upvalues: u1 (ref), ServerStorage (copy), u2 (ref), ReplicatedStorage (copy), SignalEvent (copy)
 if not p3 then
 return false, "No player";
 end;

 u1 = u1 or require(ServerStorage.SAM.Services.Adders.Item);
 u2 = u2 or require(ReplicatedStorage.CAM.Global.Collectibles.Items);
 local v8 = u2[p5];

 if v8 ~= nil and v8.PackContents ~= nil then
 local math_floor_ret = math.floor(p6 or 1);
 local math_max_ret = math.max(math_floor_ret, 1);
 local v9 = true;

 for i, v in v8.PackContents do
 v9 = u1(p3, i, v * math_max_ret, nil, nil, nil, "Shop") and v9;
 end;

 return v9;
 end;

 if v8 ~= nil and (v8.Skills ~= nil or v8.HasCombat) then
 p6 = nil;
 end;

 local v10;

 if p7 == nil then
 v10 = false;
 else
 v10 = p7.NoSave == true;
 end;

 local v11, v12 = u1(p3, p5, p6, p7 ~= nil and p7.AutoEquip == true and true or nil, nil, nil, "Shop", v10);

 if v11 and (p7 ~= nil and typeof(p7.Shout) == "table") then
 SignalEvent.ToClient(p3, "NpcNotify", p7.Shout);
 end;

 return v11, v12;
end;
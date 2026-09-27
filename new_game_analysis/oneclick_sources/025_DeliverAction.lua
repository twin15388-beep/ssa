-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);

return function(u1: string, u2: string, u3: string, u4: string) -- Line: 20
 -- upvalues: Utility (copy), Players (copy), Quests (copy), SignalEvent (copy)
 return function(p5, p6) -- Line: 21
 -- upvalues: Utility (ref), Players (ref), Quests (ref), u1 (copy), u4 (copy), u2 (copy), SignalEvent (ref), u3 (copy)
 local Data = Utility.GetData(Players.LocalPlayer);
 local v7 = Quests.Holder[u1];

 if Data == nil or v7 == nil then
 return u4;
 end;

 local v8 = Data.Quests.Holder:FindFirstChild(v7.QuestInstance.Name);

 if v8 == nil then
 return u4;
 end;

 local v9;

 if v7.TaskSpecs == nil then
 v9 = nil;
 else
 v9 = v7.TaskSpecs[u2] or nil;
 end;

 local function held(p10: string) -- Line: 28
 -- upvalues: Data (copy)
 local v11 = Data.Inventory.Inventory:FindFirstChild(p10);
 local v12;

 if v11 == nil then
 v12 = nil;
 else
 v12 = v11:FindFirstChild("Amount") or nil;
 end;

 return v11 == nil and 0 or (v12 == nil and 1 or v12.Value);
 end;

 if v9 == nil or v9.RequiredItem == nil then
 if v9 ~= nil and type(v9.RequiredItems) == "table" then
 local v13 = 0;

 for _, v in v9.RequiredItems do
 local v14 = Data.Inventory.Inventory:FindFirstChild(v);
 local v15;

 if v14 == nil then
 v15 = nil;
 else
 v15 = v14:FindFirstChild("Amount") or nil;
 end;

 v13 = v13 + (v14 == nil and 0 or (v15 == nil and 1 or v15.Value));
 end;

 if v13 <= 0 then
 return u4;
 end;
 end;
 else
 local v16 = v8.Tasks:FindFirstChild(u2);
 local v17 = v9.Count or (v16 == nil and 1 or (v16.Max.Value or 1));
 local v18 = Data.Inventory.Inventory:FindFirstChild(v9.RequiredItem);
 local v19;

 if v18 == nil then
 v19 = nil;
 else
 v19 = v18:FindFirstChild("Amount") or nil;
 end;

 if (v18 == nil and 0 or (v19 == nil and 1 or v19.Value)) < v17 then
 return u4;
 end;
 end;

 SignalEvent.ToServer("QuestProgress", u1, u2);

 return u3;
 end;
end;
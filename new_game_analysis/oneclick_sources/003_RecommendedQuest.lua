-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local simplesignal = require(ReplicatedStorage.Packages.simplesignal);
local LocalPlayer = Players.LocalPlayer;
local u1 = {
 Changed = simplesignal.new()
};
local u2 = nil;

function u1.HasBook() -- Line: 71
 -- upvalues: u2 (ref)
 if u2 == nil then
 return false;
 end;

 for _, child in u2:GetChildren() do
 if child.Name == "Book of Guidance" then
 return true;
 end;
 end;

 return false;
end;

u1.BOOK = "Book of Guidance";
local u3 = nil;
local u4 = false;

local function playerPosition() -- Line: 85
 -- upvalues: LocalPlayer (copy)
 local Character = LocalPlayer.Character;
 local v5;

 if Character == nil then
 v5 = nil;
 else
 v5 = Character:FindFirstChild("HumanoidRootPart");
 end;

 if v5 == nil then
 return nil;
 end;

 return v5.Position;
end;

local function same(p6: table?, p7: table?) -- Line: 91
 if p6 == nil or p7 == nil then
 return p6 == p7;
 end;

 return p6.Key == p7.Key;
end;

local function compute() -- Line: 98
 -- upvalues: u1 (copy), u3 (ref), ReplicatedStorage (copy), LocalPlayer (copy), Quests (copy)
 if not u1.HasBook() then
 if u3 == nil then
 return;
 end;

 u3 = nil;
 u1.Changed:Fire(nil);

 return;
 end;

 local Regions = require(ReplicatedStorage.Regions);
 local v8 = nil;
 local v9 = (1 / 0);
 local Character = LocalPlayer.Character;
 local v10;

 if Character == nil then
 v10 = nil;
 else
 v10 = Character:FindFirstChild("HumanoidRootPart");
 end;

 local v11;

 if v10 == nil then
 v11 = nil;
 else
 v11 = v10.Position;
 end;

 for i, v in Quests.Holder do
 local OfferNpc = v.OfferNpc;

 if typeof(OfferNpc) == "string" and (v.NoSave ~= true and (v.Rewards == nil or v.Rewards.Power == nil)) and (Quests.GetQuestCategory(i) == "Combat" and Quests.CanAddQuest(LocalPlayer, i) == true) then
 local v12 = (v.Requirements == nil or typeof(v.Requirements.Level) ~= "number") and 0 or v.Requirements.Level;
 local NpcSpawn = Regions.GetNpcSpawn(OfferNpc);
 local v13 = (v11 == nil or NpcSpawn == nil) and (1 / 0) or (NpcSpawn - v11).Magnitude;
 local v14;

 if v8 == nil or v8.Level < v12 then
 v14 = true;
 elseif v12 == v8.Level then
 v14 = v13 < v9;
 else
 v14 = false;
 end;

 if v14 then
 v8 = {
 Key = i,
 Name = v.QuestInstance.Name,
 Npc = OfferNpc,
 Icon = Regions.GetNpcIcon(OfferNpc),
 Position = NpcSpawn,
 Level = v12
 };
 v9 = v13;
 end;
 end;
 end;

 local v15 = u3;
 local v16;

 if v15 == nil or v8 == nil then
 v16 = v15 == v8;
 else
 v16 = v15.Key == v8.Key;
 end;

 if v16 then
 return;
 end;

 u3 = v8;
 u1.Changed:Fire(v8);
end;

local function refresh() -- Line: 136
 -- upvalues: u4 (ref), compute (copy)
 if u4 then
 return;
 end;

 u4 = true;
 task.defer(function() -- Line: 139
 -- upvalues: u4 (ref), compute (ref)
 u4 = false;
 compute();
 end);
end;

function u1.Get() -- Line: 146
 -- upvalues: u3 (ref)
 return u3;
end;

task.spawn(function() -- Line: 152
 -- upvalues: Utility (copy), LocalPlayer (copy), u2 (ref), refresh (copy), u4 (ref), compute (copy), Quests (copy)
 local Data = Utility.GetData(LocalPlayer, true);

 if Data == nil then
 return;
 end;

 local Quests2 = Data:WaitForChild("Quests");
 local Holder = Quests2:WaitForChild("Holder");
 local Completed = Quests2:WaitForChild("Completed");
 local LastTime = Quests2:WaitForChild("LastTime");
 local Goal = Data:WaitForChild("Exp"):WaitForChild("Goal");
 local Inventory = Data:WaitForChild("Inventory"):WaitForChild("Inventory");
 u2 = Inventory;
 Inventory.ChildAdded:Connect(refresh);
 Inventory.ChildRemoved:Connect(refresh);
 Holder.ChildAdded:Connect(refresh);
 Holder.ChildRemoved:Connect(refresh);
 Completed.ChildAdded:Connect(refresh);
 Completed.ChildRemoved:Connect(refresh);
 Goal.Changed:Connect(refresh);
 LastTime.Changed:Connect(function() -- Line: 172
 -- upvalues: u4 (ref), compute (ref), Quests (ref), refresh (ref)
 if not u4 then
 u4 = true;
 task.defer(function() -- Line: 139
 -- upvalues: u4 (ref), compute (ref)
 u4 = false;
 compute();
 end);
 end;

 task.delay(Quests.QuestCD + 1, refresh);
 end);

 if u4 then
 return;
 end;

 u4 = true;
 task.defer(function() -- Line: 139
 -- upvalues: u4 (ref), compute (ref)
 u4 = false;
 compute();
 end);
end);

return u1;
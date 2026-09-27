-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
require(ReplicatedStorage.CAM.Global.Types.MiscTypes);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
require(ReplicatedStorage.Packages.cleanit);
local ClientEffects = ReplicatedStorage:WaitForChild("Communication"):WaitForChild("CnC"):WaitForChild("ClientEffects");
local v1 = {};

local function spawnPickup(u2: any, u3: vector, u4: number, p5: table, u6: function) -- Line: 50
 -- upvalues: Utility (copy), ClientEffects (copy)
 local u7;

 if p5.Model == nil then
 u7 = Instance.new("Part");
 u7.Anchored = true;
 u7.CanCollide = false;
 u7.Material = Enum.Material.Neon;
 u7.Color = Color3.new(1, 0.95, 0.7);
 u7.Size = Vector3.new(1.5, 0.2, 2);
 u7.Position = u3;
 else
 u7 = p5.Model:Clone();
 u7:PivotTo(CFrame.new(u3));

 if u7:IsA("BasePart") then
 u7.Anchored = true;
 end;

 for _, v in u7:QueryDescendants("BasePart") do
 v.Anchored = true;
 end;
 end;

 u7.Name = (p5.ObjectText or "Pickup") .. u4;
 local CreatePrompt = Utility.CreatePrompt;
 local v8 = {
 ActionText = "Pick Up",
 ObjectText = p5.ObjectText or "Pickup"
 };

 if u7:IsA("Model") then
 u7 = u7.PrimaryPart or u7:FindFirstChildWhichIsA("BasePart");
 end;

 v8.Parent = u7;
 CreatePrompt(v8).Triggered:Connect(function() -- Line: 83
 -- upvalues: u2 (copy), u7 (ref), ClientEffects (ref), u3 (copy), u6 (copy), u4 (copy)
 u2:Remove(u7);
 u7:Destroy();
 ClientEffects:Fire("QuestPickup", u3);
 u6(u4);
 end);
 u7.Parent = workspace;
 u2:Add(u7);
end;

function v1.forTask(u9: string, u10: string, p11: table?) -- Line: 94
 -- upvalues: Quests (copy), spawnPickup (copy), SignalEvent (copy)
 local u12 = p11 or {};

 return {
 Tasks = {
 [u10] = {
 Do = function(p13: userdata, p14: userdata, u15: any) -- Line: 99, Name: Do
 -- upvalues: Quests (ref), u9 (copy), u10 (copy), spawnPickup (ref), u12 (ref), SignalEvent (ref)
 local v16 = Quests.Holder[u9];
 local u17;

 if v16 == nil or v16.TaskSpecs == nil then
 u17 = nil;
 else
 u17 = v16.TaskSpecs[u10] or nil;
 end;

 if u17 == nil or u17.Positions == nil then
 warn((`[PickupState] no Pickup TaskSpec/Positions for "{u9}" / "{u10}" — no props spawned`));

 return;
 end;

 local u19 = typeof(u17.Positions) ~= "function" and function(p18) -- Line: 108
 -- upvalues: u17 (copy)
 return u17.Positions[p18];
 end or u17.Positions;
 local v20;

 if typeof(u17.Positions) == "function" then
 v20 = u17.SpawnCount or 1;
 else
 v20 = #u17.Positions;
 end;

 local function spawnAt(p21: number, p22: number?) -- Line: 111
 -- upvalues: u19 (copy), u9 (ref), u10 (ref), u15 (copy), spawnAt (copy), spawnPickup (ref), u12 (ref), SignalEvent (ref), u17 (copy)
 local v23 = u19(p21);

 if v23 ~= nil then
 spawnPickup(u15, v23, p21, u12, function(p24) -- Line: 121
 -- upvalues: SignalEvent (ref), u9 (ref), u10 (ref), u17 (ref), u15 (ref), spawnAt (ref)
 SignalEvent.ToServer("QuestProgress", u9, u10, p24);

 if u17.RespawnTime ~= nil then
 u15:Add(task.delay(u17.RespawnTime, spawnAt, p24));
 end;
 end);

 return;
 end;

 local v25 = (p22 or 0) + 1;

 if v25 == 20 then
 warn((`[PickupState] "{u9}" / "{u10}" slot {p21}: placement function still returning nil after {20} tries`));
 end;

 u15:Add(task.delay(0.5, spawnAt, p21, v25));
 end;

 for i = 1, v20 do
 local Attribute = p14:GetAttribute("Picked" .. i);
 local v26;

 if u17.RespawnTime == nil then
 if Attribute == true then
 v26 = i;
 else
 spawnAt(i);
 v26 = i;
 end;
 else
 local v27 = typeof(Attribute) ~= "number" and 0 or u17.RespawnTime - (os.time() - Attribute);

 if v27 > 0 then
 u15:Add(task.delay(v27, spawnAt, i));
 v26 = i;
 else
 spawnAt(i);
 v26 = i;
 end;
 end;
 end;
 end
 }
 }
 };
end;

return v1;
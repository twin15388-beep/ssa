-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
require(ReplicatedStorage.CAM.Global.Types.MiscTypes);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
require(ReplicatedStorage.Packages.cleanit);
local ClientEffects = ReplicatedStorage:WaitForChild("Communication"):WaitForChild("CnC"):WaitForChild("ClientEffects");
local v1 = {};

local function invisibleAnchor(p2: string, p3: vector) -- Line: 64
 local Part = Instance.new("Part");
 Part.Name = p2;
 Part.Anchored = true;
 Part.CanCollide = false;
 Part.CanQuery = false;
 Part.CanTouch = false;
 Part.Transparency = 1;
 Part.Size = Vector3.new(1, 1, 1);
 Part.Position = p3;

 return Part;
end;

local function spawnScene(p4: any, p5: string, p6: vector, p7: table, p8: table) -- Line: 81
 -- upvalues: ReplicatedStorage (copy), ClientEffects (copy)
 local u9;

 if p8.Model == nil then
 local v10 = p8.PromptAt or p6;
 u9 = Instance.new("Part");
 u9.Name = "Deposit";
 u9.Anchored = true;
 u9.CanCollide = false;
 u9.CanQuery = false;
 u9.CanTouch = false;
 u9.Transparency = 1;
 u9.Size = Vector3.new(1, 1, 1);
 u9.Position = v10;
 else
 u9 = p8.Model:Clone();
 u9:PivotTo(CFrame.new(p6));
 end;

 u9.Name = p8.ObjectText or "Deposit";

 if u9:IsA("Model") then
 u9 = u9.PrimaryPart or u9:FindFirstChildWhichIsA("BasePart");
 end;

 if u9 == nil then
 warn((`[DepositState] "{p5}": the Model prop has no BasePart to anchor the prompt to`));
 u9:Destroy();

 return nil, function(p11: string) -- Line: 94
 end;
 end;

 u9.Parent = workspace;
 local v12 = (#p7 + 1) * 1.3;
 local v13 = p8.BillboardAt or p6 + vector.create(0, v12 / 2 + 4, 0);
 local Part = Instance.new("Part");
 Part.Name = "DepositProgressAnchor";
 Part.Anchored = true;
 Part.CanCollide = false;
 Part.CanQuery = false;
 Part.CanTouch = false;
 Part.Transparency = 1;
 Part.Size = Vector3.new(1, 1, 1);
 Part.Position = v13;
 Part.Parent = workspace.Debree;
 local BillboardGui = Instance.new("BillboardGui");
 BillboardGui.Name = "DepositProgress";
 BillboardGui.Size = UDim2.fromScale(7, v12);
 BillboardGui.MaxDistance = 60;
 BillboardGui.LightInfluence = 0;
 BillboardGui.Parent = Part;
 local u14 = require(ReplicatedStorage.CAM.Client.Components.NonePackagedMisc.UIDepositProgress)(BillboardGui, p7, p8.Title or (p8.ObjectText or "Delivery"));
 p4:Add(function() -- Line: 112
 -- upvalues: u14 (copy), u9 (ref), Part (copy)
 u14();
 u9:Destroy();
 task.delay(0.5, Part.Destroy, Part);
 end);
 local u15 = p8.BurstAt or p6;
 local u16 = p8.VfxScale or 1;

 return u9, function(p17: string) -- Line: 120
 -- upvalues: ClientEffects (ref), u15 (copy), u16 (copy)
 ClientEffects:Fire("QuestDeposit", u15, p17, u16);
 end;
end;

function v1.forTasks(u18: string, u19: table, p20: table?) -- Line: 125
 -- upvalues: Quests (copy), Utility (copy), spawnScene (copy), SignalEvent (copy)
 local u21 = p20 or {};
 local math_max_ret = math.max(u21.Interval or 0.15, 0.15);

 return {
 Do = function(u22: userdata, p23: userdata, p24: any) -- Line: 131, Name: Do
 -- upvalues: Quests (ref), u18 (copy), u19 (copy), Utility (ref), spawnScene (ref), u21 (copy), math_max_ret (copy), SignalEvent (ref)
 local v25 = Quests.Holder[u18];
 local v26;

 if v25 == nil then
 v26 = nil;
 else
 v26 = v25.TaskSpecs or nil;
 end;

 if v26 == nil then
 warn((`[DepositState] no TaskSpecs for "{u18}" — no deposit prop spawned`));

 return;
 end;

 local u27 = {};
 local v28 = nil;

 for _, v in u19 do
 local v29 = v26[v];
 local v30 = p23.Tasks:WaitForChild(v, 5);
 local v31;

 if v30 == nil then
 v31 = nil;
 else
 v31 = v30:WaitForChild("Value", 5) or nil;
 end;

 local v32;

 if v30 == nil then
 v32 = nil;
 else
 v32 = v30:WaitForChild("Max", 5) or nil;
 end;

 if v29 == nil or (v29.RequiredItem == nil or (v29.Position == nil or (v31 == nil or v32 == nil))) then
 warn((`[DepositState] "{u18}" / "{v}": needs a Deposit spec with RequiredItem + Position, and a live task`));
 else
 if v28 ~= nil and v29.Position ~= v28 then
 warn((`[DepositState] "{u18}" / "{v}": Position differs from the prop's — its deposits will be server-rejected`));
 end;

 v28 = v28 or v29.Position;
 table.insert(u27, {
 Name = v,
 Item = v29.RequiredItem,
 Value = v31,
 Max = v32
 });
 end;
 end;

 if v28 == nil then
 return;
 end;

 local Inventory = Utility.GetData(u22).Inventory.Inventory;

 local function stocked() -- Line: 160
 -- upvalues: u27 (copy)
 for _, v in u27 do
 if v.Value.Value < v.Max.Value then
 return false;
 end;
 end;

 return true;
 end;

 local function nextRow() -- Line: 166
 -- upvalues: u27 (copy), Inventory (copy)
 for _, v in u27 do
 if v.Value.Value < v.Max.Value then
 local v33 = Inventory:FindFirstChild(v.Item);
 local v34;

 if v33 == nil then
 v34 = nil;
 else
 v34 = v33:FindFirstChild("Amount") or nil;
 end;

 if (v33 == nil and 0 or (v34 == nil and 1 or v34.Value)) > 0 then
 return v;
 end;
 end;
 end;

 return nil;
 end;

 local v35, u36 = spawnScene(p24, u18, v28, u27, u21);

 if v35 == nil then
 return;
 end;

 local v37 = 0;

 for _, v in u27 do
 v37 = v37 + v.Max.Value;
 end;

 local u38 = Utility.CreatePrompt({
 ActionText = u21.ActionText or "Stock",
 ObjectText = u21.ObjectText or "Deposit",
 HoldDuration = v37 * math_max_ret * 1.3 + math_max_ret,
 Parent = v35
 });
 local v39 = true;

 for _, v in u27 do
 if v.Value.Value < v.Max.Value then
 v39 = false;
 break;
 end;
 end;

 u38.Enabled = not v39;
 local u40 = 0;
 local u41 = nil;
 local u42 = nil;

 local function endHold() -- Line: 200
 -- upvalues: u40 (ref), u36 (copy), u41 (ref), u42 (ref)
 u40 = u40 + 1;
 u36("Stop");

 if u41 ~= nil then
 u41:Destroy();
 u41 = nil;
 end;

 if u42 ~= nil then
 u42:Stop(0.2);
 u42:Destroy();
 u42 = nil;
 end;
 end;

 p24:Add(endHold);
 p24:Connect(u38.PromptButtonHoldBegan, function() -- Line: 216
 -- upvalues: u40 (ref), u36 (copy), u41 (ref), u42 (ref), u22 (copy), Utility (ref), nextRow (copy), SignalEvent (ref), u18 (ref), math_max_ret (ref), u38 (copy), u27 (copy)
 u40 = u40 + 1;
 u36("Stop");

 if u41 ~= nil then
 u41:Destroy();
 u41 = nil;
 end;

 if u42 ~= nil then
 u42:Stop(0.2);
 u42:Destroy();
 u42 = nil;
 end;

 local u43 = u40;
 local Character = u22.Character;
 local v44;

 if Character == nil then
 v44 = nil;
 else
 v44 = Character:FindFirstChild("HumanoidRootPart") or nil;
 end;

 if v44 ~= nil then
 u41 = Utility.AddValue(v44, "skill_stand_still");
 end;

 local v45;

 if Character == nil then
 v45 = nil;
 else
 v45 = Character:FindFirstChildOfClass("Humanoid") or nil;
 end;

 if v45 ~= nil then
 u42 = v45.Animator:LoadAnimation(script.Working);
 u42:Play(0.2);
 end;

 task.spawn(function() -- Line: 229
 -- upvalues: u40 (ref), u43 (copy), nextRow (ref), u36 (ref), SignalEvent (ref), u18 (ref), math_max_ret (ref), u38 (ref), u41 (ref), u42 (ref), u27 (ref)
 while u40 == u43 do
 local v46 = nextRow();

 if v46 == nil then
 break;
 end;

 u36("Start");
 SignalEvent.ToServer("QuestProgress", u18, v46.Name);
 task.wait(math_max_ret);
 end;

 if u40 ~= u43 or u38.Parent == nil then
 return;
 end;

 u40 = u40 + 1;
 u36("Stop");

 if u41 ~= nil then
 u41:Destroy();
 u41 = nil;
 end;

 if u42 ~= nil then
 u42:Stop(0.2);
 u42:Destroy();
 u42 = nil;
 end;

 u38.Enabled = false;
 task.defer(function() -- Line: 244
 -- upvalues: u38 (ref), u27 (ref)
 local v47;

 if u38.Parent == nil then
 v47 = false;
 else
 local v48 = true;

 for _, v in u27 do
 if v.Value.Value < v.Max.Value then
 v48 = false;
 break;
 end;
 end;

 v47 = not v48;
 end;

 u38.Enabled = v47;
 end);
 end);
 end);
 p24:Connect(u38.PromptButtonHoldEnded, endHold);

 for _, v in u27 do
 p24:Connect(v.Value.Changed, function() -- Line: 252
 -- upvalues: u36 (copy), u27 (copy), u40 (ref), u41 (ref), u42 (ref), u38 (copy)
 u36("Burst");
 local v49 = true;

 for _, v2 in u27 do
 if v2.Value.Value < v2.Max.Value then
 v49 = false;
 break;
 end;
 end;

 if not v49 then
 return;
 end;

 u40 = u40 + 1;
 u36("Stop");

 if u41 ~= nil then
 u41:Destroy();
 u41 = nil;
 end;

 if u42 ~= nil then
 u42:Stop(0.2);
 u42:Destroy();
 u42 = nil;
 end;

 u38.Enabled = false;
 end);
 end;
 end
 };
end;

return v1;
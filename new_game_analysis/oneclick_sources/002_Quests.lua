-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.CAM.Client.Controllers.Skill_Controller.Settings);
require(ReplicatedStorage.CAM.Global.Types.MiscTypes);
local ItemRequirements = require(ReplicatedStorage.CAM.Global.Collectibles.ItemRequirements);
local u1 = {
 QuestCD = 30,
 MaxQuestsPerPlayer = 1,
 Holder = {},
 Rewards = {}
};
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local MinigameSettings = require(ReplicatedStorage.CAM.Global.MinigameSettings);
local Utility = require(game.ReplicatedStorage.CAM.Global.Utility);

function u1.QuestTask(p2: string, p3: number, p4: string?, p5: string?) -- Line: 21
 if p2 ~= nil and p3 ~= nil then
 if p4 == nil then
 p4 = p2;
 end;

 local Configuration = Instance.new("Configuration");
 Configuration.Name = p2;
 local IntValue = Instance.new("IntValue");
 IntValue.Name = "Value";
 IntValue.Parent = Configuration;
 local IntValue2 = Instance.new("IntValue");
 IntValue2.Name = "Max";
 IntValue2.Value = p3;
 IntValue2.Parent = Configuration;
 local StringValue = Instance.new("StringValue");
 StringValue.Name = "Code";
 StringValue.Value = p4 or p2;
 StringValue.Parent = Configuration;

 if p5 ~= nil then
 local StringValue2 = Instance.new("StringValue");
 StringValue2.Name = "Need";
 StringValue2.Value = p5;
 StringValue2.Parent = Configuration;
 end;

 return Configuration;
 end;
end;

function u1.TaskNeedMet(p6: userdata) -- Line: 58
 local Need = p6:FindFirstChild("Need");

 if Need == nil or Need.Value == "" then
 return true;
 end;

 local v7;

 if p6.Parent == nil then
 v7 = nil;
 else
 v7 = p6.Parent:FindFirstChild(Need.Value) or nil;
 end;

 if v7 == nil then
 warn((`Quests: task "{p6.Name}" needs "{Need.Value}", which is not a task on this quest`));

 return true;
 end;

 local Value = v7:FindFirstChild("Value");
 local Max = v7:FindFirstChild("Max");

 return (Value == nil or Max == nil) and true or Value.Value >= Max.Value;
end;

local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local Caps = require(ReplicatedStorage.CAM.Global.Caps);

function u1.AtLevelCap(p8: userdata) -- Line: 79
 -- upvalues: Utility (copy), Caps (copy), gameSettings (copy)
 local Data = Utility.GetData(p8);

 if Data == nil then
 return false;
 end;

 return Data.Exp.Goal.Value >= Caps.Get(p8, "Max Level") * gameSettings.expPerLevel;
end;

function u1.GetTaskMarker(p9: any, p10: userdata) -- Line: 91
 -- upvalues: gameSettings (copy)
 local v11;

 if p9 == nil or p9.Markers == nil then
 v11 = nil;
 else
 v11 = p9.Markers[p10.Name] or nil;
 end;

 if v11 ~= nil then
 return v11;
 end;

 local TrainingMarkerPositions = gameSettings.TrainingMarkerPositions;
 local v12;

 if TrainingMarkerPositions == nil then
 v12 = nil;
 else
 v12 = TrainingMarkerPositions[game.PlaceId] or (TrainingMarkerPositions.Default or nil);
 end;

 if v12 == nil then
 return nil;
 end;

 local Code = p10:FindFirstChild("Code");
 local v13 = Code ~= nil and v12[Code.Value] or v12[p10.Name];

 return v13 ~= nil and v13.Position ~= nil and {
 Icon = v13.Image,
 Position = v13.Position
 } or nil;
end;

function u1.DeleteQuest(p14: userdata, p15: any, p16: string?) -- Line: 103
 -- upvalues: Utility (copy), SignalEvent (copy), gameSettings (copy), u1 (copy)
 local Data = Utility.GetData(p14);

 if Data == nil then
 return;
 end;

 local v17;

 if typeof(p15) == "Instance" then
 if not p15:IsDescendantOf(Data.Quests.Holder) then
 return;
 end;

 v17 = p15;
 else
 v17 = Data.Quests.Holder:FindFirstChild(p15);
 end;

 if v17 ~= nil then
 if typeof(p15) ~= "Instance" then
 SignalEvent.ToClient(p14, "Notify", {
 Type = "Denied",
 Text = `{p16 or "Abandoned"} Quest \\[['{p15}']<{gameSettings.RichTextPopularConfigs.SoroundColor}>]`
 });
 end;

 if game["Run Service"]:IsServer() then
 local QuestString = v17:FindFirstChild("QuestString");
 local v18;

 if QuestString == nil then
 v18 = nil;
 else
 v18 = u1.Holder[QuestString.Value] or nil;
 end;

 if v18 ~= nil and (v18.GrantItemOnAccept ~= nil and Data.Inventory.Inventory:FindFirstChild(v18.GrantItemOnAccept) ~= nil) then
 require(game.ServerStorage.SAM.Services.Removers.Item)(p14, v18.GrantItemOnAccept);
 end;
 end;

 v17:Destroy();
 end;
end;

function u1.Quest(p19: string, p20: any) -- Line: 138
 local Configuration = Instance.new("Configuration");
 Configuration.Name = p19;
 local Configuration2 = Instance.new("Configuration");
 Configuration2.Name = "Tasks";
 Configuration2.Parent = Configuration;

 if typeof(p20) == "Instance" then
 p20.Parent = Configuration2;

 return Configuration;
 end;

 for _, v in ipairs(p20) do
 v.Parent = Configuration2;
 end;

 return Configuration;
end;

function u1.GetQuestInfo(p21: string) -- Line: 158
 -- upvalues: u1 (copy)
 local v22 = u1.Holder[p21];

 if v22 ~= nil then
 return v22;
 end;

 for _, v in pairs(u1.Holder) do
 if v.QuestInstance ~= nil and v.QuestInstance.Name == p21 then
 return v;
 end;
 end;

 return nil;
end;

function u1.GetQuestCategory(p23: string) -- Line: 168
 -- upvalues: u1 (copy)
 local QuestInfo = u1.GetQuestInfo(p23);

 return QuestInfo ~= nil and QuestInfo.Category or "Combat";
end;

function u1.GetPlayerQuestState(p24: userdata, p25: string) -- Line: 174
 -- upvalues: Utility (copy), u1 (copy)
 local Data = Utility.GetData(p24);

 if Data == nil then
 return "None";
 end;

 local QuestInfo = u1.GetQuestInfo(p25);

 if QuestInfo ~= nil and (QuestInfo.QuestInstance ~= nil and Data.Quests.Holder:FindFirstChild(QuestInfo.QuestInstance.Name) ~= nil) then
 return "Doing";
 end;

 local Completed = Data.Quests:FindFirstChild("Completed");

 return (Completed == nil or Completed:FindFirstChild(p25) == nil) and "None" or "Done";
end;

function u1.CanAddQuest(p26: userdata, p27: string, p28: boolean?) -- Line: 188
 -- upvalues: Utility (copy), u1 (copy), ItemRequirements (copy), MinigameSettings (copy)
 local v29;

 if p27 == nil and p26 ~= nil then
 v29 = game.Players.LocalPlayer;
 else
 v29 = p26;
 p26 = p27;
 end;

 local Data = Utility.GetData(v29);
 local QuestInfo = u1.GetQuestInfo(p26);

 if QuestInfo ~= nil and (QuestInfo.LogCompletion == true and u1.GetPlayerQuestState(v29, p26) == "Done") then
 return false, 2;
 end;

 if QuestInfo ~= nil and (QuestInfo.Requirements ~= nil and not ItemRequirements.Passes(Data, QuestInfo.Requirements)) then
 return nil;
 end;

 local v30;

 if QuestInfo == nil then
 v30 = p26;
 else
 v30 = QuestInfo.QuestInstance.Name;
 end;

 local QuestCategory = u1.GetQuestCategory(p26);
 local v31 = 0;
 local v32 = nil;

 for _, child in ipairs(Data.Quests.Holder:GetChildren()) do
 local QuestString = child:FindFirstChild("QuestString");

 if u1.GetQuestCategory(QuestString ~= nil and QuestString.Value or child.Name) == QuestCategory then
 v31 = v31 + 1;

 if v32 == nil then
 v32 = child.Name;
 end;
 end;
 end;

 local v33 = MinigameSettings.Get("NoQuestCategoryLimit") == true;
 local v34 = p28 == true and true or Utility.Tick() - Data.Quests.LastTime.Value > u1.QuestCD;

 if not (v34 and (v33 or v31 < u1.MaxQuestsPerPlayer)) then
 return false, not v34, v32;
 end;

 if Data.Quests.Holder:FindFirstChild(v30) == nil then
 return true;
 end;

 return false, 1;
end;

function u1.RewardsOf(p35: userdata, p36: userdata?) -- Line: 243
 -- upvalues: u1 (copy)
 local QuestString = p35:FindFirstChild("QuestString");
 local v37 = u1.Holder[QuestString ~= nil and QuestString.Value or p35.Name];
 local v38;

 if v37 == nil then
 v38 = nil;
 else
 v38 = v37.Rewards or nil;
 end;

 if v38 == nil then
 return nil;
 end;

 local table_clone_ret = table.clone(v38);
 local MaxLevelMastery = v37.MaxLevelMastery;

 if p36 ~= nil and (type(MaxLevelMastery) == "number" and (MaxLevelMastery > 0 and u1.AtLevelCap(p36))) then
 table_clone_ret.Exp = nil;
 table_clone_ret.FlatMastery = MaxLevelMastery;
 end;

 local RewardFactor = p35:FindFirstChild("RewardFactor");

 if RewardFactor ~= nil and RewardFactor.Value ~= 1 then
 for i, v in table_clone_ret do
 if type(v) == "number" then
 table_clone_ret[i] = v * RewardFactor.Value;
 end;
 end;
 end;

 return table_clone_ret;
end;

function u1.AddQuest(p39: userdata, p40: string, p41: table?) -- Line: 264
 -- upvalues: u1 (copy), Utility (copy)
 local v42;

 if p40 == nil and p39 ~= nil then
 v42 = game.Players.LocalPlayer;
 else
 v42 = p39;
 p39 = p40;
 end;

 local v43 = u1.Holder[p39];

 if v43 == nil or v42 == nil then
 return;
 end;

 if u1.CanAddQuest(v42, p39, p41 == nil and true or p41.Client ~= true) then
 local Data = Utility.GetData(v42);
 local v44 = v43.QuestInstance:Clone();
 local StringValue = Instance.new("StringValue");
 StringValue.Value = p39;
 StringValue.Name = "QuestString";
 StringValue.Parent = v44;
 local v45 = u1.Holder[p39];
 local v46 = p41 ~= nil and p41.Timer;

 if not v46 then
 if v45 == nil then
 v46 = nil;
 else
 v46 = v45.Timer or nil;
 end;
 end;

 local v47 = p41 ~= nil and p41.NoSave or (v45 ~= nil and v45.NoSave or nil);

 if v46 ~= nil then
 local Folder = Instance.new("Folder");
 Folder.Name = "Timer";
 local NumberValue = Instance.new("NumberValue");
 NumberValue.Name = "Started";
 NumberValue.Value = os.time();
 NumberValue.Parent = Folder;
 local NumberValue2 = Instance.new("NumberValue");
 NumberValue2.Name = "Target";
 NumberValue2.Value = v46;
 NumberValue2.Parent = Folder;
 Folder.Parent = v44;
 end;

 if v47 ~= nil then
 local BoolValue = Instance.new("BoolValue");
 BoolValue.Name = "NoSave";
 BoolValue.Value = v47;
 BoolValue.Parent = v44;
 end;

 if p41 ~= nil and (p41.RewardFactor ~= nil and p41.RewardFactor ~= 1) then
 local NumberValue = Instance.new("NumberValue");
 NumberValue.Name = "RewardFactor";
 NumberValue.Value = p41.RewardFactor;
 NumberValue.Parent = v44;
 end;

 v44.Parent = Data.Quests.Holder;

 if p41 ~= nil and p41.Client == true then
 Data.Quests.LastTime.Value = Utility.Tick();
 end;

 return true;
 end;
end;

local function questClockRunsHere() -- Line: 343
 -- upvalues: gameSettings (copy)
 return not gameSettings.IsMenu;
end;

local function timersOf(p48: userdata) -- Line: 347
 local Quests = p48:FindFirstChild("Quests");
 local v49 = Quests ~= nil and Quests:FindFirstChild("Holder") or nil;

 return v49 == nil and {} or v49:GetChildren();
end;

function u1.TimerPaused(p50: userdata) -- Line: 358
 local Timer = p50:FindFirstChild("Timer");

 if Timer == nil then
 return false;
 end;

 local Started = Timer:FindFirstChild("Started");
 local v51;

 if Started == nil then
 v51 = false;
 else
 v51 = Started.Value == 0;
 end;

 return v51;
end;

function u1.PauseTimers(p52: userdata) -- Line: 365
 -- upvalues: timersOf (copy)
 local v53 = game["Run Service"]:IsServer();
 assert(v53, "Quests: only the server pauses a slot\'s timers");

 for _, v in timersOf(p52) do
 local Timer = v:FindFirstChild("Timer");

 if Timer ~= nil then
 local Started = Timer:FindFirstChild("Started");
 local Target = Timer:FindFirstChild("Target");

 if Started ~= nil and (Target ~= nil and (Target.Value > 0 and Started.Value ~= 0)) then
 local v54 = Started.Value + Target.Value - os.time();
 Started.Value = 0;
 local math_floor_ret = math.floor(v54);
 Target.Value = math.max(0, math_floor_ret);
 end;
 end;
 end;
end;

function u1.ResumeTimers(p55: userdata) -- Line: 379
 -- upvalues: gameSettings (copy), timersOf (copy)
 local v56 = game["Run Service"]:IsServer();
 assert(v56, "Quests: only the server resumes a slot\'s timers");

 if gameSettings.IsMenu then
 return;
 end;

 for _, v in timersOf(p55) do
 local Timer = v:FindFirstChild("Timer");

 if Timer ~= nil then
 local Started = Timer:FindFirstChild("Started");
 local Target = Timer:FindFirstChild("Target");

 if Started ~= nil and (Target ~= nil and (Target.Value > 0 and Started.Value == 0)) then
 Started.Value = os.time();
 end;
 end;
 end;
end;

return u1;
-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Skills_Provider = require(ReplicatedStorage.CAM.Client.Controllers.Skills_Provider);
local table_clear = table.clear;
local script_Skill = require(script.Skill);
local SkillSlot = require(ReplicatedStorage.CAM.Client.Components.Layout.ResetOnSpawn.Mobile.SkillSlot);
local Platform_Handler = require(ReplicatedStorage.CAM.Client.Controllers.Platform_Handler);
local Skill_Switch_Adder = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Skill_Switch_Adder);
local Skill_Controller = require(ReplicatedStorage.CAM.Client.Controllers.Skill_Controller);
local u1 = typeof;
game:GetService("UserInputService");
local InputHandler = require(ReplicatedStorage.CAM.Client.Components.Client.InputHandler);
local LocalPlayer = game:GetService("Players").LocalPlayer;
local StatsFetch = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.StatsFetch);
local os_clock = os.clock;
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local HoverInfo = require(ReplicatedStorage.CAM.Client.Modules.HoverInfo);
require(ReplicatedStorage.Packages.faye);
local SkillStats = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.StatsFetch.Modules.SkillStats);
local manage_cd = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.manage_cd);
local Stats = require(ReplicatedStorage.CAM.Global.SkillService.Stats);
game:GetService("GuiService");
local u2 = { "Skills_1st", "Skills_2nd", "Skills_3rd", "Skills_4th", "Skills_5th", "Skills_6th", "Skills_7th", "Skills_8th", "Skills_9th", "Skills_10th" };
local u3 = {};

for i, v in u2 do
 local v4 = i;

 for _, v2 in InputHandler.GetMapping(v) or {} do
 if typeof(v2) == "table" and v2.Modifier == Enum.KeyCode.ButtonL1 then
 u3[v4] = true;
 end;
 end;
end;

local table_clone_ret = table.clone(Utility.Cancel_Values);

return function(u5: any, p6: userdata, p7: userdata, p8: table?) -- Line: 58
 -- upvalues: u2 (copy), HoverInfo (copy), Platform_Handler (copy), LocalPlayer (copy), StatsFetch (copy), table_clear (copy), SkillStats (copy), Skill_Switch_Adder (copy), manage_cd (copy), Stats (copy), Skills_Provider (copy), Utility (copy), table_clone_ret (copy), Skill_Controller (copy), InputHandler (copy), u1 (copy), u3 (copy), os_clock (copy), SkillSlot (copy), script_Skill (copy)
 local u9 = {};
 local u10 = {};
 local u11 = {};
 local u12 = {};

 for i = 1, 10 do
 u9[i] = {
 Name = "",
 CoolDownCurrent = false,
 Enabled = u5:Value(false),
 Key = u2[i],
 Icon = u5:Value(""),
 CoolDown = u5:Value(false),
 SkillStats = {},
 Hover = HoverInfo.new(nil, ""),
 Switch = u5:Value(false),
 Locked = u5:Value(true),
 SplitHere = u5:Value(nil),
 Holding = {
 Is = false,
 HoldingState = u5:Value(false),
 Rotation = u5:Value(0)
 }
 };
 local _ = i;
 end;

 local u13 = u5:Value(Platform_Handler.IsGamepad());
 u5:Connect(Platform_Handler.Platform.Changed.Event, function() -- Line: 102
 -- upvalues: u13 (copy), Platform_Handler (ref)
 u13:Set(Platform_Handler.IsGamepad());
 end);
 local u14 = u5:Value(false);

 local function refreshAnyHolding() -- Line: 108
 -- upvalues: u9 (copy), u14 (copy), LocalPlayer (ref), StatsFetch (ref)
 local v15 = nil;

 for i = 1, 10 do
 if u9[i] ~= nil and u9[i].Holding.Is == true then
 v15 = u9[i].Name;
 break;
 end;

 local _ = i;
 end;

 u14:Set(v15 ~= nil);
 local Character = LocalPlayer.Character;

 for i = 1, 10 do
 local v16 = u9[i];
 local v17;

 if v16 == nil then
 v17 = i;
 else
 local v18;

 if v15 == nil or (Character == nil or (v16.Name == nil or (v16.Name == "" or v16.Name == v15))) then
 v18 = false;
 else
 local v19, v20 = StatsFetch.CanPlayOver(Character, v16.Name, v15);

 if v19 == true then
 v18 = v20 == true;
 else
 v18 = false;
 end;
 end;

 v16.PlaysOverHeld:Set(v18);
 v17 = i;
 end;
 end;
 end;

 for i = 1, 10 do
 u9[i].OnPad = u13;
 u9[i].AnyHolding = u14;
 u9[i].PlaysOverHeld = u5:Value(false);
 local _ = i;
 end;

 local function _(p21) -- Line: 136
 -- upvalues: u11 (copy), LocalPlayer (ref), u9 (copy)
 local v22 = u11[p21];
 local v23 = LocalPlayer:FindFirstChild(p21) ~= nil;
 u9[v22].Switch:Set(v23);
 end;

 u5:Connect(LocalPlayer.ChildAdded, function(p24) -- Line: 141
 -- upvalues: u11 (copy), LocalPlayer (ref), u9 (copy)
 if u11[p24.Name] ~= nil then
 local Name = p24.Name;
 local v25 = u11[Name];
 local v26 = LocalPlayer:FindFirstChild(Name) ~= nil;
 u9[v25].Switch:Set(v26);
 end;
 end);
 u5:Connect(LocalPlayer.ChildRemoved, function(p27) -- Line: 146
 -- upvalues: u11 (copy), LocalPlayer (ref), u9 (copy)
 if u11[p27.Name] ~= nil then
 local Name = p27.Name;
 local v28 = u11[Name];
 local v29 = LocalPlayer:FindFirstChild(Name) ~= nil;
 u9[v28].Switch:Set(v29);
 end;
 end);

 local function updateSkills(p30) -- Line: 152
 -- upvalues: table_clear (ref), u11 (copy), u12 (copy), u9 (copy), SkillStats (ref), Skill_Switch_Adder (ref), u10 (copy), manage_cd (ref), LocalPlayer (ref), Stats (ref)
 table_clear(u11);
 table_clear(u12);
 local v31 = 0;

 for i = 1, 10 do
 local v32;

 if p30[i] == nil then
 v32 = i;
 else
 v31 = v31 + 1;
 v32 = i;
 end;
 end;

 local v33 = 0;

 for i = 1, 10 do
 local v34 = u9[i];
 local v35 = p30[i];
 table_clear(v34.SkillStats);
 local v36;

 if v35 == nil then
 v34.Name = "";
 v34.Hover:Refresh(nil, "", nil);
 v34.Hover:Hide();
 v34.FilteredSkillName = nil;
 u10[i] = nil;
 v34.Switch:Reset();
 v34.SplitHere:Reset();
 v34.Enabled:Set(false);
 v36 = i;
 else
 v33 = v33 + 1;
 v34.VisualIndex = v33;
 v34.EnabledCount = v31;
 local v37 = SkillStats.Get(v35.Name);

 if v37 then
 v36 = i;

 for i2, v in SkillStats.Icons do
 local v38 = nil;

 if i2 == "skills_to_play_over" then
 if v37.skills_to_play_over then
 if v37.skills_to_play_over.Blocking == true then
 v38 = v;
 end;
 end;
 elseif v37[i2] then
 v38 = v;
 end;

 if v38 ~= nil then
 table.insert(v34.SkillStats, v38);
 end;
 end;
 else
 v36 = i;
 end;

 v34.Hover:Refresh(nil, v35.Name, v34.SkillStats);
 u11[v35.Name .. Skill_Switch_Adder.extension] = v36;
 u12[v35.Name] = v36;

 if v34.Name ~= v35.Name then
 u10[v36] = nil;
 end;

 v34.FilteredSkillName = manage_cd.filter_cd_name(LocalPlayer, v35.Name);
 v34.Switch:Reset();
 v34.Icon:Set(v35.icon or "");
 v34.Name = v35.Name;
 v34.Holding.Rotation:Reset();
 v34.Holding.HoldingState:Reset();
 v34.Max = v35.Max_Hold;
 local _, v39 = Stats.GetRequirements(LocalPlayer, v35.Name);
 v34.Locked:Set(not v39);
 v34.SplitHere:Set(v35.SplitHere or nil);
 v34.Enabled:Set(true);
 end;
 end;

 for i in u11 do
 local v40 = u11[i];
 local v41 = LocalPlayer:FindFirstChild(i) ~= nil;
 u9[v40].Switch:Set(v41);
 end;

 if p30[1] == nil then
 game.ReplicatedStorage.CAM.Client.Components.Layout.Visibility.HUD.Skills.Value = 0;
 end;
 end;

 updateSkills(Skills_Provider.get_current_keys());
 u5:Connect(Skills_Provider.Keys_Changed, updateSkills);
 local valuesfolder = Utility.getvaluesfolder(LocalPlayer);
 local u42 = nil;
 u5:Connect(valuesfolder.ChildAdded, function(p43) -- Line: 244
 -- upvalues: StatsFetch (ref), LocalPlayer (ref), table_clone_ret (ref), u42 (ref), Skill_Controller (ref), u12 (copy), InputHandler (ref), u2 (ref), u10 (copy)
 if p43.Name == "Stun" and StatsFetch.HasStunBypass(LocalPlayer.Character) then
 return;
 end;

 if p43.Name ~= "Strict_Stun" and StatsFetch.HasCancelBypass(LocalPlayer.Character) then
 return;
 end;

 if table_clone_ret[p43.Name] and (u42 ~= nil and u42.Value ~= "") then
 Skill_Controller.Canceld = true;
 local v44 = u12[u42.Value];

 if v44 ~= nil and InputHandler.IsDown(u2[v44]) then
 u10[v44] = true;
 end;
 end;
 end);

 local function tryHold(p45: number, p46: string?) -- Line: 267
 -- upvalues: u9 (copy), u1 (ref), LocalPlayer (ref), Skill_Switch_Adder (ref), Skill_Controller (ref)
 local v47 = u9[p45];

 if v47 == nil or v47.Enabled.Value ~= true then
 return false;
 end;

 local Name = v47.Name;

 if Name == nil or (u1(Name) ~= "string" or Name == "") then
 return false;
 end;

 local v48 = LocalPlayer:FindFirstChild(Name .. Skill_Switch_Adder.extension);
 local v49;

 if v48 == nil then
 v49 = false;
 else
 v49 = v48:FindFirstChild("Disabled") == nil;
 end;

 if not Skill_Controller.Attempt_Hold(Name, p46) then
 return v49;
 end;

 Skill_Controller.CurrentMax = v47.Max;
 Skill_Controller.HeldSkill = v47.Name;

 return true;
 end;

 local u50 = 0;

 local function replay(p51: string) -- Line: 297
 -- upvalues: u50 (ref), u10 (copy), InputHandler (ref), u2 (ref), tryHold (copy), u5 (copy)
 u50 = u50 + 1;
 local u52 = u50;
 task.spawn(function() -- Line: 300
 -- upvalues: u10 (ref), InputHandler (ref), u2 (ref), tryHold (ref), u52 (copy), u50 (ref), u5 (ref)
 for i = 1, 16 do
 local _ = i;
 local v53 = false;

 for i2 = 1, 10 do
 local v54;

 if u10[i2] and InputHandler.IsDown(u2[i2]) then
 v53 = true;
 local v55 = InputHandler.HeldInput(u2[i2]);

 if v55 then
 v55 = v55.Name;
 end;

 if tryHold(i2, v55) then
 u10[i2] = nil;

 return;
 end;

 v54 = i2;
 else
 v54 = i2;
 end;
 end;

 if not v53 then
 return;
 end;

 task.wait(0.05);

 if u52 ~= u50 or not u5.IsActive then
 return;
 end;
 end;
 end);
 end;

 for i = 1, 10 do
 u5:Add(InputHandler.ListenTo(u2[i], function(p56: any, p57: any, p58: userdata?) -- Line: 325
 -- upvalues: u9 (copy), i (copy), u1 (ref), u3 (ref), Platform_Handler (ref), tryHold (copy), u10 (copy), InputHandler (ref), u50 (ref), u2 (ref), u5 (copy), LocalPlayer (ref), Skill_Controller (ref)
 local v59 = u9[i];

 if v59 == nil then
 return;
 end;

 local Name = v59.Name;

 if Name == nil or (u1(Name) ~= "string" or Name == "") then
 return;
 end;

 if p56 == "Down" then
 if p57 then
 return;
 end;

 local v60;

 if p58 == nil then
 v60 = nil;
 else
 v60 = p58.KeyCode.Name;
 end;

 if v60 ~= nil and (u3[i] and Platform_Handler.IsGamepad()) then
 v60 = v60 .. "+" .. Enum.KeyCode.ButtonL1.Name;
 end;

 if tryHold(i, v60) then
 u10[i] = nil;

 return;
 end;

 u10[i] = true;

 if InputHandler.IsAvailable() then
 u50 = u50 + 1;
 local u61 = u50;
 task.spawn(function() -- Line: 300
 -- upvalues: u10 (ref), InputHandler (ref), u2 (ref), tryHold (ref), u61 (copy), u50 (ref), u5 (ref)
 for i2 = 1, 16 do
 local _ = i2;
 local v62 = false;

 for i3 = 1, 10 do
 local v63;

 if u10[i3] and InputHandler.IsDown(u2[i3]) then
 v62 = true;
 local v64 = InputHandler.HeldInput(u2[i3]);

 if v64 then
 v64 = v64.Name;
 end;

 if tryHold(i3, v64) then
 u10[i3] = nil;

 return;
 end;

 v63 = i3;
 else
 v63 = i3;
 end;
 end;

 if not v62 then
 return;
 end;

 task.wait(0.05);

 if u61 ~= u50 or not u5.IsActive then
 return;
 end;
 end;
 end);
 end;
 elseif p56 == "Up" then
 u10[i] = nil;

 if p58 == nil then
 local v65 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("SHC");

 if v65 ~= nil and v65.Value == Name then
 Skill_Controller.UnHoldBoolean = true;
 end;
 end;
 end;
 end), true);
 local _ = i;
 end;

 u5:Add(InputHandler.Available:Connect(function(p66: boolean) -- Line: 365
 -- upvalues: u50 (ref), u10 (copy), InputHandler (ref), u2 (ref), tryHold (copy), u5 (copy)
 if p66 then
 u50 = u50 + 1;
 local u67 = u50;
 task.spawn(function() -- Line: 300
 -- upvalues: u10 (ref), InputHandler (ref), u2 (ref), tryHold (ref), u67 (copy), u50 (ref), u5 (ref)
 for i = 1, 16 do
 local _ = i;
 local v68 = false;

 for i2 = 1, 10 do
 local v69;

 if u10[i2] and InputHandler.IsDown(u2[i2]) then
 v68 = true;
 local v70 = InputHandler.HeldInput(u2[i2]);

 if v70 then
 v70 = v70.Name;
 end;

 if tryHold(i2, v70) then
 u10[i2] = nil;

 return;
 end;

 v69 = i2;
 else
 v69 = i2;
 end;
 end;

 if not v68 then
 return;
 end;

 task.wait(0.05);

 if u67 ~= u50 or not u5.IsActive then
 return;
 end;
 end;
 end);
 end;
 end), true);
 u5:Add(InputHandler.ListenTo("Screen", function(p71) -- Line: 373
 -- upvalues: u50 (ref), u10 (copy), InputHandler (ref), u2 (ref), tryHold (copy), u5 (copy)
 if p71 == "Up" then
 u50 = u50 + 1;
 local u72 = u50;
 task.spawn(function() -- Line: 300
 -- upvalues: u10 (ref), InputHandler (ref), u2 (ref), tryHold (ref), u72 (copy), u50 (ref), u5 (ref)
 for i = 1, 16 do
 local _ = i;
 local v73 = false;

 for i2 = 1, 10 do
 local v74;

 if u10[i2] and InputHandler.IsDown(u2[i2]) then
 v73 = true;
 local v75 = InputHandler.HeldInput(u2[i2]);

 if v75 then
 v75 = v75.Name;
 end;

 if tryHold(i2, v75) then
 u10[i2] = nil;

 return;
 end;

 v74 = i2;
 else
 v74 = i2;
 end;
 end;

 if not v73 then
 return;
 end;

 task.wait(0.05);

 if u72 ~= u50 or not u5.IsActive then
 return;
 end;
 end;
 end);
 end;
 end), true);
 u5:Add(InputHandler.ListenTo("Combat", function(p76) -- Line: 380
 -- upvalues: u50 (ref), u10 (copy), InputHandler (ref), u2 (ref), tryHold (copy), u5 (copy)
 if p76 == "Up" then
 u50 = u50 + 1;
 local u77 = u50;
 task.spawn(function() -- Line: 300
 -- upvalues: u10 (ref), InputHandler (ref), u2 (ref), tryHold (ref), u77 (copy), u50 (ref), u5 (ref)
 for i = 1, 16 do
 local _ = i;
 local v78 = false;

 for i2 = 1, 10 do
 local v79;

 if u10[i2] and InputHandler.IsDown(u2[i2]) then
 v78 = true;
 local v80 = InputHandler.HeldInput(u2[i2]);

 if v80 then
 v80 = v80.Name;
 end;

 if tryHold(i2, v80) then
 u10[i2] = nil;

 return;
 end;

 v79 = i2;
 else
 v79 = i2;
 end;
 end;

 if not v78 then
 return;
 end;

 task.wait(0.05);

 if u77 ~= u50 or not u5.IsActive then
 return;
 end;
 end;
 end);
 end;
 end), true);
 task.spawn(function() -- Line: 388
 -- upvalues: LocalPlayer (ref), u5 (copy), u42 (ref), Skill_Controller (ref), u9 (copy), os_clock (ref), refreshAnyHolding (copy), InputHandler (ref), u2 (ref), u10 (copy), u50 (ref), tryHold (copy)
 while LocalPlayer ~= nil and (LocalPlayer.Character ~= nil and u5.IsActive) do
 u42 = LocalPlayer.Character:FindFirstChild("SHC");

 if u42 ~= nil then
 local CurrentMax = Skill_Controller.CurrentMax;
 local v81 = nil;

 for i = 1, 10 do
 local v82 = u9[i];
 local v83;

 if v82 == nil or not v82.Enabled.Value then
 v83 = i;
 else
 local v84;

 if u42.Value == nil or u42.Value == "" then
 v84 = false;
 else
 v84 = u42.Value == v82.Name;
 end;

 if v84 == true then
 local Attribute = u42:GetAttribute("last_performed");

 if Attribute ~= nil and CurrentMax ~= nil then
 v81 = v81 or os_clock() - Attribute;

 if v82.Holding.Is == true then
 v82.Holding.Rotation:Set(v81 / CurrentMax * 360);
 end;
 end;
 end;

 local v85 = u42:FindFirstChild(v82.FilteredSkillName or v82.Name);
 local v86 = v85 ~= nil;

 if v82.CoolDownCurrent ~= v86 then
 v82.CoolDownCurrent = v86;
 v82.CoolDown:Set(v86);
 end;

 if v86 then
 local v87 = (os_clock() - v85:GetAttribute("Started")) / v85.Value;
 v82.Holding.Rotation:Set((1 - v87) * 360);
 end;

 if v82.Holding.Is == v84 then
 v83 = i;
 else
 v82.Holding.Is = v84;
 v82.Holding.HoldingState:Set(v84);
 refreshAnyHolding();

 if v84 == true then
 v82.HoldStartedAt = os_clock();
 v83 = i;
 elseif InputHandler.IsDown(u2[i]) then
 local v88 = os_clock() - (v82.HoldStartedAt or 0);
 local v89;

 if v82.Max == nil or v82.Max <= 0 then
 v89 = false;
 else
 v89 = v82.Max - 0.25 <= v88;
 end;

 if v89 then
 v83 = i;
 else
 u10[i] = true;
 u50 = u50 + 1;
 local u90 = u50;
 task.spawn(function() -- Line: 300
 -- upvalues: u10 (ref), InputHandler (ref), u2 (ref), tryHold (ref), u90 (copy), u50 (ref), u5 (ref)
 for i2 = 1, 16 do
 local _ = i2;
 local v91 = false;

 for i3 = 1, 10 do
 local v92;

 if u10[i3] and InputHandler.IsDown(u2[i3]) then
 v91 = true;
 local v93 = InputHandler.HeldInput(u2[i3]);

 if v93 then
 v93 = v93.Name;
 end;

 if tryHold(i3, v93) then
 u10[i3] = nil;

 return;
 end;

 v92 = i3;
 else
 v92 = i3;
 end;
 end;

 if not v91 then
 return;
 end;

 task.wait(0.05);

 if u90 ~= u50 or not u5.IsActive then
 return;
 end;
 end;
 end);
 v83 = i;
 end;
 else
 v83 = i;
 end;
 end;
 end;
 end;
 end;

 task.wait(0.05);
 end;
 end);

 if p8 == nil then
 return u5:Create("Frame")({
 Name = "SkillsHolder",
 Parent = p6,
 AnchorPoint = Vector2.new(0.5, 1),
 Position = UDim2.new(0.5, 0, 0.93, -5),
 Size = UDim2.fromScale(0.25, 0.25),
 u5:Create("UIAspectRatioConstraint")({}),
 u5:Create("UIListLayout")({
 VerticalAlignment = Enum.VerticalAlignment.Bottom,
 FillDirection = Enum.FillDirection.Horizontal,
 HorizontalAlignment = Enum.HorizontalAlignment.Center,
 Padding = UDim.new(0.1, 0),
 SortOrder = Enum.SortOrder.LayoutOrder
 }),
 BackgroundTransparency = 1,
 u5:Iterate(u9, function(p94, p95, p96) -- Line: 485
 -- upvalues: script_Skill (ref)
 return script_Skill(p96, p94, p95);
 end)
 });
 end;

 for i, v in u9 do
 local v97 = p8[Utility.numberToWords(i)];

 if v97 ~= nil then
 u5:Create("Frame")({
 Parent = v97,
 Name = "Slot",
 Size = UDim2.fromScale(1, 1),
 BackgroundTransparency = 1,
 SkillSlot(u5, i, v)
 });
 end;
 end;
end;
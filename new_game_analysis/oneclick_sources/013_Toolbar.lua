-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local script_MasteryItem = require(script.MasteryItem);
local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);
local FightingStyles = require(ReplicatedStorage.CAM.Global.Collectibles.FightingStyles);
local ItemIcon = require(ReplicatedStorage.CAM.Global.Collectibles.ItemIcon);
local ItemRequirements = require(ReplicatedStorage.CAM.Global.Collectibles.ItemRequirements);
local Character_info_provider = require(ReplicatedStorage.CAM.Global.Character_info_provider);
local GetMasteryStatus = require(ReplicatedStorage.CAM.Global.SkillService.GetMasteryStatus);
local ToolbarItemRestrictions = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.ToolbarItemRestrictions);
local Checker = require(ReplicatedStorage.CAM.Global.Checker);
local Platform_Handler = require(ReplicatedStorage.CAM.Client.Controllers.Platform_Handler);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local InputHandler = require(ReplicatedStorage.CAM.Client.Components.Client.InputHandler);
require(ReplicatedStorage.Packages.faye);
local SlotDragger = require(ReplicatedStorage.CAM.Client.Components.Misc.Utilities.SlotDragger);
local SlotNumber = require(ReplicatedStorage.CAM.Client.Components.Layout.ResetOnSpawn.Mobile.SlotNumber);
local Vector2_new_ret = Vector2.new(0.93, 0.93);
local BottomHudLift = gameSettings.BottomHudLift;
local PadHintRaise = gameSettings.PadHintRaise;

local function CycleHint(p1: any, p2: string, p3) -- Line: 33
 -- upvalues: Utility (copy)
 return Utility.AddTag(p1:Create("Frame")({
 BackgroundTransparency = 1,
 Name = p2,
 AnchorPoint = p3,
 Position = UDim2.fromScale(p3.X, p3.Y),
 Size = UDim2.fromOffset(20, 20)
 }), "UIkey");
end;

local Items_Config = LocalPlayer:FindFirstChild("Items_Config");

if Items_Config == nil then
 Items_Config = Instance.new("Folder");
 local IntValue = Instance.new("IntValue");
 IntValue.Parent = Items_Config;
 IntValue.Name = "Equipped";
 Items_Config.Name = "Items_Config";
 Items_Config.Parent = LocalPlayer;
end;

local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
Items_Config.Equipped.Changed:Connect(function() -- Line: 53
 -- upvalues: SignalEvent (copy), Items_Config (ref)
 SignalEvent.ToServer("Item_Equip", Items_Config.Equipped.Value);
end);
local u4 = { "One", "Two", "Three", "Four", "Five" };
local u5 = {
 One = 1,
 Two = 2,
 Three = 3,
 Four = 4,
 Five = 5
};
local u6 = { "Toolbar_1st", "Toolbar_2nd", "Toolbar_3rd", "Toolbar_4th", "Toolbar_5th" };
local Data = Utility.GetData(LocalPlayer, true);
local script_Tool = require(script.Tool);
local ToolScripts = ReplicatedStorage.ToolScripts;
local u7 = {};

local function getToolScript(p8: string) -- Line: 87
 -- upvalues: u7 (copy), Items (copy), ToolScripts (copy)
 if u7[p8] ~= nil then
 return u7[p8] or nil;
 end;

 local v9 = Items[p8];
 local v10;

 if v9 then
 v10 = v9.ToolScript or p8;
 else
 v10 = p8;
 end;

 local v11 = ToolScripts:FindFirstChild(v10);

 if v11 then
 v11 = v11:FindFirstChild(v10);
 end;

 u7[p8] = v11 and require(v11) or false;

 return u7[p8] or nil;
end;

local u12 = {};

local function hasServerToolScript(p13: string) -- Line: 102
 -- upvalues: u12 (copy), Items (copy), ToolScripts (copy)
 if u12[p13] ~= nil then
 return u12[p13];
 end;

 local v14 = Items[p13];
 local v15;

 if v14 then
 v15 = v14.ToolScript or p13;
 else
 v15 = p13;
 end;

 local v16 = ToolScripts:FindFirstChild(v15);
 local v17;

 if v16 == nil then
 v17 = false;
 else
 v17 = v16:FindFirstChild(v15 .. "Server") ~= nil;
 end;

 u12[p13] = v17;

 return u12[p13];
end;

local u18 = nil;
local u19 = 0;

return function(u20: any, p21: any, p22: any, p23: table?) -- Line: 133
 -- upvalues: Platform_Handler (copy), GetMasteryStatus (copy), u4 (copy), ToolbarItemRestrictions (copy), u5 (copy), Items_Config (ref), Data (copy), u18 (ref), u19 (ref), Character_info_provider (copy), LocalPlayer (copy), getToolScript (copy), ItemRequirements (copy), SignalEvent (copy), u12 (copy), Items (copy), ToolScripts (copy), InputHandler (copy), u6 (copy), SlotDragger (copy), Checker (copy), gameSettings (copy), ItemIcon (copy), FightingStyles (copy), script_Tool (copy), SlotNumber (copy), Vector2_new_ret (copy), PadHintRaise (copy), BottomHudLift (copy), CycleHint (copy), script_MasteryItem (copy)
 local u24 = u20:Value(Platform_Handler.Platform.Value ~= "Mobile");
 u20:Connect(Platform_Handler.Platform.Changed.Event, function() -- Line: 144
 -- upvalues: u24 (copy), Platform_Handler (ref)
 u24:Set(Platform_Handler.Platform.Value ~= "Mobile");
 end);
 local u25 = u20:Value(GetMasteryStatus.GetMasteries());
 u20:Connect(GetMasteryStatus.Changed, function(p26) -- Line: 148
 -- upvalues: u25 (copy)
 u25:Set(p26);
 end);
 local u27 = {};

 for i = 1, 5 do
 u27[i] = {
 Key = u4[i],
 Id = u20:Value(0),
 Restrictions = u20:Value({})
 };
 local _ = i;
 end;

 for i, v in ToolbarItemRestrictions.CurrentRestrictions do
 local u28 = u5[i];

 local function updateRestriction() -- Line: 162
 -- upvalues: v (copy), Items_Config (ref), u28 (copy), u27 (copy)
 if v.Restrictions.Locked and Items_Config.Equipped.Value == u28 then
 Items_Config.Equipped.Value = 0;
 end;

 u27[u28].Restrictions:Set(v.Restrictions);
 end;

 if v.Restrictions.Locked and Items_Config.Equipped.Value == u28 then
 Items_Config.Equipped.Value = 0;
 end;

 u27[u28].Restrictions:Set(v.Restrictions);
 u20:Connect(v.Changed, updateRestriction);
 end;

 local function updToolbarEquips() -- Line: 171
 -- upvalues: u27 (copy), Data (ref), u4 (ref)
 for i = 1, 5 do
 u27[i].Id:Set(Data.Inventory.Toolbar[u4[i]].Value);
 local _ = i;
 end;
 end;

 updToolbarEquips();

 for _, child in pairs(Data.Inventory.Toolbar:GetChildren()) do
 u20:Connect(child.Changed, updToolbarEquips);
 end;

 local u29 = nil;
 local u30 = nil;
 local u31 = false;
 local u32 = false;
 local u33 = nil;
 local Value = Items_Config.Equipped.Value;
 local u34 = true;

 local function stopIdleAnim() -- Line: 204
 -- upvalues: u18 (ref), u19 (ref)
 if u18 then
 u18:Stop();
 u18 = nil;
 end;

 u19 = math.random();
 end;

 local function onEquipChanged() -- Line: 215
 -- upvalues: Items_Config (ref), u34 (ref), Character_info_provider (ref), LocalPlayer (ref), Data (ref), u4 (ref), getToolScript (ref), u30 (ref), u29 (ref), Value (ref), ItemRequirements (ref), u33 (ref), u32 (ref), u31 (ref), SignalEvent (ref), Platform_Handler (ref), u18 (ref), u19 (ref), u12 (ref), Items (ref), ToolScripts (ref), onEquipChanged (copy)
 local Value2 = Items_Config.Equipped.Value;
 local v35 = u34;
 u34 = false;

 if Value2 > 0 and not v35 then
 local ItemFromId = Character_info_provider.GetItemFromId(LocalPlayer, Data.Inventory.Toolbar[u4[Value2]].Value);
 local v36;

 if ItemFromId then
 v36 = getToolScript(ItemFromId.Name);
 else
 v36 = ItemFromId;
 end;

 if u30 ~= nil and (ItemFromId and (ItemFromId.Name == u30 and v36 == u29)) then
 Value = Value2;

 return;
 end;

 if ItemFromId ~= nil and not ItemRequirements.SatisfiesEquip(Data, ItemFromId.Name) then
 Items_Config.Equipped.Value = Value == Value2 and 0 or Value;

 return;
 end;

 if v36 and v36.check then
 local success, result = pcall(v36.check, LocalPlayer.Character, ItemFromId.Name);

 if success and result == false then
 Items_Config.Equipped.Value = Value == Value2 and 0 or Value;

 return;
 end;
 end;
 end;

 if u33 then
 u33:Disconnect();
 u33 = nil;
 end;

 if u32 then
 u32 = false;

 if u29 and u29.MouseUp then
 task.spawn(u29.MouseUp, LocalPlayer.Character, u30);
 end;

 if u31 then
 SignalEvent.ToServer("Tool_Mouse", "Up", Platform_Handler.mousepos(nil, u29 and u29.MouseParams));
 end;
 end;

 if u29 and u29.UnEquipped then
 task.spawn(u29.UnEquipped, LocalPlayer.Character, u30);
 end;

 u29 = nil;
 u30 = nil;
 u31 = false;

 if u18 then
 u18:Stop();
 u18 = nil;
 end;

 u19 = math.random();

 if Value2 > 0 then
 local ItemFromId = Character_info_provider.GetItemFromId(LocalPlayer, Data.Inventory.Toolbar[u4[Value2]].Value);

 if ItemFromId then
 local v37 = getToolScript(ItemFromId.Name);
 local Name = ItemFromId.Name;
 local v38;

 if u12[Name] == nil then
 local v39 = Items[Name];
 local v40;

 if v39 then
 v40 = v39.ToolScript or Name;
 else
 v40 = Name;
 end;

 local v41 = ToolScripts:FindFirstChild(v40);
 local v42;

 if v41 == nil then
 v42 = false;
 else
 v42 = v41:FindFirstChild(v40 .. "Server") ~= nil;
 end;

 u12[Name] = v42;
 v38 = u12[Name];
 else
 v38 = u12[Name];
 end;

 if v37 or v38 then
 u29 = v37;
 u30 = ItemFromId.Name;
 u31 = v38;

 if v37 and v37.Equipped then
 task.spawn(v37.Equipped, LocalPlayer.Character, ItemFromId.Name);
 end;
 end;

 local v43 = Items[ItemFromId.Name];

 if v43 and not (v43.HasCombat or (v43.NoToolIdle or v37 == nil and v43.UseIdle ~= true)) then
 local v44 = ToolScripts:FindFirstChild(v43.ToolScript or ItemFromId.Name);
 local u45 = v44 ~= nil and v44:FindFirstChild("ToolIdleAnimation") or Character_info_provider.get_core_anim(LocalPlayer, "toolidle");

 if u45 then
 local math_random_ret = math.random();
 u19 = math_random_ret;
 task.spawn(function() -- Line: 306
 -- upvalues: LocalPlayer (ref), u19 (ref), math_random_ret (copy), u18 (ref), u45 (copy), onEquipChanged (ref)
 local v46 = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait();

 if u19 ~= math_random_ret then
 return;
 end;

 local v47 = v46:FindFirstChildOfClass("Humanoid") or v46:WaitForChild("Humanoid", 5);

 if v47 == nil or u19 ~= math_random_ret then
 return;
 end;

 local v48 = v47:FindFirstChildOfClass("Animator") or v47:WaitForChild("Animator", 5);

 if v48 == nil or u19 ~= math_random_ret then
 return;
 end;

 u18 = v48:LoadAnimation(u45);
 u18:Play();

 for i = 1, 5 do
 task.wait(0.075);

 if u19 ~= math_random_ret then
 break;
 end;

 if u18 == nil or not u18.IsPlaying then
 onEquipChanged();

 return;
 end;

 local _ = i;
 end;
 end);
 end;
 end;
 end;

 local v49 = Data.Inventory.Toolbar[u4[Value2]];

 if v49 then
 u33 = v49.Changed:Connect(function(p50) -- Line: 335
 -- upvalues: SignalEvent (ref), Items_Config (ref), onEquipChanged (ref)
 SignalEvent.ToServer("Item_Equip", Items_Config.Equipped.Value);
 onEquipChanged();
 end);
 end;
 end;

 Value = Value2;
 end;

 u20:Connect(Items_Config.Equipped.Changed, onEquipChanged);
 onEquipChanged();

 if Items_Config.Equipped.Value > 0 then
 SignalEvent.ToServer("Item_Equip", Items_Config.Equipped.Value);
 end;

 u20:Connect(LocalPlayer.CharacterRemoving, function() -- Line: 358
 -- upvalues: u29 (ref), u30 (ref), u31 (ref), u18 (ref), u19 (ref)
 if u29 and u29.UnEquipped then
 u29.UnEquipped();
 end;

 u29 = nil;
 u30 = nil;
 u31 = false;

 if u18 then
 u18:Stop();
 u18 = nil;
 end;

 u19 = math.random();
 end);
 u20:Add(InputHandler.ScreenClicked(function(p51, p52) -- Line: 376
 -- upvalues: u30 (ref), u32 (ref), u29 (ref), LocalPlayer (ref), u31 (ref), SignalEvent (ref), Platform_Handler (ref)
 if p51 == "Down" then
 if not p52 and u30 ~= nil then
 u32 = true;

 if u29 and u29.MouseDown then
 task.spawn(u29.MouseDown, LocalPlayer.Character, u30);
 end;

 if u31 then
 SignalEvent.ToServer("Tool_Mouse", "Down", Platform_Handler.mousepos(nil, u29 and u29.MouseParams));
 end;
 end;
 elseif p51 == "Up" and u32 then
 u32 = false;

 if u29 and u29.MouseUp then
 task.spawn(u29.MouseUp, LocalPlayer.Character, u30);
 end;

 if u31 then
 SignalEvent.ToServer("Tool_Mouse", "Up", Platform_Handler.mousepos(nil, u29 and u29.MouseParams));
 end;
 end;
 end), true);

 for i = 1, 5 do
 u20:Add(InputHandler.ListenTo(u6[i], function(p53, p54) -- Line: 404
 -- upvalues: u27 (copy), i (copy), Items_Config (ref)
 if p53 ~= "Down" or p54 then
 return;
 end;

 local v55 = u27[i].Restrictions:Get();

 if not (v55.Locked or v55.ActionsDisabled) then
 if Items_Config.Equipped.Value == i then
 Items_Config.Equipped.Value = 0;

 return;
 end;

 Items_Config.Equipped.Value = i;
 end;
 end), true);
 local _ = i;
 end;

 local u59 = SlotDragger(u20, {
 Target = p22,

 Backdrop = function(p56) -- Line: 421, Name: Backdrop
 return p56:Create("ImageLabel")({
 Name = "Bg",
 ZIndex = -1,
 Image = "http://www.roblox.com/asset/?id=134657809787110",
 BackgroundTransparency = 1,
 AnchorPoint = Vector2.new(0.5, 0.5),
 Position = UDim2.fromScale(0.5, 0.5),
 Size = UDim2.fromScale(2.75, 2.75),
 ImageColor3 = Color3.new(0.15, 0.15, 0.15)
 });
 end,

 OnDrop = function(p57: string, p58: string) -- Line: 433, Name: OnDrop
 -- upvalues: u27 (copy), u5 (ref), Checker (ref), LocalPlayer (ref), Data (ref), SignalEvent (ref)
 if u27[u5[p58]].Restrictions:Get().ActionsDisabled then
 return;
 end;

 if Checker.DenyLoadoutChange(LocalPlayer) then
 return;
 end;

 local Value2 = Data.Inventory.Toolbar[p57].Value;
 local Value3 = Data.Inventory.Toolbar[p58].Value;
 Data.Inventory.Toolbar[p58].Value = Value2;
 Data.Inventory.Toolbar[p57].Value = Value3;
 SignalEvent.ToServer("Toolbar_Equip", p58, Value2, p57);
 end
 });
 local u77 = u20:Space(function(p60: any, p61: table, p62: any, p63: any, p64: any, p65: any, p66: any, p67: any, p68: any, p69: any, p70: any) -- Line: 450
 -- upvalues: Items_Config (ref), u59 (copy), ToolbarItemRestrictions (ref), gameSettings (ref), Character_info_provider (ref), LocalPlayer (ref), ItemIcon (ref), FightingStyles (ref)
 local Value2 = Items_Config.Equipped.Value;
 local v71 = p61.Restrictions:Get();

 if Value2 ~= p60.LastId or not (u59.Dragging:Compare(p60.LastDrag) and (u59.Hover:Compare(p60.LastHover) and v71.Locked == p60.LastLocked)) then
 local v72 = u59.Dragging:Get();
 local v73 = u59.Hover:Get();
 local Locked = v71.Locked;
 local v74 = (v72 == p60.Key or (v73 ~= p60.Key or v72 == nil)) and (v72 == p60.Key and 3 or (Locked and 5 or (Value2 == p60.Index and 1 or 2))) or 4;

 if v74 ~= p60.State then
 if v74 == 1 then
 p64:Set(UDim2.fromScale(1.15, 1.15));
 p65:Set(0.75);
 p63:Set(0.65);
 p62:Set(Color3.new(1, 1, 1));
 p67:Reset();
 p68:Reset();
 p69:Reset();
 elseif v74 == 3 then
 p69:Reset();
 p64:Reset();
 p65:Reset();
 p63:Reset(0.5);
 p62:Reset();
 p67:Set(1);
 p68:Set(0.7);
 elseif v74 == 4 then
 p62:Set(Color3.new(1, 1, 1));
 p63:Set(0.75);
 p64:Set(UDim2.fromScale(1.15, 1.15));
 p65:Set(0);
 p67:Set(1);
 p68:Set(0.7);
 p69:Reset();
 elseif v74 == 5 then
 p64:Reset();
 p69:Set(0.2);
 p65:Reset();
 p63:Reset();
 p62:Reset();
 p67:Set(0.75);
 p68:Reset();
 elseif v74 == 6 then
 p64:Reset();
 p69:Set(0.2);
 p65:Reset();
 p63:Reset();
 p62:Reset();
 p67:Set(0.75);
 p68:Reset();
 else
 p69:Reset();
 p64:Reset();
 p65:Reset();
 p63:Reset();
 p62:Reset();
 p67:Reset();
 p68:Reset();
 end;

 p60.State = v74;
 end;

 p60.LastLocked = Locked;
 p60.LastId = Value2;
 p60.LastDrag = v72;
 p60.LastHover = v73;
 end;

 if v71.Locked then
 p70:Set(ToolbarItemRestrictions.Inventory.Locked.Icon);
 elseif v71.NoSave then
 p70:Set(ToolbarItemRestrictions.Inventory.NoSave.Icon);
 p69:Set(gameSettings.noSaveOverlayTransparency);
 else
 p69:Reset();
 end;

 if not p61.Id:Compare(p60.LastTool) or p60.LastToolIsStyle == true then
 local v75 = p61.Id:Get();
 local ItemFromId = Character_info_provider.GetItemFromId(LocalPlayer, v75);
 p60.LastToolIsStyle = false;
 local v76;

 if ItemFromId == nil then
 v76 = "";
 else
 v76 = ItemIcon.For(LocalPlayer, ItemFromId.Name);
 p60.LastToolIsStyle = ItemFromId.Name == FightingStyles.TOOL_NAME;
 end;

 p66:Set(v76);
 p60.LastTool = p61.Id:Get();
 end;
 end);
 u77:Connect(Items_Config.Equipped.Changed);
 u77:Connect(u59.Dragging.Changed);
 u77:Connect(u59.Hover.Changed);

 for _, v in ipairs(u27) do
 u77:Connect(v.Restrictions.Changed);
 u77:Connect(v.Id.Changed);
 end;

 local function pokeStylePresenter() -- Line: 574
 -- upvalues: u77 (copy)
 u77:Call();
 end;

 u20:Connect(Data.Powers.FightingStyle.Changed, pokeStylePresenter);
 u20:Connect(Data.Race.Changed, pokeStylePresenter);

 if p23 == nil then
 local function canEquip(p78: number) -- Line: 620
 -- upvalues: Data (ref), u4 (ref), u27 (copy), Character_info_provider (ref), LocalPlayer (ref), ItemRequirements (ref), getToolScript (ref)
 local Value2 = Data.Inventory.Toolbar[u4[p78]].Value;

 if Value2 == 0 then
 return false;
 end;

 local v79 = u27[p78].Restrictions:Get();

 if v79.Locked or v79.ActionsDisabled then
 return false;
 end;

 local ItemFromId = Character_info_provider.GetItemFromId(LocalPlayer, Value2);

 if ItemFromId == nil then
 return false;
 end;

 if not ItemRequirements.SatisfiesEquip(Data, ItemFromId.Name) then
 return false;
 end;

 local v80 = getToolScript(ItemFromId.Name);

 if v80 and v80.check then
 local success, result = pcall(v80.check, LocalPlayer.Character, ItemFromId.Name);

 if success and result == false then
 return false;
 end;
 end;

 return true;
 end;

 local function cycle(p81: number) -- Line: 635
 -- upvalues: Items_Config (ref), u4 (ref), canEquip (copy)
 local Value2 = Items_Config.Equipped.Value;

 for i = 1, #u4 do
 local v82 = (Value2 - 1 + p81 * i) % #u4 + 1;

 if Value2 == 0 then
 v82 = (p81 > 0 and i - 1 or #u4 - i) % #u4 + 1;
 end;

 if canEquip(v82) then
 Items_Config.Equipped.Value = v82;

 return;
 end;

 local _ = i;
 end;
 end;

 u20:Add(InputHandler.ListenTo("Toolbar_Prev", function(p83, p84) -- Line: 648
 -- upvalues: cycle (copy)
 if p83 == "Down" and not p84 then
 cycle(-1);
 end;
 end), true);
 u20:Add(InputHandler.ListenTo("Toolbar_Next", function(p85, p86) -- Line: 651
 -- upvalues: cycle (copy)
 if p85 == "Down" and not p86 then
 cycle(1);
 end;
 end), true);
 local u87 = u20:Value(0);
 local u88 = u20:Value(Platform_Handler.IsGamepad());
 u20:Connect(Platform_Handler.Platform.Changed.Event, function() -- Line: 659
 -- upvalues: u88 (copy), Platform_Handler (ref)
 u88:Set(Platform_Handler.IsGamepad());
 end);

 return u20:Create("Frame")({
 Name = "Toolbar",
 Visible = u24,
 Size = UDim2.fromScale(0.4, 0.4),
 AnchorPoint = Vector2.new(0.5, 1),
 Position = UDim2.new(0.5, 0, 1, -gameSettings.BottomHudLift),
 Parent = p21,
 BackgroundTransparency = 1,
 u20:Create("UIAspectRatioConstraint")({}),
 u20:Create("Frame")({
 Name = "Cycle",
 Visible = u88,
 AnchorPoint = Vector2.new(0.5, 0),
 Position = UDim2.new(0.5, 0, 1, -PadHintRaise),
 Size = u20:Do(function(p89) -- Line: 683
 -- upvalues: u87 (copy), BottomHudLift (ref)
 return UDim2.new(0, p89(u87), 0, BottomHudLift);
 end),
 BackgroundTransparency = 1,
 CycleHint(u20, "Toolbar_Prev", Vector2.new(0, 0.5)),
 CycleHint(u20, "Toolbar_Next", Vector2.new(1, 0.5))
 }),
 u20:Create("Frame")({
 Name = "SkillHolder",
 Size = UDim2.fromScale(1, 1),
 BackgroundTransparency = 1,
 u20:Create("UIListLayout")({
 Name = "List",
 HorizontalAlignment = Enum.HorizontalAlignment.Center,
 VerticalAlignment = Enum.VerticalAlignment.Center,
 FillDirection = Enum.FillDirection.Horizontal,
 Padding = UDim.new(0.15, 0),

 [u20:GetSignal("GetPropertyChangedSignal", "AbsoluteContentSize", true)] = function(p90: userdata) -- Line: 700
 -- upvalues: u87 (copy)
 u87:Set(p90.AbsoluteContentSize.X);
 end
 }),
 u20:Iterate(u27, function(p91, p92, p93) -- Line: 704
 -- upvalues: script_Tool (ref), Items_Config (ref), u77 (copy), u59 (copy)
 return script_Tool(p93, p91, p92, Items_Config.Equipped, u77, u59);
 end)
 }),

 After = function(p94) -- Line: 708, Name: After
 -- upvalues: u20 (copy), u25 (copy), script_MasteryItem (ref)
 return u20:Create("Frame")({
 Name = "MasteryHolder",
 Position = UDim2.fromScale(0.5, 0.5),
 AnchorPoint = Vector2.new(0.5, 0.5),
 ZIndex = -1,
 Size = UDim2.fromScale(6, 1),
 BackgroundTransparency = 1,
 u20:Create("Frame")({
 Name = "Actual",
 Size = UDim2.fromScale(1, 0.7),
 AnchorPoint = Vector2.new(0, 1),
 Position = UDim2.fromScale(1.025, 0.85),
 BackgroundTransparency = 1,
 u20:Create("UIListLayout")({
 FillDirection = Enum.FillDirection.Horizontal,
 HorizontalAlignment = Enum.HorizontalAlignment.Left,
 VerticalAlignment = Enum.VerticalAlignment.Center,
 Padding = UDim.new(0, 5)
 }),
 u20:State(function(p95, p96, p97) -- Line: 728
 -- upvalues: u25 (ref), script_MasteryItem (ref)
 local v98 = p95(u25);

 if v98 ~= nil then
 local v99 = {};

 for _, v in ipairs(v98) do
 table.insert(v99, script_MasteryItem(p96, v));
 end;

 return v99;
 end;
 end)
 })
 });
 end
 });
 end;

 for i, v in u27 do
 local v100 = p23[u4[i]];

 if v100 ~= nil then
 u20:Create("Frame")({
 Parent = v100,
 Name = "Slot",
 Size = UDim2.fromScale(1, 1),
 BackgroundTransparency = 1,
 script_Tool(u20, i, v, Items_Config.Equipped, u77, u59),
 SlotNumber(u20, i, Vector2_new_ret)
 });
 end;
 end;
end;
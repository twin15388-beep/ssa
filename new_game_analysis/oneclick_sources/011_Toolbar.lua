-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local GradientButton = require(ReplicatedStorage.CAM.Client.Components.Misc.Buttons.GradientButton);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local Checker = require(ReplicatedStorage.CAM.Global.Checker);
local LocalPlayer = game:GetService("Players").LocalPlayer;
local Data = Utility.GetData(LocalPlayer, true);
local Character_info_provider = require(ReplicatedStorage.CAM.Global.Character_info_provider);
local FightingStyles = require(ReplicatedStorage.CAM.Global.Collectibles.FightingStyles);
local ItemIcon = require(ReplicatedStorage.CAM.Global.Collectibles.ItemIcon);
local script_Slot = require(script.Slot);
local Platform_Handler = require(ReplicatedStorage.CAM.Client.Controllers.Platform_Handler);
local u1 = {
 Data.Inventory.Toolbar.One,
 Data.Inventory.Toolbar.Two,
 Data.Inventory.Toolbar.Three,
 Data.Inventory.Toolbar.Four,
 Data.Inventory.Toolbar.Five
};
require(ReplicatedStorage.Packages.faye);
local SlotDragger = require(ReplicatedStorage.CAM.Client.Components.Misc.Utilities.SlotDragger);
local u2 = {
 One = 1,
 Two = 2,
 Three = 3,
 Four = 4,
 Five = 5
};
local u3 = "One";

return function(p4: any, p5: userdata, u6: any) -- Line: 49
 -- upvalues: u3 (ref), Data (copy), u1 (copy), Character_info_provider (copy), LocalPlayer (copy), u2 (copy), SlotDragger (copy), Checker (copy), SignalEvent (copy), ItemIcon (copy), FightingStyles (copy), Platform_Handler (copy), script_Slot (copy), GradientButton (copy)
 local u7 = p4:Value(Color3.new(0.666667, 1, 0.498039));
 local u8 = p4.Info(0.2);
 local u9 = p4:Value("Equip");
 local u10 = p4:Value(u3);
 local u11 = false;

 local function updItems() -- Line: 70
 -- upvalues: u6 (copy), Data (ref), u10 (copy), u11 (ref), u1 (ref)
 local v12 = u6:Get();

 if v12 ~= nil then
 local Value = v12.Id.Value;

 for _, child in ipairs(Data.Inventory.Toolbar:GetChildren()) do
 if child.Value == Value then
 u10:Set(child.Name);

 return;
 end;
 end;
 end;

 if u11 or v12 == nil then
 return;
 end;

 for i = 1, 5 do
 if u1[i].Value == 0 then
 u10:Set(u1[i].Name);

 return;
 end;

 local _ = i;
 end;

 u10:Set(u1[5].Name);
 end;

 updItems();
 local u13 = true;
 local u14 = p4:Value(false);

 local function updSlot() -- Line: 105
 -- upvalues: u10 (copy), u6 (copy), Character_info_provider (ref), LocalPlayer (ref), u13 (ref), u7 (copy), u9 (copy), u14 (copy), Data (ref), u11 (ref)
 local v15 = u10:Get();

 if u6:Get() ~= nil then
 if u6:Compare(Character_info_provider.getEquippedItems(LocalPlayer, v15)) then
 u13 = false;
 u7:Set(Color3.new(1, 0, 0));
 u9:Set("UnEquip");
 else
 u9:Reset();
 u7:Reset();
 u13 = true;
 end;

 u14:Set(true);

 return;
 end;

 local v16 = Data.Inventory.Toolbar:FindFirstChild(v15);

 if not (u11 and (v16 ~= nil and v16.Value ~= 0)) then
 u14:Set(false);

 return;
 end;

 u13 = false;
 u7:Set(Color3.new(1, 0, 0));
 u9:Set("UnEquip");
 u14:Set(true);
 end;

 updSlot();

 for _, v in pairs(u1) do
 p4:Connect(v.Changed, updSlot);
 end;

 u10.Changed:Connect(updSlot);
 p4:Connect(u6.Changed, updSlot);
 p4:Connect(u10.Changed, function() -- Line: 142
 -- upvalues: u3 (ref), u10 (copy)
 u3 = u10:Get();
 end);

 local function tryToolbarEquip(p17: string) -- Line: 149
 -- upvalues: LocalPlayer (ref), Data (ref), u2 (ref)
 local Items_Config = LocalPlayer:FindFirstChild("Items_Config");

 if Items_Config == nil or Items_Config:FindFirstChild("Equipped") == nil then
 return;
 end;

 if Items_Config.Equipped.Value ~= 0 then
 return;
 end;

 local v18 = Data.Inventory.Toolbar:FindFirstChild(p17);

 if v18 == nil or v18.Value == 0 then
 return;
 end;

 local v19 = u2[p17];

 if v19 ~= nil then
 Items_Config.Equipped.Value = v19;
 end;
 end;

 local function onSlotClicked(p20: string) -- Line: 164
 -- upvalues: u11 (ref), updSlot (copy), tryToolbarEquip (copy)
 u11 = true;
 updSlot();
 tryToolbarEquip(p20);
 end;

 local u24 = SlotDragger(p4, {
 Target = p5,

 Backdrop = function(p21) -- Line: 176, Name: Backdrop
 return p21:Create("Frame")({
 Name = "Bg",
 ZIndex = -1,
 p21:Create("UICorner")({
 CornerRadius = UDim.new(0.2)
 }),
 AnchorPoint = Vector2.new(0.5, 0.5),
 Position = UDim2.fromScale(0.5, 0.5),
 Size = UDim2.fromScale(1, 1),
 BackgroundTransparency = 0,
 BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
 });
 end,

 IconScaleType = Enum.ScaleType.Crop,

 OnDrop = function(p22: string, p23: string) -- Line: 191, Name: OnDrop
 -- upvalues: Checker (ref), LocalPlayer (ref), Data (ref), SignalEvent (ref)
 if Checker.DenyLoadoutChange(LocalPlayer) then
 return;
 end;

 local Value = Data.Inventory.Toolbar[p22].Value;
 local Value2 = Data.Inventory.Toolbar[p23].Value;
 Data.Inventory.Toolbar[p23].Value = Value;
 Data.Inventory.Toolbar[p22].Value = Value2;
 SignalEvent.ToServer("Toolbar_Equip", p23, Value, p22);
 end
 });
 local u39 = p4:Space(function(p25: any, p26: userdata, p27: any, p28: any, p29: any, p30: any, p31: any, p32: any, p33: any) -- Line: 206
 -- upvalues: u24 (copy), u10 (copy), Character_info_provider (ref), LocalPlayer (ref), u6 (copy), ItemIcon (ref), FightingStyles (ref)
 local v34 = u24.Dragging:Get();
 local v35 = u24.Hover:Get();
 local v36 = (v34 == p25.Key or (v35 ~= p25.Key or v34 == nil)) and (v34 == p25.Key and 5 or (v34 == nil and (u10:Compare(p26.Name) == true and 1 or (u24.Hover:Compare(p26.Name) and 2 or 3)) or 3)) or 4;

 if v36 ~= p25.LastState then
 p25.LastState = v36;

 if v36 == 1 then
 p29:Set(0.25);
 p30:Set(0);
 p31:Set(0);
 p32:Reset();
 p33:Reset();
 elseif v36 == 2 then
 p31:Set(0.45);
 p30:Set(0.3);
 p29:Set(0.75);
 p32:Reset();
 p33:Reset();
 elseif v36 == 4 then
 p32:Set(Color3.new(0.35, 0.35, 0.35));
 p31:Set(1);
 p30:Set(0);
 p29:Set(0);
 p33:Reset();
 elseif v36 == 5 then
 p32:Reset();
 p33:Set(0.65);
 p31:Set(1);
 p30:Set(1);
 p29:Set(1);
 else
 p33:Reset();
 p32:Reset();
 p31:Reset();
 p30:Reset();
 p29:Reset();
 end;
 end;

 local Value = p26.Value;

 if Value ~= p25.LastNew or p25.LastNewIsStyle == true then
 local v37 = false;
 local v38 = "";
 p25.LastNewIsStyle = false;

 if Value ~= nil then
 local ItemFromId = Character_info_provider.GetItemFromId(LocalPlayer, Value);

 if ItemFromId ~= nil then
 v37 = u6:Compare(ItemFromId);
 v38 = ItemIcon.For(LocalPlayer, ItemFromId.Name);
 p25.LastNewIsStyle = ItemFromId.Name == FightingStyles.TOOL_NAME;
 end;
 end;

 p27:Set(v37);
 p28:Set(v38);
 p25.LastNew = Value;
 end;
 end);

 for _, v in pairs(u1) do
 u39:Connect(v.Changed, v.Name);
 end;

 u39:Connect(u10.Changed);
 u39:Connect(u6.Changed);
 p4:Connect(u6.Changed, updItems);
 u39:Connect(u24.Dragging.Changed);
 u39:Connect(u24.Hover.Changed);
 u39:Connect(Data.Powers.FightingStyle.Changed);
 u39:Connect(Data.Race.Changed);
 local u40 = Platform_Handler.Platform.Value == "Mobile" and 1.4 or 1;

 return p4:Create("Frame")({
 Size = UDim2.fromScale(0.6, 1),
 BackgroundTransparency = 1,
 p4:Create("Frame")({
 BackgroundTransparency = 1,
 AnchorPoint = Vector2.new(0.5, 0),
 Position = UDim2.fromScale(0.5, 0),
 Size = UDim2.fromScale(u40, u40 * 0.4),
 p4:Create("UIListLayout")({
 HorizontalAlignment = Enum.HorizontalAlignment.Center,
 VerticalAlignment = Enum.VerticalAlignment.Center,
 FillDirection = Enum.FillDirection.Horizontal,
 SortOrder = Enum.SortOrder.Name,
 Padding = UDim.new(0.05, 0)
 }),
 p4:Iterate(u1, function(p41, p42, p43) -- Line: 312
 -- upvalues: script_Slot (ref), u10 (copy), u6 (copy), u39 (copy), u24 (copy), onSlotClicked (copy)
 return script_Slot(p43, p42, u10, u6, u39, u24, onSlotClicked);
 end)
 }),
 p4:State(function(p44, u45) -- Line: 317
 -- upvalues: u14 (copy), u40 (copy), u8 (copy), GradientButton (ref), u6 (copy), u13 (ref), u10 (copy), SignalEvent (ref), u7 (copy), u9 (copy)
 if p44(u14) then
 return u45:Create("CanvasGroup")({
 Name = "ButtonGroup",
 AnchorPoint = Vector2.new(0.5, 0),
 Position = UDim2.fromScale(0.5, (u40 - 1) * 0.4 + 0.7),
 Size = UDim2.fromScale(0.28, 0.4),
 BackgroundTransparency = 1,
 GroupTransparency = u45:Animation(0, u8),

 OnClean = function() -- Line: 329, Name: OnClean
 -- upvalues: u45 (copy), u8 (ref)
 return {
 GroupTransparency = u45:Animation(1, u8)
 };
 end,

 GradientButton(u45, {
 GradientRotation = -90,
 Properties = {
 AnchorPoint = Vector2.new(0.5, 0.5),
 Position = UDim2.fromScale(0.5, 0.5),
 Size = UDim2.fromScale(0.9, 1)
 },
 GradientTransparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.75, 0.5), NumberSequenceKeypoint.new(1, 0.5) }),
 TextXAlignment = Enum.TextXAlignment.Center,

 Clicked = function() -- Line: 344, Name: Clicked
 -- upvalues: u6 (ref), u13 (ref), u10 (ref), SignalEvent (ref)
 local v46 = u6:Get();

 if v46 == nil and u13 then
 return;
 end;

 local v47 = u10:Get();
 local v48 = v46 == nil and 0 or (v46.Id.Value or 0);

 if v47 ~= "" then
 if not u13 then
 SignalEvent.ToServer("Toolbar_Equip", v47, 0);

 return;
 end;

 SignalEvent.ToServer("Toolbar_Equip", v47, v48);
 end;
 end,

 BgColor = u45:Animation(u7, u8),
 Text = u9,
 ContentColor = Color3.new(1, 1, 1)
 })
 });
 end;
 end)
 });
end;
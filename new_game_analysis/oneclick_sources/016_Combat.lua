-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local Players = game:GetService("Players");
local faye = require(ReplicatedStorage.Packages.faye);
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local MobileLayout = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.MobileLayout);
local SavedLayout = require(script.Parent.SavedLayout);
local MobileButtonScale = require(game:GetService("ReplicatedStorage").CAM.Client.Modules.MobileButtonScale);
local LayoutActions = require(script.Parent.LayoutActions);
local Bounds = require(script.Parent.Bounds);
local EditPlate = require(script.Parent.EditPlate);
local HolderDrag = require(script.Parent.HolderDrag);
local JumpButton = require(script.Parent.JumpButton);
local InputHandler = require(ReplicatedStorage.CAM.Client.Components.Client.InputHandler);
local Mounted = require(ReplicatedStorage.CAM.Client.Modules.GamePlay.Mounted);
local CombatAvailable = require(ReplicatedStorage.CAM.Client.Modules.GamePlay.CombatAvailable);
local Character_info_provider = require(ReplicatedStorage.CAM.Global.Character_info_provider);
local Skills_Provider = require(ReplicatedStorage.CAM.Client.Controllers.Skills_Provider);
local CurPower = ReplicatedStorage.CAM.Client.Controllers.Skills_Provider:WaitForChild("CurPower");
local u1 = faye.Info(0.12);
local UDim2_fromScale_ret = UDim2.fromScale(1, 1);
local Size = MobileLayout.Toolbar.Size;
local Color3_new_ret = Color3.new();
local Color3_new_ret2 = Color3.new();
local Color3_new_ret3 = Color3.new(1, 1, 1);
local Color3_new_ret4 = Color3.new(1, 1, 1);
local Color3_new_ret5 = Color3.new(0.5, 0.5, 0.5);
local Color3_new_ret6 = Color3.new();

return function(u2: any, p3: userdata, u4: any) -- Line: 92
 -- upvalues: CombatAvailable (copy), Mounted (copy), Character_info_provider (copy), Players (copy), CurPower (copy), Skills_Provider (copy), MobileLayout (copy), Size (copy), MobileButtonScale (copy), JumpButton (copy), Bounds (copy), SavedLayout (copy), Color3_new_ret (copy), Color3_new_ret2 (copy), Color3_new_ret3 (copy), Color3_new_ret4 (copy), Color3_new_ret5 (copy), Color3_new_ret6 (copy), InputHandler (copy), UserInputService (copy), UDim2_fromScale_ret (copy), u1 (copy), BunchaIcons (copy), EditPlate (copy), HolderDrag (copy), LayoutActions (copy)
 local u5 = u2:Value("");

 local function refreshMode() -- Line: 109
 -- upvalues: CombatAvailable (ref), Mounted (ref), u5 (copy), Character_info_provider (ref), Players (ref)
 if CombatAvailable.Is() and not Mounted.Is() then
 u5:Set("Combat");

 return;
 end;

 if Character_info_provider.Get_equipped_tool(Players.LocalPlayer) == nil then
 u5:Set("");

 return;
 end;

 u5:Set("Tool");
 end;

 refreshMode();
 u2:Connect(CurPower.Changed, refreshMode);
 u2:Add(Skills_Provider.Keys_Changed:Connect(refreshMode), true);
 local u6 = u2:Value(Mounted.Is());
 local Character = Players.LocalPlayer.Character;

 if Character ~= nil then
 u2:Add(Mounted.Watch(Character, function(p7: boolean) -- Line: 135
 -- upvalues: u6 (copy), refreshMode (copy)
 u6:Set(p7);
 refreshMode();
 end));
 end;

 local function shown(p8) -- Line: 142
 -- upvalues: u5 (copy), u6 (copy)
 local v9 = p8(u5);

 if v9 == "Combat" then
 return p8(u6) ~= true;
 end;

 return v9 == "Tool";
 end;

 local u10 = 0;
 local u11 = 0;
 local u12 = u2:Value(Vector2.zero);
 local u13 = u2:Value(UDim2.fromOffset(MobileLayout.Combat.X, MobileLayout.Combat.Y));
 local u14 = u2:Value(UDim2.fromOffset(Size, Size));
 local u15 = nil;

 local function updatePosition() -- Line: 157
 -- upvalues: MobileButtonScale (ref), Size (ref), u14 (copy), MobileLayout (ref), u10 (ref), u11 (ref), u12 (copy), u15 (ref), JumpButton (ref), Bounds (ref), u13 (copy)
 local v16 = MobileButtonScale.Get();
 local v17 = Size * v16;
 local Vector2_new_ret = Vector2.new(v17, v17);
 u14:Set(UDim2.fromOffset(v17, v17));
 local v18 = Vector2.new(MobileLayout.Combat.X * v16 + u10, MobileLayout.Combat.Y * v16 + u11) + u12:Get();
 local v19 = u15;

 if v19 ~= nil and v19.AbsoluteSize.X > 0 then
 local v20 = v18 - Vector2.new(JumpButton.RowShift(v19), 0);
 v18 = Bounds.ClampCornerOffset(v20, Vector2_new_ret, v19.AbsoluteSize);
 end;

 u13:Set(UDim2.fromOffset(v18.X, v18.Y));
 end;

 SavedLayout(u2, "Combat", nil, function(p21, p22) -- Line: 175
 -- upvalues: u10 (ref), u11 (ref), updatePosition (copy)
 u10 = p21;
 u11 = p22;
 updatePosition();
 end);
 u2:Connect(u12.Changed, updatePosition);
 u2:Add(MobileButtonScale.Changed:Connect(updatePosition));
 local u23 = u2:Value(Color3_new_ret);
 local u24 = u2:Value(0.8);
 local u25 = u2:Value(Color3_new_ret2);
 local u26 = u2:Value(Color3_new_ret3);

 local function showPressed(p27: boolean) -- Line: 187
 -- upvalues: u23 (copy), Color3_new_ret4 (ref), Color3_new_ret (ref), u24 (copy), u25 (copy), Color3_new_ret5 (ref), Color3_new_ret2 (ref), u26 (copy), Color3_new_ret6 (ref), Color3_new_ret3 (ref)
 local v28;

 if p27 then
 v28 = Color3_new_ret4;
 else
 v28 = Color3_new_ret;
 end;

 u23:Set(v28);
 u24:Set(p27 and 0 or 0.8);
 local v29;

 if p27 then
 v29 = Color3_new_ret5;
 else
 v29 = Color3_new_ret2;
 end;

 u25:Set(v29);
 local v30;

 if p27 then
 v30 = Color3_new_ret6;
 else
 v30 = Color3_new_ret3;
 end;

 u26:Set(v30);
 end;

 local u31 = nil;
 local u32 = nil;

 local function release() -- Line: 198
 -- upvalues: u32 (ref), u31 (ref), u23 (copy), Color3_new_ret (ref), u24 (copy), u25 (copy), Color3_new_ret2 (ref), u26 (copy), Color3_new_ret3 (ref), InputHandler (ref)
 local v33 = u32;
 u31 = nil;
 u32 = nil;
 u23:Set(Color3_new_ret);
 u24:Set(0.8);
 u25:Set(Color3_new_ret2);
 u26:Set(Color3_new_ret3);

 if v33 ~= nil then
 InputHandler.VirtualRelease(v33);
 end;
 end;

 u2:Connect(UserInputService.InputEnded, function(p34: userdata) -- Line: 207
 -- upvalues: u31 (ref), u32 (ref), u23 (copy), Color3_new_ret (ref), u24 (copy), u25 (copy), Color3_new_ret2 (ref), u26 (copy), Color3_new_ret3 (ref), InputHandler (ref)
 if p34 ~= u31 then
 return;
 end;

 local v35 = u32;
 u31 = nil;
 u32 = nil;
 u23:Set(Color3_new_ret);
 u24:Set(0.8);
 u25:Set(Color3_new_ret2);
 u26:Set(Color3_new_ret3);

 if v35 ~= nil then
 InputHandler.VirtualRelease(v35);
 end;
 end);
 u2:Add(function() -- Line: 213
 -- upvalues: u31 (ref), u32 (ref), u23 (copy), Color3_new_ret (ref), u24 (copy), u25 (copy), Color3_new_ret2 (ref), u26 (copy), Color3_new_ret3 (ref), InputHandler (ref)
 if u31 ~= nil then
 local v36 = u32;
 u31 = nil;
 u32 = nil;
 u23:Set(Color3_new_ret);
 u24:Set(0.8);
 u25:Set(Color3_new_ret2);
 u26:Set(Color3_new_ret3);

 if v36 ~= nil then
 InputHandler.VirtualRelease(v36);
 end;
 end;
 end);

 return u2:Create("Frame")({
 Name = "Combat",
 AnchorPoint = Vector2.new(1, 1),
 Size = u14,
 Position = u2:Do(function(p37) -- Line: 221
 -- upvalues: UDim2_fromScale_ret (ref), u13 (copy)
 return UDim2_fromScale_ret + p37(u13);
 end),
 BackgroundTransparency = 1,

 function(p38: userdata) -- Line: 225
 -- upvalues: u15 (ref), u2 (copy), updatePosition (copy)
 local Parent = p38.Parent;
 u15 = Parent;
 u2:Connect(Parent:GetPropertyChangedSignal("AbsoluteSize"), updatePosition);
 updatePosition();
 end,

 u2:Create("Frame")({
 Name = "Content",
 Size = UDim2.fromScale(1, 1),
 BackgroundTransparency = 1,
 Visible = u2:Do(function(p39) -- Line: 236
 -- upvalues: u4 (copy), u5 (copy), u6 (copy)
 local v40;

 if p39(u4) == true then
 v40 = false;
 else
 local v41 = p39(u5);

 if v41 == "Combat" then
 return p39(u6) ~= true;
 end;

 v40 = v41 == "Tool";
 end;

 return v40;
 end),
 u2:Create("ImageLabel")({
 Name = "Bg",
 BackgroundTransparency = 1,
 Image = "http://www.roblox.com/asset/?id=134657809787110",
 ImageTransparency = 0.3,
 Size = UDim2.fromScale(3.2249999999999996, 3.2249999999999996),
 AnchorPoint = Vector2.new(0.5, 0.5),
 Position = UDim2.fromScale(0.5, 0.5),
 ImageColor3 = u2:Animation(u25, u1)
 }),
 u2:Create("ImageLabel")({
 Name = "CircleSelect",
 BackgroundTransparency = 1,
 Image = "http://www.roblox.com/asset/?id=119489413451678",
 Size = UDim2.fromScale(0.8, 0.8),
 AnchorPoint = Vector2.new(0.5, 0.5),
 Position = UDim2.fromScale(0.5, 0.5),
 ImageTransparency = u2:Animation(u24, u1),
 ImageColor3 = u2:Animation(u23, u1)
 }),
 u2:Create("ImageLabel")({
 Name = "Icon",
 ZIndex = 2,
 BackgroundTransparency = 1,
 Size = UDim2.fromScale(0.46, 0.46),
 AnchorPoint = Vector2.new(0.5, 0.5),
 Position = UDim2.fromScale(0.5, 0.5),
 Image = u2:Do(function(p42) -- Line: 267
 -- upvalues: u5 (copy), BunchaIcons (ref)
 if p42(u5) == "Combat" then
 return BunchaIcons.Fist;
 end;

 return BunchaIcons.Mouse;
 end),
 ImageColor3 = u2:Animation(u26, u1)
 }),
 u2:Create("TextButton")({
 Name = "Press",
 BackgroundTransparency = 1,
 Text = "",
 AutoButtonColor = false,
 ZIndex = 5,
 AnchorPoint = Vector2.new(0.5, 0.5),
 Position = UDim2.fromScale(0.5, 0.5),
 Size = UDim2.fromScale(1.5, 1.5),

 InputBegan = function(p43: any, p44: userdata) -- Line: 286, Name: InputBegan
 -- upvalues: u31 (ref), u5 (copy), u32 (ref), u23 (copy), Color3_new_ret4 (ref), u24 (copy), u25 (copy), Color3_new_ret5 (ref), u26 (copy), Color3_new_ret6 (ref), InputHandler (ref)
 if u31 ~= nil then
 return;
 end;

 if p44.UserInputState ~= Enum.UserInputState.Begin then
 return;
 end;

 if p44.UserInputType ~= Enum.UserInputType.Touch and p44.UserInputType ~= Enum.UserInputType.MouseButton1 then
 return;
 end;

 local v45 = u5:Compare("Combat") and "Combat" or "Screen";
 u31 = p44;
 u32 = v45;
 u23:Set(Color3_new_ret4);
 u24:Set(0);
 u25:Set(Color3_new_ret5);
 u26:Set(Color3_new_ret6);
 InputHandler.VirtualPress(v45);
 end
 })
 }),
 EditPlate(u2, u4, {
 GlowScale = 3.2249999999999996,
 CircleScale = 0.8
 }),
 HolderDrag(u2, u4, u12, {
 Drop = function(p46) -- Line: 305, Name: Drop
 -- upvalues: u10 (ref), u11 (ref), updatePosition (copy), LayoutActions (ref)
 u10 = u10 + p46.X;
 u11 = u11 + p46.Y;
 updatePosition();
 LayoutActions.Move("Combat", nil, u10, u11);
 end,

 Tap = function() -- Line: 311, Name: Tap
 -- upvalues: u10 (ref), u11 (ref), updatePosition (copy), LayoutActions (ref)
 u10 = 0;
 u11 = 0;
 updatePosition();
 LayoutActions.Reset("Combat", nil);
 end
 })
 });
end;
-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Packages.faye);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local MobileLayout = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.MobileLayout);
local SavedLayout = require(script.Parent.SavedLayout);
local LayoutActions = require(script.Parent.LayoutActions);
local Bounds = require(script.Parent.Bounds);
local EditPlate = require(script.Parent.EditPlate);
local HolderDrag = require(script.Parent.HolderDrag);
local JumpButton = require(script.Parent.JumpButton);
local MobileButtonScale = require(game:GetService("ReplicatedStorage").CAM.Client.Modules.MobileButtonScale);
local Toolbar = require(ReplicatedStorage.CAM.Client.Components.Layout.ResetOnSpawn.HUD.CenterBottomContent.Toolbar);
local UDim2_fromScale_ret = UDim2.fromScale(1, 1);
local Size = MobileLayout.Toolbar.Size;
local Count = MobileLayout.Toolbar.Count;
local Vector2_new_ret = Vector2.new(0.93, 0.93);

return function(u1: any, u2: userdata, u3: any) -- Line: 42
 -- upvalues: Count (copy), Utility (copy), MobileLayout (copy), Size (copy), MobileButtonScale (copy), JumpButton (copy), Bounds (copy), SavedLayout (copy), UDim2_fromScale_ret (copy), Toolbar (copy), EditPlate (copy), Vector2_new_ret (copy), HolderDrag (copy), LayoutActions (copy)
 local u4 = {};
 local u5 = 0;

 return u1:Iterate(Count, function(p6: any, p7: any, p8: any, p9: userdata?) -- Line: 46
 -- upvalues: Utility (ref), MobileLayout (ref), u1 (copy), Size (ref), MobileButtonScale (ref), JumpButton (ref), Bounds (ref), SavedLayout (ref), UDim2_fromScale_ret (ref), u3 (copy), u4 (copy), u5 (ref), Count (ref), Toolbar (ref), u2 (copy), EditPlate (ref), Vector2_new_ret (ref), HolderDrag (ref), LayoutActions (ref)
 local u10 = Utility.numberToWords(p6);
 local u11, u12 = MobileLayout.ToolbarOffset(p6);
 local u13 = 0;
 local u14 = 0;
 local u15 = u1:Value(Vector2.zero);
 local u16 = u1:Value(UDim2.fromOffset(u11, u12));
 local u17 = u1:Value(UDim2.fromOffset(Size, Size));
 local u18 = nil;

 local function update() -- Line: 58
 -- upvalues: MobileButtonScale (ref), Size (ref), u11 (copy), u13 (ref), u12 (copy), u14 (ref), u15 (copy), u18 (ref), JumpButton (ref), Bounds (ref), u17 (copy), u16 (copy)
 local v19 = MobileButtonScale.Get();
 local v20 = Size * v19;
 local Vector2_new_ret2 = Vector2.new(v20, v20);
 local v21 = Vector2.new(u11 * v19 + u13, u12 * v19 + u14) + u15:Get();
 local v22 = u18;

 if v22 ~= nil and v22.AbsoluteSize.X > 0 then
 local v23 = v21 - Vector2.new(JumpButton.RowShift(v22), 0);
 v21 = Bounds.ClampCornerOffset(v23, Vector2_new_ret2, v22.AbsoluteSize);
 end;

 u17:Set(UDim2.fromOffset(v20, v20));
 u16:Set(UDim2.fromOffset(v21.X, v21.Y));
 end;

 u1:Add(MobileButtonScale.Changed:Connect(update));
 SavedLayout(u1, "Toolbar", u10, function(p24, p25) -- Line: 78
 -- upvalues: u13 (ref), u14 (ref), update (copy)
 u13 = p24;
 u14 = p25;
 update();
 end);
 u1:Connect(u15.Changed, update);
 update();

 return u1:Create("Frame")({
 Name = u10,
 AnchorPoint = Vector2.new(1, 1),
 Size = u17,
 Position = u1:Do(function(p26) -- Line: 88
 -- upvalues: UDim2_fromScale_ret (ref), u16 (copy)
 return UDim2_fromScale_ret + p26(u16);
 end),
 BackgroundTransparency = 1,
 u1:Create("Frame")({
 Name = "Content",
 Size = UDim2.fromScale(1, 1),
 BackgroundTransparency = 1,
 Visible = u1:Do(function(p27) -- Line: 97
 -- upvalues: u3 (ref)
 return p27(u3) ~= true;
 end),

 function(p28: userdata) -- Line: 100
 -- upvalues: u4 (ref), u10 (copy), u5 (ref), Count (ref), Toolbar (ref), u1 (ref), u2 (ref)
 u4[u10] = p28;
 u5 = u5 + 1;

 if u5 == Count then
 Toolbar(u1, nil, u2, u4);
 end;
 end
 }),
 EditPlate(u1, u3, {
 GlowScale = 2.15,
 CircleScale = 0.8,
 Number = {
 Index = p6,
 At = Vector2_new_ret
 }
 }),
 HolderDrag(u1, u3, u15, {
 Drop = function(p29) -- Line: 117, Name: Drop
 -- upvalues: u13 (ref), u14 (ref), update (copy), LayoutActions (ref), u10 (copy)
 u13 = u13 + p29.X;
 u14 = u14 + p29.Y;
 update();
 LayoutActions.Move("Toolbar", u10, u13, u14);
 end,

 Tap = function() -- Line: 123, Name: Tap
 -- upvalues: u13 (ref), u14 (ref), update (copy), LayoutActions (ref), u10 (copy)
 u13 = 0;
 u14 = 0;
 update();
 LayoutActions.Reset("Toolbar", u10);
 end
 }),

 function(p30: userdata) -- Line: 129
 -- upvalues: u18 (ref), u1 (ref), update (copy)
 local Parent = p30.Parent;
 u18 = Parent;
 u1:Connect(Parent:GetPropertyChangedSignal("AbsoluteSize"), update);
 update();
 end
 });
 end);
end;
-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
require(ReplicatedStorage.Packages.faye);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local MobileLayout = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.MobileLayout);
local SavedLayout = require(script.Parent.SavedLayout);
local MobileButtonScale = require(game:GetService("ReplicatedStorage").CAM.Client.Modules.MobileButtonScale);
local LayoutActions = require(script.Parent.LayoutActions);
local JumpButton = require(script.Parent.JumpButton);
local Bounds = require(script.Parent.Bounds);
local EditPlate = require(script.Parent.EditPlate);
local HolderDrag = require(script.Parent.HolderDrag);
local InputHandler = require(ReplicatedStorage.CAM.Client.Components.Client.InputHandler);
local Platform_Handler = require(ReplicatedStorage.CAM.Client.Controllers.Platform_Handler);
local Skills = require(ReplicatedStorage.CAM.Client.Components.Layout.ResetOnSpawn.HUD.CenterBottomContent.Skills);
local Skills_Provider = require(ReplicatedStorage.CAM.Client.Controllers.Skills_Provider);
local u1 = { "Skills_1st", "Skills_2nd", "Skills_3rd", "Skills_4th", "Skills_5th", "Skills_6th", "Skills_7th", "Skills_8th", "Skills_9th", "Skills_10th" };
local Count = MobileLayout.Skills.Count;
local Size = MobileLayout.Toolbar.Size;
local Vector2_new_ret = Vector2.new(0.16, 0.16);
local Vector2_new_ret2 = Vector2.new(0.5, 0.5);

return function(u2: any, u3: userdata, u4: any) -- Line: 65
 -- upvalues: Count (copy), Skills_Provider (copy), Utility (copy), u1 (copy), MobileLayout (copy), JumpButton (copy), MobileButtonScale (copy), Size (copy), Bounds (copy), UserInputService (copy), Platform_Handler (copy), InputHandler (copy), Skills (copy), EditPlate (copy), Vector2_new_ret (copy), Vector2_new_ret2 (copy), HolderDrag (copy), LayoutActions (copy), SavedLayout (copy)
 local u5 = {};
 local u6 = {};
 local u7 = 0;

 for i = 1, Count do
 u5[i] = u2:Value(false);
 local _ = i;
 end;

 local function readKeys(p8) -- Line: 84
 -- upvalues: Count (ref), u5 (copy)
 for i = 1, Count do
 local v9;

 if p8 == nil then
 v9 = false;
 else
 v9 = p8[i] ~= nil;
 end;

 u5[i]:Set(v9);
 local _ = i;
 end;
 end;

 readKeys(Skills_Provider.get_current_keys());
 u2:Connect(Skills_Provider.Keys_Changed, readKeys);

 return u2:Iterate(Count, function(p10: any, p11: any, p12: any, p13: userdata?) -- Line: 91
 -- upvalues: Utility (ref), u1 (ref), u2 (copy), MobileLayout (ref), JumpButton (ref), MobileButtonScale (ref), Size (ref), Bounds (ref), UserInputService (ref), Platform_Handler (ref), InputHandler (ref), u4 (copy), u5 (copy), u6 (copy), u7 (ref), Count (ref), Skills (ref), u3 (copy), EditPlate (ref), Vector2_new_ret (ref), Vector2_new_ret2 (ref), HolderDrag (ref), LayoutActions (ref), SavedLayout (ref)
 local u14 = Utility.numberToWords(p10);
 local u15 = u1[p10];
 local u16 = u2:Value(UDim2.new());
 local u17 = u2:Value(UDim2.new());
 local u18, u19 = MobileLayout.SkillOffset(p10);
 local u20 = 0;
 local u21 = 0;
 local u22 = u2:Value(Vector2.zero);
 local u23 = nil;

 local function update() -- Line: 104
 -- upvalues: u23 (ref), JumpButton (ref), MobileButtonScale (ref), Size (ref), u18 (copy), u19 (copy), u20 (ref), u21 (ref), u22 (copy), Bounds (ref), u16 (copy), u17 (copy)
 local v24 = u23;

 if v24 == nil then
 return;
 end;

 local v25, v26, v27 = JumpButton.Metrics(v24);
 local v28 = v25 - Vector2.new(0, v27);
 local v29 = MobileButtonScale.Get();
 local v30 = Size * v29;
 local v31 = v28 + (Vector2.new(u18, u19) * v29 + Vector2.new(u20, u21)) * v26 + u22:Get();

 if v24.AbsoluteSize.X > 0 then
 v31 = Bounds.ClampCentre(v31, Vector2.new(v30, v30), v24.AbsoluteSize);
 end;

 u16:Set(UDim2.fromOffset(v31.X, v31.Y));
 u17:Set(UDim2.fromOffset(v30, v30));
 end;

 local u32 = nil;
 u2:Connect(UserInputService.InputEnded, function(p33: userdata) -- Line: 124
 -- upvalues: u32 (ref), Platform_Handler (ref), InputHandler (ref), u15 (copy)
 if p33 ~= u32 then
 return;
 end;

 u32 = nil;
 Platform_Handler.EndAim(p33);
 InputHandler.VirtualRelease(u15);
 end);
 u2:Connect(u22.Changed, update);
 u2:Add(MobileButtonScale.Changed:Connect(update));

 return u2:Create("Frame")({
 Name = u14,
 AnchorPoint = Vector2.new(0.5, 0.5),
 Size = u17,
 Position = u16,
 BackgroundTransparency = 1,
 u2:Create("Frame")({
 Name = "Content",
 Size = UDim2.fromScale(1, 1),
 BackgroundTransparency = 1,
 Visible = u2:Do(function(p34) -- Line: 144
 -- upvalues: u4 (ref)
 return p34(u4) ~= true;
 end),
 u2:Create("TextButton")({
 Name = "Press",
 BackgroundTransparency = 1,
 Text = "",
 AutoButtonColor = false,
 ZIndex = 5,
 Visible = u5[p10],
 AnchorPoint = Vector2.new(0.5, 0.5),
 Position = UDim2.fromScale(0.5, 0.5),
 Size = UDim2.fromScale(1.05, 1.05),

 InputBegan = function(p35: any, p36: userdata) -- Line: 176, Name: InputBegan
 -- upvalues: u32 (ref), Platform_Handler (ref), InputHandler (ref), u15 (copy)
 if u32 ~= nil then
 return;
 end;

 if p36.UserInputState ~= Enum.UserInputState.Begin then
 return;
 end;

 if p36.UserInputType ~= Enum.UserInputType.Touch and p36.UserInputType ~= Enum.UserInputType.MouseButton1 then
 return;
 end;

 u32 = p36;
 Platform_Handler.BeginAim(p36);
 InputHandler.VirtualPress(u15);
 end
 }),

 function(p37: userdata) -- Line: 190
 -- upvalues: u6 (ref), u14 (copy), u7 (ref), Count (ref), Skills (ref), u2 (ref), u3 (ref)
 u6[u14] = p37;
 u7 = u7 + 1;

 if u7 == Count then
 Skills(u2, u3, u3, u6);
 end;
 end
 }),
 EditPlate(u2, u4, {
 GlowScale = 1.45,
 CircleScale = 0.95,
 VisualScale = 0.8,
 Number = {
 Index = p10,
 At = Vector2_new_ret,
 Anchor = Vector2_new_ret2
 }
 }),
 HolderDrag(u2, u4, u22, {
 Drop = function(p38) -- Line: 208, Name: Drop
 -- upvalues: u23 (ref), JumpButton (ref), u20 (ref), u21 (ref), update (copy), LayoutActions (ref), u14 (copy)
 local v39 = u23;

 if v39 == nil then
 return;
 end;

 local _, v40 = JumpButton.Metrics(v39);

 if v40 <= 0 then
 return;
 end;

 u20 = u20 + p38.X / v40;
 u21 = u21 + p38.Y / v40;
 update();
 LayoutActions.Move("Skills", u14, u20, u21);
 end,

 Tap = function() -- Line: 218, Name: Tap
 -- upvalues: u20 (ref), u21 (ref), update (copy), LayoutActions (ref), u14 (copy)
 u20 = 0;
 u21 = 0;
 update();
 LayoutActions.Reset("Skills", u14);
 end
 }),

 function(p41: userdata) -- Line: 224
 -- upvalues: u23 (ref), SavedLayout (ref), u2 (ref), u14 (copy), u20 (ref), u21 (ref), update (copy)
 local Parent = p41.Parent;
 u23 = Parent;
 SavedLayout(u2, "Skills", u14, function(p42, p43) -- Line: 231
 -- upvalues: u20 (ref), u21 (ref), update (ref)
 u20 = p42;
 u21 = p43;
 update();
 end);
 update();
 u2:Connect(Parent:GetPropertyChangedSignal("AbsoluteSize"), update);
 local workspace_CurrentCamera = workspace.CurrentCamera;

 if workspace_CurrentCamera ~= nil then
 u2:Connect(workspace_CurrentCamera:GetPropertyChangedSignal("ViewportSize"), update);
 end;
 end
 });
 end);
end;
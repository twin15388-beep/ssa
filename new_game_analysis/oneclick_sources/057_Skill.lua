-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local Skill_Switch_Adder = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Skill_Switch_Adder);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local faye = require(ReplicatedStorage.Packages.faye);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local u1 = faye.Info(0.2);

return function(p2: any, p3: number, u4: table, p5: any) -- Line: 23
 -- upvalues: u1 (copy), BunchaIcons (copy), Skill_Switch_Adder (copy), Utility (copy), gameSettings (copy)
 local v6 = p2:DelayValue(u4.Enabled):For(true, 0.25);
 local u7 = 0;
 local u8 = p2:Value(0.45);
 local u9 = p2:Value(0.45);
 local u10 = p2:Value(0);
 local u11 = p2:Value(Color3.new(0.1, 0.1, 0.1));
 local u12 = p2:Value(Color3.new());
 local u13 = p2:Value(Color3.new(1, 1, 1));
 local u14 = p2:Value(Color3.new(1, 1, 1));
 local u15 = p2:Value(UDim2.fromScale(1, 1));
 local u16 = p2.SpringInfo(0.3, 1, 0.5, nil, nil, 0);
 local u17 = p2:Value(0.25);
 local u18 = nil;
 local u19 = p2:Value(false);
 local u20 = nil;

 local function update() -- Line: 40
 -- upvalues: u4 (copy), u18 (ref), u19 (copy), u17 (copy), u20 (ref), u7 (ref), u16 (copy), u15 (copy), u14 (copy), u10 (copy), u12 (copy), u8 (copy), u11 (copy), u9 (copy), u13 (copy)
 local v21 = (u4.Holding.HoldingState:Compare(true) or u4.CoolDown:Compare(true)) and 1 or 0;

 if u18 ~= v21 then
 u18 = v21;

 if v21 == 1 then
 u19:Set(true);
 u17:Reset();
 else
 u19:Reset();
 u17:Set(1);
 end;
 end;

 local v22 = u4.Enabled:Compare(true) and (u4.Locked:Compare(true) and 4 or (u4.Switch:Compare(true) and 3 or (u4.Holding.HoldingState:Compare(true) and 2 or 1))) or 0;

 if u20 ~= v22 then
 u7 = 0.03 * ((u4.EnabledCount or 1) - ((u4.VisualIndex or 1) - 1));
 u16.DelayTime = u7;

 if v22 == 4 then
 u15:Reset();
 u14:Reset();
 u10:Set(0.5);
 u12:Reset();
 u8:Set(0.5);
 u11:Reset();
 u9:Set(0);
 u13:Set(Color3.new(1, 1, 1));
 elseif v22 == 1 then
 u14:Set(Color3.new(1, 0, 0));
 u15:Reset();
 u8:Reset();
 u9:Reset();
 u10:Reset();
 u13:Reset();
 u11:Reset();
 u12:Reset();
 elseif v22 == 3 then
 u15:Reset();
 u8:Reset();
 u9:Reset();
 u10:Set(1);
 u13:Reset();
 u11:Reset();
 u12:Reset();
 elseif v22 == 2 then
 u15:Reset();
 u14:Reset();
 u10:Reset();
 u12:Set(Color3.new(0.35, 0.35, 0.35));
 u8:Set(0.5);
 u11:Set(Color3.new(0.75, 0.75, 0.75));
 u9:Set(0);
 u13:Set(Color3.new());
 else
 u14:Reset();
 u15:Set(UDim2.fromScale());
 u8:Set(1);
 u9:Set(1);
 u10:Set(1);
 u13:Reset();
 u11:Reset();
 u12:Reset();
 end;

 u20 = v22;
 end;
 end;

 update();
 p2:Connect(u4.CoolDown.Changed, update);
 p2:Connect(u4.Enabled.Changed, update);
 p2:Connect(u4.Holding.HoldingState.Changed, update);
 p2:Connect(u4.Switch.Changed, update);

 if u4.Locked then
 p2:Connect(u4.Locked.Changed, update);
 end;

 return p2:Create("Frame")({
 p2:State(function(p23, p24) -- Line: 131
 -- upvalues: u4 (copy)
 local v25 = p23(u4.SplitHere);

 if v25 == 1 then
 return p24:Create("Frame")({
 Size = UDim2.fromScale(4.5, 1.1),
 AnchorPoint = Vector2.new(1, 0.5),
 Position = UDim2.fromScale(1.025, 0.5),
 Visible = p24:Do(function(p26) -- Line: 139
 -- upvalues: u4 (ref)
 return not p26(u4.Holding.HoldingState);
 end),
 p24:Create("UICorner")({
 CornerRadius = UDim.new(0.2)
 }),
 BackgroundTransparency = 0.65,
 BackgroundColor3 = Color3.new(0.5, 0.5, 0.5),
 p24:Create("UIGradient")({
 Rotation = 180,
 Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.4, 0.6), NumberSequenceKeypoint.new(1, 1) })
 }),
 p24:Create("UIStroke")({
 BorderOffset = UDim.new(0, -2),
 Color = Color3.new(1, 1, 1),
 Transparency = 0.45,
 p24:Create("UIGradient")({
 Rotation = 180,
 Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.2, 1), NumberSequenceKeypoint.new(1, 1) })
 })
 })
 });
 end;

 if v25 == 2 then
 return p24:Create("Frame")({
 Size = UDim2.fromScale(4.5, 1.1),
 AnchorPoint = Vector2.new(0, 0.5),
 Position = UDim2.fromScale(-0.025, 0.5),
 Visible = p24:Do(function(p27) -- Line: 174
 -- upvalues: u4 (ref)
 return not p27(u4.Holding.HoldingState);
 end),
 p24:Create("UICorner")({
 CornerRadius = UDim.new(0.2)
 }),
 BackgroundTransparency = 0.65,
 BackgroundColor3 = Color3.new(0.5, 0.5, 0.5),
 p24:Create("UIGradient")({
 Rotation = 0,
 Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.4, 0.6), NumberSequenceKeypoint.new(1, 1) })
 }),
 p24:Create("UIStroke")({
 BorderOffset = UDim.new(0, -2),
 Color = Color3.new(1, 1, 1),
 Transparency = 0.45,
 p24:Create("UIGradient")({
 Rotation = 0,
 Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.2, 1), NumberSequenceKeypoint.new(1, 1) })
 })
 })
 });
 end;
 end),
 Name = p3 .. "-Skill",
 LayoutOrder = p3,
 Size = p2:Animation(u15, u16, {
 From = UDim2.fromScale()
 }),
 Visible = p2:DelayValue(u4.Enabled):For(false, u7 + 0.2),
 BackgroundTransparency = 1,
 p2:Create("ImageLabel")({
 Name = "Bg",
 BackgroundTransparency = 1,
 Image = "http://www.roblox.com/asset/?id=109235190169711",
 Size = UDim2.fromScale(1.2, 1.2),
 AnchorPoint = Vector2.new(0.5, 0.5),
 Position = UDim2.fromScale(0.5, 0.5),
 ImageColor3 = p2:Animation(u12, u1),
 ImageTransparency = p2:Animation(u8, u1, {
 From = 1
 })
 }),
 p2:Create("ImageLabel")({
 Size = UDim2.fromScale(1.15, 1.15),
 BackgroundTransparency = 1,
 AnchorPoint = Vector2.new(0.5, 0.5),
 Position = UDim2.fromScale(0.5, 0.5),
 ImageColor3 = Color3.new(0.25, 0.25, 0.25),
 p2:Create("Frame")({
 Size = UDim2.fromScale(0.5, 1),
 Name = "Left",
 BackgroundTransparency = 1,
 ClipsDescendants = true,
 p2:Create("ImageLabel")({
 Visible = u19,
 Size = UDim2.fromScale(2, 1),
 BackgroundTransparency = 1,
 Image = "rbxassetid://72297746168397",
 ImageColor3 = u14,
 p2:Create("UIGradient")({
 Transparency = NumberSequence.new({
 NumberSequenceKeypoint.new(0, 0),
 NumberSequenceKeypoint.new(0.495, 0),
 NumberSequenceKeypoint.new(0.505, 1),
 NumberSequenceKeypoint.new(1, 1)
 }),
 Rotation = p2:Do(function(p28) -- Line: 250
 -- upvalues: u4 (copy)
 local v29 = 180 - p28(u4.Holding.Rotation);

 return math.clamp(v29, 0, 180);
 end)
 })
 })
 }),
 p2:Create("Frame")({
 Name = "Right",
 BackgroundTransparency = 1,
 ClipsDescendants = true,
 Position = UDim2.fromScale(0.5, 0),
 Size = UDim2.fromScale(0.5, 1),
 p2:Create("ImageLabel")({
 Visible = u19,
 Size = UDim2.fromScale(2, 1),
 Position = UDim2.fromScale(-1, 0),
 BackgroundTransparency = 1,
 ImageColor3 = u14,
 Image = "rbxassetid://72297746168397",
 p2:Create("UIGradient")({
 Transparency = NumberSequence.new({
 NumberSequenceKeypoint.new(0, 0),
 NumberSequenceKeypoint.new(0.495, 0),
 NumberSequenceKeypoint.new(0.505, 1),
 NumberSequenceKeypoint.new(1, 1)
 }),
 Rotation = p2:Do(function(p30) -- Line: 279
 -- upvalues: u4 (copy)
 local v31 = p30(u4.Holding.Rotation) - 180;

 return -math.clamp(v31, 0, 180);
 end)
 })
 })
 }),
 ImageTransparency = p2:Animation(u17, u1),
 Image = "rbxassetid://110991810001935"
 }),
 p2:Create("ImageLabel")({
 ZIndex = 3,
 Name = "Fg",
 BackgroundTransparency = 1,
 Image = "http://www.roblox.com/asset/?id=137188897938310",
 Size = UDim2.fromScale(1, 1),
 AnchorPoint = Vector2.new(0.5, 0.5),
 Position = UDim2.fromScale(0.5, 0.5),
 ImageColor3 = p2:Animation(u11, u1),
 ImageTransparency = p2:Animation(u9, u1, {
 From = 1
 })
 }),
 p2:Create("ImageLabel")({
 ZIndex = 4,
 Name = "Image",
 BackgroundTransparency = 1,
 Size = UDim2.fromScale(0.6, 0.6),
 AnchorPoint = Vector2.new(0.5, 0.5),
 Position = UDim2.fromScale(0.5, 0.5),
 ImageTransparency = p2:Animation(u10, u1, {
 From = 1
 }),
 ImageColor3 = p2:Animation(u13, u1),
 Image = u4.Icon
 }),
 p2:State(function(p32: function, p33: any, p34: userdata?) -- Line: 311
 -- upvalues: u4 (copy), BunchaIcons (ref)
 if p32(u4.Locked) then
 return p33:Create("ImageLabel")({
 ZIndex = 6,
 BackgroundTransparency = 1,
 AnchorPoint = Vector2.new(0.5, 0.5),
 Size = UDim2.fromScale(0.6, 0.6),
 Position = UDim2.fromScale(0.5, 0.5),
 Image = BunchaIcons.Locked
 });
 end;

 return p33:Create("TextButton")({
 ZIndex = 10,
 BackgroundTransparency = 1,
 Size = UDim2.new(1, 5, 1),

 MouseEnter = function() -- Line: 330, Name: MouseEnter
 -- upvalues: u4 (ref)
 if u4.Hover ~= nil then
 u4.Hover:Enter();
 end;
 end,

 MouseLeave = function() -- Line: 333, Name: MouseLeave
 -- upvalues: u4 (ref)
 if u4.Hover ~= nil then
 u4.Hover:Leave();
 end;
 end
 });
 end),
 p2:State(function(p35, u36) -- Line: 340
 -- upvalues: u4 (copy), Skill_Switch_Adder (ref), u1 (ref)
 if p35(u4.Switch) == true then
 return u36:Create("ImageLabel")({
 ZIndex = 6,
 BackgroundTransparency = 1,
 AnchorPoint = Vector2.new(0.5, 0.5),
 Size = UDim2.fromScale(0.95, 0.95),
 Position = UDim2.fromScale(0.5, 0.5),
 Image = Skill_Switch_Adder.Lever_Icon,
 ImageColor3 = Skill_Switch_Adder.Lever_Color,
 Rotation = u36:Animation(-25, u36.Info(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true, 0), {
 From = 25
 }),

 OnClean = function() -- Line: 351, Name: OnClean
 -- upvalues: u36 (copy), u1 (ref)
 return {
 ImageTransparency = u36:Animation(1, u1)
 };
 end
 });
 end;
 end),
 Utility.AddTag(p2:Create("Frame")({
 ZIndex = -1,
 Name = u4.Key,
 BackgroundTransparency = gameSettings.KeybindTextTransparency,
 Visible = v6,
 AnchorPoint = Vector2.new(0.5, 1),
 Size = gameSettings.KeybindTextSize,
 Position = UDim2.new(0.5, 0, 0, -3)
 }), "UIkey")
 });
end;
-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.CAM.Global.Character_info_provider);
local faye = require(ReplicatedStorage.Packages.faye);
local LocalPlayer = game.Players.LocalPlayer;
local ScreenEffects = require(ReplicatedStorage.CAM.Client.Components.Misc.ScreenEffects);
local u1 = faye.Info(0.2);
require(ReplicatedStorage.CAM.Global.Utility).GetData(LocalPlayer, true);
require(ReplicatedStorage.CAM.Client.Components.Misc.Utilities.SlotDragger);

return function(p2: any, u3: userdata, u4: any, p5: any, p6: any, u7: any, u8: function?) -- Line: 12
 -- upvalues: ScreenEffects (copy), u1 (copy)
 local u9 = p2:Value("");
 local v10 = {
 LastState = nil,
 Key = u3.Name
 };
 local v11 = p2:Value(0.95);
 local v12 = p2:Value(0.5);
 local v13 = p2:Value(0.35);
 local v14 = p2:Value(0.25);
 local v15 = p2:Value(Color3.new(0.15, 0.15, 0.15));
 local v16 = p2:Value(false);
 p6:Add({
 v10,
 u3,
 v16,
 u9,
 v11,
 v12,
 v13,
 v15,
 v14
 }, p2):Call():SetId(u3.Name);

 return p2:Create("Frame")({
 p2:Create("TextButton")({
 Size = UDim2.fromScale(1, 1),
 BackgroundTransparency = 1,
 ZIndex = 2,
 AutoButtonColor = false,

 MouseButton1Down = function(p17) -- Line: 38, Name: MouseButton1Down
 -- upvalues: u7 (copy), u3 (copy)
 u7:Begin(p17, u3.Name);
 end,

 function(p18) -- Line: 43
 -- upvalues: u7 (copy), u3 (copy), u9 (copy)
 u7:Attach(u3.Name, p18, function() -- Line: 44
 -- upvalues: u3 (ref), u9 (ref)
 if u3.Value == 0 then
 return nil;
 end;

 return u9:Get();
 end);
 end,

 MouseButton1Up = function() -- Line: 49, Name: MouseButton1Up
 -- upvalues: u7 (copy), ScreenEffects (ref), u4 (copy), u3 (copy), u8 (copy)
 if u7.Dragging:Compare(nil) then
 ScreenEffects.CircleClick();
 end;

 u4:Set(u3.Name);

 if u8 ~= nil and u7.Dragging:Compare(nil) then
 u8(u3.Name);
 end;
 end,

 MouseEnter = function() -- Line: 60, Name: MouseEnter
 -- upvalues: u7 (copy), u3 (copy)
 u7:SetHover(u3.Name);
 end,

 MouseLeave = function() -- Line: 63, Name: MouseLeave
 -- upvalues: u7 (copy), u3 (copy)
 u7:ClearHover(u3.Name);
 end
 }),
 Size = UDim2.fromScale(0.1595, 1),
 BackgroundColor3 = v15,
 BackgroundTransparency = v14,
 p2:Create("UICorner")({
 CornerRadius = UDim.new(0.2)
 }),
 p2:Create("UIStroke")({
 Color = Color3.new(1, 1, 1),
 Transparency = p2:Animation(v11, u1)
 }),
 p2:Create("ImageLabel")({
 BackgroundTransparency = 1,
 Size = UDim2.fromScale(1, 1),
 Image = u9,
 ImageTransparency = v13,
 ScaleType = Enum.ScaleType.Crop
 }),
 p2:Create("TextLabel")({
 BackgroundTransparency = 1,
 TextScaled = true,
 Size = UDim2.fromScale(1, 0.65),
 AnchorPoint = Vector2.new(0.5, 0),
 Position = UDim2.fromScale(0.5, 1),
 Text = u3.Name,
 Font = Enum.Font.SourceSansBold,
 TextColor3 = Color3.new(1, 1, 1),
 TextTransparency = v12
 }),
 p2:Create("Frame")({
 ZIndex = -1,
 Visible = v16,
 Size = UDim2.new(1, -5, 1, -5),
 Position = UDim2.fromScale(0.5, 0.5),
 AnchorPoint = Vector2.new(0.5, 0.5),
 BackgroundTransparency = 0.9,
 p2:Create("UICorner")({
 CornerRadius = UDim.new(0.25)
 }),
 p2:Create("UIGradient")({
 Rotation = -90,
 Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) })
 }),
 p2:Create("UIStroke")({
 Color = Color3.new(1, 1, 1),
 Transparency = 0.7,
 p2:Create("UIGradient")({
 Rotation = -90,
 Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) })
 })
 })
 })
 });
end;
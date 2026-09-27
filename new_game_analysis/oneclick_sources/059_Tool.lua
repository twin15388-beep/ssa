-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local u1 = {
 One = "Toolbar_1st",
 Two = "Toolbar_2nd",
 Three = "Toolbar_3rd",
 Four = "Toolbar_4th",
 Five = "Toolbar_5th"
};
local ToolbarItemRestrictions = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.ToolbarItemRestrictions);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local faye = require(ReplicatedStorage.Packages.faye);
require(ReplicatedStorage.CAM.Client.Components.Misc.Utilities.SlotDragger);
local u2 = { "One", "Two", "Three", "Four", "Five" };
local Data = Utility.GetData(LocalPlayer, true);
local u3 = faye.Info(0.2);

return function(p4: any, u5: number, u6: table, u7: userdata, p8: any, u9: any) -- Line: 38
 -- upvalues: ToolbarItemRestrictions (copy), u2 (copy), Data (copy), u3 (copy), gameSettings (copy), Utility (copy), u1 (copy)
 local u10 = p4:Value("");
 local v11 = p4:Value(Color3.new());
 local v12 = p4:Value(0.8);
 local v13 = p4:Value(UDim2.fromScale(1, 1));
 local v14 = p4:Value(1);
 local v15 = p4:Value(0);
 local v16 = p4:Value(0.4);
 local u17 = p4:Value(1);
 local v18 = p4:Value(ToolbarItemRestrictions.Inventory.Locked.Icon);
 local v19 = p8:Add({
 {
 Index = u5,
 Key = u2[u5]
 },
 u6,
 v11,
 v12,
 v13,
 v14,
 u10,
 v15,
 v16,
 u17,
 v18
 }):Call();
 v19:Connect(u6.Id.Changed);
 v19:Connect(u6.Restrictions.Changed);

 return p4:Create("TextButton")({
 Name = u5 .. "_ToolPosition",
 Size = UDim2.fromScale(1, 1),
 BackgroundTransparency = 1,

 MouseEnter = function() -- Line: 67, Name: MouseEnter
 -- upvalues: u9 (copy), u2 (ref), u5 (copy)
 u9:SetHover(u2[u5]);
 end,

 MouseLeave = function() -- Line: 70, Name: MouseLeave
 -- upvalues: u9 (copy), u2 (ref), u5 (copy)
 u9:ClearHover(u2[u5]);
 end,

 MouseButton1Down = function(p20) -- Line: 74, Name: MouseButton1Down
 -- upvalues: u9 (copy), u2 (ref), u5 (copy)
 u9:Begin(p20, u2[u5]);
 end,

 function(p21) -- Line: 79
 -- upvalues: u9 (copy), u2 (ref), u5 (copy), u6 (copy), Data (ref), u10 (copy)
 u9:Attach(u2[u5], p21, function() -- Line: 80
 -- upvalues: u6 (ref), Data (ref), u2 (ref), u5 (ref), u10 (ref)
 local v22 = u6.Restrictions:Get();

 if Data.Inventory.Toolbar[u2[u5]].Value == 0 or v22.ActionsDisabled then
 return nil;
 end;

 return u10:Get();
 end);
 end,

 MouseButton1Up = function() -- Line: 91, Name: MouseButton1Up
 -- upvalues: u6 (copy), u9 (copy), u7 (copy), u5 (copy)
 local v23 = u6.Restrictions:Get();

 if u9.Dragging:Compare(nil) and not (v23.Locked or v23.ActionsDisabled) then
 if u7.Value == u5 then
 u7.Value = 0;

 return;
 end;

 u7.Value = u5;
 end;
 end,

 p4:Create("ImageLabel")({
 Name = "Bg",
 ZIndex = -1,
 Image = "http://www.roblox.com/asset/?id=134657809787110",
 BackgroundTransparency = 1,
 AnchorPoint = Vector2.new(0.5, 0.5),
 Position = UDim2.fromScale(0.5, 0.5),
 Size = UDim2.fromScale(2.15, 2.15),
 ImageColor3 = Color3.new(0.15, 0.15, 0.15),
 ImageTransparency = p4:Animation(v16, u3)
 }),
 p4:Create("ImageLabel")({
 Name = "CircleSelect",
 Size = UDim2.fromScale(0.8, 0.8),
 AnchorPoint = Vector2.new(0.5, 0.5),
 Position = UDim2.fromScale(0.5, 0.5),
 BackgroundTransparency = 1,
 ImageTransparency = p4:Animation(v12, u3),
 ImageColor3 = p4:Animation(v11, u3),
 Image = "http://www.roblox.com/asset/?id=119489413451678",
 p4:Create("Frame")({
 AnchorPoint = Vector2.new(0.5, 0.5),
 Size = p4:Animation(v13, u3),
 Position = UDim2.fromScale(0.5, 0.5),
 p4:Create("UICorner")({
 CornerRadius = UDim.new(1, 0)
 }),
 BackgroundTransparency = 1,
 p4:Create("UIStroke")({
 Thickness = 2,
 Transparency = p4:Animation(v14, u3),
 Color = Color3.new(1, 1, 1)
 })
 })
 }),
 p4:Create("ImageLabel")({
 Size = UDim2.fromScale(0.5, 0.5),
 ZIndex = 10,
 AnchorPoint = Vector2.new(0.5, 0.5),
 Position = UDim2.fromScale(0.5, 0.5),
 BackgroundTransparency = 1,
 Image = v18,
 ImageTransparency = u17,
 p4:Create("UIShadow")({
 Color = gameSettings.noSaveOverlayShadowColor,
 Transparency = p4:Do(function(p24) -- Line: 158
 -- upvalues: u17 (copy), gameSettings (ref)
 local v25 = p24(u17);

 return 1 - (1 - gameSettings.noSaveOverlayShadowTransparency) * (1 - v25);
 end),
 BlurRadius = gameSettings.noSaveOverlayShadowBlur
 })
 }),
 p4:Create("ImageLabel")({
 ZIndex = 2,
 Name = "Image",
 BackgroundTransparency = 1,
 AnchorPoint = Vector2.new(0.5, 0.5),
 Position = UDim2.fromScale(0.5, 0.5),
 Size = UDim2.fromScale(1, 1),
 Image = u10,
 ImageTransparency = v15
 }),
 Utility.AddTag(p4:Create("Frame")({
 ZIndex = -1,
 Name = u1[u6.Key] or u6.Key,
 BackgroundTransparency = gameSettings.KeybindTextTransparency,
 AnchorPoint = Vector2.new(0.5, 1),
 Size = gameSettings.KeybindTextSize,
 Position = UDim2.new(0.5, 0, 1, gameSettings.KeybindTextOffset)
 }), "UIkey")
 });
end;
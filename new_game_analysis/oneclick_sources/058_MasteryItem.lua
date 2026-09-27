-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local faye = require(ReplicatedStorage.Packages.faye);
local u1 = faye.Info(0.2, Enum.EasingStyle.Back);
local u2 = faye.Info(0.2);

function GetList(p3: any, p4: any, p5)
 return p3:Create("UIListLayout")({
 Name = "List",
 FillDirection = Enum.FillDirection.Horizontal,
 HorizontalAlignment = p4 or Enum.HorizontalAlignment.Left,
 VerticalAlignment = Enum.VerticalAlignment.Center,
 Padding = p5 or UDim.new(0, 10)
 });
end;

local Data = Utility.GetData(Players.LocalPlayer, true);

return function(u6: any, u7: table) -- Line: 19
 -- upvalues: gameSettings (copy), Data (copy), u2 (copy), u1 (copy)
 local u8 = u6:Value(UDim2.fromScale(0.5, 1));
 local u9 = u6:Value("5 / 10");
 local u10 = u6:Value("Lv 1");
 local u11 = u7.Mastery ~= nil and u7.Mastery.IncrementAmount or gameSettings.expPerMasteryDefault;

 local function updateMasteryThing(p12, p13) -- Line: 24
 -- upvalues: u11 (copy), u8 (copy), u9 (copy), u10 (copy)
 local v14 = p12 or 0;
 local v15 = p13 or u11;
 u8:Set(UDim2.fromScale(v14 / v15, 1));
 u9:Set((`{v14} / {v15}`));
 u10:Set((`Lv {math.floor(v15 / u11)}`));
 end;

 updateMasteryThing();

 local function HandleValue(u16: table) -- Line: 32
 -- upvalues: updateMasteryThing (copy), u6 (copy)
 updateMasteryThing(u16.Current.Value, u16.Goal.Value);
 u6:Connect(u16.Current.Changed, function() -- Line: 34
 -- upvalues: updateMasteryThing (ref), u16 (copy)
 updateMasteryThing(u16.Current.Value, u16.Goal.Value);
 end);
 end;

 if Data.MasteryProgressionList:FindFirstChild(u7.Name) == nil then
 local u17 = nil;
 u17 = u6:Add(Data.MasteryProgressionList.ChildAdded:Connect(function(u18) -- Line: 39
 -- upvalues: u7 (copy), u17 (ref), u6 (copy), updateMasteryThing (copy)
 if u18.Name == u7.Name then
 if u17 ~= nil then
 u6:Remove(u17);
 u17:Disconnect();
 u17 = nil;
 end;

 updateMasteryThing(u18.Current.Value, u18.Goal.Value);
 u6:Connect(u18.Current.Changed, function() -- Line: 34
 -- upvalues: updateMasteryThing (ref), u18 (copy)
 updateMasteryThing(u18.Current.Value, u18.Goal.Value);
 end);
 end;
 end));
 else
 local u19 = Data.MasteryProgressionList[u7.Name];
 updateMasteryThing(u19.Current.Value, u19.Goal.Value);
 u6:Connect(u19.Current.Changed, function() -- Line: 34
 -- upvalues: updateMasteryThing (copy), u19 (copy)
 updateMasteryThing(u19.Current.Value, u19.Goal.Value);
 end);
 end;

 return u6:Create("CanvasGroup")({
 Size = UDim2.fromScale(1, 1),
 BackgroundTransparency = 1,
 GroupTransparency = u6:Animation(0, u2, {
 From = 1
 }),
 Name = u7.Name,
 u6:Create("Frame")({
 AnchorPoint = Vector2.new(0.5, 0.5),
 Position = UDim2.fromScale(0.5, 0.5),
 Size = u6:Animation(UDim2.fromScale(1, 1), u1, {
 From = UDim2.fromScale(0.7, 0.7)
 }),
 Name = "Bg",
 u6:Create("UICorner")({
 CornerRadius = UDim.new(0.5)
 }),
 BackgroundColor3 = Color3.new(0.15, 0.15, 0.15),
 BackgroundTransparency = 0.25,
 u6:Create("UIStroke")({
 Thickness = 1,
 Transparency = 0.65,
 Color = Color3.new(1, 1, 1),
 BorderOffset = UDim.new(-0.1)
 })
 }),
 u6:Create("Frame")({
 Name = "Content",
 BackgroundTransparency = 1,
 Size = UDim2.fromScale(1, 0.75),
 AnchorPoint = Vector2.new(0.5, 0.5),
 Position = UDim2.fromScale(0.5, 0.5),
 GetList(u6, Enum.HorizontalAlignment.Center, UDim.new(0, 5)),

 function() -- Line: 83
 -- upvalues: u7 (copy), u6 (copy)
 if u7.Icon ~= nil then
 return u6:Create("ImageLabel")({
 Name = "Icon",
 Size = UDim2.fromScale(1, 1),
 BackgroundTransparency = 1,
 Image = "rbxassetid://79024618338298",
 ImageColor3 = Color3.new(0.35, 0.35, 0.35),
 Instance.new("UIAspectRatioConstraint"),
 u6:Create("ImageLabel")({
 BackgroundTransparency = 1,
 Name = "Fg",
 ZIndex = 2,
 Size = UDim2.fromScale(1, 1),
 Image = u7.Icon
 })
 });
 end;
 end,

 u6:Create("Frame")({
 Name = "NameAndBarHolder",
 Size = UDim2.fromScale(1, 1),
 BackgroundTransparency = 1,
 u6:Create("Frame")({
 Name = "NameHolder",
 Size = UDim2.fromScale(1, 0.55),
 BackgroundTransparency = 1,
 GetList(u6, Enum.HorizontalAlignment.Center),
 u6:Create("TextLabel")({
 Name = "Txt",
 BackgroundTransparency = 1,
 TextScaled = true,
 TextStrokeTransparency = 0.5,
 Size = UDim2.fromScale(100, 1),
 Text = u7.Name .. " Mastery",
 TextXAlignment = Enum.TextXAlignment.Center,
 TextColor3 = Color3.new(1, 1, 1),
 Font = Enum.Font.SourceSansBold,

 After = function(p20: userdata) -- Line: 122, Name: After
 p20.Size = UDim2.new(0, p20.TextBounds.X, 1);
 end
 })
 }),
 u6:Create("Frame")({
 Name = "BottomHolder",
 Size = UDim2.fromScale(1, 0.5),
 Position = UDim2.fromScale(0.5, 0.5),
 AnchorPoint = Vector2.new(0.5, 0),
 BackgroundTransparency = 1,
 GetList(u6, Enum.HorizontalAlignment.Center, UDim.new(0, 5)),
 u6:Create("TextLabel")({
 Name = "CurrentValue",
 BackgroundTransparency = 1,
 TextStrokeTransparency = 0.5,
 TextScaled = true,
 Size = UDim2.fromScale(100, 1.2),
 Font = Enum.Font.SourceSansBold,
 TextColor3 = gameSettings.masteryColor,
 Text = u10
 }),
 u6:Create("Frame")({
 Name = "BarHolder",
 Size = UDim2.fromScale(1, 0.5),
 u6:Create("UIAspectRatioConstraint")({
 AspectRatio = 8.2,
 DominantAxis = Enum.DominantAxis.Height,
 AspectType = Enum.AspectType.ScaleWithParentSize
 }),
 BackgroundColor3 = Color3.new(0.3, 0.3, 0.3),
 u6:Create("UICorner")({
 CornerRadius = UDim.new(1)
 }),
 u6:Create("UIStroke")({
 Transparency = 0.75,
 Color = Color3.new(1, 1, 1),
 BorderOffset = UDim.new(0, -1)
 }),
 u6:Create("Frame")({
 Name = "Inner",
 Size = UDim2.new(1, -5, 1, -5),
 Position = UDim2.fromScale(0.5, 0.5),
 AnchorPoint = Vector2.new(0.5, 0.5),
 BackgroundTransparency = 1,
 u6:Create("Frame")({
 Name = "Bar",
 Size = u8,
 Position = UDim2.fromScale(0, 0.5),
 AnchorPoint = Vector2.new(0, 0.5),
 BackgroundColor3 = gameSettings.masteryColor,
 u6:Create("UICorner")({
 CornerRadius = UDim.new(1)
 })
 })
 })
 }),
 u6:Create("TextLabel")({
 Name = "Progress",
 BackgroundTransparency = 1,
 TextStrokeTransparency = 0.5,
 TextTransparency = 0.25,
 TextScaled = true,
 Size = UDim2.fromScale(100, 1),
 Font = Enum.Font.SourceSansBold,
 TextColor3 = gameSettings.masteryColor,
 Text = u9
 })
 }),

 After = function(p21: userdata) -- Line: 201, Name: After
 if p21 == nil then
 return;
 end;

 p21.NameHolder.Txt.Size = UDim2.new(0, p21.NameHolder.Txt.TextBounds.X, 1);
 p21.BottomHolder.CurrentValue.Size = UDim2.new(0, p21.BottomHolder.CurrentValue.TextBounds.X, p21.BottomHolder.CurrentValue.Size.Y.Scale);
 p21.BottomHolder.Progress.Size = UDim2.new(0, p21.BottomHolder.Progress.TextBounds.X, p21.BottomHolder.Progress.Size.Y.Scale);
 p21.Size = UDim2.new(0, math.max(p21.NameHolder.List.AbsoluteContentSize.X, p21.BottomHolder.List.AbsoluteContentSize.X), 1);
 end
 }),

 After = function(p22: userdata) -- Line: 211, Name: After
 if p22 == nil or p22.Parent == nil then
 return;
 end;

 local math_max_ret = math.max(p22.NameAndBarHolder.NameHolder.List.AbsoluteContentSize.X, p22.NameAndBarHolder.BottomHolder.List.AbsoluteContentSize.X);
 p22.Parent.Size = UDim2.new(p22.List.AbsoluteContentSize.X / p22.Parent.Parent.AbsoluteSize.X, 15, 1);
 p22.NameAndBarHolder.Size = UDim2.fromScale(math_max_ret / p22.NameAndBarHolder.Parent.AbsoluteSize.X, 1);
 p22.NameAndBarHolder.NameHolder.Txt.Size = UDim2.fromScale(p22.NameAndBarHolder.NameHolder.Txt.TextBounds.X / p22.NameAndBarHolder.NameHolder.AbsoluteSize.X, 1);
 end
 })
 });
end;
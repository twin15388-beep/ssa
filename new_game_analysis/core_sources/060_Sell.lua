-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local ScreenEffects = require(ReplicatedStorage.CAM.Client.Components.Misc.ScreenEffects);
local Adders = require(ReplicatedStorage.CAM.Client.Components.Misc.Buttons.Adders);
local GradientButton = require(ReplicatedStorage.CAM.Client.Components.Misc.Buttons.GradientButton);
local Platform_Handler = require(ReplicatedStorage.CAM.Client.Controllers.Platform_Handler);
local ItemModels = require(ReplicatedStorage.CAM.Global.Collectibles.ItemModels);
local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);
local Rarities = require(ReplicatedStorage.CAM.Global.Rarities);
local Shop = require(ReplicatedStorage.CAM.Global.Shop);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local faye = require(ReplicatedStorage.Packages.faye);
local TweenInfo_new_ret = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u1 = faye.Info(0.15, Enum.EasingStyle.Sine);
local u2 = faye.Info(0.2);
local u3 = faye.Info(0.45);
local u4 = Platform_Handler.Platform.Value == "Mobile";
local Color3_fromRGB_ret = Color3.fromRGB(155, 208, 255);
local UDim2_fromScale_ret = UDim2.fromScale(0.45, 0.7);

local function GatherSellables() -- Line: 61
    -- upvalues: Utility (copy), Players (copy), Items (copy), Shop (copy)
    local v5 = {};
    local Data = Utility.GetData(Players.LocalPlayer);

    if Data == nil then
        return v5;
    end;

    local v6 = {};
    local v7 = {};

    for _, child in ipairs(Data.Inventory.Inventory:GetChildren()) do
        local Name = child.Name;

        if child:FindFirstChild("NoSave") == nil and child:FindFirstChild("QuestGrant") == nil then
            local v8 = Items[Name];

            if v8 ~= nil and (v8.NoDelete ~= true and (v8.NoSell ~= true and (v8.Requirements == nil and (v8.NoSaveRequirements == nil and (v8.Price ~= nil or Shop.itemsforsale[Name] ~= nil))))) then
                local Amount = child:FindFirstChild("Amount");
                v7[Name] = (v7[Name] or 0) + (Amount == nil and 1 or (Amount.Value or 1));
            end;
        else
            v6[Name] = true;
        end;
    end;

    for i, v in pairs(v7) do
        if not v6[i] then
            table.insert(v5, {
                Name = i,
                Owned = v
            });
        end;
    end;

    table.sort(v5, function(p9, p10) -- Line: 87
        return p9.Name < p10.Name;
    end);

    return v5;
end;

return function() -- Line: 93
    -- upvalues: GatherSellables (copy), u3 (copy), u4 (copy), Items (copy), Rarities (copy), Shop (copy), RunService (copy), TweenInfo_new_ret (copy), u1 (copy), ItemModels (copy), Utility (copy), u2 (copy), Adders (copy), GradientButton (copy), Color3_fromRGB_ret (copy), UDim2_fromScale_ret (copy), ScreenEffects (copy)
    return function(p11: any, p12: userdata, p13: userdata, p14: any) -- Line: 94
        -- upvalues: GatherSellables (ref), u3 (ref), u4 (ref), Items (ref), Rarities (ref), Shop (ref), RunService (ref), TweenInfo_new_ret (ref), u1 (ref), ItemModels (ref), Utility (ref), u2 (ref), Adders (ref), GradientButton (ref), Color3_fromRGB_ret (ref), UDim2_fromScale_ret (ref), ScreenEffects (ref)
        local u15 = typeof(p14.SellSelection) == "table" and (p14.SellSelection or {}) or {};
        p14.SellSelection = u15;
        local v16 = GatherSellables();
        local v17 = {};

        for _, v in ipairs(v16) do
            v17[v.Name] = v.Owned;
        end;

        for i, v in pairs(u15) do
            local v18;

            if v17[i] == nil then
                v18 = nil;
            else
                local math_min_ret = math.min(v17[i], 999);
                v18 = math.clamp(v, 1, math_min_ret);
            end;

            u15[i] = v18;
        end;

        local u19 = p11:Value("");
        local u20 = p11:Value(Color3.new(1, 1, 1));
        local v21 = p11:Value(v16);
        local u22 = p11:Value(UDim2.fromScale(1, 1));

        return p11:Create("CanvasGroup")({
            Parent = p12,
            Size = UDim2.fromScale(0.7, 0.5),
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 0.96),
            p11:Create("UIAspectRatioConstraint")({
                AspectRatio = 1.4
            }),
            BackgroundTransparency = 1,
            GroupTransparency = p11:Animation(0, u3, {
                From = 1
            }),

            OnClean = function(p23) -- Line: 131, Name: OnClean
                -- upvalues: u3 (ref)
                return {
                    GroupTransparency = p23:Animation(1, u3)
                };
            end,

            p11:Create("Frame")({
                Name = "TilesHolder",
                Size = UDim2.fromScale(1, 0.94),
                BackgroundTransparency = 1,
                p11:Create("Frame")({
                    Name = "Bg",
                    AnchorPoint = Vector2.new(0.5, 1),
                    Position = UDim2.fromScale(0.5, 1),
                    Size = UDim2.fromScale(1, 0.5),
                    BackgroundColor3 = Color3.new(0, 0, 0),
                    BackgroundTransparency = 0.35,
                    p11:Create("UICorner")({
                        CornerRadius = UDim.new(0, 5)
                    }),
                    p11:Create("UIGradient")({
                        Rotation = -90,
                        Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) })
                    })
                }),
                p11:Create("ScrollingFrame")({
                    Name = "Actual",
                    Size = UDim2.fromScale(1, 1),
                    BackgroundTransparency = 1,
                    CanvasSize = u22,
                    ScrollingDirection = Enum.ScrollingDirection.Y,
                    ElasticBehavior = Enum.ElasticBehavior.WhenScrollable,
                    ScrollBarThickness = 0,
                    p11:Create("UIGridLayout")({
                        StartCorner = Enum.StartCorner.BottomLeft,
                        FillDirection = Enum.FillDirection.Horizontal,
                        VerticalAlignment = Enum.VerticalAlignment.Bottom,
                        HorizontalAlignment = Enum.HorizontalAlignment.Left,
                        CellSize = UDim2.fromScale((u4 and 1.5 or 1) * 0.159, 1),
                        CellPadding = UDim2.new((u4 and 1.5 or 1) * 0.008, 0, 0, 5),
                        p11:Create("UIAspectRatioConstraint")({}),

                        AbsoluteContentSizeOnChangedInit = function(p24: userdata) -- Line: 200, Name: AbsoluteContentSizeOnChangedInit
                            -- upvalues: u22 (copy)
                            local Parent = p24.Parent;
                            local Y = Parent.AbsoluteWindowSize.Y;
                            local math_max_ret = math.max(p24.AbsoluteContentSize.Y - Y, 0);
                            u22:Set(UDim2.new(1, 0, 1, math_max_ret));

                            local function toBottom() -- Line: 215
                                -- upvalues: Parent (copy)
                                if Parent.Parent == nil then
                                    return;
                                end;

                                Parent.CanvasPosition = Vector2.new(0, (math.max(Parent.AbsoluteCanvasSize.Y - Parent.AbsoluteWindowSize.Y, 0)));
                            end;

                            if Parent.AbsoluteCanvasSize.Y >= Y + math_max_ret - 1 then
                                task.defer(toBottom);

                                return;
                            end;

                            Parent:GetPropertyChangedSignal("AbsoluteCanvasSize"):Once(toBottom);
                        end
                    }),
                    p11:Iterate(v21, function(p25: any, p26: table, p27: any, p28: userdata?) -- Line: 227
                        -- upvalues: Items (ref), Rarities (ref), u15 (copy), Shop (ref), RunService (ref), TweenInfo_new_ret (ref), u3 (ref), u1 (ref), ItemModels (ref), Utility (ref), u2 (ref), Adders (ref), GradientButton (ref), Color3_fromRGB_ret (ref), UDim2_fromScale_ret (ref), ScreenEffects (ref), u19 (copy), u20 (copy)
                        local Name = p26.Name;
                        local Owned = p26.Owned;
                        local u29 = Items[Name];

                        if u29 == nil then
                            return nil;
                        end;

                        local u30 = Rarities.Colors[u29.Rarity] or Color3.new(1, 1, 1);
                        local u31 = p27:Value(0.25);
                        local u32 = p27:Value(0.75);
                        local u33 = p27:Value(0.4);
                        local u34 = p27:Value(0.2);
                        local u35 = p27:Value(0.25);
                        local u36 = p27:Value(1);
                        local u37 = p27:Value({ {
                                Text = "..."
                            } });
                        local v38 = u15[Name];
                        local u39 = p27:Value(v38 ~= nil);
                        local u40 = p27:Value(v38 or 1);

                        local function ApplyEmphasis(p41: string) -- Line: 250
                            -- upvalues: u31 (copy), u32 (copy), u33 (copy), u34 (copy), u35 (copy), u36 (copy)
                            if p41 == "Selected" then
                                u31:Set(0.05);
                                u32:Set(0.5);
                                u33:Set(0.05);
                                u34:Set(0);
                                u35:Set(0);
                                u36:Set(0.2);

                                return;
                            end;

                            if p41 == "Hover" then
                                u31:Set(0.15);
                                u32:Set(0.65);
                                u33:Set(0.2);
                                u34:Set(0.1);
                                u35:Set(0.1);
                                u36:Set(1);

                                return;
                            end;

                            u31:Reset();
                            u32:Reset();
                            u33:Reset();
                            u34:Reset();
                            u35:Reset();
                            u36:Reset();
                        end;

                        if v38 ~= nil then
                            u31:Set(0.05);
                            u32:Set(0.5);
                            u33:Set(0.05);
                            u34:Set(0);
                            u35:Set(0);
                            u36:Set(0.2);
                        end;

                        local u42 = false;
                        task.spawn(function() -- Line: 279
                            -- upvalues: Shop (ref), Name (copy), u42 (ref), u37 (copy)
                            local SellContent = Shop.GetSellContent(Name);

                            if SellContent == nil or #SellContent <= 0 then
                                u37:Set({ {
                                        Text = "?"
                                    } });

                                return;
                            end;

                            u42 = true;
                            u37:Set(SellContent);
                        end);

                        local function SetCount(p43: number?) -- Line: 295
                            -- upvalues: u15 (ref), Name (copy), u39 (copy), u31 (copy), u32 (copy), u33 (copy), u34 (copy), u35 (copy), u36 (copy), Owned (copy), u40 (copy)
                            if p43 == nil then
                                u15[Name] = nil;
                                u39:Set(false);
                                u31:Set(0.15);
                                u32:Set(0.65);
                                u33:Set(0.2);
                                u34:Set(0.1);
                                u35:Set(0.1);
                                u36:Set(1);

                                return;
                            end;

                            local math_min_ret = math.min(Owned, 999);
                            local math_clamp_ret = math.clamp(p43, 1, math_min_ret);
                            u15[Name] = math_clamp_ret;
                            u39:Set(true);
                            u40:Set(math_clamp_ret);
                            u31:Set(0.05);
                            u32:Set(0.5);
                            u33:Set(0.05);
                            u34:Set(0);
                            u35:Set(0);
                            u36:Set(0.2);
                        end;

                        local u44 = nil;
                        local CFrame_new_ret = CFrame.new();
                        local u45 = Vector3.new(0, 0, 0);
                        local u46 = 0;
                        local u47 = nil;
                        local u48 = nil;
                        local NumberValue = Instance.new("NumberValue");

                        local function ApplyAngle(p49: number) -- Line: 318
                            -- upvalues: u44 (ref), u45 (ref), CFrame_new_ret (ref)
                            if u44 == nil then
                                return;
                            end;

                            u44:PivotTo(CFrame.new(u45) * CFrame.Angles(0, math.rad(p49), 0) * CFrame_new_ret);
                        end;

                        local function StartSpin() -- Line: 323
                            -- upvalues: u47 (ref), u44 (ref), u48 (ref), RunService (ref), u46 (ref), u45 (ref), CFrame_new_ret (ref)
                            if u47 ~= nil or u44 == nil then
                                return;
                            end;

                            if u48 ~= nil then
                                u48:Cancel();
                                u48 = nil;
                            end;

                            u47 = RunService.RenderStepped:Connect(function(p50) -- Line: 331
                                -- upvalues: u46 (ref), u44 (ref), u45 (ref), CFrame_new_ret (ref)
                                u46 = u46 + 120 * p50;

                                if u44 == nil then
                                    return;
                                end;

                                u44:PivotTo(CFrame.new(u45) * CFrame.Angles(0, math.rad(u46), 0) * CFrame_new_ret);
                            end);
                        end;

                        local function StopSpin() -- Line: 336
                            -- upvalues: u44 (ref), u47 (ref), u46 (ref), NumberValue (copy), u48 (ref), TweenInfo_new_ret (ref)
                            if u44 == nil then
                                return;
                            end;

                            if u47 ~= nil then
                                u47:Disconnect();
                                u47 = nil;
                            end;

                            u46 = u46 % 360;
                            NumberValue.Value = u46;
                            u48 = game:GetService("TweenService"):Create(NumberValue, TweenInfo_new_ret, {
                                Value = u46 > 180 and 360 or 0
                            });
                            u48:Play();
                        end;

                        NumberValue:GetPropertyChangedSignal("Value"):Connect(function() -- Line: 348
                            -- upvalues: u46 (ref), NumberValue (copy), u44 (ref), u45 (ref), CFrame_new_ret (ref)
                            u46 = NumberValue.Value;

                            if u44 == nil then
                                return;
                            end;

                            u44:PivotTo(CFrame.new(u45) * CFrame.Angles(0, math.rad(u46), 0) * CFrame_new_ret);
                        end);

                        return p27:Create("Frame")({
                            CleanDelay = u3.Time,
                            BackgroundTransparency = 1,
                            p27:Create("Frame")({
                                Name = "Bg",
                                Size = UDim2.fromScale(1, 1),
                                BackgroundColor3 = Color3.new(0, 0, 0),
                                BackgroundTransparency = p27:Animation(u31, u1),
                                p27:Create("UICorner")({
                                    CornerRadius = UDim.new(0.1)
                                }),
                                p27:Create("UIGradient")({
                                    Rotation = 90,
                                    Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0.5) })
                                }),
                                p27:Create("Frame")({
                                    AnchorPoint = Vector2.new(0.5, 0.5),
                                    Position = UDim2.fromScale(0.5, 0.5),
                                    Size = UDim2.new(1, -6, 1, -6),
                                    BackgroundColor3 = u30,
                                    BackgroundTransparency = p27:Animation(u32, u1),
                                    p27:Create("UICorner")({
                                        CornerRadius = UDim.new(0.1)
                                    }),
                                    p27:Create("UIStroke")({
                                        Thickness = 1.5,
                                        Color = u30,
                                        Transparency = p27:Animation(u33, u1)
                                    }),
                                    p27:Create("Frame")({
                                        Name = "SelectedRing",
                                        AnchorPoint = Vector2.new(0.5, 0.5),
                                        Position = UDim2.fromScale(0.5, 0.5),
                                        Size = UDim2.new(1, -8, 1, -8),
                                        BackgroundTransparency = 1,
                                        p27:Create("UICorner")({
                                            CornerRadius = UDim.new(0.1)
                                        }),
                                        p27:Create("UIStroke")({
                                            Thickness = 1.5,
                                            Color = Color3.new(1, 1, 1),
                                            Transparency = p27:Animation(u36, u1)
                                        })
                                    }),
                                    p27:Create("ImageLabel")({
                                        Name = "BgImage",
                                        BackgroundTransparency = 1,
                                        ImageTransparency = 0.65,
                                        AnchorPoint = Vector2.new(0.5, 0.5),
                                        Position = UDim2.fromScale(0.5, 0.5),
                                        Size = UDim2.fromScale(0.95, 0.95),
                                        Image = u29.Icon
                                    })
                                })
                            }),
                            p27:Create("ViewportFrame")({
                                AnchorPoint = Vector2.new(0.5, 0.5),
                                Position = UDim2.fromScale(0.5, 0.5),
                                Size = UDim2.fromScale(0.8, 0.8),
                                BackgroundTransparency = 1,
                                BorderSizePixel = 0,
                                BorderColor3 = Color3.new(),
                                BackgroundColor3 = Color3.new(),
                                ImageTransparency = p27:Animation(u34, u1),

                                function(p51: userdata) -- Line: 423
                                    -- upvalues: ItemModels (ref), Name (copy), u29 (copy), u45 (ref), CFrame_new_ret (ref), u44 (ref), u47 (ref), u48 (ref)
                                    local v52 = ItemModels.Get(Name);

                                    if v52 == nil then
                                        warn((`Sell: no ItemAssets model for "{Name}"`));

                                        return;
                                    end;

                                    local v53 = v52:Clone();

                                    if v53:IsA("BasePart") then
                                        v53.Anchored = true;
                                    end;

                                    for _, v in v53:QueryDescendants("BasePart") do
                                        v.Anchored = true;
                                    end;

                                    v53.Parent = p51;
                                    local v54 = u29.ViewmodelSettings or {};
                                    local CFrame_new_ret2 = CFrame.new();

                                    if typeof(v54.CFrameOffset) == "CFrame" then
                                        CFrame_new_ret2 = v54.CFrameOffset.Rotation;
                                        u45 = v54.CFrameOffset.Position;
                                    end;

                                    v53:PivotTo(CFrame_new_ret2);
                                    local v55, v56;

                                    if v53:IsA("Model") then
                                        v55, v56 = v53:GetBoundingBox();
                                    else
                                        v55 = v53.CFrame;
                                        v56 = v53.Size;
                                    end;

                                    CFrame_new_ret = CFrame.new(-v55.Position) * CFrame_new_ret2;
                                    u44 = v53;

                                    if u44 ~= nil then
                                        u44:PivotTo(CFrame.new(u45) * CFrame.Angles(0, 0, 0) * CFrame_new_ret);
                                    end;

                                    local Camera = Instance.new("Camera");
                                    Camera.Parent = p51;
                                    p51.CurrentCamera = Camera;
                                    local v57 = v56.Magnitude / 2;
                                    local math_rad_ret = math.rad(Camera.FieldOfView / 2);
                                    local v58 = v57 / math.tan(math_rad_ret) + v57 - 1 + (tonumber(v54.CameraOffset) or 0);
                                    Camera.CFrame = CFrame.new(Vector3.new(0, 0, v58), Vector3.new(0, 0, 0));
                                    p51.Destroying:Connect(function() -- Line: 460
                                        -- upvalues: u47 (ref), u48 (ref), u44 (ref)
                                        if u47 ~= nil then
                                            u47:Disconnect();
                                            u47 = nil;
                                        end;

                                        if u48 ~= nil then
                                            u48:Cancel();
                                            u48 = nil;
                                        end;

                                        u44 = nil;
                                    end);
                                end
                            }),
                            p27:Create("TextLabel")({
                                ZIndex = 4,
                                AnchorPoint = Vector2.new(1, 0),
                                Position = UDim2.new(1, -4, 0, 2),
                                Size = UDim2.fromScale(0.4, 0.18),
                                BackgroundTransparency = 1,
                                Text = `x{Owned}`,
                                TextScaled = true,
                                TextXAlignment = Enum.TextXAlignment.Right,
                                Font = Enum.Font.SourceSansBold,
                                TextColor3 = Color3.new(1, 1, 1),
                                TextTransparency = 0.2,
                                p27:Create("UIStroke")({
                                    Thickness = 1,
                                    Transparency = 0.6
                                })
                            }),
                            p27:Create("CanvasGroup")({
                                Name = "PriceHolder",
                                ZIndex = 4,
                                AnchorPoint = Vector2.new(0.5, 1),
                                Position = UDim2.new(0.5, 0, 1, -8),
                                Size = UDim2.fromScale(0.9, 1),
                                BackgroundTransparency = 1,
                                GroupTransparency = p27:Animation(u35, u1),
                                p27:Create("UIListLayout")({
                                    Wraps = true,
                                    FillDirection = Enum.FillDirection.Horizontal,
                                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                                    VerticalAlignment = Enum.VerticalAlignment.Bottom,
                                    Padding = UDim.new(0, 2)
                                }),
                                p27:Iterate(u37, function(p59, p60, p61) -- Line: 511
                                    -- upvalues: u3 (ref), Utility (ref)
                                    local v62 = p60.Icon ~= nil;

                                    return p61:Create("Frame")({
                                        CleanDelay = u3.Time,
                                        ZIndex = 4,
                                        Size = UDim2.new(0.65, 0, 0.25, 0),
                                        BackgroundTransparency = 1,
                                        p61:Create("UIListLayout")({
                                            FillDirection = Enum.FillDirection.Horizontal,
                                            HorizontalAlignment = Enum.HorizontalAlignment.Center,
                                            VerticalAlignment = Enum.VerticalAlignment.Center,
                                            Padding = UDim.new(0, 2)
                                        }),
                                        p61:Create("ImageLabel")({
                                            ZIndex = 4,
                                            LayoutOrder = 1,
                                            Visible = v62,
                                            Size = UDim2.fromScale(1, 1),
                                            Instance.new("UIAspectRatioConstraint"),
                                            BackgroundTransparency = 1,
                                            Image = p60.Icon or "",
                                            ImageColor3 = p60.Color or Color3.new(1, 1, 1)
                                        }),
                                        p61:Create("TextLabel")({
                                            ZIndex = 4,
                                            LayoutOrder = 2,
                                            Size = UDim2.fromScale(0.7, 1),
                                            BackgroundTransparency = 1,
                                            Text = p60.Text or Utility.addCommasToNumber(p60.Price),
                                            TextScaled = true,
                                            Font = Enum.Font.SourceSansBold,
                                            TextXAlignment = v62 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
                                            TextColor3 = p60.Color or Color3.new(1, 1, 1),
                                            p61:Create("UIStroke")({
                                                Thickness = 1,
                                                Transparency = 0.6
                                            }),
                                            p61:Create("UIShadow")({
                                                Transparency = 0.5,
                                                BlurRadius = UDim.new(0.5),
                                                Spread = UDim2.fromScale(0.2, 0.15),
                                                Offset = UDim2.fromScale(-0.2, 0)
                                            })
                                        })
                                    });
                                end)
                            }),
                            p27:State(function(p63, p64) -- Line: 577
                                -- upvalues: u39 (copy), Owned (copy), u15 (ref), Name (copy), SetCount (copy), u40 (copy), u2 (ref), Adders (ref), GradientButton (ref), Color3_fromRGB_ret (ref), UDim2_fromScale_ret (ref)
                                if p63(u39) and Owned > 1 then
                                    local u65 = 1;

                                    local function add(p66) -- Line: 580
                                        -- upvalues: u65 (ref), u15 (ref), Name (ref), SetCount (ref), u40 (ref), Owned (ref)
                                        u65 = p66;

                                        if u15[Name] == nil then
                                            return;
                                        end;

                                        SetCount((math.clamp(u40.Value + p66, 1, Owned)));
                                    end;

                                    local function sellMax() -- Line: 586
                                        -- upvalues: u15 (ref), Name (ref), Owned (ref), u40 (ref), u65 (ref), SetCount (ref)
                                        if u15[Name] == nil then
                                            return;
                                        end;

                                        local math_min_ret = math.min(Owned, 999);

                                        if math_min_ret == u40.Value then
                                            return;
                                        end;

                                        u65 = u40.Value < math_min_ret and 1 or -1;
                                        SetCount(math_min_ret);
                                    end;

                                    local u67 = nil;

                                    return p64:Create("Frame")({
                                        ZIndex = 5,
                                        AnchorPoint = Vector2.new(0.5, 0.5),
                                        Position = UDim2.fromScale(0.5, 0.3),
                                        Size = UDim2.fromScale(0.9, 0.25),
                                        BackgroundTransparency = p64:Animation(0.2, u2, {
                                            From = 1
                                        }),
                                        BackgroundColor3 = Color3.new(0.25, 0.25, 0.25),
                                        p64:Create("UIGradient")({
                                            Transparency = NumberSequence.new({
                                                NumberSequenceKeypoint.new(0, 1),
                                                NumberSequenceKeypoint.new(0.25, 0),
                                                NumberSequenceKeypoint.new(0.75, 0),
                                                NumberSequenceKeypoint.new(1, 1)
                                            })
                                        }),
                                        p64:Create("Frame")({
                                            Name = "TxtHolder",
                                            ZIndex = 5,
                                            Size = UDim2.fromScale(0.45, 1),
                                            AnchorPoint = Vector2.new(0.5, 0.5),
                                            Position = UDim2.fromScale(0.5, 0.5),
                                            p64:Create("UICorner")({
                                                CornerRadius = UDim.new(1)
                                            }),
                                            ClipsDescendants = true,
                                            BackgroundColor3 = Color3.new(0.15, 0.15, 0.15),
                                            BackgroundTransparency = 0.5,
                                            p64:State(function(p68, p69) -- Line: 623
                                                -- upvalues: u40 (ref), u67 (ref), u2 (ref), u65 (ref)
                                                local v70 = p68(u40);

                                                if u67 == nil or v70 ~= u67 then
                                                    if u67 == nil then
                                                        u67 = v70;

                                                        return p69:Create("TextLabel")({
                                                            ZIndex = 5,
                                                            BackgroundTransparency = 1,
                                                            TextScaled = true,
                                                            Size = UDim2.fromScale(1, 0.95),
                                                            AnchorPoint = Vector2.new(0.5, 0.5),
                                                            Position = UDim2.fromScale(0.5, 0.5),

                                                            OnClean = function(p71, p72) -- Line: 653, Name: OnClean
                                                                -- upvalues: u65 (ref), u2 (ref)
                                                                p71:Configure(p72)({
                                                                    Position = p71:Animation(UDim2.fromScale(0.5, u65 * 1 * -1), u2)
                                                                });
                                                            end,

                                                            Font = Enum.Font.SourceSansBold,
                                                            Text = v70,
                                                            TextColor3 = Color3.new(1, 1, 1)
                                                        });
                                                    end;

                                                    u67 = v70;

                                                    return p69:Create("TextLabel")({
                                                        ZIndex = 5,
                                                        BackgroundTransparency = 1,
                                                        CleanDelay = 0.2,
                                                        TextScaled = true,
                                                        Size = UDim2.fromScale(1, 0.95),
                                                        AnchorPoint = Vector2.new(0.5, 0.5),
                                                        Position = p69:Animation(UDim2.fromScale(0.5, 0.5), u2, {
                                                            From = UDim2.fromScale(0.5, u65 * 1)
                                                        }),
                                                        Font = Enum.Font.SourceSansBold,
                                                        Text = v70,
                                                        TextColor3 = Color3.new(1, 1, 1),

                                                        OnClean = function(p73, p74) -- Line: 639, Name: OnClean
                                                            -- upvalues: u65 (ref), u2 (ref)
                                                            p73:Configure(p74)({
                                                                Position = p73:Animation(UDim2.fromScale(0.5, u65 * 1 * -1), u2)
                                                            });
                                                        end
                                                    });
                                                end;
                                            end)
                                        }),
                                        Adders(p64, nil, nil, function() -- Line: 667
                                            -- upvalues: u65 (ref), u15 (ref), Name (ref), SetCount (ref), u40 (ref), Owned (ref)
                                            u65 = 1;

                                            if u15[Name] == nil then
                                                return;
                                            end;

                                            SetCount((math.clamp(u40.Value + 1, 1, Owned)));
                                        end, 2),
                                        Adders(p64, {
                                            Position = UDim2.fromScale(1, 0.5),
                                            AnchorPoint = Vector2.new(1, 0.5)
                                        }, 90, function() -- Line: 670
                                            -- upvalues: u65 (ref), u15 (ref), Name (ref), SetCount (ref), u40 (ref), Owned (ref)
                                            u65 = -1;

                                            if u15[Name] == nil then
                                                return;
                                            end;

                                            SetCount((math.clamp(u40.Value + -1, 1, Owned)));
                                        end, 2),
                                        GradientButton(p64, {
                                            Text = "Max",
                                            Font = Enum.Font.SourceSansBold,
                                            TextXAlignment = Enum.TextXAlignment.Center,
                                            TextBoxSize = UDim2.fromScale(0.8, 0.75),
                                            BgColor = Color3_fromRGB_ret,
                                            CornerRadius = UDim.new(1, 0),
                                            Clicked = sellMax,
                                            Properties = {
                                                ZIndex = 5,
                                                AnchorPoint = Vector2.new(0.5, 0),
                                                Position = UDim2.new(0.5, 0, 1, 0),
                                                Size = UDim2_fromScale_ret
                                            }
                                        })
                                    });
                                end;
                            end),
                            p27:Create("TextButton")({
                                Name = "Hover",
                                ZIndex = 3,
                                BackgroundTransparency = 1,
                                Text = "",
                                Size = UDim2.fromScale(1, 1),

                                MouseButton1Click = function() -- Line: 700, Name: MouseButton1Click
                                    -- upvalues: u42 (ref), ScreenEffects (ref), u15 (ref), Name (copy), SetCount (copy)
                                    if not u42 then
                                        return;
                                    end;

                                    ScreenEffects.CircleClick();

                                    if u15[Name] == nil then
                                        SetCount(1);

                                        return;
                                    end;

                                    SetCount(nil);
                                end,

                                MouseEnter = function() -- Line: 709, Name: MouseEnter
                                    -- upvalues: u19 (ref), Name (copy), u20 (ref), u30 (copy), u47 (ref), u44 (ref), u48 (ref), RunService (ref), u46 (ref), u45 (ref), CFrame_new_ret (ref), ApplyEmphasis (copy), u15 (ref)
                                    u19:Set(Name);
                                    u20:Set(u30);

                                    if u47 == nil and u44 ~= nil then
                                        if u48 ~= nil then
                                            u48:Cancel();
                                            u48 = nil;
                                        end;

                                        u47 = RunService.RenderStepped:Connect(function(p75) -- Line: 331
                                            -- upvalues: u46 (ref), u44 (ref), u45 (ref), CFrame_new_ret (ref)
                                            u46 = u46 + 120 * p75;

                                            if u44 == nil then
                                                return;
                                            end;

                                            u44:PivotTo(CFrame.new(u45) * CFrame.Angles(0, math.rad(u46), 0) * CFrame_new_ret);
                                        end);
                                    end;

                                    ApplyEmphasis(u15[Name] == nil and "Hover" or "Selected");
                                end,

                                MouseLeave = function() -- Line: 715, Name: MouseLeave
                                    -- upvalues: StopSpin (copy), u19 (ref), u20 (ref), u15 (ref), Name (copy), u31 (copy), u32 (copy), u33 (copy), u34 (copy), u35 (copy), u36 (copy)
                                    StopSpin();
                                    u19:Reset();
                                    u20:Reset();

                                    if u15[Name] == nil then
                                        u31:Reset();
                                        u32:Reset();
                                        u33:Reset();
                                        u34:Reset();
                                        u35:Reset();
                                        u36:Reset();
                                    end;
                                end
                            })
                        });
                    end)
                })
            }),
            p11:Create("TextLabel")({
                Name = "HoveredName",
                AnchorPoint = Vector2.new(0, 1),
                Position = UDim2.fromScale(0.005, 1),
                Size = UDim2.fromScale(0.5, 0.055),
                BackgroundTransparency = 1,
                Text = u19,
                TextScaled = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                Font = Enum.Font.SourceSansSemibold,
                TextColor3 = u20,
                p11:Create("UIStroke")({
                    Thickness = 3,
                    Transparency = 0.8
                })
            })
        });
    end;
end;
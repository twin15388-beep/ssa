-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u1 = require(ReplicatedStorage.CAM.Client.Controllers.Platform_Handler).Platform.Value == "Mobile";
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local ScreenEffects = require(ReplicatedStorage.CAM.Client.Components.Misc.ScreenEffects);
local Adders = require(ReplicatedStorage.CAM.Client.Components.Misc.Buttons.Adders);
local GradientButton = require(ReplicatedStorage.CAM.Client.Components.Misc.Buttons.GradientButton);
local ItemModels = require(ReplicatedStorage.CAM.Global.Collectibles.ItemModels);
local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);
local Rarities = require(ReplicatedStorage.CAM.Global.Rarities);
local Shop = require(ReplicatedStorage.CAM.Global.Shop);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local Wen = require(ReplicatedStorage.CAM.Client.Components.Layout.ResetOnSpawn.HUD.HudBottomRight.FirstVertical.Wen);
local faye = require(ReplicatedStorage.Packages.faye);
local TweenInfo_new_ret = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u2 = faye.Info(0.15, Enum.EasingStyle.Sine);
local u3 = faye.Info(0.2);
local u4 = faye.Info(0.45);
local Color3_fromRGB_ret = Color3.fromRGB(155, 208, 255);
local UDim2_fromScale_ret = UDim2.fromScale(0.45, 0.7);

return function(u5: table, p6: table?) -- Line: 47
    -- upvalues: Wen (copy), Shop (copy), u4 (copy), u1 (copy), Items (copy), Rarities (copy), Players (copy), Utility (copy), RunService (copy), TweenService (copy), TweenInfo_new_ret (copy), u2 (copy), ItemModels (copy), u3 (copy), Adders (copy), GradientButton (copy), Color3_fromRGB_ret (copy), UDim2_fromScale_ret (copy), ScreenEffects (copy)
    local u7 = p6 ~= nil and p6.Counter or Wen;
    local u8;

    if p6 == nil then
        u8 = false;
    else
        u8 = p6.Single == true;
    end;

    return function(p9: any, p10: userdata, p11: userdata, p12: any) -- Line: 50
        -- upvalues: u5 (copy), Shop (ref), u8 (copy), u4 (ref), u7 (copy), u1 (ref), Items (ref), Rarities (ref), Players (ref), Utility (ref), RunService (ref), TweenService (ref), TweenInfo_new_ret (ref), u2 (ref), ItemModels (ref), u3 (ref), Adders (ref), GradientButton (ref), Color3_fromRGB_ret (ref), UDim2_fromScale_ret (ref), ScreenEffects (ref)
        local u13 = typeof(p12.BuySelection) == "table" and (p12.BuySelection or {}) or {};
        p12.BuySelection = u13;
        local v14 = {};

        for _, v in u5 do
            v14[v] = true;
        end;

        local v15 = 0;

        for i, v in pairs(u13) do
            if v14[i] and Shop.itemsforsale[i] ~= nil then
                if u8 and v15 > 0 then
                    u13[i] = nil;
                else
                    u13[i] = Shop.EffectiveAmount(i, v);
                    v15 = v15 + 1;
                end;
            else
                u13[i] = nil;
            end;
        end;

        local u16 = p9:Value("");
        local u17 = p9:Value(Color3.new(1, 1, 1));
        local u18 = p9:Value(nil);
        local v19 = p9:Value(u5);
        local u20 = p9:Value(UDim2.fromScale(1, 1));

        return p9:Create("Frame")({
            Parent = p10,
            Size = UDim2.fromScale(0.7, 0.5),
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 0.96),
            p9:Create("UIAspectRatioConstraint")({
                AspectRatio = 1.4
            }),
            BackgroundTransparency = 1,
            CleanDelay = 0.45,
            p9:Create("CanvasGroup")({
                Name = "WenCounter",
                AnchorPoint = Vector2.new(1, 1),
                Position = UDim2.fromScale(1.04, 1.098),
                Size = UDim2.fromScale(1, 0.15),
                BackgroundTransparency = 1,
                ZIndex = 99,
                GroupTransparency = p9:Animation(0, u4, {
                    From = 1
                }),

                OnClean = function(p21) -- Line: 122, Name: OnClean
                    -- upvalues: u4 (ref)
                    return {
                        GroupTransparency = p21:Animation(1, u4)
                    };
                end,

                p9:Create("Frame")({
                    AnchorPoint = Vector2.new(1, 1),
                    Position = UDim2.fromScale(1, 1),
                    Size = UDim2.fromScale(1, 1),
                    p9:Create("UIAspectRatioConstraint")({
                        AspectRatio = 1
                    }),
                    BackgroundTransparency = 1,
                    u7(p9)
                })
            }),
            p9:Create("CanvasGroup")({
                Name = "Panel",
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                GroupTransparency = p9:Animation(0, u4, {
                    From = 1
                }),

                OnClean = function(p22) -- Line: 147, Name: OnClean
                    -- upvalues: u4 (ref)
                    return {
                        GroupTransparency = p22:Animation(1, u4)
                    };
                end,

                p9:Create("Frame")({
                    Name = "TilesHolder",
                    Size = UDim2.fromScale(1, 0.94),
                    BackgroundTransparency = 1,
                    p9:Create("Frame")({
                        Name = "Bg",
                        Size = UDim2.fromScale(1, 0.5),
                        AnchorPoint = Vector2.new(0.5, 1),
                        Position = UDim2.fromScale(0.5, 1),
                        BackgroundColor3 = Color3.new(),
                        p9:Create("UICorner")({
                            CornerRadius = UDim.new(0, 5)
                        }),
                        p9:Create("UIGradient")({
                            Rotation = -90,
                            Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.7), NumberSequenceKeypoint.new(1, 1) })
                        })
                    }),
                    p9:Create("ScrollingFrame")({
                        Size = UDim2.new(1, 0, 1, 0),
                        Position = UDim2.fromScale(0.5, 0.5),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        BackgroundTransparency = 1,
                        Name = "Actual",
                        CanvasSize = u20,
                        ScrollingDirection = Enum.ScrollingDirection.Y,
                        ElasticBehavior = Enum.ElasticBehavior.WhenScrollable,
                        ScrollBarThickness = 0,
                        p9:Create("UIGridLayout")({
                            StartCorner = Enum.StartCorner.BottomLeft,
                            FillDirection = Enum.FillDirection.Horizontal,
                            VerticalAlignment = Enum.VerticalAlignment.Bottom,
                            HorizontalAlignment = Enum.HorizontalAlignment.Left,
                            CellSize = UDim2.fromScale((u1 and 1.5 or 1) * 0.159, 1),
                            CellPadding = UDim2.new((u1 and 1.5 or 1) * 0.008, 0, 0, 5),
                            p9:Create("UIAspectRatioConstraint")({}),

                            AbsoluteContentSizeOnChangedInit = function(p23: userdata) -- Line: 221, Name: AbsoluteContentSizeOnChangedInit
                                -- upvalues: u20 (copy)
                                local Parent = p23.Parent;
                                local Y = Parent.AbsoluteWindowSize.Y;
                                local math_max_ret = math.max(p23.AbsoluteContentSize.Y - Y, 0);
                                u20:Set(UDim2.new(1, 0, 1, math_max_ret));

                                local function toBottom() -- Line: 235
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
                        p9:Iterate(v19, function(p24: any, u25: any, p26: any, p27: userdata?) -- Line: 248
                            -- upvalues: Shop (ref), Items (ref), Rarities (ref), Players (ref), u8 (ref), u13 (copy), Utility (ref), u18 (copy), RunService (ref), TweenService (ref), TweenInfo_new_ret (ref), u4 (ref), u2 (ref), ItemModels (ref), u3 (ref), Adders (ref), GradientButton (ref), Color3_fromRGB_ret (ref), UDim2_fromScale_ret (ref), ScreenEffects (ref), u16 (copy), u17 (copy), u1 (ref)
                            local v28 = Shop.itemsforsale[u25];
                            local v29 = Items[u25] ~= nil and true or nil;
                            local u30 = Items[u25];

                            if not u30 then
                                if v28 == nil or (v28.Icon == nil or not v28) then
                                    u30 = nil;
                                else
                                    u30 = v28;
                                end;
                            end;

                            if u30 == nil then
                                warn((`Shop: "{u25}" is not in the item catalogue, tile skipped`));

                                return nil;
                            end;

                            local u31 = Rarities.Colors[u30.Rarity] or Color3.new(1, 1, 1);
                            local _, v32 = next(u30.PackContents or {});
                            local u33 = Shop.CanBuyResults(Players.LocalPlayer, u25);
                            local u34;

                            if u33 == nil then
                                u34 = false;
                            else
                                u34 = #u33 > 0;
                            end;

                            for _, v in u33 or {} do
                                if not v.CanBuy then
                                    u34 = false;
                                    break;
                                end;
                            end;

                            local v35;

                            if v28 == nil or v28.Price == nil then
                                v35 = false;
                            else
                                v35 = v28.Price.Product ~= nil and true or v28.Price.Gamepass ~= nil;
                            end;

                            local u36;

                            if v28 == nil or u30.Skills ~= nil then
                                u36 = false;
                            else
                                u36 = not (u30.HasCombat or v35) and not u8;
                            end;

                            local v37 = u13[u25];
                            local u38 = p26:Value(v37 ~= nil);
                            local u39 = p26:Value(v37 or 1);
                            local u40 = 1;
                            local u41;

                            if u36 then
                                u41 = {};

                                for i, v in u33 or {} do
                                    u41[i] = p26:Value(Utility.addCommasToNumber(v.Price * (v37 or 1)));
                                end;
                            else
                                u41 = nil;
                            end;

                            local u42 = p26:Value(u34 and 0.25 or 0.45);
                            local u43 = p26:Value(0.75);
                            local u44 = p26:Value(u34 and 0.4 or 0.65);
                            local u45 = p26:Value(0.2);
                            local u46 = p26:Value(u34 and 0.25 or 0.5);
                            local u47 = p26:Value(1);

                            local function ApplyEmphasis(p48: string) -- Line: 319
                                -- upvalues: u42 (copy), u43 (copy), u44 (copy), u45 (copy), u46 (copy), u47 (copy)
                                if p48 == "Selected" then
                                    u42:Set(0.05);
                                    u43:Set(0.5);
                                    u44:Set(0.05);
                                    u45:Set(0);
                                    u46:Set(0);
                                    u47:Set(0.2);

                                    return;
                                end;

                                if p48 == "Hover" then
                                    u42:Set(0.15);
                                    u43:Set(0.65);
                                    u44:Set(0.2);
                                    u45:Set(0.1);
                                    u46:Set(0.1);
                                    u47:Set(1);

                                    return;
                                end;

                                u42:Reset();
                                u43:Reset();
                                u44:Reset();
                                u45:Reset();
                                u46:Reset();
                                u47:Reset();
                            end;

                            if v37 ~= nil then
                                u42:Set(0.05);
                                u43:Set(0.5);
                                u44:Set(0.05);
                                u45:Set(0);
                                u46:Set(0);
                                u47:Set(0.2);

                                if u8 then
                                    u18:Set(u25);
                                end;
                            end;

                            local function SetCount(p49: number?) -- Line: 348
                                -- upvalues: u13 (ref), u25 (copy), u38 (copy), u42 (copy), u43 (copy), u44 (copy), u45 (copy), u46 (copy), u47 (copy), u8 (ref), u18 (ref), u39 (copy), u41 (ref), u33 (copy), Utility (ref)
                                if p49 == nil then
                                    u13[u25] = nil;
                                    u38:Set(false);
                                    u42:Set(0.15);
                                    u43:Set(0.65);
                                    u44:Set(0.2);
                                    u45:Set(0.1);
                                    u46:Set(0.1);
                                    u47:Set(1);
                                else
                                    if u8 then
                                        u18:Set(u25);
                                        p49 = 1;
                                    end;

                                    p49 = math.clamp(p49, 1, 99);
                                    u13[u25] = p49;
                                    u38:Set(true);
                                    u39:Set(p49);
                                    u42:Set(0.05);
                                    u43:Set(0.5);
                                    u44:Set(0.05);
                                    u45:Set(0);
                                    u46:Set(0);
                                    u47:Set(0.2);
                                end;

                                if u41 ~= nil then
                                    for i, v in u33 or {} do
                                        u41[i]:Set(Utility.addCommasToNumber(v.Price * (p49 or 1)));
                                    end;
                                end;
                            end;

                            if u8 then
                                p26:Reactive(function(p50) -- Line: 374
                                    -- upvalues: u18 (ref), u25 (copy), u13 (ref), u38 (copy), u42 (copy), u43 (copy), u44 (copy), u45 (copy), u46 (copy), u47 (copy)
                                    if p50(u18) ~= u25 and u13[u25] ~= nil then
                                        u13[u25] = nil;
                                        u38:Set(false);
                                        u42:Reset();
                                        u43:Reset();
                                        u44:Reset();
                                        u45:Reset();
                                        u46:Reset();
                                        u47:Reset();
                                    end;
                                end);
                            end;

                            local function AdjustAmount(p51: number) -- Line: 383
                                -- upvalues: u13 (ref), u25 (copy), u39 (copy), Shop (ref), Players (ref), u40 (ref), SetCount (copy)
                                if u13[u25] == nil then
                                    return;
                                end;

                                local math_clamp_ret = math.clamp(u39.Value + p51, 1, 99);

                                if math_clamp_ret == u39.Value then
                                    return;
                                end;

                                if u39.Value < math_clamp_ret and not Shop.CanBuy(Players.LocalPlayer, u25, nil, math_clamp_ret) then
                                    return;
                                end;

                                u40 = p51;
                                SetCount(math_clamp_ret);
                            end;

                            local function SelectMax() -- Line: 395
                                -- upvalues: u13 (ref), u25 (copy), Shop (ref), Players (ref), u39 (copy), u40 (ref), SetCount (copy)
                                if u13[u25] == nil then
                                    return;
                                end;

                                local v52 = 1;
                                local v53 = 99;

                                while v52 < v53 do
                                    local math_ceil_ret = math.ceil((v52 + v53) / 2);

                                    if Shop.CanBuy(Players.LocalPlayer, u25, nil, math_ceil_ret) then
                                        v52 = math_ceil_ret;
                                    else
                                        v53 = math_ceil_ret - 1;
                                    end;
                                end;

                                if v52 == u39.Value then
                                    return;
                                end;

                                u40 = u39.Value < v52 and 1 or -1;
                                SetCount(v52);
                            end;

                            local u54 = nil;
                            local CFrame_new_ret = CFrame.new();
                            local u55 = Vector3.new(0, 0, 0);
                            local u56 = 0;
                            local u57 = nil;
                            local u58 = nil;
                            local NumberValue = Instance.new("NumberValue");
                            NumberValue.Changed:Connect(function(p59: number) -- Line: 423, Name: ApplyAngle
                                -- upvalues: u56 (ref), u54 (ref), u55 (ref), CFrame_new_ret (ref)
                                u56 = p59;

                                if u54 ~= nil then
                                    u54:PivotTo(CFrame.new(u55) * CFrame.Angles(0, math.rad(p59), 0) * CFrame_new_ret);
                                end;
                            end);

                            local function StartSpin() -- Line: 432
                                -- upvalues: u58 (ref), u57 (ref), u54 (ref), RunService (ref), u56 (ref), u55 (ref), CFrame_new_ret (ref)
                                if u58 ~= nil then
                                    u58:Cancel();
                                    u58 = nil;
                                end;

                                if u57 ~= nil or u54 == nil then
                                    return;
                                end;

                                u57 = RunService.RenderStepped:Connect(function(p60) -- Line: 438
                                    -- upvalues: u56 (ref), u54 (ref), u55 (ref), CFrame_new_ret (ref)
                                    local v61 = u56 + p60 * 120;
                                    u56 = v61;

                                    if u54 ~= nil then
                                        u54:PivotTo(CFrame.new(u55) * CFrame.Angles(0, math.rad(v61), 0) * CFrame_new_ret);
                                    end;
                                end);
                            end;

                            local function StopSpin() -- Line: 442
                                -- upvalues: u57 (ref), u54 (ref), u56 (ref), NumberValue (copy), u58 (ref), TweenService (ref), TweenInfo_new_ret (ref)
                                if u57 ~= nil then
                                    u57:Disconnect();
                                    u57 = nil;
                                end;

                                if u54 == nil then
                                    return;
                                end;

                                u56 = u56 % 360;
                                NumberValue.Value = u56;
                                u58 = TweenService:Create(NumberValue, TweenInfo_new_ret, {
                                    Value = u56 > 180 and 360 or 0
                                });
                                u58:Play();
                            end;

                            local v62 = p26:Create("Frame");
                            local v63 = {
                                BackgroundTransparency = 1,
                                CleanDelay = u4.Time
                            };
                            local v64 = p26:Create("Frame")({
                                Name = "Bg",
                                AnchorPoint = Vector2.new(0.5, 0.5),
                                Position = UDim2.fromScale(0.5, 0.5),
                                Size = UDim2.new(1, -4, 1, -4),
                                p26:Create("UICorner")({
                                    CornerRadius = UDim.new(0.1)
                                }),
                                BackgroundTransparency = p26:Animation(u42, u2),
                                p26:Create("UIGradient")({
                                    Rotation = 90,
                                    Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0.65) })
                                }),
                                BackgroundColor3 = Color3.new(0, 0, 0),
                                p26:Create("Frame")({
                                    AnchorPoint = Vector2.new(0.5, 0.5),
                                    Position = UDim2.fromScale(0.5, 0.5),
                                    Size = UDim2.new(1, -8, 1, -8),
                                    p26:Create("UICorner")({
                                        CornerRadius = UDim.new(0.1)
                                    }),
                                    BackgroundColor3 = u31,
                                    BackgroundTransparency = p26:Animation(u43, u2),
                                    p26:Create("UIGradient")({
                                        Rotation = -90,
                                        Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) })
                                    }),
                                    p26:Create("UIStroke")({
                                        Color = u31,
                                        Transparency = p26:Animation(u44, u2),
                                        p26:Create("UIGradient")({
                                            Rotation = -90,
                                            Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) })
                                        })
                                    }),
                                    p26:Create("Frame")({
                                        Name = "SelectedRing",
                                        AnchorPoint = Vector2.new(0.5, 0.5),
                                        Position = UDim2.fromScale(0.5, 0.5),
                                        Size = UDim2.new(1, -8, 1, -8),
                                        BackgroundTransparency = 1,
                                        p26:Create("UICorner")({
                                            CornerRadius = UDim.new(0.1)
                                        }),
                                        p26:Create("UIStroke")({
                                            Thickness = 1.5,
                                            Color = Color3.new(1, 1, 1),
                                            Transparency = p26:Animation(u47, u2)
                                        })
                                    })
                                })
                            });
                            local v65 = p26:Create("ImageLabel")({
                                Name = "BgImage",
                                Image = u30.Icon,
                                BackgroundTransparency = 1,
                                AnchorPoint = Vector2.new(0.5, 0.5),
                                Position = UDim2.fromScale(0.5, 0.5),
                                Size = UDim2.new(0.7, 0.7, 0.7),
                                p26:Create("UIGradient")({
                                    Rotation = 90,
                                    Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.4), NumberSequenceKeypoint.new(1, 1) })
                                })
                            });
                            local v74 = v29 and p26:Create("ViewportFrame")({
                                AnchorPoint = Vector2.new(0.5, 0.5),
                                Position = UDim2.fromScale(0.5, 0.5),
                                Size = UDim2.fromScale(0.8, 0.8),
                                BackgroundTransparency = 1,
                                BorderSizePixel = 0,
                                BorderColor3 = Color3.new(),
                                BackgroundColor3 = Color3.new(),
                                ImageTransparency = p26:Animation(u45, u2),

                                function(p66: userdata) -- Line: 546
                                    -- upvalues: ItemModels (ref), u25 (copy), u30 (copy), u55 (ref), CFrame_new_ret (ref), u54 (ref), u56 (ref), u57 (ref), u58 (ref)
                                    local v67 = ItemModels.Get(u25);

                                    if v67 == nil then
                                        warn((`Shop: no ItemAssets model for "{u25}"`));

                                        return;
                                    end;

                                    local v68 = v67:Clone();

                                    if v68:IsA("BasePart") then
                                        v68.Anchored = true;
                                    end;

                                    for _, v in v68:QueryDescendants("BasePart") do
                                        v.Anchored = true;
                                    end;

                                    v68.Parent = p66;
                                    local v69 = u30.ViewmodelSettings or {};
                                    local CFrame_new_ret2 = CFrame.new();

                                    if typeof(v69.CFrameOffset) == "CFrame" then
                                        CFrame_new_ret2 = v69.CFrameOffset.Rotation;
                                        u55 = v69.CFrameOffset.Position;
                                    end;

                                    v68:PivotTo(CFrame_new_ret2);
                                    local v70, v71;

                                    if v68:IsA("Model") then
                                        v70, v71 = v68:GetBoundingBox();
                                    else
                                        v70 = v68.CFrame;
                                        v71 = v68.Size;
                                    end;

                                    CFrame_new_ret = CFrame.new(-v70.Position) * CFrame_new_ret2;
                                    u54 = v68;
                                    u56 = 0;

                                    if u54 ~= nil then
                                        u54:PivotTo(CFrame.new(u55) * CFrame.Angles(0, 0, 0) * CFrame_new_ret);
                                    end;

                                    local Camera = Instance.new("Camera");
                                    Camera.Parent = p66;
                                    p66.CurrentCamera = Camera;
                                    local v72 = v71.Magnitude / 2;
                                    local math_rad_ret = math.rad(Camera.FieldOfView / 2);
                                    local v73 = v72 / math.tan(math_rad_ret) + v72 - 1 + (tonumber(v69.CameraOffset) or 0);
                                    Camera.CFrame = CFrame.new(Vector3.new(0, 0, v73), Vector3.new(0, 0, 0));
                                    p66.Destroying:Connect(function() -- Line: 594
                                        -- upvalues: u57 (ref), u58 (ref), u54 (ref)
                                        if u57 ~= nil then
                                            u57:Disconnect();
                                            u57 = nil;
                                        end;

                                        if u58 ~= nil then
                                            u58:Cancel();
                                            u58 = nil;
                                        end;

                                        u54 = nil;
                                    end);
                                end
                            }) or p26:Create("ImageLabel")({
                                AnchorPoint = Vector2.new(0.5, 0.5),
                                Position = UDim2.fromScale(0.5, 0.5),
                                Size = UDim2.fromScale(0.6, 0.6),
                                BackgroundTransparency = 1,
                                Image = u30.Icon,
                                ImageTransparency = p26:Animation(u45, u2),
                                p26:Create("UIAspectRatioConstraint")({})
                            });
                            local v75;

                            if (v32 or 0) > 1 then
                                v75 = p26:Create("TextLabel")({
                                    Name = "PackCount",
                                    ZIndex = 4,
                                    AnchorPoint = Vector2.new(1, 0),
                                    Position = UDim2.new(1, -4, 0, 2),
                                    Size = UDim2.fromScale(0.4, 0.18),
                                    BackgroundTransparency = 1,
                                    Text = `x{v32}`,
                                    TextScaled = true,
                                    TextXAlignment = Enum.TextXAlignment.Right,
                                    Font = Enum.Font.SourceSansBold,
                                    TextColor3 = Color3.new(1, 1, 1),
                                    TextTransparency = 0.2,
                                    p26:Create("UIStroke")({
                                        Thickness = 1,
                                        Transparency = 0.6
                                    })
                                }) or nil;
                            else
                                v75 = nil;
                            end;

                            v63[1], v63[2], v63[3], v63[4], v63[5], v63[6], v63[7] = v64, v65, v74, v75, p26:Create("CanvasGroup")({
    Name = "PriceHolder",
    ZIndex = 4,
    AnchorPoint = Vector2.new(0.5, 1),
    Position = UDim2.new(0.5, 0, 1, -8),
    Size = UDim2.fromScale(0.9, 1),
    BackgroundTransparency = 1,
    GroupTransparency = p26:Animation(u46, u2),
    p26:Create("UIListLayout")({
        Wraps = true,
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Padding = UDim.new(0, 2)
    }),
    p26:Iterate(u33 or {}, function(p76, p77, p78) -- Line: 665
        -- upvalues: u4 (ref), u41 (ref), Utility (ref), u34 (ref)
        return p78:Create("Frame")({
            CleanDelay = u4.Time,
            ZIndex = 4,
            Size = UDim2.new(0.65, 0, 0.25, 0),
            BackgroundTransparency = 1,
            p78:Create("UIListLayout")({
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = UDim.new(0, 2)
            }),
            p78:Create("ImageLabel")({
                ZIndex = 5,
                LayoutOrder = 1,
                Size = UDim2.fromScale(1, 1),
                Instance.new("UIAspectRatioConstraint"),
                BackgroundTransparency = 1,
                Image = p77.Icon,
                ImageColor3 = p77.Color or Color3.new(1, 1, 1)
            }),
            p78:Create("TextLabel")({
                ZIndex = 4,
                LayoutOrder = 2,
                Size = UDim2.fromScale(0.7, 1),
                BackgroundTransparency = 1,
                Text = u41 ~= nil and u41[p76] or Utility.addCommasToNumber(p77.Price),
                TextScaled = true,
                Font = Enum.Font.SourceSansBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextColor3 = u34 and (p77.Color or Color3.new(1, 1, 1)) or Color3.new(1, 0.35, 0.35),
                p78:Create("UIStroke")({
                    Thickness = 1,
                    Transparency = 0.6
                }),
                p78:Create("UIShadow")({
                    Transparency = 0.5,
                    BlurRadius = UDim.new(0.5),
                    Spread = UDim2.fromScale(0.2, 0.15),
                    Offset = UDim2.fromScale(-0.2, 0)
                })
            })
        });
    end)
}), p26:State(function(p79, p80) -- Line: 729
    -- upvalues: u36 (copy), u38 (copy), u3 (ref), u39 (copy), u40 (ref), Adders (ref), AdjustAmount (copy), GradientButton (ref), Color3_fromRGB_ret (ref), SelectMax (copy), UDim2_fromScale_ret (ref)
    if u36 and p79(u38) then
        local u81 = nil;

        return p80:Create("Frame")({
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.3),
            Size = UDim2.fromScale(0.9, 0.25),
            BackgroundTransparency = p80:Animation(0.2, u3, {
                From = 1
            }),
            BackgroundColor3 = Color3.new(0.25, 0.25, 0.25),
            p80:Create("UIGradient")({
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(0.25, 0),
                    NumberSequenceKeypoint.new(0.75, 0),
                    NumberSequenceKeypoint.new(1, 1)
                })
            }),
            p80:Create("Frame")({
                Name = "TxtHolder",
                ZIndex = 5,
                LayoutOrder = 1,
                Size = UDim2.fromScale(0.45, 1),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                p80:Create("UICorner")({
                    CornerRadius = UDim.new(1)
                }),
                ClipsDescendants = true,
                BackgroundColor3 = Color3.new(0.15, 0.15, 0.15),
                BackgroundTransparency = 0.5,
                p80:State(function(p82, p83) -- Line: 762
                    -- upvalues: u39 (ref), u81 (ref), u3 (ref), u40 (ref)
                    local v84 = p82(u39);

                    if u81 == nil or v84 ~= u81 then
                        if u81 == nil then
                            u81 = v84;

                            return p83:Create("TextLabel")({
                                ZIndex = 5,
                                BackgroundTransparency = 1,
                                TextScaled = true,
                                Size = UDim2.fromScale(1, 0.95),
                                AnchorPoint = Vector2.new(0.5, 0.5),
                                Position = UDim2.fromScale(0.5, 0.5),

                                OnClean = function(p85, p86) -- Line: 792, Name: OnClean
                                    -- upvalues: u40 (ref), u3 (ref)
                                    p85:Configure(p86)({
                                        Position = p85:Animation(UDim2.fromScale(0.5, u40 * 1 * -1), u3)
                                    });
                                end,

                                Font = Enum.Font.SourceSansBold,
                                Text = v84,
                                TextColor3 = Color3.new(1, 1, 1)
                            });
                        end;

                        u81 = v84;

                        return p83:Create("TextLabel")({
                            ZIndex = 5,
                            BackgroundTransparency = 1,
                            CleanDelay = 0.2,
                            TextScaled = true,
                            Size = UDim2.fromScale(1, 0.95),
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            Position = p83:Animation(UDim2.fromScale(0.5, 0.5), u3, {
                                From = UDim2.fromScale(0.5, u40 * 1)
                            }),
                            Font = Enum.Font.SourceSansBold,
                            Text = v84,
                            TextColor3 = Color3.new(1, 1, 1),

                            OnClean = function(p87, p88) -- Line: 778, Name: OnClean
                                -- upvalues: u40 (ref), u3 (ref)
                                p87:Configure(p88)({
                                    Position = p87:Animation(UDim2.fromScale(0.5, u40 * 1 * -1), u3)
                                });
                            end
                        });
                    end;
                end)
            }),
            Adders(p80, nil, nil, function() -- Line: 806
                -- upvalues: AdjustAmount (ref)
                AdjustAmount(1);
            end, 2),
            Adders(p80, {
                Position = UDim2.fromScale(1, 0.5),
                AnchorPoint = Vector2.new(1, 0.5)
            }, 90, function() -- Line: 809
                -- upvalues: AdjustAmount (ref)
                AdjustAmount(-1);
            end, 2),
            GradientButton(p80, {
                Text = "Max",
                Font = Enum.Font.SourceSansBold,
                TextXAlignment = Enum.TextXAlignment.Center,
                TextBoxSize = UDim2.fromScale(0.8, 0.75),
                BgColor = Color3_fromRGB_ret,
                CornerRadius = UDim.new(1, 0),
                Clicked = SelectMax,
                Properties = {
                    ZIndex = 5,
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.new(0.5, 0, 1, 0),
                    Size = UDim2_fromScale_ret
                }
            })
        });
    end;
end), p26:Create("TextButton")({
    Name = "Hover",
    ZIndex = 3,
    BackgroundTransparency = 1,
    Text = "",
    Size = UDim2.fromScale(1, 1),

    MouseButton1Click = function() -- Line: 845, Name: MouseButton1Click
        -- upvalues: u34 (ref), ScreenEffects (ref), u13 (ref), u25 (copy), SetCount (copy)
        if not u34 then
            return;
        end;

        ScreenEffects.CircleClick();

        if u13[u25] == nil then
            SetCount(1);

            return;
        end;

        SetCount(nil);
    end,

    MouseEnter = function() -- Line: 855, Name: MouseEnter
        -- upvalues: u34 (ref), u16 (ref), u25 (copy), u17 (ref), u31 (copy), u58 (ref), u57 (ref), u54 (ref), RunService (ref), u56 (ref), u55 (ref), CFrame_new_ret (ref), ApplyEmphasis (copy), u13 (ref)
        if not u34 then
            return;
        end;

        u16:Set(u25);
        u17:Set(u31);

        if u58 ~= nil then
            u58:Cancel();
            u58 = nil;
        end;

        if u57 == nil and u54 ~= nil then
            u57 = RunService.RenderStepped:Connect(function(p89) -- Line: 438
                -- upvalues: u56 (ref), u54 (ref), u55 (ref), CFrame_new_ret (ref)
                local v90 = u56 + p89 * 120;
                u56 = v90;

                if u54 ~= nil then
                    u54:PivotTo(CFrame.new(u55) * CFrame.Angles(0, math.rad(v90), 0) * CFrame_new_ret);
                end;
            end);
        end;

        ApplyEmphasis(u13[u25] == nil and "Hover" or "Selected");
    end,

    MouseLeave = function() -- Line: 862, Name: MouseLeave
        -- upvalues: StopSpin (copy), u1 (ref), u16 (ref), u17 (ref), u13 (ref), u25 (copy), u42 (copy), u43 (copy), u44 (copy), u45 (copy), u46 (copy), u47 (copy)
        StopSpin();

        if not u1 then
            u16:Reset();
            u17:Reset();
        end;

        if u13[u25] == nil then
            u42:Reset();
            u43:Reset();
            u44:Reset();
            u45:Reset();
            u46:Reset();
            u47:Reset();
        end;
    end
});

                            return v62(v63);
                        end)
                    })
                }),
                p9:Create("TextLabel")({
                    Name = "HoveredName",
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.fromScale(0.005, 1),
                    Size = UDim2.fromScale(0.5, 0.055),
                    BackgroundTransparency = 1,
                    Text = u16,
                    TextScaled = true,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.SourceSansSemibold,
                    TextColor3 = u17,
                    p9:Create("UIStroke")({
                        Thickness = 3,
                        Transparency = 0.8
                    })
                })
            })
        });
    end;
end;
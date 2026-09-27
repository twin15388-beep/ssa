-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local faye = require(ReplicatedStorage.Packages.faye);
local Crafting = require(ReplicatedStorage.CAM.Global.Crafting);
local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);
local Rarities = require(ReplicatedStorage.CAM.Global.Rarities);
local Refinement = require(ReplicatedStorage.CAM.Global.Refinement);
local Series = require(ReplicatedStorage.CAM.Global.Series);
local Shop = require(ReplicatedStorage.CAM.Global.Shop);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local GradientButton = require(ReplicatedStorage.CAM.Client.Components.Misc.Buttons.GradientButton);
local DebrisModule = require(ReplicatedStorage.CAM.DebrisModule);
local PopUpCreator = require(ReplicatedStorage.CAM.Global.Subsets.Classes.PopUpCreator);
local SignalFunction = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalFunction);
local MaterialCard = require(script.Parent.MaterialCard);
local TierBadge = require(script.Parent.TierBadge);
local MaterialTile = require(script.Parent.MaterialTile);
local RefineBadge = require(script.Parent.RefineBadge);
local u1 = faye.Info(0.25, Enum.EasingStyle.Back);
local UDim2_fromScale_ret = UDim2.fromScale(0.9, 0.9);
local u2 = faye.Info(0.2);
local u3 = faye.Info(0.2, Enum.EasingStyle.Back);
local Color3_fromRGB_ret = Color3.fromRGB(255, 95, 95);
local Color3_new_ret = Color3.new(1, 1, 1);
local Color3_fromRGB_ret2 = Color3.fromRGB(85, 170, 255);
local Color3_new_ret2 = Color3.new(0.35, 0.35, 0.35);

return function(p4: any, u5: any, u6: function) -- Line: 50
    -- upvalues: Crafting (copy), Items (copy), Rarities (copy), Utility (copy), Players (copy), Refinement (copy), Series (copy), Shop (copy), u1 (copy), UDim2_fromScale_ret (copy), MaterialCard (copy), u3 (copy), RefineBadge (copy), TierBadge (copy), MaterialTile (copy), Color3_new_ret (copy), Color3_fromRGB_ret (copy), u2 (copy), GradientButton (copy), Color3_fromRGB_ret2 (copy), Color3_new_ret2 (copy), PopUpCreator (copy), SignalFunction (copy), ReplicatedStorage (copy), DebrisModule (copy)
    return p4:Create("Frame")({
        Name = "Recipe",
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -6, 0.5, 0),
        Size = UDim2.new(0.65, -18, 1, -12),
        BackgroundTransparency = 1,
        p4:State(function(p7: function, u8: any) -- Line: 59
            -- upvalues: u5 (copy), Crafting (ref), Items (ref), Rarities (ref), Utility (ref), Players (ref), Refinement (ref), Series (ref), Shop (ref), u1 (ref), UDim2_fromScale_ret (ref), MaterialCard (ref), u3 (ref), RefineBadge (ref), TierBadge (ref), u6 (copy), MaterialTile (ref), Color3_new_ret (ref), Color3_fromRGB_ret (ref), u2 (ref), GradientButton (ref), Color3_fromRGB_ret2 (ref), Color3_new_ret2 (ref), PopUpCreator (ref), SignalFunction (ref), ReplicatedStorage (ref), DebrisModule (ref)
            local u9 = p7(u5);

            if u9 == "" then
                return;
            end;

            local u10 = Crafting.Get(u9);

            if u10 == nil then
                return;
            end;

            local v11 = Items[u10.result];
            local v12 = v11 ~= nil and Rarities.Colors[v11.Rarity] or Color3.new(1, 1, 1);
            local v13 = v11 == nil and "" or (Rarities.Order[v11.Rarity] or "");
            local v14 = string.upper((string.sub(v13, 1, 1))) .. string.lower((string.sub(v13, 2)));
            local v15 = v12:Lerp(Color3.new(1, 1, 1), 0.45);
            local Data = Utility.GetData(Players.LocalPlayer);
            local v16;

            if Data == nil then
                v16 = nil;
            else
                v16 = Data:FindFirstChild("Inventory") or nil;
            end;

            local u17;

            if v16 == nil then
                u17 = nil;
            else
                u17 = v16:FindFirstChild("Inventory") or nil;
            end;

            local u18 = u8:Value(0);
            local u19 = {};

            local function bump() -- Line: 79
                -- upvalues: u18 (copy)
                u18:Set(u18.Value + 1);
            end;

            for _, v in u10.required do
                u19[v.name] = true;
            end;

            for _, v in u10.additionalMaterials do
                u19[v.name] = true;
            end;

            for _, v in u10.keep or {} do
                u19[v] = true;
            end;

            for i in u10.price do
                u19[i] = true;
            end;

            local function watchStack(p20: userdata) -- Line: 95
                -- upvalues: u19 (copy), u18 (copy), u8 (copy), bump (copy)
                if not u19[p20.Name] then
                    return;
                end;

                u18:Set(u18.Value + 1);
                local Amount = p20:FindFirstChild("Amount");

                if Amount ~= nil then
                    u8:Connect(Amount.Changed, bump);
                end;
            end;

            if u17 ~= nil then
                for _, child in u17:GetChildren() do
                    if u19[child.Name] then
                        u18:Set(u18.Value + 1);
                        local Amount = child:FindFirstChild("Amount");

                        if Amount ~= nil then
                            u8:Connect(Amount.Changed, bump);
                        end;
                    end;
                end;

                u8:Connect(u17.ChildAdded, watchStack);
                u8:Connect(u17.ChildRemoved, function(p21: userdata) -- Line: 108
                    -- upvalues: u19 (copy), u18 (copy)
                    if u19[p21.Name] then
                        u18:Set(u18.Value + 1);
                    end;
                end);
            end;

            local v22;

            if Data == nil then
                v22 = nil;
            else
                v22 = Data:FindFirstChild("Wen") or nil;
            end;

            if v22 ~= nil then
                u8:Connect(v22.Changed, bump);
            end;

            local Items_Config = Players.LocalPlayer:FindFirstChild("Items_Config");
            local v23;

            if Items_Config == nil then
                v23 = nil;
            else
                v23 = Items_Config:FindFirstChild("Equipped") or nil;
            end;

            if v23 ~= nil then
                u8:Connect(v23.Changed, bump);
            end;

            local function tierOf(p24: string) -- Line: 122
                -- upvalues: Crafting (ref), u10 (copy)
                return Crafting.RequiredTier(u10, p24);
            end;

            local function spentLevel(p25: function, p26: string) -- Line: 126
                -- upvalues: u18 (copy), Crafting (ref), Players (ref), tierOf (copy)
                p25(u18);
                local v27 = Crafting.SpentCopy(Players.LocalPlayer, p26, tierOf(p26));

                if v27 == nil then
                    return nil;
                end;

                local RefineLevel = v27:FindFirstChild("RefineLevel");

                return RefineLevel == nil and 0 or RefineLevel.Value;
            end;

            local u28 = nil;

            if u10.refineKept ~= nil then
                for _, v in u10.required do
                    if Refinement.IsRefinable(v.name) then
                        u28 = v.name;
                        break;
                    end;
                end;
            end;

            local function owned(p29: function, p30: string) -- Line: 146
                -- upvalues: u18 (copy), u17 (ref), Crafting (ref), u10 (copy), Series (ref)
                p29(u18);

                if u17 == nil then
                    return 0;
                end;

                local v31 = Crafting.RequiredTier(u10, p30);
                local v32 = 0;

                for _, child in u17:GetChildren() do
                    if child.Name == p30 and (child:FindFirstChild("NoSave") == nil and (child:FindFirstChild("QuestGrant") == nil and (v31 == nil or Series.TierOf(child) == v31))) then
                        local Amount = child:FindFirstChild("Amount");
                        v32 = v32 + (Amount == nil and 1 or (Amount.Value or 1));
                    end;
                end;

                return v32;
            end;

            local u33 = {};

            for _, v in { u10.required, u10.additionalMaterials } do
                for _, v2 in v do
                    u33[v2.name] = (u33[v2.name] or 0) + v2.amount;
                end;
            end;

            local function canPay(p34: function, p35: string, p36: number) -- Line: 170
                -- upvalues: u18 (copy), Shop (ref), Data (copy), Items (ref), owned (copy), u33 (copy)
                p34(u18);
                local v37 = Shop.cashiers[p35];

                if v37 == nil or Data == nil then
                    return false;
                end;

                if v37.Deferred == true or Items[p35] == nil then
                    return v37.CanBuy(Data, p36) == true;
                end;

                return owned(p34, p35) >= p36 + (u33[p35] or 0);
            end;

            local u38 = {};

            for i, v in u10.price do
                local v39 = {
                    Currency = i,
                    Amount = Crafting.PricedLine(nil, u10, i, v)
                };
                table.insert(u38, v39);
            end;

            table.sort(u38, function(p40, p41) -- Line: 184
                if p40.Currency == "Wen" == (p41.Currency == "Wen") then
                    return p40.Currency < p41.Currency;
                end;

                return p40.Currency == "Wen";
            end);

            local function canCraft(p42: function) -- Line: 190
                -- upvalues: u33 (copy), owned (copy), u10 (copy), u38 (copy), Shop (ref), canPay (copy)
                for i, v in u33 do
                    if owned(p42, i) < v then
                        return false;
                    end;
                end;

                for _, v in u10.keep or {} do
                    if owned(p42, v) < 1 then
                        return false;
                    end;
                end;

                for _, v in u38 do
                    local v43 = Shop.cashiers[v.Currency];

                    if v43 ~= nil and v43.Deferred == true then
                        return false;
                    end;

                    if not canPay(p42, v.Currency, v.Amount) then
                        return false;
                    end;
                end;

                return true;
            end;

            local v44 = #u10.additionalMaterials > 0;
            local u45 = u8:Value(UDim2.new());
            local u46 = false;

            local function noGrab() -- Line: 212
            end;

            local u47 = {
                BgColor = false,
                ContentTransparency = false
            };
            local v48 = u8:Create("Frame");
            local v49 = {
                Name = "Holder",
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = u8:Animation(UDim2.fromScale(1, 1), u1, {
                    From = UDim2_fromScale_ret
                }),
                BackgroundTransparency = 1
            };
            local v50 = u8:Create("Frame")({
                Name = "Header",
                Size = UDim2.fromScale(1, 0.12),
                BackgroundTransparency = 1,
                u8:Create("TextLabel")({
                    Name = "Title",
                    BackgroundTransparency = 1,
                    TextScaled = true,
                    Size = UDim2.fromScale(1, 0.467),
                    Font = Enum.Font.SourceSansBold,
                    Text = u10.result,
                    TextColor3 = Color3.new(1, 1, 1),
                    TextXAlignment = Enum.TextXAlignment.Left
                }),
                u8:Create("TextLabel")({
                    Name = "Rarity",
                    BackgroundTransparency = 1,
                    TextTransparency = 0.15,
                    TextScaled = true,
                    Position = UDim2.fromScale(0, 0.467),
                    Size = UDim2.fromScale(1, 0.455),
                    Font = Enum.Font.SourceSansSemibold,
                    Text = v14,
                    TextColor3 = v15,
                    TextXAlignment = Enum.TextXAlignment.Left
                }),
                u8:Create("Frame")({
                    Name = "Underline",
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.fromScale(0, 1),
                    Size = UDim2.new(0.385, 0, 0, 2),
                    BackgroundColor3 = v12,
                    u8:Create("UIGradient")({
                        Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) })
                    }),
                    u8:Create("UIShadow")({
                        Transparency = 0.6,
                        BlurRadius = UDim.new(1),
                        Color = v12
                    })
                })
            });
            local v51 = u8:Create("Frame");
            local v52 = {
                Name = "Craft",
                Position = UDim2.fromScale(0, 0.145),
                Size = UDim2.fromScale(1, 0.44),
                BackgroundTransparency = 1
            };
            local v62 = u8:Create("Frame")({
                Name = "Required",
                Size = UDim2.fromScale(0.44, 1),
                BackgroundTransparency = 1,
                u8:Create("UIListLayout")({
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDim.new(0.04, 0)
                }),
                u8:Iterate(u10.required, function(p53: any, p54: any, p55: any, p56: userdata?) -- Line: 285
                    -- upvalues: MaterialCard (ref), owned (copy), Refinement (ref), spentLevel (copy), tierOf (copy)
                    local v57;

                    if Refinement.IsRefinable(p54.name) then
                        v57 = spentLevel;
                    else
                        v57 = nil;
                    end;

                    return MaterialCard(p55, p54, owned, v57, tierOf(p54.name));
                end),
                u8:Iterate(u10.keep or {}, function(p58: any, p59: any, p60: any, p61: userdata?) -- Line: 289
                    -- upvalues: MaterialCard (ref), owned (copy)
                    return MaterialCard(p60, {
                        amount = 1,
                        name = p59
                    }, owned, nil);
                end)
            });
            local v63 = u8:Create("Frame")({
                Name = "Connector",
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.fromScale(0.47, 0.5),
                Size = UDim2.new(0.17, -5.656854249492381, 0, 2),
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 0.5,
                u8:Create("UIGradient")({
                    Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.8), NumberSequenceKeypoint.new(1, 0) })
                }),
                u8:Create("Frame")({
                    Name = "Head",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(1, 5.656854249492381, 0.5, 0),
                    Size = UDim2.fromOffset(8, 8),
                    Rotation = 45,
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    BackgroundTransparency = 1,
                    u8:Create("UIStroke")({
                        Thickness = 2,
                        Color = Color3.new(1, 1, 1)
                    })
                })
            });
            local v64 = u8:Create("Frame");
            local v65 = {
                Name = "Result",
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.fromScale(1, 0.5),
                Size = UDim2.fromScale(0.32, 0.9),
                u8:Create("UIAspectRatioConstraint")({}),
                BackgroundColor3 = Color3.new(0.25, 0.25, 0.25),
                BackgroundTransparency = 0.95
            };
            local v66 = u8:Create("UICorner")({
                CornerRadius = UDim.new(0.5, 0)
            });
            local v67 = u8:Create("UIShadow")({
                Transparency = 0.4,
                Color = Color3.new(0.25, 0.25, 0.25),
                BlurRadius = UDim.new(0.4)
            });
            local v68 = u8:Create("Frame")({
                Name = "Bg",
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.5, 0.5),
                Rotation = 45,
                BackgroundColor3 = v12,
                u8:Create("UICorner")({
                    CornerRadius = UDim.new(0.2)
                }),
                u8:Create("UIGradient")({
                    Rotation = -90,
                    Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.6), NumberSequenceKeypoint.new(1, 1) })
                }),
                u8:Create("UIShadow")({
                    BlurRadius = UDim.new(1),
                    Color = v12,
                    Spread = UDim2.fromScale(-0.5, -0.5)
                })
            });
            local v69 = u8:Create("ImageLabel")({
                Name = "Icon",
                BackgroundTransparency = 1,
                ZIndex = 2,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = u8:Animation(UDim2.fromScale(0.85, 0.85), u3, {
                    From = UDim2.fromScale(0.6, 0.6)
                }),
                Image = v11 == nil and "" or (v11.Icon or "")
            });
            local v70;

            if u10.amount > 1 then
                v70 = u8:Create("TextLabel")({
                    Name = "Amount",
                    BackgroundTransparency = 1,
                    TextScaled = true,
                    TextStrokeTransparency = 0.8,
                    ZIndex = 3,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.9),
                    Size = UDim2.fromScale(0.4, 0.15),
                    Font = Enum.Font.SourceSansSemibold,
                    Text = `x{u10.amount}`,
                    TextColor3 = Color3.new(1, 1, 1)
                }) or nil;
            else
                v70 = nil;
            end;

            local v71;

            if u28 == nil then
                v71 = nil;
            else
                v71 = RefineBadge(u8, function(p72) -- Line: 385
                    -- upvalues: u28 (ref), u18 (copy), Crafting (ref), Players (ref), tierOf (copy), u10 (copy), Refinement (ref)
                    local v73 = u28;
                    p72(u18);
                    local v74 = Crafting.SpentCopy(Players.LocalPlayer, v73, tierOf(v73));
                    local v75;

                    if v74 == nil then
                        v75 = nil;
                    else
                        local RefineLevel = v74:FindFirstChild("RefineLevel");
                        v75 = RefineLevel == nil and 0 or RefineLevel.Value;
                    end;

                    if v75 == nil then
                        return nil;
                    end;

                    local math_floor_ret = math.floor(v75 * u10.refineKept);

                    return math.clamp(math_floor_ret, 0, Refinement.MaxLevel);
                end) or nil;
            end;

            local v76;

            if u10.tier == nil then
                v76 = nil;
            else
                v76 = TierBadge(u8, u10.tier) or nil;
            end;

            v65[2], v65[3], v65[4], v65[5], v65[6], v65[7], v65[8] = v66, v67, v68, v69, v70, v71, v76;
            v52[1], v52[2], v52[3] = v62, v63, v64(v65);
            local v77 = v51(v52);
            local v78;

            if v44 then
                v78 = u8:Create("Frame")({
                    Name = "Additional",
                    Position = UDim2.fromScale(0, 0.6),
                    Size = UDim2.fromScale(1, 0.26),
                    BackgroundTransparency = 1,
                    u8:Create("TextLabel")({
                        Name = "Label",
                        BackgroundTransparency = 1,
                        Text = "Additional Materials",
                        TextTransparency = 0.25,
                        TextScaled = true,
                        Size = UDim2.fromScale(1, 0.19),
                        Font = Enum.Font.SourceSansSemibold,
                        TextColor3 = Color3.new(1, 1, 1),
                        TextXAlignment = Enum.TextXAlignment.Left
                    }),
                    u8:Create("CanvasGroup")({
                        Name = "StripMask",
                        AnchorPoint = Vector2.new(0, 1),
                        Position = UDim2.fromScale(0, 1),
                        Size = UDim2.fromScale(1, 0.76),
                        BackgroundTransparency = 1,
                        u8:Create("UIGradient")({
                            Transparency = NumberSequence.new({
                                NumberSequenceKeypoint.new(0, 1),
                                NumberSequenceKeypoint.new(0.02, 0),
                                NumberSequenceKeypoint.new(0.8, 0),
                                NumberSequenceKeypoint.new(1, 1)
                            })
                        }),
                        u8:Create("ScrollingFrame")({
                            Name = "Strip",
                            Size = UDim2.fromScale(1, 1),
                            BackgroundTransparency = 1,
                            ScrollBarThickness = 0,
                            ScrollingDirection = Enum.ScrollingDirection.X,
                            CanvasSize = u45,
                            u8:Create("UIListLayout")({
                                FillDirection = Enum.FillDirection.Horizontal,
                                VerticalAlignment = Enum.VerticalAlignment.Center,
                                Padding = UDim.new(0, 4),

                                AbsoluteContentSizeOnChangedInit = function(p79: userdata, p80) -- Line: 443, Name: AbsoluteContentSizeOnChangedInit
                                    -- upvalues: u45 (copy), u6 (ref)
                                    u45:Set(UDim2.new(0, p80.X * 1.2 / u6(), 0, 0));
                                end
                            }),
                            u8:Iterate(u10.additionalMaterials, function(p81: any, p82: any, p83: any, p84: userdata?) -- Line: 447
                                -- upvalues: MaterialTile (ref), owned (copy)
                                return MaterialTile(p83, p82, owned);
                            end)
                        })
                    })
                }) or nil;
            else
                v78 = nil;
            end;

            v49[1], v49[2], v49[3], v49[4] = v50, v77, v78, u8:Create("Frame")({
    Name = "Footer",
    AnchorPoint = Vector2.new(0, 1),
    Position = UDim2.fromScale(0, 1),
    Size = UDim2.fromScale(1, 0.1),
    BackgroundTransparency = 1,
    u8:Create("Frame")({
        Name = "Cost",
        Size = UDim2.fromScale(0.6, 1),
        BackgroundColor3 = Color3.new(0.1, 0.1, 0.1),
        BackgroundTransparency = 0.5,
        u8:Create("UICorner")({
            CornerRadius = UDim.new(0.3)
        }),
        u8:Create("UIStroke")({
            Transparency = 0.9,
            Color = Color3.new(1, 1, 1),
            BorderOffset = UDim.new(0, -4)
        }),
        u8:Create("UIPadding")({
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10)
        }),
        u8:Create("UIListLayout")({
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10)
        }),
        u8:Create("TextLabel")({
            Name = "Label",
            LayoutOrder = 0,
            BackgroundTransparency = 1,
            TextTransparency = 0.25,
            TextScaled = true,
            Size = UDim2.fromScale(0, 0.5),
            AutomaticSize = Enum.AutomaticSize.X,
            Font = Enum.Font.SourceSansSemibold,
            Text = #u38 > 0 and "Cost" or "Free",
            TextColor3 = Color3.new(1, 1, 1),
            TextXAlignment = Enum.TextXAlignment.Left
        }),
        u8:Iterate(u38, function(p85: any, u86: any, u87: any, p88: userdata?) -- Line: 501
            -- upvalues: Shop (ref), Utility (ref), canPay (copy), Color3_new_ret (ref), Color3_fromRGB_ret (ref), u2 (ref)
            local u89 = Shop.cashiers[u86.Currency];
            local v90;

            if u89 == nil then
                v90 = false;
            else
                v90 = u89.Deferred == true;
            end;

            local v91;

            if u89 == nil or v90 then
                v91 = nil;
            else
                v91 = u89.GetContent(u86.Amount);
            end;

            local u92 = u87:Value(v91);

            if v90 then
                task.spawn(function() -- Line: 509
                    -- upvalues: u89 (copy), u86 (copy), u87 (copy), u92 (copy)
                    local Content = u89.GetContent(u86.Amount);

                    if not u87.IsActive then
                        return;
                    end;

                    u92:Set(Content);
                end);
            end;

            return u87:Create("Frame")({
                Name = u86.Currency,
                LayoutOrder = p85,
                Size = UDim2.fromScale(0, 1),
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                u87:Create("UIListLayout")({
                    FillDirection = Enum.FillDirection.Horizontal,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 3)
                }),
                u87:Create("ImageLabel")({
                    Name = "Icon",
                    LayoutOrder = 1,
                    BackgroundTransparency = 1,
                    Size = UDim2.fromScale(0.55, 0.55),
                    SizeConstraint = Enum.SizeConstraint.RelativeYY,
                    Image = u87:Do(function(p93) -- Line: 537
                        -- upvalues: u92 (copy)
                        local v94 = p93(u92);

                        return v94 ~= nil and v94.Icon or "";
                    end),
                    ScaleType = Enum.ScaleType.Fit
                }),
                u87:Create("TextLabel")({
                    Name = "Amount",
                    LayoutOrder = 2,
                    BackgroundTransparency = 1,
                    RichText = true,
                    TextScaled = true,
                    Size = UDim2.fromScale(0, 0.5),
                    AutomaticSize = Enum.AutomaticSize.X,
                    Font = Enum.Font.SourceSansBold,
                    Text = u87:Do(function(p95) -- Line: 554
                        -- upvalues: u92 (copy), Utility (ref), canPay (ref), u86 (copy)
                        local v96 = p95(u92);

                        if v96 == nil then
                            return "...";
                        end;

                        local v97 = Utility.addCommasToNumber(v96.Price);

                        if canPay(p95, u86.Currency, u86.Amount) then
                            return v97;
                        end;

                        return `<s>{v97}</s>`;
                    end),
                    TextColor3 = u87:Do(function(p98) -- Line: 561
                        -- upvalues: u92 (copy), Color3_new_ret (ref), u87 (copy), canPay (ref), u86 (copy), Color3_fromRGB_ret (ref), u2 (ref)
                        local v99 = p98(u92);
                        local v100 = v99 ~= nil and v99.Color or Color3_new_ret;

                        if not canPay(p98, u86.Currency, u86.Amount) then
                            v100 = Color3_fromRGB_ret;
                        end;

                        return u87:Animation(v100, u2);
                    end),
                    TextXAlignment = Enum.TextXAlignment.Left
                })
            });
        end)
    }),
    u8:Create("Frame")({
        Name = "CraftButton",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.fromScale(1, 0),
        Size = UDim2.new(0.4, -6, 1, 0),
        BackgroundTransparency = 1,
        GradientButton(u8, {
            Text = "Craft",
            GradientRotation = -90,
            StrokeClick = true,
            Font = Enum.Font.SourceSansBold,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextBoxSize = UDim2.fromScale(0.8, 0.55),
            GradientTransparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.4), NumberSequenceKeypoint.new(1, 1) }),
            BgColor = u8:Do(function(p101) -- Line: 595
                -- upvalues: canCraft (copy), Color3_fromRGB_ret2 (ref), Color3_new_ret2 (ref), u47 (copy), u8 (copy), u2 (ref)
                local v102;

                if canCraft(p101) then
                    v102 = Color3_fromRGB_ret2;
                else
                    v102 = Color3_new_ret2;
                end;

                if u47.BgColor then
                    return u8:Animation(v102, u2);
                end;

                u47.BgColor = true;

                return v102;
            end),
            ContentTransparency = u8:Do(function(p103) -- Line: 603
                -- upvalues: canCraft (copy), u47 (copy), u8 (copy), u2 (ref)
                local v104 = canCraft(p103) and 0 or 0.5;

                if u47.ContentTransparency then
                    return u8:Animation(v104, u2);
                end;

                u47.ContentTransparency = true;

                return v104;
            end),
            CornerRadius = UDim.new(0.3),

            Clicked = function() -- Line: 617, Name: Clicked
                -- upvalues: u46 (ref), canCraft (copy), noGrab (copy), PopUpCreator (ref), SignalFunction (ref), u9 (copy), ReplicatedStorage (ref), DebrisModule (ref)
                if u46 or not canCraft(noGrab) then
                    return;
                end;

                u46 = true;
                local v105 = PopUpCreator.new({
                    Type = "LoadingFull"
                });
                local success, result = pcall(SignalFunction.ToServer, "CraftRecipe", u9);
                v105:Destroy();
                u46 = false;

                if success then
                    if typeof(result) == "table" then
                        success = result.Ok == true;
                    else
                        success = false;
                    end;
                end;

                local v106 = ReplicatedStorage.Assets.Sounds.Misc[success and "Money_Kaching" or "denied_old"]:Clone();
                v106.Parent = script;
                v106:Play();
                DebrisModule:AddItem(v106, v106.TimeLength);
            end,

            Properties = {
                Size = UDim2.fromScale(0.9, 1),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5)
            }
        })
    })
});

            return v48(v49);
        end)
    });
end;
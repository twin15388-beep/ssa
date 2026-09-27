-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local faye = require(ReplicatedStorage.Packages.faye);
local PageBrowser = require(ReplicatedStorage.CAM.Client.Components.Misc.PageBrowser);
local Platform_Handler = require(ReplicatedStorage.CAM.Client.Controllers.Platform_Handler);
local ScreenEffects = require(ReplicatedStorage.CAM.Client.Components.Misc.ScreenEffects);
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local VipAccess = require(ReplicatedStorage.CAM.Global.VipAccess);
local PopUpCreator = require(ReplicatedStorage.CAM.Global.Subsets.Classes.PopUpCreator);
local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);
local Menum = require(ReplicatedStorage.CAM.Global.Menum);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local LiveConfig = require(ReplicatedStorage.CAM.Global.LiveConfig);
local ShopSettingsLive = require(ReplicatedStorage.CAM.Global.ShopSettingsLive);
local shopSettings = require(ReplicatedStorage.CAM.Global.shopSettings);
local Shop = require(ReplicatedStorage.CAM.Global.Shop);
require(script.GridContent);
local script_GiftBox = require(script.GiftBox);
local script_Full = require(script.Full);
local script_Half = require(script.Half);
local u1 = faye.Info(0.35);

local function requiresVip(p2: table) -- Line: 33
    for _, v in p2 do
        if typeof(v) == "table" and v.RequiresVIP == true then
            return true;
        end;
    end;

    return false;
end;

local function buildChildren(p3: table) -- Line: 42
    -- upvalues: Shop (copy)
    local v4 = {};

    for i, v in p3 do
        if typeof(v) == "table" and v.Hidden ~= true then
            table.insert(v4, {
                Key = i,
                Entry = v
            });
        end;
    end;

    table.sort(v4, function(p5, p6) -- Line: 50
        local v7 = p5.Entry.Order or (1 / 0);
        local v8 = p6.Entry.Order or (1 / 0);

        if v7 == v8 then
            return p5.Key < p6.Key;
        end;

        return v7 < v8;
    end);
    local v9 = nil;
    local v10 = {};

    for _, v in ipairs(v4) do
        local table_clone_ret = table.clone(v.Entry);
        table_clone_ret.Icon = Shop.cashiers.Product.GetProductIcon(table_clone_ret.ProductId);
        local v11;

        if typeof(table_clone_ret.Duration) == "number" then
            v11 = `{table_clone_ret.Name} ({math.floor(table_clone_ret.Duration / 60 + 0.5)}m)`;
        else
            v11 = table_clone_ret.Name;
        end;

        table_clone_ret.Label = v11;

        if table_clone_ret.Type == 1 then
            table.insert(v10, table_clone_ret);
        elseif v9 == nil then
            v9 = {
                IsSplit = true,
                Content = { table_clone_ret }
            };
        else
            table.insert(v9.Content, table_clone_ret);
            table.insert(v10, v9);
            v9 = nil;
        end;
    end;

    if v9 ~= nil then
        table.insert(v10, v9);
    end;

    return v10;
end;

local function spinsCategory() -- Line: 93
    -- upvalues: Shop (copy), Menum (copy)
    local v12 = {};

    for i, v in Shop.itemsforsale do
        if v.Type == Menum.ShopItemType.Spins then
            local v13;

            if typeof(v.Price) == "table" then
                v13 = v.Price.Product or nil;
            else
                v13 = nil;
            end;

            if v13 ~= nil then
                v12[i] = {
                    Color = "Purple",
                    Name = i,
                    ProductId = v13,
                    ListedPrice = v.ListedPrice,
                    Order = tonumber(v.Spins) or (1 / 0)
                };
            end;
        end;
    end;

    return v12;
end;

local function buildContent() -- Line: 114
    -- upvalues: shopSettings (copy), spinsCategory (copy), buildChildren (copy)
    local v14 = {};

    for i, v in shopSettings do
        if typeof(v) == "table" then
            v14[i] = v;
        end;
    end;

    v14.Spins = spinsCategory();
    local v15 = {};

    for i, v in v14 do
        if #buildChildren(v) > 0 then
            table.insert(v15, i);
        end;
    end;

    table.sort(v15);
    local v16 = {};

    for _, v in ipairs(v15) do
        local v17 = {
            CategoryName = v,
            Children = buildChildren(v14[v])
        };
        local v18 = false;

        for _, v2 in v14[v] do
            if typeof(v2) == "table" and v2.RequiresVIP == true then
                v18 = true;
                break;
            end;
        end;

        v17.RequiresVIP = v18;
        table.insert(v16, v17);
    end;

    return v16;
end;

local v19 = gameSettings.SellRobuxPayout and gameSettings.SellRobuxPayout.Item or "Ore";
local u20 = {
    {
        Name = "Robux",
        Icon = BunchaIcons.Robux
    },
    {
        Name = "Ore",
        Icon = Items[v19] and Items[v19].Icon or "",
        IconColor = Color3.new(1, 1, 1)
    }
};
local u21 = "Robux";
local Vector2_new_ret = Vector2.new(0.3, 0.045);
local u22 = {
    {
        Position = UDim2.fromScale(0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0)
    },
    {
        Position = UDim2.fromScale(0.5, 1),
        AnchorPoint = Vector2.new(0.5, 1)
    }
};

return function(u23: any, p24: userdata) -- Line: 182
    -- upvalues: u21 (ref), Platform_Handler (copy), Vector2_new_ret (copy), Players (copy), VipAccess (copy), ScreenEffects (copy), PopUpCreator (copy), buildContent (copy), LiveConfig (copy), ShopSettingsLive (copy), PageBrowser (copy), u20 (copy), script_GiftBox (copy), u1 (copy), BunchaIcons (copy), script_Half (copy), u22 (copy), script_Full (copy)
    local u25 = u23:Value(u21);
    u23:Connect(u25.Changed, function() -- Line: 185
        -- upvalues: u21 (ref), u25 (copy)
        u21 = u25.Value;
    end);
    local u26 = u23:Value("");
    local u27 = u23:Value("");
    local v28 = Platform_Handler.Platform.Value == "Mobile" and 1.35 or 1;
    local UDim2_fromScale_ret = UDim2.fromScale(Vector2_new_ret.X * v28, Vector2_new_ret.Y * v28);
    local NumberSequence_new_ret = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(0.5, 0.8), NumberSequenceKeypoint.new(1, 1) });
    local u31 = u23:Space(function(p29) -- Line: 209
        -- upvalues: NumberSequence_new_ret (copy)
        local v30 = p29.In:Compare(true) and 1 or 0;

        if p29.State == v30 then
            return;
        end;

        if v30 == 1 then
            p29.BgColor:Set(Color3.new(0.32, 0.32, 0.32));
            p29.ShadowTransparency:Set(0.15);
            p29.StrokeTransparency:Set(0.25);
            p29.StrokeThickness:Set(2);
            p29.GradientTransparency:Set(NumberSequence_new_ret);
            p29.IconSize:Set(UDim2.fromScale(1.3, 1.3));
        else
            p29.BgColor:Reset();
            p29.ShadowTransparency:Reset();
            p29.StrokeTransparency:Reset();
            p29.StrokeThickness:Reset();
            p29.GradientTransparency:Reset();
            p29.IconSize:Reset();
        end;

        p29.State = v30;
    end);
    local LocalPlayer = Players.LocalPlayer;
    local u32 = u23:Value(VipAccess.Has(LocalPlayer));
    u23:Connect(VipAccess.Changed(), function() -- Line: 235
        -- upvalues: u32 (copy), VipAccess (ref), LocalPlayer (copy)
        u32:Set(VipAccess.Has(LocalPlayer));
    end);
    local u33 = false;

    local function promptVip(p34: userdata) -- Line: 241
        -- upvalues: u33 (ref), ScreenEffects (ref), PopUpCreator (ref), VipAccess (ref)
        if u33 then
            return;
        end;

        u33 = true;
        ScreenEffects.StrokeClick(p34.Parent, UDim.new(0.2));
        local v35 = PopUpCreator.new({
            Type = "LoadingFull"
        });
        VipAccess.PromptPurchase();
        v35:Destroy();
        u33 = false;
    end;

    local u36 = u23:Value(UDim2.fromScale(0, 0));
    local u37 = u23:Value(UDim2.fromScale(1, 0));
    local u38 = u23:Value(UDim.new(0, 0));
    local u39 = u23:Value({});

    local function updateContent() -- Line: 270
        -- upvalues: buildContent (ref), u23 (copy), u39 (copy)
        task.spawn(function() -- Line: 271
            -- upvalues: buildContent (ref), u23 (ref), u39 (ref)
            local v40 = buildContent();

            if not u23.IsActive then
                return;
            end;

            u39:Set(v40);
        end);
    end;

    task.spawn(function() -- Line: 271
        -- upvalues: buildContent (ref), u23 (copy), u39 (copy)
        local v41 = buildContent();

        if not u23.IsActive then
            return;
        end;

        u39:Set(v41);
    end);
    u23:Add(LiveConfig.listen(ShopSettingsLive.KEY, updateContent));

    return u23:Create("Frame")({
        Size = u23:Animation(UDim2.fromScale(0.8, 0.8), u23.SpringInfo(0.35, 1, 0.65), {
            From = UDim2.fromScale(0.7200000000000001, 0.7200000000000001)
        }),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Instance.new("UIAspectRatioConstraint"),
        BackgroundTransparency = 1,
        u23:Create("Frame")({
            Name = "CurrencyTypeHolder",
            Size = UDim2.fromScale(0.2, 0.04),
            AnchorPoint = Vector2.new(0, 1),
            Position = UDim2.new(0, 0, 0, -2),
            BackgroundTransparency = 1,
            PageBrowser(u23, u25, u20, {
                IconShadow = true,
                Backdrop = false,

                Key = function(p42, p43) -- Line: 299, Name: Key
                    return p43.Name;
                end,

                Icon = function(p44, p45) -- Line: 300, Name: Icon
                    return p45.Icon;
                end,

                IconColor = function(p46, p47) -- Line: 301, Name: IconColor
                    return p47.IconColor;
                end,

                Size = UDim2.fromScale(1, 1),
                Position = UDim2.fromScale(0, 0),
                TabSize = UDim2.fromScale(1, 1),
                Padding = UDim.new(0, 0),
                TextXAlignment = Enum.TextXAlignment.Left
            })
        }),
        u23:Create("Frame")({
            Name = "GiftHolder",
            Size = UDim2_fromScale_ret,
            AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.new(1, 0, 0, -2),
            BackgroundTransparency = 1,
            ZIndex = 5,
            script_GiftBox(u23, u26, u27)
        }),
        u23:Create("CanvasGroup")({
            Name = "CategoriesGroup",
            Size = UDim2.new(1, 5, 1, 5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            BackgroundTransparency = 1,
            u23:Create("UIGradient")({
                Rotation = 90,
                Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.92, 0), NumberSequenceKeypoint.new(1, 1) })
            }),
            u23:Create("ScrollingFrame")({
                Name = "Categories",
                Size = UDim2.new(1, -20, 1, -20),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                BackgroundTransparency = 1,
                CanvasSize = u36,
                ScrollBarThickness = 0,
                ScrollingDirection = Enum.ScrollingDirection.Y,
                ClipsDescendants = false,

                AbsoluteWindowSizeOnChangedInit = function(p48: userdata, p49) -- Line: 364, Name: AbsoluteWindowSizeOnChangedInit
                    -- upvalues: Platform_Handler (ref), u37 (copy), u38 (copy)
                    u37:Set(UDim2.new(1, 0, 0, p49.Y * (Platform_Handler.Platform.Value == "Mobile" and 0.476 or 0.34)));
                    u38:Set(UDim.new(0, p49.Y * 0.05));
                end,

                u23:Create("UIListLayout")({
                    FillDirection = Enum.FillDirection.Vertical,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = u38,

                    AbsoluteContentSizeOnChangedInit = function(p50: userdata) -- Line: 373, Name: AbsoluteContentSizeOnChangedInit
                        -- upvalues: u36 (copy)
                        u36:Set(UDim2.fromOffset(0, p50.AbsoluteContentSize.Y * 1.2));
                    end
                }),
                u23:Iterate(u39, function(p51, p52, p53) -- Line: 377
                    -- upvalues: u37 (copy), u32 (copy), u1 (ref), promptVip (copy), BunchaIcons (ref), script_Half (ref), u31 (copy), u22 (ref), u25 (copy), u26 (copy), u27 (copy), script_Full (ref)
                    local v54 = p53:Create("Frame");
                    local v55 = {
                        Name = p52.CategoryName,
                        LayoutOrder = p51,
                        Size = u37,
                        BackgroundTransparency = 1
                    };
                    local v56;

                    if p52.RequiresVIP then
                        v56 = p53:State(function(p57: function, p58: any) -- Line: 388
                            -- upvalues: u32 (ref), u1 (ref), promptVip (ref), BunchaIcons (ref)
                            if not p57(u32) then
                                return p58:Create("CanvasGroup")({
                                    Name = "VipCover",
                                    ZIndex = 99,
                                    Size = UDim2.new(1, 4, 1, 4),
                                    AnchorPoint = Vector2.new(0.5, 0.5),
                                    Position = UDim2.fromScale(0.5, 0.5),
                                    BackgroundTransparency = 1,
                                    OnClean = {
                                        GroupTransparency = p58:Animation(1, u1)
                                    },
                                    p58:Create("TextButton")({
                                        ZIndex = 99,
                                        CleanDelay = u1.Time,
                                        MouseButton1Click = promptVip,
                                        BackgroundTransparency = 0.05,
                                        Selectable = true,
                                        AutoButtonColor = false,
                                        Size = UDim2.fromScale(1, 1),
                                        BackgroundColor3 = Color3.new(),
                                        p58:Create("UICorner")({
                                            CornerRadius = UDim.new(0.06)
                                        }),
                                        p58:Create("UIShadow")({
                                            Transparency = 0.15,
                                            BlurRadius = UDim.new(0.6)
                                        }),
                                        p58:Create("UIGradient")({
                                            Rotation = -90,
                                            Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0.5) })
                                        }),
                                        p58:Create("UIListLayout")({
                                            HorizontalAlignment = Enum.HorizontalAlignment.Center,
                                            VerticalAlignment = Enum.VerticalAlignment.Center,
                                            FillDirection = Enum.FillDirection.Vertical
                                        }),
                                        p58:Create("ImageLabel")({
                                            Size = UDim2.fromScale(0.3, 0.3),
                                            Instance.new("UIAspectRatioConstraint"),
                                            BackgroundTransparency = 1,
                                            Image = BunchaIcons.Locked
                                        }),
                                        p58:Create("TextLabel")({
                                            BackgroundTransparency = 1,
                                            Text = "You need VIP to access this (Purchase VIP by clicking me)",
                                            TextScaled = true,
                                            Size = UDim2.new(1, -4, 0.35, 0),
                                            TextColor3 = Color3.new(1, 1, 1),
                                            Font = Enum.Font.SourceSansSemibold
                                        })
                                    })
                                });
                            end;
                        end);
                    else
                        v56 = nil;
                    end;

                    v55[1], v55[2], v55[3] = v56, p53:Create("TextLabel")({
    Name = "Title",
    BackgroundTransparency = 1,
    TextScaled = true,
    Size = UDim2.fromScale(1, 0.09),
    Text = p52.CategoryName,
    TextColor3 = Color3.new(1, 1, 1),
    TextXAlignment = Enum.TextXAlignment.Left,
    Font = Enum.Font.SourceSansSemibold
}), p53:Create("Frame")({
    Name = "Holder",
    Size = UDim2.fromScale(1, 0.91),
    Position = UDim2.fromScale(0, 0.09),
    BackgroundTransparency = 1,
    p53:Create("UIListLayout")({
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 0)
    }),
    p53:Iterate(p52.Children, function(p59, u60, u61) -- Line: 472
        -- upvalues: script_Half (ref), u31 (ref), u22 (ref), u25 (ref), u26 (ref), u27 (ref), script_Full (ref)
        local v62 = u61:Create("Frame");
        local v63 = {
            Name = u60.IsSplit and "Split" or u60.Name,
            LayoutOrder = p59,
            Size = UDim2.fromScale(0.25, 1),
            BackgroundTransparency = 1
        };
        local v64 = u61:Create("UIAspectRatioConstraint")({
            AspectRatio = 0.5
        });
        local v65;

        if u60.IsSplit then
            v65 = function() -- Line: 483
                -- upvalues: u60 (copy), script_Half (ref), u61 (copy), u31 (ref), u22 (ref), u25 (ref), u26 (ref), u27 (ref)
                local v66 = {};

                for i, v in u60.Content do
                    table.insert(v66, script_Half(u61, u31, v, u22[i], u25, u26, u27));
                end;

                return v66;
            end;
        else
            v65 = script_Full(u61, u31, u60, u25, u26, u27);
        end;

        v63[1], v63[2] = v64, v65;

        return v62(v63);
    end)
});

                    return v54(v55);
                end)
            })
        })
    });
end;
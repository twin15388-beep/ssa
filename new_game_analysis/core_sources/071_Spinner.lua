-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local SpinBuyComponent = require(script.Parent.SpinBuyComponent);
local GradientButton = require(ReplicatedStorage.CAM.Client.Components.Misc.Buttons.GradientButton);
local Menum = require(ReplicatedStorage.CAM.Global.Menum);
local Shop = require(ReplicatedStorage.CAM.Global.Shop);
local SpinBalance = require(ReplicatedStorage.CAM.Global.SpinBalance);
local Spinners = require(ReplicatedStorage.CAM.Global.Spinners);
local Clans = require(ReplicatedStorage.CAM.Clans);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local PopUpCreator = require(ReplicatedStorage.CAM.Global.Subsets.Classes.PopUpCreator);
require(ReplicatedStorage.Packages.faye);
local Policies = require(ReplicatedStorage.CAM.Global.Policies);
local LocalPlayer = Players.LocalPlayer;
local Color3_fromRGB_ret = Color3.fromRGB(85, 170, 255);
local u1 = {
    Legendary = true,
    Mythic = true,
    Supreme = true
};
local Color3_fromRGB_ret2 = Color3.fromRGB(150, 150, 155);

return function(u2: any, u3: boolean, u4: any, u5: any) -- Line: 29
    -- upvalues: Shop (copy), Menum (copy), Spinners (copy), Utility (copy), LocalPlayer (copy), SpinBalance (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy), Clans (copy), u1 (copy), PopUpCreator (copy), SpinBuyComponent (copy), Policies (copy), GradientButton (copy), BunchaIcons (copy)
    local v6 = Shop.ListingsOfType(Menum.ShopItemType.Spins, "Spins");
    local u7;

    if u3 then
        u7 = Spinners.Clan.Cost;
    else
        u7 = Spinners.EvilArt.Cost;
    end;

    local Data = Utility.GetData(LocalPlayer, true);
    local Spinning = Data:FindFirstChild("Spinning");
    local u8;

    if u3 then
        u8 = Spinning.FreeClanSpins;
    else
        u8 = Spinning.FreeOtherSpins;
    end;

    local function canAfford(p9) -- Line: 39
        -- upvalues: SpinBalance (ref), Data (copy), u3 (copy), u7 (copy)
        local v10 = 0;

        for _, v in SpinBalance.Values(Data, u3) do
            v10 = v10 + p9(v);
        end;

        return u7 <= v10;
    end;

    local u11 = u2:Value(false);

    local function totalSpins() -- Line: 53
        -- upvalues: SpinBalance (ref), Data (copy), u3 (copy)
        return SpinBalance.Total(Data, u3);
    end;

    local u12 = SpinBalance.Total(Data, u3);
    local u13 = u2:Value(u12);
    local u14 = 0;

    local function UpdValue(p15: number) -- Line: 62
        -- upvalues: u14 (ref), u12 (ref), u13 (copy), SpinBalance (ref), Data (copy), u3 (copy), u2 (copy), UpdValue (copy)
        local math_random_ret = math.random(1, 999);
        u14 = math_random_ret;

        if p15 ~= 0 then
            local math_sign_ret = math.sign(p15);
            local v16 = math.abs(p15) * 0.5;
            local math_floor_ret = math.floor(v16);
            u12 = u12 + math.max(math_floor_ret, 1) * math_sign_ret;
        end;

        u13:Set(u12);

        if u12 ~= SpinBalance.Total(Data, u3) then
            task.delay(0.05, function() -- Line: 71
                -- upvalues: u14 (ref), math_random_ret (copy), u2 (ref), UpdValue (ref), SpinBalance (ref), Data (ref), u3 (ref), u12 (ref)
                if u14 ~= math_random_ret or not u2.IsActive then
                    return;
                end;

                UpdValue(SpinBalance.Total(Data, u3) - u12);
            end);
        end;
    end;

    local function onBalanceChanged() -- Line: 77
        -- upvalues: UpdValue (copy), SpinBalance (ref), Data (copy), u3 (copy), u12 (ref)
        UpdValue(SpinBalance.Total(Data, u3) - u12);
    end;

    for _, v in SpinBalance.Values(Data, u3) do
        u2:Connect(v.Changed, onBalanceChanged);
    end;

    local v19 = u2:Do(function(p17) -- Line: 83
        -- upvalues: SpinBalance (ref), Data (copy), u3 (copy), u7 (copy)
        local v18 = 0;

        for _, v in SpinBalance.Values(Data, u3) do
            v18 = v18 + p17(v);
        end;

        return u7 > v18 and "Insufficient Spins" or `Roll · {u7} {u7 == 1 and "Spin" or "Spins"}`;
    end);
    local v22 = u2:Do(function(p20) -- Line: 86
        -- upvalues: SpinBalance (ref), Data (copy), u3 (copy), u7 (copy), u11 (copy), Color3_fromRGB_ret (ref), Color3_fromRGB_ret2 (ref)
        local v21 = 0;

        for _, v in SpinBalance.Values(Data, u3) do
            v21 = v21 + p20(v);
        end;

        if u7 <= v21 and not p20(u11) then
            return Color3_fromRGB_ret;
        end;

        return Color3_fromRGB_ret2;
    end);

    local function equippedTier() -- Line: 94
        -- upvalues: Utility (ref), LocalPlayer (ref), Clans (ref)
        local Data2 = Utility.GetData(LocalPlayer, true);
        local v23 = Data2 ~= nil and Data2:FindFirstChild("Clan") or nil;
        local v24;

        if v23 == nil then
            v24 = nil;
        else
            v24 = v23.Value or nil;
        end;

        return Clans.TierOf(v24);
    end;

    local u25 = false;

    local function confirmedReroll() -- Line: 107
        -- upvalues: u3 (copy), Utility (ref), LocalPlayer (ref), Clans (ref), u1 (ref), u25 (ref), PopUpCreator (ref)
        if not u3 then
            return true;
        end;

        local Data2 = Utility.GetData(LocalPlayer, true);
        local v26 = Data2 ~= nil and Data2:FindFirstChild("Clan") or nil;
        local v27;

        if v26 == nil then
            v27 = nil;
        else
            v27 = v26.Value or nil;
        end;

        local v28 = Clans.TierOf(v27);

        if v28 == nil or not u1[v28.name] then
            return true;
        end;

        local Clan = Utility.GetData(LocalPlayer, true):FindFirstChild("Clan");
        local v29 = v28.color:ToHex();
        u25 = true;
        local v30 = PopUpCreator.new({
            Type = "Question",
            Content = `You already have <b><font color="#{v29}">{Clan.Value}</font></b>, a <b><font color="#{v29}">{v28.name}</font></b> clan. Rolling replaces it. Are you sure?`
        }):WaitResult();
        u25 = false;

        return v30 == "Yes";
    end;

    local function spin() -- Line: 125
        -- upvalues: u25 (ref), u11 (copy), u3 (copy), LocalPlayer (ref), SpinBalance (ref), Data (copy), u7 (copy), confirmedReroll (copy), PopUpCreator (ref), u2 (copy)
        if u25 or u11.Value == true then
            return;
        end;

        if u3 and LocalPlayer:GetAttribute("PendingClanSpin") ~= nil then
            return;
        end;

        if SpinBalance.Total(Data, u3) < u7 then
            return;
        end;

        u11:Set(true);
        task.spawn(function() -- Line: 134
            -- upvalues: confirmedReroll (ref), u11 (ref), PopUpCreator (ref), u3 (ref), u2 (ref)
            if not confirmedReroll() then
                u11:Set(false);

                return;
            end;

            local u31 = PopUpCreator.new({
                Type = "Spinner",
                IsClan = u3
            });
            local u32 = nil;
            u32 = PopUpCreator.signal:Connect(function(p33: number, p34: any) -- Line: 145
                -- upvalues: u31 (copy), u32 (ref), u11 (ref)
                if p33 ~= u31.id or p34 ~= nil then
                    return;
                end;

                u32:Disconnect();
                u11:Set(false);
            end);
            u2:Add(u32);
        end);
    end;

    local u35 = 0;
    local os_clock_ret = os.clock();

    local function snapToBottom(p36: userdata) -- Line: 159
        -- upvalues: os_clock_ret (copy), u35 (ref)
        if p36.Parent == nil then
            return;
        end;

        if os.clock() - os_clock_ret > 1 and math.abs(p36.CanvasPosition.Y - u35) > 4 then
            return;
        end;

        local math_max_ret = math.max(p36.AbsoluteCanvasSize.Y - p36.AbsoluteWindowSize.Y, 0);
        p36.CanvasPosition = Vector2.new(0, math_max_ret);
        u35 = math_max_ret;
    end;

    local v37 = u2:Create("Frame");
    local v38 = {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Name = "Spinner",
        CleanDelay = u4.Time
    };
    local v39;

    if u3 then
        v39 = nil;
    else
        v39 = u2:Create("Frame")({
            Name = "gradient",
            Size = UDim2.new(1, 4, 1, 4),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            BackgroundColor3 = Color3.new(),
            u2:Create("UICorner")({
                CornerRadius = UDim.new(0.3)
            }),
            u2:Create("UIGradient")({
                Rotation = -90,
                Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(0.5, 1), NumberSequenceKeypoint.new(1, 1) })
            }),
            u2:Create("UIShadow")({
                BlurRadius = UDim.new(1, 0),
                Transparency = u2:Animation(0, u4, {
                    From = 1
                }),

                OnClean = function(p40) -- Line: 196, Name: OnClean
                    -- upvalues: u4 (copy)
                    return {
                        Transparency = p40:Animation(1, u4)
                    };
                end
            })
        }) or nil;
    end;

    local v48 = u2:Create("CanvasGroup")({
        Size = UDim2.fromScale(1, 1.2),
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.fromScale(0.5, 0.55),
        ZIndex = 2,
        BackgroundTransparency = 1,
        u2:Create("UIGradient")({
            Rotation = -90,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.8),
                NumberSequenceKeypoint.new(0.125, 0),
                NumberSequenceKeypoint.new(0.5, 0),
                NumberSequenceKeypoint.new(1, 1)
            })
        }),
        u2:Create("ScrollingFrame")({
            Size = UDim2.fromScale(1, 1),
            ClipsDescendants = false,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 0,
            u2:Create("UIListLayout")({
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Bottom,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 1),

                AbsoluteContentSizeOnChangedInit = function(p41, p42) -- Line: 230, Name: AbsoluteContentSizeOnChangedInit
                    -- upvalues: snapToBottom (copy)
                    local Parent = p41.Parent;
                    Parent.CanvasSize = UDim2.fromOffset(0, p42.Y * 1.2);
                    task.defer(function() -- Line: 238
                        -- upvalues: snapToBottom (ref), Parent (copy)
                        snapToBottom(Parent);
                    end);
                end
            }),

            function(u43) -- Line: 243
                -- upvalues: u2 (copy), snapToBottom (copy)
                u2:Connect(u43:GetPropertyChangedSignal("AbsoluteWindowSize"), function() -- Line: 245
                    -- upvalues: snapToBottom (ref), u43 (copy)
                    task.defer(function() -- Line: 246
                        -- upvalues: snapToBottom (ref), u43 (ref)
                        snapToBottom(u43);
                    end);
                end);
            end,

            u2:Iterate(v6, function(p44: any, p45: any, p46: any, p47: userdata?) -- Line: 251
                -- upvalues: SpinBuyComponent (ref), u5 (copy), u4 (copy)
                return SpinBuyComponent(p46, p45, u5, u4.Time);
            end)
        })
    });
    local v49 = u2:Create("Frame");
    local v50 = {
        Name = "Holder",
        Size = UDim2.new(1, -6, 1, -6),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        BackgroundTransparency = 1
    };
    local v51 = u2:Create("UIListLayout")({
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Bottom
    });
    local v52 = u2:Create("Frame");
    local v53 = {
        Name = "SpinButton",
        Size = UDim2.fromScale(0.7, 0.2),
        BackgroundTransparency = 1
    };
    local v54;

    if Policies.CanSpin then
        v54 = GradientButton(u2, {
            GradientRotation = -90,
            Text = v19,
            BgColor = v22,
            Clicked = spin,
            TextXAlignment = Enum.TextXAlignment.Center,
            Properties = {
                AnchorPoint = Vector2.new(0.5, 0),
                Position = UDim2.fromScale(0.5, 0)
            },
            GradientTransparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0.5) })
        });
    else
        v54 = u2:Create("TextLabel")({
            BackgroundTransparency = 1,
            Text = "Roblox disabled rolling for you",
            TextScaled = true,
            Size = UDim2.fromScale(1.3, 1),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.35),
            TextColor3 = Color3.new(1, 1, 1),
            Font = Enum.Font.SourceSansSemibold
        });
    end;

    v53[1] = v54;
    v50[1], v50[2], v50[3] = v51, v52(v53), u2:Create("Frame")({
    Name = "AATitleHolder",
    Size = UDim2.fromScale(1, 0.2),
    BackgroundTransparency = 1,
    u2:Create("TextLabel")({
        Size = UDim2.fromScale(1, 0.8),
        BackgroundTransparency = 1,
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.SourceSans,
        TextScaled = true,
        RichText = true,
        u2:Create("UIStroke")({
            Transparency = 0.8
        }),
        u2:Create("UIShadow")({
            BlurRadius = UDim.new(1, 0),
            Transparency = u2:Animation(0.4, u4, {
                From = 1
            }),

            OnClean = function(p55) -- Line: 316, Name: OnClean
                -- upvalues: u4 (copy)
                return {
                    Transparency = p55:Animation(1, u4)
                };
            end
        }),
        Text = u2:Do(function(p56: function, p57: any, p58: userdata?) -- Line: 321
            -- upvalues: u8 (copy), u13 (copy)
            local v59 = p56(u8);

            return `<b>{p56(u13)} Spins</b> {v59 > 0 and `<font transparency=".5">( {v59} Free )</font>` or ""}`;
        end),

        function(u60: userdata) -- Line: 330
            -- upvalues: BunchaIcons (ref), u2 (copy)
            local ImageLabel = Instance.new("ImageLabel");
            ImageLabel.Name = "SpinsIcon";
            ImageLabel.BackgroundTransparency = 1;
            ImageLabel.Image = BunchaIcons.SpinsIcon;
            ImageLabel.AnchorPoint = Vector2.new(1, 0.5);
            ImageLabel.Parent = u60;

            local function place() -- Line: 337
                -- upvalues: u60 (copy), ImageLabel (copy)
                local math_floor_ret = math.floor(u60.AbsoluteSize.Y * 0.9);
                ImageLabel.Size = UDim2.fromOffset(math_floor_ret, math_floor_ret);
                ImageLabel.Position = UDim2.new(0.5, -math.ceil(u60.TextBounds.X / 2) - 3, 0.5, 0);
            end;

            u2:Connect(u60:GetPropertyChangedSignal("TextBounds"), place);
            u2:Connect(u60:GetPropertyChangedSignal("AbsoluteSize"), place);
            task.defer(place);
        end
    })
});
    v38[1], v38[2], v38[3] = v39, v48, v49(v50);

    return v37(v38);
end;
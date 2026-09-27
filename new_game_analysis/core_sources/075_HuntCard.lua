-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local ScreenEffects = require(ReplicatedStorage.CAM.Client.Components.Misc.ScreenEffects);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local BossHunts = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests.BossHunts);
local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local RewardsStyling = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests.RewardsStyling);
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local Rarities = require(ReplicatedStorage.CAM.Global.Rarities);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local Multipliers = require(ReplicatedStorage.CAM.Global.Multipliers);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
require(ReplicatedStorage.Packages.faye);
local Transition = require(script.Parent.Transition);
require(script.Parent.Types);
local Info = Transition.Info;
local Color3_new_ret = Color3.new(1, 1, 1);
local Color3_new_ret2 = Color3.new(0.5, 0.5, 0.5);
local u1 = {
    Common = 0.97,
    UnCommon = 0.95,
    Rare = 0.92,
    Epic = 0.88,
    Legendary = 0.82,
    Mythic = 0.74
};
local u2 = {
    Muzan = BunchaIcons.MuzanIcon,
    Crow = BunchaIcons.CrowIcon
};

local function loadRegions() -- Line: 73
    -- upvalues: ReplicatedStorage (copy)
    return require(ReplicatedStorage.Regions);
end;

local function loadDialogues() -- Line: 79
    -- upvalues: ReplicatedStorage (copy)
    return require(ReplicatedStorage.CAM.Client.Modules.GamePlay.Dialogue);
end;

local function playerRace() -- Line: 83
    -- upvalues: ReplicatedStorage (copy), LocalPlayer (copy)
    local Data = require(ReplicatedStorage.CAM.Global.Utility).GetData(LocalPlayer);

    return Data ~= nil and Data.Race.Value or nil;
end;

local function bossIcon(p3) -- Line: 91
    -- upvalues: ReplicatedStorage (copy), u2 (copy)
    return require(ReplicatedStorage.Regions).GetNpcIcon(p3.Boss) or u2[p3.Side];
end;

local function rewardsOf(p4) -- Line: 98
    -- upvalues: ReplicatedStorage (copy), Quests (copy), BossHunts (copy), LocalPlayer (copy), RewardsStyling (copy), BunchaIcons (copy), Multipliers (copy), Items (copy)
    require(ReplicatedStorage.Regions);
    local QuestInfo = Quests.GetQuestInfo(p4.Quest);
    local v5 = BossHunts.Entry(p4.Boss);
    local v6 = QuestInfo ~= nil and QuestInfo.Rewards or (v5 == nil and {} or (BossHunts.Rewards(v5) or {}));
    local v7 = v5 == nil and 1 or BossHunts.Factor(v5);
    local v8 = {};
    local v9 = QuestInfo ~= nil and QuestInfo.MaxLevelMastery or (v5 ~= nil and BossHunts.MaxLevelMastery(v5) or nil);

    if v9 == nil or not Quests.AtLevelCap(LocalPlayer) then
        if v6.Exp ~= nil then
            local v10 = {
                Icon = BunchaIcons.Exp
            };
            local v11 = v6.Exp * v7 * Multipliers.ExpGain(nil, "Quest");
            v10.Amount = math.floor(v11);
            v10.Tag = Multipliers.ExpGainTag(nil, "Quest");
            table.insert(v8, v10);
        end;
    else
        local v12 = {
            Icon = RewardsStyling.GetIconAndColor("FlatMastery"),
            Amount = v9 * v7
        };
        table.insert(v8, v12);
    end;

    if v6.Wen ~= nil then
        local v13 = {
            Icon = BunchaIcons.Wen
        };
        local v14 = v6.Wen * v7 * Multipliers.WenGain(nil, "Quest");
        v13.Amount = math.floor(v14);
        v13.Tag = Multipliers.WenGainTag(nil, "Quest");
        table.insert(v8, v13);
    end;

    for i, v in v6 do
        local v15 = Items[i];

        if v15 ~= nil and (typeof(v) == "table" and v.Quantity ~= nil) then
            table.insert(v8, {
                Icon = v15.Icon,
                Amount = v.Quantity
            });
        end;
    end;

    return v8;
end;

return function(p16: any, u17: any, u18: string, u19: table, p20: any) -- Line: 135
    -- upvalues: Utility (copy), Rarities (copy), Color3_new_ret (copy), u1 (copy), BossHunts (copy), LocalPlayer (copy), gameSettings (copy), rewardsOf (copy), Info (copy), Transition (copy), ReplicatedStorage (copy), u2 (copy), Color3_new_ret2 (copy), ScreenEffects (copy), Quests (copy), SignalEvent (copy), BunchaIcons (copy)
    local function remaining() -- Line: 138
        -- upvalues: u17 (copy)
        local v21 = u17.ExpiresAt - workspace:GetServerTimeNow();

        return math.max(0, v21);
    end;

    local formatTime = Utility.formatTime;
    local v22 = u17.ExpiresAt - workspace:GetServerTimeNow();
    local u23 = p16:Value(formatTime((math.max(0, v22))));
    p16:Spawn(function() -- Line: 142
        -- upvalues: u23 (copy), Utility (ref), u17 (copy)
        while true do
            task.wait(0.25);
            local formatTime2 = Utility.formatTime;
            local v24 = u17.ExpiresAt - workspace:GetServerTimeNow();
            u23:Set(formatTime2((math.max(0, v24))));
        end;
    end);
    local v25 = Rarities.Colors[table.find(Rarities.Order, u17.Tier)] or Color3_new_ret;
    local u26 = u1[u17.Tier] or 0.97;
    local u27 = BossHunts.Entry(u17.Boss);
    local Data = Utility.GetData(LocalPlayer);
    local u28;

    if Data == nil then
        u28 = nil;
    else
        u28 = Data.Exp.Goal or nil;
    end;

    local function lockedBecause() -- Line: 158
        -- upvalues: u28 (copy), u27 (copy), gameSettings (ref)
        if u28 == nil or u27 == nil then
            return "";
        end;

        local v29 = u28.Value / gameSettings.expPerLevel;

        if v29 < u27.MinLevel then
            return `Min level is {u27.MinLevel}`;
        end;

        return (u27.MaxLevel == nil or u27.MaxLevel >= v29) and "" or `Max level is {u27.MaxLevel}`;
    end;

    local v30;

    if u28 == nil or u27 == nil then
        v30 = "";
    else
        local v31 = u28.Value / gameSettings.expPerLevel;

        if v31 < u27.MinLevel then
            v30 = `Min level is {u27.MinLevel}`;
        else
            v30 = (u27.MaxLevel == nil or u27.MaxLevel >= v31) and "" or `Max level is {u27.MaxLevel}`;
        end;
    end;

    local u32 = p16:Value(v30);

    if u28 ~= nil then
        p16:Connect(u28.Changed, function() -- Line: 171
            -- upvalues: u32 (copy), u28 (copy), u27 (copy), gameSettings (ref)
            local v33;

            if u28 == nil or u27 == nil then
                v33 = "";
            else
                local v34 = u28.Value / gameSettings.expPerLevel;

                if v34 < u27.MinLevel then
                    v33 = `Min level is {u27.MinLevel}`;
                else
                    v33 = (u27.MaxLevel == nil or u27.MaxLevel >= v34) and "" or `Max level is {u27.MaxLevel}`;
                end;
            end;

            u32:Set(v33);
        end);
    end;

    local u35 = rewardsOf(u17);
    local u36 = {};
    local u37 = {};
    local Vector2_zero = Vector2.zero;
    local u38 = 0.8;

    local function refitRewards() -- Line: 185
        -- upvalues: Vector2_zero (ref), u35 (copy), u36 (copy), u37 (copy), u38 (ref)
        if Vector2_zero.X <= 0 or Vector2_zero.Y <= 0 then
            return;
        end;

        local v39 = 0;

        for i in u35 do
            local v40 = u36[i];

            if v40 == nil or u37[i] == nil then
                return;
            end;

            v39 = v39 + (v40 + 1);
        end;

        local v41 = math.max(#u35 - 1, 0) * 4 + #u35 * 3;
        local math_clamp_ret = math.clamp((Vector2_zero.X * 0.97 - v41) / (Vector2_zero.Y * v39), 0, 0.8);

        if math.abs(math_clamp_ret - u38) > 0.02 then
            u38 = math_clamp_ret;
        end;

        local v42 = u38 * Vector2_zero.Y;

        for i, v in u37 do
            v:Set(UDim2.fromScale((v42 * (u36[i] + 1) + 3) / Vector2_zero.X, u38));
        end;
    end;

    local u43 = false;
    local u44 = p16:Value(0.35);
    local u45 = p16:Value(0.25);
    local u46 = p16:Value(u26);

    local function applyEmphasis(p47: boolean) -- Line: 214
        -- upvalues: u44 (copy), u45 (copy), u46 (copy), u26 (copy)
        if p47 then
            u44:Set(0.1);
            u45:Set(0);
            u46:Set((math.max(u26 - 0.15, 0)));

            return;
        end;

        u44:Reset();
        u45:Reset();
        u46:Reset();
    end;

    local v48 = p16:Create("Frame");
    local v49 = {
        Name = `Hunt{u17.Id}`,
        Size = p20,
        BackgroundColor3 = Color3.new(0.065, 0.065, 0.065),
        BackgroundTransparency = p16:Animation(u44, Info, {
            From = 1
        }),
        OnClean = Transition.FadeOutOnClean()
    };
    local v50 = p16:Create("UICorner")({
        CornerRadius = UDim.new(0.25)
    });
    local v51 = p16:Create("Frame")({
        Name = "Glow",
        ZIndex = -1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, -4, 1, -4),
        BackgroundColor3 = v25,
        BackgroundTransparency = 0.95,
        p16:Create("UICorner")({
            CornerRadius = UDim.new(0.25)
        }),
        p16:Create("UIShadow")({
            BlurRadius = UDim.new(0.8),
            Color = v25,
            Transparency = p16:Animation(u46, Info, {
                From = 1
            })
        })
    });
    local v52 = p16:Create("Frame");
    local v53 = {
        Name = "Content",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1
    };
    local v54 = p16:Create("UIPadding")({
        PaddingLeft = UDim.new(0.01, 0),
        PaddingRight = UDim.new(0.015, 0),
        PaddingTop = UDim.new(0.03, 0),
        PaddingBottom = UDim.new(0.03, 0)
    });
    local v55 = p16:Create("Frame")({
        Name = "Portrait",
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.fromScale(0, 0.5),
        Size = UDim2.fromScale(1, 0.72),
        BackgroundTransparency = 1,
        p16:Create("UIAspectRatioConstraint")({}),
        p16:Create("ImageLabel")({
            Name = "Boss",
            ZIndex = 5,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Image = require(ReplicatedStorage.Regions).GetNpcIcon(u17.Boss) or u2[u17.Side],
            ImageTransparency = p16:Animation(u45, Info, {
                From = 1
            })
        }),
        p16:Create("Frame")({
            Name = "Bg",
            ZIndex = -1,
            Size = UDim2.fromScale(0.8, 0.8),
            Instance.new("UIAspectRatioConstraint"),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Rotation = 45,
            BackgroundTransparency = 0.7,
            BackgroundColor3 = v25,
            p16:Create("UICorner")({
                CornerRadius = UDim.new(0.2)
            }),
            p16:Create("UIGradient")({
                Rotation = -90,
                Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0.8) })
            }),
            p16:Create("UIShadow")({
                Transparency = 0.8,
                BlurRadius = UDim.new(1),
                Color = v25
            })
        })
    });
    local v56 = p16:Create("TextLabel");
    local v57 = {
        Name = "Quest",
        BackgroundTransparency = 1,
        TextScaled = true,
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.fromScale(0.21, 0.5),
        Size = UDim2.fromScale(0.53, 0.5)
    };
    local Title = BossHunts.Title;
    local Boss = u17.Boss;
    local Data2 = require(ReplicatedStorage.CAM.Global.Utility).GetData(LocalPlayer);
    local v58;

    if Data2 == nil then
        v58 = nil;
    else
        v58 = Data2.Race.Value or nil;
    end;

    v57.Text = Title(Boss, v58);
    v57.TextXAlignment = Enum.TextXAlignment.Left;
    v57.TextYAlignment = Enum.TextYAlignment.Bottom;
    v57.TextColor3 = Color3_new_ret;
    v57.TextTransparency = p16:Animation(u45, Info, {
        From = 1
    });
    v57.Font = Enum.Font.SourceSansBold;
    v53[1], v53[2], v53[3], v53[4], v53[5] = v54, v55, v56(v57), p16:Create("Frame")({
    Name = "Rewards",
    AnchorPoint = Vector2.new(0, 0),
    Position = UDim2.fromScale(0.19, 0.5),
    Size = UDim2.fromScale(0.55, 0.5),
    BackgroundTransparency = 1,

    AbsoluteSizeOnChangedInit = function(p59: userdata) -- Line: 346, Name: AbsoluteSizeOnChangedInit
        -- upvalues: Vector2_zero (ref), refitRewards (copy)
        Vector2_zero = p59.AbsoluteSize;
        refitRewards();
    end,

    p16:Create("UIListLayout")({
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4)
    }),
    p16:Iterate(u35, function(u60: number, p61: any, p62: any) -- Line: 359
        -- upvalues: u35 (copy), u37 (copy), u45 (copy), Info (ref), Utility (ref), Color3_new_ret (ref), u36 (copy), refitRewards (copy)
        local v63 = p62:Value(UDim2.fromScale(1 / math.max(#u35, 1), 0.8));
        u37[u60] = v63;

        return p62:Create("Frame")({
            Name = `Reward{u60}`,
            LayoutOrder = u60,
            Size = v63,
            BackgroundTransparency = 1,
            p62:Create("UIListLayout")({
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                FillDirection = Enum.FillDirection.Horizontal,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 3)
            }),
            p62:Create("ImageLabel")({
                Name = "Icon",
                LayoutOrder = 1,
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Image = p61.Icon,
                ImageTransparency = p62:Animation(u45, Info, {
                    From = 1
                }),
                p62:Create("UIAspectRatioConstraint")({
                    DominantAxis = Enum.DominantAxis.Height
                })
            }),
            p62:Create("TextLabel")({
                Name = "Amount",
                LayoutOrder = 2,
                BackgroundTransparency = 1,
                TextScaled = true,
                TextWrapped = false,
                Size = UDim2.fromScale(50, 1),
                Text = Utility.addCommasToNumber(p61.Amount) .. (p61.Tag == nil and "" or ` ({p61.Tag})`),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextColor3 = Color3_new_ret,
                TextTransparency = p62:Animation(u45, Info, {
                    From = 1
                }),
                Font = Enum.Font.SourceSansSemibold,

                TextBoundsOnChangedInit = function(p64: userdata) -- Line: 403, Name: TextBoundsOnChangedInit
                    -- upvalues: u36 (ref), u60 (copy), refitRewards (ref)
                    local TextBounds = p64.TextBounds;

                    if TextBounds.X <= 0 or TextBounds.Y <= 0 then
                        return;
                    end;

                    u36[u60] = TextBounds.X / TextBounds.Y;
                    refitRewards();
                end
            })
        });
    end)
}), p16:Create("Frame")({
    Name = "Clock",
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.fromScale(1, 0.5),
    Size = UDim2.fromScale(0.21, 0.55),
    BackgroundColor3 = Color3_new_ret2,
    BackgroundTransparency = p16:Animation(0.85, Info, {
        From = 1
    }),
    p16:Create("UICorner")({
        CornerRadius = UDim.new(0, 6)
    }),
    p16:Create("UIPadding")({
        PaddingLeft = UDim.new(0.06, 0),
        PaddingRight = UDim.new(0.06, 0),
        PaddingTop = UDim.new(0.06, 0),
        PaddingBottom = UDim.new(0.06, 0)
    }),
    p16:Create("TextLabel")({
        Name = "Value",
        BackgroundTransparency = 1,
        TextScaled = true,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 0.7),
        Text = u23,
        TextColor3 = Color3_new_ret,
        TextTransparency = p16:Animation(u45, Info, {
            From = 1
        }),
        Font = Enum.Font.SourceSansSemibold
    })
});
    v49[1], v49[2], v49[3], v49[4], v49[5] = v50, v51, v52(v53), p16:Create("TextButton")({
    Name = "Claim",
    ZIndex = 3,
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1),

    MouseButton1Click = function() -- Line: 452, Name: MouseButton1Click
        -- upvalues: ScreenEffects (ref), Quests (ref), LocalPlayer (ref), u17 (copy), u19 (copy), ReplicatedStorage (ref), u18 (copy), SignalEvent (ref)
        ScreenEffects.CircleClick();
        local v65, v66, v67 = Quests.CanAddQuest(LocalPlayer, u17.Quest);

        if v65 then
            SignalEvent.ToServer("BossHuntsRequest", {
                action = "Claim",
                id = u17.Id
            });

            return;
        end;

        u19.HuntDenial = {
            Reason = v66,
            Blocking = v67
        };
        require(ReplicatedStorage.CAM.Client.Modules.GamePlay.Dialogue).AttemptDialogue:Fire(u18);
    end,

    MouseEnter = function() -- Line: 467, Name: MouseEnter
        -- upvalues: u43 (ref), u44 (copy), u45 (copy), u46 (copy), u26 (copy)
        if u43 then
            return;
        end;

        u43 = true;
        u44:Set(0.1);
        u45:Set(0);
        u46:Set((math.max(u26 - 0.15, 0)));
    end,

    MouseLeave = function() -- Line: 472, Name: MouseLeave
        -- upvalues: u43 (ref), u44 (copy), u45 (copy), u46 (copy)
        if not u43 then
            return;
        end;

        u43 = false;
        u44:Reset();
        u45:Reset();
        u46:Reset();
    end
}), p16:State(function(p68, p69) -- Line: 481
    -- upvalues: u32 (copy), Info (ref), BunchaIcons (ref), Color3_new_ret (ref)
    local v70 = p68(u32);

    if v70 ~= "" then
        return p69:Create("CanvasGroup")({
            Name = "LevelCover",
            ZIndex = 10,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            GroupTransparency = p69:Animation(0, Info, {
                From = 1
            }),
            OnClean = {
                GroupTransparency = p69:Animation(1, Info)
            },
            p69:Create("TextButton")({
                Name = "Plate",
                CleanDelay = Info.Time,
                Size = UDim2.fromScale(1, 1),
                Text = "",
                AutoButtonColor = false,
                BackgroundColor3 = Color3.new(),
                BackgroundTransparency = 0.25,
                p69:Create("UICorner")({
                    CornerRadius = UDim.new(0.25)
                }),
                p69:Create("UIListLayout")({
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 6)
                }),
                p69:Create("ImageLabel")({
                    Name = "Lock",
                    LayoutOrder = 1,
                    Size = UDim2.fromScale(0.34, 0.34),
                    BackgroundTransparency = 1,
                    Image = BunchaIcons.Locked,
                    p69:Create("UIAspectRatioConstraint")({})
                }),
                p69:Create("TextLabel")({
                    Name = "Reason",
                    LayoutOrder = 2,
                    BackgroundTransparency = 1,
                    TextScaled = true,
                    TextWrapped = false,
                    Size = UDim2.fromScale(0.46, 0.3),
                    Text = v70,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextColor3 = Color3_new_ret,
                    Font = Enum.Font.SourceSansBold
                })
            })
        });
    end;
end);

    return v48(v49);
end;
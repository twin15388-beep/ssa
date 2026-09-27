-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TaskComponent = require(script.Parent.TaskComponent);
local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local RewardsStyling = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests.RewardsStyling);
local Resolve = require(ReplicatedStorage.CAM.Global.Powers.Resolve);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local Multipliers = require(ReplicatedStorage.CAM.Global.Multipliers);
local GradientButton = require(ReplicatedStorage.CAM.Client.Components.Misc.Buttons.GradientButton);
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local PopUpCreator = require(ReplicatedStorage.CAM.Global.Subsets.Classes.PopUpCreator);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local faye = require(ReplicatedStorage.Packages.faye);
require(ReplicatedStorage.Packages.faye);
local u1 = faye.Info(0.2);
local u2 = {};

for _, child in script.Parent.Events:GetChildren() do
    if child:IsA("ModuleScript") then
        u2[child.Name] = require(child);
    end;
end;

local u3 = {};
local u4 = false;
local u5 = faye.Info(0.2);

function addToTimerTracker(p6: any, p7: table)
    -- upvalues: u3 (copy), u4 (ref)
    p6.vting = p7;
    table.insert(u3, p6);

    if not u4 then
        u4 = true;
        task.spawn(function() -- Line: 42
            -- upvalues: u3 (ref), u4 (ref)
            while #u3 > 0 do
                for _, v in ipairs(u3) do
                    local Value = v.vting.Started.Value;
                    local Value2 = v.vting.Target.Value;

                    if Value ~= 0 then
                        Value2 = Value + Value2 - os.time();
                    end;

                    v:Set(Value2);
                end;

                task.wait(1);
            end;

            u4 = false;
        end);
    end;
end;

function removeFromTimerTracker(p8)
    -- upvalues: u3 (copy)
    local table_find_ret = table.find(u3, p8);

    if table_find_ret ~= nil then
        table.remove(u3, table_find_ret);
    end;
end;

return function(u9: any, p10: string, u11: userdata, u12: number) -- Line: 64
    -- upvalues: Quests (copy), u5 (copy), u2 (copy), BunchaIcons (copy), GradientButton (copy), PopUpCreator (copy), gameSettings (copy), SignalEvent (copy), u1 (copy), ReplicatedStorage (copy), Utility (copy), TaskComponent (copy), RewardsStyling (copy), Resolve (copy), Items (copy), Multipliers (copy)
    local v13 = u11:FindFirstChild("QuestString") or u11:WaitForChild("QuestString", 5);
    local u14 = Quests.Holder[v13 ~= nil and v13.Value or u11.Name];
    local u15 = u9:Value();
    local u16 = u9:Value();
    local u17 = u9:Value(false);

    local function hookTimer(p18: userdata?) -- Line: 78
        -- upvalues: u16 (copy), u17 (copy)
        removeFromTimerTracker(u16);

        if p18 ~= nil then
            addToTimerTracker(u16, p18);
        end;

        u17:Set(p18 ~= nil);
    end;

    local Timer = u11:FindFirstChild("Timer");
    removeFromTimerTracker(u16);

    if Timer ~= nil then
        addToTimerTracker(u16, Timer);
    end;

    u17:Set(Timer ~= nil);
    u9:Connect(u11.ChildAdded, function(p19) -- Line: 86
        -- upvalues: u16 (copy), u17 (copy)
        if p19.Name == "Timer" then
            removeFromTimerTracker(u16);

            if p19 ~= nil then
                addToTimerTracker(u16, p19);
            end;

            u17:Set(p19 ~= nil);
        end;
    end);
    u9:Connect(u11.ChildRemoved, function(p20) -- Line: 91
        -- upvalues: u11 (copy), u16 (copy), u17 (copy)
        if p20.Name == "Timer" then
            local Timer2 = u11:FindFirstChild("Timer");
            removeFromTimerTracker(u16);

            if Timer2 ~= nil then
                addToTimerTracker(u16, Timer2);
            end;

            u17:Set(Timer2 ~= nil);
        end;
    end);
    u9:Add(function() -- Line: 96
        -- upvalues: u16 (copy)
        removeFromTimerTracker(u16);
    end);

    local function updProg() -- Line: 99
        -- upvalues: u11 (copy), u15 (copy)
        local v21 = 0;
        local v22 = 0;

        for _, child in ipairs(u11.Tasks:GetChildren()) do
            if child.Value.Value == child.Max.Value then
                v21 = v21 + 1;
            end;

            v22 = v22 + 1;
        end;

        u15:Set((`{v21}/{v22}`));
    end;

    updProg();
    local u23 = u9:Value(Color3.new(1, 0.1, 0.1));
    local u24 = false;
    local u25 = false;
    local math_min_ret = math.min(u12 * 0.2, 30);
    local math_min_ret2 = math.min(u12 * 0.1575);
    local math_min_ret3 = math.min(26, u12 * 0.1595);
    local u26 = u9:Value(UDim2.new(0, 50, 0, math_min_ret2));

    return u9:Create("Frame")({
        Size = UDim2.new(1, 0, 0, 200),
        BackgroundTransparency = 1,
        LayoutOrder = u14 == nil and -1 or (u14.Priority or -1),
        Name = u11.Name,
        CleanDelay = u5.Time,

        OnClean = function(p27, p28) -- Line: 139, Name: OnClean
            -- upvalues: u5 (ref)
            for _, descendant in ipairs(p28:GetDescendants()) do
                if descendant:IsA("GuiObject") then
                    p27:LoadAnimation(descendant, {
                        BackgroundTransparency = 1
                    }, u5):Play();
                end;

                if descendant:IsA("TextLabel") or (descendant:IsA("TextButton") or descendant:IsA("TextBox")) then
                    p27:LoadAnimation(descendant, {
                        TextTransparency = 1,
                        TextStrokeTransparency = 1
                    }, u5):Play();
                end;

                if descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
                    p27:LoadAnimation(descendant, {
                        ImageTransparency = 1
                    }, u5):Play();
                end;

                if descendant:IsA("UIStroke") then
                    p27:LoadAnimation(descendant, {
                        Transparency = 1
                    }, u5):Play();
                end;
            end;
        end,

        u9:Create("UIListLayout")({
            Name = "List",
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            VerticalAlignment = Enum.VerticalAlignment.Top,
            SortOrder = Enum.SortOrder.Name,
            FillDirection = Enum.FillDirection.Vertical,
            Padding = UDim.new(0, 5),

            [u9:GetSignal("GetPropertyChangedSignal", "AbsoluteContentSize", true)] = function(p29) -- Line: 162
                p29.Parent.Size = UDim2.new(1, 0, 0, p29.AbsoluteContentSize.Y);
            end
        }),

        function() -- Line: 169
            -- upvalues: u14 (copy), u2 (ref), u9 (copy), u11 (copy), u12 (copy)
            local v30 = u14 ~= nil and u14.Event or nil;

            if v30 == nil then
                return nil;
            end;

            local v31 = u2[v30];

            if v31 == nil then
                return nil;
            end;

            return v31(u9, u11, u14, u12);
        end,

        u9:Create("Frame")({
            Name = "aTitle",
            LayoutOrder = 1,
            Size = UDim2.new(1, 0, 0, math_min_ret),
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 0),
            u9:Create("Frame")({
                Name = "Underline",
                ZIndex = 2,
                BackgroundTransparency = 0.55,
                Size = UDim2.new(1, 0, 0, 1),
                Position = UDim2.fromScale(0, 1)
            }),
            u9:Create("Frame")({
                Name = "Bg",
                Size = UDim2.fromScale(1, 1),
                ZIndex = -1,
                BackgroundColor3 = Color3.new(),
                Position = UDim2.fromScale(0, 0),
                BackgroundTransparency = 0.65,
                u9:Create("UICorner")({
                    CornerRadius = UDim.new(0.15)
                }),
                u9:Create("UIGradient")({
                    Rotation = -90,
                    Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 0),
                        NumberSequenceKeypoint.new(0.15, 0.45),
                        NumberSequenceKeypoint.new(0.25, 0.45),
                        NumberSequenceKeypoint.new(0.5, 0.8),
                        NumberSequenceKeypoint.new(1, 1)
                    })
                })
            }),
            u9:Create("Frame")({
                Name = "Holder",
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                u9:Create("UIListLayout")({
                    Name = "List",
                    HorizontalAlignment = Enum.HorizontalAlignment.Left,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 6),

                    [u9:GetSignal("GetPropertyChangedSignal", "AbsoluteContentSize", true)] = function(p32) -- Line: 222
                        local v33 = (p32.AbsoluteContentSize.X + 5) / p32.Parent.Parent.AbsoluteSize.X;
                        p32.Parent.Parent.Bg.Size = UDim2.fromScale(v33, 1);
                        p32.Parent.Parent.Underline.Size = UDim2.new(v33, 0, 0, 1);
                    end
                }),
                u9:Create("ImageLabel")({
                    Size = UDim2.fromScale(0.2, 0.8),
                    u9:Create("UIAspectRatioConstraint")({
                        AspectRatio = 1.2
                    }),
                    ScaleType = Enum.ScaleType.Fit,
                    BackgroundTransparency = 1,
                    Image = BunchaIcons[u14 == nil and "Combat" or (u14.Category or "Combat")] or BunchaIcons.Combat
                }),
                u9:Create("TextLabel")({
                    Name = "Text",
                    Size = UDim2.fromScale(2, 0.9),
                    BackgroundTransparency = 1,
                    TextColor3 = Color3.new(1, 1, 1),
                    Text = u9:Do(function(p34: function, p35: any, p36: userdata?) -- Line: 242
                        -- upvalues: u11 (copy), u15 (copy)
                        return `{u11.Name}  {p34(u15)}`;
                    end),
                    TextScaled = true,
                    Font = Enum.Font.SourceSansSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    u9:Create("UIStroke")({
                        Transparency = 0.75,
                        Thickness = 2
                    }),

                    TextBoundsOnChangedInit = function(p37: userdata) -- Line: 252, Name: TextBoundsOnChangedInit
                        if p37.TextBounds.X > 0 then
                            p37.Size = UDim2.fromScale(p37.TextBounds.X / p37.Parent.AbsoluteSize.X, 1);
                        end;
                    end
                }),

                function() -- Line: 258
                    -- upvalues: u14 (copy), u9 (copy), GradientButton (ref), u24 (ref), u11 (copy), PopUpCreator (ref), gameSettings (ref), u23 (copy), SignalEvent (ref), u1 (ref)
                    if u14 == nil or u14.NoCancel ~= true then
                        return u9:Create("Frame")({
                            Name = "zExit",
                            Size = UDim2.fromScale(0.3, 1),
                            AnchorPoint = Vector2.new(1, 0.5),
                            Position = UDim2.fromScale(1, 0.5),
                            BackgroundTransparency = 1,
                            Instance.new("UIAspectRatioConstraint"),
                            GradientButton(u9, {
                                Image = "rbxassetid://140084835628457",

                                Clicked = function() -- Line: 271, Name: Clicked
                                    -- upvalues: u24 (ref), u11 (ref), PopUpCreator (ref), gameSettings (ref), u23 (ref), SignalEvent (ref)
                                    if u24 then
                                        return;
                                    end;

                                    u24 = true;

                                    if u11 ~= nil and u11.Parent ~= nil then
                                        local v38 = PopUpCreator.new({
                                            Type = "Question",
                                            Content = `Are you sure you want to abandon <font {string.lower(gameSettings.RichTextPopularConfigs.SoroundColorRBX)}>'{u11.Name}'</font>?`
                                        });
                                        u23:Set(Color3.new(0.35, 0.35, 0.35));

                                        if v38.Result:Wait(5) == "Yes" then
                                            SignalEvent.ToServer("RemoveQuest", u11.Name);
                                        else
                                            u23:Reset();
                                        end;
                                    end;

                                    u24 = false;
                                end,

                                BgColor = u9:Animation(u23, u1),
                                Properties = {
                                    AnchorPoint = Vector2.new(0.5, 0.5),
                                    Position = UDim2.fromScale(0.5, 0.5)
                                },
                                ContentColor = u9:Animation(u23, u1)
                            })
                        });
                    end;
                end
            })
        }),

        function() -- Line: 303
            -- upvalues: u14 (copy), u9 (copy), math_min_ret (copy)
            local v39 = u14 ~= nil and u14.Hint or nil;

            if type(v39) == "string" and v39 ~= "" then
                return u9:Create("Frame")({
                    Name = "aaHint",
                    Size = UDim2.new(1, 0, 0, math_min_ret * 0.8),
                    BackgroundTransparency = 1,
                    u9:Create("Frame")({
                        Name = "Bg",
                        Size = UDim2.new(0, 40, 1, 0),
                        BackgroundColor3 = Color3.new(),
                        BackgroundTransparency = 0.65,
                        u9:Create("UICorner")({
                            CornerRadius = UDim.new(1)
                        }),
                        u9:Create("TextLabel")({
                            Name = "Txt",
                            BackgroundTransparency = 1,
                            TextScaled = true,
                            TextTransparency = 0.15,
                            AnchorPoint = Vector2.new(0, 0.5),
                            Position = UDim2.new(0, 6, 0.5, 0),
                            Size = UDim2.new(100, 0, 1, -4),
                            Text = v39,
                            Font = Enum.Font.SourceSansItalic,
                            TextColor3 = Color3.new(1, 1, 1),
                            TextXAlignment = Enum.TextXAlignment.Left,

                            TextBoundsOnChangedInit = function(p40: userdata) -- Line: 333, Name: TextBoundsOnChangedInit
                                if p40.TextBounds.X > 0 then
                                    p40.Parent.Size = UDim2.new(0, p40.TextBounds.X + 12, 1, 0);
                                end;
                            end
                        })
                    })
                });
            end;
        end,

        function() -- Line: 342
            -- upvalues: u9 (copy), u17 (copy), u26 (copy), u16 (copy), u25 (ref), ReplicatedStorage (ref), Utility (ref), math_min_ret2 (copy)
            return u9:Create("Frame")({
                Name = "bTimer",
                Visible = u9:Do(function(p41: function) -- Line: 346
                    -- upvalues: u17 (ref)
                    return p41(u17) == true;
                end),
                Size = u26,
                BackgroundColor3 = Color3.new(0.1, 0.1, 0.1),
                BackgroundTransparency = 0.55,
                u9:Create("UICorner")({
                    CornerRadius = UDim.new(1)
                }),
                u9:Create("UIStroke")({
                    Transparency = 0.75,
                    Color = Color3.new(1, 1, 1),
                    BorderOffset = UDim.new(0, -2)
                }),
                u9:Create("TextLabel")({
                    BackgroundTransparency = 1,
                    TextScaled = true,
                    TextStrokeTransparency = 0.85,
                    Size = UDim2.fromScale(100, 0.8),
                    TextColor3 = Color3.new(1, 1, 1),
                    Font = Enum.Font.SourceSansBold,
                    Text = u9:Do(function(p42: function, p43: any, p44: userdata?) -- Line: 376
                        -- upvalues: u16 (ref), u25 (ref), ReplicatedStorage (ref), Utility (ref)
                        local v45 = p42(u16);

                        if v45 ~= nil and v45 < 15 then
                            if not u25 then
                                u25 = true;
                                p44.TextColor3 = Color3.new(1, 0.3, 0.3);
                            end;

                            ReplicatedStorage.Assets.Sounds.Misc.countDown.TimePosition = 0;
                            ReplicatedStorage.Assets.Sounds.Misc.countDown:Play();
                        end;

                        return Utility.formatTime(v45 or 0);
                    end),

                    TextBoundsOnChangedInit = function(p46: userdata, p47) -- Line: 399, Name: TextBoundsOnChangedInit
                        -- upvalues: u26 (ref), math_min_ret2 (ref)
                        u26:Set(UDim2.new(0, math.max(p47.X, 40) + 10, 0, math_min_ret2));
                    end,

                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.5)
                })
            });
        end,

        u9:Create("Frame")({
            Name = "cTasksHolder",
            Size = UDim2.fromScale(1, 0.5),
            Position = UDim2.new(0, 0, 0, 35),
            BackgroundTransparency = 1,
            u9:Create("UIListLayout")({
                Name = "List",
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Top,
                SortOrder = Enum.SortOrder.LayoutOrder,
                FillDirection = Enum.FillDirection.Vertical,
                Padding = UDim.new(0, 5),

                [u9:GetSignal("GetPropertyChangedSignal", "AbsoluteContentSize", true)] = function(p48) -- Line: 421
                    p48.Parent.Size = UDim2.new(1, 0, 0, p48.AbsoluteContentSize.Y);
                end
            }),
            u9:Iterate(u11.Tasks:GetChildren(), function(p49: any, p50: any, p51: any, p52: userdata) -- Line: 425
                -- upvalues: u14 (copy), TaskComponent (ref), u9 (copy), updProg (copy), Quests (ref), u12 (copy)
                local v53 = nil;

                if u14 ~= nil and u14.QuestInstance ~= nil then
                    for i, child in ipairs(u14.QuestInstance.Tasks:GetChildren()) do
                        if child.Name == p50.Name then
                            v53 = i;
                            break;
                        end;
                    end;
                end;

                local v54;

                if u14 == nil or u14.TaskSpecs == nil then
                    v54 = nil;
                else
                    v54 = u14.TaskSpecs[p50.Name] or nil;
                end;

                local TaskMarker = Quests.GetTaskMarker(u14, p50);
                local v55;

                if v54 == nil then
                    v55 = nil;
                else
                    v55 = v54.Hint or nil;
                end;

                return TaskComponent(u9, p50, updProg, TaskMarker, v53, v55, u12);
            end)
        }),

        function() -- Line: 441
            -- upvalues: Quests (ref), u11 (copy), u9 (copy), math_min_ret3 (copy), RewardsStyling (ref), Resolve (ref), Items (ref), Multipliers (ref), Utility (ref)
            local v56 = Quests.RewardsOf(u11, game.Players.LocalPlayer);

            if v56 ~= nil then
                return u9:Create("Frame")({
                    Name = "zRewardsHolder",
                    Size = UDim2.new(1, 0, 0, math_min_ret3),
                    BackgroundTransparency = 1,
                    u9:Create("UIListLayout")({
                        Name = "List",
                        HorizontalAlignment = Enum.HorizontalAlignment.Left,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        FillDirection = Enum.FillDirection.Horizontal,
                        Padding = UDim.new(0, 2),

                        [u9:GetSignal("GetPropertyChangedSignal", "AbsoluteContentSize", true)] = function(p57) -- Line: 456
                            -- upvalues: math_min_ret3 (ref)
                            p57.Parent.Size = UDim2.new(0, p57.AbsoluteContentSize.X, 0, math_min_ret3);
                        end
                    }),
                    u9:Iterate(v56, function(p58, p59, p60) -- Line: 460
                        -- upvalues: Quests (ref), RewardsStyling (ref), Resolve (ref), Items (ref), Multipliers (ref), Utility (ref)
                        if typeof(p59) == "table" and (p59.RequiresQuest ~= nil and Quests.GetPlayerQuestState(game.Players.LocalPlayer, p59.RequiresQuest) == "None") then
                            return nil;
                        end;

                        local IconAndColor, v61 = RewardsStyling.GetIconAndColor(p58, p59);
                        local v62, v63;

                        if p58 == "Power" then
                            local v64 = Resolve.NameOf(p59);
                            v62 = Resolve.DisplayName(v64) or tostring(v64);
                            v63 = "Unlock";
                        elseif Items[p58] == nil then
                            v62 = p58 == "FlatMastery" and "Mastery" or p58;
                            local v65;

                            if p58 == "Exp" then
                                v65 = Multipliers.ExpGain(nil, "Quest");
                            elseif p58 == "Wen" then
                                v65 = Multipliers.WenGain(nil, "Quest");
                            else
                                v65 = nil;
                            end;

                            local v66;

                            if p58 == "Exp" then
                                v66 = Multipliers.ExpGainTag(nil, "Quest");
                            elseif p58 == "Wen" then
                                v66 = Multipliers.WenGainTag(nil, "Quest");
                            else
                                v66 = nil;
                            end;

                            local addCommasToNumber = Utility.addCommasToNumber;

                            if v65 ~= nil then
                                p59 = math.floor(p59 * v65);
                            end;

                            v63 = "+" .. addCommasToNumber(p59) .. (v66 == nil and "" or ` ({v66})`);
                        else
                            local v67 = typeof(p59) == "table" and (p59.Quantity or 1) or 1;

                            if typeof(p59) == "table" then
                                p59 = p59.Chance;
                            end;

                            v63 = "x" .. v67;

                            if typeof(p59) == "number" and p59 < 100 then
                                v63 = v63 .. ` ({p59}%)`;
                                v62 = p58;
                            else
                                v62 = p58;
                            end;
                        end;

                        return p60:Create("Frame")({
                            Name = p58,
                            Size = UDim2.fromScale(0.3, 1),
                            BackgroundTransparency = 0.55,
                            p60:Create("UICorner")({
                                CornerRadius = UDim.new(1)
                            }),
                            p60:Create("UIStroke")({
                                Transparency = 0.75,
                                BorderOffset = UDim.new(0, -4),
                                Color = Color3.new(1, 1, 1)
                            }),
                            BackgroundColor3 = Color3.new(0.1, 0.1, 0.1),
                            p60:Create("Frame")({
                                Name = "Holder",
                                Size = UDim2.new(1, -4, 1, -4),
                                AnchorPoint = Vector2.new(0.5, 0.5),
                                Position = UDim2.fromScale(0.5, 0.5),
                                BackgroundTransparency = 1,
                                p60:Create("UIListLayout")({
                                    Name = "List",
                                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                                    VerticalAlignment = Enum.VerticalAlignment.Center,
                                    FillDirection = Enum.FillDirection.Horizontal,
                                    Padding = UDim.new(0, 2),

                                    [p60:GetSignal("GetPropertyChangedSignal", "AbsoluteContentSize", true)] = function(p68) -- Line: 526
                                        p68.Parent.Parent.Size = UDim2.new(0, p68.AbsoluteContentSize.X, 1, 0);
                                    end
                                }),
                                p60:Create("ImageLabel")({
                                    Image = IconAndColor,
                                    Name = "Img",
                                    Size = UDim2.fromScale(1, 1.25),
                                    BackgroundTransparency = 1,
                                    Instance.new("UIAspectRatioConstraint")
                                }),
                                p60:Create("TextLabel")({
                                    Name = "ItemName",
                                    Size = UDim2.fromScale(100, 1),
                                    BackgroundTransparency = 1,
                                    Text = v62,
                                    TextXAlignment = Enum.TextXAlignment.Left,
                                    TextScaled = true,
                                    Font = Enum.Font.SourceSansSemibold,
                                    TextColor3 = Color3.new(1, 1, 1),
                                    TextTransparency = 0.2,
                                    p60:Create("UIStroke")({
                                        Transparency = 0.75,
                                        Thickness = 1.5
                                    }),

                                    TextBoundsOnChangedInit = function(p69: userdata) -- Line: 551, Name: TextBoundsOnChangedInit
                                        if p69.TextBounds.X > 0 then
                                            p69.Size = UDim2.new(0, p69.TextBounds.X + 2, 1, 0);
                                        end;
                                    end
                                }),
                                p60:Create("TextLabel")({
                                    Name = "Txt",
                                    Size = UDim2.fromScale(100, 1),
                                    BackgroundTransparency = 1,
                                    Text = v63,
                                    TextXAlignment = Enum.TextXAlignment.Left,
                                    TextScaled = true,
                                    Font = Enum.Font.SourceSansSemibold,
                                    TextColor3 = v61,
                                    p60:Create("UIStroke")({
                                        Transparency = 0.75,
                                        Thickness = 1.5
                                    }),

                                    TextBoundsOnChangedInit = function(p70: userdata) -- Line: 570, Name: TextBoundsOnChangedInit
                                        if p70.TextBounds.X > 0 then
                                            p70.Size = UDim2.new(0, p70.TextBounds.X + 10, 1, 0);
                                        end;
                                    end
                                })
                            })
                        });
                    end)
                });
            end;
        end
    });
end;
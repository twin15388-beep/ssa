-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local faye = require(ReplicatedStorage.Packages.faye);
local BossHunts = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests.BossHunts);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local TimedEvents = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.TimedEvents);
local Platform_Handler = require(ReplicatedStorage.CAM.Client.Controllers.Platform_Handler);
local script_HuntCard = require(script.HuntCard);
local script_Transition = require(script.Transition);
require(script.Types);
local LocalPlayer = Players.LocalPlayer;
local u1 = faye.Info(0.2);
local Every = TimedEvents.BossHunt.Every;

local function readsSide(p2: string?) -- Line: 65
    -- upvalues: BossHunts (copy), Utility (copy), LocalPlayer (copy)
    local v3 = p2 ~= nil and BossHunts.Sides[p2] or nil;
    local Data = Utility.GetData(LocalPlayer);
    local v4;

    if Data == nil then
        v4 = nil;
    else
        v4 = Data.Race.Value or nil;
    end;

    local v5;

    if v3 == nil or v4 == nil then
        v5 = false;
    else
        v5 = table.find(v3.Race, v4) ~= nil;
    end;

    return v5;
end;

local function readsBand(p6: string) -- Line: 74
    -- upvalues: Utility (copy), LocalPlayer (copy), gameSettings (copy), BossHunts (copy)
    local Data = Utility.GetData(LocalPlayer);
    local v7;

    if Data == nil then
        v7 = nil;
    else
        v7 = Data.Exp.Goal or nil;
    end;

    if v7 == nil then
        return false;
    end;

    local v8 = v7.Value / gameSettings.expPerLevel;

    if p6 == "High" then
        return BossHunts.BandLevel <= v8;
    end;

    return v8 <= BossHunts.BandLevel;
end;

local u9 = not RunService:IsRunning();
local u10 = { {
        Id = "1",
        Quest = "Eliminate Rengu",
        Boss = "Rengu",
        Side = "Muzan",
        Tier = "Legendary",
        ExpiresAt = 540
    }, {
        Id = "2",
        Quest = "Eliminate Akazo",
        Boss = "Akazo",
        Side = "Crow",
        Tier = "Mythic",
        ExpiresAt = 300
    }, {
        Id = "3",
        Quest = "Eliminate Mother Bear",
        Boss = "Mother Bear",
        Side = "Crow",
        Tier = "Common",
        ExpiresAt = 75
    }, {
        Id = "4",
        Quest = "Eliminate Datai",
        Boss = "Datai",
        Side = "Crow",
        Tier = "Legendary",
        ExpiresAt = 480
    }, {
        Id = "5",
        Quest = "Eliminate Tai Chi Trainee Suzume",
        Boss = "Tai Chi Trainee Suzume",
        Side = "Muzan",
        Tier = "UnCommon",
        ExpiresAt = 210
    } };

return function(p11: any, u12: userdata, p13: userdata, u14: any, u15: string) -- Line: 100
    -- upvalues: BossHunts (copy), Utility (copy), LocalPlayer (copy), ReplicatedStorage (copy), Every (copy), gameSettings (copy), u9 (copy), u10 (copy), script_Transition (copy), Platform_Handler (copy), script_HuntCard (copy), u1 (copy)
    local u16 = {};
    local u17 = p11:Value(u16);
    local u18 = p11:Value(0);

    local function visibleCap() -- Line: 107
        -- upvalues: BossHunts (ref), Utility (ref), LocalPlayer (ref)
        local v19 = 0;

        for i in BossHunts.Sides do
            local v20;

            if i == nil then
                v20 = nil;
            else
                v20 = BossHunts.Sides[i] or nil;
            end;

            local Data = Utility.GetData(LocalPlayer);
            local v21;

            if Data == nil then
                v21 = nil;
            else
                v21 = Data.Race.Value or nil;
            end;

            local v22;

            if v20 == nil or v21 == nil then
                v22 = false;
            else
                v22 = table.find(v20.Race, v21) ~= nil;
            end;

            if v22 then
                v19 = v19 + 1;
            end;
        end;

        return math.max(v19, 1) * BossHunts.MaxOpen;
    end;

    local u23 = p11:Value(UDim2.new());
    local u24 = p11:Value(UDim2.new(1, -12, 0, 20));
    local u25 = nil;
    local u26 = p11:Value(UDim2.new(1, 0, 0, 20));
    local u27 = p11:Value(UDim.new());
    local u28 = 20;
    local u29 = 0;
    local u30 = 0;

    local function pinToBottom() -- Line: 130
        -- upvalues: u25 (ref)
        if u25 == nil or u25.Parent == nil then
            return;
        end;

        local math_max_ret = math.max(u25.AbsoluteCanvasSize.Y - u25.AbsoluteWindowSize.Y, 0);
        u25.CanvasPosition = Vector2.new(0, math_max_ret);
    end;

    local function refreshCanvas() -- Line: 137
        -- upvalues: u16 (copy), u18 (copy), u28 (ref), u29 (ref), u30 (ref), u23 (copy), u24 (copy), pinToBottom (copy)
        local v31 = 0;

        for _ in u16 do
            v31 = v31 + 1;
        end;

        u18:Set(v31);
        local v32 = v31 < 1 and 1 or v31;
        local v33 = math.max(v32 * u28 + (v32 - 1) * u29, u30) * 1.4;
        u23:Set(UDim2.new(0, 0, 0, v33));
        u24:Set(UDim2.new(1, -12, 0, v33));
        task.defer(pinToBottom);
    end;

    local BossHunts2 = ReplicatedStorage:FindFirstChild("BossHunts");

    local function untilNextRoll() -- Line: 158
        -- upvalues: Every (ref), BossHunts2 (copy), BossHunts (ref), Utility (ref), LocalPlayer (ref), gameSettings (ref)
        local ServerTimeNow = workspace:GetServerTimeNow();
        local v34 = Every - ServerTimeNow % Every;

        if BossHunts2 == nil then
            return v34;
        end;

        local v35 = nil;

        for i in BossHunts.Sides do
            local v36;

            if i == nil then
                v36 = nil;
            else
                v36 = BossHunts.Sides[i] or nil;
            end;

            local Data = Utility.GetData(LocalPlayer);
            local v37;

            if Data == nil then
                v37 = nil;
            else
                v37 = Data.Race.Value or nil;
            end;

            local v38;

            if v36 == nil or v37 == nil then
                v38 = false;
            else
                v38 = table.find(v36.Race, v37) ~= nil;
            end;

            if v38 then
                local v39 = i;

                for _, v in BossHunts.Bands do
                    local Data2 = Utility.GetData(LocalPlayer);
                    local v40;

                    if Data2 == nil then
                        v40 = nil;
                    else
                        v40 = Data2.Exp.Goal or nil;
                    end;

                    local v41;

                    if v40 == nil then
                        v41 = false;
                    else
                        local v42 = v40.Value / gameSettings.expPerLevel;

                        if v == "High" then
                            v41 = BossHunts.BandLevel <= v42;
                        else
                            v41 = v42 <= BossHunts.BandLevel;
                        end;
                    end;

                    if v41 then
                        local Attribute = BossHunts2:GetAttribute((`EligibleAt{v39}{v}`));

                        if Attribute == nil then
                            return v34;
                        end;

                        if v35 == nil or Attribute < v35 then
                            v35 = Attribute;
                        end;
                    end;
                end;
            end;
        end;

        if v35 == nil then
            return v34;
        end;

        local v43 = math.ceil(v35 / Every) * Every - ServerTimeNow;

        return math.max(v34, v43);
    end;

    local function readHunt(p44: userdata) -- Line: 189
        -- upvalues: BossHunts (ref), Utility (ref), LocalPlayer (ref)
        local Attribute = p44:GetAttribute("Side");
        local v45;

        if Attribute == nil then
            v45 = nil;
        else
            v45 = BossHunts.Sides[Attribute] or nil;
        end;

        local Data = Utility.GetData(LocalPlayer);
        local v46;

        if Data == nil then
            v46 = nil;
        else
            v46 = Data.Race.Value or nil;
        end;

        local v47;

        if v45 == nil or v46 == nil then
            v47 = false;
        else
            v47 = table.find(v45.Race, v46) ~= nil;
        end;

        return v47 and {
            Id = p44.Name,
            Quest = p44:GetAttribute("Quest"),
            Boss = p44:GetAttribute("Boss"),
            Side = p44:GetAttribute("Side"),
            Tier = p44:GetAttribute("Tier"),
            ExpiresAt = p44:GetAttribute("ExpiresAt")
        } or nil;
    end;

    if u9 then
        for _, v in u10 do
            local table_clone_ret = table.clone(v);
            table_clone_ret.ExpiresAt = table_clone_ret.ExpiresAt + workspace:GetServerTimeNow();
            u17:Add(table_clone_ret.Id, table_clone_ret);
        end;

        refreshCanvas();
    elseif BossHunts2 ~= nil then
        for _, child in BossHunts2:GetChildren() do
            local v48 = readHunt(child);

            if v48 ~= nil then
                u17:Add(v48.Id, v48);
            end;
        end;

        refreshCanvas();
        p11:Connect(BossHunts2.ChildAdded, function(p49: userdata) -- Line: 220
            -- upvalues: readHunt (copy), u17 (copy), refreshCanvas (copy)
            local v50 = readHunt(p49);

            if v50 ~= nil then
                u17:Add(v50.Id, v50);
            end;

            refreshCanvas();
        end);
        p11:Connect(BossHunts2.ChildRemoved, function(p51: userdata) -- Line: 225
            -- upvalues: u17 (copy), refreshCanvas (copy)
            u17:Remove(p51.Name);
            refreshCanvas();
        end);
    end;

    p11:Create("Frame")({
        Parent = u12,
        Size = UDim2.fromScale(0.7, 0.7),
        OnClean = script_Transition.FadeOutOnClean(),
        p11:Create("UIAspectRatioConstraint")({
            AspectRatio = 0.6
        }),
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.fromScale(0.5, Platform_Handler.Platform.Value == "Mobile" and 1.03 or 1),
        p11:Create("UIGradient")({
            Rotation = -90,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.25, 0.8),
                NumberSequenceKeypoint.new(0.7, 0.9),
                NumberSequenceKeypoint.new(1, 1)
            })
        }),
        p11:Create("UICorner")({
            CornerRadius = UDim.new(0.1)
        }),
        BackgroundColor3 = Color3.new(0.065, 0.065, 0.065),
        BackgroundTransparency = p11:Animation(0, script_Transition.Info, {
            From = 1
        }),
        p11:Create("CanvasGroup")({
            Name = "ListMask",
            Size = UDim2.new(1, -12, 1, -(Platform_Handler.Platform.Value == "Mobile" and 0 or 4)),
            Position = UDim2.new(0.5, 0, 0, -26),
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundTransparency = 1,
            p11:Create("UIGradient")({
                Rotation = 90,
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(0.06, 0),
                    NumberSequenceKeypoint.new(0.94, 0),
                    NumberSequenceKeypoint.new(1, 0.7)
                })
            }),
            p11:Create("ScrollingFrame")({
                Name = "ActualHolder",
                AnchorPoint = Vector2.new(0.5, 0),
                Position = UDim2.fromScale(0.5, 0),
                Size = UDim2.new(1, 12, 1, 0),
                BackgroundTransparency = 1,
                CanvasSize = u23,

                function(p52: userdata) -- Line: 291
                    -- upvalues: u25 (ref), pinToBottom (copy)
                    u25 = p52;
                    task.defer(pinToBottom);
                end,

                AbsoluteSizeOnChangedInit = function(p53: userdata, p54) -- Line: 298, Name: AbsoluteSizeOnChangedInit
                    -- upvalues: u12 (copy), u28 (ref), u29 (ref), u30 (ref), u26 (copy), u27 (copy), refreshCanvas (copy)
                    if p54.X <= 0 then
                        return;
                    end;

                    local v55 = u12:FindFirstChildOfClass("UIScale");
                    local v56 = (v55 == nil or v55.Scale <= 0) and 1 or v55.Scale;
                    u28 = p54.X * 0.258 / v56;
                    u29 = p54.X * 0.02 / v56;
                    u30 = p54.Y / v56;
                    u26:Set(UDim2.new(1, 0, 0, u28));
                    u27:Set(UDim.new(0, u29));
                    refreshCanvas();
                end,

                ScrollingDirection = Enum.ScrollingDirection.Y,
                ScrollBarThickness = 0,
                p11:Create("Frame")({
                    Name = "InnerHolder",
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.fromScale(0.5, 0),
                    Size = u24,
                    BackgroundTransparency = 1,
                    p11:Create("UIListLayout")({
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        VerticalAlignment = Enum.VerticalAlignment.Bottom,
                        Padding = u27
                    }),
                    p11:AdvancedIterate(u17, function(p57: any, p58: any, p59: any, p60: userdata?) -- Line: 328
                        -- upvalues: script_HuntCard (ref), u15 (copy), u14 (copy), u26 (copy)
                        return script_HuntCard(p59, p58, u15, u14, u26);
                    end)
                })
            })
        }),
        p11:Create("Frame")({
            Name = "Footer",
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.new(0.5, 0, 1, -5),
            Size = UDim2.new(1, -12, 0, 26),
            BackgroundTransparency = 1,
            p11:State(function(p61, p62) -- Line: 345
                -- upvalues: BossHunts2 (copy), u9 (ref), u18 (copy), Utility (ref), LocalPlayer (ref), BossHunts (ref), untilNextRoll (copy), u1 (ref)
                if BossHunts2 ~= nil or u9 then
                    local u63 = p61(u18);
                    local Data = Utility.GetData(LocalPlayer);
                    local v64;

                    if Data == nil then
                        v64 = nil;
                    else
                        v64 = Data.Race.Value or nil;
                    end;

                    local u65 = BossHunts.Noun(v64);
                    local v66 = 0;

                    for i in BossHunts.Sides do
                        local v67;

                        if i == nil then
                            v67 = nil;
                        else
                            v67 = BossHunts.Sides[i] or nil;
                        end;

                        local Data2 = Utility.GetData(LocalPlayer);
                        local v68;

                        if Data2 == nil then
                            v68 = nil;
                        else
                            v68 = Data2.Race.Value or nil;
                        end;

                        local v69;

                        if v67 == nil or v68 == nil then
                            v69 = false;
                        else
                            v69 = table.find(v67.Race, v68) ~= nil;
                        end;

                        if v69 then
                            v66 = v66 + 1;
                        end;
                    end;

                    local u70 = math.max(v66, 1) * BossHunts.MaxOpen;
                    local u71 = u70 <= u63;

                    local function line() -- Line: 357
                        -- upvalues: u71 (copy), u63 (copy), u70 (copy), u65 (copy), Utility (ref), untilNextRoll (ref)
                        if u71 then
                            return `{u63} / {u70} {u65}s available`;
                        end;

                        return `{u63} / {u70} Next {u65} in <b>{Utility.formatTime((untilNextRoll()))}</b>`;
                    end;

                    local v72;

                    if u71 then
                        v72 = `{u63} / {u70} {u65}s available`;
                    else
                        v72 = `{u63} / {u70} Next {u65} in <b>{Utility.formatTime((untilNextRoll()))}</b>`;
                    end;

                    local u73 = p62:Value(v72);

                    if not u71 then
                        p62:Spawn(function() -- Line: 365
                            -- upvalues: u73 (copy), u71 (copy), u63 (copy), u70 (copy), u65 (copy), Utility (ref), untilNextRoll (ref)
                            while true do
                                task.wait(0.25);
                                local v74;

                                if u71 then
                                    v74 = `{u63} / {u70} {u65}s available`;
                                else
                                    v74 = `{u63} / {u70} Next {u65} in <b>{Utility.formatTime((untilNextRoll()))}</b>`;
                                end;

                                u73:Set(v74);
                            end;
                        end);
                    end;

                    return p62:Create("TextLabel")({
                        Name = "Label",
                        BackgroundTransparency = 1,
                        RichText = true,
                        TextScaled = true,
                        TextWrapped = false,
                        Size = UDim2.fromScale(1, 0.98),
                        Text = u73,
                        TextXAlignment = Enum.TextXAlignment.Center,
                        TextColor3 = Color3.new(1, 1, 1),
                        TextTransparency = p62:Animation(0.25, u1, {
                            From = 1
                        }),
                        Font = Enum.Font.SourceSansSemibold
                    });
                end;
            end)
        })
    });
end;
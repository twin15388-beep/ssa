-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Packages.faye);
local PlayerStatResolver = require(ReplicatedStorage.CAM.Global.PlayerStatResolver);
local StatTypes = require(ReplicatedStorage.CAM.Global.Types.StatTypes);
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local Multipliers = require(ReplicatedStorage.CAM.Global.Multipliers);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local StatRow = require(script.Parent.StatRow);
local Platform_Handler = require(ReplicatedStorage.CAM.Client.Controllers.Platform_Handler);

local function paddingFor() -- Line: 17
    -- upvalues: Platform_Handler (copy)
    return UDim.new(0, Platform_Handler.Platform.Value == "Mobile" and 10 or 5);
end;

local LocalPlayer = Players.LocalPlayer;

return function(u1) -- Line: 32
    -- upvalues: StatTypes (copy), PlayerStatResolver (copy), LocalPlayer (copy), BunchaIcons (copy), ReplicatedStorage (copy), Utility (copy), Multipliers (copy), paddingFor (copy), Platform_Handler (copy), StatRow (copy)
    local u2 = u1:Value({});
    local u3 = {};
    local Color3_new_ret = Color3.new(0.9, 1, 0.9);
    local Color3_new_ret2 = Color3.new(1, 0.9, 0.9);
    local Color3_new_ret3 = Color3.new(0.9, 0.95, 1);
    local Color3_new_ret4 = Color3.new(1, 0.8, 0.8);
    local u4 = { "Factor", "Regen" };

    local function isMultiplier(p5: string) -- Line: 52
        -- upvalues: u4 (copy)
        for _, v in u4 do
            if string.find(p5, v, 1, true) ~= nil then
                return true;
            end;
        end;

        return false;
    end;

    local function displayText(p6: string, p7: number) -- Line: 60
        -- upvalues: isMultiplier (copy)
        if isMultiplier(p6) then
            return `{math.round((1 + p7) * 10000) / 10000}x`;
        end;

        if p7 > 0 then
            return `+{p7}`;
        end;

        return tostring(p7);
    end;

    local u8 = nil;

    local function put(p9: string, p10: any, p11: table?) -- Line: 74
        -- upvalues: u3 (copy), isMultiplier (copy), Color3_new_ret4 (copy), Color3_new_ret3 (copy), Color3_new_ret2 (copy), Color3_new_ret (copy), u1 (copy), u2 (copy), u8 (ref)
        local v12 = typeof(p10) == "number" and p10 ~= 0 and true or p10 == true;
        local v13 = u3[p9];
        local v14;

        if typeof(p10) == "number" then
            v14 = p10 < 0;
        else
            v14 = false;
        end;

        local v15 = v14 and 0.45 or 0;
        local v16 = p11 ~= nil and p11.Tint;

        if not v16 then
            if isMultiplier(p9) then
                if v14 then
                    v16 = Color3_new_ret4;
                else
                    v16 = Color3_new_ret3;
                end;
            elseif v14 then
                v16 = Color3_new_ret2;
            else
                v16 = Color3_new_ret;
            end;
        end;

        local v17 = p11 ~= nil and p11.Text;

        if not v17 then
            if typeof(p10) == "number" then
                if isMultiplier(p9) then
                    v17 = `{math.round((1 + p10) * 10000) / 10000}x`;
                elseif p10 > 0 then
                    v17 = `+{p10}`;
                else
                    v17 = tostring(p10);
                end;
            else
                v17 = "";
            end;
        end;

        if v12 then
            if v13 ~= nil then
                v13.Value:Set(p10);
                v13.Dim:Set(v15);
                v13.Tint:Set(v16);
                v13.Text:Set(v17);

                return;
            end;

            local v18 = {
                Value = u1:Value(p10),
                Dim = u1:Value(v15),
                Tint = u1:Value(v16),
                Text = u1:Value(v17)
            };
            u3[p9] = v18;
            u2:Add(p9, v18);

            if u8 ~= nil then
                u1:Delay(0, u8);
            end;
        elseif v13 ~= nil then
            u3[p9] = nil;
            u2:Remove(p9);
            v13.Value:Destroy();
            v13.Dim:Destroy();
            v13.Tint:Destroy();
            v13.Text:Destroy();
        end;
    end;

    local u19 = {};

    for _, v in StatTypes.StatKeys do
        table.insert(u19, PlayerStatResolver.Attach(LocalPlayer, v, function(p20) -- Line: 114
            -- upvalues: put (copy), v (copy)
            put(v, p20);
        end));
    end;

    local function registered(p21: string) -- Line: 124
        -- upvalues: BunchaIcons (ref)
        return BunchaIcons.StatsAndDebuffs[p21] ~= nil;
    end;

    table.insert(u19, PlayerStatResolver.AttachActiveStatEvents(LocalPlayer, {
        Added = function(p22, p23) -- Line: 128, Name: Added
            -- upvalues: StatTypes (ref), BunchaIcons (ref), put (copy)
            if StatTypes.StatKeyLookup[p22] or BunchaIcons.StatsAndDebuffs[p22] == nil then
                return;
            end;

            put(p22, p23);
        end,

        Changed = function(p24, p25) -- Line: 132, Name: Changed
            -- upvalues: StatTypes (ref), BunchaIcons (ref), put (copy)
            if StatTypes.StatKeyLookup[p24] or BunchaIcons.StatsAndDebuffs[p24] == nil then
                return;
            end;

            put(p24, p25);
        end,

        Removed = function(p26) -- Line: 136, Name: Removed
            -- upvalues: StatTypes (ref), u3 (copy), isMultiplier (copy), Color3_new_ret3 (copy), Color3_new_ret (copy), u2 (copy)
            if StatTypes.StatKeyLookup[p26] then
                return;
            end;

            local v27 = u3[p26];
            isMultiplier(p26);

            if v27 ~= nil then
                u3[p26] = nil;
                u2:Remove(p26);
                v27.Value:Destroy();
                v27.Dim:Destroy();
                v27.Tint:Destroy();
                v27.Text:Destroy();
            end;
        end
    }));
    local Color3_new_ret5 = Color3.new(1, 1, 1);
    local u28 = false;
    local u29 = {};

    local function markClock(p30: string) -- Line: 155
        -- upvalues: ReplicatedStorage (ref), LocalPlayer (ref), StatTypes (ref)
        local v31 = ReplicatedStorage.Player_Service.Values:FindFirstChild(LocalPlayer.Name);

        if v31 == nil then
            return nil, false;
        end;

        local v32 = StatTypes.StatToAttribute(p30);
        local v33 = nil;
        local v34 = false;

        for _, child in v31:GetChildren() do
            if child:HasTag(StatTypes.ValueStatTag) and child:GetAttribute(v32) == true then
                v34 = true;
                local Attribute = child:GetAttribute("_Started");
                local Attribute2 = child:GetAttribute("_Duration");

                if typeof(Attribute) == "number" and (typeof(Attribute2) == "number" and Attribute2 > 0) then
                    local v35 = Attribute + Attribute2 - workspace:GetServerTimeNow();

                    if v35 > 0 and (v33 == nil or v33 < v35) then
                        v33 = v35;
                    end;
                end;
            end;
        end;

        return v33, v34;
    end;

    local function refreshClocks() -- Line: 172
        -- upvalues: u3 (copy), markClock (copy), u29 (copy), put (copy), Utility (ref), Color3_new_ret5 (copy), PlayerStatResolver (ref), LocalPlayer (ref)
        local v36 = {};
        local v37 = false;

        for i in u3 do
            table.insert(v36, i);
        end;

        for _, v in v36 do
            local v38, v39 = markClock(v);
            v37 = v39 and true or v37;

            if v38 == nil then
                if u29[v] then
                    u29[v] = nil;
                    put(v, PlayerStatResolver.GetStat(LocalPlayer, v));
                end;
            else
                u29[v] = true;
                put(v, v38, {
                    Text = Utility.formatTime(v38),
                    Tint = Color3_new_ret5
                });
            end;
        end;

        return v37;
    end;

    local function refreshWindows() -- Line: 189
        -- upvalues: refreshClocks (copy), Multipliers (ref), u3 (copy), isMultiplier (copy), Color3_new_ret3 (copy), Color3_new_ret (copy), u2 (copy), put (copy), Utility (ref), Color3_new_ret5 (copy)
        local v40 = refreshClocks();

        for _, v in Multipliers.Kinds do
            for _, v2 in v do
                local Value = Multipliers.GetValue(v2);
                local v41 = Multipliers.DisplayName(v2);

                if Value.Status then
                    if Value.Remaining > 0 then
                        put(v41, Value.Remaining, {
                            Text = `{Utility.formatTime(Value.Remaining)} ({v41})`,
                            Tint = Color3_new_ret5
                        });
                        v40 = true;
                    else
                        put(v41, (1 / 0), {
                            Text = `Active ({v41})`,
                            Tint = Color3_new_ret5
                        });
                    end;
                else
                    local v42 = u3[v41];
                    isMultiplier(v41);

                    if v42 ~= nil then
                        u3[v41] = nil;
                        u2:Remove(v41);
                        v42.Value:Destroy();
                        v42.Dim:Destroy();
                        v42.Tint:Destroy();
                        v42.Text:Destroy();
                    end;
                end;
            end;
        end;

        return v40;
    end;

    local function tick() -- Line: 207
        -- upvalues: refreshWindows (copy), u28 (ref), u1 (copy), tick (copy)
        if refreshWindows() then
            u1:Delay(1, tick);

            return;
        end;

        u28 = false;
    end;

    u8 = function() -- Line: 214, Name: startTicking
        -- upvalues: u28 (ref), refreshWindows (copy), u1 (copy), tick (copy)
        if u28 then
            return;
        end;

        u28 = true;

        if refreshWindows() then
            u1:Delay(1, tick);

            return;
        end;

        u28 = false;
    end;

    for _, v in Multipliers.Kinds do
        for _, v2 in v do
            local u43 = Multipliers.Changed(v2):Connect(u8);
            table.insert(u19, function() -- Line: 222
                -- upvalues: u43 (copy)
                u43:Disconnect();
            end);
        end;
    end;

    local v44 = ReplicatedStorage.Player_Service.Values:FindFirstChild(LocalPlayer.Name);

    if v44 ~= nil then
        local u45 = v44.ChildAdded:Connect(u8);
        table.insert(u19, function() -- Line: 231
            -- upvalues: u45 (copy)
            u45:Disconnect();
        end);
    end;

    u8();
    local u46 = u1:Value(paddingFor());
    u1:Connect(Platform_Handler.Platform.Changed.Event, function() -- Line: 238
        -- upvalues: u46 (copy), paddingFor (ref)
        u46:Set(paddingFor());
    end);

    return u1:Create("Frame")({
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.fromScale(1.05, 1),
        Size = UDim2.fromScale(1.8, 0.55),
        BackgroundTransparency = 1,

        OnClean = function() -- Line: 249, Name: OnClean
            -- upvalues: u19 (copy)
            for _, v in u19 do
                v();
            end;
        end,

        u1:Create("UIListLayout")({
            Wraps = true,
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            Padding = u46
        }),
        u1:AdvancedIterate(u2, function(p47, p48, p49) -- Line: 262
            -- upvalues: StatRow (ref)
            return StatRow(p49, p47, p48);
        end)
    });
end;
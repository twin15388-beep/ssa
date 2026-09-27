-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local SkillTreeConfig = require(ReplicatedStorage.CAM.Global.SkillService.SkillTreeholder.SkillTreeConfig);
local StatTypes = require(ReplicatedStorage.CAM.Global.Types.StatTypes);
local Character_info_provider = require(script.Parent.Character_info_provider);
local ToolLock = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.ToolLock);
local PlayerProfile = require(script.Parent.PlayerProfile);
local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);
local Clans = require(ReplicatedStorage.CAM.Clans);
local MasterySource = require(ReplicatedStorage.CAM.Global.Collectibles.MasterySource);
local Breathings = require(ReplicatedStorage.CAM.Global.Powers.Breathings);
local DemonArts = require(ReplicatedStorage.CAM.Global.Powers.DemonArts);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local Titles = require(ReplicatedStorage.CAM.Global.Titles);
local PlayerProgression = require(ReplicatedStorage.CAM.Global.PlayerProgression);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local u1 = {};
local u2 = RunService:IsServer();
local u3 = {};
local u4 = {};
local u5 = {};

local function disposeSet(p6: table) -- Line: 42
    for _, v in p6 do
        v:Disconnect();
    end;

    table.clear(p6);
end;

local function bucketKey(p7: userdata) -- Line: 49
    -- upvalues: u2 (copy)
    if p7:IsA("Player") then
        return not u2 and 0 or p7.UserId;
    end;

    return p7;
end;

local function getBucket(p8: userdata) -- Line: 58
    -- upvalues: u2 (copy), u3 (copy)
    if p8:IsA("Player") then
        p8 = not u2 and 0 or p8.UserId;
    end;

    if p8 == 0 then
        return u3;
    end;

    local v9 = u3[p8];

    if v9 == nil then
        v9 = {};
        u3[p8] = v9;
    end;

    return v9;
end;

local function clearBucket(p10: userdata) -- Line: 72
    -- upvalues: u2 (copy), u3 (copy)
    if p10:IsA("Player") then
        p10 = not u2 and 0 or p10.UserId;
    end;

    if p10 == 0 then
        table.clear(u3);

        return;
    end;

    u3[p10] = nil;
end;

local function nilStatInBucket(p11: userdata, p12: string) -- Line: 81
    -- upvalues: u2 (copy), u3 (copy)
    if p11:IsA("Player") then
        p11 = not u2 and 0 or p11.UserId;
    end;

    if p11 == 0 then
        u3[p12] = nil;

        return;
    end;

    local v13 = u3[p11];

    if v13 then
        v13[p12] = nil;
    end;
end;

local function notifyStat(p14: userdata, p15: string) -- Line: 91
    -- upvalues: u2 (copy), u5 (copy), u1 (copy)
    local v16;

    if p14:IsA("Player") then
        v16 = not u2 and 0 or p14.UserId;
    else
        v16 = p14;
    end;

    local v17 = u5[v16] and u5[v16][p15];

    if not v17 then
        return;
    end;

    for _, v in table.clone(v17) do
        local Stat = u1.GetStat(p14, p15, v.resolver, v.data);
        task.spawn(v.callback, Stat);
    end;
end;

local function notifyAll(p18: userdata) -- Line: 103
    -- upvalues: u2 (copy), u5 (copy), notifyStat (copy)
    local v19;

    if p18:IsA("Player") then
        v19 = not u2 and 0 or p18.UserId;
    else
        v19 = p18;
    end;

    local v20 = u5[v19];

    if not v20 then
        return;
    end;

    local v21 = {};

    for i in v20 do
        table.insert(v21, i);
    end;

    for _, v in v21 do
        notifyStat(p18, v);
    end;
end;

local function invalidateAndNotifyAll(p22: userdata) -- Line: 116
    -- upvalues: u2 (copy), u3 (copy), notifyAll (copy)
    local v23;

    if p22:IsA("Player") then
        v23 = not u2 and 0 or p22.UserId;
    else
        v23 = p22;
    end;

    if v23 == 0 then
        table.clear(u3);
    else
        u3[v23] = nil;
    end;

    notifyAll(p22);
end;

local function invalidateOneAndNotify(p24: userdata, p25: string) -- Line: 121
    -- upvalues: u2 (copy), u3 (copy), notifyStat (copy)
    local v26;

    if p24:IsA("Player") then
        v26 = not u2 and 0 or p24.UserId;
    else
        v26 = p24;
    end;

    if v26 == 0 then
        u3[p25] = nil;
    else
        local v27 = u3[v26];

        if v27 then
            v27[p25] = nil;
        end;
    end;

    notifyStat(p24, p25);
end;

local function roundStat(p28) -- Line: 136
    if typeof(p28) == "number" then
        return math.round(p28 * 1000) / 1000;
    end;

    return p28;
end;

local u29 = {};
local u30 = {};

function u1.GetActiveValueStats(p31: userdata) -- Line: 152
    -- upvalues: Utility (copy), StatTypes (copy), CollectionService (copy)
    local u32 = {};
    local valuesfolder = Utility.getvaluesfolder(p31);

    if valuesfolder == nil or valuesfolder:IsA("Player") then
        return u32;
    end;

    local function contribute(p33: string, p34: any) -- Line: 160
        -- upvalues: u32 (copy), StatTypes (ref)
        if u32[p33] == true then
            return;
        end;

        if typeof(p34) ~= "number" then
            if p34 == true then
                u32[p33] = true;
            end;

            return;
        end;

        local v35 = u32[p33];
        local v36 = typeof(v35) ~= "number" and 0 or v35;
        local v37;

        if StatTypes.HighestOnlyStats[p33] == true then
            v37 = math.max(v36, p34);
        else
            v37 = v36 + p34;
        end;

        u32[p33] = v37;
    end;

    for _, child in valuesfolder:GetChildren() do
        if CollectionService:HasTag(child, StatTypes.ValueStatTag) then
            for i, v in child:GetAttributes() do
                if not StatTypes.IsMetaAttribute(i) then
                    local v38 = StatTypes.AttributeToStat(i);

                    if u32[v38] ~= true then
                        if typeof(v) == "number" then
                            local v39 = u32[v38];
                            local v40 = typeof(v39) ~= "number" and 0 or v39;
                            local v41;

                            if StatTypes.HighestOnlyStats[v38] == true then
                                v41 = math.max(v40, v);
                            else
                                v41 = v40 + v;
                            end;

                            u32[v38] = v41;
                        elseif v == true then
                            u32[v38] = true;
                        end;
                    end;
                end;
            end;
        elseif StatTypes.StatKeyLookup[child.Name] and child:IsA("ValueBase") then
            local Name = child.Name;
            local Value = child.Value;

            if u32[Name] ~= true then
                if typeof(Value) == "number" then
                    local v42 = u32[Name];
                    local v43 = typeof(v42) ~= "number" and 0 or v42;
                    local v44;

                    if StatTypes.HighestOnlyStats[Name] == true then
                        v44 = math.max(v43, Value);
                    else
                        v44 = v43 + Value;
                    end;

                    u32[Name] = v44;
                elseif Value == true then
                    u32[Name] = true;
                end;
            end;
        end;
    end;

    for i, v in u32 do
        local v45;

        if typeof(v) == "number" then
            v45 = math.round(v * 1000) / 1000;
        else
            v45 = v;
        end;

        u32[i] = v45;
    end;

    return u32;
end;

local function notifyActive(u46: userdata) -- Line: 193
    -- upvalues: u2 (copy), u29 (copy), u30 (copy), u1 (copy)
    local u47;

    if u46:IsA("Player") then
        u47 = not u2 and 0 or u46.UserId;
    else
        u47 = u46;
    end;

    if u29[u47] == nil or u30[u47] then
        return;
    end;

    u30[u47] = true;
    task.defer(function() -- Line: 197
        -- upvalues: u30 (ref), u47 (copy), u29 (ref), u1 (ref), u46 (copy)
        u30[u47] = nil;
        local v48 = u29[u47];

        if v48 == nil then
            return;
        end;

        local ActiveValueStats = u1.GetActiveValueStats(u46);

        for _, v in table.clone(v48) do
            task.spawn(v, ActiveValueStats);
        end;
    end);
end;

local function watchSlotValue(u49: userdata, u50: userdata, p51: table) -- Line: 209
    -- upvalues: u2 (copy), u3 (copy), notifyAll (copy)
    if not u50:IsA("ValueBase") then
        return;
    end;

    local u54 = u50:GetPropertyChangedSignal("Value"):Connect(function() -- Line: 211
        -- upvalues: u49 (copy), u2 (ref), u3 (ref), notifyAll (ref)
        local v52 = u49;
        local v53;

        if v52:IsA("Player") then
            v53 = not u2 and 0 or v52.UserId;
        else
            v53 = v52;
        end;

        if v53 == 0 then
            table.clear(u3);
        else
            u3[v53] = nil;
        end;

        notifyAll(v52);
    end);
    table.insert(p51, u54);
    local Parent = u50.Parent;
    local u55 = nil;
    u55 = u50:GetPropertyChangedSignal("Parent"):Connect(function() -- Line: 220
        -- upvalues: u50 (copy), Parent (copy), u54 (copy), u55 (ref)
        if u50.Parent ~= Parent then
            u54:Disconnect();
            u55:Disconnect();
        end;
    end);
    table.insert(p51, u55);
end;

local function attachConfigWatchers(u56: userdata, p57: userdata, u58: table) -- Line: 229
    -- upvalues: u2 (copy), u3 (copy), notifyAll (copy), watchSlotValue (copy)
    local Equipped = p57:FindFirstChild("Equipped");

    if Equipped and Equipped:IsA("ValueBase") then
        local PropertyChangedSignal = Equipped:GetPropertyChangedSignal("Value");
        table.insert(u58, PropertyChangedSignal:Connect(function() -- Line: 232
            -- upvalues: u56 (copy), u2 (ref), u3 (ref), notifyAll (ref)
            local v59 = u56;
            local v60;

            if v59:IsA("Player") then
                v60 = not u2 and 0 or v59.UserId;
            else
                v60 = v59;
            end;

            if v60 == 0 then
                table.clear(u3);
            else
                u3[v60] = nil;
            end;

            notifyAll(v59);
        end));
    end;

    local Toolbar = p57:FindFirstChild("Toolbar");

    if Toolbar then
        for _, child in Toolbar:GetChildren() do
            watchSlotValue(u56, child, u58);
        end;

        table.insert(u58, Toolbar.ChildAdded:Connect(function(p61) -- Line: 241
            -- upvalues: u56 (copy), u2 (ref), u3 (ref), notifyAll (ref), watchSlotValue (ref), u58 (copy)
            local v62 = u56;
            local v63;

            if v62:IsA("Player") then
                v63 = not u2 and 0 or v62.UserId;
            else
                v63 = v62;
            end;

            if v63 == 0 then
                table.clear(u3);
            else
                u3[v63] = nil;
            end;

            notifyAll(v62);
            watchSlotValue(u56, p61, u58);
        end));
        table.insert(u58, Toolbar.ChildRemoved:Connect(function() -- Line: 245
            -- upvalues: u56 (copy), u2 (ref), u3 (ref), notifyAll (ref)
            local v64 = u56;
            local v65;

            if v64:IsA("Player") then
                v65 = not u2 and 0 or v64.UserId;
            else
                v65 = v64;
            end;

            if v65 == 0 then
                table.clear(u3);
            else
                u3[v65] = nil;
            end;

            notifyAll(v64);
        end));
    end;
end;

local function attachValuesFolderWatchers(u66: userdata, u67: userdata, u68: table) -- Line: 251
    -- upvalues: StatTypes (copy), u2 (copy), u3 (copy), notifyStat (copy), CollectionService (copy), u29 (copy), u30 (copy), u1 (copy)
    local function invalidateTagged(p69: userdata) -- Line: 257
        -- upvalues: StatTypes (ref), u66 (copy), u2 (ref), u3 (ref), notifyStat (ref)
        for i, v in p69:GetAttributes() do
            if not (StatTypes.IsMetaAttribute(i) or typeof(v) ~= "number" and typeof(v) ~= "boolean") then
                u66 = u66;
                local v70 = StatTypes.AttributeToStat(i);
                local v71;

                if u66:IsA("Player") then
                    v71 = not u2 and 0 or u66.UserId;
                end;

                if v71 == 0 then
                    u3[v70] = nil;
                else
                    local v72 = u3[v71];

                    if v72 then
                        v72[v70] = nil;
                    end;
                end;

                notifyStat(u66, v70);
            end;
        end;
    end;

    local function onChange(p73: userdata) -- Line: 265
        -- upvalues: CollectionService (ref), StatTypes (ref), invalidateTagged (copy), u66 (copy), u2 (ref), u29 (ref), u30 (ref), u1 (ref), u3 (ref), notifyStat (ref)
        if CollectionService:HasTag(p73, StatTypes.ValueStatTag) then
            invalidateTagged(p73);
            local u74 = u66;
            local u75;

            if u74:IsA("Player") then
                u75 = not u2 and 0 or u74.UserId;
            else
                u75 = u74;
            end;

            if u29[u75] ~= nil then
                if u30[u75] then
                    return;
                end;

                u30[u75] = true;
                task.defer(function() -- Line: 197
                    -- upvalues: u30 (ref), u75 (copy), u29 (ref), u1 (ref), u74 (copy)
                    u30[u75] = nil;
                    local v76 = u29[u75];

                    if v76 == nil then
                        return;
                    end;

                    local ActiveValueStats = u1.GetActiveValueStats(u74);

                    for _, v in table.clone(v76) do
                        task.spawn(v, ActiveValueStats);
                    end;
                end);
            end;
        else
            local v77 = u66;
            local Name = p73.Name;
            local v78;

            if v77:IsA("Player") then
                v78 = not u2 and 0 or v77.UserId;
            else
                v78 = v77;
            end;

            if v78 == 0 then
                u3[Name] = nil;
            else
                local v79 = u3[v78];

                if v79 then
                    v79[Name] = nil;
                end;
            end;

            notifyStat(v77, Name);

            if StatTypes.StatKeyLookup[p73.Name] then
                local u80 = u66;
                local u81;

                if u80:IsA("Player") then
                    u81 = not u2 and 0 or u80.UserId;
                else
                    u81 = u80;
                end;

                if u29[u81] ~= nil then
                    if u30[u81] then
                        return;
                    end;

                    u30[u81] = true;
                    task.defer(function() -- Line: 197
                        -- upvalues: u30 (ref), u81 (copy), u29 (ref), u1 (ref), u80 (copy)
                        u30[u81] = nil;
                        local v82 = u29[u81];

                        if v82 == nil then
                            return;
                        end;

                        local ActiveValueStats = u1.GetActiveValueStats(u80);

                        for _, v in table.clone(v82) do
                            task.spawn(v, ActiveValueStats);
                        end;
                    end);
                end;
            end;
        end;
    end;

    local u83 = {};

    local function bindTagged(u84: userdata) -- Line: 284
        -- upvalues: u83 (copy), StatTypes (ref), u66 (copy), u2 (ref), u3 (ref), notifyStat (ref), u29 (ref), u30 (ref), u1 (ref), u68 (copy), u67 (copy)
        if u83[u84] ~= nil then
            return;
        end;

        local u93 = u84.AttributeChanged:Connect(function(p85: string) -- Line: 286
            -- upvalues: StatTypes (ref), u66 (ref), u2 (ref), u3 (ref), notifyStat (ref), u29 (ref), u30 (ref), u1 (ref)
            if StatTypes.IsMetaAttribute(p85) then
                return;
            end;

            local v86 = u66;
            local v87 = StatTypes.AttributeToStat(p85);
            local v88;

            if v86:IsA("Player") then
                v88 = not u2 and 0 or v86.UserId;
            else
                v88 = v86;
            end;

            if v88 == 0 then
                u3[v87] = nil;
            else
                local v89 = u3[v88];

                if v89 then
                    v89[v87] = nil;
                end;
            end;

            notifyStat(v86, v87);
            local u90 = u66;
            local u91;

            if u90:IsA("Player") then
                u91 = not u2 and 0 or u90.UserId;
            else
                u91 = u90;
            end;

            if u29[u91] ~= nil then
                if u30[u91] then
                    return;
                end;

                u30[u91] = true;
                task.defer(function() -- Line: 197
                    -- upvalues: u30 (ref), u91 (copy), u29 (ref), u1 (ref), u90 (copy)
                    u30[u91] = nil;
                    local v92 = u29[u91];

                    if v92 == nil then
                        return;
                    end;

                    local ActiveValueStats = u1.GetActiveValueStats(u90);

                    for _, v in table.clone(v92) do
                        task.spawn(v, ActiveValueStats);
                    end;
                end);
            end;
        end);
        u83[u84] = u93;
        table.insert(u68, u93);
        local u94 = nil;
        u94 = u84:GetPropertyChangedSignal("Parent"):Connect(function() -- Line: 294
            -- upvalues: u84 (copy), u67 (ref), u93 (copy), u94 (ref), u83 (ref)
            if u84.Parent ~= u67 then
                u93:Disconnect();
                u94:Disconnect();
                u83[u84] = nil;
            end;
        end);
        table.insert(u68, u94);
    end;

    for _, child in u67:GetChildren() do
        if CollectionService:HasTag(child, StatTypes.ValueStatTag) then
            bindTagged(child);
        end;
    end;

    table.insert(u68, u67.ChildAdded:Connect(function(p95) -- Line: 309
        -- upvalues: onChange (copy), CollectionService (ref), StatTypes (ref), bindTagged (copy)
        onChange(p95);

        if CollectionService:HasTag(p95, StatTypes.ValueStatTag) then
            bindTagged(p95);
        end;
    end));
    table.insert(u68, u67.ChildRemoved:Connect(onChange));
    local InstanceAddedSignal = CollectionService:GetInstanceAddedSignal(StatTypes.ValueStatTag);
    table.insert(u68, InstanceAddedSignal:Connect(function(p96) -- Line: 320
        -- upvalues: u67 (copy), bindTagged (copy), invalidateTagged (copy), u66 (copy), u2 (ref), u29 (ref), u30 (ref), u1 (ref)
        if p96.Parent ~= u67 then
            return;
        end;

        bindTagged(p96);
        invalidateTagged(p96);
        local u97 = u66;
        local u98;

        if u97:IsA("Player") then
            u98 = not u2 and 0 or u97.UserId;
        else
            u98 = u97;
        end;

        if u29[u98] ~= nil then
            if u30[u98] then
                return;
            end;

            u30[u98] = true;
            task.defer(function() -- Line: 197
                -- upvalues: u30 (ref), u98 (copy), u29 (ref), u1 (ref), u97 (copy)
                u30[u98] = nil;
                local v99 = u29[u98];

                if v99 == nil then
                    return;
                end;

                local ActiveValueStats = u1.GetActiveValueStats(u97);

                for _, v in table.clone(v99) do
                    task.spawn(v, ActiveValueStats);
                end;
            end);
        end;
    end));
    local InstanceRemovedSignal = CollectionService:GetInstanceRemovedSignal(StatTypes.ValueStatTag);
    table.insert(u68, InstanceRemovedSignal:Connect(function(p100) -- Line: 326
        -- upvalues: u67 (copy), invalidateTagged (copy), u66 (copy), u2 (ref), u29 (ref), u30 (ref), u1 (ref)
        if p100.Parent ~= u67 then
            return;
        end;

        invalidateTagged(p100);
        local u101 = u66;
        local u102;

        if u101:IsA("Player") then
            u102 = not u2 and 0 or u101.UserId;
        else
            u102 = u101;
        end;

        if u29[u102] ~= nil then
            if u30[u102] then
                return;
            end;

            u30[u102] = true;
            task.defer(function() -- Line: 197
                -- upvalues: u30 (ref), u102 (copy), u29 (ref), u1 (ref), u101 (copy)
                u30[u102] = nil;
                local v103 = u29[u102];

                if v103 == nil then
                    return;
                end;

                local ActiveValueStats = u1.GetActiveValueStats(u101);

                for _, v in table.clone(v103) do
                    task.spawn(v, ActiveValueStats);
                end;
            end);
        end;
    end));
end;

local function attachAccessoryWatchers(u104: userdata, p105: userdata, u106: table) -- Line: 333
    -- upvalues: watchSlotValue (copy), u2 (copy), u3 (copy), notifyAll (copy)
    for _, child in p105:GetChildren() do
        watchSlotValue(u104, child, u106);
    end;

    table.insert(u106, p105.ChildAdded:Connect(function(p107) -- Line: 337
        -- upvalues: u104 (copy), u2 (ref), u3 (ref), notifyAll (ref), watchSlotValue (ref), u106 (copy)
        local v108 = u104;
        local v109;

        if v108:IsA("Player") then
            v109 = not u2 and 0 or v108.UserId;
        else
            v109 = v108;
        end;

        if v109 == 0 then
            table.clear(u3);
        else
            u3[v109] = nil;
        end;

        notifyAll(v108);
        watchSlotValue(u104, p107, u106);
    end));
    table.insert(u106, p105.ChildRemoved:Connect(function() -- Line: 341
        -- upvalues: u104 (copy), u2 (ref), u3 (ref), notifyAll (ref)
        local v110 = u104;
        local v111;

        if v110:IsA("Player") then
            v111 = not u2 and 0 or v110.UserId;
        else
            v111 = v110;
        end;

        if v111 == 0 then
            table.clear(u3);
        else
            u3[v111] = nil;
        end;

        notifyAll(v110);
    end));
end;

local function ensureWatchers(u112: userdata) -- Line: 346
    -- upvalues: u4 (copy), Utility (copy), attachValuesFolderWatchers (copy), u1 (copy), attachConfigWatchers (copy), u2 (copy), u3 (copy), notifyAll (copy), ToolLock (copy), u29 (copy), u30 (copy), attachAccessoryWatchers (copy), PlayerProgression (copy)
    if u4[u112] then
        return;
    end;

    local u113 = {
        main = {},
        config = {},
        values = {},
        accessory = {},
        titles = {},
        skilltree = {},
        clan = {},
        character = {}
    };
    u4[u112] = u113;

    if not u112:IsA("Player") then
        local valuesfolder = Utility.getvaluesfolder(u112);

        if valuesfolder ~= nil then
            attachValuesFolderWatchers(u112, valuesfolder, u113.values);
        end;

        table.insert(u113.main, u112.Destroying:Connect(function() -- Line: 372
            -- upvalues: u1 (ref), u112 (copy)
            u1.ClearCache(u112);
        end));

        return;
    end;

    local function bindConfig(p114: userdata) -- Line: 380
        -- upvalues: u113 (copy), attachConfigWatchers (ref), u112 (copy)
        local config = u113.config;

        for _, v in config do
            v:Disconnect();
        end;

        table.clear(config);
        attachConfigWatchers(u112, p114, u113.config);
    end;

    local v115 = u112:FindFirstChild("Items_Config") or u112:FindFirstChild("Items_ConfigServer");

    if v115 then
        local config = u113.config;

        for _, v in config do
            v:Disconnect();
        end;

        table.clear(config);
        attachConfigWatchers(u112, v115, u113.config);
    end;

    table.insert(u113.main, u112.ChildAdded:Connect(function(p116) -- Line: 388
        -- upvalues: u112 (copy), u2 (ref), u3 (ref), notifyAll (ref), u113 (copy), attachConfigWatchers (ref)
        if p116.Name == "Items_Config" or p116.Name == "Items_ConfigServer" then
            local v117 = u112;
            local v118;

            if v117:IsA("Player") then
                v118 = not u2 and 0 or v117.UserId;
            else
                v118 = v117;
            end;

            if v118 == 0 then
                table.clear(u3);
            else
                u3[v118] = nil;
            end;

            notifyAll(v117);
            local config = u113.config;

            for _, v in config do
                v:Disconnect();
            end;

            table.clear(config);
            attachConfigWatchers(u112, p116, u113.config);
        end;
    end));

    local function bindCharacter(p119: userdata) -- Line: 401
        -- upvalues: u113 (copy), ToolLock (ref), u112 (copy), u2 (ref), u3 (ref), notifyAll (ref)
        local character = u113.character;

        for _, v in character do
            v:Disconnect();
        end;

        table.clear(character);
        local character2 = u113.character;
        local AttributeChangedSignal = p119:GetAttributeChangedSignal(ToolLock.Attribute);
        table.insert(character2, AttributeChangedSignal:Connect(function() -- Line: 403
            -- upvalues: u112 (ref), u2 (ref), u3 (ref), notifyAll (ref)
            local v120 = u112;
            local v121;

            if v120:IsA("Player") then
                v121 = not u2 and 0 or v120.UserId;
            else
                v121 = v120;
            end;

            if v121 == 0 then
                table.clear(u3);
            else
                u3[v121] = nil;
            end;

            notifyAll(v120);
        end));
        local v122 = u112;
        local v123;

        if v122:IsA("Player") then
            v123 = not u2 and 0 or v122.UserId;
        else
            v123 = v122;
        end;

        if v123 == 0 then
            table.clear(u3);
        else
            u3[v123] = nil;
        end;

        notifyAll(v122);
    end;

    if u112.Character ~= nil then
        bindCharacter(u112.Character);
    end;

    table.insert(u113.main, u112.CharacterAdded:Connect(bindCharacter));
    task.spawn(function() -- Line: 420
        -- upvalues: Utility (ref), u112 (copy), u4 (ref), u112 (copy), u113 (copy), attachValuesFolderWatchers (ref), u2 (ref), u3 (ref), notifyAll (ref), u29 (ref), u30 (ref), u1 (ref)
        local valuesfolder = Utility.getvaluesfolder(u112, true);

        if u4[u112] ~= u113 then
            return;
        end;

        if valuesfolder and valuesfolder:IsA("Folder") then
            attachValuesFolderWatchers(u112, valuesfolder, u113.values);
            local v124 = u112;
            local v125;

            if v124:IsA("Player") then
                v125 = not u2 and 0 or v124.UserId;
            else
                v125 = v124;
            end;

            if v125 == 0 then
                table.clear(u3);
            else
                u3[v125] = nil;
            end;

            notifyAll(v124);
            local u126 = u112;
            local u127;

            if u126:IsA("Player") then
                u127 = not u2 and 0 or u126.UserId;
            else
                u127 = u126;
            end;

            if u29[u127] ~= nil then
                if u30[u127] then
                    return;
                end;

                u30[u127] = true;
                task.defer(function() -- Line: 197
                    -- upvalues: u30 (ref), u127 (copy), u29 (ref), u1 (ref), u126 (copy)
                    u30[u127] = nil;
                    local v128 = u29[u127];

                    if v128 == nil then
                        return;
                    end;

                    local ActiveValueStats = u1.GetActiveValueStats(u126);

                    for _, v in table.clone(v128) do
                        task.spawn(v, ActiveValueStats);
                    end;
                end);
            end;
        end;
    end);
    local u129 = 0;

    local function bindSlotFolders() -- Line: 435
        -- upvalues: u129 (ref), u113 (copy), Utility (ref), u112 (copy), u4 (ref), u112 (copy), attachAccessoryWatchers (ref), u2 (ref), u3 (ref), notifyAll (ref), PlayerProgression (ref)
        u129 = u129 + 1;
        local u130 = u129;
        local accessory = u113.accessory;

        for _, v in accessory do
            v:Disconnect();
        end;

        table.clear(accessory);
        local titles = u113.titles;

        for _, v in titles do
            v:Disconnect();
        end;

        table.clear(titles);
        local skilltree = u113.skilltree;

        for _, v in skilltree do
            v:Disconnect();
        end;

        table.clear(skilltree);
        local clan = u113.clan;

        for _, v in clan do
            v:Disconnect();
        end;

        table.clear(clan);
        task.spawn(function() -- Line: 445
            -- upvalues: Utility (ref), u112 (ref), u4 (ref), u112 (ref), u113 (ref), u129 (ref), u130 (copy), attachAccessoryWatchers (ref), u2 (ref), u3 (ref), notifyAll (ref)
            local Data = Utility.GetData(u112, true);

            if u4[u112] ~= u113 or u129 ~= u130 then
                return;
            end;

            if not Data then
                return;
            end;

            local Inventory = Data:WaitForChild("Inventory", 60);

            if u4[u112] ~= u113 or (u129 ~= u130 or not Inventory) then
                return;
            end;

            local Toolbar = Inventory:WaitForChild("Toolbar", 60);

            if u4[u112] ~= u113 or (u129 ~= u130 or not Toolbar) then
                return;
            end;

            attachAccessoryWatchers(u112, Toolbar, u113.accessory);
            local Accessories = Inventory:WaitForChild("Accessories", 60);

            if u4[u112] ~= u113 or (u129 ~= u130 or not Accessories) then
                return;
            end;

            local Stats = Accessories:WaitForChild("Stats", 60);

            if u4[u112] ~= u113 or (u129 ~= u130 or not Stats) then
                return;
            end;

            attachAccessoryWatchers(u112, Stats, u113.accessory);
            local v131 = u112;
            local v132;

            if v131:IsA("Player") then
                v132 = not u2 and 0 or v131.UserId;
            else
                v132 = v131;
            end;

            if v132 == 0 then
                table.clear(u3);
            else
                u3[v132] = nil;
            end;

            notifyAll(v131);
        end);
        task.spawn(function() -- Line: 465
            -- upvalues: Utility (ref), u112 (ref), u4 (ref), u112 (ref), u113 (ref), u129 (ref), u130 (copy), attachAccessoryWatchers (ref), u2 (ref), u3 (ref), notifyAll (ref)
            local Data, v133 = Utility.GetData(u112, true);

            if u4[u112] ~= u113 or u129 ~= u130 then
                return;
            end;

            if not Data then
                return;
            end;

            local EquippedTitles = Data:WaitForChild("EquippedTitles", 60);

            if u4[u112] ~= u113 or (u129 ~= u130 or not EquippedTitles) then
                return;
            end;

            local Boost = EquippedTitles:WaitForChild("Boost", 60);

            if u4[u112] ~= u113 or (u129 ~= u130 or not Boost) then
                return;
            end;

            local Unlocked = v133.PlayerTitles:WaitForChild("Unlocked", 60);

            if u4[u112] ~= u113 or (u129 ~= u130 or not Unlocked) then
                return;
            end;

            attachAccessoryWatchers(u112, Boost, u113.titles);
            attachAccessoryWatchers(u112, Unlocked, u113.titles);
            local v134 = u112;
            local v135;

            if v134:IsA("Player") then
                v135 = not u2 and 0 or v134.UserId;
            else
                v135 = v134;
            end;

            if v135 == 0 then
                table.clear(u3);
            else
                u3[v135] = nil;
            end;

            notifyAll(v134);
        end);
        task.spawn(function() -- Line: 485
            -- upvalues: Utility (ref), u112 (ref), u4 (ref), u112 (ref), u113 (ref), u129 (ref), u130 (copy), attachAccessoryWatchers (ref), u2 (ref), u3 (ref), notifyAll (ref)
            local Data = Utility.GetData(u112, true);

            if u4[u112] ~= u113 or u129 ~= u130 then
                return;
            end;

            if not Data then
                return;
            end;

            local SkillTreeUnlockedList = Data:WaitForChild("SkillTreeUnlockedList", 60);

            if u4[u112] ~= u113 or (u129 ~= u130 or not SkillTreeUnlockedList) then
                return;
            end;

            attachAccessoryWatchers(u112, SkillTreeUnlockedList, u113.skilltree);
            local v136 = u112;
            local v137;

            if v136:IsA("Player") then
                v137 = not u2 and 0 or v136.UserId;
            else
                v137 = v136;
            end;

            if v137 == 0 then
                table.clear(u3);
            else
                u3[v137] = nil;
            end;

            notifyAll(v136);
        end);
        task.spawn(function() -- Line: 499
            -- upvalues: Utility (ref), u112 (ref), u4 (ref), u112 (ref), u113 (ref), u129 (ref), u130 (copy), u2 (ref), u3 (ref), notifyAll (ref)
            local Data = Utility.GetData(u112, true);

            if u4[u112] ~= u113 or u129 ~= u130 then
                return;
            end;

            if not Data then
                return;
            end;

            local Clan = Data:WaitForChild("Clan", 60);

            if u4[u112] ~= u113 or (u129 ~= u130 or not (Clan and Clan:IsA("ValueBase"))) then
                return;
            end;

            local clan2 = u113.clan;
            local PropertyChangedSignal = Clan:GetPropertyChangedSignal("Value");
            table.insert(clan2, PropertyChangedSignal:Connect(function() -- Line: 505
                -- upvalues: u112 (ref), u2 (ref), u3 (ref), notifyAll (ref)
                local v138 = u112;
                local v139;

                if v138:IsA("Player") then
                    v139 = not u2 and 0 or v138.UserId;
                else
                    v139 = v138;
                end;

                if v139 == 0 then
                    table.clear(u3);
                else
                    u3[v139] = nil;
                end;

                notifyAll(v138);
            end));
            local v140 = u112;
            local v141;

            if v140:IsA("Player") then
                v141 = not u2 and 0 or v140.UserId;
            else
                v141 = v140;
            end;

            if v141 == 0 then
                table.clear(u3);
            else
                u3[v141] = nil;
            end;

            notifyAll(v140);
        end);
        task.spawn(function() -- Line: 515
            -- upvalues: Utility (ref), u112 (ref), u4 (ref), u112 (ref), u113 (ref), u129 (ref), u130 (copy), u2 (ref), u3 (ref), notifyAll (ref)
            local Data = Utility.GetData(u112, true);

            if u4[u112] ~= u113 or u129 ~= u130 then
                return;
            end;

            if not Data then
                return;
            end;

            local Powers = Data:WaitForChild("Powers", 60);

            if u4[u112] ~= u113 or (u129 ~= u130 or not Powers) then
                return;
            end;

            for _, v in { "Breathing", "DemonArt" } do
                local v142 = Powers:FindFirstChild(v);

                if v142 ~= nil and v142:IsA("ValueBase") then
                    local clan2 = u113.clan;
                    local PropertyChangedSignal = v142:GetPropertyChangedSignal("Value");
                    table.insert(clan2, PropertyChangedSignal:Connect(function() -- Line: 524
                        -- upvalues: u112 (ref), u2 (ref), u3 (ref), notifyAll (ref)
                        local v143 = u112;
                        local v144;

                        if v143:IsA("Player") then
                            v144 = not u2 and 0 or v143.UserId;
                        else
                            v144 = v143;
                        end;

                        if v144 == 0 then
                            table.clear(u3);
                        else
                            u3[v144] = nil;
                        end;

                        notifyAll(v143);
                    end));
                end;
            end;

            local Race = Data:FindFirstChild("Race");

            if Race ~= nil and Race:IsA("ValueBase") then
                local clan2 = u113.clan;
                local PropertyChangedSignal = Race:GetPropertyChangedSignal("Value");
                table.insert(clan2, PropertyChangedSignal:Connect(function() -- Line: 531
                    -- upvalues: u112 (ref), u2 (ref), u3 (ref), notifyAll (ref)
                    local v145 = u112;
                    local v146;

                    if v145:IsA("Player") then
                        v146 = not u2 and 0 or v145.UserId;
                    else
                        v146 = v145;
                    end;

                    if v146 == 0 then
                        table.clear(u3);
                    else
                        u3[v146] = nil;
                    end;

                    notifyAll(v145);
                end));
            end;

            local v147 = u112;
            local v148;

            if v147:IsA("Player") then
                v148 = not u2 and 0 or v147.UserId;
            else
                v148 = v147;
            end;

            if v148 == 0 then
                table.clear(u3);
            else
                u3[v148] = nil;
            end;

            notifyAll(v147);
        end);
        task.spawn(function() -- Line: 542
            -- upvalues: Utility (ref), u112 (ref), u4 (ref), u112 (ref), u113 (ref), u129 (ref), u130 (copy), PlayerProgression (ref), u2 (ref), u3 (ref), notifyAll (ref)
            local Data = Utility.GetData(u112, true);

            if u4[u112] ~= u113 or u129 ~= u130 then
                return;
            end;

            if not Data then
                return;
            end;

            local Progression = Data:WaitForChild("Progression", 60);

            if u4[u112] ~= u113 or (u129 ~= u130 or not Progression) then
                return;
            end;

            for _, v in PlayerProgression.Sides do
                local v149 = Progression:FindFirstChild(v);
                local v150;

                if v149 == nil then
                    v150 = nil;
                else
                    v150 = v149:FindFirstChild("Max") or nil;
                end;

                if v150 ~= nil and v150:IsA("ValueBase") then
                    local clan2 = u113.clan;
                    local PropertyChangedSignal = v150:GetPropertyChangedSignal("Value");
                    table.insert(clan2, PropertyChangedSignal:Connect(function() -- Line: 552
                        -- upvalues: u112 (ref), u2 (ref), u3 (ref), notifyAll (ref)
                        local v151 = u112;
                        local v152;

                        if v151:IsA("Player") then
                            v152 = not u2 and 0 or v151.UserId;
                        else
                            v152 = v151;
                        end;

                        if v152 == 0 then
                            table.clear(u3);
                        else
                            u3[v152] = nil;
                        end;

                        notifyAll(v151);
                    end));
                end;
            end;

            local v153 = u112;
            local v154;

            if v153:IsA("Player") then
                v154 = not u2 and 0 or v153.UserId;
            else
                v154 = v153;
            end;

            if v154 == 0 then
                table.clear(u3);
            else
                u3[v154] = nil;
            end;

            notifyAll(v153);
        end);
    end;

    bindSlotFolders();
    task.spawn(function() -- Line: 563
        -- upvalues: Utility (ref), u112 (copy), u4 (ref), u112 (copy), u113 (copy), bindSlotFolders (copy), u2 (ref), u3 (ref), notifyAll (ref)
        local _, _, v155 = Utility.GetData(u112, true);

        if u4[u112] ~= u113 then
            return;
        end;

        if v155 == nil or not v155:IsA("ValueBase") then
            return;
        end;

        local main = u113.main;
        local PropertyChangedSignal = v155:GetPropertyChangedSignal("Value");
        table.insert(main, PropertyChangedSignal:Connect(function() -- Line: 567
            -- upvalues: bindSlotFolders (ref), u112 (ref), u2 (ref), u3 (ref), notifyAll (ref)
            bindSlotFolders();
            local v156 = u112;
            local v157;

            if v156:IsA("Player") then
                v157 = not u2 and 0 or v156.UserId;
            else
                v157 = v156;
            end;

            if v157 == 0 then
                table.clear(u3);
            else
                u3[v157] = nil;
            end;

            notifyAll(v156);
        end));
    end);
end;

local function resolveMasteryData(p158: any, p159: string) -- Line: 574
    -- upvalues: gameSettings (copy)
    if p158 == nil or type(p158.Mastery) ~= "string" then
        if p158 ~= nil and type(p158.Mastery) == "table" then
            p159 = p158.Mastery.Value or p159;
        end;
    else
        p159 = p158.Mastery;
    end;

    return p159, p158 ~= nil and type(p158.Mastery) == "table" and p158.Mastery.IncrementAmount or gameSettings.expPerMasteryDefault;
end;

local function _resolveSource(p160: userdata, p161: string) -- Line: 587
    -- upvalues: StatTypes (copy), Utility (copy), CollectionService (copy), PlayerProfile (copy), MasterySource (copy), resolveMasteryData (copy), SkillTreeConfig (copy), Character_info_provider (copy), Items (copy), ToolLock (copy), Clans (copy), Breathings (copy), DemonArts (copy), PlayerProgression (copy), Titles (copy)
    if not p160:IsA("Player") then
        local v162 = {};
        local Attribute = p160:GetAttribute(StatTypes.StatToAttribute(p161));

        if typeof(Attribute) == "number" or typeof(Attribute) == "boolean" then
            v162.NpcStats = true;
        end;

        local valuesfolder = Utility.getvaluesfolder(p160);

        if valuesfolder ~= nil then
            if valuesfolder:FindFirstChild(p161) ~= nil then
                v162.ValueFolder = true;

                return v162;
            end;

            local v163 = StatTypes.StatToAttribute(p161);

            for _, child in valuesfolder:GetChildren() do
                local v164;

                if CollectionService:HasTag(child, StatTypes.ValueStatTag) then
                    v164 = child:GetAttribute(v163) or nil;
                else
                    v164 = nil;
                end;

                if typeof(v164) == "number" or (typeof(v164) == "boolean" or typeof(v164) == "string") then
                    v162.ValueFolder = true;

                    return v162;
                end;
            end;
        end;

        return v162;
    end;

    local v165 = PlayerProfile.skill_info[p161];

    if v165 ~= nil and v165.Category then
        local Category = v165.Category;
        local v166 = MasterySource(Category);

        if v166 ~= nil and v166.Mastery == false then
            return {};
        end;

        local v167, v168 = resolveMasteryData(v166, Category);

        return "Mastery", {
            name = v167,
            incrementAmount = v168
        };
    end;

    if PlayerProfile.mastery_categories._index and PlayerProfile.mastery_categories._index[p161] then
        local v169, v170 = resolveMasteryData(MasterySource(p161), p161);

        return "Mastery", {
            name = v169,
            incrementAmount = v170
        };
    end;

    if PlayerProfile.mastery_name_set[p161] then
        return "Mastery", p161;
    end;

    local v171 = {};

    if SkillTreeConfig[p161] then
        v171.SkillTree = true;
    end;

    local v172 = Character_info_provider.getEquippedItems(p160) or {};
    local v173 = Character_info_provider.getEquippedAccessoryStats(p160) or {};

    for _, v in ipairs(v172) do
        local v174 = Items[v];

        if v174 then
            local ToolbarStats = v174.ToolbarStats;

            if ToolbarStats then
                if v174.ToolbarStats[p161] == nil then
                    ToolbarStats = false;
                else
                    ToolbarStats = v174.ToolbarStats[p161] ~= 0;
                end;
            end;

            local v175;

            if ToolbarStats or not v174.Skills then
                v175 = v;
            else
                v175 = v;

                for _, v2 in ipairs(v174.Skills) do
                    if v2.ToolbarStats and (v2.ToolbarStats[p161] ~= nil and v2.ToolbarStats[p161] ~= 0) then
                        ToolbarStats = true;
                        break;
                    end;
                end;
            end;

            if ToolbarStats then
                if v171.ToolbarEquipped == nil then
                    v171.ToolbarEquipped = {};
                end;

                table.insert(v171.ToolbarEquipped, v175);
            end;

            if v174.Skills then
                for _, v2 in ipairs(v174.Skills) do
                    if v2.PerformanceStats and (v2.PerformanceStats[p161] ~= nil and v2.PerformanceStats[p161] ~= 0) then
                        v171.PerformanceStats = true;
                        break;
                    end;
                end;
            end;
        end;
    end;

    local v176 = ToolLock.SlotOf(p160);
    local v177;

    if v176 == nil then
        v177 = Character_info_provider.Get_equipped_tool(p160);
    else
        v177 = Character_info_provider.getEquippedItems(p160, v176);

        if typeof(v177) ~= "Instance" then
            v177 = nil;
        end;
    end;

    if v177 ~= nil then
        local Name = v177.Name;
        local v178 = Items[Name];

        if v178 then
            local ActiveToolStats = v178.ActiveToolStats;

            if ActiveToolStats then
                if v178.ActiveToolStats[p161] == nil then
                    ActiveToolStats = false;
                else
                    ActiveToolStats = v178.ActiveToolStats[p161] ~= 0;
                end;
            end;

            if not ActiveToolStats and v178.Skills then
                for _, v in ipairs(v178.Skills) do
                    if v.ActiveToolStats and (v.ActiveToolStats[p161] ~= nil and v.ActiveToolStats[p161] ~= 0) then
                        ActiveToolStats = true;
                        break;
                    end;
                end;
            end;

            if ActiveToolStats then
                v171.ActiveTool = { Name };

                if typeof(v177) == "Instance" then
                    v171.ActiveTool.Entry = v177;
                end;
            end;
        end;
    end;

    for _, v in ipairs(v173) do
        local v179 = Items[v];

        if v179 and (v179.Stats and (v179.Stats[p161] ~= nil and v179.Stats[p161] ~= 0)) then
            if v171.Accessory == nil then
                v171.Accessory = {};
            end;

            table.insert(v171.Accessory, v);
        end;
    end;

    local Data = Utility.GetData(p160);
    local v180;

    if Data == nil then
        v180 = nil;
    else
        v180 = Data:FindFirstChild("Clan") or nil;
    end;

    local v181;

    if v180 == nil then
        v181 = nil;
    else
        v181 = Clans.GetClan(v180.Value) or nil;
    end;

    local v182;

    if v181 == nil or v181.stats == nil then
        v182 = nil;
    else
        v182 = v181.stats[p161] or nil;
    end;

    if v182 ~= nil and v182 ~= 0 then
        v171.Clan = true;
    end;

    for _, v in Character_info_provider.GetEquippedPowers(p160) do
        local v183 = Breathings[v] or DemonArts[v];
        local v184;

        if v183 == nil or v183.Stats == nil then
            v184 = nil;
        else
            v184 = v183.Stats[p161] or nil;
        end;

        if v184 ~= nil and v184 ~= 0 then
            v171.Power = true;
            break;
        end;
    end;

    if PlayerProgression.GetStatTotal(p160, p161) ~= 0 then
        v171.Progression = true;
    end;

    local valuesfolder = Utility.getvaluesfolder(p160);

    if valuesfolder ~= nil then
        if valuesfolder:FindFirstChild(p161) == nil then
            local v185 = StatTypes.StatToAttribute(p161);

            for _, child in valuesfolder:GetChildren() do
                local v186;

                if CollectionService:HasTag(child, StatTypes.ValueStatTag) then
                    v186 = child:GetAttribute(v185) or nil;
                else
                    v186 = nil;
                end;

                if typeof(v186) == "number" or (typeof(v186) == "boolean" or typeof(v186) == "string") then
                    v171.ValueFolder = true;
                    break;
                end;
            end;
        else
            v171.ValueFolder = true;
        end;
    end;

    if Titles.GetStatBonus(p160, p161) ~= 0 then
        v171.Titles = true;
    end;

    return v171;
end;

function getStatSource(p187: userdata, p188: string)
    -- upvalues: u2 (copy), u3 (copy), ensureWatchers (copy), _resolveSource (copy)
    local v189;

    if p187:IsA("Player") then
        v189 = not u2 and 0 or p187.UserId;
    else
        v189 = p187;
    end;

    local v190;

    if v189 == 0 then
        v190 = u3;
    else
        v190 = u3[v189];

        if v190 == nil then
            v190 = {};
            u3[v189] = v190;
        end;
    end;

    local v191 = v190[p188];

    if v191 ~= nil then
        return v191[1], v191[2];
    end;

    ensureWatchers(p187);
    local v192, v193 = _resolveSource(p187, p188);
    v190[p188] = { v192, v193 };

    return v192, v193;
end;

local u194 = {
    Accessory = require(script.Solvers.Accessory),
    Clan = require(script.Solvers.Clan),
    Power = require(script.Solvers.Power),
    NpcStats = require(script.Solvers.NpcStats),
    Mastery = require(script.Solvers.Mastery),
    SkillTree = require(script.Solvers.SkillTree),
    ToolbarEquipped = require(script.Solvers.ToolbarEquipped),
    ActiveTool = require(script.Solvers.ActiveTool),
    PerformanceStats = require(script.Solvers.PerformanceStats),
    ValueFolder = require(script.Solvers.ValueFolder),
    Titles = require(script.Solvers.Titles),
    Progression = require(script.Solvers.Progression)
};

local function computeStat(p195: userdata, p196: string, p197: string?, p198: any, p199: string?, p200: boolean?) -- Line: 817
    -- upvalues: u194 (copy), StatTypes (copy)
    if p197 ~= nil then
        local v201 = u194[p197];

        if v201 == nil then
            return 0;
        end;

        if p198 == nil or not p198 then
            p198 = p196;
        end;

        return v201(p195, p196, p198, true, p200) or 0;
    end;

    local v202, v203 = getStatSource(p195, p196);

    if v202 == "Mastery" then
        return p199 == "Mastery" and 0 or u194.Mastery(p195, p196, v203);
    end;

    if next(v202) == nil then
        return nil;
    end;

    local v204 = StatTypes.HighestOnlyStats[p196] == true;
    local v205 = 0;

    for i, v in v202 do
        if i ~= p199 then
            local v206 = u194[i];

            if v206 then
                local v207 = v206(p195, p196, v, true, p200) or 0;

                if v207 == true then
                    return true;
                end;

                if typeof(v207) == "number" then
                    if v204 then
                        v205 = math.max(v205, v207);
                    else
                        v205 = v205 + v207;
                    end;
                end;
            end;
        end;
    end;

    return v205;
end;

function u1.GetStat(p208: userdata, p209: string, p210: string?, p211: any, p212: boolean?) -- Line: 863
    -- upvalues: computeStat (copy)
    if p208 ~= nil and (p209 ~= nil and typeof(p208) == "Instance") then
        local v213 = computeStat(p208, p209, p210, p211, nil, p212);

        if typeof(v213) == "number" then
            return math.round(v213 * 1000) / 1000;
        end;

        return v213;
    end;
end;

function u1.GetStatExcept(p214: userdata, p215: string, p216: string) -- Line: 874
    -- upvalues: computeStat (copy)
    if p214 ~= nil and (p215 ~= nil and typeof(p214) == "Instance") then
        local v217 = computeStat(p214, p215, nil, nil, p216);

        if typeof(v217) == "number" then
            return math.round(v217 * 1000) / 1000;
        end;

        return v217;
    end;
end;

function u1.Attach(p218: userdata, u219: string, p220: any, p221: any, p222: any) -- Line: 886
    -- upvalues: u2 (copy), u5 (copy), ensureWatchers (copy), u1 (copy)
    local v223;

    if type(p220) == "function" then
        v223 = nil;
        p221 = nil;
    else
        v223 = p220;
        p220 = p222;
    end;

    local v224 = type(p220) == "function";
    assert(v224, "PlayerStatResolver.Attach requires a callback");
    local u225;

    if p218:IsA("Player") then
        u225 = not u2 and 0 or p218.UserId;
    else
        u225 = p218;
    end;

    local v226 = u5[u225];

    if v226 == nil then
        v226 = {};
        u5[u225] = v226;
    end;

    if v226[u219] == nil then
        v226[u219] = {};
    end;

    local u227 = {
        callback = p220,
        resolver = v223,
        data = p221
    };
    table.insert(v226[u219], u227);
    ensureWatchers(p218);
    task.spawn(p220, u1.GetStat(p218, u219, v223, p221));

    return function() -- Line: 911
        -- upvalues: u5 (ref), u225 (copy), u219 (copy), u227 (copy)
        local v228 = u5[u225] and u5[u225][u219];

        if not v228 then
            return;
        end;

        local table_find_ret = table.find(v228, u227);

        if table_find_ret then
            table.remove(v228, table_find_ret);
        end;

        if #v228 == 0 then
            u5[u225][u219] = nil;
        end;
    end;
end;

function u1.AttachActiveStats(p229: userdata, u230: function) -- Line: 926
    -- upvalues: u2 (copy), u29 (copy), ensureWatchers (copy), u1 (copy)
    local v231 = type(u230) == "function";
    assert(v231, "PlayerStatResolver.AttachActiveStats requires a callback");
    local u232;

    if p229:IsA("Player") then
        u232 = not u2 and 0 or p229.UserId;
    else
        u232 = p229;
    end;

    local v233 = u29[u232];

    if v233 == nil then
        v233 = {};
        u29[u232] = v233;
    end;

    table.insert(v233, u230);
    ensureWatchers(p229);
    task.spawn(u230, u1.GetActiveValueStats(p229));

    return function() -- Line: 939
        -- upvalues: u29 (ref), u232 (copy), u230 (copy)
        local v234 = u29[u232];

        if v234 == nil then
            return;
        end;

        local table_find_ret = table.find(v234, u230);

        if table_find_ret then
            table.remove(v234, table_find_ret);
        end;

        if #v234 == 0 then
            u29[u232] = nil;
        end;
    end;
end;

function u1.AttachActiveStatEvents(p235: userdata, u236: table) -- Line: 962
    -- upvalues: u1 (copy)
    local u237 = {};

    return u1.AttachActiveStats(p235, function(p238) -- Line: 964
        -- upvalues: u237 (ref), u236 (copy)
        for i, v in u237 do
            if p238[i] == nil and u236.Removed then
                task.spawn(u236.Removed, i, v);
            end;
        end;

        for i, v in p238 do
            local v239 = u237[i];

            if v239 == nil then
                if u236.Added then
                    task.spawn(u236.Added, i, v);
                end;
            elseif v239 ~= v and u236.Changed then
                task.spawn(u236.Changed, i, v, v239);
            end;
        end;

        u237 = p238;
    end);
end;

function u1.GetMovementMultiplier(p240: userdata) -- Line: 990
    -- upvalues: u1 (copy), gameSettings (copy)
    local v241 = u1.GetStat(p240, "Movement Speed Factor") or 0;
    local v242 = gameSettings.movementFactorFloor or -0.9;

    if v241 < v242 then
        v241 = v242;
    end;

    local movementFactorSoftCap = gameSettings.movementFactorSoftCap;

    if movementFactorSoftCap ~= nil and movementFactorSoftCap < v241 then
        v241 = movementFactorSoftCap + (v241 - movementFactorSoftCap) * (gameSettings.movementFactorExcessRate or 0);
    end;

    local movementFactorHardCap = gameSettings.movementFactorHardCap;

    if movementFactorHardCap == nil then
        movementFactorHardCap = v241;
    elseif movementFactorHardCap >= v241 then
        movementFactorHardCap = v241;
    end;

    return 1 + movementFactorHardCap;
end;

function u1.Invalidate(p243: userdata, p244: string) -- Line: 1013
    -- upvalues: u2 (copy), u3 (copy)
    if p243:IsA("Player") then
        p243 = not u2 and 0 or p243.UserId;
    end;

    if p243 == 0 then
        u3[p244] = nil;

        return;
    end;

    local v245 = u3[p243];

    if v245 then
        v245[p244] = nil;
    end;
end;

function u1.Init(p246: userdata) -- Line: 1022
    -- upvalues: u4 (copy), ensureWatchers (copy)
    local v247 = u4[p246];

    if v247 then
        for _, v in v247 do
            for _, v2 in v do
                v2:Disconnect();
            end;

            table.clear(v);
        end;

        u4[p246] = nil;
    end;

    ensureWatchers(p246);
end;

function u1.ClearCache(p248: userdata) -- Line: 1035
    -- upvalues: u2 (copy), u3 (copy), u4 (copy), u5 (copy), u29 (copy), u30 (copy)
    local v249;

    if p248:IsA("Player") then
        v249 = not u2 and 0 or p248.UserId;
    else
        v249 = p248;
    end;

    if v249 == 0 then
        table.clear(u3);
    else
        u3[v249] = nil;
    end;

    local v250 = u4[p248];

    if v250 then
        local main = v250.main;

        for _, v in main do
            v:Disconnect();
        end;

        table.clear(main);
        local config = v250.config;

        for _, v in config do
            v:Disconnect();
        end;

        table.clear(config);
        local values = v250.values;

        for _, v in values do
            v:Disconnect();
        end;

        table.clear(values);
        local accessory = v250.accessory;

        for _, v in accessory do
            v:Disconnect();
        end;

        table.clear(accessory);
        local titles = v250.titles;

        for _, v in titles do
            v:Disconnect();
        end;

        table.clear(titles);
        local skilltree = v250.skilltree;

        for _, v in skilltree do
            v:Disconnect();
        end;

        table.clear(skilltree);
        local clan = v250.clan;

        for _, v in clan do
            v:Disconnect();
        end;

        table.clear(clan);
        u4[p248] = nil;
    end;

    if not p248:IsA("Player") then
        if p248:IsA("Player") then
            p248 = not u2 and 0 or p248.UserId;
        end;

        u5[p248] = nil;
        u29[p248] = nil;
        u30[p248] = nil;
    end;
end;

function u1.Release(p251: userdata) -- Line: 1058
    -- upvalues: u1 (copy), u2 (copy), u5 (copy), u29 (copy), u30 (copy)
    u1.ClearCache(p251);

    if p251:IsA("Player") then
        p251 = not u2 and 0 or p251.UserId;
    end;

    u5[p251] = nil;
    u29[p251] = nil;
    u30[p251] = nil;
end;

return u1;
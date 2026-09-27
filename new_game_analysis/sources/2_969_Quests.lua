-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local MarkerHandler = require(ReplicatedStorage.CAM.Client.Modules.MarkerHandler);
local BunchaIcons = require(ReplicatedStorage.CAM.Global.BunchaIcons);
local Quests = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests);
local Regions = require(ReplicatedStorage.Regions);

local function resolveNpcTop(p1: string) -- Line: 12
    -- upvalues: Regions (copy)
    local Debree = workspace:FindFirstChild("Debree");
    local v2;

    if Debree == nil then
        v2 = nil;
    else
        v2 = Debree:FindFirstChild("Regions") or nil;
    end;

    if v2 ~= nil then
        for _, child in v2:GetChildren() do
            local StationaryNpcs = child:FindFirstChild("StationaryNpcs");
            local v3;

            if StationaryNpcs == nil then
                v3 = false;
            else
                v3 = StationaryNpcs:FindFirstChild(p1);
            end;

            if v3 then
                return v3:GetAttribute("Top") or v3:GetPivot().Position;
            end;
        end;
    end;

    local NpcSpawn = Regions.GetNpcSpawn(p1);

    if NpcSpawn == nil then
        return nil;
    end;

    return NpcSpawn + Vector3.new(0, 5, 0);
end;

local Color3_fromRGB_ret = Color3.fromRGB(255, 60, 60);
local Color3_new_ret = Color3.new(1, 1, 1);
local u4 = {
    Combat = Color3_fromRGB_ret,
    BossHunt = Color3_fromRGB_ret
};

local function onMapToo(p5: table, p6: string) -- Line: 44
    -- upvalues: u4 (copy), Quests (copy), Color3_new_ret (copy)
    local table_clone_ret = table.clone(p5);
    table_clone_ret.onMap = true;
    table_clone_ret.ping = u4[Quests.GetQuestCategory(p6)] or Color3_new_ret;

    return table_clone_ret;
end;

return function(p7: userdata, p8: userdata) -- Line: 53
    -- upvalues: Quests (copy), BunchaIcons (copy), resolveNpcTop (copy), MarkerHandler (copy), u4 (copy), Color3_new_ret (copy), Regions (copy)
    local function taskMarkerKey(p9: string, p10: string) -- Line: 54
        return p9 .. " - " .. p10;
    end;

    local u11 = {};
    local u12 = {};

    local function questAdded(p13: userdata) -- Line: 67
        -- upvalues: Quests (ref), BunchaIcons (ref), resolveNpcTop (ref), MarkerHandler (ref), u4 (ref), Color3_new_ret (ref), u11 (copy), u12 (copy), Regions (ref)
        local Name = p13.Name;
        local QuestString = p13:FindFirstChild("QuestString");
        local u14;

        if QuestString == nil then
            u14 = Name;
        else
            u14 = QuestString.Value or Name;
        end;

        local u15 = Quests.Holder[u14];

        if u15 == nil then
            return;
        end;

        local MarkerData = u15.MarkerData;
        local v16 = MarkerData == nil and u15.Position ~= nil and {
            minDistance = 35,
            margin = 10,
            position = u15.Position,
            img = BunchaIcons[u15.Category] or BunchaIcons.Combat
        } or MarkerData;

        if v16 ~= nil then
            if v16.position == nil then
                local Npc = v16.Npc;

                if not Npc then
                    if v16.useName == nil then
                        Npc = nil;
                    else
                        Npc = string.match(v16.useName, "^(.+)%-AddedByAreaLocator$") or nil;
                    end;
                end;

                local v17;

                if Npc == nil then
                    v17 = nil;
                else
                    v17 = resolveNpcTop(Npc) or nil;
                end;

                if v17 ~= nil then
                    v16 = table.clone(v16);
                    v16.position = v17;
                end;
            end;

            if v16.position ~= nil then
                local addMarker = MarkerHandler.addMarker;
                local table_clone_ret = table.clone(v16);
                table_clone_ret.onMap = true;
                table_clone_ret.ping = u4[Quests.GetQuestCategory(u14)] or Color3_new_ret;
                addMarker(Name, table_clone_ret);
            end;
        end;

        local v18 = {};
        u11[Name] = v18;
        local v19 = {};
        u12[Name] = v19;

        for _, child in ipairs(p13.Tasks:GetChildren()) do
            local TaskMarker = Quests.GetTaskMarker(u15, child);
            local u20 = nil;
            local u21;

            if TaskMarker == nil then
                u21 = nil;
            else
                u21 = TaskMarker.Position;

                if TaskMarker.Npc ~= nil then
                    u21 = u21 or resolveNpcTop(TaskMarker.Npc);
                    u20 = TaskMarker.Npc .. "-AddedByAreaLocator";
                end;
            end;

            if TaskMarker ~= nil and u21 ~= nil then
                local Value = child.Value;
                local Max = child.Max;
                local u22 = Name .. " - " .. child.Name;
                table.insert(v19, u22);
                local u23 = {};
                local v24;

                if TaskMarker.After == nil then
                    v24 = child;
                else
                    v24 = child;

                    for _, v in ipairs(TaskMarker.After) do
                        local v25 = p13.Tasks:FindFirstChild(v);

                        if v25 ~= nil then
                            table.insert(u23, v25);
                        end;
                    end;
                end;

                local Need = v24:FindFirstChild("Need");
                local v26;

                if Need == nil then
                    v26 = nil;
                else
                    v26 = p13.Tasks:FindFirstChild(Need.Value) or nil;
                end;

                if v26 ~= nil and table.find(u23, v26) == nil then
                    table.insert(u23, v26);
                end;

                local u27 = false;

                local function sync() -- Line: 155
                    -- upvalues: Value (copy), Max (copy), u23 (copy), u27 (ref), MarkerHandler (ref), u22 (copy), u21 (ref), TaskMarker (copy), Regions (ref), BunchaIcons (ref), u15 (copy), u20 (ref), u14 (copy), u4 (ref), Quests (ref), Color3_new_ret (ref)
                    local v28 = Value.Value < Max.Value;

                    if v28 then
                        for _, v in ipairs(u23) do
                            if v.Value.Value < v.Max.Value then
                                v28 = false;
                                break;
                            end;
                        end;
                    end;

                    if not v28 or u27 then
                        if not v28 and u27 then
                            u27 = false;
                            MarkerHandler.removeMarker(u22);
                        end;

                        return;
                    end;

                    u27 = true;
                    local addMarker = MarkerHandler.addMarker;
                    local v29 = {
                        minDistance = 35,
                        margin = 10,
                        position = u21,
                        img = TaskMarker.Icon ~= nil and TaskMarker.Icon ~= "" and TaskMarker.Icon or TaskMarker.Npc ~= nil and Regions.GetNpcIcon(TaskMarker.Npc) or (BunchaIcons[u15.Category] or BunchaIcons.Combat),
                        useName = u20
                    };
                    local table_clone_ret = table.clone(v29);
                    table_clone_ret.onMap = true;
                    table_clone_ret.ping = u4[Quests.GetQuestCategory(u14)] or Color3_new_ret;
                    addMarker(u22, table_clone_ret);
                end;

                table.insert(v18, Value.Changed:Connect(sync));

                for _, v in ipairs(u23) do
                    table.insert(v18, v.Value.Changed:Connect(sync));
                end;

                sync();
            end;
        end;
    end;

    local function questRemoved(p30: userdata) -- Line: 190
        -- upvalues: MarkerHandler (ref), u11 (copy), u12 (copy)
        local Name = p30.Name;
        MarkerHandler.removeMarker(Name);
        local v31 = u11[Name];

        if v31 ~= nil then
            for _, v in ipairs(v31) do
                v:Disconnect();
            end;

            u11[Name] = nil;
        end;

        local v32 = u12[Name];

        if v32 ~= nil then
            for _, v in ipairs(v32) do
                MarkerHandler.removeMarker(v);
            end;

            u12[Name] = nil;
        end;
    end;

    local Holder = p8:WaitForChild("Quests"):WaitForChild("Holder");

    for _, child in ipairs(Holder:GetChildren()) do
        questAdded(child);
    end;

    Holder.ChildAdded:Connect(function(p33) -- Line: 214
        -- upvalues: questAdded (copy)
        p33:WaitForChild("QuestString");
        questAdded(p33);
    end);
    Holder.ChildRemoved:Connect(questRemoved);
end;
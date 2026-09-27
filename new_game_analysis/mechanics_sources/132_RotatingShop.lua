-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Menum = require(ReplicatedStorage.CAM.Global.Menum);
require(ReplicatedStorage.CAM.Global.Types.NpcTypes);
local Shop = require(ReplicatedStorage.CAM.Global.Shop);
local TimedEvents = require(script.Parent.TimedEvents);
local u1 = {
    GRACE = 30
};
local u2 = {};

function u1.GetEvery(p3) -- Line: 36
    -- upvalues: TimedEvents (copy)
    local v4 = TimedEvents[p3.TimedEvent];
    local v5 = `RotatingShop: no TimedEvents entry named "{p3.TimedEvent}" (shop {p3.Name})`;
    assert(v4 ~= nil, v5);

    return v4.Every;
end;

function u1.GetCycleIndex(p6) -- Line: 45
    -- upvalues: u1 (copy)
    if p6.CycleAttribute ~= nil then
        return tonumber(workspace:GetAttribute(p6.CycleAttribute)) or 0;
    end;

    local v7 = workspace:GetServerTimeNow() / u1.GetEvery(p6);

    return math.floor(v7);
end;

function u1.GetRotation(p8: any, p9: number) -- Line: 54
    local Random_new_ret = Random.new(p9 * 8191 + p8.Seed);
    local v10;

    if typeof(p8.SlotCount) == "table" then
        v10 = Random_new_ret:NextInteger(p8.SlotCount.Min, p8.SlotCount.Max);
    else
        v10 = p8.SlotCount;
    end;

    local math_min_ret = math.min(v10, #p8.Pool);
    local v11 = {};

    if p8.Always ~= nil then
        for _, v in p8.Always do
            local v12 = typeof(v) == "string" and {
                Name = v
            } or v;
            table.insert(v11, v12);
        end;
    end;

    local table_create_ret = table.create(#p8.Pool);

    for i = 1, #p8.Pool do
        table_create_ret[i] = i;
        local _ = i;
    end;

    for i = 1, math_min_ret do
        local v13 = Random_new_ret:NextInteger(i, #table_create_ret);
        local v14 = table_create_ret[i];
        table_create_ret[i] = table_create_ret[v13];
        table_create_ret[v13] = v14;
        local v15 = p8.Pool[table_create_ret[i]];
        local v16 = typeof(v15) == "string" and {
            Name = v15
        } or v15;
        table.insert(v11, v16);
        local _ = i;
    end;

    return v11;
end;

function u1.RegisterStock(p17: string, p18: table, p19: string?) -- Line: 88
    -- upvalues: Shop (copy), u2 (copy), Menum (copy)
    local v20 = {};

    for _, v in ipairs(p18) do
        if Shop.itemsforsale[v.Name] == nil or u2[v.Name] then
            local v21 = {
                Type = Menum.ShopItemType.IngameItem,
                Price = v.Price,
                NoSave = v.NoSave,
                RequiresQuestDone = p19
            };

            if Shop.RegisterItem(v.Name, v21) then
                u2[v.Name] = v21;
                table.insert(v20, v.Name);
            end;
        else
            warn((`RotatingShop: "{v.Name}" already has a permanent listing, {p17} sells it through that entry`));
        end;
    end;

    return v20;
end;

function u1.UnregisterStock(p22: table, p23: table?) -- Line: 111
    -- upvalues: u2 (copy), Shop (copy)
    for _, v in ipairs(p22) do
        if (p23 == nil or not p23[v]) and u2[v] ~= nil then
            if Shop.itemsforsale[v] == u2[v] then
                Shop.itemsforsale[v] = nil;
            end;

            u2[v] = nil;
        end;
    end;
end;

local u24 = {};
local u25 = false;

local function UpdateCountdown(p26: table, p27: userdata?, p28: any) -- Line: 145
    local DisappearDistance = p26.Data.DisappearDistance;
    local v29;

    if p27 == nil then
        v29 = false;
    else
        v29 = DisappearDistance == nil and true or (p27.Position - p26.At).Magnitude <= DisappearDistance + (p26.Cleanup == nil and 0 or 8);
    end;

    if not v29 or p26.Cleanup ~= nil then
        if not v29 and p26.Cleanup ~= nil then
            p26.Cleanup();
            p26.Cleanup = nil;
            local Anchor = p26.Anchor;
            p26.Anchor = nil;

            if Anchor ~= nil then
                task.delay(1, Anchor.Destroy, Anchor);
            end;
        end;

        return;
    end;

    local Part = Instance.new("Part");
    Part.Name = p26.Name .. "RestockCountdown";
    Part.Size = Vector3.new(1, 1, 1);
    Part.Transparency = 1;
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.CFrame = CFrame.new(p26.At);
    local BillboardGui = Instance.new("BillboardGui");
    BillboardGui.Name = "RestockCountdown";
    BillboardGui.Size = UDim2.fromScale(14, 6);
    BillboardGui.MaxDistance = DisappearDistance == nil and 150 or (DisappearDistance + 30 or 150);
    BillboardGui.LightInfluence = 0;
    BillboardGui.Parent = Part;
    Part.Parent = workspace.Debree;
    p26.Anchor = Part;
    p26.Cleanup = p28(BillboardGui, p26.Data);
end;

local function StartCountdownWatcher() -- Line: 180
    -- upvalues: u25 (ref), ReplicatedStorage (copy), Players (copy), u24 (copy), UpdateCountdown (copy)
    if u25 then
        return;
    end;

    u25 = true;
    task.spawn(function() -- Line: 183
        -- upvalues: ReplicatedStorage (ref), Players (ref), u24 (ref), UpdateCountdown (ref)
        local UITimedEvent = require(ReplicatedStorage.CAM.Client.Components.NonePackagedMisc.UITimedEvent);

        while true do
            local Character = Players.LocalPlayer.Character;
            local v30;

            if Character == nil then
                v30 = nil;
            else
                v30 = Character:FindFirstChild("HumanoidRootPart") or nil;
            end;

            for _, v in ipairs(u24) do
                local success, result = pcall(UpdateCountdown, v, v30, UITimedEvent);

                if not success then
                    warn((`RotatingShop: countdown update failed for {v.Name}: {result}`));
                end;
            end;

            task.wait(1);
        end;
    end);
end;

function u1.BindClient(u31) -- Line: 210
    -- upvalues: RunService (copy), TimedEvents (copy), u24 (copy), u25 (ref), ReplicatedStorage (copy), Players (copy), UpdateCountdown (copy), u1 (copy)
    if not RunService:IsClient() then
        return;
    end;

    if u31.CountdownAt ~= nil then
        local v32 = TimedEvents[u31.TimedEvent];

        if v32 == nil then
            warn((`RotatingShop: no TimedEvents entry named "{u31.TimedEvent}" (shop {u31.Name}), countdown skipped`));
        else
            table.insert(u24, {
                Name = u31.Name,
                At = u31.CountdownAt,
                Data = v32
            });

            if not u25 then
                u25 = true;
                task.spawn(function() -- Line: 183
                    -- upvalues: ReplicatedStorage (ref), Players (ref), u24 (ref), UpdateCountdown (ref)
                    local UITimedEvent = require(ReplicatedStorage.CAM.Client.Components.NonePackagedMisc.UITimedEvent);

                    while true do
                        local Character = Players.LocalPlayer.Character;
                        local v33;

                        if Character == nil then
                            v33 = nil;
                        else
                            v33 = Character:FindFirstChild("HumanoidRootPart") or nil;
                        end;

                        for _, v in ipairs(u24) do
                            local success, result = pcall(UpdateCountdown, v, v33, UITimedEvent);

                            if not success then
                                warn((`RotatingShop: countdown update failed for {v.Name}: {result}`));
                            end;
                        end;

                        task.wait(1);
                    end;
                end);
            end;
        end;
    end;

    local CycleIndex = u1.GetCycleIndex(u31);
    local u34 = u1.RegisterStock(u31.Name, u1.GetRotation(u31, CycleIndex), u31.RequiresQuestDone);
    task.spawn(function() -- Line: 229
        -- upvalues: u1 (ref), u31 (copy), CycleIndex (ref), u34 (ref)
        while true do
            local v35;

            repeat
                task.wait(5);
                v35 = u1.GetCycleIndex(u31);
            until v35 ~= CycleIndex;

            CycleIndex = v35;
            local u36 = u34;
            u34 = u1.RegisterStock(u31.Name, u1.GetRotation(u31, v35), u31.RequiresQuestDone);
            task.delay(u1.GRACE, function() -- Line: 237
                -- upvalues: u34 (ref), u1 (ref), u36 (copy)
                local v37 = {};

                for _, v in ipairs(u34) do
                    v37[v] = true;
                end;

                u1.UnregisterStock(u36, v37);
            end);
        end;
    end);
end;

return u1;
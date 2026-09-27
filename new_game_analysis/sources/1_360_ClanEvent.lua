-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local v1 = game:GetService("RunService"):IsServer();
local Clans = require(ReplicatedStorage.CAM:WaitForChild("Clans"));
local BadgeRewards = require(ReplicatedStorage.CAM.Global.BadgeRewards);
local u2;

if v1 then
    u2 = require(ReplicatedStorage.CAM.Global.ClanEvents) or nil;
else
    u2 = nil;
end;

local u3 = v1 and require(ReplicatedStorage.CAM.Global.Utility) or nil;
local u4 = { "None" };
local u5 = {};
local u6 = {};

for i in Clans.Clans do
    table.insert(u4, i);
    u5[i:lower()] = i;
end;

table.sort(u4);

for _, v in BadgeRewards do
    if typeof(v.ClanEvent) == "table" then
        u6[v.Key:lower()] = v.ClanEvent;
        table.insert(u4, 1, v.Key);
    end;
end;

local u7 = {};

for _, v in Clans.Rarities do
    table.insert(u7, v.name);
end;

local function named(p8: table, p9: any) -- Line: 62
    if p9 == nil then
        return nil;
    end;

    local v10 = tostring(p9):lower();

    for _, v in p8 do
        if v:lower() == v10 then
            return v;
        end;
    end;

    return nil;
end;

return {
    Clearance = 6,
    Keys = {
        {
            Type = "Players",
            Required = true
        },
        {
            Type = "Event",
            Name = "Badge or clan",
            Required = true,
            Suggester = u4,

            Completer = function(p11: string) -- Line: 87, Name: Completer
                -- upvalues: named (copy), u4 (copy)
                if p11 == nil or p11 == "" then
                    return nil;
                end;

                return named(u4, p11);
            end
        },
        {
            Type = "Rarity",
            Name = "Rarity",
            Required = false,
            Suggester = u7,

            Completer = function(p12: string) -- Line: 97, Name: Completer
                -- upvalues: named (copy), u7 (copy)
                if p12 == nil or p12 == "" then
                    return nil;
                end;

                return named(u7, p12);
            end
        },
        {
            Type = "Amount",
            Name = "Spins",
            Required = false,

            Completer = function(p13: string) -- Line: 107, Name: Completer
                return tonumber(p13);
            end
        }
    },

    Server = function(p14: userdata, p15: table, p16: any, p17: any, p18: any) -- Line: 112, Name: Server
        -- upvalues: named (copy), u4 (copy), u2 (copy), u6 (copy), u5 (copy), u7 (copy), u3 (copy)
        local v19 = named(u4, p16);

        if v19 == nil then
            error((`No clan or badge reward "{tostring(p16)}"`));
        end;

        if v19 == "None" then
            for _, v in p15 do
                u2.Clear(v);
            end;

            return {
                Content = `Cleared every clan event on {#p15} player(s)`,
                ContentColor = Color3.new(1, 1, 1),
                BgColor = Color3.fromRGB(150, 80, 30)
            };
        end;

        local v20 = u6[v19:lower()];
        local v21;

        if v20 == nil then
            v21 = u5[v19:lower()];
        else
            v21 = v20.Clan;
        end;

        local v22 = named(u7, p17);

        if not v22 then
            if v20 == nil then
                v22 = nil;
            else
                v22 = v20.Rarity or nil;
            end;
        end;

        local v23 = tonumber(p18);

        if not v23 then
            if v20 == nil then
                v23 = nil;
            else
                v23 = v20.Spins or nil;
            end;
        end;

        if v21 == nil then
            error((`No clan "{tostring(v19)}"`));
        end;

        if v22 == nil then
            error((`Which rarity? ({table.concat(u7, ", ")})`));
        end;

        if v23 == nil or v23 <= 0 then
            error("How many spins? Give a count above 0");
        end;

        local v24 = true;
        local v25 = {};

        for _, v in p15 do
            u3.GetData(v, true);

            if v.Parent ~= nil then
                local v26 = u2.Grant(v, v21, v22, v23);
                local v27 = `{v.Name}: {v26 and "granted" or "refused"}`;
                table.insert(v25, v27);
                v24 = v24 and v26;
            end;
        end;

        local v28 = `{v21} draws as {v22} for {v23} spins`;
        table.insert(v25, 1, v28);
        local v29 = {
            Content = table.concat(v25, "\n"),
            ContentColor = Color3.new(1, 1, 1)
        };
        local v30;

        if v24 then
            v30 = Color3.fromRGB(30, 110, 60);
        else
            v30 = Color3.fromRGB(150, 30, 30);
        end;

        v29.BgColor = v30;

        return v29;
    end
};
-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local v1 = RunService:IsServer();
local script_Parent = script.Parent;
local Breathings = require(ReplicatedStorage.CAM.Global.Powers.Breathings);
local DemonArts = require(ReplicatedStorage.CAM.Global.Powers.DemonArts);
local Mastery = require(script_Parent.Mastery);
local Set = require(script_Parent.Set);
local Ultimates = require(script_Parent.Ultimates);
local u2;

if v1 then
    u2 = require(script_Parent.ModeBar) or nil;
else
    u2 = nil;
end;

local u3;

if v1 then
    u3 = require(script_Parent.Set.Clan) or nil;
else
    u3 = nil;
end;

local u4;

if v1 then
    u4 = require(script_Parent.Set.Race) or nil;
else
    u4 = nil;
end;

local u5;

if v1 then
    u5 = require(script_Parent.Give.Breathing) or nil;
else
    u5 = nil;
end;

local u6;

if v1 then
    u6 = require(script_Parent.Give["Evil Art"]) or nil;
else
    u6 = nil;
end;

local u7;

if v1 then
    u7 = require(script_Parent.Give["Stat Points"]) or nil;
else
    u7 = nil;
end;

local u8 = v1 and require(script_Parent.Reset.Cooldowns) or nil;
local v9 = {};
local v10 = {};
local u11 = {
    ModeBar = true,
    Cooldowns = true
};
local u12 = { "Mastery", "Clan", "StatPoints", "Breathing", "EvilArt", "Race", "Ultimates", "ModeBar", "Cooldowns" };
local u13 = { "Slayer", "Demon" };

for i in Breathings do
    table.insert(v9, i);
end;

for i in DemonArts do
    table.insert(v10, i);
end;

table.sort(v9);
table.sort(v10);
local u14 = {
    mastery = Mastery.Keys[2].Suggester,
    clan = Set.Keys[3].Suggester({
        [2] = "clan"
    }),
    breathing = v9,
    evilart = v10,
    race = u13
};

local function valuesFor(p15: string) -- Line: 91
    -- upvalues: Ultimates (copy), u14 (copy)
    if p15 == "ultimates" then
        return Ultimates.Keys[2].Suggester();
    end;

    return u14[p15];
end;

local function named(p16: table?, p17: any) -- Line: 103
    if p16 == nil then
        return nil;
    end;

    local v18 = tostring(p17):lower();

    for _, v in p16 do
        if v:lower() == v18 then
            return v;
        end;
    end;

    return nil;
end;

return {
    Clearance = 0.5,
    Keys = {
        {
            Type = "Category",
            Name = "Category",
            Required = true,
            Suggester = u12,

            Completer = function(p19: string) -- Line: 122, Name: Completer
                -- upvalues: named (copy), u12 (copy)
                return named(u12, p19);
            end
        },
        {
            Type = "Value",
            Name = "Value",
            Required = false,

            Suggester = function(p20: table) -- Line: 134, Name: Suggester
                -- upvalues: Ultimates (copy), u14 (copy)
                local v21 = (p20[1] or ""):lower();
                local v22;

                if v21 == "ultimates" then
                    v22 = Ultimates.Keys[2].Suggester();
                else
                    v22 = u14[v21];
                end;

                return v22, true;
            end,

            Completer = function(p23: string, p24: table) -- Line: 137, Name: Completer
                -- upvalues: Ultimates (copy), u14 (copy), named (copy)
                if p23 == nil or p23 == "" then
                    return nil;
                end;

                local v25 = (p24[1] or ""):lower();
                local v26;

                if v25 == "ultimates" then
                    v26 = Ultimates.Keys[2].Suggester();
                else
                    v26 = u14[v25];
                end;

                if v26 == nil then
                    return tonumber(p23);
                end;

                return named(v26, p23) or p23;
            end
        },
        {
            Type = "Amount",
            Name = "Amount",
            Required = false,

            Completer = function(p27: string) -- Line: 156, Name: Completer
                return tonumber(p27);
            end
        }
    },

    Server = function(p28: userdata, p29: string, p30: any, p31: any) -- Line: 161, Name: Server
        -- upvalues: named (copy), u12 (copy), u11 (copy), u14 (copy), Mastery (copy), u3 (copy), u13 (copy), u4 (copy), Breathings (copy), u5 (copy), DemonArts (copy), u6 (copy), u7 (copy), Ultimates (copy), u2 (copy), u8 (copy)
        local v32 = named(u12, p29);

        if v32 == nil then
            error((`Invalid balancer category: {p29}`));
        end;

        if p30 == nil and not u11[v32] then
            error((`{v32} needs a value`));
        end;

        local v33 = { p28 };

        if v32 == "Mastery" then
            local v34 = named(u14.mastery, p30);

            if v34 == nil then
                error((`No mastery named "{p30}"`));
            end;

            local Server = Mastery.Server;
            local v35 = tonumber(p31) or 1;

            return Server(p28, v33, v34, (math.max(v35, 0)));
        end;

        if v32 == "Clan" then
            return u3(v33, p30);
        end;

        if v32 == "Race" then
            if table.find(u13, p30) == nil then
                error((`Race must be {table.concat(u13, " or ")}, not "{p30}"`));
            end;

            return u4(v33, p30);
        end;

        if v32 == "Breathing" then
            if Breathings[p30] == nil then
                error((`No breathing named "{p30}"`));
            end;

            return u5(p28, p30);
        end;

        if v32 == "EvilArt" then
            if DemonArts[p30] == nil then
                error((`No evil art named "{p30}"`));
            end;

            return u6(p28, p30);
        end;

        if v32 == "StatPoints" then
            local v36 = tonumber(p30);

            if v36 == nil then
                error((`Stat Points needs a number, not "{p30}"`));
            end;

            return u7(p28, (math.max(v36, 0)));
        end;

        if v32 == "Ultimates" then
            local v37 = named(Ultimates.Keys[2].Suggester(), p30);

            if v37 == nil then
                error((`No boss-skill category named "{p30}"`));
            end;

            return Ultimates.Server(p28, v33, v37);
        end;

        if v32 == "ModeBar" then
            return u2.Server(p28, v33);
        end;

        if v32 == "Cooldowns" then
            return u8(v33);
        end;
    end
};
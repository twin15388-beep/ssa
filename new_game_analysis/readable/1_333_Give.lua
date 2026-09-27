-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local v1 = RunService:IsServer();
local u2 = {};
local u3 = {};

for _, child in ipairs(script:GetChildren()) do
    if child:IsA("ModuleScript") then
        table.insert(u2, child.Name);

        if v1 then
            u3[child.Name] = require(child);
        end;
    end;
end;

local u4 = {};
local u5 = {};
local table_insert = table.insert;
local table_find = table.find;

if not v1 then
    local v6 = {
        Breathing = require(ReplicatedStorage.CAM.Global.Powers.Breathings),
        ["Evil Art"] = require(ReplicatedStorage.CAM.Global.Powers.DemonArts),
        ["Fighting Style"] = require(ReplicatedStorage.CAM.Global.Powers.FightingStyles),
        Item = require(ReplicatedStorage.CAM.Global.Collectibles.Items),
        Progress = {
            Slayer = true,
            Demon = true
        }
    };

    for i, v in pairs(v6) do
        local v7 = i:lower();
        u4[i] = {};
        u5[v7] = {
            Upper = i
        };
        local v8 = i;

        for i2, _ in v do
            table_insert(u4[v8], i2);
            table_insert(u5[v7], i2:lower());
        end;
    end;
end;

return {
    Clearance = 1,
    Keys = {
        {
            Type = "Players",
            Required = true
        },
        {
            Type = "Type",
            Required = true,
            Suggester = u2,

            Completer = function(p9) -- Line: 75, Name: Completer
                -- upvalues: u2 (copy)
                for _, v in ipairs(u2) do
                    if v:lower() == p9:lower() then
                        return v;
                    end;
                end;
            end
        },
        {
            Type = "Varies",
            Required = true,

            Suggester = function(p10: table) -- Line: 92, Name: Suggester
                -- upvalues: u4 (copy)
                return u4[p10[2]], true;
            end,

            Completer = function(p11: string, p12: table) -- Line: 96, Name: Completer
                -- upvalues: u5 (copy), table_find (copy), u4 (copy)
                local v13 = (p12[2] or ""):lower();
                local v14 = p11:lower();

                if u5[v13] == nil then
                    return tonumber(p11) or p11;
                end;

                local v15 = table_find(u5[v13], v14);

                if v15 ~= nil then
                    return u4[u5[v13].Upper][v15];
                end;
            end
        },
        {
            Type = "Amount",
            Name = "Amount",
            Required = false,

            Completer = function(p16: string) -- Line: 122, Name: Completer
                return tonumber(p16);
            end
        }
    },

    Server = function(p17: userdata, p18: table, p19: string, p20: string, p21: any) -- Line: 127, Name: Server
        -- upvalues: u3 (copy)
        if p19 == nil or not u3[p19] then
            error((`Invalid give type: {p19}`));

            return;
        end;

        for _, v in pairs(p18) do
            u3[p19](v, p20, p21);
        end;
    end
};
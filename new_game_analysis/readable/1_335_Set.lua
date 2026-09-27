-- Decompiled with Potassium's decompiler.

local u1 = {};
local v2 = {};

for _, child in pairs(script:GetChildren()) do
    u1[child.Name:lower()] = require(child);
    table.insert(v2, child.Name);
end;

local Clans = require(game:GetService("ReplicatedStorage").CAM:WaitForChild("Clans"));
local v3 = { "None" };

for _, v in Clans.Rarities do
    for i in Clans.GetByRarity(v.rarity) or {} do
        table.insert(v3, i);
    end;
end;

local u4 = {
    race = { "Human", "Slayer", "Demon", "Hybrid" },
    clan = v3,
    progresslevel = { "Slayer", "Demon" }
};

return {
    Clearance = 1,
    Priority = 10,
    Keys = {
        {
            Type = "Players",
            Required = true
        },
        {
            Type = "Set Category",
            Required = true,
            Suggester = v2
        },
        {
            Required = true,

            Suggester = function(p5) -- Line: 52, Name: Suggester
                -- upvalues: u4 (copy)
                return u4[(p5[2] or ""):lower()];
            end
        },
        {
            Type = "Amount",
            Name = "Amount",
            Required = false,

            Completer = function(p6: string) -- Line: 68, Name: Completer
                return tonumber(p6);
            end
        }
    },

    Server = function(p7: userdata, p8: table, p9: any, ...) -- Line: 75, Name: Server
        -- upvalues: u1 (copy)
        if u1[p9:lower()] then
            return u1[p9:lower()](p8, ...);
        end;
    end
};
-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
require(ReplicatedStorage.CAM.Global.Types.ClanTypes);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local u1 = {
    Rarities = {
        {
            rarity = 1,
            name = "Common",
            chance = 0.6,
            color = Color3.fromRGB(220, 228, 240)
        },
        {
            rarity = 2,
            name = "Uncommon",
            chance = 0.23,
            color = Color3.fromRGB(96, 214, 130)
        },
        {
            rarity = 3,
            name = "Rare",
            chance = 0.12,
            color = Color3.fromRGB(92, 170, 255)
        },
        {
            rarity = 5,
            name = "Legendary",
            chance = 0.04,
            color = Color3.fromRGB(240, 190, 80)
        },
        {
            rarity = 6,
            name = "Mythic",
            chance = 0.009,
            color = Color3.fromRGB(200, 120, 255)
        },
        {
            rarity = 7,
            name = "Supreme",
            chance = 0.001,
            color = Color3.fromRGB(255, 92, 120)
        }
    },
    ByRarity = {
        [1] = require(script.Common),
        [2] = require(script.Uncommon),
        [3] = require(script.Rare),
        [5] = require(script.Legendary),
        [6] = require(script.Mythic),
        [7] = require(script.Supreme)
    },
    Clans = {}
};

for _, v in u1.Rarities do
    for i, v2 in u1.ByRarity[v.rarity] do
        u1.Clans[i] = v2;
    end;
end;

u1.TestClans = require(script.Test);

for i, v in u1.TestClans do
    u1.Clans[i] = v;
end;

u1.TEST_CLAN = "Test";

function u1.GetClan(p2: string) -- Line: 99
    -- upvalues: u1 (copy)
    return u1.Clans[p2];
end;

function u1.GetByRarity(p3: number) -- Line: 113
    -- upvalues: u1 (copy)
    return u1.ByRarity[p3];
end;

function u1.TierOf(p4: string?) -- Line: 127
    -- upvalues: u1 (copy)
    local v5;

    if p4 == nil then
        v5 = nil;
    else
        v5 = u1.GetClan(p4);
    end;

    if v5 == nil then
        return nil;
    end;

    for _, v in u1.Rarities do
        if v.rarity == v5.rarity then
            return v;
        end;
    end;

    return nil;
end;

function u1.GetAll() -- Line: 147
    -- upvalues: u1 (copy)
    return u1.Clans;
end;

function u1.HasPassive(p6: string?, p7: string) -- Line: 158
    -- upvalues: u1 (copy)
    local v8;

    if p6 == nil then
        v8 = nil;
    else
        v8 = u1.Clans[p6] or nil;
    end;

    if v8 == nil or v8.passives == nil then
        return false;
    end;

    for _, v in v8.passives do
        if v.name == p7 then
            return true;
        end;
    end;

    return false;
end;

function u1.BurnPassive(p9: string?, p10: string?) -- Line: 172
    -- upvalues: u1 (copy)
    local v11;

    if p9 == nil then
        v11 = nil;
    else
        v11 = u1.Clans[p9] or nil;
    end;

    if v11 == nil or (v11.passives == nil or p10 == nil) then
        return nil;
    end;

    for _, v in v11.passives do
        if v.burns ~= nil and table.find(v.burns, p10) ~= nil then
            return v.name;
        end;
    end;

    return nil;
end;

function u1.IsImmune(p12: string?, p13: any) -- Line: 189
    -- upvalues: u1 (copy)
    if typeof(p13) == "table" then
        for _, v in p13 do
            if u1.IsImmune(p12, v) then
                return true;
            end;
        end;

        return false;
    end;

    local v14;

    if p12 == nil then
        v14 = nil;
    else
        v14 = u1.Clans[p12] or nil;
    end;

    if v14 == nil or v14.passives == nil then
        return false;
    end;

    for _, v in v14.passives do
        local immunities = v.immunities;

        if immunities ~= nil and table.find(immunities, p13) ~= nil then
            return true;
        end;
    end;

    return u1.Resistance(p12, p13) >= 1;
end;

function u1.Resistance(p15: string?, p16: any) -- Line: 215
    -- upvalues: u1 (copy)
    if typeof(p16) == "table" then
        local v17 = 0;

        for _, v in p16 do
            v17 = v17 + u1.Resistance(p15, v);
        end;

        return math.clamp(v17, 0, 1);
    end;

    local v18;

    if p15 == nil then
        v18 = nil;
    else
        v18 = u1.Clans[p15] or nil;
    end;

    if v18 == nil or v18.passives == nil then
        return 0;
    end;

    local v19 = 0;

    for _, v in v18.passives do
        local resistances = v.resistances;

        if resistances ~= nil and resistances[p16] ~= nil then
            v19 = v19 + resistances[p16];
        end;
    end;

    return math.clamp(v19, 0, 1);
end;

function u1.ClanOfCharacter(p20: userdata?) -- Line: 242
    -- upvalues: Players (copy), Utility (copy)
    if p20 == nil then
        return nil;
    end;

    local PlayerFromCharacter = Players:GetPlayerFromCharacter(p20);

    if PlayerFromCharacter == nil then
        return p20:GetAttribute("Clan");
    end;

    local Data = Utility.GetData(PlayerFromCharacter);
    local v21 = Data ~= nil and Data:FindFirstChild("Clan") or nil;

    return v21 ~= nil and v21.Value or nil;
end;

return u1;
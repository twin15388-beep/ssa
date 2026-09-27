-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);
local Series = require(ReplicatedStorage.CAM.Global.Series);
local CombatMode = require(ReplicatedStorage.CAM.Global.CombatMode);
local u1 = {};
local u2 = {};

for _, v in ReplicatedStorage.Skills:QueryDescendants("ModuleScript#Config") do
    local PVP = require(v).PVP;

    if PVP ~= nil then
        u1[v.Parent.Name] = PVP;
        local v3 = v;

        for _, child in v.Parent:GetChildren() do
            if child:IsA("ModuleScript") and child ~= v3 then
                u1[string.gsub(child.Name, "Server$", "")] = PVP;
            end;
        end;
    end;
end;

local u4 = {};

for _, v in { Series.Passives, Series.OutfitPassives } do
    for _, v2 in v do
        if v2.PvP ~= nil then
            u4[v2.Name] = v2.PvP;
        end;
    end;
end;

function u2.Block(p5: string?) -- Line: 51
    -- upvalues: Items (copy), u1 (copy), u4 (copy)
    if p5 == nil then
        return nil;
    end;

    local v6 = Items[p5];
    local v7 = u1[p5];

    if not v7 then
        local v8;

        if v6 == nil then
            v8 = nil;
        else
            v8 = v6.PvP;
        end;

        v7 = v8 or u4[p5];
    end;

    return v7;
end;

function u2.Knob(p9: string?, p10: string) -- Line: 58
    -- upvalues: u2 (copy)
    local v11 = u2.Block(p9);

    return v11 ~= nil and v11[p10] or 1;
end;

local function playerOf(p12: userdata?) -- Line: 63
    -- upvalues: Players (copy)
    if p12 == nil then
        return nil;
    end;

    if p12:IsA("Player") then
        return p12;
    end;

    return Players:GetPlayerFromCharacter(p12);
end;

function u2.IsPvP(p13: userdata?, p14: userdata?) -- Line: 74
    -- upvalues: Players (copy), CombatMode (copy)
    if p13 == nil then
        p13 = nil;
    elseif not p13:IsA("Player") then
        p13 = Players:GetPlayerFromCharacter(p13);
    end;

    if p14 == nil then
        p14 = nil;
    elseif not p14:IsA("Player") then
        p14 = Players:GetPlayerFromCharacter(p14);
    end;

    if p13 == nil or p13 == p14 then
        return false;
    end;

    return p14 ~= nil and true or CombatMode.PvPHits(p13);
end;

function u2.CastKnob(p15: userdata?, p16: string?, p17: string) -- Line: 81
    -- upvalues: CombatMode (copy), u2 (copy)
    return not CombatMode.InPvPMode(p15) and 1 or u2.Knob(p16, p17);
end;

function u2.IsWeighted(p18: string) -- Line: 90
    return (p18 == "Additional Damage" or (p18 == "Damage Reduction" or p18 == "Damage Reduction Factor")) and true or string.find(p18, " Damage Factor", 1, true) ~= nil;
end;

local u19 = { {
        Knob = "Damage",
        Name = "damage",
        Hit = true
    }, {
        Knob = "Base",
        Name = "base damage",
        Hit = true
    }, {
        Knob = "AdScale",
        Name = "additional damage scaling",
        Hit = true
    }, {
        Knob = "Stun",
        Name = "stun",
        Hit = true
    }, {
        Knob = "StrictStun",
        Name = "strict stun",
        Hit = true
    }, {
        Knob = "BlockDamage",
        Name = "block damage",
        Hit = true
    }, {
        Knob = "Cooldown",
        Name = "cooldown in arenas"
    }, {
        Knob = "Stamina",
        Name = "stamina cost in arenas"
    }, {
        Knob = "Stats",
        Name = "damage and defence stats"
    }, {
        Knob = "Upgrades",
        Name = "refine and set tier bonus"
    } };

function u2.Lines(p20: table?, p21: string, p22: boolean?) -- Line: 115
    -- upvalues: u19 (copy)
    local v23 = {};

    if p20 == nil then
        return v23;
    end;

    for _, v in u19 do
        local v24 = p20[v.Knob];

        if v24 ~= nil and (v24 ~= 1 and (v.Hit or not p22)) then
            local v25 = {
                Label = `{p21}{v.Name}`,
                Share = v24
            };
            table.insert(v23, v25);
        end;
    end;

    return v23;
end;

return u2;
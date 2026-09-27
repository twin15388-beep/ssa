-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Character_info_provider = require(ReplicatedStorage.CAM.Global.Character_info_provider);
local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);
local Refinement = require(ReplicatedStorage.CAM.Global.Refinement);
local Series = require(ReplicatedStorage.CAM.Global.Series);
local SettingsLive = require(ReplicatedStorage.CAM.Global.SettingsLive);
local Shop = require(ReplicatedStorage.CAM.Global.Shop);
require(ReplicatedStorage.CAM.Global.Types.CraftingTypes);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local u1 = {
    Definitions = require(script.DefaultConfigs)
};

for i, v in u1.Definitions do
    local v2 = #v.required;

    if v2 < 1 or v2 > 3 then
        warn((`Crafting: "{i}" has {v2} required items, needs {1} to {3}`));
    end;
end;

u1.Live = SettingsLive.new("CraftingRecipes", u1.Definitions, u1.Definitions);
u1.StationNpcs = {
    Ouwigahara = { "Blacksmith Togane" },
    Ouwland = { "Blacksmith Togane" },
    ["Hidden Mist"] = { "Yagane" }
};

function u1.Get(p3: string) -- Line: 62
    -- upvalues: u1 (copy)
    return u1.Definitions[p3];
end;

function u1.Spendable(p4: userdata, p5: string) -- Line: 67
    local v6;

    if p4.Name == p5 and p4:FindFirstChild("NoSave") == nil then
        v6 = p4:FindFirstChild("QuestGrant") == nil;
    else
        v6 = false;
    end;

    return v6;
end;

function u1.Held(p7: userdata, p8: string, p9: number?) -- Line: 74
    -- upvalues: u1 (copy), Series (copy)
    local v10 = 0;

    for _, child in p7:GetChildren() do
        if u1.Spendable(child, p8) and (p9 == nil or Series.TierOf(child) == p9) then
            local Amount = child:FindFirstChild("Amount");
            v10 = v10 + (Amount == nil and 1 or (Amount.Value or 1));
        end;
    end;

    return v10;
end;

function u1.PricedLine(p11: userdata?, p12: any, p13: string, p14: number) -- Line: 85
    -- upvalues: Shop (copy)
    if p12.fullPrice == true then
        return p14;
    end;

    return Shop.PricedFor(p11, p13, p14, 1);
end;

function u1.RequiredTier(p15: any, p16: string) -- Line: 91
    if p15.requiredTier == nil or p16 ~= p15.required[1].name then
        return nil;
    end;

    return p15.requiredTier;
end;

function u1.SpentCopy(p17: userdata, u18: string, u19: number?) -- Line: 101
    -- upvalues: Utility (copy), u1 (copy), Series (copy), Refinement (copy), Character_info_provider (copy)
    local Data = Utility.GetData(p17);
    local v20;

    if Data == nil then
        v20 = nil;
    else
        v20 = Data:FindFirstChild("Inventory") or nil;
    end;

    local v21;

    if v20 == nil then
        v21 = nil;
    else
        v21 = v20:FindFirstChild("Inventory") or nil;
    end;

    if v21 == nil then
        return nil;
    end;

    local function fits(p22: userdata) -- Line: 106
        -- upvalues: u1 (ref), u18 (copy), u19 (copy), Series (ref)
        local v23 = u1.Spendable(p22, u18) and (u19 == nil and true or Series.TierOf(p22) == u19);

        return v23;
    end;

    if not Refinement.IsRefinable(u18) then
        for _, child in v21:GetChildren() do
            local v24 = u1.Spendable(child, u18) and (u19 == nil and true or Series.TierOf(child) == u19);

            if v24 then
                return child;
            end;
        end;

        return nil;
    end;

    local _equipped_tool = Character_info_provider.Get_equipped_tool(p17);

    if typeof(_equipped_tool) == "Instance" and _equipped_tool.Parent == v21 then
        local v25 = u1.Spendable(_equipped_tool, u18) and (u19 == nil and true or Series.TierOf(_equipped_tool) == u19);

        if v25 then
            return _equipped_tool;
        end;
    end;

    local v26 = (1 / 0);
    local v27 = nil;

    for _, child in v21:GetChildren() do
        local v28 = u1.Spendable(child, u18) and (u19 == nil and true or Series.TierOf(child) == u19);

        if v28 then
            local RefineLevel = child:FindFirstChild("RefineLevel");
            local v29 = RefineLevel == nil and 0 or RefineLevel.Value;

            if v29 < v26 then
                v27 = child;
                v26 = v29;
            end;
        end;
    end;

    return v27;
end;

u1.TierTransferShare = 0.25;

function u1.TierUp(p30: string, p31: number) -- Line: 137
    -- upvalues: u1 (copy)
    for _, v in u1.Definitions do
        if v.result == p30 and (v.tier == p31 and v.requiredTier == p31 - 1) then
            return v;
        end;
    end;

    return nil;
end;

local function tierBill(p32: string, p33: number, p34: number, p35: boolean) -- Line: 149
    -- upvalues: u1 (copy), Items (copy)
    local v36 = {};

    for i = p33 + 1, p34 do
        local v37 = u1.TierUp(p32, i);

        if v37 == nil then
            return nil;
        end;

        local _ = i;

        for i2, v in v37.price do
            v36[i2] = (v36[i2] or 0) + v;
        end;

        for _, v in v37.additionalMaterials do
            local v38 = Items[v.name];
            local v39 = p35 and (v38 ~= nil and v38.SetMaterial ~= nil) and "\0Set" or v.name;
            v36[v39] = (v36[v39] or 0) + v.amount;
        end;
    end;

    return v36;
end;

function u1.TierTransferFee(p40: string, p41: string, p42: number, p43: number) -- Line: 172
    -- upvalues: tierBill (copy), u1 (copy)
    if p43 <= p42 then
        return nil;
    end;

    local v44 = tierBill(p40, p42, p43, true);
    local v45 = tierBill(p41, p42, p43, true);

    if v44 == nil or v45 == nil then
        return nil;
    end;

    for i, v in v44 do
        if v45[i] ~= v then
            return nil;
        end;
    end;

    for i, v in v45 do
        if v44[i] ~= v then
            return nil;
        end;
    end;

    local v46 = {};

    for i, v in tierBill(p41, p42, p43, false) do
        v46[i] = math.ceil(v * u1.TierTransferShare);
    end;

    return v46;
end;

function u1.ForStation(p47: string?) -- Line: 190
    -- upvalues: u1 (copy)
    local v48 = {};

    for i, v in u1.Definitions do
        if p47 == nil or v.station == p47 then
            v48[i] = v;
        end;
    end;

    return v48;
end;

return u1;
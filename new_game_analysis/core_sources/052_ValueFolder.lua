-- Decompiled with Potassium's decompiler.

local CollectionService = game:GetService("CollectionService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local StatTypes = require(ReplicatedStorage.CAM.Global.Types.StatTypes);
local Character_info_provider = require(ReplicatedStorage.CAM.Global.Character_info_provider);
local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);

local function conditionalAmount(p1: userdata, p2: string) -- Line: 22
    -- upvalues: Character_info_provider (copy), Items (copy)
    local string_match_ret, v3 = string.match(p2, "^%s*([^,]-)%s*,%s*([%-%+%.%d]+)%s*$");
    local v4 = tonumber(v3);

    if string_match_ret == nil or (string_match_ret == "" or v4 == nil) then
        return nil;
    end;

    if table.find(Character_info_provider.GetEquippedPowers(p1), string_match_ret) ~= nil then
        return v4;
    end;

    local _equipped_tool = Character_info_provider.Get_equipped_tool(p1);
    local v5;

    if _equipped_tool == nil then
        v5 = nil;
    else
        v5 = Items[_equipped_tool.Name] or nil;
    end;

    if v5 == nil or v5.Mastery ~= string_match_ret then
        return nil;
    end;

    return v4;
end;

return function(p6: userdata, p7: string) -- Line: 37
    -- upvalues: Utility (copy), StatTypes (copy), CollectionService (copy), conditionalAmount (copy)
    local valuesfolder = Utility.getvaluesfolder(p6);

    if valuesfolder == nil then
        return 0;
    end;

    local v8 = StatTypes.HighestOnlyStats[p7] == true;
    local v9 = 0;

    for _, child in ipairs(valuesfolder:GetChildren()) do
        if CollectionService:HasTag(child, StatTypes.ValueStatTag) then
            local Attribute = child:GetAttribute(StatTypes.StatToAttribute(p7));

            if typeof(Attribute) == "string" then
                Attribute = conditionalAmount(p6, Attribute);
            end;

            if typeof(Attribute) == "number" then
                if v8 then
                    v9 = math.max(v9, Attribute);
                else
                    v9 = v9 + Attribute;
                end;
            elseif Attribute == true then
                return true;
            end;
        elseif child.Name == p7 then
            if typeof(child.Value) == "number" then
                if v8 then
                    v9 = math.max(v9, child.Value);
                else
                    v9 = v9 + child.Value;
                end;
            elseif child.Value == true then
                return true;
            end;
        end;
    end;

    return v9;
end;
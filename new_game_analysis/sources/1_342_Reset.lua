-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local v1 = RunService:IsServer();
local u2 = {};
local u3 = {};
local u4 = {};

for _, child in script:GetChildren() do
    if child:IsA("ModuleScript") then
        table.insert(u2, child.Name);
        table.insert(u3, child.Name:lower());

        if v1 then
            u4[child.Name:lower()] = require(child);
        end;
    end;
end;

local u5 = {};
local u6 = {};

if not v1 then
    local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);

    for _, v in {
        Items,
        require(ReplicatedStorage.CAM.Global.Powers.Breathings),
        require(ReplicatedStorage.CAM.Global.Powers.DemonArts),
        (require(ReplicatedStorage.CAM.Global.Powers.FightingStyles))
    } do
        local v7 = v;

        for i, v2 in v do
            if v7 ~= Items or (v2.HasCombat or v2.Mastery ~= nil) then
                local v8;

                if type(v2.Mastery) == "string" then
                    v8 = v2.Mastery;
                elseif type(v2.Mastery) == "table" then
                    v8 = v2.Mastery.Value or i;
                else
                    v8 = i;
                end;

                table.insert(u5, v8);
                table.insert(u6, v8:lower());
            end;
        end;
    end;
end;

local u9 = {
    mastery = true,
    ["skill tree"] = true
};
local u10 = {};
local u11 = {};

if not v1 then
    for _, v in require(ReplicatedStorage.CAM.Global.Collectibles.FightingStyles).Names do
        table.insert(u10, v);
        table.insert(u11, v:lower());
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
            Type = "Reset Category",
            Required = true,
            Suggester = u2,

            Completer = function(p12: string) -- Line: 85, Name: Completer
                -- upvalues: u3 (copy), u2 (copy)
                if p12 == nil or p12 == "" then
                    return nil;
                end;

                local table_find_ret = table.find(u3, p12:lower());

                if table_find_ret == nil then
                    return nil;
                end;

                return u2[table_find_ret];
            end
        },
        {
            Type = "Name",
            Name = "Name",
            Required = false,

            Suggester = function(p13: table) -- Line: 99, Name: Suggester
                -- upvalues: u10 (copy), u9 (copy), u5 (copy)
                local v14 = (p13[2] or ""):lower();

                if v14 == "fighting style" then
                    return u10, true;
                end;

                if u9[v14] then
                    return u5, true;
                end;
            end,

            Completer = function(p15: string, p16: table) -- Line: 104, Name: Completer
                -- upvalues: u11 (copy), u10 (copy), u9 (copy), u6 (copy), u5 (copy)
                if p15 == nil or p15 == "" then
                    return nil;
                end;

                local v17 = (p16[2] or ""):lower();

                if v17 == "fighting style" then
                    local table_find_ret = table.find(u11, p15:lower());

                    if table_find_ret == nil then
                        return p15;
                    end;

                    return u10[table_find_ret];
                end;

                if not u9[v17] then
                    return nil;
                end;

                local table_find_ret = table.find(u6, p15:lower());

                if table_find_ret == nil then
                    return p15;
                end;

                return u5[table_find_ret];
            end
        }
    },

    Server = function(p18: userdata, p19: table, p20: string, p21: string?) -- Line: 117, Name: Server
        -- upvalues: u4 (copy)
        local v22;

        if p20 == nil then
            v22 = nil;
        else
            v22 = u4[p20:lower()] or nil;
        end;

        if v22 == nil then
            error((`Invalid reset category: {tostring(p20)}`));
        end;

        return v22(p19, p21);
    end
};
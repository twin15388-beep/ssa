-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local v1 = RunService:IsServer();
local Items = require(ReplicatedStorage.CAM.Global.Collectibles.Items);
local Breathings = require(ReplicatedStorage.CAM.Global.Powers.Breathings);
local DemonArts = require(ReplicatedStorage.CAM.Global.Powers.DemonArts);
local FightingStyles = require(ReplicatedStorage.CAM.Global.Powers.FightingStyles);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local Caps = require(ReplicatedStorage.CAM.Global.Caps);
local u2 = {};
local u3 = {};
local u4 = {};

for _, v in {
    Items,
    Breathings,
    DemonArts,
    FightingStyles
} do
    local v5 = v;

    for i, v2 in v do
        if v5 ~= Items or (v2.HasCombat or v2.Mastery ~= nil) then
            local v6;

            if type(v2.Mastery) == "string" then
                v6 = v2.Mastery;
            elseif type(v2.Mastery) == "table" then
                v6 = v2.Mastery.Value or i;
            else
                v6 = i;
            end;

            table.insert(u2, v6);
            table.insert(u3, v6:lower());
            u4[v6:lower()] = v6;
        end;
    end;
end;

local u7 = v1 and require(ReplicatedStorage.CAM.Global.Utility) or nil;

return {
    Clearance = 1,
    Keys = {
        {
            Type = "Players",
            Required = true
        },
        {
            Type = "Mastery",
            Name = "Mastery",
            Required = true,
            Suggester = u2,

            Completer = function(p8: string) -- Line: 67, Name: Completer
                -- upvalues: u3 (copy), u2 (copy)
                local v9 = p8:lower();
                local table_find_ret = table.find(u3, v9);

                if table_find_ret then
                    return u2[table_find_ret];
                end;

                return v9;
            end
        },
        {
            Type = "Amount",
            Name = "Amount",
            Required = false,

            Completer = function(p10: string) -- Line: 82, Name: Completer
                return tonumber(p10);
            end
        }
    },

    Server = function(p11: userdata, p12: table, p13: string, p14: any) -- Line: 87, Name: Server
        -- upvalues: u4 (copy), u7 (copy), gameSettings (copy), Caps (copy)
        local v15 = u4[p13:lower()] or p13;
        local v16 = tonumber(p14) or 1;

        for _, v in p12 do
            local Data = u7.GetData(v);

            if Data ~= nil then
                local expPerMasteryDefault = gameSettings.expPerMasteryDefault;
                local v17 = Data.MasteryProgressionList:FindFirstChild(v15);

                if v17 == nil then
                    v17 = Instance.new("Folder");
                    v17.Name = v15;
                    local IntValue = Instance.new("IntValue");
                    IntValue.Name = "Current";
                    IntValue.Value = 0;
                    IntValue.Parent = v17;
                    local IntValue2 = Instance.new("IntValue");
                    IntValue2.Name = "Goal";
                    IntValue2.Value = expPerMasteryDefault;
                    IntValue2.Parent = v17;
                    v17.Parent = Data.MasteryProgressionList;
                end;

                local math_min_ret = math.min(v16, Caps.Get(v, Caps.MasteryKey(v15)));
                v17.Goal.Value = math_min_ret * expPerMasteryDefault;
                v17.Current.Value = 0;
            end;
        end;
    end
};
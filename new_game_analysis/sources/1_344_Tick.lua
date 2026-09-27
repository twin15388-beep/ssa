-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local v1 = RunService:IsServer();
local AppliedTicks = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.AppliedTicks);
local u2 = v1 and require(ReplicatedStorage.CAM.Global.Utility) or nil;

return {
    Clearance = 1,
    Keys = {
        {
            Type = "Players",
            Required = true
        },
        {
            Type = "Tick",
            Name = "Tick",
            Required = true,
            Suggester = AppliedTicks.Names,

            Completer = function(p3: string) -- Line: 41, Name: Completer
                -- upvalues: AppliedTicks (copy)
                local v4 = AppliedTicks.ByName[p3:lower()];

                if v4 == nil then
                    return p3;
                end;

                return v4.Name;
            end
        },
        {
            Type = "Amount",
            Name = "Duration",
            Required = false,

            Completer = function(p5: string) -- Line: 56, Name: Completer
                return tonumber(p5);
            end
        }
    },

    Server = function(p6: userdata, p7: table, p8: string, p9: any) -- Line: 61, Name: Server
        -- upvalues: AppliedTicks (copy), u2 (copy)
        local v10 = AppliedTicks.ByName[tostring(p8):lower()];

        if v10 == nil then
            return;
        end;

        local v11 = tonumber(p9) or 10;

        if v11 <= 0 then
            return;
        end;

        local Character = p6.Character;

        for _, v in p7 do
            local Character2 = v.Character;

            if Character2 ~= nil then
                local valuesfolder = u2.getvaluesfolder(Character2);

                if valuesfolder ~= nil then
                    u2.AddValue(valuesfolder, v10.Value, v11, "ObjectValue", Character);
                end;
            end;
        end;
    end
};
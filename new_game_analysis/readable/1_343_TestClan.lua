-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Clans = require(ReplicatedStorage.CAM:WaitForChild("Clans"));
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local u1 = {};

for i in Clans.TestClans do
    table.insert(u1, i);
end;

table.sort(u1);

return {
    Clearance = 6,
    Keys = {
        {
            Type = "Players",
            Required = true
        },
        {
            Type = "Which",
            Name = "Which",
            Required = false,
            Suggester = u1,

            Completer = function(p2: string) -- Line: 38, Name: Completer
                -- upvalues: u1 (copy)
                if p2 == nil then
                    return nil;
                end;

                for _, v in ipairs(u1) do
                    if v:lower() == p2:lower() then
                        return v;
                    end;
                end;

                return nil;
            end
        }
    },

    Server = function(p3: userdata, p4: table, p5: string?) -- Line: 47, Name: Server
        -- upvalues: Clans (copy), Utility (copy)
        if p5 == nil or (Clans.TestClans[p5] == nil or not p5) then
            p5 = Clans.TEST_CLAN;
        end;

        for _, v in ipairs(p4) do
            local Clan = Utility.GetData(v, true):FindFirstChild("Clan");

            if Clan ~= nil then
                Clan.Value = p5;
            end;
        end;
    end
};
-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Utility = require(ReplicatedStorage.CAM.Global.Utility);

return {
    Clearance = 1,
    Keys = { {
            Type = "Players",
            Required = true
        } },

    Server = function(p1: userdata, p2: table) -- Line: 19, Name: Server
        -- upvalues: Utility (copy)
        for _, v in ipairs(p2) do
            local valuesfolder = Utility.getvaluesfolder(v);
            local v3;

            if valuesfolder == nil then
                v3 = nil;
            else
                v3 = valuesfolder:FindFirstChild("ModeBar") or nil;
            end;

            if v3 ~= nil then
                v3.Value = v3.MaxValue;
            end;
        end;
    end
};
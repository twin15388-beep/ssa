-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local ServerStorage = game:GetService("ServerStorage");
local u1;

if RunService:IsServer() then
    u1 = require(ServerStorage.SAM.Services.ServerNpcUtil);
else
    u1 = nil;
end;

return {
    Clearance = 1,
    Keys = {
        {
            Type = "Players",
            Required = true
        },
        {
            Type = "Config",
            Name = "Config",
            Required = false,
            Suggester = { "Default" },

            Completer = function(p2: string) -- Line: 32, Name: Completer
                if p2 == nil or p2 == "" then
                    return nil;
                end;

                return p2;
            end
        }
    },

    Server = function(p3: userdata, p4: table, p5: string?) -- Line: 38, Name: Server
        -- upvalues: ServerStorage (copy), u1 (copy)
        local v6 = (p5 == nil or p5 == "") and "Default" or p5;

        if type(p4) ~= "table" or #p4 == 0 then
            error("SpawnNpc: no valid players targeted");
        end;

        local TempNpcs = ServerStorage.SAM:FindFirstChild("TempNpcs");

        if TempNpcs == nil or TempNpcs:FindFirstChild(v6) == nil then
            error((`SpawnNpc: no temp NPC config named "{v6}" in ServerStorage.SAM.TempNpcs`));
        end;

        for _, v in ipairs(p4) do
            local Character = v.Character;

            if Character ~= nil then
                u1.SpawnTempNpc(v6, {
                    LockTarget = true,
                    Position = (Character:GetPivot() * CFrame.new(0, 0, -8)).Position,
                    Target = v
                });
            end;
        end;
    end
};
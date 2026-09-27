-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local ServerStorage = game:GetService("ServerStorage");
local v1 = RunService:IsServer();
local Titles = require(ReplicatedStorage.CAM.Global.Titles);
local u2 = v1 and require(ServerStorage.SAM.Services.TitleService) or nil;
local v3 = {};
local u4 = {};
local u5 = { "Unlock", "Lock" };

for i, v in Titles.GetAll() do
    table.insert(v3, i);
    u4[i:lower()] = i;

    if type(v.displayName) == "string" then
        u4[v.displayName:lower()] = i;
    end;
end;

table.sort(v3);

local function named(p6: table, p7: any) -- Line: 32
    local v8 = tostring(p7):lower();

    for _, v in p6 do
        if v:lower() == v8 then
            return v;
        end;
    end;

    return nil;
end;

return {
    Clearance = 6,
    Keys = {
        {
            Type = "Players",
            Required = true
        },
        {
            Type = "Action",
            Name = "Action",
            Required = true,
            Suggester = u5,

            Completer = function(p9: string) -- Line: 54, Name: Completer
                -- upvalues: u5 (copy)
                local v10 = tostring(p9):lower();

                for _, v in u5 do
                    if v:lower() == v10 then
                        return v;
                    end;
                end;

                return nil;
            end
        },
        {
            Type = "Title",
            Name = "Title",
            Required = true,
            Suggester = v3,

            Completer = function(p11: string) -- Line: 64, Name: Completer
                -- upvalues: u4 (copy)
                if p11 == nil or p11 == "" then
                    return nil;
                end;

                return u4[p11:lower()] or p11;
            end
        }
    },

    Server = function(p12: userdata, p13: table, p14: string, p15: any) -- Line: 70, Name: Server
        -- upvalues: u5 (copy), u4 (copy), u2 (copy)
        local v16 = tostring(p14):lower();
        local v17 = nil;

        for _, v in u5 do
            if v:lower() == v16 then
                v17 = v;
                break;
            end;
        end;

        if v17 == nil then
            error((`Invalid title action: {tostring(p14)} (Unlock or Lock)`));
        end;

        local v18 = u4[tostring(p15):lower()];

        if v18 == nil then
            error((`No title "{tostring(p15)}"`));
        end;

        local v19;

        if v17 == "Unlock" then
            v19 = u2.Unlock;
        else
            v19 = u2.Lock;
        end;

        local v20 = true;
        local v21 = {};

        for _, v in p13 do
            local v22, v23 = v19(v, v18);
            local v24 = `{v.Name}: {v23}`;
            table.insert(v21, v24);
            v20 = v20 and v22;
        end;

        local v25 = {
            Content = table.concat(v21, "\n"),
            ContentColor = Color3.new(1, 1, 1)
        };
        local v26;

        if v20 then
            if v17 == "Unlock" then
                v26 = Color3.fromRGB(30, 110, 60);
            else
                v26 = Color3.fromRGB(150, 80, 30);
            end;
        else
            v26 = Color3.fromRGB(150, 30, 30);
        end;

        v25.BgColor = v26;

        return v25;
    end
};
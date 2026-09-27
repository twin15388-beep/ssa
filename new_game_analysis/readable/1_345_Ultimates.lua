-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local v1 = RunService:IsServer();
local PlayerProfile = require(ReplicatedStorage.CAM.Global.PlayerProfile);
local u2;

if v1 then
    u2 = require(ReplicatedStorage.CAM.Global.SkillService.SkillTreeholder.Requirements.Boss) or nil;
else
    u2 = nil;
end;

local u3;

if v1 then
    u3 = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent) or nil;
else
    u3 = nil;
end;

local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);

local function bossGated() -- Line: 22
    -- upvalues: PlayerProfile (copy)
    local v4 = {};
    local v5 = {};
    local v6 = {};

    for i, v in PlayerProfile.skill_info do
        if typeof(v) == "table" and v.Boss ~= nil then
            v4[i] = v;
            local v7 = v.Category or i;

            if not v5[v7] then
                v5[v7] = true;
                table.insert(v6, v7);
            end;
        end;
    end;

    table.sort(v6);

    return v4, v6;
end;

return {
    Clearance = 1,
    Keys = {
        {
            Type = "Players",
            Required = true
        },
        {
            Type = "String",
            Name = "Category",
            Required = false,

            Suggester = function() -- Line: 39, Name: categorySuggestions
                -- upvalues: bossGated (copy)
                local _, v8 = bossGated();

                return v8, true;
            end,

            Completer = function(p9: string) -- Line: 58, Name: Completer
                -- upvalues: bossGated (copy)
                if p9 == nil or p9 == "" then
                    return nil;
                end;

                local v10 = p9:lower();
                local _, v11 = bossGated();

                for _, v in v11, true do
                    if v:lower() == v10 then
                        return v;
                    end;
                end;

                return p9;
            end
        }
    },

    Server = function(p12: userdata, p13: table, p14: any) -- Line: 70, Name: Server
        -- upvalues: bossGated (copy), u2 (copy), gameSettings (copy), u3 (copy)
        local v15, v16 = bossGated();
        local v17 = nil;

        if typeof(p14) == "string" and p14 ~= "" then
            for _, v in v16 do
                if v:lower() == p14:lower() then
                    v17 = v;
                    break;
                end;
            end;
        end;

        for _, v in p13 do
            local v18 = v;
            local v19 = {};

            for i, v2 in v15 do
                if (v17 == nil or (v2.Category or i) == v17) and u2.Grant(v18, i) then
                    table.insert(v19, i);
                end;
            end;

            if #v19 > 0 then
                table.sort(v19);
                local SoroundColor = gameSettings.RichTextPopularConfigs.SoroundColor;
                u3.ToClient(v18, "Notify", {
                    Type = "Success",
                    Duration = 10,
                    Text = `\\[['{table.concat(v19, ", ")}']<{SoroundColor}>] obtained, open your Skill Tree!`
                });
            end;
        end;
    end
};
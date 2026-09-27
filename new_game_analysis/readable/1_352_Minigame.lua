-- Decompiled with Potassium's decompiler.

local HttpService = game:GetService("HttpService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local ServerScriptService = game:GetService("ServerScriptService");
local u1 = require(ReplicatedStorage.Packages["data-serializer"]);
local HudGrid = require(ReplicatedStorage.CAM.HudGrid);
local MinigameSettings = require(ReplicatedStorage.CAM.Global.MinigameSettings);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local u2 = {};

for i, v in MinigameSettings.Settings do
    local v3 = {};

    for i2 in v.Modes or {} do
        table.insert(v3, i2);
    end;

    u2[i] = v3;
end;

for i, v in HudGrid.Grid do
    local v4 = u2[v.Minigame];

    if v4 == nil then
        v4 = {};
        u2[v.Minigame] = v4;
    end;

    if table.find(v4, i) == nil then
        table.insert(v4, i);
    end;
end;

local u5 = {};

for i, v in u2 do
    table.sort(v);
    table.insert(u5, i);
end;

table.sort(u5);

return {
    Clearance = 7,
    Keys = {
        {
            Type = "Players",
            Required = true
        },
        {
            Type = "Minigame",
            Name = "Minigame",
            Required = true,
            Suggester = u5,

            Completer = function(p6: string) -- Line: 74, Name: Completer
                -- upvalues: u5 (copy)
                if p6 == nil or p6 == "" then
                    return nil;
                end;

                local v7 = p6:lower();

                for _, v in u5 do
                    if v:lower() == v7 then
                        return v;
                    end;
                end;

                return nil;
            end
        },
        {
            Type = "Gamemode",
            Name = "Gamemode",
            Required = false,

            Suggester = function(p8: table) -- Line: 89, Name: Suggester
                -- upvalues: u2 (copy)
                return u2[p8[2] or ""], true;
            end,

            Completer = function(p9: string, p10: table) -- Line: 92, Name: Completer
                -- upvalues: u2 (copy)
                if p9 == nil or p9 == "" then
                    return nil;
                end;

                local v11 = p9:lower();

                for _, v in u2[p10[2] or ""] or {} do
                    if v:lower() == v11 then
                        return v;
                    end;
                end;

                return nil;
            end
        }
    },

    Server = function(p12: userdata, p13: table, p14: string, p15: string?) -- Line: 103, Name: Server
        -- upvalues: RunService (copy), gameSettings (copy), u2 (copy), u5 (copy), HttpService (copy), HudGrid (copy), Utility (copy), u1 (copy), ServerScriptService (copy)
        if RunService:IsStudio() then
            error("Minigame: Studio refuses teleports — run this in a published server");
        end;

        if gameSettings.IsMinigame then
            error("Minigame: can\'t re-queue from inside a minigame (TeleportData rides the save, which a run may have disabled) — go home first");
        end;

        if #p13 == 0 then
            error("Minigame: no players targeted (use `me`)");
        end;

        local v16 = u2[p14];

        if v16 == nil then
            error((`Minigame: no minigame named "{p14}" ({table.concat(u5, ", ")})`));
        end;

        if p15 == "" then
            p15 = nil;
        end;

        if p15 == nil and #v16 > 0 then
            error((`Minigame: {p14} needs a gamemode ({table.concat(v16, ", ")})`));
        elseif p15 ~= nil and table.find(v16, p15) == nil then
            error((`Minigame: {p14} has no gamemode "{p15}"`));
        end;

        local v17 = HttpService:GenerateGUID(false);
        local v18 = HudGrid.ByName[p15];
        local v19;

        if v18 == nil then
            v19 = #p13;
        else
            v19 = v18.Players;
        end;

        local v20 = {};

        for _, v in p13 do
            local _, v21 = Utility.GetData(v);

            if v21 ~= nil then
                local TeleportData = v21:FindFirstChild("TeleportData");

                if TeleportData ~= nil then
                    TeleportData:Destroy();
                end;

                local tofold = u1.tofold;
                local v22 = {};
                local v23 = {
                    Minigame = p14,
                    Gamemode = p15,
                    TeleportId = v17
                };
                local v24;

                if #v20 < v19 then
                    v24 = v17 .. "-A";
                else
                    v24 = v17 .. "-B";
                end;

                v23.TicketId = v24;
                v23.PlaceId = game.PlaceId;
                v23.JobId = game.JobId;
                v22.TeleportData = v23;
                tofold(v22, v21);
                table.insert(v20, v);
            end;
        end;

        if #v20 == 0 then
            error("Minigame: no targeted player has loaded data to stamp");
        end;

        if not require(ServerScriptService.USC.TeleportHandler).GroupToPrivateServer(gameSettings.HUDQueuPlaceId, v20, {
            Title = "Minigame",
            SubTitle = p15 or p14
        }) then
            error("Minigame: the teleport failed — check the server log");
        end;

        return {
            Content = `Sent {#v20} player(s) into {p14}{p15 == nil and "" or ` ({p15})`}`,
            BgColor = Color3.fromRGB(32, 143, 70),
            FgColor = Color3.new(1, 1, 1)
        };
    end
};
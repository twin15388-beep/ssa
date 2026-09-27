-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local ServerScriptService = game:GetService("ServerScriptService");
local Worlds = require(ReplicatedStorage.CAM.Worlds);
local u1 = {};

for i, v in Worlds.Grid do
    if v.Ignore ~= true then
        table.insert(u1, i);
    end;
end;

table.sort(u1);

return {
    Clearance = 7,
    Keys = {
        {
            Type = "Players",
            Required = true,

            Completer = function(p2: string) -- Line: 36, Name: Completer
                -- upvalues: Players (copy)
                if p2 == nil or p2 == "" then
                    return nil;
                end;

                local v3 = p2:lower();

                if v3 == "all" then
                    return Players:GetPlayers();
                end;

                if v3 == "all except me" then
                    local v4 = {};

                    for _, v in Players:GetPlayers() do
                        if v ~= Players.LocalPlayer then
                            table.insert(v4, v);
                        end;
                    end;

                    return v4;
                end;

                local v5 = {};

                for i in p2:gmatch("[^,]+") do
                    local v6 = i:match("^%s*(.-)%s*$");
                    local v7;

                    if v6:lower() == "me" then
                        v7 = Players.LocalPlayer;
                    else
                        v7 = Players:FindFirstChild(v6);
                    end;

                    if v7 == nil or (not v7:IsA("Player") or table.find(v5, v7) ~= nil) then
                        return nil;
                    end;

                    table.insert(v5, v7);
                end;

                if #v5 > 0 then
                    return v5;
                end;

                return nil;
            end
        },
        {
            Type = "World",
            Name = "World",
            Required = false,
            Suggester = u1,

            Completer = function(p8: string) -- Line: 70, Name: Completer
                -- upvalues: u1 (copy)
                if p8 == nil or p8 == "" then
                    return nil;
                end;

                local v9 = p8:lower();

                for _, v in u1 do
                    if v:lower() == v9 then
                        return v;
                    end;
                end;

                return nil;
            end
        }
    },

    Server = function(p10: userdata, p11: table, p12: string?) -- Line: 80, Name: Server
        -- upvalues: RunService (copy), Worlds (copy), u1 (copy), ServerScriptService (copy)
        if RunService:IsStudio() then
            error("Private: Studio refuses teleports — run this in a published server");
        end;

        if #p11 == 0 then
            error("Private: no players targeted (use `me`)");
        end;

        local game_PlaceId = game.PlaceId;

        if p12 ~= nil then
            local v13 = Worlds.ByName[p12];

            if v13 == nil or v13.Ignore == true then
                error((`Private: no world named "{p12}" ({table.concat(u1, ", ")})`));
            end;

            game_PlaceId = v13.Id;
        end;

        if not require(ServerScriptService.USC.TeleportHandler).GroupToPrivateServer(game_PlaceId, p11, {
            SubTitle = "Private Server"
        }) then
            error("Private: the teleport failed — check the server log");
        end;

        return {
            Content = `Sent {#p11} player(s) into a fresh private server`,
            BgColor = Color3.fromRGB(32, 143, 70),
            FgColor = Color3.new(1, 1, 1)
        };
    end
};
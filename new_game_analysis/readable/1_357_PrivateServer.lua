-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ServerStorage = game:GetService("ServerStorage");
local u1 = { "Info", "Join", "Suspend", "Unsuspend", "Kick", "Ban", "Unban", "Whitelist", "Unwhitelist", "Mod", "Unmod", "Access", "PvP", "PvE", "Announce", "Shutdown" };
local u2 = {
    Join = { "JoinPrivateServer", true },
    Kick = { "Kick", false },
    Ban = { "BanAdd", true },
    Unban = { "BanRemove", true },
    Whitelist = { "WhitelistAdd", true },
    Unwhitelist = { "WhitelistRemove", true },
    Mod = { "ModeratorAdd", true },
    Unmod = { "ModeratorRemove", true }
};
local u3 = { "on", "off" };
local u4 = { "closed", "friends", "everyone" };

local function named(p5) -- Line: 40
    -- upvalues: u1 (copy)
    local v6 = tostring(p5):lower();

    for _, v in u1 do
        if v:lower() == v6 then
            return v;
        end;
    end;

    return nil;
end;

return {
    Clearance = 1,
    Keys = {
        {
            Type = "Action",
            Name = "Action",
            Required = true,
            Suggester = u1,

            Completer = function(p7: string) -- Line: 56, Name: Completer
                -- upvalues: u1 (copy)
                if p7 == nil or p7 == "" then
                    return nil;
                end;

                local v8 = tostring(p7):lower();

                for _, v in u1 do
                    if v:lower() == v8 then
                        return v;
                    end;
                end;

                return nil;
            end
        },
        {
            Type = "Value",
            Name = "Value",
            Required = false,

            Suggester = function(p9: table) -- Line: 65, Name: Suggester
                -- upvalues: u1 (copy), u3 (copy), u4 (copy), u2 (copy), Players (copy)
                local v10 = tostring(p9[1] or ""):lower();
                local v11 = nil;

                for _, v in u1 do
                    if v:lower() == v10 then
                        v11 = v;
                        break;
                    end;
                end;

                if v11 == "PvP" or v11 == "PvE" then
                    return u3, true;
                end;

                if v11 == "Access" then
                    return u4, true;
                end;

                if u2[v11] == nil then
                    return nil;
                end;

                local v12 = {};

                for _, v in Players:GetPlayers() do
                    table.insert(v12, v.Name);
                end;

                return v12, true;
            end,

            Completer = function(p13: string) -- Line: 79, Name: Completer
                if p13 == nil or p13 == "" then
                    return nil;
                end;

                return p13;
            end
        }
    },

    Server = function(p14: userdata, p15: string, p16: string?) -- Line: 85, Name: Server
        -- upvalues: u1 (copy), ServerStorage (copy), Players (copy), u2 (copy)
        local v17 = tostring(p15):lower();
        local v18 = nil;

        for _, v in u1 do
            if v:lower() == v17 then
                v18 = v;
                break;
            end;
        end;

        if v18 == nil then
            error((`PrivateServer: unknown action "{p15}" ({table.concat(u1, ", ")})`));
        end;

        local PrivateServerService = require(ServerStorage.SAM.Services.PrivateServerService);
        PrivateServerService.ResolveSession();

        if v18 ~= "Info" then
            local v19 = u2[v18];
            local v20, v21;

            if v19 == nil then
                if v18 == "PvP" or v18 == "PvE" then
                    if p16 ~= "on" and p16 ~= "off" then
                        error((`PrivateServer: {v18} takes on or off`));
                    end;

                    v20, v21 = PrivateServerService.SetSetting(p14, v18, p16 == "on");
                elseif v18 == "Access" then
                    local v22 = p16 or "";
                    v20, v21 = PrivateServerService.SetAccess(p14, v22:sub(1, 1):upper() .. v22:sub(2):lower());
                elseif v18 == "Announce" then
                    v20, v21 = PrivateServerService.Announce(p14, p16);
                else
                    v20, v21 = PrivateServerService[v18](p14);
                end;
            else
                local v23, v24 = PrivateServerService.ResolveUserId(p16, v19[2]);

                if v23 == nil then
                    error((`PrivateServer: {v24}`));
                end;

                v20, v21 = PrivateServerService[v19[1]](p14, v23);
            end;

            if not v20 then
                error((`PrivateServer: {v21}`));
            end;

            return {
                Content = v21,
                BgColor = Color3.fromRGB(32, 143, 70),
                FgColor = Color3.new(1, 1, 1)
            };
        end;

        local State = PrivateServerService.GetState(p14);

        if State == nil then
            error("PrivateServer: this isn\'t a private server");
        end;

        local u25 = tostring(State.OwnerId);
        pcall(function() -- Line: 99
            -- upvalues: u25 (ref), Players (ref), State (copy)
            u25 = Players:GetNameFromUserIdAsync(State.OwnerId);
        end);
        local v26 = {};

        for _, v in State.Occupants do
            local v27 = `{v.Name} ({v.Role})`;
            table.insert(v26, v27);
        end;

        return {
            Content = table.concat({
                `Owner: {u25}`,
                `Access: {State.Settings.Access} · PvP {State.Settings.PvP and "on" or "off"} · PvE {State.Settings.PvE and "on" or "off"}`,
                `Suspended: {State.Suspended and "yes" or "no"}`,
                `Moderators: {#(State.Moderators or {})} · Whitelist: {#(State.Whitelist or {})} · Bans: {#(State.Bans or {})}`,
                (`Here: {table.concat(v26, ", ")}`)
            }, "\n"),
            BgColor = Color3.fromRGB(40, 40, 40),
            FgColor = Color3.new(1, 1, 1)
        };
    end
};
-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");

return {
    Clearance = 7,
    Keys = {
        {
            Type = "Action",
            Name = "Action",
            Required = true,
            Suggester = { "Start", "End", "Hearts", "Timer" }
        },
        {
            Type = "Value",
            Name = "Value",
            Required = false,

            Completer = function(p1: string) -- Line: 32, Name: Completer
                if p1 == nil or p1 == "" then
                    return nil;
                end;

                return p1;
            end
        }
    },

    Server = function(p2: userdata, p3: string, p4: string?) -- Line: 38, Name: Server
        -- upvalues: ReplicatedStorage (copy)
        if workspace:GetAttribute("MinigameKey") ~= "PvP" then
            error("Pvp: only works on a PvP minigame server");
        end;

        local v5 = ReplicatedStorage:FindFirstChild("Minigames Place");
        local v6;

        if v5 == nil then
            v6 = nil;
        else
            v6 = v5:FindFirstChild("Minigames") or nil;
        end;

        local v7;

        if v6 == nil then
            v7 = nil;
        else
            v7 = v6:FindFirstChild("PvP") or nil;
        end;

        if v7 == nil then
            error("Pvp: no PvP minigame module in this place");
        end;

        local v8 = require(v7);
        local string_lower_ret = string.lower((tostring(p3)));

        if string_lower_ret == "start" then
            v8.DebugStart();

            return;
        end;

        if string_lower_ret == "end" then
            local v9;

            if p4 == nil then
                v9 = nil;
            else
                v9 = string.upper(p4) or nil;
            end;

            if v9 ~= nil and (v9 ~= "A" and v9 ~= "B") then
                error((`Pvp: side must be A or B, got "{p4}"`));
            end;

            v8.DebugEnd(v9);

            return;
        end;

        if string_lower_ret == "hearts" then
            local v10 = tonumber(p4);

            if v10 == nil then
                error("Pvp: hearts needs a number, e.g. pvp hearts 0");
            end;

            v8.DebugSetHearts({ p2 }, (math.floor(v10)));

            return;
        end;

        if string_lower_ret ~= "timer" then
            error((`Pvp: unknown action "{string_lower_ret}" (Start, End, Hearts, Timer)`));

            return;
        end;

        local v11 = tonumber(p4);

        if v11 == nil or v11 <= 0 then
            error("Pvp: timer needs a positive number of seconds");
        end;

        v8.DebugTimer(v11);
    end
};
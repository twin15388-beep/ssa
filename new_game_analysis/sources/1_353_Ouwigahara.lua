-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");

return {
    Clearance = 7,
    Keys = {
        {
            Type = "Action",
            Name = "Action",
            Required = true,
            Suggester = { "End", "Rebuild" }
        },
        {
            Type = "Value",
            Name = "Mode",
            Required = false,

            Completer = function(p1: string) -- Line: 28, Name: Completer
                if p1 == nil or p1 == "" then
                    return nil;
                end;

                return p1;
            end
        },
        {
            Type = "Value",
            Name = "Season",
            Required = false,

            Completer = function(p2: string) -- Line: 37, Name: Completer
                if p2 == nil or p2 == "" then
                    return nil;
                end;

                return p2;
            end
        }
    },

    Server = function(p3: userdata, p4: string, u5: string?, p6: string?) -- Line: 43, Name: Server
        -- upvalues: ReplicatedStorage (copy)
        if workspace:GetAttribute("MinigameKey") ~= "Ouwigahara" then
            error("Ouwigahara: only works on an Ouwigahara minigame server");
        end;

        local v7 = ReplicatedStorage:FindFirstChild("Minigames Place");
        local v8;

        if v7 == nil then
            v8 = nil;
        else
            v8 = v7:FindFirstChild("Minigames") or nil;
        end;

        local v9;

        if v8 == nil then
            v9 = nil;
        else
            v9 = v8:FindFirstChild("Ouwigahara") or nil;
        end;

        if v9 == nil then
            error("Ouwigahara: no Ouwigahara minigame module in this place");
        end;

        local string_lower_ret = string.lower((tostring(p4)));

        if string_lower_ret == "end" then
            if not require(v9.Run).End((`The run was ended by {p3.Name}`)) then
                error("Ouwigahara: no run is live");
            end;
        else
            if string_lower_ret == "rebuild" then
                local Score = require(v9.Score);

                if u5 == nil or u5 == "" then
                    error("Ouwigahara: rebuild needs a mode (Normal, Roguelike)");
                end;

                local u10;

                if p6 == nil or p6 == "" then
                    u10 = Score.Season();
                else
                    u10 = tonumber(p6);
                end;

                if u10 == nil then
                    error("Ouwigahara: the season is a number");
                end;

                task.spawn(function() -- Line: 63
                    -- upvalues: Score (copy), u5 (copy), u10 (copy)
                    local v11 = Score.Rebuild(u5, u10);
                    local v12 = print;
                    local v13;

                    if v11 == nil then
                        v13 = `[Ouwigahara] {u5} season {u10}: rebuild failed, see the warnings`;
                    else
                        v13 = `[Ouwigahara] {u5} season {u10}: histogram rebuilt, population {v11}`;
                    end;

                    v12(v13);
                end);

                return {
                    Content = `{u5} season {u10}: rebuilding from the board, the result prints to the server output`,
                    BgColor = Color3.fromRGB(32, 143, 70),
                    FgColor = Color3.new(1, 1, 1)
                };
            end;

            error((`Ouwigahara: unknown action "{string_lower_ret}" (End, Rebuild)`));
        end;

        return nil;
    end
};
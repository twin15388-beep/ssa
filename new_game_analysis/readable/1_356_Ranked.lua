-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerStorage = game:GetService("ServerStorage");
local Ranked = require(ReplicatedStorage.CAM.Global.Ranked);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);

local function describe(u1: userdata) -- Line: 22
    -- upvalues: Ranked (copy)
    local function v(p2: string) -- Line: 23
        -- upvalues: u1 (copy)
        local v3 = u1:FindFirstChild(p2);

        if v3 == nil then
            return nil;
        end;

        return v3.Value;
    end;

    local Points = u1:FindFirstChild("Points");
    local v4;

    if Points == nil then
        v4 = nil;
    else
        v4 = Points.Value;
    end;

    local v5 = v4 or 0;
    local _, v6 = Ranked.TierOf(v5);
    local Name = u1.Name;
    local string_format = string.format;
    local Mu = u1:FindFirstChild("Mu");
    local v7;

    if Mu == nil then
        v7 = nil;
    else
        v7 = Mu.Value;
    end;

    local v8 = string_format("%.2f", v7 or 0);
    local string_format2 = string.format;
    local Sigma = u1:FindFirstChild("Sigma");
    local v9;

    if Sigma == nil then
        v9 = nil;
    else
        v9 = Sigma.Value;
    end;

    local v10 = string_format2("%.2f", v9 or 0);
    local Name2 = v6.Name;
    local Placements = u1:FindFirstChild("Placements");
    local v11;

    if Placements == nil then
        v11 = nil;
    else
        v11 = Placements.Value;
    end;

    local Peak = u1:FindFirstChild("Peak");
    local v12;

    if Peak == nil then
        v12 = nil;
    else
        v12 = Peak.Value;
    end;

    local Season = u1:FindFirstChild("Season");
    local v13;

    if Season == nil then
        v13 = nil;
    else
        v13 = Season.Value;
    end;

    local Wins = u1:FindFirstChild("Wins");
    local v14;

    if Wins == nil then
        v14 = nil;
    else
        v14 = Wins.Value;
    end;

    local Losses = u1:FindFirstChild("Losses");
    local v15;

    if Losses == nil then
        v15 = nil;
    else
        v15 = Losses.Value;
    end;

    return `{Name}: Mu {v8} Sigma {v10} | {v5} {Name2} | placements {v11 or 0} peak {v12 or 0} | season {v13 or "?"} | W{v14 or 0} L{v15 or 0}`;
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
            Suggester = { "Show", "Reset", "Rollover", "Cutoffs", "Points", "Rebuild" }
        },
        {
            Type = "Value",
            Name = "Key",
            Required = false,

            Completer = function(p16: string) -- Line: 50, Name: Completer
                if p16 == nil or p16 == "" then
                    return nil;
                end;

                return p16;
            end
        },
        {
            Type = "Value",
            Name = "Value",
            Required = false,

            Completer = function(p17: string) -- Line: 59, Name: Completer
                if p17 == nil or p17 == "" then
                    return nil;
                end;

                return p17;
            end
        }
    },

    Server = function(p18: userdata, p19: table, p20: string, u21: string?, u22: string?) -- Line: 65, Name: Server
        -- upvalues: ServerStorage (copy), Ranked (copy), Utility (copy), describe (copy)
        local RankedRecord = require(ServerStorage.SAM.Utility.RankedRecord);
        local RankedBoard = require(ServerStorage.SAM.Utility.RankedBoard);
        local string_lower_ret = string.lower((tostring(p20)));

        if u21 == "" then
            u21 = nil;
        end;

        if u21 ~= nil and not Ranked.IsKey(u21) then
            error((`Ranked: "{u21}" is not a ladder key (1v1, 2v2, 3v3, Tourney:<style>)`));
        end;

        local v23 = {};

        for _, v in p19 do
            local _, v24 = Utility.GetData(v);
            local v25 = RankedRecord.Root(v24);

            if v25 == nil then
                local v26 = `{v.Name}: data not loaded`;
                table.insert(v23, v26);
            elseif string_lower_ret == "show" then
                local v27 = `{v.Name} (season {Ranked.Season()}):`;
                table.insert(v23, v27);
                local v28;

                if u21 == nil then
                    v28 = v25.Modes:GetChildren();
                else
                    v28 = { v25.Modes:FindFirstChild(u21) };
                end;

                if #v28 == 0 or v28[1] == nil then
                    table.insert(v23, "  no ladders yet");
                end;

                for _, v2 in v28 do
                    local v29 = "  " .. describe(v2);
                    table.insert(v23, v29);
                end;

                for _, child in v25.Pending:GetChildren() do
                    local v30 = `  pending {child.Name}: {child.Value}`;
                    table.insert(v23, v30);
                end;

                for _, child in v25.Claimed:GetChildren() do
                    local v31 = `  claimed {child.Name}: {child.Value}`;
                    table.insert(v23, v31);
                end;
            elseif string_lower_ret == "reset" then
                local v32;

                if u21 == nil then
                    v32 = v25.Modes:GetChildren();
                else
                    v32 = { v25.Modes:FindFirstChild(u21) };
                end;

                for _, v2 in v32 do
                    v2:Destroy();
                end;

                if u21 == nil then
                    v25.Recent.Value = "";

                    for _, child in v25.Pending:GetChildren() do
                        child:Destroy();
                    end;

                    for _, child in v25.Claimed:GetChildren() do
                        child:Destroy();
                    end;
                end;

                local v33 = `{v.Name}: reset {u21 or "every ladder"}`;
                table.insert(v23, v33);
            elseif string_lower_ret == "rollover" then
                if u21 == nil then
                    error("Ranked: rollover needs a key");
                end;

                local v34 = v25.Modes:FindFirstChild(u21);

                if v34 == nil then
                    error((`Ranked: {v.Name} has no {u21} ladder yet`));
                end;

                local Season = v34:FindFirstChild("Season");

                if Season == nil then
                    error((`Ranked: {v.Name}'s {u21} ladder has no Season`));
                end;

                Season.Value = Ranked.Previous(Ranked.Season());
                RankedRecord.Entry(v24, u21);
                local v35 = `{v.Name}: rolled {u21} over — {describe(v34)}`;
                table.insert(v23, v35);
                local v36 = v25.Pending:FindFirstChild(u21);
                local v37 = `  pending: {v36 == nil and "none" or v36.Value}`;
                table.insert(v23, v37);
            else
                if string_lower_ret == "cutoffs" then
                    if u21 == nil then
                        error("Ranked: cutoffs needs a key");
                    end;

                    if u22 == nil or u22 == "" then
                        u22 = Ranked.Previous(Ranked.Season());
                    end;

                    if Ranked.Season() <= u22 then
                        error((`Ranked: cutoffs are only computed for a FINISHED season (before {Ranked.Season()})`));
                    end;

                    local v38, v39 = RankedBoard.Cutoffs(u21, u22);

                    if v38 == nil then
                        local v40 = `{u21} {u22}: the ledger did not answer`;
                        table.insert(v23, v40);
                    else
                        local v41 = {};

                        for i, v2 in v38 do
                            local v42 = `{i} >= {v2}`;
                            table.insert(v41, v42);
                        end;

                        local v43 = `{u21} {u22}: population {v39 or "?"}; {#v41 <= 0 and "nobody qualifies" or table.concat(v41, ", ")}`;
                        table.insert(v23, v43);
                    end;

                    break;
                end;

                if string_lower_ret == "points" then
                    if u21 == nil then
                        error("Ranked: points needs a key");
                    end;

                    local v44 = tonumber(u22);

                    if v44 == nil then
                        error("Ranked: points needs a number");
                    end;

                    local v45 = RankedRecord.Entry(v24, u21);

                    if v45 == nil then
                        error((`Ranked: {v.Name}'s data is not loaded`));
                    end;

                    local v46 = RankedRecord.Read(v45);
                    local math_floor_ret = math.floor(v44);
                    v46.Points = math.max(math_floor_ret, 0);
                    local Peak = v46.Peak;
                    local v47 = Ranked.TierOf(v46.Points);
                    v46.Peak = math.max(Peak, v47);
                    RankedRecord.Write(v45, v46);

                    if Ranked.Placed(v46) then
                        task.spawn(RankedBoard.Submit, v.UserId, u21, v46.Points);
                    end;

                    local v48 = `{v.Name}: {describe(v45)}`;
                    table.insert(v23, v48);
                else
                    if string_lower_ret == "rebuild" then
                        if u21 == nil then
                            error("Ranked: rebuild needs a key");
                        end;

                        if u22 == nil or u22 == "" then
                            u22 = Ranked.Season();
                        end;

                        task.spawn(function() -- Line: 157
                            -- upvalues: RankedBoard (copy), u21 (ref), u22 (copy)
                            local v49 = RankedBoard.Rebuild(u21, u22);
                            local v50 = print;
                            local v51;

                            if v49 == nil then
                                v51 = `[Ranked] {u21} {u22}: rebuild failed, see the warnings`;
                            else
                                v51 = `[Ranked] {u21} {u22}: histogram rebuilt, population {v49}`;
                            end;

                            v50(v51);
                        end);
                        local v52 = `{u21} {u22}: rebuilding from the board, the result prints to the server output`;
                        table.insert(v23, v52);
                        break;
                    end;

                    error((`Ranked: unknown action "{string_lower_ret}" (Show, Reset, Rollover, Cutoffs, Points, Rebuild)`));
                end;
            end;
        end;

        return {
            Content = table.concat(v23, "\n"),
            BgColor = Color3.fromRGB(32, 143, 70),
            FgColor = Color3.new(1, 1, 1)
        };
    end
};
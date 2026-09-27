-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local MinigameSettings = require(ReplicatedStorage.CAM.Global.MinigameSettings);
local Ranked = require(ReplicatedStorage.CAM.Global.Ranked);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local TowerBoard = require(ReplicatedStorage.CAM.Global.TowerBoard);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local simplesignal = require(ReplicatedStorage.Packages.simplesignal);
local LocalPlayer = Players.LocalPlayer;
local u1 = {
    BoardReceived = simplesignal.new(),
    ResultReceived = simplesignal.new()
};

function u1.handleBoard(p2: table) -- Line: 47
    -- upvalues: u1 (copy)
    if type(p2) ~= "table" then
        return;
    end;

    u1.BoardReceived:Fire(p2);
end;

function u1.handleResult(p3: table) -- Line: 52
    -- upvalues: u1 (copy)
    if type(p3) ~= "table" then
        return;
    end;

    u1.ResultReceived:Fire(p3);
end;

function u1.RequestBoard(p4: string) -- Line: 58
    -- upvalues: SignalEvent (copy)
    SignalEvent.ToServer("RankedRequest", {
        action = "Board",
        key = p4
    });
end;

function u1.Mine(p5: string) -- Line: 63
    -- upvalues: Utility (copy), LocalPlayer (copy), MinigameSettings (copy)
    local _, v6 = Utility.GetData(LocalPlayer);
    local v7;

    if v6 == nil then
        v7 = nil;
    else
        v7 = v6:FindFirstChild("Ranked");
    end;

    local v8;

    if v7 == nil then
        v8 = nil;
    else
        v8 = v7:FindFirstChild("Modes");
    end;

    local v9;

    if v8 == nil then
        v9 = nil;
    else
        v9 = v8:FindFirstChild(p5);
    end;

    local v10;

    if v9 == nil then
        v10 = nil;
    else
        v10 = v9:FindFirstChild("Points");
    end;

    local v11;

    if v9 == nil then
        v11 = nil;
    else
        v11 = v9:FindFirstChild("Placements");
    end;

    if v10 == nil or (v11 == nil or v11.Value < MinigameSettings.Settings.PvP.Ranked.PlacementCount) then
        return nil;
    end;

    return v10.Value;
end;

function u1.Icon(p12: string) -- Line: 77
    -- upvalues: u1 (copy), Ranked (copy)
    local v13 = u1.Mine(p12);

    if v13 == nil then
        return nil;
    end;

    return Ranked.IconOf(v13);
end;

function u1.Claim(p14: string) -- Line: 83
    -- upvalues: SignalEvent (copy)
    SignalEvent.ToServer("RankedRequest", {
        action = "Claim",
        key = p14
    });
end;

function u1.KeyFor(p15: string) -- Line: 88
    -- upvalues: Ranked (copy), Utility (copy), LocalPlayer (copy)
    if p15 ~= Ranked.TOURNEY then
        return p15;
    end;

    local v16 = Ranked.BucketOf(Utility.GetData(LocalPlayer));

    if v16 == nil then
        return nil;
    end;

    return Ranked.KeyFor(p15, v16);
end;

function u1.Pending(p17: string) -- Line: 97
    -- upvalues: Utility (copy), LocalPlayer (copy), Ranked (copy)
    local _, v18 = Utility.GetData(LocalPlayer);
    local v19;

    if v18 == nil then
        v19 = nil;
    else
        v19 = v18:FindFirstChild("Ranked");
    end;

    local v20;

    if v19 == nil then
        v20 = nil;
    else
        v20 = v19:FindFirstChild("Pending");
    end;

    local v21;

    if v20 == nil then
        v21 = nil;
    else
        v21 = v20:FindFirstChild(p17);
    end;

    if v21 == nil then
        return nil, nil;
    end;

    local string_match_ret, v22 = string.match(v21.Value, "^([^:]+):(.+)$");

    if string_match_ret == Ranked.Previous(Ranked.Season()) then
        return string_match_ret, v22;
    end;

    return nil, nil;
end;

function u1.Line(p23: string) -- Line: 110
    -- upvalues: Utility (copy), LocalPlayer (copy), MinigameSettings (copy), Ranked (copy)
    local _, v24 = Utility.GetData(LocalPlayer);
    local v25;

    if v24 == nil then
        v25 = nil;
    else
        v25 = v24:FindFirstChild("Ranked");
    end;

    local v26;

    if v25 == nil then
        v26 = nil;
    else
        v26 = v25:FindFirstChild("Modes");
    end;

    local v27;

    if v26 == nil then
        v27 = nil;
    else
        v27 = v26:FindFirstChild(p23);
    end;

    if v27 == nil then
        return "Unranked";
    end;

    local Points = v27:FindFirstChild("Points");
    local Placements = v27:FindFirstChild("Placements");
    local v28 = Points == nil and 0 or Points.Value;
    local v29 = Placements == nil and 0 or Placements.Value;

    if v29 < MinigameSettings.Settings.PvP.Ranked.PlacementCount then
        return `Placement {v29}/{MinigameSettings.Settings.PvP.Ranked.PlacementCount}`;
    end;

    local _, v30 = Ranked.TierOf(v28);
    local Rank = v27:FindFirstChild("Rank");
    local Share = v27:FindFirstChild("Share");
    local v31 = `{v30.Name} · {Utility.addCommasToNumber(v28)}`;

    if Rank ~= nil and Rank.Value > 0 then
        return `{v31} · #{Rank.Value}`;
    end;

    if Share == nil or Share.Value <= 0 then
        return v31;
    end;

    return `{v31} · Top {Share.Value}%`;
end;

function u1.TowerLine(p32: string) -- Line: 137
    -- upvalues: Utility (copy), LocalPlayer (copy), TowerBoard (copy)
    local _, v33 = Utility.GetData(LocalPlayer);
    local v34;

    if v33 == nil then
        v34 = nil;
    else
        v34 = v33:FindFirstChild("Ranked");
    end;

    local v35;

    if v34 == nil then
        v35 = nil;
    else
        v35 = v34:FindFirstChild("Tower");
    end;

    local v36;

    if v35 == nil then
        v36 = nil;
    else
        v36 = v35:FindFirstChild(p32);
    end;

    local v37;

    if v36 == nil then
        v37 = nil;
    else
        v37 = v36:FindFirstChild("Season");
    end;

    local v38;

    if v36 == nil then
        v38 = nil;
    else
        v38 = v36:FindFirstChild("Best");
    end;

    local v39;

    if v36 == nil then
        v39 = nil;
    else
        v39 = v36:FindFirstChild("Rank");
    end;

    local v40;

    if v36 == nil then
        v40 = nil;
    else
        v40 = v36:FindFirstChild("Share");
    end;

    if v37 == nil or (v38 == nil or v37.Value ~= TowerBoard.Season()) then
        return "No ranked run yet";
    end;

    local v41 = `Best {Utility.addCommasToNumber(v38.Value)}`;

    if v39 ~= nil and v39.Value > 0 then
        return `{v41} · #{v39.Value}`;
    end;

    if v40 == nil or v40.Value <= 0 then
        return v41;
    end;

    return `{v41} · Top {v40.Value}%`;
end;

return u1;
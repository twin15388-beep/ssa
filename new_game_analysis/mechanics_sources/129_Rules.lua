-- Decompiled with Potassium's decompiler.

local u1 = {};
local u2 = { "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" };
local u3 = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };

local function daysIn(p4: number, p5: number) -- Line: 49
    -- upvalues: u3 (copy)
    return p5 == 2 and (p4 % 4 == 0 and (p4 % 100 ~= 0 or p4 % 400 == 0)) and 29 or u3[p5];
end;

function u1.Season(p6: number?) -- Line: 56
    local os_date_ret = os.date("!*t", p6 or os.time());

    return string.format("%04d-%02d", os_date_ret.year, os_date_ret.month);
end;

function u1.Previous(p7: string) -- Line: 61
    local string_match_ret, v8 = string.match(p7, "^(%d+)%-(%d+)$");
    local v9 = tonumber(string_match_ret);
    local v10 = tonumber(v8);

    if v10 == 1 then
        return string.format("%04d-%02d", v9 - 1, 12);
    end;

    return string.format("%04d-%02d", v9, v10 - 1);
end;

function u1.SeasonLabel(p11: string) -- Line: 70
    -- upvalues: u2 (copy)
    local string_match_ret, v12 = string.match(p11, "^(%d+)%-(%d+)$");
    local v13 = u2[tonumber(v12) or 0];

    if v13 == nil then
        return p11;
    end;

    return `{v13} {string_match_ret}`;
end;

function u1.SeasonEnds(p14: number?) -- Line: 77
    -- upvalues: u3 (copy)
    local v15 = p14 or os.time();
    local os_date_ret = os.date("!*t", v15);
    local year = os_date_ret.year;
    local month = os_date_ret.month;

    return v15 - ((os_date_ret.day - 1) * 86400 + os_date_ret.hour * 3600 + os_date_ret.min * 60 + os_date_ret.sec) + (month == 2 and (year % 4 == 0 and (year % 100 ~= 0 or year % 400 == 0)) and 29 or u3[month]) * 86400;
end;

function u1.Display(p16: table, p17: number) -- Line: 88
    return p16.DisplayBase + (p17 - 25) * p16.DisplayScale;
end;

function u1.TierOf(p18: table, p19: number) -- Line: 93
    local Tiers = p18.Tiers;
    local v20 = 1;

    for i, v in Tiers do
        if v.Threshold > p19 then
            break;
        end;

        v20 = i;
    end;

    return v20, Tiers[v20];
end;

function u1.PointsFor(p21: table, p22: number) -- Line: 107
    local Tiers = p21.Tiers;
    local v23 = 1;

    for i, v in Tiers do
        if p21.PlacementCapTier < i then
            break;
        end;

        if v.Anchor <= p22 then
            v23 = i;
        end;
    end;

    return Tiers[v23].Threshold;
end;

function u1.Floor(p24: table, p25: number) -- Line: 122
    local math_min_ret = math.min(p25, p24.FloorTierMax);

    return math_min_ret < 1 and 0 or p24.Tiers[math_min_ret].Threshold;
end;

function u1.Placed(p26: table, p27: table) -- Line: 130
    return p27.Placements >= p26.PlacementCount;
end;

function u1.Delta(p28: table, p29: table, p30: string, p31: number) -- Line: 140
    -- upvalues: u1 (copy)
    if p30 == "Draw" then
        return 0;
    end;

    if p30 == "Dodge" then
        return -p28.DodgePoints;
    end;

    local _, v32 = u1.TierOf(p28, p29.Points);
    local v33 = (u1.Display(p28, p29.Mu) - v32.Anchor) / p28.GapScale;
    local math_clamp_ret = math.clamp(v33, -1, 1);
    local v34 = 1 - p31 * 2;

    if p30 == "Win" then
        return math.round(p28.WinPoints * (p28.GapBonus * math_clamp_ret + 1) * (p28.OddsBonus * v34 + 1));
    end;

    return -math.round(p28.LossPoints * (1 - p28.GapBonus * math_clamp_ret) * (1 - p28.OddsBonus * v34));
end;

function u1.Apply(p35: table, p36: table, p37: string, p38: number, p39: number, p40: number) -- Line: 157
    -- upvalues: u1 (copy)
    local v41 = {
        Mu = p38,
        Sigma = p39,
        Points = p36.Points,
        Placements = p36.Placements + 1,
        Peak = p36.Peak
    };
    local v42 = 0;
    local v43 = false;

    if u1.Placed(p35, p36) then
        v42 = u1.Delta(p35, p36, p37, p40);
        local v44 = p37 == "Dodge" and 0 or u1.Floor(p35, p36.Peak);
        v41.Points = math.max(p36.Points + v42, v44);
    elseif u1.Placed(p35, v41) then
        v41.Points = u1.PointsFor(p35, u1.Display(p35, p38 - p35.PlacementConfidence * p39));
        v42 = v41.Points;
        v43 = true;
    end;

    local v45 = u1.TierOf(p35, v41.Points);
    v41.Peak = math.max(p36.Peak, v45);

    return v41, v42, v43;
end;

function u1.Bucket(p46: table, p47: number) -- Line: 188
    local v48 = math.floor(p47 / p46.HistogramBucket) + 1;

    return math.clamp(v48, 1, p46.HistogramBuckets);
end;

function u1.Population(p49: table) -- Line: 192
    local v50 = 0;

    for _, v in p49 do
        v50 = v50 + v;
    end;

    return v50;
end;

function u1.CutoffFrom(p51: table, p52: table, p53: number) -- Line: 202
    -- upvalues: u1 (copy)
    local v54 = u1.Population(p52);

    if v54 <= 0 or p53 <= 0 then
        return nil;
    end;

    local math_ceil_ret = math.ceil(v54 * p53 / 100);
    local math_max_ret = math.max(1, math_ceil_ret);
    local v55 = 0;

    for i = #p52, 1, -1 do
        local v56 = p52[i];

        if v56 > 0 and math_max_ret <= v55 + v56 then
            local v57 = (i - 1) * p51.HistogramBucket;

            if i == #p52 then
                return v57;
            end;

            return math.floor(v57 + (1 - (math_max_ret - v55) / v56) * p51.HistogramBucket);
        end;

        v55 = v55 + v56;
        local _ = i;
    end;

    return 0;
end;

function u1.ShareAbove(p58: table, p59: table, p60: number) -- Line: 225
    -- upvalues: u1 (copy)
    local v61 = u1.Population(p59);

    if v61 <= 0 then
        return nil;
    end;

    local v62 = u1.Bucket(p58, p60);
    local v63 = p59[v62] / 2;

    for i = #p59, v62 + 1, -1 do
        v63 = v63 + p59[i];
        local _ = i;
    end;

    local math_ceil_ret = math.ceil(v63 / v61 * 100);

    return math.clamp(math_ceil_ret, 1, 100);
end;

function u1.BandFor(p64: table, p65: number, p66: table) -- Line: 239
    for _, v in p64 do
        local v67 = p66[v.Band];

        if v67 ~= nil and v67 <= p65 then
            return v.Band;
        end;
    end;

    return nil;
end;

function u1.ParseRecent(p68: string) -- Line: 252
    local v69 = {};

    for i, v in string.gmatch(p68 or "", "(%d+)@(%d+)") do
        local v70 = {
            UserId = tonumber(i),
            Time = tonumber(v)
        };
        table.insert(v69, v70);
    end;

    return v69;
end;

function u1.SerializeRecent(p71: table) -- Line: 260
    local v72 = {};

    for _, v in p71 do
        local v73 = `{v.UserId}@{v.Time}`;
        table.insert(v72, v73);
    end;

    return table.concat(v72, ";");
end;

function u1.PruneRecent(p74: table, p75: table, p76: number) -- Line: 268
    local v77 = {};

    for _, v in p75 do
        if p76 - v.Time < p74.RepeatWindow then
            table.insert(v77, v);
        end;
    end;

    return v77;
end;

function u1.Dampened(p78: table, p79: table, p80: table, p81: number) -- Line: 279
    if #p80 == 0 then
        return false;
    end;

    local v82 = {};

    for _, v in p79 do
        if p81 - v.Time < p78.RepeatWindow then
            v82[v.UserId] = (v82[v.UserId] or 0) + 1;
        end;
    end;

    for _, v in p80 do
        if (v82[v] or 0) < p78.RepeatLimit then
            return false;
        end;
    end;

    return true;
end;

function u1.Margin(p83: table, p84: number, p85: number) -- Line: 299
    local v86 = p83.MarginBase + p83.MarginStep * math.floor(p84 / p83.MarginStepTime) + p83.MarginStep * p85;

    return math.min(v86, p83.MarginCap);
end;

return u1;
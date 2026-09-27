-- Decompiled with Potassium's decompiler.

local Dot = Vector3.new().Dot;
local Cross = Vector3.new().Cross;
local math_clamp = math.clamp;

local function SafeUnit(p1) -- Line: 12
    return p1.Magnitude == 0 and Vector3.new(0, 0, 0) or p1.Unit;
end;

local function ClosestPointOnLineSegment(p2, p3, p4) -- Line: 20
    -- upvalues: Dot (copy), math_clamp (copy)
    local v5 = p3 - p2;

    return p2 + math_clamp(Dot(p4 - p2, v5) / Dot(v5, v5), 0, 1) * v5;
end;

local function ProjectOnPlane(p6, p7, p8) -- Line: 26
    return p8 - (p8 - p6):Dot(p7) * p7;
end;

local function SameSide(p9, p10, p11, p12) -- Line: 34
    -- upvalues: Cross (copy), Dot (copy)
    return Dot(Cross(p12 - p11, p9 - p11), (Cross(p12 - p11, p10 - p11))) >= 0;
end;

local function PointInTriangle(p13, p14, p15, p16) -- Line: 44
    -- upvalues: Cross (copy), Dot (copy)
    return Dot(Cross(p16 - p15, p13 - p15), (Cross(p16 - p15, p14 - p15))) >= 0 and (Dot(Cross(p16 - p14, p13 - p14), (Cross(p16 - p14, p15 - p14))) >= 0 and Dot(Cross(p15 - p14, p13 - p14), (Cross(p15 - p14, p16 - p14))) >= 0);
end;

return function(p17, p18, p19, p20) -- Line: 52, Name: ClosestPointOnTri
    -- upvalues: Dot (copy), math_clamp (copy), Cross (copy)
    local v21 = p18 - p17;
    local v22 = p17 + math_clamp(Dot(p20 - p17, v21) / Dot(v21, v21), 0, 1) * v21;
    local v23 = p19 - p18;
    local v24 = p18 + math_clamp(Dot(p20 - p18, v23) / Dot(v23, v23), 0, 1) * v23;
    local v25 = p17 - p19;
    local v26 = p19 + math_clamp(Dot(p20 - p19, v25) / Dot(v25, v25), 0, 1) * v25;
    local v27 = Cross(p18 - p17, p19 - p17);
    local v28 = v27.Magnitude == 0 and Vector3.new(0, 0, 0) or v27.Unit;
    local v29 = p20 - (p20 - (p17 + p18 + p19) * 0.3333):Dot(v28) * v28;
    local v30;

    if Dot(Cross(p19 - p18, p20 - p18), (Cross(p19 - p18, p17 - p18))) >= 0 and Dot(Cross(p19 - p17, p20 - p17), (Cross(p19 - p17, p18 - p17))) >= 0 then
        v30 = Dot(Cross(p18 - p17, p20 - p17), (Cross(p18 - p17, p19 - p17))) >= 0;
    else
        v30 = false;
    end;

    if v30 then
        return v29, v28;
    end;

    local Magnitude = (v22 - p20).Magnitude;
    local Magnitude2 = (v24 - p20).Magnitude;
    local Magnitude3 = (v26 - p20).Magnitude;
    local math_min_ret = math.min(Magnitude, Magnitude2, Magnitude3);

    if math_min_ret == Magnitude then
        return v22, v28;
    end;

    if math_min_ret == Magnitude2 then
        return v24, v28;
    end;

    if math_min_ret == Magnitude3 then
        return v26, v28;
    end;

    return p20, v28;
end;
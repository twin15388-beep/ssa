-- Decompiled with Potassium's decompiler.

local function SafeUnit(p1) -- Line: 2
    return p1.Magnitude == 0 and Vector3.new(0, 0, 0) or p1.Unit;
end;

local function solve(p2, p3, p4, p5) -- Line: 10
    local v6 = (p5 - p2):Dot(p3);
    local math_clamp_ret = math.clamp(v6, -p4, p4);

    return p2 + p3 * math_clamp_ret, math_clamp_ret;
end;

local function ProjectOnPlane(p7, p8, p9) -- Line: 17
    return p9 - (p9 - p7):Dot(p8) * p8;
end;

local function ClosestPointFunc(p10, p11, p12) -- Line: 25
    local u13 = (p11.Y < p11.Z and p11.Y or p11.Z) * 0.5;
    local v14 = p11.X * 0.5;
    local Position = p10.Position;
    local RightVector = p10.RightVector;
    local v15 = (p12 - Position):Dot(RightVector);
    local math_clamp_ret = math.clamp(v15, -v14, v14);
    local v16 = Position + RightVector * math_clamp_ret;
    local v17 = p10.Position + -p10.RightVector * v14;
    local v18 = p10.Position + p10.RightVector * v14;
    local v19 = -p10.RightVector;
    local RightVector2 = p10.RightVector;
    local v20 = p12 - (p12 - v17):Dot(v19) * v19;
    local v21 = p12 - (p12 - v18):Dot(RightVector2) * RightVector2;

    local function GetFinalProj(p22, p23) -- Line: 39
        -- upvalues: u13 (copy)
        local v24 = p22 - p23;
        local Magnitude = (p22 - p23).Magnitude;

        return p23 + (v24.Magnitude == 0 and Vector3.new(0, 0, 0) or v24.Unit) * (Magnitude < u13 and Magnitude and Magnitude or u13);
    end;

    local v25 = v20 - v17;
    local Magnitude = (v20 - v17).Magnitude;
    local v26;

    if Magnitude < u13 then
        v26 = Magnitude or u13;
    else
        v26 = u13;
    end;

    local v27 = v17 + (v25.Magnitude == 0 and Vector3.new(0, 0, 0) or v25.Unit) * v26;
    local v28 = v21 - v18;
    local Magnitude2 = (v21 - v18).Magnitude;
    local v29;

    if Magnitude2 < u13 then
        v29 = Magnitude2 or u13;
    else
        v29 = u13;
    end;

    local v30 = v18 + (v28.Magnitude == 0 and Vector3.new(0, 0, 0) or v28.Unit) * v29;
    local v31 = p12 - v16;
    local v32 = v31.Magnitude == 0 and Vector3.new(0, 0, 0) or v31.Unit;
    local v33 = (v16 - p12).Magnitude <= u13;
    local v34 = v16 + v32 * u13;
    local Magnitude3 = (v30 - p12).Magnitude;
    local Magnitude4 = (v27 - p12).Magnitude;
    local math_min_ret = math.min(Magnitude3, Magnitude4, (v34 - p12).Magnitude);

    if math_clamp_ret == v14 or math_min_ret == Magnitude3 then
        local v35 = p12 - v30;

        return (v35.Magnitude == 0 and Vector3.new(0, 0, 0) or v35.Unit):Dot(RightVector2) < 0, v30, RightVector2;
    end;

    if math_clamp_ret ~= -v14 and math_min_ret ~= Magnitude4 then
        return v33, v34, v32;
    end;

    local v36 = p12 - v27;

    return (v36.Magnitude == 0 and Vector3.new(0, 0, 0) or v36.Unit):Dot(v19) < 0, v27, v19;
end;

return function(p37, p38, p39, p40) -- Line: 70
    -- upvalues: ClosestPointFunc (copy)
    local v41, v42, v43 = ClosestPointFunc(p37, p38, p39);

    if v41 then
        return v41, v42, v43;
    end;

    return (v42 - p39).Magnitude < p40, v42, v43;
end;
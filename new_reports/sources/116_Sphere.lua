-- Decompiled with Potassium's decompiler.

local function SafeUnit(p1) -- Line: 2
    return p1.Magnitude == 0 and Vector3.new(0, 0, 0) or p1.Unit;
end;

local function ClosestPointFunc(p2, p3, p4) -- Line: 10
    local v5 = p4 - p2;
    local v6 = v5.Magnitude == 0 and Vector3.new(0, 0, 0) or v5.Unit;

    return (p2 - p4).Magnitude <= p3, p2 + v6 * p3, v6;
end;

return function(p7, p8, p9, p10) -- Line: 18
    local Position = p7.Position;
    local v11 = math.min(p8.X, p8.Y, p8.Z) * 0.5;
    local v12 = p9 - Position;
    local v13 = v12.Magnitude == 0 and Vector3.new(0, 0, 0) or v12.Unit;
    local v14 = (Position - p9).Magnitude <= v11;
    local v15 = Position + v13 * v11;

    if v14 then
        return v14, v15, v13;
    end;

    return (v15 - p9).Magnitude < p10, v15, v13;
end;
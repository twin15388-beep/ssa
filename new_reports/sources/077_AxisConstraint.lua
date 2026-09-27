-- Decompiled with Potassium's decompiler.

local function SafeUnit(p1) -- Line: 1
    return p1.Magnitude == 0 and Vector3.new(0, 0, 0) or p1.Unit;
end;

return function(p2, p3, p4, p5) -- Line: 11
    local v6 = p5:PointToObjectSpace(p3);
    local X = v6.X;
    local Y = v6.Y;
    local Z = v6.Z;
    local XAxisLimits = p2.XAxisLimits;
    local YAxisLimits = p2.YAxisLimits;
    local ZAxisLimits = p2.ZAxisLimits;
    local v7 = p2.AxisLocked[1] and 0 or 1;
    local v8 = p2.AxisLocked[2] and 0 or 1;
    local v9 = p2.AxisLocked[3] and 0 or 1;

    if XAxisLimits.Min == (-1 / 0) and (XAxisLimits.Max == (1 / 0) and (YAxisLimits.Min == (-1 / 0) and (YAxisLimits.Max == (1 / 0) and (ZAxisLimits.Min == (-1 / 0) and ZAxisLimits.Max == (1 / 0))))) then
        if v7 == 1 and (v8 == 1 and v9 == 1) then
            return p3;
        end;

        return p5 * Vector3.new(X * v7, Y * v8, Z * v9);
    end;

    local v10 = XAxisLimits.Min + p2.Radius;
    local v11;

    if v10 <= XAxisLimits.Max - p2.Radius then
        v11 = XAxisLimits.Max - p2.Radius or v10;
    else
        v11 = v10;
    end;

    local v12 = YAxisLimits.Min + p2.Radius;
    local v13;

    if v12 <= YAxisLimits.Max - p2.Radius then
        v13 = YAxisLimits.Max - p2.Radius or v12;
    else
        v13 = v12;
    end;

    local v14 = ZAxisLimits.Min + p2.Radius;
    local v15;

    if v14 <= ZAxisLimits.Max - p2.Radius then
        v15 = ZAxisLimits.Max - p2.Radius or v14;
    else
        v15 = v14;
    end;

    if X < v10 and v10 then
        X = v10;
    elseif v11 < X then
        X = v11 or X;
    end;

    if Y < v12 and v12 then
        Y = v12;
    elseif v13 < Y then
        Y = v13 or Y;
    end;

    if Z < v14 and v14 then
        Z = v14;
    elseif v15 < Z then
        Z = v15 or Z;
    end;

    local v16 = X * v7;
    local v17 = Y * v8;
    local v18 = Z * v9;
    local v19 = p5 * Vector3.new(v16, v17, v18);
    local RightVector = p5.RightVector;
    local UpVector = p5.UpVector;
    local LookVector = p5.LookVector;
    local v20 = v19 - p4;
    local v21 = v20.Magnitude == 0 and Vector3.new(0, 0, 0) or v20.Unit;

    if v16 ~= v6.X then
        if RightVector:Dot(v21) < 0 then
            RightVector = -RightVector or RightVector;
        end;

        p2:ClipVelocity(v19, RightVector);
    end;

    if v17 ~= v6.Y then
        if UpVector:Dot(v21) < 0 then
            UpVector = -UpVector or UpVector;
        end;

        p2:ClipVelocity(v19, UpVector);
    end;

    if v18 ~= v6.Z then
        if LookVector:Dot(v21) < 0 then
            LookVector = -LookVector or LookVector;
        end;

        p2:ClipVelocity(v19, LookVector);
    end;

    return v19;
end;
-- Decompiled with Potassium's decompiler.

local function SafeUnit(p1) -- Line: 2
    return p1.Magnitude == 0 and Vector3.new(0, 0, 0) or p1.Unit;
end;

local function solve(p2, p3, p4, p5) -- Line: 10
    local v6 = (p5 - p2):Dot(p3);

    return p2 + p3 * math.clamp(v6, -p4, p4);
end;

local function ClosestPointFunc(p7, p8, p9, p10) -- Line: 17
    local Position = p7.Position;
    local UpVector = p7.UpVector;
    local v11 = p8 * 0.5;
    local v12 = (p10 - Position):Dot(UpVector);
    local v13 = Position + UpVector * math.clamp(v12, -v11, v11);
    local v14 = p10 - v13;
    local v15 = v14.Magnitude == 0 and Vector3.new(0, 0, 0) or v14.Unit;

    return (v13 - p10).Magnitude <= p9, v13 + v15 * p9, v15;
end;

return function(p16, p17, p18, p19) -- Line: 27
    local v20 = (p17.Y < p17.Z and p17.Y or p17.Z) * 0.5;
    local X = p17.X;
    local v21 = p16 * CFrame.Angles(1.5707963267948966, -1.5707963267948966, 0);
    local Position = v21.Position;
    local UpVector = v21.UpVector;
    local v22 = X * 0.5;
    local v23 = (p18 - Position):Dot(UpVector);
    local v24 = Position + UpVector * math.clamp(v23, -v22, v22);
    local v25 = p18 - v24;
    local v26 = v25.Magnitude == 0 and Vector3.new(0, 0, 0) or v25.Unit;
    local v27 = (v24 - p18).Magnitude <= v20;
    local v28 = v24 + v26 * v20;

    if v27 then
        return v27, v28, v26;
    end;

    return (v28 - p18).Magnitude < p19, v28, v26;
end;
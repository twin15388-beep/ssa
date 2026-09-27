-- Decompiled with Potassium's decompiler.

local function SafeUnit(p1) -- Line: 1
    return p1.Magnitude == 0 and Vector3.new(0, 0, 0) or p1.Unit;
end;

return function(p2, p3, p4) -- Line: 9
    local v5 = p4.Bones[p2.ParentIndex];

    if not v5 then
        return p3;
    end;

    local RotationLimit = v5.RotationLimit;

    if RotationLimit >= 180 then
        return p3;
    end;

    local v6 = p4.Bones[v5.ParentIndex];

    if not v6 then
        return p3;
    end;

    local Position = v5.Position;
    local v7 = v5.Position - v6.Position;
    local v8 = v7.Magnitude == 0 and Vector3.new(0, 0, 0) or v7.Unit;
    local Magnitude = (p3 - Position).Magnitude;
    local v9 = p3 - Position;
    local v10 = v9.Magnitude == 0 and Vector3.new(0, 0, 0) or v9.Unit;

    if RotationLimit <= 0 then
        return Position + v8 * Magnitude;
    end;

    local math_rad_ret = math.rad(RotationLimit);
    local v11 = v8:Dot(v10);

    if math_rad_ret <= math.acos(v11) then
        local v12 = v8:Cross(v10);
        v10 = CFrame.fromAxisAngle(v12.Magnitude == 0 and Vector3.new(0, 0, 0) or v12.Unit, math_rad_ret) * v8;
    end;

    if v10 == v10 then
        v8 = v10;
    end;

    return Position + v8 * Magnitude;
end;
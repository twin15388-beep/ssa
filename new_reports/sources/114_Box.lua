-- Decompiled with Potassium's decompiler.

local function SafeUnit(p1) -- Line: 1
    return p1.Magnitude == 0 and Vector3.new(0, 0, 0) or p1.Unit;
end;

local function ClosestPointFunc(p2, p3, p4) -- Line: 9
    local v5 = p2:pointToObjectSpace(p4);
    local x = p3.x;
    local y = p3.y;
    local z = p3.z;
    local x2 = v5.x;
    local y2 = v5.y;
    local z2 = v5.z;
    local math_clamp_ret = math.clamp(x2, -x * 0.5, x * 0.5);
    local math_clamp_ret2 = math.clamp(y2, -y * 0.5, y * 0.5);
    local math_clamp_ret3 = math.clamp(z2, -z * 0.5, z * 0.5);

    if math_clamp_ret ~= x2 or (math_clamp_ret2 ~= y2 or math_clamp_ret3 ~= z2) then
        local v6 = p2 * Vector3.new(math_clamp_ret, math_clamp_ret2, math_clamp_ret3);
        local v7 = p4 - v6;

        return false, v6, v7.Magnitude == 0 and Vector3.new(0, 0, 0) or v7.Unit;
    end;

    local v8 = x2 - x * 0.5;
    local v9 = y2 - y * 0.5;
    local v10 = z2 - z * 0.5;
    local v11 = -x2 - x * 0.5;
    local v12 = -y2 - y * 0.5;
    local v13 = -z2 - z * 0.5;
    local math_max_ret = math.max(v8, v9, v10, v11, v12, v13);

    if math_max_ret == v8 then
        return true, p2 * Vector3.new(x * 0.5, y2, z2), p2.XVector;
    end;

    if math_max_ret == v9 then
        return true, p2 * Vector3.new(x2, y * 0.5, z2), p2.YVector;
    end;

    if math_max_ret == v10 then
        return true, p2 * Vector3.new(x2, y2, z * 0.5), p2.ZVector;
    end;

    if math_max_ret == v11 then
        return true, p2 * Vector3.new(-x * 0.5, y2, z2), -p2.XVector;
    end;

    if math_max_ret == v12 then
        return true, p2 * Vector3.new(x2, -y * 0.5, z2), -p2.YVector;
    end;

    if math_max_ret == v13 then
        return true, p2 * Vector3.new(x2, y2, -z * 0.5), -p2.ZVector;
    end;

    warn("CLOSEST POINT ON BOX FAIL");

    return false, p2.Position, Vector3.new(0, 0, 0);
end;

return function(p14, p15, p16, p17) -- Line: 60
    -- upvalues: ClosestPointFunc (copy)
    local v18, v19, v20 = ClosestPointFunc(p14, p15, p16);

    if v18 then
        return v18, v19, v20;
    end;

    return (v19 - p16).Magnitude < p17, v19, v20;
end;
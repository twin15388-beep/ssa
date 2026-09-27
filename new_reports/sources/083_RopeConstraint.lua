-- Decompiled with Potassium's decompiler.

local function SafeUnit(p1) -- Line: 1
    return p1.Magnitude == 0 and Vector3.new(0, 0, 0) or p1.Unit;
end;

return function(p2, p3, p4) -- Line: 9
    local v5 = p4.Bones[p2.ParentIndex];

    if not v5 then
        return p3;
    end;

    local FreeLength = p2.FreeLength;
    local v6 = p3 - v5.Position;

    if v6.Magnitude < FreeLength then
        FreeLength = v6.Magnitude or FreeLength;
    end;

    return v5.Position + (v6.Magnitude == 0 and Vector3.new(0, 0, 0) or v6.Unit) * FreeLength;
end;
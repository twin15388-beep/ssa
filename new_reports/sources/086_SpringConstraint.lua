-- Decompiled with Potassium's decompiler.

return function(p1, p2, p3, p4, p5) -- Line: 2
    local Settings = p4.Settings;
    local Stiffness = Settings.Stiffness;
    local Elasticity = Settings.Elasticity;
    local v6 = p4.Bones[p1.ParentIndex];

    if v6 then
        local FreeLength = p1.FreeLength;

        if Stiffness > 0 or Elasticity > 0 then
            local v7 = p3 or (CFrame.new(v6.Position) * v6.TransformOffset.Rotation * CFrame.new(p1.LocalTransformOffset.Position)).Position;
            p2 = p2 + (v7 - p2) * math.min(Elasticity * p5, 1);

            if Stiffness > 0 then
                local v8 = v7 - p2;
                local Magnitude = v8.Magnitude;
                local v9 = FreeLength * (1 - Stiffness) * 2;

                if v9 < Magnitude then
                    p2 = p2 + v8 * ((Magnitude - v9) / Magnitude);
                end;
            end;
        end;

        local v10 = v6.Position - p2;
        local Magnitude = v10.Magnitude;

        if Magnitude > 0 then
            p2 = p2 + v10 * ((Magnitude - FreeLength) / Magnitude);
        end;
    end;

    return p2;
end;
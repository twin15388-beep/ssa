-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;

function u1.Init(p2, p3, p4, p5, p6) -- Line: 6
    -- upvalues: u1 (copy)
    local v7 = setmetatable({}, u1);
    v7.Ceive = p2;
    v7.Propertys = p3;
    v7.Request = p4;
    v7.Release = p5;
    v7.Retain = p6;

    return v7;
end;

function u1.Draw(p8: table, p9, p10: number, p11: number, p12: number) -- Line: 18
    local Ceive = p8.Ceive;

    if not Ceive.Enabled then
        return;
    end;

    local v13 = p9 * CFrame.Angles(-1.5707963267948966, 0, 0);
    local v14 = v13.Position + v13.UpVector * (p11 * 0.5);
    local v15 = v13.Position + -v13.UpVector * (p11 * 0.5);
    local CFrame_lookAt_ret = CFrame.lookAt(v14, v14 + v13.UpVector);
    local CFrame_lookAt_ret2 = CFrame.lookAt(v15, v15 - v13.UpVector);
    local v16 = nil;
    local v17 = nil;

    for i = 0, 360, math.floor(360 / p12) do
        local math_rad_ret = math.rad(i);
        local v18 = math.sin(math_rad_ret) * p10;
        local math_rad_ret2 = math.rad(i);
        local v19 = math.cos(math_rad_ret2) * p10;
        local v20 = CFrame_lookAt_ret2.Position + (v13.LookVector * v19 + v13.RightVector * v18);
        local v21;

        if v16 then
            Ceive.Ray:Draw(v20, CFrame_lookAt_ret.Position);
            Ceive.Ray:Draw(v16, v20);
            v16 = v20;
            v21 = i;
        else
            Ceive.Ray:Draw(v20, CFrame_lookAt_ret.Position);
            v17 = v20;
            v16 = v17;
            v21 = i;
            local v22 = v17;
            v17 = v16;
            v22 = v16;
            v16 = v17;
        end;
    end;

    Ceive.Ray:Draw(v16, v17);
end;

function u1.Create(p23: table, p24, p25: number, p26: number, p27: number) -- Line: 63
    local v28 = {
        Enabled = true,
        Destroy = false,
        Transform = p24,
        Radius = p25,
        Length = p26,
        Subdivisions = p27,
        AlwaysOnTop = p23.Propertys.AlwaysOnTop,
        Transparency = p23.Propertys.Transparency,
        Color3 = p23.Propertys.Color3
    };
    p23.Retain(p23, v28);

    return v28;
end;

function u1.Update(p29, p30) -- Line: 81
    local Ceive = p29.Ceive;
    Ceive.PushProperty("AlwaysOnTop", p30.AlwaysOnTop);
    Ceive.PushProperty("Transparency", p30.Transparency);
    Ceive.PushProperty("Color3", p30.Color3);
    p29:Draw(p30.Transform, p30.Radius, p30.Length, p30.Subdivisions);
end;

return u1;
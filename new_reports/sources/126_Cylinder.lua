-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;

function u1.Init(p2, p3, p4, p5, p6) -- Line: 4
    -- upvalues: u1 (copy)
    local v7 = setmetatable({}, u1);
    v7.Ceive = p2;
    v7.Propertys = p3;
    v7.Request = p4;
    v7.Release = p5;
    v7.Retain = p6;

    return v7;
end;

function u1.Draw(p8: table, p9, p10: number, p11: number, p12: number) -- Line: 16
    local Ceive = p8.Ceive;

    if not Ceive.Enabled then
        return;
    end;

    local v13 = p9.Position + p9.UpVector * (p11 * 0.5);
    local v14 = p9.Position - p9.UpVector * (p11 * 0.5);
    local CFrame_lookAt_ret = CFrame.lookAt(v13, v13 + p9.UpVector);
    local CFrame_lookAt_ret2 = CFrame.lookAt(v14, v14 - p9.UpVector);
    local v15 = nil;
    local v16 = nil;
    local v17 = nil;
    local v18 = nil;

    for i = 0, 360, math.floor(360 / p12) do
        local math_rad_ret = math.rad(i);
        local v19 = math.sin(math_rad_ret) * p10;
        local math_rad_ret2 = math.rad(i);
        local v20 = math.cos(math_rad_ret2) * p10;
        local v21 = p9.LookVector * v20 + p9.RightVector * v19;
        local v22 = CFrame_lookAt_ret.Position + v21;
        local v23 = CFrame_lookAt_ret2.Position + v21;
        Ceive.Ray:Draw(v22, v23);
        local v24;

        if v15 then
            Ceive.Ray:Draw(v15, v22);
            Ceive.Ray:Draw(v16, v23);
            v24 = i;
            v16 = v23;
            v15 = v22;
        else
            v18 = v23;
            v17 = v22;
            v24 = i;
            v16 = v18;
            v15 = v17;
            local v25 = v18;
            v18 = v16;
            v25 = v17;
            v17 = v15;
            v25 = v16;
            v16 = v18;
            v25 = v15;
        end;
    end;

    Ceive.Ray:Draw(v15, v17);
    Ceive.Ray:Draw(v16, v18);
end;

function u1.Create(p26: table, p27, p28: number, p29: number, p30: number) -- Line: 71
    local v31 = {
        Enabled = true,
        Destroy = false,
        Transform = p27,
        Radius = p28,
        Length = p29,
        Subdivisions = p30,
        AlwaysOnTop = p26.Propertys.AlwaysOnTop,
        Transparency = p26.Propertys.Transparency,
        Color3 = p26.Propertys.Color3
    };
    p26.Retain(p26, v31);

    return v31;
end;

function u1.Update(p32, p33) -- Line: 89
    local Ceive = p32.Ceive;
    Ceive.PushProperty("AlwaysOnTop", p33.AlwaysOnTop);
    Ceive.PushProperty("Transparency", p33.Transparency);
    Ceive.PushProperty("Color3", p33.Color3);
    p32:Draw(p33.Transform, p33.Radius, p33.Length, p33.Subdivisions);
end;

return u1;
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

function u1.Draw(p8: table, p9, p10: number, p11: number, p12: number, p13: boolean?) -- Line: 16
    local Ceive = p8.Ceive;

    if Ceive.Enabled then
        local v14 = nil;
        local v15 = 0;
        local v16 = nil;

        for i = 0, p12, math.floor(p12 / p11) do
            local math_rad_ret = math.rad(i);
            local v17 = math.sin(math_rad_ret) * p10;
            local math_rad_ret2 = math.rad(i);
            local v18 = math.cos(math_rad_ret2) * p10;
            local v19 = p9.Position + (p9.UpVector * v18 + p9.RightVector * v17);
            local v20;

            if v14 == nil then
                v16 = v19;
                v15 = i;
                v14 = v16;
                v20 = v15;
                local v21 = v16;
                v16 = v14;
                v21 = v15;
                v15 = v20;
                v21 = v14;
                v14 = v16;
                v21 = v20;
            else
                Ceive.Ray:Draw(v14, v19);
                v15 = i;
                v14 = v19;
                v20 = v15;
                local v22 = v15;
                v15 = v20;
                v22 = v20;
            end;
        end;

        if v15 ~= p12 then
            local math_rad_ret = math.rad(p12);
            local v23 = math.sin(math_rad_ret) * p10;
            local math_rad_ret2 = math.rad(p12);
            local v24 = math.cos(math_rad_ret2) * p10;
            Ceive.Ray:Draw(v14, p9.Position + (p9.UpVector * v24 + p9.RightVector * v23));
        end;

        if p13 ~= false then
            Ceive.Ray:Draw(v14, v16);
        end;

        return v14;
    end;
end;

function u1.Create(p25: table, p26, p27: number, p28: number, p29: number, p30: boolean?) -- Line: 64
    local v31 = {
        Enabled = true,
        Destroy = false,
        Transform = p26,
        Radius = p27,
        Subdivisions = p28,
        Angle = p29,
        ConnectToStart = p30,
        AlwaysOnTop = p25.Propertys.AlwaysOnTop,
        Transparency = p25.Propertys.Transparency,
        Color3 = p25.Propertys.Color3
    };
    p25.Retain(p25, v31);

    return v31;
end;

function u1.Update(p32, p33) -- Line: 83
    local Ceive = p32.Ceive;
    Ceive.PushProperty("AlwaysOnTop", p33.AlwaysOnTop);
    Ceive.PushProperty("Transparency", p33.Transparency);
    Ceive.PushProperty("Color3", p33.Color3);
    p32:Draw(p33.Transform, p33.Radius, p33.Subdivisions, p33.Angle, p33.ConnectToStart);
end;

return u1;
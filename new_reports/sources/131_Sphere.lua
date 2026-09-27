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

    Ceive.Circle:Draw(p9, p10, p11, p12);
    Ceive.Circle:Draw(p9 * CFrame.Angles(0, 1.5707963267948966, 0), p10, p11, p12);
    Ceive.Circle:Draw(p9 * CFrame.Angles(1.5707963267948966, 0, 0), p10, p11, p12);
end;

function u1.Create(p13: table, p14, p15: number, p16: number, p17: number) -- Line: 30
    local v18 = {
        Enabled = true,
        Destroy = false,
        Transform = p14,
        Radius = p15,
        Subdivisions = p16,
        Angle = p17,
        AlwaysOnTop = p13.Propertys.AlwaysOnTop,
        Transparency = p13.Propertys.Transparency,
        Color3 = p13.Propertys.Color3
    };
    p13.Retain(p13, v18);

    return v18;
end;

function u1.Update(p19, p20) -- Line: 48
    local Ceive = p19.Ceive;
    Ceive.PushProperty("AlwaysOnTop", p20.AlwaysOnTop);
    Ceive.PushProperty("Transparency", p20.Transparency);
    Ceive.PushProperty("Color3", p20.Color3);
    p19:Draw(p20.Transform, p20.Radius, p20.Subdivisions, p20.Angle);
end;

return u1;
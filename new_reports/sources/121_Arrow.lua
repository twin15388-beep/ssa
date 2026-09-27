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

function u1.Draw(p8: table, p9: vector, p10: vector, p11: number, p12: number, p13: number) -- Line: 16
    local Ceive = p8.Ceive;

    if not Ceive.Enabled then
        return;
    end;

    Ceive.Ray:Draw(p9, p10);
    local CFrame_lookAt_ret = CFrame.lookAt(p10 + (p9 - p10).Unit * (p12 * 0.5), p10);
    Ceive.Cone:Draw(CFrame_lookAt_ret, p11, p12, p13);
end;

function u1.Create(p14: table, p15: vector, p16: vector, p17: number, p18: number, p19: number) -- Line: 29
    local v20 = {
        Enabled = true,
        Destroy = false,
        Origin = p15,
        End = p16,
        Radius = p17,
        Length = p18,
        Subdivisions = p19,
        AlwaysOnTop = p14.Propertys.AlwaysOnTop,
        Transparency = p14.Propertys.Transparency,
        Color3 = p14.Propertys.Color3
    };
    p14.Retain(p14, v20);

    return v20;
end;

function u1.Update(p21, p22) -- Line: 48
    local Ceive = p21.Ceive;
    Ceive.PushProperty("AlwaysOnTop", p22.AlwaysOnTop);
    Ceive.PushProperty("Transparency", p22.Transparency);
    Ceive.PushProperty("Color3", p22.Color3);
    p21:Draw(p22.Origin, p22.End, p22.Radius, p22.Length, p22.Subdivisions);
end;

return u1;
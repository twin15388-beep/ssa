-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;

function u1.Init(p2, p3, p4, p5, p6, p7) -- Line: 4
    -- upvalues: u1 (copy)
    local v8 = setmetatable({}, u1);
    v8.Ceive = p2;
    v8.Propertys = p3;
    v8.Request = p4;
    v8.Release = p5;
    v8.Retain = p6;
    v8.Register = p7;

    return v8;
end;

function u1.Draw(p9: table, p10: vector, p11: vector, p12: number, p13: number, p14: number, p15: boolean?) -- Line: 17
    local Ceive = p9.Ceive;

    if not Ceive.Enabled then
        return;
    end;

    local CFrame_lookAt_ret = CFrame.lookAt(p11 - (p11 - p10).Unit * (p14 * 0.5), p11);

    if p15 == true then
        local Position = CFrame_lookAt_ret.Position;
        local Magnitude = (Position - p10).Magnitude;
        local CFrame_lookAt_ret2 = CFrame.lookAt((p10 + Position) * 0.5, p11);
        Ceive.VolumeCylinder:Draw(CFrame_lookAt_ret2, p12, Magnitude);
    else
        Ceive.Ray:Draw(p10, p11);
    end;

    Ceive.VolumeCone:Draw(CFrame_lookAt_ret, p13, p14);
    p9.Ceive.ScheduleCleaning();
end;

function u1.Create(p16: table, p17: vector, p18: vector, p19: number, p20: number, p21: number, p22: boolean?) -- Line: 40
    local v23 = {
        Enabled = true,
        Destroy = false,
        Origin = p17,
        End = p18,
        CylinderRadius = p19,
        ConeRadius = p20,
        Length = p21,
        UseCylinder = p22,
        AlwaysOnTop = p16.Propertys.AlwaysOnTop,
        Transparency = p16.Propertys.Transparency,
        Color3 = p16.Propertys.Color3
    };
    p16.Retain(p16, v23);

    return v23;
end;

function u1.Update(p24, p25) -- Line: 60
    local Ceive = p24.Ceive;
    Ceive.PushProperty("AlwaysOnTop", p25.AlwaysOnTop);
    Ceive.PushProperty("Transparency", p25.Transparency);
    Ceive.PushProperty("Color3", p25.Color3);
    p24:Draw(p25.Origin, p25.End, p25.Radius, p25.Length, p25.UseCylinder);
end;

return u1;
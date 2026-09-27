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

function u1.Draw(p8: table, p9: vector, p10: vector) -- Line: 16
    local Ceive = p8.Ceive;

    if not Ceive.Enabled then
        return;
    end;

    if p8.Propertys.AlwaysOnTop then
        Ceive.AOTWireframeHandle:AddLine(p9, p10);
    else
        Ceive.WireframeHandle:AddLine(p9, p10);
    end;

    local Ceive2 = p8.Ceive;
    Ceive2.ActiveRays = Ceive2.ActiveRays + 1;
    p8.Ceive.ScheduleCleaning();
end;

function u1.Create(p11: table, p12: vector, p13: vector) -- Line: 34
    local v14 = {
        Enabled = true,
        Destroy = false,
        Origin = p12,
        End = p13,
        AlwaysOnTop = p11.Propertys.AlwaysOnTop,
        Transparency = p11.Propertys.Transparency,
        Color3 = p11.Propertys.Color3
    };
    p11.Retain(p11, v14);

    return v14;
end;

function u1.Update(p15, p16) -- Line: 50
    local Ceive = p15.Ceive;
    Ceive.PushProperty("AlwaysOnTop", p16.AlwaysOnTop);
    Ceive.PushProperty("Transparency", p16.Transparency);
    Ceive.PushProperty("Color3", p16.Color3);
    p15:Draw(p16.Origin, p16.End);
end;

return u1;
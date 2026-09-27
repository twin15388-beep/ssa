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

function u1.Draw(p8: table, u9: vector, p10: vector, p11: vector) -- Line: 16
    local Ceive = p8.Ceive;

    if not Ceive.Enabled then
        return;
    end;

    local CFrame_lookAt_ret = CFrame.lookAt(u9, u9 + p10);
    local v12 = p11 * Vector3.new(1, 1, 0) * 0.5;
    (function(p13, p14, p15) -- Line: 35, Name: CalculateZFace
        -- upvalues: u9 (copy), Ceive (copy)
        local v16 = u9 + (p13 - p14 + p15);
        local v17 = u9 + (p13 + p14 + p15);
        local v18 = u9 + (-p13 - p14 + p15);
        local v19 = u9 + (-p13 + p14 + p15);
        Ceive.Ray:Draw(v16, v17);
        Ceive.Ray:Draw(v16, v18);
        Ceive.Ray:Draw(v17, v19);
        Ceive.Ray:Draw(v17, v18);
        Ceive.Ray:Draw(v18, v19);
    end)(CFrame_lookAt_ret.UpVector * v12.Y, CFrame_lookAt_ret.RightVector * v12.X, CFrame_lookAt_ret.LookVector * v12.Z);
end;

function u1.Create(p20: table, p21: vector, p22: vector, p23: vector) -- Line: 53
    local v24 = {
        Enabled = true,
        Destroy = false,
        Position = p21,
        Normal = p22,
        Size = p23,
        AlwaysOnTop = p20.Propertys.AlwaysOnTop,
        Transparency = p20.Propertys.Transparency,
        Color3 = p20.Propertys.Color3
    };
    p20.Retain(p20, v24);

    return v24;
end;

function u1.Update(p25, p26) -- Line: 70
    local Ceive = p25.Ceive;
    Ceive.PushProperty("AlwaysOnTop", p26.AlwaysOnTop);
    Ceive.PushProperty("Transparency", p26.Transparency);
    Ceive.PushProperty("Color3", p26.Color3);
    p25:Draw(p26.Position, p26.Normal, p26.Size);
end;

return u1;
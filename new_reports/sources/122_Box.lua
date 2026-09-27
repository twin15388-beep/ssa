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

function u1.Draw(p8: table, p9, p10: vector, u11: boolean) -- Line: 16
    local Ceive = p8.Ceive;

    if not Ceive.Enabled then
        return;
    end;

    local Position = p9.Position;
    local v12 = p10 * 0.5;
    local v13 = p9.UpVector * v12.Y;
    local v14 = p9.RightVector * v12.X;
    local v15 = p9.LookVector * v12.Z;

    local function CalculateYFace(p16, p17, p18) -- Line: 32
        -- upvalues: Position (copy), Ceive (copy), u11 (copy)
        local v19 = Position + (p16 - p17 + p18);
        local v20 = Position + (p16 + p17 + p18);
        local v21 = Position + (p16 - p17 - p18);
        local v22 = Position + (p16 + p17 - p18);
        Ceive.Ray:Draw(v19, v20);
        Ceive.Ray:Draw(v19, v21);
        Ceive.Ray:Draw(v20, v22);

        if u11 ~= false then
            Ceive.Ray:Draw(v20, v21);
        end;

        Ceive.Ray:Draw(v21, v22);
    end;

    local function CalculateZFace(p23, p24, p25) -- Line: 49
        -- upvalues: Position (copy), Ceive (copy), u11 (copy)
        local v26 = Position + (p23 - p24 + p25);
        local v27 = Position + (p23 + p24 + p25);
        local v28 = Position + (-p23 - p24 + p25);
        local v29 = Position + (-p23 + p24 + p25);
        Ceive.Ray:Draw(v26, v27);
        Ceive.Ray:Draw(v26, v28);
        Ceive.Ray:Draw(v27, v29);

        if u11 ~= false then
            Ceive.Ray:Draw(v27, v28);
        end;

        Ceive.Ray:Draw(v28, v29);
    end;

    local function CalculateXFace(p30, p31, p32) -- Line: 66
        -- upvalues: Position (copy), Ceive (copy), u11 (copy)
        local v33 = Position + (p30 - p31 - p32);
        local v34 = Position + (p30 - p31 + p32);
        local v35 = Position + (-p30 - p31 - p32);
        local v36 = Position + (-p30 - p31 + p32);
        Ceive.Ray:Draw(v33, v34);
        Ceive.Ray:Draw(v33, v35);
        Ceive.Ray:Draw(v34, v36);

        if u11 ~= false then
            Ceive.Ray:Draw(v34, v35);
        end;

        Ceive.Ray:Draw(v35, v36);
    end;

    CalculateXFace(v13, v14, v15);
    CalculateXFace(v13, -v14, v15);
    CalculateYFace(v13, v14, v15);
    CalculateYFace(-v13, v14, v15);
    CalculateZFace(v13, v14, v15);
    CalculateZFace(v13, v14, -v15);
end;

function u1.Create(p37: table, p38, p39: vector, p40: boolean) -- Line: 93
    local v41 = {
        Enabled = true,
        Destroy = false,
        Transform = p38,
        Size = p39,
        DrawTriangles = p40,
        AlwaysOnTop = p37.Propertys.AlwaysOnTop,
        Transparency = p37.Propertys.Transparency,
        Color3 = p37.Propertys.Color3
    };
    p37.Retain(p37, v41);

    return v41;
end;

function u1.Update(p42, p43) -- Line: 110
    local Ceive = p42.Ceive;
    Ceive.PushProperty("AlwaysOnTop", p43.AlwaysOnTop);
    Ceive.PushProperty("Transparency", p43.Transparency);
    Ceive.PushProperty("Color3", p43.Color3);
    p42:Draw(p43.Transform, p43.Size, p43.DrawTriangles);
end;

return u1;
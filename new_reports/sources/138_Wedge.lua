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
    local u16 = nil;
    local u17 = nil;
    local u18 = nil;
    local u19 = nil;

    local function CalculateZFace(p20, p21, p22) -- Line: 58
        -- upvalues: Position (copy), u18 (ref), u19 (ref), Ceive (copy), u11 (copy)
        local v23 = Position + (p20 - p21 + p22);
        local v24 = Position + (p20 + p21 + p22);
        local v25 = Position + (-p20 - p21 + p22);
        local v26 = Position + (-p20 + p21 + p22);
        u18 = v23;
        u19 = v24;
        Ceive.Ray:Draw(v23, v24);
        Ceive.Ray:Draw(v23, v25);
        Ceive.Ray:Draw(v24, v26);

        if u11 ~= false then
            Ceive.Ray:Draw(v24, v25);
        end;

        Ceive.Ray:Draw(v25, v26);
    end;

    (function(p27, p28, p29) -- Line: 38, Name: CalculateYFace
        -- upvalues: Position (copy), u16 (ref), u17 (ref), Ceive (copy), u11 (copy)
        local v30 = Position + (p27 - p28 + p29);
        local v31 = Position + (p27 + p28 + p29);
        local v32 = Position + (p27 - p28 - p29);
        local v33 = Position + (p27 + p28 - p29);
        u16 = v30;
        u17 = v31;
        Ceive.Ray:Draw(v30, v31);
        Ceive.Ray:Draw(v30, v32);
        Ceive.Ray:Draw(v31, v33);

        if u11 ~= false then
            Ceive.Ray:Draw(v31, v32);
        end;

        Ceive.Ray:Draw(v32, v33);
    end)(-v13, v14, v15);
    CalculateZFace(v13, v14, -v15);
    Ceive.Ray:Draw(u16, u18);
    Ceive.Ray:Draw(u17, u19);

    if u11 ~= false then
        Ceive.Ray:Draw(u17, u18);
    end;
end;

function u1.Create(p34: table, p35, p36: vector, p37: boolean) -- Line: 89
    local v38 = {
        Enabled = true,
        Destroy = false,
        Transform = p35,
        Size = p36,
        DrawTriangles = p37,
        AlwaysOnTop = p34.Propertys.AlwaysOnTop,
        Transparency = p34.Propertys.Transparency,
        Color3 = p34.Propertys.Color3
    };
    p34.Retain(p34, v38);

    return v38;
end;

function u1.Update(p39, p40) -- Line: 106
    local Ceive = p39.Ceive;
    Ceive.PushProperty("AlwaysOnTop", p40.AlwaysOnTop);
    Ceive.PushProperty("Transparency", p40.Transparency);
    Ceive.PushProperty("Color3", p40.Color3);
    p39:Draw(p40.Transform, p40.Size, p40.DrawTriangles);
end;

return u1;
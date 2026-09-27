-- Decompiled with Potassium's decompiler.

local function Map(p1, p2, p3, p4, p5) -- Line: 1
    return (p1 - p2) / (p3 - p2) * (p5 - p4) + p4;
end;

local u6 = {};
u6.__index = u6;

function u6.Init(p7, p8, p9, p10, p11) -- Line: 8
    -- upvalues: u6 (copy)
    local v12 = setmetatable({}, u6);
    v12.Ceive = p7;
    v12.Propertys = p8;
    v12.Request = p9;
    v12.Release = p10;
    v12.Retain = p11;

    return v12;
end;

function u6.Draw(p13: table, p14, p15: vector, p16: any, p17: any) -- Line: 20
    local Ceive = p13.Ceive;

    if not Ceive.Enabled then
        return;
    end;

    local v18 = (-1 / 0);
    local v19 = (-1 / 0);
    local v20 = (-1 / 0);
    local v21 = (1 / 0);
    local v22 = (1 / 0);
    local v23 = (1 / 0);

    for _, v in p16 do
        v18 = math.max(v18, v.x);
        v19 = math.max(v19, v.y);
        v20 = math.max(v20, v.z);
        v21 = math.min(v21, v.x);
        v22 = math.min(v22, v.y);
        v23 = math.min(v23, v.z);
    end;

    for i, v in p16 do
        p16[i] = p14 * CFrame.new(Vector3.new((v.x - v21) / (v18 - v21) * 1 + -0.5, (v.y - v22) / (v19 - v22) * 1 + -0.5, (v.z - v23) / (v20 - v23) * 1 + -0.5) * p15);
    end;

    for _, v in p17 do
        if #v == 3 then
            local v24 = p16[v[1].v];
            local v25 = p16[v[2].v];
            local v26 = p16[v[3].v];
            Ceive.Ray:Draw(v24.Position, v25.Position);
            Ceive.Ray:Draw(v25.Position, v26.Position);
            Ceive.Ray:Draw(v26.Position, v24.Position);
        else
            local v27 = p16[v[1].v];
            local v28 = p16[v[2].v];
            local v29 = p16[v[3].v];
            local v30 = p16[v[4].v];
            Ceive.Ray:Draw(v27.Position, v28.Position);
            Ceive.Ray:Draw(v27.Position, v30.Position);
            Ceive.Ray:Draw(v30.Position, v28.Position);
            Ceive.Ray:Draw(v29.Position, v30.Position);
            Ceive.Ray:Draw(v28.Position, v29.Position);
        end;
    end;
end;

function u6.Create(p31: table, p32, p33: vector, p34: any, p35: any) -- Line: 79
    local v36 = {
        Enabled = true,
        Destroy = false,
        Transform = p32,
        Size = p33,
        Vertices = p34,
        Faces = p35,
        AlwaysOnTop = p31.Propertys.AlwaysOnTop,
        Transparency = p31.Propertys.Transparency,
        Color3 = p31.Propertys.Color3
    };
    p31.Retain(p31, v36);

    return v36;
end;

function u6.Update(p37, p38) -- Line: 97
    local Ceive = p37.Ceive;
    Ceive.PushProperty("AlwaysOnTop", p38.AlwaysOnTop);
    Ceive.PushProperty("Transparency", p38.Transparency);
    Ceive.PushProperty("Color3", p38.Color3);
    p37:Draw(p38.Transform, p38.Size, p38.Vertices, p38.Faces);
end;

return u6;
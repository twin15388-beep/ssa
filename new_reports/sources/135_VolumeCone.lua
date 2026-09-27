-- Decompiled with Potassium's decompiler.

local workspace_Terrain = workspace.Terrain;
local u1 = {};
u1.__index = u1;

function u1.Init(p2, p3, p4, p5, p6, p7) -- Line: 6
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

function u1.Draw(p9: table, p10, p11: number, p12: number) -- Line: 19
    -- upvalues: workspace_Terrain (copy)
    local Ceive = p9.Ceive;

    if not Ceive.Enabled then
        return;
    end;

    local v13 = p9.Request("ConeHandleAdornment");
    v13.Color3 = p9.Propertys.Color3;
    v13.Transparency = p9.Propertys.Transparency;
    v13.CFrame = p10;
    v13.AlwaysOnTop = p9.Propertys.AlwaysOnTop;
    v13.ZIndex = 1;
    v13.Height = p12;
    v13.Radius = p11;
    v13.Adornee = workspace_Terrain;
    v13.Parent = workspace_Terrain;
    Ceive.ActiveInstances = Ceive.ActiveInstances + 1;
    p9.Register(v13);
    p9.Ceive.ScheduleCleaning();
end;

function u1.Create(p14: table, p15, p16: number, p17: number) -- Line: 44
    local v18 = {
        Enabled = true,
        Destroy = false,
        Transform = p15,
        Radius = p16,
        Length = p17,
        AlwaysOnTop = p14.Propertys.AlwaysOnTop,
        Transparency = p14.Propertys.Transparency,
        Color3 = p14.Propertys.Color3
    };
    p14.Retain(p14, v18);

    return v18;
end;

function u1.Update(p19, p20) -- Line: 61
    local Ceive = p19.Ceive;
    Ceive.PushProperty("AlwaysOnTop", p20.AlwaysOnTop);
    Ceive.PushProperty("Transparency", p20.Transparency);
    Ceive.PushProperty("Color3", p20.Color3);
    p19:Draw(p20.Transform, p20.Radius, p20.Length);
end;

return u1;
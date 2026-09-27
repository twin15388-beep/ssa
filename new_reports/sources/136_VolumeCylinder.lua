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

function u1.Draw(p9: table, p10, p11: number, p12: number, p13: number?, p14: number?) -- Line: 19
    -- upvalues: workspace_Terrain (copy)
    local Ceive = p9.Ceive;

    if not Ceive.Enabled then
        return;
    end;

    local v15 = p9.Request("CylinderHandleAdornment");
    v15.Color3 = p9.Propertys.Color3;
    v15.Transparency = p9.Propertys.Transparency;
    v15.CFrame = p10;
    v15.Height = p12;
    v15.Radius = p11;
    v15.InnerRadius = p13 or 0;
    v15.Angle = p14 or 360;
    v15.AlwaysOnTop = p9.Propertys.AlwaysOnTop;
    v15.ZIndex = 1;
    v15.Adornee = workspace_Terrain;
    v15.Parent = workspace_Terrain;
    Ceive.ActiveInstances = Ceive.ActiveInstances + 1;
    p9.Register(v15);
    p9.Ceive.ScheduleCleaning();
end;

function u1.Create(p16: table, p17, p18: number, p19: number, p20: number?, p21: number?) -- Line: 46
    local v22 = {
        Enabled = true,
        Destroy = false,
        Transform = p17,
        Radius = p18,
        Length = p19,
        InnerRadius = p20 or 0,
        Angle = p21 or 360,
        AlwaysOnTop = p16.Propertys.AlwaysOnTop,
        Transparency = p16.Propertys.Transparency,
        Color3 = p16.Propertys.Color3
    };
    p16.Retain(p16, v22);

    return v22;
end;

function u1.Update(p23, p24) -- Line: 65
    local Ceive = p23.Ceive;
    Ceive.PushProperty("AlwaysOnTop", p24.AlwaysOnTop);
    Ceive.PushProperty("Transparency", p24.Transparency);
    Ceive.PushProperty("Color3", p24.Color3);
    p23:Draw(p24.Transform, p24.Radius, p24.Length, p24.InnerRadius, p24.Angle);
end;

return u1;
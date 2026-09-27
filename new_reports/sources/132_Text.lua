-- Decompiled with Potassium's decompiler.

local workspace_CurrentCamera = workspace.CurrentCamera;
local u1 = {};
u1.__index = u1;

function u1.Init(p2, p3, p4, p5, p6) -- Line: 9
    -- upvalues: u1 (copy)
    local v7 = setmetatable({}, u1);
    v7.Ceive = p2;
    v7.Propertys = p3;
    v7.Request = p4;
    v7.Release = p5;
    v7.Retain = p6;

    return v7;
end;

function u1.Draw(p8: table, p9: vector, p10: string, p11: number?) -- Line: 21
    -- upvalues: workspace_CurrentCamera (copy)
    local Ceive = p8.Ceive;

    if not Ceive.Enabled then
        return;
    end;

    if p8.Propertys.AlwaysOnTop then
        local Magnitude = (p9 - workspace_CurrentCamera.CFrame.Position).Magnitude;
        local v12 = Ceive.PopProperty("Color3");
        Ceive.PushProperty("Color3", Color3.new());
        Ceive.AOTWireframeHandle:AddText(p9 + -(Vector3.new(1, 1, 0)).Unit * (Magnitude * 0.00175), p10, p11);
        Ceive.PushProperty("Color3", v12);
        Ceive.AOTWireframeHandle:AddText(p9, p10, p11);
    else
        local Magnitude = (p9 - workspace_CurrentCamera.CFrame.Position).Magnitude;
        local v13 = Ceive.PopProperty("Color3");
        Ceive.PushProperty("Color3", Color3.new());
        Ceive.WireframeHandle:AddText(p9 + -(Vector3.new(1, 1, 0)).Unit * (Magnitude * 0.00175), p10, p11);
        Ceive.PushProperty("Color3", v13);
        Ceive.WireframeHandle:AddText(p9, p10, p11);
    end;

    p8.Ceive.ScheduleCleaning();
end;

function u1.Create(p14: table, p15: vector, p16: string, p17: number?) -- Line: 60
    local v18 = {
        Enabled = true,
        Destroy = false,
        Origin = p15,
        Text = p16,
        Size = p17,
        AlwaysOnTop = p14.Propertys.AlwaysOnTop,
        Transparency = p14.Propertys.Transparency,
        Color3 = p14.Propertys.Color3
    };
    p14.Retain(p14, v18);

    return v18;
end;

function u1.Update(p19, p20) -- Line: 77
    local Ceive = p19.Ceive;
    Ceive.PushProperty("AlwaysOnTop", p20.AlwaysOnTop);
    Ceive.PushProperty("Transparency", p20.Transparency);
    Ceive.PushProperty("Color3", p20.Color3);
    p19:Draw(p20.Origin, p20.Text, p20.Size);
end;

return u1;
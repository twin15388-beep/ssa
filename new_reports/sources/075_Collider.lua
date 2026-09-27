-- Decompiled with Potassium's decompiler.

local HttpService = game:GetService("HttpService");
local Dependencies = script.Parent.Parent.Parent:WaitForChild("Dependencies");
local Colliders = script.Parent:WaitForChild("Colliders");
local Box = require(Colliders:WaitForChild("Box"));
local Capsule = require(Colliders:WaitForChild("Capsule"));
local Cylinder = require(Colliders:WaitForChild("Cylinder"));
local Sphere = require(Colliders:WaitForChild("Sphere"));
local SB_VERBOSE_LOG = require(script.Parent.Parent.Parent:WaitForChild("Dependencies"):WaitForChild("Utilities")).SB_VERBOSE_LOG;
local Gizmo = require(Dependencies:WaitForChild("Debug"):WaitForChild("Gizmo"));
local u1 = {};
u1.__index = u1;

function u1.new() -- Line: 70
    -- upvalues: HttpService (copy), u1 (copy)
    local v2 = {
        Type = "Box",
        Scale = Vector3.new(0, 0, 0),
        Offset = Vector3.new(0, 0, 0),
        Rotation = Vector3.new(0, 0, 0),
        Radius = 0,
        PreviousScale = Vector3.new(0, 0, 0),
        PreviousOffset = Vector3.new(0, 0, 0),
        PreviousRotation = Vector3.new(0, 0, 0),
        PreviousObjectPosition = Vector3.new(0, 0, 0),
        PreviousObjectRotation = Vector3.new(0, 0, 0),
        m_Object = nil,
        InNarrowphase = false,
        Size = Vector3.new(0, 0, 0),
        Transform = CFrame.identity,
        GUID = HttpService:GenerateGUID(false)
    };

    return setmetatable(v2, u1);
end;

function u1.SetObject(p3: table, p4: userdata) -- Line: 99
    p3.m_Object = p4;
    p3:UpdateTransform();
end;

function u1.UpdateTransform(p5) -- Line: 106
    local m_Object = p5.m_Object;
    local CFrame2 = m_Object.CFrame;
    local Size = m_Object.Size;
    local Rotation = p5.Rotation;
    local v6 = Size * p5.Offset;
    local v7 = Size * p5.Scale;
    local CFrame_Angles_ret = CFrame.Angles(Rotation.X * 0.017453, Rotation.Y * 0.017453, Rotation.Z * 0.017453);
    p5.Transform = CFrame2 * CFrame.new(v6) * CFrame_Angles_ret;
    p5.Size = v7;
    p5.Radius = v7.Magnitude * 0.5;
end;

function u1.GetClosestPoint(p8, p9, p10) -- Line: 131
    -- upvalues: Box (copy), Capsule (copy), Sphere (copy), Cylinder (copy)
    if p8.m_Object == nil then
        return;
    end;

    p8.InNarrowphase = false;

    if (p9 - p8.Transform.Position).Magnitude - p10 <= p8.Radius then
        p8.InNarrowphase = true;
        local Type = p8.Type;
        local v11 = nil;
        local v12 = nil;
        local v13 = nil;

        if Type ~= "Box" then
            if Type == "Capsule" then
                local v14, v15, v16 = Capsule(p8.Transform, p8.Size, p9, p10);

                return v14, v15, v16;
            end;

            if Type == "Sphere" then
                local v17, v18, v19 = Sphere(p8.Transform, p8.Size, p9, p10);

                return v17, v18, v19;
            end;

            if Type == "Cylinder" then
                v11, v12, v13 = Cylinder(p8.Transform, p8.Size, p9, p10);
            end;

            return v11, v12, v13;
        end;

        if p8.m_Object:GetAttribute("CapeBackOnly") ~= true then
            local v20, v21, v22 = Box(p8.Transform, p8.Size, p9, p10);

            return v20, v21, v22;
        end;

        local v23 = p8.Transform:PointToObjectSpace(p9);
        local v24 = p8.Size * 0.5;
        local v25;

        if math.abs(v23.X) <= v24.X + p10 and (math.abs(v23.Y) <= v24.Y + p10 and v23.Z >= -v24.Z - p10) then
            v25 = v23.Z < v24.Z + p10;
        else
            v25 = false;
        end;

        return v25, p8.Transform:PointToWorldSpace((Vector3.new(v23.X, v23.Y, v24.Z))), p8.Transform.ZVector;
    end;
end;

function u1.Step(p26) -- Line: 181
    p26:UpdateTransform();
end;

function u1.DrawDebug(p27, p28, p29, p30, p31, p32) -- Line: 193
    -- upvalues: Gizmo (copy)
    local Color3_new_ret = Color3.new(0.509803, 0.933333, 0.42745);
    local Color3_new_ret2 = Color3.new(0.90196, 0.784313, 0.513725);
    local Color3_new_ret3 = Color3.new(1, 0, 1);
    local Color3_new_ret4 = Color3.new(0, 1, 1);
    local Color3_new_ret5 = Color3.new(1, 0.3, 0.3);
    local Type = p27.Type;
    local Transform = p27.Transform;
    local Size = p27.Size;

    if p28.m_Awake then
        Color3_new_ret3 = Color3_new_ret;
    elseif not p31 then
        Color3_new_ret3 = Color3_new_ret;
    end;

    if p27.InNarrowphase == false then
        if not p32 then
            Color3_new_ret4 = Color3_new_ret2;
        end;
    else
        Color3_new_ret4 = Color3_new_ret2;
    end;

    if p30 then
        Gizmo.SetStyle(Color3_new_ret5, 0, false);
        Gizmo.Sphere:Draw(Transform, p27.Radius, 25, 360);
    end;

    if Type == "Box" then
        Gizmo.SetStyle(Color3_new_ret3, 0, false);
        Gizmo.Box:Draw(Transform, Size);

        if p29 then
            Gizmo.SetStyle(Color3_new_ret4, 0.75, false);
            Gizmo.VolumeBox:Draw(Transform, Size);
            Gizmo.PushProperty("Transparency", 0);
        end;

        return;
    end;

    if Type == "Capsule" then
        local v33 = (Size.Y < Size.Z and Size.Y or Size.Z) * 0.5;
        local X = Size.X;
        local v34 = Transform * CFrame.Angles(1.5707963267948966, -1.5707963267948966, 0);
        Gizmo.SetStyle(Color3_new_ret3, 0, false);
        Gizmo.Capsule:Draw(v34, v33, X, 15);

        if p29 then
            local v35 = v34.Position + v34.UpVector * (X * 0.5);
            local v36 = v34.Position - v34.UpVector * (X * 0.5);
            Gizmo.SetStyle(Color3_new_ret4, 0.75, false);
            Gizmo.VolumeCylinder:Draw(Transform, v33, X);
            Gizmo.VolumeSphere:Draw(CFrame.new(v35), v33);
            Gizmo.VolumeSphere:Draw(CFrame.new(v36), v33);
            Gizmo.PushProperty("Transparency", 0);
        end;

        return;
    end;

    if Type == "Sphere" then
        local v37 = math.min(Size.X, Size.Y, Size.Z) * 0.5;
        Gizmo.SetStyle(Color3_new_ret3, 0, false);
        Gizmo.Sphere:Draw(Transform, v37, 15, 360);

        if p29 then
            Gizmo.SetStyle(Color3_new_ret4, 0.75, false);
            Gizmo.VolumeSphere:Draw(Transform, v37);
            Gizmo.PushProperty("Transparency", 0);
        end;

        return;
    end;

    if Type ~= "Cylinder" then
        return;
    end;

    local v38 = (Size.Y < Size.Z and Size.Y or Size.Z) * 0.5;
    Gizmo.SetStyle(Color3_new_ret3, 0, false);
    Gizmo.Cylinder:Draw(Transform * CFrame.Angles(0, 0, 1.5707963267948966), v38, Size.X, 15);

    if p29 then
        Gizmo.SetStyle(Color3_new_ret4, 0.75, false);
        Gizmo.VolumeCylinder:Draw(Transform * CFrame.Angles(0, -1.5707963267948966, 0), v38, Size.X, 0, 360);
        Gizmo.PushProperty("Transparency", 0);
    end;
end;

function u1.Destroy(p39) -- Line: 285
    -- upvalues: SB_VERBOSE_LOG (copy)
    SB_VERBOSE_LOG((`Collider destroying, object: {p39.m_Object}`));
    setmetatable(p39, nil);
end;

return u1;
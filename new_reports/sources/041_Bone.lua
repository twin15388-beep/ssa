-- Decompiled with Potassium's decompiler.

local Dependencies = script.Parent.Parent:WaitForChild("Dependencies");
local Config = require(script.Parent.Parent:WaitForChild("Config"));
local Gizmo = require(Dependencies:WaitForChild("Debug"):WaitForChild("Gizmo"));
local Utilities = require(Dependencies:WaitForChild("Utilities"));
local Constraints = script.Parent:WaitForChild("Constraints");
local AxisConstraint = require(Constraints:WaitForChild("AxisConstraint"));
local CollisionConstraint = require(Constraints:WaitForChild("CollisionConstraint"));
local DistanceConstraint = require(Constraints:WaitForChild("DistanceConstraint"));
local FrictionConstraint = require(Constraints:WaitForChild("FrictionConstraint"));
local RopeConstraint = require(Constraints:WaitForChild("RopeConstraint"));
local RotationConstraint = require(Constraints:WaitForChild("RotationConstraint"));
local SpringConstraint = require(Constraints:WaitForChild("SpringConstraint"));
local SB_ASSERT_CB = Utilities.SB_ASSERT_CB;

local function SafeUnit(p1: vector) -- Line: 23
    return p1.Magnitude == 0 and Vector3.new(0, 0, 0) or p1.Unit;
end;

local function IsNaN(p2) -- Line: 84
    return p2 ~= p2;
end;

local u3 = setmetatable({}, {
    __mode = "k"
});

local function QueryTransformedWorldCFrameNonSmartbone(p4: userdata) -- Line: 95
    -- upvalues: u3 (copy), QueryTransformedWorldCFrameNonSmartbone (copy)
    local v5 = u3[p4];

    if v5 and v5.Frame == shared.FrameCounter then
        return v5.CFrame;
    end;

    local Parent = p4.Parent;
    local v6;

    if Parent:IsA("Bone") then
        v6 = QueryTransformedWorldCFrameNonSmartbone(Parent);
    else
        v6 = Parent.CFrame;
    end;

    local v7 = v6 * p4.TransformedCFrame;

    if not v5 then
        u3[p4] = {
            Frame = shared.FrameCounter,
            CFrame = v7
        };

        return v7;
    end;

    v5.Frame = shared.FrameCounter;
    v5.CFrame = v7;

    return v7;
end;

local function QueryTransformedWorldCFrame(p8: any, p9: table) -- Line: 128
    -- upvalues: QueryTransformedWorldCFrameNonSmartbone (copy), QueryTransformedWorldCFrame (copy)
    p9.SolvedAnimatedCFrame = true;
    local ParentIndex = p9.ParentIndex;
    local Bone = p9.Bone;

    if ParentIndex < 1 then
        return QueryTransformedWorldCFrameNonSmartbone(Bone);
    end;

    local v10 = p8.Bones[ParentIndex];

    if not v10.SolvedAnimatedCFrame then
        v10.AnimatedWorldCFrame = QueryTransformedWorldCFrame(p8, v10);
    end;

    return v10.AnimatedWorldCFrame * Bone.TransformedCFrame;
end;

local function ClipVector(p11: vector, p12: vector, p13: vector) -- Line: 150
    return p11 * (Vector3.new(1, 1, 1) - p13) + p12 * p13;
end;

local function GetFriction(p14: userdata, p15: userdata) -- Line: 156
    local CurrentPhysicalProperties = p14.CurrentPhysicalProperties;
    local CurrentPhysicalProperties2 = p15.CurrentPhysicalProperties;
    local FrictionWeight = CurrentPhysicalProperties.FrictionWeight;
    local FrictionWeight2 = CurrentPhysicalProperties2.FrictionWeight;

    return (CurrentPhysicalProperties.Friction * FrictionWeight + CurrentPhysicalProperties2.Friction * FrictionWeight2) / (FrictionWeight + FrictionWeight2);
end;

local function SolveWind(p16: table, u17: any, p18: vector) -- Line: 169
    local Settings = u17.Settings;
    local WindType = Settings.WindType;

    if WindType ~= "Sine" and (WindType ~= "Noise" and WindType ~= "Hybrid") then
        return Vector3.new(0, 0, 0);
    end;

    local v19 = u17.WindOffset + (os.clock() - p16.HeirarchyLength * 0.2 + (p16.TransformOffset.Position - u17.Root.WorldPosition).Magnitude * 0.2) * Settings.WindInfluence;
    local WindSpeed = Settings.WindSpeed;
    local WindStrength = Settings.WindStrength;

    if WindSpeed <= 1e-6 or WindStrength <= 1e-6 then
        return Vector3.new(0, 0, 0);
    end;

    local WindDirection = Settings.WindDirection;
    local v20 = p18.Magnitude == 0 and Vector3.new(0, 0, 0) or p18.Unit;
    local v21 = v20:Dot(WindDirection);
    local v22 = 1 - math.abs(v21);

    if WindSpeed > 0 then
        if v20:Dot(WindDirection) > 0 then
            v22 = v22 * math.abs(1 - p18.Magnitude / WindSpeed);
        else
            v22 = v22 * (1 + p18.Magnitude / WindSpeed);
        end;
    end;

    local v23 = WindSpeed * v22;

    local function EaseInExpo(p24: number) -- Line: 217
        return p24 == 0 and 0 or 2 ^ (p24 * 10 - 10);
    end;

    local v25 = p18.Magnitude < 100 and p18.Magnitude or 100;
    local math_min_ret = math.min(v25 == 0 and 0 or 2 ^ (v25 * 10 - 10), 100);
    local u26 = v19 * math.max(math_min_ret, 1);
    local u27;

    if v23 < 1 then
        u27 = v23 * math_min_ret;
    else
        local v28 = math_min_ret / 2;
        u27 = v23 * (v28 > 1 and v28 and v28 or 1);
    end;

    local v29 = nil;

    local function GetNoise(p30, p31, p32, p33) -- Line: 234
        local math_noise_ret = math.noise(p30, p31, p32);
        local math_clamp_ret = math.clamp(math_noise_ret, -1, 1);

        if p33 then
            math_clamp_ret = math_clamp_ret ^ 2;
        end;

        return math_clamp_ret;
    end;

    local function SampleGust() -- Line: 246
        -- upvalues: u26 (ref)
        return math.sin(u26 * 1) * 0.3 + 0.7;
    end;

    local function SampleSin() -- Line: 252
        -- upvalues: WindStrength (copy), u27 (ref), u26 (ref), WindDirection (copy)
        local v34 = WindStrength ^ 0.8;
        local v35 = u27 * 2;
        local math_sin_ret = math.sin(u26 * v34);
        local math_cos_ret = math.cos(u26 / 10 * v34);
        local math_sin_ret2 = math.sin(u26 * 2 * v34);
        local math_cos_ret2 = math.cos(u26 * 3 * v34);
        local v36 = (math_sin_ret + math_cos_ret + math_sin_ret2 + math_cos_ret2) / 4;
        local v37 = v36 * v35;
        local v38 = (v36 * 0.5 + 0.5) * v35;

        if v37 < v38 then
            v37 = v38 or v37;
        end;

        return WindDirection * v37;
    end;

    local function SampleNoise(p39, p40) -- Line: 270
        -- upvalues: WindStrength (copy), u27 (ref), u17 (copy), WindDirection (copy)
        local v41 = p39 or 0;
        local v42 = WindStrength ^ 0.8;
        local v43 = u27 * 2;
        local WindOffset = u17.WindOffset;
        local math_noise_ret = math.noise(v42, 0, WindOffset);
        local math_clamp_ret = math.clamp(math_noise_ret, -1, 1);

        if p40 then
            math_clamp_ret = math_clamp_ret ^ 2;
        end;

        local math_noise_ret2 = math.noise(0, v42, WindOffset);
        local math_clamp_ret2 = math.clamp(math_noise_ret2, -1, 1);

        if p40 then
            math_clamp_ret2 = math_clamp_ret2 ^ 2;
        end;

        local math_noise_ret3 = math.noise(WindOffset, 0, v42);
        local math_clamp_ret3 = math.clamp(math_noise_ret3, -1, 1);

        if p40 then
            math_clamp_ret3 = math_clamp_ret3 ^ 2;
        end;

        return WindDirection * Vector3.new(math_clamp_ret * (v43 + v41), math_clamp_ret2 * (v43 + v41), math_clamp_ret3 * (v43 + v41));
    end;

    if Settings.WindType == "Sine" then
        v29 = SampleSin() * (math.sin(u26 * 1) * 0.3 + 0.7);
    elseif Settings.WindType == "Noise" then
        v29 = SampleNoise(0, true) * (math.sin(u26 * 1) * 0.3 + 0.7);
    elseif Settings.WindType == "Hybrid" then
        v29 = (SampleSin() * (math.sin(u26 * 1) * 0.3 + 0.7) + SampleNoise(0.5, true) * (math.sin(u26 * 1) * 0.3 + 0.7)) * 0.5;
    end;

    return v29 / (p16.FreeLength < 0.01 and 0.01 or p16.FreeLength) * (Settings.WindInfluence * (WindStrength * 0.01) * (math.clamp(p16.HeirarchyLength, 1, 10) * 0.1)) * p16.Weight;
end;

local u44 = {};
u44.__index = u44;

function u44.new(u45: userdata, p46: userdata, p47: userdata) -- Line: 446
    -- upvalues: u44 (copy), Utilities (copy)
    local v48 = u45.Parent:IsA("Bone") and u45.Parent.TransformedWorldCFrame or p47.CFrame;
    local v49 = {
        Bone = u45,
        FreeLength = -1,
        Weight = 0.7,
        ParentIndex = -1,
        HeirarchyLength = 0,
        Transform = u45.TransformedWorldCFrame:ToObjectSpace(v48):Inverse(),
        LocalTransform = u45.TransformedCFrame:ToObjectSpace(p46.TransformedCFrame):Inverse(),
        RootPart = p47,
        RootBone = p46,
        Radius = 0,
        Friction = 0,
        RotationLimit = 0,
        Force = nil,
        Gravity = nil,
        GravityFalloff = 0,
        SolvedAnimatedCFrame = false,
        HasChild = false,
        AnimatedWorldCFrame = u45.TransformedWorldCFrame,
        StartingCFrame = u45.TransformedCFrame,
        TransformOffset = CFrame.identity,
        LocalTransformOffset = CFrame.identity,
        RestPosition = Vector3.new(0, 0, 0),
        CalculatedWorldCFrame = u45.TransformedWorldCFrame,
        Position = u45.TransformedWorldCFrame.Position,
        LastPosition = u45.TransformedWorldCFrame.Position,
        WeldPosition = Vector3.new(0, 0, 0),
        WeldCFrame = CFrame.identity,
        ActiveWeld = false,
        RigidWeld = false,
        Anchored = false,
        AxisLocked = { false, false, false },
        XAxisLimits = NumberRange.new((-1 / 0), (1 / 0)),
        YAxisLimits = NumberRange.new((-1 / 0), (1 / 0)),
        ZAxisLimits = NumberRange.new((-1 / 0), (1 / 0)),
        IsSkippingUpdates = false,
        CollisionHits = {},
        CollisionsData = {}
    };
    local u50 = setmetatable(v49, u44);
    u50.AttributeConnection = u45.AttributeChanged:Connect(function(p51) -- Line: 500
        -- upvalues: Utilities (ref), u45 (copy), u50 (copy)
        for i, v in Utilities.GatherBoneSettings(u45) do
            local v52;

            if v == "¬" or not v then
                v52 = nil;
            else
                v52 = v;
            end;

            u50[i] = v52;
        end;
    end);

    return u50;
end;

function u44.ClipVelocity(p53: table, p54: vector, p55: vector) -- Line: 517
    p53.LastPosition = p53.LastPosition * (Vector3.new(1, 1, 1) - p55) + p54 * p55;
end;

function u44.PreUpdate(p56, p57) -- Line: 523
    -- upvalues: QueryTransformedWorldCFrameNonSmartbone (copy), QueryTransformedWorldCFrame (copy)
    local v58 = p57.Bones[1];
    local v59 = p57.Bones[p56.ParentIndex];
    p56.SolvedAnimatedCFrame = true;
    local ParentIndex = p56.ParentIndex;
    local Bone = p56.Bone;
    local v60;

    if ParentIndex < 1 then
        v60 = QueryTransformedWorldCFrameNonSmartbone(Bone);
    else
        local v61 = p57.Bones[ParentIndex];

        if not v61.SolvedAnimatedCFrame then
            v61.AnimatedWorldCFrame = QueryTransformedWorldCFrame(p57, v61);
        end;

        v60 = v61.AnimatedWorldCFrame * Bone.TransformedCFrame;
    end;

    p56.AnimatedWorldCFrame = v60;
    local SmartWeld = p56.Bone:FindFirstChild("SmartWeld");
    p56.ActiveWeld = false;

    if SmartWeld and SmartWeld:IsA("ObjectValue") then
        local Value = SmartWeld.Value;
        p56.RigidWeld = SmartWeld:GetAttribute("Rigid") == true;

        if Value then
            if Value:IsA("Attachment") then
                p56.WeldPosition = Value.WorldPosition;
                p56.WeldCFrame = Value.WorldCFrame;
                p56.ActiveWeld = true;
            elseif Value:IsA("BasePart") then
                p56.WeldPosition = Value.Position;
                p56.WeldCFrame = Value.CFrame;
                p56.ActiveWeld = true;
            end;
        end;
    end;

    if p56.ParentIndex < 1 then
        p56.Anchored = true;
    end;

    if p56.Bone == p56.RootBone then
        local v62;

        if p56.Bone.Parent:IsA("Bone") then
            v62 = QueryTransformedWorldCFrameNonSmartbone(p56.Bone.Parent);
        else
            v62 = p56.RootPart.CFrame;
        end;

        p56.TransformOffset = v62 * p56.Transform;
    else
        p56.TransformOffset = v59.AnimatedWorldCFrame * p56.Transform;
    end;

    p56.LocalTransformOffset = v58.Bone.CFrame * p56.LocalTransform;
end;

function u44.StepPhysics(p63: table, p64: any, p65: vector, p66: number) -- Line: 582
    -- upvalues: SolveWind (copy)
    if p63.Anchored then
        p63.LastPosition = p63.AnimatedWorldCFrame.Position;
        p63.Position = p63.AnimatedWorldCFrame.Position;

        return;
    end;

    if p63.Force or p63.Gravity then
        p65 = (p63.Gravity or p64.Settings.Gravity) + (p63.Force or p64.Settings.Force);
    end;

    local Settings = p64.Settings;
    local v67 = (p63.Position - p63.LastPosition) / p66;

    if v67.Magnitude > 50 then
        v67 = v67.Unit * 50 or v67;
    end;

    local v68 = p64.ObjectAcceleration * Settings.Inertia;
    local v69 = SolveWind(p63, p64, v67);
    p63.LastPosition = p63.Position;
    p63.Position = p63.Position + (v67 * (1 - Settings.Damping) * p66 + (p65 + v68) * p66 * p66 + v69);
end;

function u44.Constrain(p70: table, p71: any, p72: any, p73: number) -- Line: 623
    -- upvalues: FrictionConstraint (copy), CollisionConstraint (copy), SpringConstraint (copy), DistanceConstraint (copy), RopeConstraint (copy), AxisConstraint (copy), RotationConstraint (copy)
    if p70.Anchored then
        return;
    end;

    local RootPart = p70.RootPart;
    local CFrame2 = RootPart.CFrame;
    local v74 = FrictionConstraint(p70, p70.Position, p70.LastPosition);

    if #p72 ~= 0 then
        v74 = CollisionConstraint(p70, v74, p72);
    end;

    local v75;

    if p71.Settings.Constraint == "Spring" then
        v75 = SpringConstraint(p70, v74, nil, p71, p73);
    elseif p71.Settings.Constraint == "Distance" then
        v75 = DistanceConstraint(p70, v74, p71);
    elseif p71.Settings.Constraint == "Rope" then
        v75 = RopeConstraint(p70, v74, p71);
    else
        v75 = p70.AnimatedWorldCFrame.Position;
    end;

    local v76 = RotationConstraint(p70, AxisConstraint(p70, v75, p70.LastPosition, CFrame2), p71);

    if RootPart:GetAttribute("ProceduralCapeSkinning") == true then
        local Attribute = p70.Bone:GetAttribute("CapeRestWidth");

        if typeof(Attribute) == "number" then
            local v77 = CFrame2:PointToObjectSpace(v76);
            local math_clamp_ret = math.clamp(v77.Z, Attribute - 0.12, Attribute + 0.12);

            if math_clamp_ret ~= v77.Z then
                v76 = CFrame2:PointToWorldSpace((Vector3.new(v77.X, v77.Y, math_clamp_ret)));
                p70:ClipVelocity(v76, CFrame2.ZVector);
            end;
        end;
    end;

    if p70.ActiveWeld then
        if p70.RigidWeld then
            v76 = p70.WeldPosition;
        else
            v76 = SpringConstraint(p70, v76, p70.WeldPosition, p71, p73);
        end;
    end;

    p70.Friction = 0;

    for _, v in p70.CollisionHits do
        local CurrentPhysicalProperties = p70.RootPart.CurrentPhysicalProperties;
        local CurrentPhysicalProperties2 = v.CurrentPhysicalProperties;
        local FrictionWeight = CurrentPhysicalProperties.FrictionWeight;
        local FrictionWeight2 = CurrentPhysicalProperties2.FrictionWeight;
        local v78 = (CurrentPhysicalProperties.Friction * FrictionWeight + CurrentPhysicalProperties2.Friction * FrictionWeight2) / (FrictionWeight + FrictionWeight2);

        if v78 < p70.Friction then
            v78 = p70.Friction or v78;
        end;

        p70.Friction = v78;
    end;

    p70.Position = v76;
end;

function u44.SkipUpdate(p79) -- Line: 692
    -- upvalues: Config (copy)
    if p79.IsSkippingUpdates == false and Config.RESET_TRANSFORM_ON_SKIP then
        p79.CalculatedWorldCFrame = p79.AnimatedWorldCFrame;
        p79.IsSkippingUpdates = true;
    end;

    p79.LastPosition = p79.AnimatedWorldCFrame.Position + (p79.LastPosition - p79.Position);
    p79.Position = p79.AnimatedWorldCFrame.Position;
end;

function u44.SolveTransform(p80: table, p81: any, p82: number) -- Line: 707
    -- upvalues: Utilities (copy), SB_ASSERT_CB (copy)
    if p80.ParentIndex < 1 then
        return;
    end;

    p80.IsSkippingUpdates = false;
    local v83 = p81.Bones[p80.ParentIndex];

    if v83 and v83.Bone then
        local Bone = v83.Bone;
        local TransformOffset = v83.TransformOffset;
        local v84 = p80.Position - v83.Position;
        local UpVector = TransformOffset.UpVector;
        local v85;

        if p80.RootPart:GetAttribute("ProceduralCapeSkinning") == true then
            v85 = TransformOffset:VectorToWorldSpace(p80.Transform.Position);

            if v85.Magnitude <= 1e-6 then
                v85 = UpVector;
            end;
        else
            v85 = UpVector;
        end;

        local v86 = Utilities.GetRotationBetween(v85, v84).Rotation * TransformOffset.Rotation;
        local math_min_ret = math.min(1 - 0.00001 ^ p82, 1);

        if v83.ActiveWeld and v83.RigidWeld then
            v83.CalculatedWorldCFrame = v83.WeldCFrame;
        else
            v83.CalculatedWorldCFrame = Bone.WorldCFrame:Lerp(CFrame.new(v83.Position) * v86, math_min_ret);
        end;

        local Position = v83.CalculatedWorldCFrame.Position;
        SB_ASSERT_CB(Position == Position, warn, "If you see this report this as a bug, (NaN Calc world cframe)");
    end;
end;

function u44.ApplyTransform(p87, p88) -- Line: 753
    p87.SolvedAnimatedCFrame = false;

    if p87.ParentIndex < 1 then
        return;
    end;

    local v89 = p88.Bones[p87.ParentIndex];

    if v89 and v89.Bone then
        local Bone = v89.Bone;

        if v89.Anchored then
            if p88.Settings.AnchorsRotate and not p87.Anchored then
                Bone.WorldCFrame = CFrame.new(v89.Position) * v89.CalculatedWorldCFrame.Rotation;

                return;
            end;

            Bone.WorldCFrame = v89.TransformOffset;

            return;
        end;

        Bone.WorldCFrame = v89.CalculatedWorldCFrame;
    end;
end;

function u44.DrawDebug(p90: table, p91: any, p92: boolean, p93: boolean, p94: boolean, p95: boolean, p96: boolean) -- Line: 797
    -- upvalues: Gizmo (copy)
    local Color3_fromRGB_ret = Color3.fromRGB(255, 0, 0);
    local Color3_fromRGB_ret2 = Color3.fromRGB(255, 94, 0);
    local Color3_fromRGB_ret3 = Color3.fromRGB(234, 1, 255);
    local Color3_fromRGB_ret4 = Color3.fromRGB(0, 255, 255);
    local Color3_fromRGB_ret5 = Color3.fromRGB(255, 0, 0);
    local Color3_fromRGB_ret6 = Color3.fromRGB(0, 255, 0);
    local Color3_fromRGB_ret7 = Color3.fromRGB(0, 0, 255);
    local Color3_fromRGB_ret8 = Color3.fromRGB(0, 183, 255);
    local Color3_fromRGB_ret9 = Color3.fromRGB(255, 0, 0);
    local Color3_fromRGB_ret10 = Color3.fromRGB(0, 255, 0);
    local Color3_fromRGB_ret11 = Color3.fromRGB(0, 0, 255);
    local Color3_fromRGB_ret12 = Color3.fromRGB(28, 41, 224);
    local Color3_fromRGB_ret13 = Color3.fromRGB(255, 27, 27);
    local v97 = 1;
    local AnimatedWorldCFrame = p90.AnimatedWorldCFrame;
    local Position = AnimatedWorldCFrame.Position;
    local CFrame_new_ret = CFrame.new(p90.Position);
    local CFrame_new_ret2 = CFrame.new(p90.LastPosition);

    if p94 then
        Gizmo.PushProperty("AlwaysOnTop", false);
        Gizmo.PushProperty("Color3", Color3_fromRGB_ret);
        Gizmo.Sphere:Draw(CFrame_new_ret, p90.Radius, 10, 360);
        Gizmo.PushProperty("Color3", Color3_fromRGB_ret2);
        Gizmo.Sphere:Draw(CFrame_new_ret2, p90.Radius, 10, 360);
        Gizmo.PushProperty("Color3", Color3_fromRGB_ret3);
        Gizmo.Ray:Draw(p90.Position, p90.LastPosition);
    end;

    if p95 and not p90.Anchored then
        local v98 = p90.AxisLocked[1];
        local v99 = p90.AxisLocked[2];
        local v100 = p90.AxisLocked[3];
        local RootPart = p90.RootPart;
        local v101 = RootPart.CFrame:PointToObjectSpace(Position);
        local RightVector = RootPart.CFrame.RightVector;
        local UpVector = RootPart.CFrame.UpVector;
        local LookVector = RootPart.CFrame.LookVector;

        if not v98 then
            Gizmo.PushProperty("Color3", Color3_fromRGB_ret9);
            Gizmo.Arrow:Draw(Position - RightVector * 2, Position + RightVector * 2, 0.05, 0.15, 9);
            local v102 = p90.XAxisLimits.Max - v101.X;
            Gizmo.Plane:Draw(Position + RightVector * (p90.XAxisLimits.Min - v101.X), RightVector, Vector3.new(5, 5, 0));
            Gizmo.Plane:Draw(Position + RightVector * v102, RightVector, Vector3.new(5, 5, 0));
        end;

        if not v99 then
            Gizmo.PushProperty("Color3", Color3_fromRGB_ret10);
            Gizmo.Arrow:Draw(Position - UpVector * 2, Position + UpVector * 2, 0.05, 0.15, 9);
            local v103 = p90.YAxisLimits.Max - v101.Y;
            Gizmo.Plane:Draw(Position + UpVector * (p90.YAxisLimits.Min - v101.Y), UpVector, Vector3.new(5, 5, 0));
            Gizmo.Plane:Draw(Position + UpVector * v103, UpVector, Vector3.new(5, 5, 0));
        end;

        if not v100 then
            Gizmo.PushProperty("Color3", Color3_fromRGB_ret11);
            Gizmo.Arrow:Draw(Position - LookVector * 2, Position + LookVector * 2, 0.05, 0.15, 9);
            local v104 = p90.ZAxisLimits.Max - v101.Z;
            Gizmo.Plane:Draw(Position - LookVector * (p90.ZAxisLimits.Min - v101.Z), LookVector, Vector3.new(5, 5, 0));
            Gizmo.Plane:Draw(Position - LookVector * v104, LookVector, Vector3.new(5, 5, 0));
        end;
    end;

    if p93 then
        Gizmo.PushProperty("Color3", Color3_fromRGB_ret4);
        Gizmo.Sphere:Draw(AnimatedWorldCFrame, 0.08, 5, 360);
        Gizmo.PushProperty("Color3", Color3_fromRGB_ret5);
        Gizmo.VolumeArrow:Draw(Position, Position + AnimatedWorldCFrame.LookVector * 0.25, 0.005, 0.015, 0.05, true);
        Gizmo.PushProperty("Color3", Color3_fromRGB_ret6);
        Gizmo.VolumeArrow:Draw(Position, Position + AnimatedWorldCFrame.UpVector * 0.25, 0.005, 0.015, 0.05, true);
        Gizmo.PushProperty("Color3", Color3_fromRGB_ret7);
        Gizmo.VolumeArrow:Draw(Position, Position + AnimatedWorldCFrame.RightVector * 0.25, 0.005, 0.015, 0.05, true);
    end;

    if p92 and not p90.Anchored then
        for _, v in p90.CollisionsData do
            Gizmo.PushProperty("Color3", Color3_fromRGB_ret12);
            Gizmo.Sphere:Draw(CFrame.new(v.ClosestPoint), 0.08, 5, 360);
            Gizmo.PushProperty("Color3", Color3_fromRGB_ret13);
            Gizmo.Arrow:Draw(v.ClosestPoint, v.ClosestPoint + v.Normal * 0.5, 0.05, 0.15, 9);
        end;
    end;

    if p96 and (p90.RotationLimit < 180 and (p90.RotationLimit > 0 and (p90.ParentIndex > 0 and p90.HasChild))) then
        local v105 = 1;
        local v106;

        if p90.RotationLimit < 89.5 then
            local math_rad_ret = math.rad(p90.RotationLimit);
            v106 = v97 * math.tan(math_rad_ret);
        elseif p90.RotationLimit > 90 then
            local math_rad_ret = math.rad(180 - p90.RotationLimit);
            v106 = v97 * math.tan(math_rad_ret);
            v105 = -1;
        else
            v106 = 5;
            v97 = 0;
        end;

        local math_min_ret = math.min(v106, 5);
        local v107 = math_min_ret == 5 and 0 or v97;
        local v108 = (p90.Position - p91.Bones[p90.ParentIndex].Position).Unit * v105;
        local CFrame_lookAt_ret = CFrame.lookAt(Position + v108 * (v107 * 0.5), Position + -v108 * 500, AnimatedWorldCFrame.LookVector);
        Gizmo.PushProperty("Color3", Color3_fromRGB_ret8);
        Gizmo.Cone:Draw(CFrame_lookAt_ret, math_min_ret, v107, 8 + math_min_ret * 2);
    end;
end;

function u44.DrawOverlay(p109: table, p110: table) -- Line: 988
    -- upvalues: Config (copy)
    p110.Text((`Bone: {p109.Bone.Name}`));

    if Config.DEBUG_OVERLAY_BONE_INFO or Config.DEBUG_OVERLAY_BONE_NUMERICS then
        p110.Text((`Free Length: {p109.FreeLength}`));
        p110.Text((`Weight: {p109.Weight}`));
        p110.Text((`Parent Index: {p109.ParentIndex}`));
        p110.Text((`Heirarchy Length: {p109.HeirarchyLength}`));
        p110.Text((`Radius: {p109.Radius}`));
        p110.Text((`Friction: {p109.Friction}`));
        p110.Text((`Rotation Limit: {p109.RotationLimit}`));
    end;

    if Config.DEBUG_OVERLAY_BONE_INFO or Config.DEBUG_OVERLAY_BONE_CONSTRAIN then
        p110.Text((`Anchored: {p109.Anchored}`));
        p110.Text((`Axis Locked: {p109.AxisLocked[1]}, {p109.AxisLocked[2]}, {p109.AxisLocked[3]}`));
        p110.Text((`X Axis Limit: {p109.XAxisLimits}`));
        p110.Text((`Y Axis Limit: {p109.YAxisLimits}`));
        p110.Text((`Z Axis Limit: {p109.ZAxisLimits}`));
    end;

    if Config.DEBUG_OVERLAY_BONE_INFO or Config.DEBUG_OVERLAY_BONE_WELD then
        p110.Text((`Active Weld: {p109.ActiveWeld}`));
        p110.Text((`Rigid Weld: {p109.RigidWeld}`));
        p110.Text((`Weld Position: {string.format("%.3f, %.3f, %.3f", p109.WeldPosition.X, p109.WeldPosition.Y, p109.WeldPosition.Z)}`));
    end;

    if Config.DEBUG_OVERLAY_BONE_INFO or Config.DEBUG_OVERLAY_BONE_FORCES then
        local v111 = p109.Force and (string.format("%.3f, %.3f, %.3f", p109.Force.X, p109.Force.Y, p109.Force.Z) or "-, -, -") or "-, -, -";
        local v112 = p109.Gravity and string.format("%.3f, %.3f, %.3f", p109.Gravity.X, p109.Gravity.Y, p109.Gravity.Z) or "-, -, -";
        p110.Text((`Force: {v111}`));
        p110.Text((`Gravity: {v112}`));
    end;
end;

function u44.Destroy(p113) -- Line: 1024
    -- upvalues: Config (copy)
    if Config.RESET_BONE_ON_DESTROY then
        p113.Bone.CFrame = p113.StartingCFrame;
    end;

    p113.AttributeConnection:Disconnect();
    setmetatable(p113, nil);
end;

return u44;
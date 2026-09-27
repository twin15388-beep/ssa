-- Decompiled with Potassium's decompiler.

local Dependencies = script.Parent.Parent:WaitForChild("Dependencies");
local Config = require(Dependencies:WaitForChild("Config"));
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
local _ = Utilities.SB_ASSERT_CB;

local function SafeUnit(p1: vector) -- Line: 23
    return p1.Magnitude == 0 and Vector3.new(0, 0, 0) or p1.Unit;
end;

local function IsNaN(p2) -- Line: 84
    return p2 ~= p2;
end;

local u3 = 0;
local u4 = {};

local function QueryTransformedWorldCFrameNonSmartbone(p5: userdata) -- Line: 99
    -- upvalues: u4 (copy), QueryTransformedWorldCFrameNonSmartbone (copy)
    local v6 = u4[p5];

    if v6 and v6.Frame == shared.FrameCounter then
        return v6.CFrame;
    end;

    local Parent = p5.Parent;

    if Parent == nil then
        return v6 and v6.CFrame or CFrame.identity;
    end;

    local v7;

    if Parent:IsA("Bone") then
        v7 = QueryTransformedWorldCFrameNonSmartbone(Parent);
    else
        v7 = Parent.CFrame;
    end;

    local v8 = v7 * p5.TransformedCFrame;
    u4[p5] = {
        Frame = shared.FrameCounter,
        CFrame = v8
    };

    return v8;
end;

local function QueryTransformedWorldCFrame(p9: any, p10: table) -- Line: 134
    -- upvalues: QueryTransformedWorldCFrameNonSmartbone (copy), QueryTransformedWorldCFrame (copy)
    p10.SolvedAnimatedCFrame = true;
    local ParentIndex = p10.ParentIndex;
    local Bone = p10.Bone;

    if ParentIndex < 1 then
        return QueryTransformedWorldCFrameNonSmartbone(Bone);
    end;

    local v11 = p9.Bones[ParentIndex];

    if not v11.SolvedAnimatedCFrame then
        v11.AnimatedWorldCFrame = QueryTransformedWorldCFrame(p9, v11);
    end;

    return v11.AnimatedWorldCFrame * Bone.TransformedCFrame;
end;

local function ClipVector(p12: vector, p13: vector, p14: vector) -- Line: 156
    return p12 * (Vector3.new(1, 1, 1) - p14) + p13 * p14;
end;

local function GetFriction(p15: userdata, p16: userdata) -- Line: 162
    local CurrentPhysicalProperties = p15.CurrentPhysicalProperties;
    local CurrentPhysicalProperties2 = p16.CurrentPhysicalProperties;
    local FrictionWeight = CurrentPhysicalProperties.FrictionWeight;
    local FrictionWeight2 = CurrentPhysicalProperties2.FrictionWeight;

    return (CurrentPhysicalProperties.Friction * FrictionWeight + CurrentPhysicalProperties2.Friction * FrictionWeight2) / (FrictionWeight + FrictionWeight2);
end;

local function SolveWind(p17: table, u18: any, p19: vector) -- Line: 175
    local Settings = u18.Settings;
    local WindType = Settings.WindType;

    if WindType ~= "Sine" and (WindType ~= "Noise" and WindType ~= "Hybrid") then
        return Vector3.new(0, 0, 0);
    end;

    local WindSpeed = Settings.WindSpeed;
    local WindStrength = Settings.WindStrength;

    if WindSpeed <= 1e-6 or WindStrength <= 1e-6 then
        return Vector3.new(0, 0, 0);
    end;

    local v20 = u18.WindOffset + (os.clock() - p17.HeirarchyLength * 0.2 + (p17.TransformOffset.Position - u18.Root.WorldPosition).Magnitude * 0.2) * Settings.WindInfluence;
    local WindDirection = Settings.WindDirection;
    local v21 = p19.Magnitude == 0 and Vector3.new(0, 0, 0) or p19.Unit;
    local v22 = v21:Dot(WindDirection);
    local v23 = 1 - math.abs(v22);

    if WindSpeed > 0 then
        if v21:Dot(WindDirection) > 0 then
            v23 = v23 * math.abs(1 - p19.Magnitude / WindSpeed);
        else
            v23 = v23 * (1 + p19.Magnitude / WindSpeed);
        end;
    end;

    local v24 = WindSpeed * v23;

    local function EaseInExpo(p25: number) -- Line: 224
        return p25 == 0 and 0 or 2 ^ (p25 * 10 - 10);
    end;

    local v26 = p19.Magnitude < 100 and p19.Magnitude or 100;
    local math_min_ret = math.min(v26 == 0 and 0 or 2 ^ (v26 * 10 - 10), 100);
    local u27 = v20 * math.max(math_min_ret, 1);
    local u28;

    if v24 < 1 then
        u28 = v24 * math_min_ret;
    else
        local v29 = math_min_ret / 2;
        u28 = v24 * (v29 > 1 and v29 and v29 or 1);
    end;

    local v30 = nil;

    local function GetNoise(p31, p32, p33, p34) -- Line: 241
        local math_noise_ret = math.noise(p31, p32, p33);
        local math_clamp_ret = math.clamp(math_noise_ret, -1, 1);

        if p34 then
            math_clamp_ret = math_clamp_ret ^ 2;
        end;

        return math_clamp_ret;
    end;

    local function SampleGust() -- Line: 253
        -- upvalues: u27 (ref)
        return math.sin(u27 * 1) * 0.3 + 0.7;
    end;

    local function SampleSin() -- Line: 259
        -- upvalues: WindStrength (copy), u28 (ref), u27 (ref), WindDirection (copy)
        local v35 = WindStrength ^ 0.8;
        local v36 = u28 * 2;
        local math_sin_ret = math.sin(u27 * v35);
        local math_cos_ret = math.cos(u27 / 10 * v35);
        local math_sin_ret2 = math.sin(u27 * 2 * v35);
        local math_cos_ret2 = math.cos(u27 * 3 * v35);
        local v37 = (math_sin_ret + math_cos_ret + math_sin_ret2 + math_cos_ret2) / 4;
        local v38 = v37 * v36;
        local v39 = (v37 * 0.5 + 0.5) * v36;

        if v38 < v39 then
            v38 = v39 or v38;
        end;

        return WindDirection * v38;
    end;

    local function SampleNoise(p40, p41) -- Line: 277
        -- upvalues: WindStrength (copy), u28 (ref), u18 (copy), WindDirection (copy)
        local v42 = p40 or 0;
        local v43 = WindStrength ^ 0.8;
        local v44 = u28 * 2;
        local WindOffset = u18.WindOffset;
        local math_noise_ret = math.noise(v43, 0, WindOffset);
        local math_clamp_ret = math.clamp(math_noise_ret, -1, 1);

        if p41 then
            math_clamp_ret = math_clamp_ret ^ 2;
        end;

        local math_noise_ret2 = math.noise(0, v43, WindOffset);
        local math_clamp_ret2 = math.clamp(math_noise_ret2, -1, 1);

        if p41 then
            math_clamp_ret2 = math_clamp_ret2 ^ 2;
        end;

        local math_noise_ret3 = math.noise(WindOffset, 0, v43);
        local math_clamp_ret3 = math.clamp(math_noise_ret3, -1, 1);

        if p41 then
            math_clamp_ret3 = math_clamp_ret3 ^ 2;
        end;

        return WindDirection * Vector3.new(math_clamp_ret * (v44 + v42), math_clamp_ret2 * (v44 + v42), math_clamp_ret3 * (v44 + v42));
    end;

    if Settings.WindType == "Sine" then
        v30 = SampleSin() * (math.sin(u27 * 1) * 0.3 + 0.7);
    elseif Settings.WindType == "Noise" then
        v30 = SampleNoise(0, true) * (math.sin(u27 * 1) * 0.3 + 0.7);
    elseif Settings.WindType == "Hybrid" then
        v30 = (SampleSin() * (math.sin(u27 * 1) * 0.3 + 0.7) + SampleNoise(0.5, true) * (math.sin(u27 * 1) * 0.3 + 0.7)) * 0.5;
    end;

    return v30 / (p17.FreeLength < 0.01 and 0.01 or p17.FreeLength) * (Settings.WindInfluence * (WindStrength * 0.01) * (math.clamp(p17.HeirarchyLength, 1, 10) * 0.1)) * p17.Weight;
end;

local u45 = {};
u45.__index = u45;

function u45.new(u46: userdata, p47: userdata, p48: userdata) -- Line: 453
    -- upvalues: u45 (copy), Utilities (copy)
    local v49 = u46.Parent:IsA("Bone") and u46.Parent.TransformedWorldCFrame or p48.CFrame;
    local v50 = {
        Bone = u46,
        FreeLength = -1,
        Weight = 0.7,
        ParentIndex = -1,
        HeirarchyLength = 0,
        Transform = u46.TransformedWorldCFrame:ToObjectSpace(v49):Inverse(),
        LocalTransform = u46.TransformedCFrame:ToObjectSpace(p47.TransformedCFrame):Inverse(),
        RootPart = p48,
        RootBone = p47,
        Radius = 0,
        Friction = 0,
        RotationLimit = 0,
        Force = nil,
        Gravity = nil,
        SolvedAnimatedCFrame = false,
        HasChild = false,
        AnimatedWorldCFrame = u46.TransformedWorldCFrame,
        StartingCFrame = u46.TransformedCFrame,
        TransformOffset = CFrame.identity,
        LocalTransformOffset = CFrame.identity,
        RestPosition = Vector3.new(0, 0, 0),
        CalculatedWorldCFrame = u46.TransformedWorldCFrame,
        Position = u46.TransformedWorldCFrame.Position,
        LastPosition = u46.TransformedWorldCFrame.Position,
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
    local u51 = setmetatable(v50, u45);
    u51.AttributeConnection = u46.AttributeChanged:Connect(function(p52) -- Line: 506
        -- upvalues: Utilities (ref), u46 (copy), u51 (copy)
        for i, v in Utilities.GatherBoneSettings(u46) do
            local v53;

            if v == "¬" or not v then
                v53 = nil;
            else
                v53 = v;
            end;

            u51[i] = v53;
        end;
    end);
    u51.SmartWeld = u46:FindFirstChild("SmartWeld");
    u51.WeldAddedConnection = u46.ChildAdded:Connect(function(p54) -- Line: 519
        -- upvalues: u51 (copy)
        if p54.Name == "SmartWeld" then
            u51.SmartWeld = p54;
        end;
    end);
    u51.WeldRemovedConnection = u46.ChildRemoved:Connect(function(p55) -- Line: 524
        -- upvalues: u51 (copy), u46 (copy)
        if p55 == u51.SmartWeld then
            u51.SmartWeld = u46:FindFirstChild("SmartWeld");
        end;
    end);

    return u51;
end;

function u45.ClipVelocity(p56: table, p57: vector, p58: vector) -- Line: 537
    p56.LastPosition = p56.LastPosition * (Vector3.new(1, 1, 1) - p58) + p57 * p58;
end;

function u45.PreUpdate(p59, p60) -- Line: 543
    -- upvalues: QueryTransformedWorldCFrameNonSmartbone (copy), QueryTransformedWorldCFrame (copy)
    local v61 = p60.Bones[1];
    local v62 = p60.Bones[p59.ParentIndex];
    p59.SolvedAnimatedCFrame = true;
    local ParentIndex = p59.ParentIndex;
    local Bone = p59.Bone;
    local v63;

    if ParentIndex < 1 then
        v63 = QueryTransformedWorldCFrameNonSmartbone(Bone);
    else
        local v64 = p60.Bones[ParentIndex];

        if not v64.SolvedAnimatedCFrame then
            v64.AnimatedWorldCFrame = QueryTransformedWorldCFrame(p60, v64);
        end;

        v63 = v64.AnimatedWorldCFrame * Bone.TransformedCFrame;
    end;

    p59.AnimatedWorldCFrame = v63;
    local SmartWeld = p59.SmartWeld;
    p59.ActiveWeld = false;

    if SmartWeld and SmartWeld:IsA("ObjectValue") then
        local Value = SmartWeld.Value;
        p59.RigidWeld = SmartWeld:GetAttribute("Rigid") == true;

        if Value then
            if Value:IsA("Attachment") then
                p59.WeldPosition = Value.WorldPosition;
                p59.WeldCFrame = Value.WorldCFrame;
                p59.ActiveWeld = true;
            elseif Value:IsA("BasePart") then
                p59.WeldPosition = Value.Position;
                p59.WeldCFrame = Value.CFrame;
                p59.ActiveWeld = true;
            end;
        end;
    end;

    if p59.ParentIndex < 1 then
        p59.Anchored = true;
    end;

    if p59.Bone == p59.RootBone then
        local v65;

        if p59.Bone.Parent and p59.Bone.Parent:IsA("Bone") then
            v65 = QueryTransformedWorldCFrameNonSmartbone(p59.Bone.Parent);
        else
            if not p59.RootPart then
                return;
            end;

            v65 = p59.RootPart.CFrame;
        end;

        p59.TransformOffset = v65 * p59.Transform;
    else
        p59.TransformOffset = v62.AnimatedWorldCFrame * p59.Transform;
    end;

    p59.LocalTransformOffset = (p60.RootBoneCFrame or v61.Bone.CFrame) * p59.LocalTransform;
end;

function u45.StepPhysics(p66: table, p67: any, p68: vector, p69: number) -- Line: 608
    -- upvalues: SolveWind (copy)
    if p66.Anchored then
        p66.LastPosition = p66.AnimatedWorldCFrame.Position;
        p66.Position = p66.AnimatedWorldCFrame.Position;

        return;
    end;

    if p66.Force or p66.Gravity then
        p68 = (p66.Gravity or p67.Settings.Gravity) + (p66.Force or p67.Settings.Force);
    end;

    local Settings = p67.Settings;
    local v70 = (p66.Position - p66.LastPosition) / p69;

    if v70.Magnitude > 50 then
        v70 = v70.Unit * 50 or v70;
    end;

    local v71 = p67.ObjectAcceleration * Settings.Inertia;
    local v72 = SolveWind(p66, p67, v70);
    p66.LastPosition = p66.Position;
    p66.Position = p66.Position + (v70 * (1 - Settings.Damping) * p69 + (p68 + v71) * p69 * p69 + v72);
end;

function u45.Constrain(p73: table, p74: any, p75: any, p76: number) -- Line: 648
    -- upvalues: FrictionConstraint (copy), CollisionConstraint (copy), SpringConstraint (copy), DistanceConstraint (copy), RopeConstraint (copy), AxisConstraint (copy), RotationConstraint (copy)
    if p73.Anchored then
        return;
    end;

    local v77 = p74.RootPartCFrame or p73.RootPart.CFrame;
    local v78 = FrictionConstraint(p73, p73.Position, p73.LastPosition);

    if #p75 ~= 0 then
        v78 = CollisionConstraint(p73, v78, p75);
    end;

    local v79;

    if p74.Settings.Constraint == "Spring" then
        v79 = SpringConstraint(p73, v78, nil, p74, p76);
    elseif p74.Settings.Constraint == "Distance" then
        v79 = DistanceConstraint(p73, v78, p74);
    elseif p74.Settings.Constraint == "Rope" then
        v79 = RopeConstraint(p73, v78, p74);
    else
        v79 = p73.AnimatedWorldCFrame.Position;
    end;

    local v80 = RotationConstraint(p73, AxisConstraint(p73, v79, p73.LastPosition, v77, p74.RootPartCFrameInverse), p74);

    if p73.ActiveWeld then
        if p73.RigidWeld then
            v80 = p73.WeldPosition;
        else
            v80 = SpringConstraint(p73, v80, p73.WeldPosition, p74, p76);
        end;
    end;

    p73.Friction = 0;

    for _, v in p73.CollisionHits do
        local CurrentPhysicalProperties = p73.RootPart.CurrentPhysicalProperties;
        local CurrentPhysicalProperties2 = v.CurrentPhysicalProperties;
        local FrictionWeight = CurrentPhysicalProperties.FrictionWeight;
        local FrictionWeight2 = CurrentPhysicalProperties2.FrictionWeight;
        local v81 = (CurrentPhysicalProperties.Friction * FrictionWeight + CurrentPhysicalProperties2.Friction * FrictionWeight2) / (FrictionWeight + FrictionWeight2);

        if v81 < p73.Friction then
            v81 = p73.Friction or v81;
        end;

        p73.Friction = v81;
    end;

    p73.Position = v80;
end;

function u45.SkipUpdate(p82) -- Line: 703
    -- upvalues: Config (copy)
    if p82.IsSkippingUpdates == false and Config.RESET_TRANSFORM_ON_SKIP then
        p82.CalculatedWorldCFrame = p82.AnimatedWorldCFrame;
        p82.IsSkippingUpdates = true;
    end;

    p82.LastPosition = p82.AnimatedWorldCFrame.Position + (p82.LastPosition - p82.Position);
    p82.Position = p82.AnimatedWorldCFrame.Position;
end;

function u45.SolveTransform(p83: table, p84: any, p85: number) -- Line: 718
    -- upvalues: Utilities (copy), u3 (ref)
    if p83.ParentIndex < 1 then
        return;
    end;

    p83.IsSkippingUpdates = false;
    local v86 = p84.Bones[p83.ParentIndex];
    local Bone = v86.Bone;

    if v86 and Bone then
        local v87 = false;
        local X = p83.Position.X;
        local v88, v89;

        if X ~= X then
            v88 = p83.AnimatedWorldCFrame;
            v89 = v88.Position.X;

            if v89 ~= v89 then
                v88 = p83.RootPart.CFrame;
            end;

            p83.Position = v88.Position;
            p83.LastPosition = v88.Position;
            v87 = true;
        else
            local X2 = p83.LastPosition.X;

            if X2 ~= X2 then
                v88 = p83.AnimatedWorldCFrame;
                v89 = v88.Position.X;

                if v89 ~= v89 then
                    v88 = p83.RootPart.CFrame;
                end;

                p83.Position = v88.Position;
                p83.LastPosition = v88.Position;
                v87 = true;
            end;
        end;

        local TransformOffset = v86.TransformOffset;
        local v90 = Utilities.GetRotationBetween(TransformOffset.UpVector, p83.Position - v86.Position).Rotation * TransformOffset.Rotation;
        local math_min_ret = math.min(1 - 0.00001 ^ p85, 1);

        if v86.ActiveWeld and v86.RigidWeld then
            v86.CalculatedWorldCFrame = v86.WeldCFrame;
        else
            v86.CalculatedWorldCFrame = Bone.WorldCFrame:Lerp(CFrame.new(v86.Position) * v90, math_min_ret);
        end;

        local X2 = v86.CalculatedWorldCFrame.Position.X;

        if X2 ~= X2 then
            local AnimatedWorldCFrame = v86.AnimatedWorldCFrame;
            local X3 = AnimatedWorldCFrame.Position.X;

            if X3 ~= X3 then
                AnimatedWorldCFrame = p83.RootPart.CFrame;
            end;

            v86.CalculatedWorldCFrame = AnimatedWorldCFrame;
            v86.Position = AnimatedWorldCFrame.Position;
            v86.LastPosition = AnimatedWorldCFrame.Position;
            v87 = true;
        end;

        if v87 and os.clock() - u3 > 3 then
            u3 = os.clock();
            local Parent = p83.RootPart.Parent;
            warn((`[SmartBone] NaN bone on {Parent and Parent.Name or "?"}.{p83.RootPart.Name}, reset to rest pose (throttled)`));
        end;
    end;
end;

function u45.ApplyTransform(p91, p92) -- Line: 792
    p91.SolvedAnimatedCFrame = false;

    if p91.ParentIndex < 1 then
        return;
    end;

    local v93 = p92.Bones[p91.ParentIndex];
    local Bone = v93.Bone;

    if v93 and Bone then
        local v94;

        if v93.Anchored and not p92.Settings.AnchorsRotate then
            v94 = v93.TransformOffset;
        elseif v93.Anchored then
            v94 = CFrame.new(v93.Position) * v93.CalculatedWorldCFrame.Rotation;
        else
            v94 = v93.CalculatedWorldCFrame;
        end;

        local X = v94.Position.X;

        if X ~= X then
            Bone.CFrame = v93.StartingCFrame;

            return;
        end;

        Bone.WorldCFrame = v94;
    end;
end;

function u45.DrawDebug(p95: table, p96: any, p97: boolean, p98: boolean, p99: boolean, p100: boolean, p101: boolean) -- Line: 843
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
    local v102 = 1;
    local AnimatedWorldCFrame = p95.AnimatedWorldCFrame;
    local Position = AnimatedWorldCFrame.Position;
    local CFrame_new_ret = CFrame.new(p95.Position);
    local CFrame_new_ret2 = CFrame.new(p95.LastPosition);

    if p99 then
        Gizmo.PushProperty("AlwaysOnTop", false);
        Gizmo.PushProperty("Color3", Color3_fromRGB_ret);
        Gizmo.Sphere:Draw(CFrame_new_ret, p95.Radius, 10, 360);
        Gizmo.PushProperty("Color3", Color3_fromRGB_ret2);
        Gizmo.Sphere:Draw(CFrame_new_ret2, p95.Radius, 10, 360);
        Gizmo.PushProperty("Color3", Color3_fromRGB_ret3);
        Gizmo.Ray:Draw(p95.Position, p95.LastPosition);
    end;

    if p100 and not p95.Anchored then
        local v103 = p95.AxisLocked[1];
        local v104 = p95.AxisLocked[2];
        local v105 = p95.AxisLocked[3];
        local RootPart = p95.RootPart;
        local v106 = RootPart.CFrame:PointToObjectSpace(Position);
        local RightVector = RootPart.CFrame.RightVector;
        local UpVector = RootPart.CFrame.UpVector;
        local LookVector = RootPart.CFrame.LookVector;

        if not v103 then
            Gizmo.PushProperty("Color3", Color3_fromRGB_ret9);
            Gizmo.Arrow:Draw(Position - RightVector * 2, Position + RightVector * 2, 0.05, 0.15, 9);
            local v107 = p95.XAxisLimits.Max - v106.X;
            Gizmo.Plane:Draw(Position + RightVector * (p95.XAxisLimits.Min - v106.X), RightVector, Vector3.new(5, 5, 0));
            Gizmo.Plane:Draw(Position + RightVector * v107, RightVector, Vector3.new(5, 5, 0));
        end;

        if not v104 then
            Gizmo.PushProperty("Color3", Color3_fromRGB_ret10);
            Gizmo.Arrow:Draw(Position - UpVector * 2, Position + UpVector * 2, 0.05, 0.15, 9);
            local v108 = p95.YAxisLimits.Max - v106.Y;
            Gizmo.Plane:Draw(Position + UpVector * (p95.YAxisLimits.Min - v106.Y), UpVector, Vector3.new(5, 5, 0));
            Gizmo.Plane:Draw(Position + UpVector * v108, UpVector, Vector3.new(5, 5, 0));
        end;

        if not v105 then
            Gizmo.PushProperty("Color3", Color3_fromRGB_ret11);
            Gizmo.Arrow:Draw(Position - LookVector * 2, Position + LookVector * 2, 0.05, 0.15, 9);
            local v109 = p95.ZAxisLimits.Max - v106.Z;
            Gizmo.Plane:Draw(Position - LookVector * (p95.ZAxisLimits.Min - v106.Z), LookVector, Vector3.new(5, 5, 0));
            Gizmo.Plane:Draw(Position - LookVector * v109, LookVector, Vector3.new(5, 5, 0));
        end;
    end;

    if p98 then
        Gizmo.PushProperty("Color3", Color3_fromRGB_ret4);
        Gizmo.Sphere:Draw(AnimatedWorldCFrame, 0.08, 5, 360);
        Gizmo.PushProperty("Color3", Color3_fromRGB_ret5);
        Gizmo.VolumeArrow:Draw(Position, Position + AnimatedWorldCFrame.LookVector * 0.25, 0.005, 0.015, 0.05, true);
        Gizmo.PushProperty("Color3", Color3_fromRGB_ret6);
        Gizmo.VolumeArrow:Draw(Position, Position + AnimatedWorldCFrame.UpVector * 0.25, 0.005, 0.015, 0.05, true);
        Gizmo.PushProperty("Color3", Color3_fromRGB_ret7);
        Gizmo.VolumeArrow:Draw(Position, Position + AnimatedWorldCFrame.RightVector * 0.25, 0.005, 0.015, 0.05, true);
    end;

    if p97 and not p95.Anchored then
        for _, v in p95.CollisionsData do
            Gizmo.PushProperty("Color3", Color3_fromRGB_ret12);
            Gizmo.Sphere:Draw(CFrame.new(v.ClosestPoint), 0.08, 5, 360);
            Gizmo.PushProperty("Color3", Color3_fromRGB_ret13);
            Gizmo.Arrow:Draw(v.ClosestPoint, v.ClosestPoint + v.Normal * 0.5, 0.05, 0.15, 9);
        end;
    end;

    if p101 and (p95.RotationLimit < 180 and (p95.RotationLimit > 0 and (p95.ParentIndex > 0 and p95.HasChild))) then
        local v110 = 1;
        local v111;

        if p95.RotationLimit < 89.5 then
            local math_rad_ret = math.rad(p95.RotationLimit);
            v111 = v102 * math.tan(math_rad_ret);
        elseif p95.RotationLimit > 90 then
            local math_rad_ret = math.rad(180 - p95.RotationLimit);
            v111 = v102 * math.tan(math_rad_ret);
            v110 = -1;
        else
            v111 = 5;
            v102 = 0;
        end;

        local math_min_ret = math.min(v111, 5);
        local v112 = math_min_ret == 5 and 0 or v102;
        local v113 = (p95.Position - p96.Bones[p95.ParentIndex].Position).Unit * v110;
        local CFrame_lookAt_ret = CFrame.lookAt(Position + v113 * (v112 * 0.5), Position + -v113 * 500, AnimatedWorldCFrame.LookVector);
        Gizmo.PushProperty("Color3", Color3_fromRGB_ret8);
        Gizmo.Cone:Draw(CFrame_lookAt_ret, math_min_ret, v112, 8 + math_min_ret * 2);
    end;
end;

function u45.DrawOverlay(p114: table, p115: table) -- Line: 1034
    -- upvalues: Config (copy)
    p115.Text((`Bone: {p114.Bone.Name}`));

    if Config.DEBUG_OVERLAY_BONE_INFO or Config.DEBUG_OVERLAY_BONE_NUMERICS then
        p115.Text((`Free Length: {p114.FreeLength}`));
        p115.Text((`Weight: {p114.Weight}`));
        p115.Text((`Parent Index: {p114.ParentIndex}`));
        p115.Text((`Heirarchy Length: {p114.HeirarchyLength}`));
        p115.Text((`Radius: {p114.Radius}`));
        p115.Text((`Friction: {p114.Friction}`));
        p115.Text((`Rotation Limit: {p114.RotationLimit}`));
    end;

    if Config.DEBUG_OVERLAY_BONE_INFO or Config.DEBUG_OVERLAY_BONE_CONSTRAIN then
        p115.Text((`Anchored: {p114.Anchored}`));
        p115.Text((`Axis Locked: {p114.AxisLocked[1]}, {p114.AxisLocked[2]}, {p114.AxisLocked[3]}`));
        p115.Text((`X Axis Limit: {p114.XAxisLimits}`));
        p115.Text((`Y Axis Limit: {p114.YAxisLimits}`));
        p115.Text((`Z Axis Limit: {p114.ZAxisLimits}`));
    end;

    if Config.DEBUG_OVERLAY_BONE_INFO or Config.DEBUG_OVERLAY_BONE_WELD then
        p115.Text((`Active Weld: {p114.ActiveWeld}`));
        p115.Text((`Rigid Weld: {p114.RigidWeld}`));
        p115.Text((`Weld Position: {string.format("%.3f, %.3f, %.3f", p114.WeldPosition.X, p114.WeldPosition.Y, p114.WeldPosition.Z)}`));
    end;

    if Config.DEBUG_OVERLAY_BONE_INFO or Config.DEBUG_OVERLAY_BONE_FORCES then
        local v116 = p114.Force and (string.format("%.3f, %.3f, %.3f", p114.Force.X, p114.Force.Y, p114.Force.Z) or "-, -, -") or "-, -, -";
        local v117 = p114.Gravity and string.format("%.3f, %.3f, %.3f", p114.Gravity.X, p114.Gravity.Y, p114.Gravity.Z) or "-, -, -";
        p115.Text((`Force: {v116}`));
        p115.Text((`Gravity: {v117}`));
    end;
end;

function u45.Destroy(p118) -- Line: 1070
    -- upvalues: Config (copy)
    if Config.RESET_BONE_ON_DESTROY then
        task.synchronize();
        p118.Bone.CFrame = p118.StartingCFrame;
    end;

    p118.AttributeConnection:Disconnect();
    p118.WeldAddedConnection:Disconnect();
    p118.WeldRemovedConnection:Disconnect();
    setmetatable(p118, nil);
end;

return u45;
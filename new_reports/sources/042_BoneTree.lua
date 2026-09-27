-- Decompiled with Potassium's decompiler.

local Lighting = game:GetService("Lighting");
local Dependencies = script.Parent.Parent:WaitForChild("Dependencies");
require(script.Parent:WaitForChild("Bone"));
local Config = require(script.Parent.Parent:WaitForChild("Config"));
local DefaultObjectSettings = require(Dependencies:WaitForChild("DefaultObjectSettings"));
local Gizmo = require(Dependencies:WaitForChild("Debug"):WaitForChild("Gizmo"));
local Utilities = require(Dependencies:WaitForChild("Utilities"));
local Random_new_ret = Random.new(1029410295159813);
local SB_VERBOSE_LOG = Utilities.SB_VERBOSE_LOG;
local CollectionService = game:GetService("CollectionService");

local function SafeUnit(p1: vector) -- Line: 52
    return p1.Magnitude == 0 and Vector3.new(0, 0, 0) or p1.Unit;
end;

local function map(p2: number, p3: number, p4: number, p5: number, p6: number, p7: boolean) -- Line: 61
    local v8 = (p2 - p3) / (p4 - p3) * (p6 - p5) + p5;

    if not p7 then
        return v8;
    end;

    if p5 < p6 then
        if p5 < (v8 < p6 and v8 and v8 or p6) then
            p5 = v8 < p6 and v8 and v8 or (p6 or p5);
        end;

        return p5;
    end;

    if p6 < (v8 < p5 and v8 and v8 or p5) then
        p6 = v8 < p5 and v8 and v8 or (p5 or p6);
    end;

    return p6;
end;

local u9 = {};
u9.__index = u9;

function u9.new(p10: userdata, u11: userdata, u12: table) -- Line: 173
    -- upvalues: Random_new_ret (copy), u9 (copy), DefaultObjectSettings (copy), CollectionService (copy)
    local v13 = {
        UpdateRate = 0,
        InView = true,
        AccumulatedDelta = 0,
        Destroyed = false,
        IsSkippingUpdates = false,
        InWorkspace = false,
        Force = Vector3.new(0, 0, 0),
        ObjectMove = Vector3.new(0, 0, 0),
        ObjectVelocity = Vector3.new(0, 0, 0),
        ObjectAcceleration = Vector3.new(0, 0, 0),
        WindOffset = Random_new_ret:NextNumber(0, 1000000),
        Root = p10:IsA("Bone") and p10 and p10 or nil,
        RootPart = u11,
        RootPartSize = u11.Size,
        Bones = {},
        Settings = u12,
        BoundingBoxCFrame = u11.CFrame,
        BoundingBoxSize = u11.Size,
        ObjectPreviousPosition = u11.Position,
        DefaultRootOrientation = (p10:IsA("Bone") and p10.WorldCFrame or CFrame.identity).Rotation
    };
    local u14 = setmetatable(v13, u9);
    u14.InWorkspace = u11:IsDescendantOf(workspace);
    u14.DestroyConnection = u11.AncestryChanged:ConnectParallel(function() -- Line: 202
        -- upvalues: u11 (copy), u14 (copy)
        if not u11:IsDescendantOf(game) then
            u14.Destroyed = true;
        end;

        u14.InWorkspace = u11:IsDescendantOf(workspace);
    end);
    u14.AttributeConnection = u11.AttributeChanged:ConnectParallel(function(p15) -- Line: 210
        -- upvalues: u12 (copy), u11 (copy), DefaultObjectSettings (ref)
        u12[p15] = u11:GetAttribute(p15) or DefaultObjectSettings[p15];
    end);
    u14.TagConnection = CollectionService:GetInstanceRemovedSignal("SmartBone"):Connect(function(p16) -- Line: 215
        -- upvalues: u11 (copy), u14 (copy)
        if p16 ~= u11 then
            return;
        end;

        u14.Destroyed = true;
    end);

    return u14;
end;

function u9.UpdateBoundingBox(p17) -- Line: 250
    if not p17.InView then
        p17.BoundingBoxCFrame = p17.RootPart.CFrame;
        p17.BoundingBoxSize = p17.RootPart.Size;

        return;
    end;

    if #p17.Bones == 0 then
        p17.BoundingBoxCFrame = p17.RootPart.CFrame;
        p17.BoundingBoxSize = p17.RootPartSize;

        return;
    end;

    local v18 = Vector3.new(inf, inf, inf);
    local v19 = Vector3.new(-inf, -inf, -inf);

    for _, v in p17.Bones do
        local v20 = v.Position + (v.Position - v.LastPosition);
        v18 = v18:Min(v20);
        v19 = v19:Max(v20);
    end;

    p17.BoundingBoxCFrame = CFrame.new((v18 + v19) * 0.5);
    p17.BoundingBoxSize = p17.RootPartSize:Max(v19 - v18);
end;

function u9.UpdateThrottling(p21: table, p22: vector) -- Line: 295
    local Settings = p21.Settings;
    local Magnitude = (p22 - workspace.CurrentCamera.CFrame.Position).Magnitude;

    if Settings.ActivationDistance < Magnitude then
        p21.UpdateRate = 0;

        return;
    end;

    local ThrottleDistance = Settings.ThrottleDistance;
    local v23 = (Magnitude - ThrottleDistance) / (Settings.ActivationDistance - ThrottleDistance) * 1 + 0;
    p21.UpdateRate = Settings.UpdateRate * (1 - ((v23 < 1 and v23 and v23 or 1) > 0 and (v23 < 1 and v23 and v23 or 1) or 0));
end;

function u9.PreUpdate(p24: table, p25: number) -- Line: 316
    local Position = p24.RootPart.CFrame.Position;
    local ObjectVelocity = p24.ObjectVelocity;
    p24.ObjectMove = Position - p24.ObjectPreviousPosition;
    p24.ObjectVelocity = p24.ObjectMove;
    p24.ObjectAcceleration = ObjectVelocity - p24.ObjectVelocity;
    p24.ObjectPreviousPosition = Position;
    p24.RootPartSize = p24.RootPart.Size;
    p24:UpdateThrottling(Position);
    p24:UpdateBoundingBox();
    p24:UpdateWind();

    for _, v in p24.Bones do
        v:PreUpdate(p24);
    end;
end;

function u9.UpdateWind(p26) -- Line: 341
    -- upvalues: Lighting (copy), DefaultObjectSettings (copy)
    local Settings = p26.Settings;

    if Settings.MatchWorkspaceWind == true then
        local workspace_GlobalWind = workspace.GlobalWind;
        Settings.WindDirection = workspace_GlobalWind.Magnitude == 0 and Vector3.new(0, 0, 0) or workspace_GlobalWind.Unit;
        Settings.WindSpeed = workspace_GlobalWind.Magnitude;
    else
        local v27 = Lighting:GetAttribute("WindDirection") or DefaultObjectSettings.WindDirection;
        local v28 = Lighting:GetAttribute("WindSpeed") or DefaultObjectSettings.WindSpeed;
        Settings.WindDirection = v27.Magnitude == 0 and Vector3.new(0, 0, 0) or v27.Unit;
        Settings.WindSpeed = v28;
    end;

    Settings.WindStrength = Lighting:GetAttribute("WindStrength") or DefaultObjectSettings.WindStrength;
end;

function u9.StepPhysics(p29: table, p30: number) -- Line: 364
    local Settings = p29.Settings;
    local v31 = 1 - p29.DefaultRootOrientation:ToObjectSpace(p29.Root.WorldCFrame.Rotation).UpVector:Dot(Vector3.new(0, 1, 0));
    local math_clamp_ret = math.clamp(v31, 0, 1);
    local v32 = Settings.Gravity * math.lerp(1 - Settings.GravityFalloff, 1, math_clamp_ret) + Settings.Force;
    p29.Force = v32;

    for _, v in p29.Bones do
        v:StepPhysics(p29, v32, p30);
    end;
end;

function u9.Constrain(p33: table, p34: any, p35: number) -- Line: 393
    for _, v in p33.Bones do
        v:Constrain(p33, p34, p35);
    end;
end;

function u9.SkipUpdate(p36) -- Line: 403
    for _, v in p36.Bones do
        v:SkipUpdate();
    end;

    p36.IsSkippingUpdates = true;
end;

function u9.SolveTransform(p37: table, p38: number) -- Line: 415
    for _, v in p37.Bones do
        v:SolveTransform(p37, p38);
    end;

    p37.IsSkippingUpdates = false;
end;

function u9.ApplyTransform(p39) -- Line: 427
    for _, v in p39.Bones do
        v:ApplyTransform(p39);
    end;
end;

function u9.DrawDebug(p40: table, p41: boolean, p42: boolean, p43: boolean, p44: boolean, p45: boolean, p46: boolean, p47: boolean, p48: boolean) -- Line: 445
    -- upvalues: Gizmo (copy)
    local Color3_fromRGB_ret = Color3.fromRGB(248, 168, 20);
    local Color3_fromRGB_ret2 = Color3.fromRGB(76, 208, 223);
    local Color3_fromRGB_ret3 = Color3.fromRGB(255, 89, 89);
    local Color3_new_ret = Color3.new(1, 0, 0);
    local Color3_new_ret2 = Color3.new(0, 1, 0);
    local Color3_new_ret3 = Color3.new(0, 0, 1);

    if p48 then
        local v49 = p40.RootPart.Position + Vector3.new(0, p40.RootPart.Size.Y * 0.5 + 1, 0);
        Gizmo.SetStyle(Color3_new_ret, 0, true);
        Gizmo.Arrow:Draw(v49, v49 + p40.ObjectMove, 0.025, 0.1, 6);
        Gizmo.SetStyle(Color3_new_ret2, 0, true);
        Gizmo.Arrow:Draw(v49, v49 + p40.ObjectVelocity, 0.025, 0.1, 6);
        Gizmo.SetStyle(Color3_new_ret3, 0, true);
        Gizmo.Arrow:Draw(v49, v49 + p40.ObjectAcceleration, 0.025, 0.1, 6);
    end;

    Gizmo.PushProperty("AlwaysOnTop", false);

    if p46 then
        Gizmo.PushProperty("Color3", Color3_fromRGB_ret2);
        Gizmo.Box:Draw(p40.BoundingBoxCFrame, p40.BoundingBoxSize, true);
    end;

    if p45 then
        Gizmo.PushProperty("Color3", Color3_fromRGB_ret2);
        Gizmo.Box:Draw(p40.RootPart.CFrame, p40.RootPart.Size, true);
        Gizmo.SetStyle(Color3_fromRGB_ret3, 0.75, false);
        Gizmo.VolumeBox:Draw(p40.RootPart.CFrame, p40.RootPart.Size);
        Gizmo.PushProperty("Transparency", 0);
    end;

    for i, v in p40.Bones do
        local Position = v.Bone.TransformedWorldCFrame.Position;
        local v50 = p40.Bones[v.ParentIndex];
        v:DrawDebug(p40, p41, p42, p43, p44, p47);

        if p42 and i ~= 1 then
            Gizmo.PushProperty("Color3", Color3_fromRGB_ret);
            Gizmo.Ray:Draw(v50.Bone.TransformedWorldCFrame.Position, Position);
        end;
    end;
end;

function u9.DrawOverlay(p51: table, p52: table) -- Line: 510
    -- upvalues: Config (copy)
    if Config.DEBUG_OVERLAY_TREE_INFO or Config.DEBUG_OVERLAY_TREE_OBJECTS then
        p52.Text((`Root Part: {p51.RootPart.Name}`));
        p52.Text((`Root Bone: {p51.Root.Name}`));
        p52.Text((`Root Part Size: {string.format("%.3f, %.3f, %.3f", p51.RootPart.Size.X, p51.RootPart.Size.Y, p51.RootPart.Size.Z)}`));
    end;

    if Config.DEBUG_OVERLAY_TREE_INFO or Config.DEBUG_OVERLAY_TREE_NUMERICS then
        p52.Text((`Update Rate: {string.format("%.3f", p51.UpdateRate)}`));
        p52.Text((`In View: {p51.InView}`));
        p52.Text((`Accumulated Delta: {string.format("%.3f", p51.AccumulatedDelta)}`));
        p52.Text((`Force: {string.format("%.3f, %.3f, %.3f", p51.Force.X, p51.Force.Y, p51.Force.Z)}`));
    end;

    local Color3_new_ret = Color3.new(0.486275, 0.431373, 1);
    local Color3_new_ret2 = Color3.new(1, 1, 1);

    if Config.DEBUG_OVERLAY_BONE then
        for i, v in p51.Bones do
            if Config.DEBUG_OVERLAY_MAX_BONES > 0 and Config.DEBUG_OVERLAY_BONE_OFFSET + Config.DEBUG_OVERLAY_MAX_BONES <= i then
                break;
            end;

            if i >= Config.DEBUG_OVERLAY_BONE_OFFSET then
                p52.Begin(`Bone {i}`, Color3_new_ret, Color3_new_ret2);
                v:DrawOverlay(p52);
                p52.End();
            end;
        end;
    end;
end;

function u9.Destroy(p53) -- Line: 546
    -- upvalues: SB_VERBOSE_LOG (copy)
    SB_VERBOSE_LOG("Destroy BoneTree");
    p53.DestroyConnection:Disconnect();
    p53.AttributeConnection:Disconnect();
    p53.TagConnection:Disconnect();

    for _, v in p53.Bones do
        v:Destroy();
    end;

    setmetatable(p53, nil);
end;

return u9;
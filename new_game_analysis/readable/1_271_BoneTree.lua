-- Decompiled with Potassium's decompiler.

local Lighting = game:GetService("Lighting");
local Dependencies = script.Parent.Parent:WaitForChild("Dependencies");
require(script.Parent:WaitForChild("Bone"));
local Config = require(Dependencies:WaitForChild("Config"));
local DefaultObjectSettings = require(Dependencies:WaitForChild("DefaultObjectSettings"));
local Gizmo = require(Dependencies:WaitForChild("Debug"):WaitForChild("Gizmo"));
local Utilities = require(Dependencies:WaitForChild("Utilities"));
local Random_new_ret = Random.new(1029410295159813);
local SB_VERBOSE_LOG = Utilities.SB_VERBOSE_LOG;

local function SafeUnit(p1: vector) -- Line: 49
    return p1.Magnitude == 0 and Vector3.new(0, 0, 0) or p1.Unit;
end;

local function map(p2: number, p3: number, p4: number, p5: number, p6: number, p7: boolean) -- Line: 58
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

function u9.new(p10: userdata, u11: userdata, u12: table) -- Line: 166
    -- upvalues: Random_new_ret (copy), u9 (copy), DefaultObjectSettings (copy)
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
        ObjectPreviousPosition = u11.Position
    };
    local u14 = setmetatable(v13, u9);
    u14.InWorkspace = u11:IsDescendantOf(workspace);
    u14.DestroyConnection = u11.AncestryChanged:ConnectParallel(function() -- Line: 194
        -- upvalues: u11 (copy), u14 (copy)
        if not u11:IsDescendantOf(game) then
            u14.Destroyed = true;
        end;

        u14.InWorkspace = u11:IsDescendantOf(workspace);
    end);
    u14.AttributeConnection = u11.AttributeChanged:ConnectParallel(function(p15) -- Line: 202
        -- upvalues: u12 (copy), u11 (copy), DefaultObjectSettings (ref)
        u12[p15] = u11:GetAttribute(p15) or DefaultObjectSettings[p15];
    end);

    return u14;
end;

function u9.UpdateBoundingBox(p16) -- Line: 234
    if not p16.InView then
        p16.BoundingBoxCFrame = p16.RootPart.CFrame;
        p16.BoundingBoxSize = p16.RootPart.Size;

        return;
    end;

    local v17 = Vector3.new(inf, inf, inf);
    local v18 = Vector3.new(-inf, -inf, -inf);

    for _, v in p16.Bones do
        local v19 = v.Position + (v.Position - v.LastPosition);
        v17 = v17:Min(v19);
        v18 = v18:Max(v19);
    end;

    p16.BoundingBoxCFrame = CFrame.new((v17 + v18) * 0.5);
    p16.BoundingBoxSize = p16.RootPartSize:Max(v18 - v17);
end;

function u9.UpdateThrottling(p20: table, p21: vector) -- Line: 271
    local Settings = p20.Settings;
    local Magnitude = (p21 - workspace.CurrentCamera.CFrame.Position).Magnitude;

    if Settings.ActivationDistance < Magnitude then
        p20.UpdateRate = 0;

        return;
    end;

    local ThrottleDistance = Settings.ThrottleDistance;
    local v22 = (Magnitude - ThrottleDistance) / (Settings.ActivationDistance - ThrottleDistance) * 1 + 0;
    p20.UpdateRate = Settings.UpdateRate * (1 - ((v22 < 1 and v22 and v22 or 1) > 0 and (v22 < 1 and v22 and v22 or 1) or 0));
end;

function u9.PreUpdate(p23: table, p24: number) -- Line: 292
    -- upvalues: Config (copy)
    local CFrame2 = p23.RootPart.CFrame;
    local Position = CFrame2.Position;
    local ObjectVelocity = p23.ObjectVelocity;
    p23.ObjectMove = Position - p23.ObjectPreviousPosition;
    p23.ObjectVelocity = p23.ObjectMove;
    p23.ObjectAcceleration = ObjectVelocity - p23.ObjectVelocity;
    p23.ObjectPreviousPosition = Position;
    p23.RootPartSize = p23.RootPart.Size;
    p23:UpdateThrottling(Position);
    local v25 = not p23.InView or (math.floor(p23.UpdateRate) == 0 and true or not p23.InWorkspace);

    if v25 and p23.IsSkippingUpdates then
        p23.BoundingBoxCFrame = CFrame2;
        p23.BoundingBoxSize = p23.RootPartSize;

        return;
    end;

    p23.RootPartCFrame = CFrame2;
    p23.RootBoneCFrame = p23.Root.CFrame;

    for _, v in p23.Bones do
        v:PreUpdate(p23);
    end;

    if not v25 and p23.IsSkippingUpdates then
        for _, v in p23.Bones do
            v:SkipUpdate();
        end;
    end;

    if ((shared.FrameCounter or 0) + 1) % Config.FRUSTUM_FREQ == 0 then
        p23:UpdateBoundingBox();
    end;
end;

function u9.StepPhysics(p26: table, p27: number) -- Line: 347
    -- upvalues: Lighting (copy), DefaultObjectSettings (copy)
    local Settings = p26.Settings;
    local v28 = Settings.Gravity + Settings.Force;

    if Settings.MatchWorkspaceWind == true then
        local workspace_GlobalWind = workspace.GlobalWind;
        Settings.WindDirection = workspace_GlobalWind.Magnitude == 0 and Vector3.new(0, 0, 0) or workspace_GlobalWind.Unit;
        Settings.WindSpeed = workspace_GlobalWind.Magnitude;
    else
        local v29 = Lighting:GetAttribute("WindDirection") or DefaultObjectSettings.WindDirection;
        local v30 = Lighting:GetAttribute("WindSpeed") or DefaultObjectSettings.WindSpeed;
        Settings.WindDirection = v29.Magnitude == 0 and Vector3.new(0, 0, 0) or v29.Unit;
        Settings.WindSpeed = v30;
    end;

    Settings.WindStrength = Lighting:GetAttribute("WindStrength") or DefaultObjectSettings.WindStrength;

    for _, v in p26.Bones do
        v:StepPhysics(p26, v28, p27);
    end;
end;

function u9.Constrain(p31: table, p32: any, p33: number) -- Line: 377
    p31.RootPartCFrameInverse = (p31.RootPartCFrame or p31.RootPart.CFrame):Inverse();

    for _, v in p31.Bones do
        v:Constrain(p31, p32, p33);
    end;
end;

function u9.SkipUpdate(p34) -- Line: 389
    if p34.IsSkippingUpdates then
        return;
    end;

    for _, v in p34.Bones do
        v:SkipUpdate();
    end;

    p34.IsSkippingUpdates = true;
end;

function u9.SolveTransform(p35: table, p36: number) -- Line: 405
    for _, v in p35.Bones do
        v:SolveTransform(p35, p36);
    end;

    p35.IsSkippingUpdates = false;
end;

function u9.ApplyTransform(p37) -- Line: 417
    for _, v in p37.Bones do
        v:ApplyTransform(p37);
    end;
end;

function u9.DrawDebug(p38: table, p39: boolean, p40: boolean, p41: boolean, p42: boolean, p43: boolean, p44: boolean, p45: boolean, p46: boolean) -- Line: 435
    -- upvalues: Gizmo (copy)
    local Color3_fromRGB_ret = Color3.fromRGB(248, 168, 20);
    local Color3_fromRGB_ret2 = Color3.fromRGB(76, 208, 223);
    local Color3_fromRGB_ret3 = Color3.fromRGB(255, 89, 89);
    local Color3_new_ret = Color3.new(1, 0, 0);
    local Color3_new_ret2 = Color3.new(0, 1, 0);
    local Color3_new_ret3 = Color3.new(0, 0, 1);

    if p46 then
        local v47 = p38.RootPart.Position + Vector3.new(0, p38.RootPart.Size.Y * 0.5 + 1, 0);
        Gizmo.SetStyle(Color3_new_ret, 0, true);
        Gizmo.Arrow:Draw(v47, v47 + p38.ObjectMove, 0.025, 0.1, 6);
        Gizmo.SetStyle(Color3_new_ret2, 0, true);
        Gizmo.Arrow:Draw(v47, v47 + p38.ObjectVelocity, 0.025, 0.1, 6);
        Gizmo.SetStyle(Color3_new_ret3, 0, true);
        Gizmo.Arrow:Draw(v47, v47 + p38.ObjectAcceleration, 0.025, 0.1, 6);
    end;

    Gizmo.PushProperty("AlwaysOnTop", false);

    if p44 then
        Gizmo.PushProperty("Color3", Color3_fromRGB_ret2);
        Gizmo.Box:Draw(p38.BoundingBoxCFrame, p38.BoundingBoxSize, true);
    end;

    if p43 then
        Gizmo.PushProperty("Color3", Color3_fromRGB_ret2);
        Gizmo.Box:Draw(p38.RootPart.CFrame, p38.RootPart.Size, true);
        Gizmo.SetStyle(Color3_fromRGB_ret3, 0.75, false);
        Gizmo.VolumeBox:Draw(p38.RootPart.CFrame, p38.RootPart.Size);
        Gizmo.PushProperty("Transparency", 0);
    end;

    for i, v in p38.Bones do
        local Position = v.Bone.TransformedWorldCFrame.Position;
        local v48 = p38.Bones[v.ParentIndex];
        v:DrawDebug(p38, p39, p40, p41, p42, p45);

        if p40 and i ~= 1 then
            Gizmo.PushProperty("Color3", Color3_fromRGB_ret);
            Gizmo.Ray:Draw(v48.Bone.TransformedWorldCFrame.Position, Position);
        end;
    end;
end;

function u9.DrawOverlay(p49: table, p50: table) -- Line: 500
    -- upvalues: Config (copy)
    if Config.DEBUG_OVERLAY_TREE_INFO or Config.DEBUG_OVERLAY_TREE_OBJECTS then
        p50.Text((`Root Part: {p49.RootPart.Name}`));
        p50.Text((`Root Bone: {p49.Root.Name}`));
        p50.Text((`Root Part Size: {string.format("%.3f, %.3f, %.3f", p49.RootPart.Size.X, p49.RootPart.Size.Y, p49.RootPart.Size.Z)}`));
    end;

    if Config.DEBUG_OVERLAY_TREE_INFO or Config.DEBUG_OVERLAY_TREE_NUMERICS then
        p50.Text((`Update Rate: {string.format("%.3f", p49.UpdateRate)}`));
        p50.Text((`In View: {p49.InView}`));
        p50.Text((`Accumulated Delta: {string.format("%.3f", p49.AccumulatedDelta)}`));
        p50.Text((`Force: {string.format("%.3f, %.3f, %.3f", p49.Force.X, p49.Force.Y, p49.Force.Z)}`));
    end;

    local Color3_new_ret = Color3.new(0.486275, 0.431373, 1);
    local Color3_new_ret2 = Color3.new(1, 1, 1);

    if Config.DEBUG_OVERLAY_BONE then
        for i, v in p49.Bones do
            if Config.DEBUG_OVERLAY_MAX_BONES > 0 and Config.DEBUG_OVERLAY_BONE_OFFSET + Config.DEBUG_OVERLAY_MAX_BONES <= i then
                break;
            end;

            if i >= Config.DEBUG_OVERLAY_BONE_OFFSET then
                p50.Begin(`Bone {i}`, Color3_new_ret, Color3_new_ret2);
                v:DrawOverlay(p50);
                p50.End();
            end;
        end;
    end;
end;

function u9.Destroy(p51) -- Line: 536
    -- upvalues: SB_VERBOSE_LOG (copy)
    SB_VERBOSE_LOG("Destroy BoneTree");
    task.synchronize();
    p51.DestroyConnection:Disconnect();
    p51.AttributeConnection:Disconnect();

    for _, v in p51.Bones do
        v:Destroy();
    end;

    setmetatable(p51, nil);
    task.desynchronize();
end;

return u9;
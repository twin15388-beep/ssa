-- Decompiled with Potassium's decompiler.

local u1 = { 0, 15, 30 };
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local BaseCamera = require(script.Parent:WaitForChild("BaseCamera"));
local CameraInput = require(script.Parent:WaitForChild("CameraInput"));
local CameraUtils = require(script.Parent:WaitForChild("CameraUtils"));
require(script.Parent:WaitForChild("ZoomController"));
local VehicleCameraCore = require(script:WaitForChild("VehicleCameraCore"));
local VehicleCameraConfig = require(script:WaitForChild("VehicleCameraConfig"));
local LocalPlayer = Players.LocalPlayer;
local _ = CameraUtils.map;
local Spring = CameraUtils.Spring;
local mapClamp = CameraUtils.mapClamp;
local sanitizeAngle = CameraUtils.sanitizeAngle;

local function pitchVelocity(p2, p3) -- Line: 31
    local v4 = p3.XVector:Dot(p2);

    return math.abs(v4);
end;

local function yawVelocity(p5, p6) -- Line: 36
    local v7 = p6.YVector:Dot(p5);

    return math.abs(v7);
end;

local u8 = 0.016666666666666666;
RunService.Stepped:Connect(function(p9, p10) -- Line: 42
    -- upvalues: u8 (ref)
    u8 = p10;
end);
local u11 = setmetatable({}, BaseCamera);
u11.__index = u11;

function u11.new() -- Line: 49
    -- upvalues: BaseCamera (copy), u11 (copy)
    local v12 = BaseCamera.new();
    local v13 = setmetatable(v12, u11);
    v13:Reset();

    return v13;
end;

function u11.Reset(p14) -- Line: 55
    -- upvalues: VehicleCameraCore (copy), Spring (copy), VehicleCameraConfig (copy), CameraUtils (copy), u1 (copy)
    p14.vehicleCameraCore = VehicleCameraCore.new(p14:GetSubjectCFrame());
    p14.pitchSpring = Spring.new(0, -math.rad(VehicleCameraConfig.pitchBaseAngle));
    p14.yawSpring = Spring.new(0, 0);
    p14.lastPanTick = 0;
    local workspace_CurrentCamera = workspace.CurrentCamera;
    local v15;

    if workspace_CurrentCamera then
        v15 = workspace_CurrentCamera.CameraSubject;
    else
        v15 = workspace_CurrentCamera;
    end;

    assert(workspace_CurrentCamera);
    assert(v15);
    assert(v15:IsA("VehicleSeat"));
    local ConnectedParts = v15:GetConnectedParts(true);
    local LooseBoundingSphere, v16 = CameraUtils.getLooseBoundingSphere(ConnectedParts);
    p14.assemblyRadius = math.max(v16, 5);
    p14.assemblyOffset = v15.CFrame:Inverse() * LooseBoundingSphere;
    p14.gamepadZoomLevels = {};

    for _, v in u1 do
        table.insert(p14.gamepadZoomLevels, v * p14.assemblyRadius / 10);
    end;

    p14:SetCameraToSubjectDistance(p14.gamepadZoomLevels[#p14.gamepadZoomLevels]);
end;

function u11._StepRotation(p17, p18, p19) -- Line: 85
    -- upvalues: CameraInput (copy), sanitizeAngle (copy), VehicleCameraConfig (copy), mapClamp (copy)
    local yawSpring = p17.yawSpring;
    local pitchSpring = p17.pitchSpring;
    local Rotation = CameraInput.getRotation(p18);
    local v20 = -Rotation.Y;
    yawSpring.pos = sanitizeAngle(yawSpring.pos + -Rotation.X);
    pitchSpring.pos = sanitizeAngle((math.clamp(pitchSpring.pos + v20, -1.3962634015954636, 1.3962634015954636)));

    if CameraInput.getRotationActivated() then
        p17.lastPanTick = os.clock();
    end;

    local v21 = -math.rad(VehicleCameraConfig.pitchBaseAngle);
    local math_rad_ret = math.rad(VehicleCameraConfig.pitchDeadzoneAngle);

    if os.clock() - p17.lastPanTick > VehicleCameraConfig.autocorrectDelay then
        local v22 = mapClamp(p19, VehicleCameraConfig.autocorrectMinCarSpeed, VehicleCameraConfig.autocorrectMaxCarSpeed, 0, VehicleCameraConfig.autocorrectResponse);
        yawSpring.freq = v22;
        pitchSpring.freq = v22;

        if yawSpring.freq < 0.001 then
            yawSpring.vel = 0;
        end;

        if pitchSpring.freq < 0.001 then
            pitchSpring.vel = 0;
        end;

        local v23 = sanitizeAngle(v21 - pitchSpring.pos);

        if math.abs(v23) <= math_rad_ret then
            pitchSpring.goal = pitchSpring.pos;
        else
            pitchSpring.goal = v21;
        end;
    else
        yawSpring.freq = 0;
        yawSpring.vel = 0;
        pitchSpring.freq = 0;
        pitchSpring.vel = 0;
        pitchSpring.goal = v21;
    end;

    return CFrame.fromEulerAnglesYXZ(pitchSpring:step(p18), yawSpring:step(p18), 0);
end;

function u11._GetThirdPersonLocalOffset(p24) -- Line: 148
    -- upvalues: VehicleCameraConfig (copy)
    return p24.assemblyOffset + Vector3.new(0, p24.assemblyRadius * VehicleCameraConfig.verticalCenterOffset, 0);
end;

function u11._GetFirstPersonLocalOffset(p25: table, p26) -- Line: 152
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if Character and Character.Parent then
        local Head = Character:FindFirstChild("Head");

        if Head and Head:IsA("BasePart") then
            return p26:Inverse() * Head.Position;
        end;
    end;

    return p25:_GetThirdPersonLocalOffset();
end;

function u11.Update(p27) -- Line: 166
    -- upvalues: u8 (ref), mapClamp (copy)
    local workspace_CurrentCamera = workspace.CurrentCamera;
    local v28;

    if workspace_CurrentCamera then
        v28 = workspace_CurrentCamera.CameraSubject;
    else
        v28 = workspace_CurrentCamera;
    end;

    local vehicleCameraCore = p27.vehicleCameraCore;
    assert(workspace_CurrentCamera);
    assert(v28);
    assert(v28:IsA("VehicleSeat"));
    local v29 = u8;
    u8 = 0;
    local SubjectCFrame = p27:GetSubjectCFrame();
    local SubjectVelocity = p27:GetSubjectVelocity();
    local SubjectRotVelocity = p27:GetSubjectRotVelocity();
    local v30 = SubjectVelocity:Dot(SubjectCFrame.ZVector);
    local math_abs_ret = math.abs(v30);
    local v31 = SubjectCFrame.YVector:Dot(SubjectRotVelocity);
    local math_abs_ret2 = math.abs(v31);
    local v32 = SubjectCFrame.XVector:Dot(SubjectRotVelocity);
    local math_abs_ret3 = math.abs(v32);
    local v33 = p27:StepZoom(v29);
    local v34 = p27:_StepRotation(v29, math_abs_ret);
    local v35 = mapClamp(v33, 0.5, p27.assemblyRadius, 1, 0);
    local v36 = p27:_GetThirdPersonLocalOffset():Lerp(p27:_GetFirstPersonLocalOffset(SubjectCFrame), v35);
    vehicleCameraCore:setTransform(SubjectCFrame);
    local v37 = vehicleCameraCore:step(v29, math_abs_ret3, math_abs_ret2, v35);
    local v38 = CFrame.new(SubjectCFrame * v36) * v37 * v34;

    return v38 * CFrame.new(0, 0, v33), v38;
end;

return u11;
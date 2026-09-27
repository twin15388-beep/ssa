-- Decompiled with Potassium's decompiler.

local UserFlag = require(script.Parent.Parent:WaitForChild("CommonUtils")).get("FlagUtil").getUserFlag("UserFixOrbitalCameraAzimuth");
require(script.Parent:WaitForChild("CameraUtils"));
local CameraInput = require(script.Parent:WaitForChild("CameraInput"));
local Players = game:GetService("Players");
local BaseCamera = require(script.Parent:WaitForChild("BaseCamera"));
local u1 = setmetatable({}, BaseCamera);
u1.__index = u1;

function u1.new() -- Line: 33
    -- upvalues: BaseCamera (copy), u1 (copy)
    local v2 = BaseCamera.new();
    local v3 = setmetatable(v2, u1);
    v3.lastUpdate = tick();
    v3.changedSignalConnections = {};
    v3.refAzimuthRad = nil;
    v3.curAzimuthRad = nil;
    v3.minAzimuthAbsoluteRad = nil;
    v3.maxAzimuthAbsoluteRad = nil;
    v3.useAzimuthLimits = nil;
    v3.curElevationRad = nil;
    v3.minElevationRad = nil;
    v3.maxElevationRad = nil;
    v3.curDistance = nil;
    v3.minDistance = nil;
    v3.maxDistance = nil;
    v3.gamepadDollySpeedMultiplier = 1;
    v3.lastUserPanCamera = tick();
    v3.externalProperties = {};
    v3.externalProperties.InitialDistance = 25;
    v3.externalProperties.MinDistance = 10;
    v3.externalProperties.MaxDistance = 100;
    v3.externalProperties.InitialElevation = 35;
    v3.externalProperties.MinElevation = 35;
    v3.externalProperties.MaxElevation = 35;
    v3.externalProperties.ReferenceAzimuth = -45;
    v3.externalProperties.CWAzimuthTravel = 90;
    v3.externalProperties.CCWAzimuthTravel = 90;
    v3.externalProperties.UseAzimuthLimits = false;
    v3:LoadNumberValueParameters();

    return v3;
end;

function u1.LoadOrCreateNumberValueParameter(u4: table, u5: string, p6: any, u7: any) -- Line: 72
    local v8 = script:FindFirstChild(u5);

    if v8 and v8:IsA(p6) then
        u4.externalProperties[u5] = v8.Value;
    else
        if u4.externalProperties[u5] == nil then
            return;
        end;

        v8 = Instance.new(p6);
        v8.Name = u5;
        v8.Parent = script;
        v8.Value = u4.externalProperties[u5];
    end;

    if u7 then
        if u4.changedSignalConnections[u5] then
            u4.changedSignalConnections[u5]:Disconnect();
        end;

        u4.changedSignalConnections[u5] = v8.Changed:Connect(function(p9) -- Line: 92
            -- upvalues: u4 (copy), u5 (copy), u7 (copy)
            u4.externalProperties[u5] = p9;
            u7(u4);
        end);
    end;
end;

function u1.SetAndBoundsCheckAzimuthValues(p10) -- Line: 99
    local math_rad_ret = math.rad(p10.externalProperties.ReferenceAzimuth);
    local math_rad_ret2 = math.rad(p10.externalProperties.CWAzimuthTravel);
    p10.minAzimuthAbsoluteRad = math_rad_ret - math.abs(math_rad_ret2);
    local math_rad_ret3 = math.rad(p10.externalProperties.ReferenceAzimuth);
    local math_rad_ret4 = math.rad(p10.externalProperties.CCWAzimuthTravel);
    p10.maxAzimuthAbsoluteRad = math_rad_ret3 + math.abs(math_rad_ret4);
    p10.useAzimuthLimits = p10.externalProperties.UseAzimuthLimits;

    if p10.useAzimuthLimits then
        p10.curAzimuthRad = math.max(p10.curAzimuthRad, p10.minAzimuthAbsoluteRad);
        p10.curAzimuthRad = math.min(p10.curAzimuthRad, p10.maxAzimuthAbsoluteRad);
    end;
end;

function u1.SetAndBoundsCheckElevationValues(p11) -- Line: 109
    local math_max_ret = math.max(p11.externalProperties.MinElevation, -80);
    local math_min_ret = math.min(p11.externalProperties.MaxElevation, 80);
    local math_min_ret2 = math.min(math_max_ret, math_min_ret);
    p11.minElevationRad = math.rad(math_min_ret2);
    local math_max_ret2 = math.max(math_max_ret, math_min_ret);
    p11.maxElevationRad = math.rad(math_max_ret2);
    p11.curElevationRad = math.max(p11.curElevationRad, p11.minElevationRad);
    p11.curElevationRad = math.min(p11.curElevationRad, p11.maxElevationRad);
end;

function u1.SetAndBoundsCheckDistanceValues(p12) -- Line: 125
    p12.minDistance = p12.externalProperties.MinDistance;
    p12.maxDistance = p12.externalProperties.MaxDistance;
    p12.curDistance = math.max(p12.curDistance, p12.minDistance);
    p12.curDistance = math.min(p12.curDistance, p12.maxDistance);
end;

function u1.LoadNumberValueParameters(p13) -- Line: 133
    -- upvalues: UserFlag (copy)
    p13:LoadOrCreateNumberValueParameter("InitialElevation", "NumberValue", nil);
    p13:LoadOrCreateNumberValueParameter("InitialDistance", "NumberValue", nil);
    local v14;

    if UserFlag then
        v14 = p13.SetAndBoundsCheckAzimuthValues;
    else
        v14 = p13.SetAndBoundsCheckAzimuthValue;
    end;

    p13:LoadOrCreateNumberValueParameter("ReferenceAzimuth", "NumberValue", v14);
    p13:LoadOrCreateNumberValueParameter("CWAzimuthTravel", "NumberValue", p13.SetAndBoundsCheckAzimuthValues);
    p13:LoadOrCreateNumberValueParameter("CCWAzimuthTravel", "NumberValue", p13.SetAndBoundsCheckAzimuthValues);
    p13:LoadOrCreateNumberValueParameter("MinElevation", "NumberValue", p13.SetAndBoundsCheckElevationValues);
    p13:LoadOrCreateNumberValueParameter("MaxElevation", "NumberValue", p13.SetAndBoundsCheckElevationValues);
    p13:LoadOrCreateNumberValueParameter("MinDistance", "NumberValue", p13.SetAndBoundsCheckDistanceValues);
    p13:LoadOrCreateNumberValueParameter("MaxDistance", "NumberValue", p13.SetAndBoundsCheckDistanceValues);
    p13:LoadOrCreateNumberValueParameter("UseAzimuthLimits", "BoolValue", p13.SetAndBoundsCheckAzimuthValues);
    p13.curAzimuthRad = math.rad(p13.externalProperties.ReferenceAzimuth);
    p13.curElevationRad = math.rad(p13.externalProperties.InitialElevation);
    p13.curDistance = p13.externalProperties.InitialDistance;
    p13:SetAndBoundsCheckAzimuthValues();
    p13:SetAndBoundsCheckElevationValues();
    p13:SetAndBoundsCheckDistanceValues();
end;

function u1.GetModuleName(p15) -- Line: 159
    return "OrbitalCamera";
end;

function u1.GetCameraToSubjectDistance(p16) -- Line: 164
    return p16.curDistance;
end;

function u1.SetCameraToSubjectDistance(p17, p18) -- Line: 168
    -- upvalues: Players (copy)
    if Players.LocalPlayer then
        p17.currentSubjectDistance = math.clamp(p18, p17.minDistance, p17.maxDistance);
        p17.currentSubjectDistance = math.max(p17.currentSubjectDistance, p17.FIRST_PERSON_DISTANCE_THRESHOLD);
    end;

    p17.inFirstPerson = false;
    p17:UpdateMouseBehavior();

    return p17.currentSubjectDistance;
end;

function u1.CalculateNewLookVector(p19: table, p20: vector, p21) -- Line: 181
    local v22 = p20 or p19:GetCameraLookVector();
    local math_asin_ret = math.asin(v22.Y);
    local math_clamp_ret = math.clamp(p21.Y, math_asin_ret - 1.3962634015954636, math_asin_ret - -1.3962634015954636);
    local Vector2_new_ret = Vector2.new(p21.X, math_clamp_ret);
    local CFrame_new_ret = CFrame.new(Vector3.new(0, 0, 0), v22);

    return (CFrame.Angles(0, -Vector2_new_ret.X, 0) * CFrame_new_ret * CFrame.Angles(-Vector2_new_ret.Y, 0, 0)).LookVector;
end;

function u1.Update(p23: table, p24: number) -- Line: 192
    -- upvalues: CameraInput (copy), Players (copy)
    local v25 = tick();
    local v26 = v25 - p23.lastUpdate;
    local v27 = CameraInput.getRotation(p24) ~= Vector2.new();
    local workspace_CurrentCamera = workspace.CurrentCamera;
    local CFrame2 = workspace_CurrentCamera.CFrame;
    local Focus = workspace_CurrentCamera.Focus;
    local LocalPlayer = Players.LocalPlayer;
    local v28;

    if workspace_CurrentCamera then
        v28 = workspace_CurrentCamera.CameraSubject;
    else
        v28 = workspace_CurrentCamera;
    end;

    local v29;

    if v28 then
        v29 = v28:IsA("VehicleSeat");
    else
        v29 = v28;
    end;

    local v30;

    if v28 then
        v30 = v28:IsA("SkateboardPlatform");
    else
        v30 = v28;
    end;

    if p23.lastUpdate == nil or v26 > 1 then
        p23.lastCameraTransform = nil;
    end;

    if v27 then
        p23.lastUserPanCamera = tick();
    end;

    local SubjectPosition = p23:GetSubjectPosition();

    if SubjectPosition and (LocalPlayer and workspace_CurrentCamera) then
        if p23.gamepadDollySpeedMultiplier ~= 1 then
            p23:SetCameraToSubjectDistance(p23.currentSubjectDistance * p23.gamepadDollySpeedMultiplier);
        end;

        Focus = CFrame.new(SubjectPosition);
        local Rotation = CameraInput.getRotation(p24);
        p23.curAzimuthRad = p23.curAzimuthRad - Rotation.X;

        if p23.useAzimuthLimits then
            p23.curAzimuthRad = math.clamp(p23.curAzimuthRad, p23.minAzimuthAbsoluteRad, p23.maxAzimuthAbsoluteRad);
        else
            p23.curAzimuthRad = p23.curAzimuthRad == 0 and 0 or (math.sign(p23.curAzimuthRad) * (math.abs(p23.curAzimuthRad) % 6.283185307179586) or 0);
        end;

        p23.curElevationRad = math.clamp(p23.curElevationRad + Rotation.Y, p23.minElevationRad, p23.maxElevationRad);
        local v31 = SubjectPosition + p23.currentSubjectDistance * (CFrame.fromEulerAnglesYXZ(-p23.curElevationRad, p23.curAzimuthRad, 0) * Vector3.new(0, 0, 1));
        CFrame2 = CFrame.new(v31, SubjectPosition);
        p23.lastCameraTransform = CFrame2;
        p23.lastCameraFocus = Focus;

        if (v29 or v30) and v28:IsA("BasePart") then
            p23.lastSubjectCFrame = v28.CFrame;
        else
            p23.lastSubjectCFrame = nil;
        end;
    end;

    p23.lastUpdate = v25;

    return CFrame2, Focus;
end;

return u1;
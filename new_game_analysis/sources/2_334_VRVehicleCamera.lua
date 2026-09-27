-- Decompiled with Potassium's decompiler.

local u1 = { 0, 30 };
local VRBaseCamera = require(script.Parent:WaitForChild("VRBaseCamera"));
local CameraUtils = require(script.Parent:WaitForChild("CameraUtils"));
local CameraInput = require(script.Parent:WaitForChild("CameraInput"));
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local VRService = game:GetService("VRService");
local Lighting = game:GetService("Lighting");
local LocalPlayer = Players.LocalPlayer;
local mapClamp = CameraUtils.mapClamp;
local VehicleCameraConfig = require(script.Parent:WaitForChild("VehicleCamera"):FindFirstChild("VehicleCameraConfig"));
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
RaycastParams_new_ret.IgnoreWater = true;

local function yawVelocity(p2: vector, p3) -- Line: 36
    local v4 = p3.YVector:Dot(p2);

    return math.abs(v4);
end;

local function computeCameraCFrame(p5, p6: vector, p7: number) -- Line: 40
    local math_atan2_ret = math.atan2(p6.X, p6.Z);

    return CFrame.new(p5.Position + p6 * p7) * CFrame.Angles(0, math_atan2_ret, 0);
end;

local function vrOccludeDisplace(p8, p9: vector, p10: number, p11: userdata?) -- Line: 45
    -- upvalues: LocalPlayer (copy), RaycastParams_new_ret (copy)
    local math_atan2_ret = math.atan2(p9.X, p9.Z);
    local v12 = CFrame.new(p8.Position + p9 * p10) * CFrame.Angles(0, math_atan2_ret, 0);
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if not workspace_CurrentCamera then
        return v12;
    end;

    local Position = p8.Position;
    local v13 = (v12.Position - Position) * Vector3.new(1, 0, 1);
    local Magnitude = v13.Magnitude;

    if Magnitude < 0.5 then
        return v12;
    end;

    local v14 = { workspace_CurrentCamera };

    if p11 then
        table.insert(v14, p11);
    end;

    local v15 = LocalPlayer and LocalPlayer.Character;

    if v15 then
        table.insert(v14, v15);
    end;

    RaycastParams_new_ret.FilterDescendantsInstances = v14;
    local Unit = v13.Unit;
    local v16 = workspace:Raycast(Position, v13, RaycastParams_new_ret);

    if v16 and v16.Normal:Dot(Unit) < 0 then
        local v17 = (v16.Position - Position).Magnitude - 0.5;

        if v17 < Magnitude then
            local math_max_ret = math.max(v17, 0.5);

            return CFrame.new(p8.Position + Unit * math_max_ret) * v12.Rotation;
        end;
    end;

    return v12;
end;

local OverlapParams_new_ret = OverlapParams.new();
OverlapParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;

local function findObstructions(p18, p19, p20: number, p21: userdata?) -- Line: 81
    -- upvalues: VRService (copy), LocalPlayer (copy), RaycastParams_new_ret (copy), OverlapParams_new_ret (copy)
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if not workspace_CurrentCamera then
        return 0, {};
    end;

    local Position = p19.Position;
    local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head);
    local v22 = p18 * (CFrame.new(UserCFrame.Position * workspace_CurrentCamera.HeadScale) * UserCFrame.Rotation);
    local v23 = v22.Position - Position;
    local Magnitude = v23.Magnitude;

    if Magnitude < 0.5 then
        return 0, {};
    end;

    local v24 = { workspace_CurrentCamera };

    if p21 then
        table.insert(v24, p21);
    end;

    local v25 = LocalPlayer and LocalPlayer.Character;

    if v25 then
        table.insert(v24, v25);
    end;

    RaycastParams_new_ret.FilterDescendantsInstances = v24;
    local v26 = workspace:Raycast(Position, v23, RaycastParams_new_ret);

    if v26 then
        local Magnitude2 = (v26.Position - Position).Magnitude;

        if Magnitude2 < Magnitude then
            local v27 = (1 - -v23.Unit:Dot(v22.LookVector)) / 0.1339745962155613;
            local math_clamp_ret = math.clamp(v27, 0, 1);
            local math_max_ret = math.max(math_clamp_ret, 1 - Magnitude2 / p20, 0.15);
            local Position2 = v26.Position;
            local Position3 = v22.Position;
            local Vector3_new_ret = Vector3.new(2, 2, (Position3 - Position2).Magnitude);
            local CFrame_lookAt_ret = CFrame.lookAt((Position2 + Position3) / 2, Position3);
            OverlapParams_new_ret.FilterDescendantsInstances = v24;

            return math_max_ret, workspace:GetPartBoundsInBox(CFrame_lookAt_ret, Vector3_new_ret, OverlapParams_new_ret);
        end;
    end;

    return 0, {};
end;

local u28 = 0.016666666666666666;
local u29 = setmetatable({}, VRBaseCamera);
u29.__index = u29;

function u29.new() -- Line: 133
    -- upvalues: VRBaseCamera (copy), u29 (copy), RunService (copy), u28 (ref)
    local v30 = VRBaseCamera.new();
    local v31 = setmetatable(v30, u29);
    v31.skipOcclusion = true;
    v31:Reset();

    if v31.thirdPersonOptionChanged then
        v31.thirdPersonOptionChanged:Disconnect();
        v31.thirdPersonOptionChanged = nil;
    end;

    RunService.Stepped:Connect(function(p32: number, p33: number) -- Line: 143
        -- upvalues: u28 (ref)
        u28 = p33;
    end);

    return v31;
end;

function u29.Reset(p34) -- Line: 150
    -- upvalues: CameraUtils (copy), u1 (copy)
    local workspace_CurrentCamera = workspace.CurrentCamera;
    local v35;

    if workspace_CurrentCamera then
        v35 = workspace_CurrentCamera.CameraSubject;
    else
        v35 = workspace_CurrentCamera;
    end;

    assert(workspace_CurrentCamera, "VRVehicleCamera initialization error");
    assert(v35);
    assert(v35:IsA("VehicleSeat"));
    p34.lastOrbitalDir = nil;
    p34.wasInFirstPerson = nil;
    local ConnectedParts = v35:GetConnectedParts(true);
    table.insert(ConnectedParts, v35);
    local LooseBoundingSphere, v36 = CameraUtils.getLooseBoundingSphere(ConnectedParts);
    p34.vehicleModel = v35:FindFirstAncestorOfClass("Model") or v35.Parent;
    p34.assemblyRadius = math.max(v36, 5);
    p34.assemblyOffset = v35.CFrame:Inverse() * LooseBoundingSphere;
    p34.gamepadZoomLevels = {};

    for _, v in u1 do
        table.insert(p34.gamepadZoomLevels, v * p34.headScale * p34.assemblyRadius / 10);
    end;

    p34.lastCameraFocus = nil;

    if not p34:IsInFirstPerson() then
        p34:SetCameraToSubjectDistance(p34.gamepadZoomLevels[#p34.gamepadZoomLevels]);
    end;

    p34.needsReset = false;
end;

function u29._getThirdPersonLocalOffset(p37) -- Line: 184
    -- upvalues: VehicleCameraConfig (copy)
    return p37.assemblyOffset + Vector3.new(0, p37.assemblyRadius * VehicleCameraConfig.verticalCenterOffset, 0);
end;

function u29._getFirstPersonLocalOffset(p38: table, p39) -- Line: 188
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if Character and Character.Parent then
        local Head = Character:FindFirstChild("Head");

        if Head and Head:IsA("BasePart") then
            return p39:Inverse() * Head.Position;
        end;
    end;

    return p38:_getThirdPersonLocalOffset();
end;

function u29._vrOccludeVignette(p40: table, p41, p42: vector, p43: number) -- Line: 202
    -- upvalues: findObstructions (copy), Lighting (copy), LocalPlayer (copy)
    local math_atan2_ret = math.atan2(p42.X, p42.Z);
    local v44 = CFrame.new(p41.Position + p42 * p43) * CFrame.Angles(0, math_atan2_ret, 0);
    local v45, v46 = findObstructions(v44, p41, p43, p40.vehicleModel);
    local VRFade = Lighting:FindFirstChild("VRFade");

    if not VRFade then
        VRFade = Instance.new("ColorCorrectionEffect");
        VRFade.Name = "VRFade";
        VRFade.Parent = Lighting;
    end;

    VRFade.Brightness = -v45;

    if p40.lastOccludedParts then
        for _, v in p40.lastOccludedParts do
            v.LocalTransparencyModifier = 0;
        end;
    end;

    if #v46 > 0 then
        for _, v in v46 do
            v.LocalTransparencyModifier = 1;
        end;

        p40:StartVREdgeBlur(LocalPlayer, true);
    end;

    p40.lastOccludedParts = v46;

    return v44;
end;

function u29.Update(p47) -- Line: 229
    -- upvalues: u28 (ref), LocalPlayer (copy)
    local v48 = u28;
    u28 = 0;
    p47:UpdateFadeFromBlack(v48);
    p47:UpdateEdgeBlur(LocalPlayer, v48);
    local v49, v50 = p47:_updateStepRotation(v48);

    return v49, v50;
end;

function u29._updateStepRotation(p51: table, p52: number) -- Line: 241
    -- upvalues: mapClamp (copy), CameraInput (copy), VehicleCameraConfig (copy), vrOccludeDisplace (copy)
    local SubjectCFrame = p51:GetSubjectCFrame();
    local CameraToSubjectDistance = p51:GetCameraToSubjectDistance();
    local v53 = mapClamp(CameraToSubjectDistance, 0.5, p51.assemblyRadius, 1, 0);
    local v54 = SubjectCFrame * p51:_getThirdPersonLocalOffset():Lerp(p51:_getFirstPersonLocalOffset(SubjectCFrame), v53);
    local CFrame_new = CFrame.new;
    local CameraHeight = p51:GetCameraHeight();
    local v55 = CFrame_new(v54 + Vector3.new(0, CameraHeight, 0));

    if p51.needsReset or p51.recentered then
        p51.lastOrbitalDir = nil;
        p51.needsReset = false;
        p51.recentered = false;
    end;

    local lastOrbitalDir = p51.lastOrbitalDir;

    if not lastOrbitalDir then
        lastOrbitalDir = (SubjectCFrame.LookVector * Vector3.new(-1, 0, -1)).Unit;
        p51:StartFadeFromBlack();
    end;

    local v56 = (p51:GetSubjectVelocity() * Vector3.new(1, 0, 1)).Magnitude > 2;

    if v56 then
        CameraInput.getRotation(p52);
    else
        local Rotation = p51:getRotation(p52);

        if math.abs(Rotation) > 0 then
            lastOrbitalDir = (CFrame.Angles(0, -Rotation, 0) * CFrame.new(lastOrbitalDir)).Position.Unit;
            p51.lastRotateTime = os.clock();
        end;
    end;

    local v57;

    if p51:IsInFirstPerson() then
        if not p51.wasInFirstPerson or v56 then
            lastOrbitalDir = (SubjectCFrame.LookVector * Vector3.new(-1, 0, -1)).Unit;
            p51.wasInFirstPerson = true;
        end;

        local math_atan2_ret = math.atan2(-SubjectCFrame.LookVector.X, -SubjectCFrame.LookVector.Z);

        if p51.lastVehicleYaw then
            local v58 = (math_atan2_ret - p51.lastVehicleYaw + 3.141592653589793) % 6.283185307179586 - 3.141592653589793;

            if math.abs(v58) > 0.001 then
                lastOrbitalDir = (CFrame.Angles(0, v58, 0) * CFrame.new(lastOrbitalDir)).Position.Unit;
            end;
        end;

        p51.lastVehicleYaw = math_atan2_ret;
        local math_atan2_ret2 = math.atan2(lastOrbitalDir.X, lastOrbitalDir.Z);
        v57 = CFrame.new(v55.Position + lastOrbitalDir * CameraToSubjectDistance) * CFrame.Angles(0, math_atan2_ret2, 0);
    else
        p51.wasInFirstPerson = false;
        p51.lastVehicleYaw = nil;
        local v59 = p51.lastRotateTime and os.clock() - p51.lastRotateTime < VehicleCameraConfig.autocorrectDelay;

        if v56 and not v59 then
            local Unit = (SubjectCFrame.LookVector * Vector3.new(-1, 0, -1)).Unit;
            local v60 = lastOrbitalDir:Dot(Unit);
            local math_clamp_ret = math.clamp(v60, -1, 1);
            local math_acos_ret = math.acos(math_clamp_ret);
            local SubjectRotVelocity = p51:GetSubjectRotVelocity();
            local v61 = SubjectCFrame.YVector:Dot(SubjectRotVelocity);
            local math_abs_ret = math.abs(v61);
            lastOrbitalDir = lastOrbitalDir:Lerp(Unit, (math.min(0.01 + math_acos_ret / 3.141592653589793 * 0.05 + math_abs_ret * 0.02, 0.15)));
        end;

        v57 = vrOccludeDisplace(v55, lastOrbitalDir, CameraToSubjectDistance, p51.vehicleModel);
    end;

    p51.lastOrbitalDir = lastOrbitalDir;

    return v57, v57 * CFrame.new(0, 0, -CameraToSubjectDistance);
end;

return u29;
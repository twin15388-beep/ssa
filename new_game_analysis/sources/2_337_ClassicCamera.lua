-- Decompiled with Potassium's decompiler.

local u1 = 0;
local CFrame_fromOrientation_ret = CFrame.fromOrientation(-0.2617993877991494, 0, 0);
local UserFlag = require(script.Parent.Parent:WaitForChild("CommonUtils")).get("FlagUtil").getUserFlag("UserFixCameraFPError");
local Players = game:GetService("Players");
local CameraInput = require(script.Parent:WaitForChild("CameraInput"));
local CameraUtils = require(script.Parent:WaitForChild("CameraUtils"));
local BaseCamera = require(script.Parent:WaitForChild("BaseCamera"));
local u2 = setmetatable({}, BaseCamera);
u2.__index = u2;

function u2.new() -- Line: 35
    -- upvalues: BaseCamera (copy), u2 (copy), CameraUtils (copy)
    local v3 = BaseCamera.new();
    local v4 = setmetatable(v3, u2);
    v4.isFollowCamera = false;
    v4.isCameraToggle = false;
    v4.lastUpdate = tick();
    v4.cameraToggleSpring = CameraUtils.Spring.new(5, 0);

    return v4;
end;

function u2.GetCameraToggleOffset(p5: table, p6: number) -- Line: 46
    -- upvalues: CameraInput (copy), CameraUtils (copy)
    if not p5.isCameraToggle then
        return Vector3.new();
    end;

    local currentSubjectDistance = p5.currentSubjectDistance;

    if CameraInput.getTogglePan() then
        local cameraToggleSpring = p5.cameraToggleSpring;
        local v7 = CameraUtils.map(currentSubjectDistance, 0.5, p5.FIRST_PERSON_DISTANCE_THRESHOLD, 0, 1);
        cameraToggleSpring.goal = math.clamp(v7, 0, 1);
    else
        p5.cameraToggleSpring.goal = 0;
    end;

    local v8 = CameraUtils.map(currentSubjectDistance, 0.5, 64, 0, 1);
    local v9 = math.clamp(v8, 0, 1) + 1;
    local v10 = p5.cameraToggleSpring:step(p6) * v9;

    return Vector3.new(0, v10, 0);
end;

function u2.SetCameraMovementMode(p11, p12) -- Line: 64
    -- upvalues: BaseCamera (copy)
    BaseCamera.SetCameraMovementMode(p11, p12);
    p11.isFollowCamera = p12 == Enum.ComputerCameraMovementMode.Follow;
    p11.isCameraToggle = p12 == Enum.ComputerCameraMovementMode.CameraToggle;
end;

function u2.Update(p13, p14) -- Line: 71
    -- upvalues: CFrame_fromOrientation_ret (copy), Players (copy), CameraInput (copy), u1 (ref), CameraUtils (copy), UserFlag (copy)
    local v15 = tick();
    local workspace_CurrentCamera = workspace.CurrentCamera;
    local CFrame2 = workspace_CurrentCamera.CFrame;
    local Focus = workspace_CurrentCamera.Focus;
    local v16;

    if p13.resetCameraAngle then
        local HumanoidRootPart = p13:GetHumanoidRootPart();

        if HumanoidRootPart then
            v16 = (HumanoidRootPart.CFrame * CFrame_fromOrientation_ret).lookVector;
        else
            v16 = CFrame_fromOrientation_ret.lookVector;
        end;

        p13.resetCameraAngle = false;
    else
        v16 = nil;
    end;

    local LocalPlayer = Players.LocalPlayer;
    local Humanoid = p13:GetHumanoid();
    local CameraSubject = workspace_CurrentCamera.CameraSubject;
    local v17;

    if CameraSubject then
        v17 = CameraSubject:IsA("VehicleSeat");
    else
        v17 = CameraSubject;
    end;

    local v18;

    if CameraSubject then
        v18 = CameraSubject:IsA("SkateboardPlatform");
    else
        v18 = CameraSubject;
    end;

    local v19;

    if Humanoid then
        v19 = Humanoid:GetState() == Enum.HumanoidStateType.Climbing;
    else
        v19 = Humanoid;
    end;

    if p13.lastUpdate == nil or p14 > 1 then
        p13.lastCameraTransform = nil;
    end;

    local Rotation = CameraInput.getRotation(p14);
    local v20 = Rotation + CameraInput.getAssistRotation();
    p13:StepZoom(p14);
    local CameraHeight = p13:GetCameraHeight();

    if Rotation ~= Vector2.new() then
        u1 = 0;
        p13.lastUserPanCamera = tick();
    end;

    local v21 = v15 - p13.lastUserPanCamera < 2;
    local SubjectPosition = p13:GetSubjectPosition();

    if SubjectPosition and (LocalPlayer and workspace_CurrentCamera) then
        local CameraToSubjectDistance = p13:GetCameraToSubjectDistance();
        local v22 = CameraToSubjectDistance < 0.5 and 0.5 or CameraToSubjectDistance;

        if p13:GetIsMouseLocked() and not p13:IsInFirstPerson() then
            local v23 = p13:CalculateNewLookCFrameFromArg(v16, v20);
            local MouseLockOffset = p13:GetMouseLockOffset();

            if Humanoid then
                MouseLockOffset = MouseLockOffset + Humanoid.CameraOffset;
            end;

            local v24 = MouseLockOffset.X * v23.RightVector + MouseLockOffset.Y * v23.UpVector + MouseLockOffset.Z * v23.LookVector;

            if CameraUtils.IsFiniteVector3(v24) then
                SubjectPosition = SubjectPosition + v24;
            end;
        elseif Rotation == Vector2.new() and p13.lastCameraTransform then
            local v25 = p13:IsInFirstPerson();

            if (v17 or (v18 or p13.isFollowCamera and v19)) and (p13.lastUpdate and (Humanoid and Humanoid.Torso)) then
                if v25 then
                    if p13.lastSubjectCFrame and (v17 or v18) and CameraSubject:IsA("BasePart") then
                        local v26 = -CameraUtils.GetAngleBetweenXZVectors(p13.lastSubjectCFrame.lookVector, CameraSubject.CFrame.lookVector);

                        if CameraUtils.IsFinite(v26) then
                            v20 = v20 + Vector2.new(v26, 0);
                        end;

                        u1 = 0;
                    end;
                elseif not v21 then
                    local lookVector = Humanoid.Torso.CFrame.lookVector;
                    u1 = math.clamp(u1 + 3.839724354387525 * p14, 0, 4.363323129985824);
                    local math_clamp_ret = math.clamp(u1 * p14, 0, 1);
                    local v27 = p13:IsInFirstPerson() and not (p13.isFollowCamera and p13.isClimbing) and 1 or math_clamp_ret;
                    local AngleBetweenXZVectors = CameraUtils.GetAngleBetweenXZVectors(lookVector, p13:GetCameraLookVector());

                    if CameraUtils.IsFinite(AngleBetweenXZVectors) and math.abs(AngleBetweenXZVectors) > 0.0001 then
                        v20 = v20 + Vector2.new(AngleBetweenXZVectors * v27, 0);
                    end;
                end;
            elseif p13.isFollowCamera and not (v25 or v21) then
                local AngleBetweenXZVectors = CameraUtils.GetAngleBetweenXZVectors(-(p13.lastCameraTransform.Position - SubjectPosition), p13:GetCameraLookVector());

                if CameraUtils.IsFinite(AngleBetweenXZVectors) and (math.abs(AngleBetweenXZVectors) > 0.0001 and math.abs(AngleBetweenXZVectors) > 0.4 * p14) then
                    v20 = v20 + Vector2.new(AngleBetweenXZVectors, 0);
                end;
            end;
        end;

        local v28, v29;

        if p13.isFollowCamera then
            local v30 = p13:CalculateNewLookVectorFromArg(v16, v20);
            v28 = CFrame.new(SubjectPosition);

            if UserFlag then
                v29 = CFrame.lookAlong(v28.Position - v22 * v30, v30);
            else
                v29 = CFrame.new(v28.Position - v22 * v30, v28.Position) + Vector3.new(0, CameraHeight, 0);
            end;
        else
            v28 = CFrame.new(SubjectPosition);
            local Position = v28.Position;
            local v31 = p13:CalculateNewLookVectorFromArg(v16, v20);

            if UserFlag then
                v29 = CFrame.lookAlong(Position - v22 * v31, v31);
            else
                v29 = CFrame.new(Position - v22 * v31, Position);
            end;
        end;

        local CameraToggleOffset = p13:GetCameraToggleOffset(p14);
        Focus = v28 + CameraToggleOffset;
        CFrame2 = v29 + CameraToggleOffset;
        p13.lastCameraTransform = CFrame2;
        p13.lastCameraFocus = Focus;

        if (v17 or v18) and CameraSubject:IsA("BasePart") then
            p13.lastSubjectCFrame = CameraSubject.CFrame;
        else
            p13.lastSubjectCFrame = nil;
        end;
    end;

    p13.lastUpdate = v15;

    return CFrame2, Focus;
end;

return u2;
-- Decompiled with Potassium's decompiler.

require(script.Parent:WaitForChild("CameraUtils"));
local CameraInput = require(script.Parent:WaitForChild("CameraInput"));
local Players = game:GetService("Players");
local BaseCamera = require(script.Parent:WaitForChild("BaseCamera"));
local u1 = setmetatable({}, BaseCamera);
u1.__index = u1;

function u1.new() -- Line: 20
    -- upvalues: BaseCamera (copy), u1 (copy)
    local v2 = BaseCamera.new();
    local v3 = setmetatable(v2, u1);
    v3.cameraType = Enum.CameraType.Fixed;
    v3.lastUpdate = tick();
    v3.lastDistanceToSubject = nil;

    return v3;
end;

function u1.GetModuleName(p4) -- Line: 30
    return "LegacyCamera";
end;

function u1.Update(p5: table, p6: number) -- Line: 34
    -- upvalues: Players (copy), CameraInput (copy)
    if not p5.cameraType then
        return nil, nil;
    end;

    local v7 = tick();
    local v8 = v7 - p5.lastUpdate;
    local workspace_CurrentCamera = workspace.CurrentCamera;
    local CFrame2 = workspace_CurrentCamera.CFrame;
    local Focus = workspace_CurrentCamera.Focus;
    local LocalPlayer = Players.LocalPlayer;
    local Rotation = CameraInput.getRotation(p6);

    if p5.lastUpdate == nil or v8 > 1 then
        p5.lastDistanceToSubject = nil;
    end;

    local SubjectPosition = p5:GetSubjectPosition();

    if p5.cameraType == Enum.CameraType.Fixed then
        if SubjectPosition and (LocalPlayer and workspace_CurrentCamera) then
            local CameraToSubjectDistance = p5:GetCameraToSubjectDistance();
            local v9 = p5:CalculateNewLookVectorFromArg(nil, Rotation);
            Focus = workspace_CurrentCamera.Focus;
            CFrame2 = CFrame.new(workspace_CurrentCamera.CFrame.Position, workspace_CurrentCamera.CFrame.Position + CameraToSubjectDistance * v9);
        end;
    elseif p5.cameraType == Enum.CameraType.Attach then
        local SubjectCFrame = p5:GetSubjectCFrame();
        local v10 = workspace_CurrentCamera.CFrame:ToEulerAnglesYXZ();
        local _, v11 = SubjectCFrame:ToEulerAnglesYXZ();
        local math_clamp_ret = math.clamp(v10 - Rotation.Y, -1.3962634015954636, 1.3962634015954636);
        Focus = CFrame.new(SubjectCFrame.Position) * CFrame.fromEulerAnglesYXZ(math_clamp_ret, v11, 0);
        CFrame2 = Focus * CFrame.new(0, 0, p5:StepZoom(p6));
    else
        if p5.cameraType ~= Enum.CameraType.Watch then
            return workspace_CurrentCamera.CFrame, workspace_CurrentCamera.Focus;
        end;

        if SubjectPosition and (LocalPlayer and workspace_CurrentCamera) then
            local v12 = nil;

            if SubjectPosition == workspace_CurrentCamera.CFrame.Position then
                warn("Camera cannot watch subject in same position as itself");

                return workspace_CurrentCamera.CFrame, workspace_CurrentCamera.Focus;
            end;

            local Humanoid = p5:GetHumanoid();

            if Humanoid and Humanoid.RootPart then
                local v13 = SubjectPosition - workspace_CurrentCamera.CFrame.Position;
                v12 = v13.unit;

                if p5.lastDistanceToSubject and p5.lastDistanceToSubject == p5:GetCameraToSubjectDistance() then
                    p5:SetCameraToSubjectDistance(v13.magnitude);
                end;
            end;

            local CameraToSubjectDistance = p5:GetCameraToSubjectDistance();
            local v14 = p5:CalculateNewLookVectorFromArg(v12, Rotation);
            Focus = CFrame.new(SubjectPosition);
            CFrame2 = CFrame.new(SubjectPosition - CameraToSubjectDistance * v14, SubjectPosition);
            p5.lastDistanceToSubject = CameraToSubjectDistance;
        end;
    end;

    p5.lastUpdate = v7;

    return CFrame2, Focus;
end;

return u1;
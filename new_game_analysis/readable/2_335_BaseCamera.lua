-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local VRService = game:GetService("VRService");
local GuiService = game:GetService("GuiService");
local UserGameSettings = UserSettings():GetService("UserGameSettings");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CommonUtils = require(script.Parent.Parent:WaitForChild("CommonUtils"));
local u1 = CommonUtils.get("ConnectionUtil");
CommonUtils.get("FlagUtil");
local CameraUtils = require(script.Parent:WaitForChild("CameraUtils"));
local ZoomController = require(script.Parent:WaitForChild("ZoomController"));
local CameraToggleStateController = require(script.Parent:WaitForChild("CameraToggleStateController"));
local CameraInput = require(script.Parent:WaitForChild("CameraInput"));
local CameraUI = require(script.Parent:WaitForChild("CameraUI"));
local CameraGamepadZoomAction = script.Parent.Parent:WaitForChild("InputContexts"):WaitForChild("CameraContext"):WaitForChild("CameraGamepadZoomAction");
local LocalPlayer = Players.LocalPlayer;
local Run_Handler = require(ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Modules"):WaitForChild("GamePlay"):WaitForChild("Run_Handler"));
local Camera_Traffic_Handler = require(ReplicatedStorage.CAM.Client.Controllers.Camera_Traffic_Handler);
local u2 = {};
u2.__index = u2;

function u2.new() -- Line: 80
    -- upvalues: u2 (copy), u1 (copy), LocalPlayer (copy), CameraGamepadZoomAction (copy), UserGameSettings (copy)
    local u3 = setmetatable({}, u2);
    u3._connections = u1.new();
    u3.gamepadZoomLevels = { 0, 10, 20 };
    u3.FIRST_PERSON_DISTANCE_THRESHOLD = 1;
    u3.cameraType = nil;
    u3.cameraMovementMode = nil;
    u3.lastCameraTransform = nil;
    u3.lastUserPanCamera = tick();
    u3.humanoidRootPart = nil;
    u3.humanoidCache = {};
    u3.lastSubject = nil;
    u3.lastSubjectPosition = Vector3.new(0, 5, 0);
    u3.lastSubjectCFrame = CFrame.new(u3.lastSubjectPosition);
    u3.currentSubjectDistance = math.clamp(12.5, LocalPlayer.CameraMinZoomDistance, LocalPlayer.CameraMaxZoomDistance);
    u3.inFirstPerson = false;
    u3.inMouseLockedMode = false;
    u3.resetCameraAngle = true;
    u3.enabled = false;
    u3.cameraChangedConn = nil;
    u3.shouldUseVRRotation = false;
    u3.VRRotationIntensityAvailable = false;
    u3.lastVRRotationIntensityCheckTime = 0;
    u3.lastVRRotationTime = 0;
    u3.vrRotateKeyCooldown = {};
    u3.cameraTranslationConstraints = Vector3.new(1, 1, 1);
    u3.humanoidJumpOrigin = nil;
    u3.trackingHumanoid = nil;
    u3.cameraFrozen = false;
    u3.subjectStateChangedConn = nil;
    u3.gamepadZoomPressConnection = CameraGamepadZoomAction.Pressed:Connect(function() -- Line: 128
        -- upvalues: u3 (copy)
        u3:GamepadZoomPress();
    end);
    u3.mouseLockOffset = Vector3.new(0, 0, 0);
    UserGameSettings:SetCameraYInvertVisible();
    UserGameSettings:SetGamepadCameraSensitivityVisible();

    return u3;
end;

function u2.GetModuleName(p4) -- Line: 142
    return "BaseCamera";
end;

local function onSelectedObjectChanged() -- Line: 146
    -- upvalues: CameraGamepadZoomAction (copy), GuiService (copy)
    CameraGamepadZoomAction.Enabled = not GuiService.SelectedObject;
end;

function u2._setUpConfigurations(u5) -- Line: 150
    -- upvalues: LocalPlayer (copy), GuiService (copy), CameraGamepadZoomAction (copy)
    u5._connections:trackConnection("CHARACTER_ADDED", LocalPlayer.CharacterAdded:Connect(function(p6) -- Line: 151
        -- upvalues: u5 (copy)
        u5:OnCharacterAdded(p6);
    end));
    u5.humanoidRootPart = nil;
    u5._connections:trackConnection("CAMERA_MODE_CHANGED", LocalPlayer:GetPropertyChangedSignal("CameraMode"):Connect(function() -- Line: 156
        -- upvalues: u5 (copy)
        u5:OnPlayerCameraPropertyChange();
    end));
    u5._connections:trackConnection("CAMERA_MIN_DISTANCE_CHANGED", LocalPlayer:GetPropertyChangedSignal("CameraMinZoomDistance"):Connect(function() -- Line: 159
        -- upvalues: u5 (copy)
        u5:OnPlayerCameraPropertyChange();
    end));
    u5._connections:trackConnection("CAMERA_MAX_DISTANCE_CHANGED", LocalPlayer:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(function() -- Line: 162
        -- upvalues: u5 (copy)
        u5:OnPlayerCameraPropertyChange();
    end));
    u5._connections:trackConnection("SELECTION_MODE_CHANGED", GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(function() -- Line: 165
        -- upvalues: CameraGamepadZoomAction (ref), GuiService (ref)
        CameraGamepadZoomAction.Enabled = not GuiService.SelectedObject;
    end));
    u5:OnPlayerCameraPropertyChange();
end;

function u2.OnCharacterAdded(p7, p8) -- Line: 171
    p7.resetCameraAngle = p7.resetCameraAngle or p7:GetEnabled();
    p7.humanoidRootPart = nil;
end;

function u2.GetHumanoidRootPart(p9) -- Line: 178
    -- upvalues: LocalPlayer (copy)
    local v10 = (not p9.humanoidRootPart and LocalPlayer.Character and true or false) and LocalPlayer.Character:FindFirstChildOfClass("Humanoid");

    if v10 then
        p9.humanoidRootPart = v10.RootPart;
    end;

    return p9.humanoidRootPart;
end;

function u2.GetSubjectCFrame(p11) -- Line: 190
    local lastSubjectCFrame = p11.lastSubjectCFrame;
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if workspace_CurrentCamera then
        workspace_CurrentCamera = workspace_CurrentCamera.CameraSubject;
    end;

    if not workspace_CurrentCamera then
        return lastSubjectCFrame;
    end;

    if workspace_CurrentCamera:IsA("Humanoid") then
        local v12 = workspace_CurrentCamera:GetState() == Enum.HumanoidStateType.Dead;
        local CameraOffset = workspace_CurrentCamera.CameraOffset;

        if p11:GetIsMouseLocked() then
            CameraOffset = Vector3.new();
        end;

        local RootPart = workspace_CurrentCamera.RootPart;

        if v12 and (workspace_CurrentCamera.Parent and workspace_CurrentCamera.Parent:IsA("Model")) then
            RootPart = workspace_CurrentCamera.Parent:FindFirstChild("Head") or RootPart;
        end;

        if RootPart and RootPart:IsA("BasePart") then
            local v13;

            if workspace_CurrentCamera.RigType == Enum.HumanoidRigType.R15 then
                if workspace_CurrentCamera.AutomaticScalingEnabled then
                    v13 = Vector3.new(0, 1.5, 0);
                    local RootPart2 = workspace_CurrentCamera.RootPart;

                    if RootPart == RootPart2 then
                        v13 = v13 + Vector3.new(0, (RootPart2.Size.Y - 2) / 2, 0);
                    end;
                else
                    v13 = Vector3.new(0, 2, 0);
                end;
            else
                v13 = Vector3.new(0, 1.5, 0);
            end;

            lastSubjectCFrame = RootPart.CFrame * CFrame.new((v12 and Vector3.new(0, 0, 0) or v13) + CameraOffset);
        end;
    elseif workspace_CurrentCamera:IsA("BasePart") then
        lastSubjectCFrame = workspace_CurrentCamera.CFrame;
    elseif workspace_CurrentCamera:IsA("Model") then
        if workspace_CurrentCamera.PrimaryPart then
            lastSubjectCFrame = workspace_CurrentCamera:GetPrimaryPartCFrame();
        else
            lastSubjectCFrame = CFrame.new();
        end;
    end;

    if lastSubjectCFrame then
        p11.lastSubjectCFrame = lastSubjectCFrame;
    end;

    return lastSubjectCFrame;
end;

function u2.GetSubjectVelocity(p14) -- Line: 264
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if workspace_CurrentCamera then
        workspace_CurrentCamera = workspace_CurrentCamera.CameraSubject;
    end;

    if not workspace_CurrentCamera then
        return Vector3.new(0, 0, 0);
    end;

    if workspace_CurrentCamera:IsA("BasePart") then
        return workspace_CurrentCamera.Velocity;
    end;

    if workspace_CurrentCamera:IsA("Humanoid") then
        local RootPart = workspace_CurrentCamera.RootPart;

        if RootPart then
            return RootPart.Velocity;
        end;
    else
        local v15 = workspace_CurrentCamera:IsA("Model") and workspace_CurrentCamera.PrimaryPart;

        if v15 then
            return v15.Velocity;
        end;
    end;

    return Vector3.new(0, 0, 0);
end;

function u2.GetSubjectRotVelocity(p16) -- Line: 293
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if workspace_CurrentCamera then
        workspace_CurrentCamera = workspace_CurrentCamera.CameraSubject;
    end;

    if not workspace_CurrentCamera then
        return Vector3.new(0, 0, 0);
    end;

    if workspace_CurrentCamera:IsA("BasePart") then
        return workspace_CurrentCamera.RotVelocity;
    end;

    if workspace_CurrentCamera:IsA("Humanoid") then
        local RootPart = workspace_CurrentCamera.RootPart;

        if RootPart then
            return RootPart.RotVelocity;
        end;
    else
        local v17 = workspace_CurrentCamera:IsA("Model") and workspace_CurrentCamera.PrimaryPart;

        if v17 then
            return v17.RotVelocity;
        end;
    end;

    return Vector3.new(0, 0, 0);
end;

function u2.StepZoom(p18: table, p19: number?) -- Line: 322
    -- upvalues: CameraInput (copy), ZoomController (copy)
    local currentSubjectDistance = p18.currentSubjectDistance;
    local ZoomDelta = CameraInput.getZoomDelta(p19);

    if math.abs(ZoomDelta) > 0 then
        local v20;

        if ZoomDelta > 0 then
            v20 = math.max(currentSubjectDistance + ZoomDelta * (currentSubjectDistance * 0.5 + 1), p18.FIRST_PERSON_DISTANCE_THRESHOLD);
        else
            v20 = math.max((currentSubjectDistance + ZoomDelta) / (1 - ZoomDelta * 0.5), 0.5);
        end;

        p18:SetCameraToSubjectDistance(v20 < p18.FIRST_PERSON_DISTANCE_THRESHOLD and 0.5 or v20);
    end;

    return ZoomController.GetZoomRadius();
end;

function u2.GetSubjectPosition(p21) -- Line: 347
    local lastSubjectPosition = p21.lastSubjectPosition;
    local CurrentCamera = game.Workspace.CurrentCamera;

    if CurrentCamera then
        CurrentCamera = CurrentCamera.CameraSubject;
    end;

    if not CurrentCamera then
        return nil;
    end;

    if CurrentCamera:IsA("Humanoid") then
        local v22 = CurrentCamera:GetState() == Enum.HumanoidStateType.Dead;
        local CameraOffset = CurrentCamera.CameraOffset;

        if p21:GetIsMouseLocked() then
            CameraOffset = Vector3.new();
        end;

        local RootPart = CurrentCamera.RootPart;

        if v22 and (CurrentCamera.Parent and CurrentCamera.Parent:IsA("Model")) then
            RootPart = CurrentCamera.Parent:FindFirstChild("Head") or RootPart;
        end;

        if RootPart and RootPart:IsA("BasePart") then
            local v23;

            if CurrentCamera.RigType == Enum.HumanoidRigType.R15 then
                if CurrentCamera.AutomaticScalingEnabled then
                    v23 = Vector3.new(0, 1.5, 0);

                    if RootPart == CurrentCamera.RootPart then
                        v23 = v23 + Vector3.new(0, CurrentCamera.RootPart.Size.Y / 2 - 1, 0);
                    end;
                else
                    v23 = Vector3.new(0, 2, 0);
                end;
            else
                v23 = Vector3.new(0, 1.5, 0);
            end;

            lastSubjectPosition = RootPart.CFrame.Position + RootPart.CFrame:vectorToWorldSpace((v22 and Vector3.new(0, 0, 0) or v23) + CameraOffset);
        end;
    elseif CurrentCamera:IsA("VehicleSeat") then
        lastSubjectPosition = CurrentCamera.CFrame.Position + CurrentCamera.CFrame:vectorToWorldSpace(Vector3.new(0, 5, 0));
    elseif CurrentCamera:IsA("SkateboardPlatform") then
        lastSubjectPosition = CurrentCamera.CFrame.Position + Vector3.new(0, 5, 0);
    elseif CurrentCamera:IsA("BasePart") then
        lastSubjectPosition = CurrentCamera.CFrame.Position;
    elseif CurrentCamera:IsA("Model") then
        if CurrentCamera.PrimaryPart then
            lastSubjectPosition = CurrentCamera:GetPrimaryPartCFrame().Position;
        else
            lastSubjectPosition = CurrentCamera:GetModelCFrame().Position;
        end;
    end;

    p21.lastSubject = CurrentCamera;
    p21.lastSubjectPosition = lastSubjectPosition;

    return lastSubjectPosition;
end;

function u2.OnCurrentCameraChanged(u24) -- Line: 425
    if u24.cameraSubjectChangedConn then
        u24.cameraSubjectChangedConn:Disconnect();
        u24.cameraSubjectChangedConn = nil;
    end;

    local CurrentCamera = game.Workspace.CurrentCamera;

    if CurrentCamera then
        u24.cameraSubjectChangedConn = CurrentCamera:GetPropertyChangedSignal("CameraSubject"):Connect(function() -- Line: 434
            -- upvalues: u24 (copy)
            u24:OnNewCameraSubject();
        end);
        u24:OnNewCameraSubject();
    end;
end;

function u2.OnPlayerCameraPropertyChange(p25) -- Line: 441
    p25:SetCameraToSubjectDistance(p25.currentSubjectDistance);
end;

function u2.InputTranslationToCameraAngleChange(p26, p27, p28) -- Line: 446
    return p27 * p28;
end;

function u2.GamepadZoomPress(p29) -- Line: 452
    -- upvalues: LocalPlayer (copy)
    local CameraToSubjectDistance = p29:GetCameraToSubjectDistance();
    local CameraMaxZoomDistance = LocalPlayer.CameraMaxZoomDistance;

    for i = #p29.gamepadZoomLevels, 1, -1 do
        local v30 = p29.gamepadZoomLevels[i];
        local v31;

        if CameraMaxZoomDistance < v30 then
            v31 = i;
        else
            if v30 < LocalPlayer.CameraMinZoomDistance then
                v30 = LocalPlayer.CameraMinZoomDistance;

                if CameraMaxZoomDistance == v30 then
                    break;
                end;
            end;

            if v30 + (CameraMaxZoomDistance - v30) / 2 < CameraToSubjectDistance then
                p29:SetCameraToSubjectDistance(v30);

                return;
            end;

            CameraMaxZoomDistance = v30;
            v31 = i;
        end;
    end;

    p29:SetCameraToSubjectDistance(p29.gamepadZoomLevels[#p29.gamepadZoomLevels]);
end;

function u2.Enable(p32: table, p33: boolean) -- Line: 489
    if p32.enabled ~= p33 then
        p32.enabled = p33;
        p32:OnEnabledChanged();
    end;
end;

function u2.OnEnabledChanged(u34) -- Line: 497
    -- upvalues: CameraInput (copy), CameraGamepadZoomAction (copy), LocalPlayer (copy)
    if not u34.enabled then
        u34._connections:disconnectAll();
        CameraInput.setInputEnabled(false);
        CameraGamepadZoomAction.Enabled = false;
        u34:Cleanup();

        return;
    end;

    u34:_setUpConfigurations();
    CameraInput.setInputEnabled(true);
    CameraGamepadZoomAction.Enabled = true;

    if LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
        u34.currentSubjectDistance = 0.5;

        if not u34.inFirstPerson then
            u34:EnterFirstPerson();
        end;
    end;

    if u34.cameraChangedConn then
        u34.cameraChangedConn:Disconnect();
        u34.cameraChangedConn = nil;
    end;

    u34.cameraChangedConn = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- Line: 513
        -- upvalues: u34 (copy)
        u34:OnCurrentCameraChanged();
    end);
    u34:OnCurrentCameraChanged();
end;

function u2.GetEnabled(p35) -- Line: 528
    return p35.enabled;
end;

function u2.Cleanup(p36) -- Line: 532
    -- upvalues: CameraUtils (copy)
    if p36.subjectStateChangedConn then
        p36.subjectStateChangedConn:Disconnect();
        p36.subjectStateChangedConn = nil;
    end;

    if p36.cameraChangedConn then
        p36.cameraChangedConn:Disconnect();
        p36.cameraChangedConn = nil;
    end;

    p36.lastCameraTransform = nil;
    p36.lastSubjectCFrame = nil;
    CameraUtils.restoreMouseBehavior();
end;

local u37 = 0;
local u38 = false;

function u2.UpdateMouseBehavior(p39) -- Line: 573
    -- upvalues: UserGameSettings (copy), CameraUI (copy), CameraInput (copy), CameraToggleStateController (copy), LocalPlayer (copy), Camera_Traffic_Handler (copy), Run_Handler (copy), CameraUtils (copy), u38 (ref), u37 (ref)
    if p39.isCameraToggle and UserGameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove == false then
        CameraUI.setCameraModeToastEnabled(true);
        CameraInput.enableCameraToggleInput();
        CameraToggleStateController(p39.inFirstPerson);

        return;
    end;

    CameraUI.setCameraModeToastEnabled(false);
    CameraInput.disableCameraToggleInput();
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if workspace_CurrentCamera then
        workspace_CurrentCamera = workspace_CurrentCamera.CameraSubject;
    end;

    local v40 = LocalPlayer and LocalPlayer.Character;
    local v41;

    if workspace_CurrentCamera == nil or (v40 == nil or workspace_CurrentCamera:IsDescendantOf(v40)) then
        v41 = false;
    else
        if not workspace_CurrentCamera:IsA("Model") then
            workspace_CurrentCamera = workspace_CurrentCamera:FindFirstAncestorOfClass("Model");
        end;

        if workspace_CurrentCamera == nil then
            v41 = false;
        else
            v41 = workspace_CurrentCamera:FindFirstChildOfClass("Humanoid") ~= nil;
        end;
    end;

    local v42 = v41 and 0 or ((p39.inFirstPerson or p39.inMouseLockedMode) and 3 or (Camera_Traffic_Handler.Equipped_Hirearchy == "" and Run_Handler.Shift_lock == 1 and ((Run_Handler.Is_Running == false or (Run_Handler.IsWalking or (Run_Handler.SkillBeingPerformed or (Run_Handler.DashArmed == true and true or Run_Handler.RunToggles == true))) == true) and 1 or 2) or 0));

    if v42 == 1 or v42 == 2 then
        CameraUtils.setMouseBehaviorOverride(Enum.MouseBehavior.LockCenter);
        u38 = true;
    elseif v42 == 0 then
        if u38 then
            CameraUtils.restoreMouseBehavior();
            u38 = false;
        end;

        if CameraInput.getPanActivated() then
            CameraUtils.setMouseBehaviorOverride(Enum.MouseBehavior.LockCurrentPosition);
        else
            CameraUtils.restoreMouseBehavior();
        end;
    end;

    if v42 ~= u37 then
        if v42 == 1 then
            CameraUtils.setRotationTypeOverride(Enum.RotationType.CameraRelative);
            Run_Handler.ActualShiftlockMode = 1;
        elseif v42 == 2 then
            Run_Handler.ActualShiftlockMode = 2;
            CameraUtils.restoreRotationType();
        elseif v42 == 3 then
            CameraUtils.setRotationTypeOverride(Enum.RotationType.CameraRelative);
            CameraUtils.setMouseBehaviorOverride(Enum.MouseBehavior.LockCenter);
            u38 = true;
        else
            Run_Handler.ActualShiftlockMode = 0;
            CameraUtils.restoreRotationType();
        end;

        u37 = v42;
    end;
end;

function u2.UpdateForDistancePropertyChange(p43) -- Line: 648
    p43:SetCameraToSubjectDistance(p43.currentSubjectDistance);
end;

function u2.SetCameraToSubjectDistance(p44: table, p45: number) -- Line: 654
    -- upvalues: LocalPlayer (copy), ZoomController (copy)
    local currentSubjectDistance = p44.currentSubjectDistance;

    if LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
        p44.currentSubjectDistance = 0.5;

        if not p44.inFirstPerson then
            p44:EnterFirstPerson();
        end;
    else
        local math_clamp_ret = math.clamp(p45, LocalPlayer.CameraMinZoomDistance, LocalPlayer.CameraMaxZoomDistance);

        if math_clamp_ret < 1 then
            p44.currentSubjectDistance = 0.5;

            if not p44.inFirstPerson then
                p44:EnterFirstPerson();
            end;
        else
            p44.currentSubjectDistance = math_clamp_ret;

            if p44.inFirstPerson then
                p44:LeaveFirstPerson();
            end;
        end;
    end;

    ZoomController.SetZoomParameters(p44.currentSubjectDistance, (math.sign(p45 - currentSubjectDistance)));

    return p44.currentSubjectDistance;
end;

function u2.SetCameraType(p46, p47) -- Line: 688
    p46.cameraType = p47;
end;

function u2.GetCameraType(p48) -- Line: 693
    return p48.cameraType;
end;

function u2.SetCameraMovementMode(p49, p50) -- Line: 698
    p49.cameraMovementMode = p50;
end;

function u2.GetCameraMovementMode(p51) -- Line: 702
    return p51.cameraMovementMode;
end;

function u2.SetIsMouseLocked(p52: table, p53: boolean) -- Line: 706
    p52.inMouseLockedMode = p53;
end;

function u2.GetIsMouseLocked(p54) -- Line: 710
    return p54.inMouseLockedMode;
end;

function u2.SetMouseLockOffset(p55, p56) -- Line: 714
    p55.mouseLockOffset = p56;
end;

function u2.GetMouseLockOffset(p57) -- Line: 718
    return p57.mouseLockOffset;
end;

function u2.InFirstPerson(p58) -- Line: 722
    return p58.inFirstPerson;
end;

function u2.EnterFirstPerson(p59) -- Line: 726
    p59.inFirstPerson = true;
    p59:UpdateMouseBehavior();
end;

function u2.LeaveFirstPerson(p60) -- Line: 731
    p60.inFirstPerson = false;
    p60:UpdateMouseBehavior();
end;

function u2.GetCameraToSubjectDistance(p61) -- Line: 737
    return p61.currentSubjectDistance;
end;

function u2.GetMeasuredDistanceToFocus(p62) -- Line: 744
    local CurrentCamera = game.Workspace.CurrentCamera;

    if CurrentCamera then
        return (CurrentCamera.CoordinateFrame.Position - CurrentCamera.Focus.Position).magnitude;
    end;

    return nil;
end;

function u2.GetCameraLookVector(p63) -- Line: 752
    return game.Workspace.CurrentCamera and game.Workspace.CurrentCamera.CFrame.LookVector or Vector3.new(0, 0, 1);
end;

function u2.CalculateNewLookCFrameFromArg(p64: table, p65: vector?, p66) -- Line: 756
    local v67 = p65 or p64:GetCameraLookVector();
    local math_asin_ret = math.asin(v67.Y);
    local math_clamp_ret = math.clamp(p66.Y, math_asin_ret + -1.3962634015954636, math_asin_ret + 1.3962634015954636);
    local Vector2_new_ret = Vector2.new(p66.X, math_clamp_ret);
    local CFrame_new_ret = CFrame.new(Vector3.new(0, 0, 0), v67);

    return CFrame.Angles(0, -Vector2_new_ret.X, 0) * CFrame_new_ret * CFrame.Angles(-Vector2_new_ret.Y, 0, 0);
end;

function u2.CalculateNewLookVectorFromArg(p68: table, p69: vector?, p70) -- Line: 766
    return p68:CalculateNewLookCFrameFromArg(p69, p70).LookVector;
end;

function u2.CalculateNewLookVectorVRFromArg(p71: table, p72) -- Line: 771
    local unit = ((p71:GetSubjectPosition() - game.Workspace.CurrentCamera.CFrame.Position) * Vector3.new(1, 0, 1)).unit;
    local Vector2_new_ret = Vector2.new(p72.X, 0);
    local CFrame_new_ret = CFrame.new(Vector3.new(0, 0, 0), unit);

    return ((CFrame.Angles(0, -Vector2_new_ret.X, 0) * CFrame_new_ret * CFrame.Angles(-Vector2_new_ret.Y, 0, 0)).LookVector * Vector3.new(1, 0, 1)).unit;
end;

function u2.GetHumanoid(p73) -- Line: 781
    -- upvalues: LocalPlayer (copy)
    local v74 = LocalPlayer and LocalPlayer.Character;

    if not v74 then
        return nil;
    end;

    local v75 = p73.humanoidCache[LocalPlayer];

    if v75 and v75.Parent == v74 then
        return v75;
    end;

    p73.humanoidCache[LocalPlayer] = nil;
    local v76 = v74:FindFirstChildOfClass("Humanoid");

    if v76 then
        p73.humanoidCache[LocalPlayer] = v76;
    end;

    return v76;
end;

function u2.OnNewCameraSubject(p77) -- Line: 799
    if p77.subjectStateChangedConn then
        p77.subjectStateChangedConn:Disconnect();
        p77.subjectStateChangedConn = nil;
    end;
end;

function u2.IsInFirstPerson(p78) -- Line: 806
    return p78.inFirstPerson;
end;

function u2.Update(p79, p80) -- Line: 810
    error("BaseCamera:Update() This is a virtual function that should never be getting called.", 2);
end;

function u2.GetCameraHeight(p81) -- Line: 814
    -- upvalues: VRService (copy)
    return (not VRService.VREnabled or p81.inFirstPerson) and 0 or 0.25881904510252074 * p81.currentSubjectDistance;
end;

return u2;
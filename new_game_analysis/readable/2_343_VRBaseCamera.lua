-- Decompiled with Potassium's decompiler.

local VRService = game:GetService("VRService");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local Lighting = game:GetService("Lighting");
local RunService = game:GetService("RunService");
local UserGameSettings = UserSettings():GetService("UserGameSettings");
local CameraInput = require(script.Parent:WaitForChild("CameraInput"));
local ZoomController = require(script.Parent:WaitForChild("ZoomController"));
local UserFlag = require(script.Parent.Parent:WaitForChild("CommonUtils")).get("FlagUtil").getUserFlag("UserVRRemoveLuaEdgeBlur");
local CameraGamepadResetAction = script.Parent.Parent:WaitForChild("InputContexts"):WaitForChild("CameraContext"):WaitForChild("CameraGamepadResetAction");
local BaseCamera = require(script.Parent:WaitForChild("BaseCamera"));
local u1 = setmetatable({}, BaseCamera);
u1.__index = u1;

function u1.new() -- Line: 38
    -- upvalues: BaseCamera (copy), u1 (copy), CameraGamepadResetAction (copy)
    local v2 = BaseCamera.new();
    local u3 = setmetatable(v2, u1);
    u3.gamepadZoomLevels = { 0, 7 };
    u3.headScale = 1;
    u3:SetCameraToSubjectDistance(7);
    u3.VRFadeResetTimer = 0;
    u3.VREdgeBlurTimer = 0;
    u3.needsReset = true;
    u3.recentered = false;
    u3.gamepadResetConnection = CameraGamepadResetAction.Pressed:Connect(function() -- Line: 57
        -- upvalues: u3 (copy)
        u3:GamepadReset();
    end);
    u3:Reset();

    return u3;
end;

function u1.Reset(p4) -- Line: 67
    p4.stepRotateTimeout = 0;
end;

function u1.GetModuleName(p5) -- Line: 71
    return "VRBaseCamera";
end;

function u1.GamepadZoomPress(p6) -- Line: 75
    -- upvalues: BaseCamera (copy)
    BaseCamera.GamepadZoomPress(p6);
    p6:GamepadReset();
    p6:ResetZoom();
end;

function u1.GamepadReset(p7) -- Line: 83
    p7.stepRotateTimeout = 0;
    p7.needsReset = true;
end;

function u1.ResetZoom(p8) -- Line: 88
    -- upvalues: ZoomController (copy)
    ZoomController.SetZoomParameters(p8.currentSubjectDistance, 0);
    ZoomController.ReleaseSpring();
end;

function u1.OnEnabledChanged(u9) -- Line: 93
    -- upvalues: BaseCamera (copy), CameraGamepadResetAction (copy), VRService (copy), UserFlag (copy), LocalPlayer (copy), Lighting (copy)
    BaseCamera.OnEnabledChanged(u9);

    if u9.enabled then
        CameraGamepadResetAction.Enabled = true;
        u9.thirdPersonOptionChanged = VRService:GetPropertyChangedSignal("ThirdPersonFollowCamEnabled"):Connect(function() -- Line: 100
            -- upvalues: u9 (copy)
            u9:Reset();
        end);
        u9.vrRecentered = VRService.UserCFrameChanged:Connect(function(p10, p11) -- Line: 104
            -- upvalues: u9 (copy)
            if p10 == Enum.UserCFrame.Floor then
                u9.recentered = true;
            end;
        end);

        return;
    end;

    if u9.inFirstPerson then
        u9:GamepadZoomPress();
    end;

    if u9.thirdPersonOptionChanged then
        u9.thirdPersonOptionChanged:Disconnect();
        u9.thirdPersonOptionChanged = nil;
    end;

    if u9.vrRecentered then
        u9.vrRecentered:Disconnect();
        u9.vrRecentered = nil;
    end;

    if u9.cameraHeadScaleChangedConn then
        u9.cameraHeadScaleChangedConn:Disconnect();
        u9.cameraHeadScaleChangedConn = nil;
    end;

    CameraGamepadResetAction.Enabled = false;

    if not UserFlag then
        u9.VREdgeBlurTimer = 0;
        u9:UpdateEdgeBlur(LocalPlayer, 1);
    end;

    local VRFade = Lighting:FindFirstChild("VRFade");

    if VRFade then
        VRFade.Brightness = 0;
    end;
end;

function u1.OnCurrentCameraChanged(u12) -- Line: 145
    -- upvalues: BaseCamera (copy)
    BaseCamera.OnCurrentCameraChanged(u12);

    if u12.cameraHeadScaleChangedConn then
        u12.cameraHeadScaleChangedConn:Disconnect();
        u12.cameraHeadScaleChangedConn = nil;
    end;

    local workspace_CurrentCamera = workspace.CurrentCamera;

    if workspace_CurrentCamera then
        u12.cameraHeadScaleChangedConn = workspace_CurrentCamera:GetPropertyChangedSignal("HeadScale"):Connect(function() -- Line: 157
            -- upvalues: u12 (copy)
            u12:OnHeadScaleChanged();
        end);
        u12:OnHeadScaleChanged();
    end;
end;

function u1.OnHeadScaleChanged(p13) -- Line: 162
    local HeadScale = workspace.CurrentCamera.HeadScale;

    for i, v in p13.gamepadZoomLevels do
        p13.gamepadZoomLevels[i] = v * HeadScale / p13.headScale;
    end;

    p13:SetCameraToSubjectDistance(p13:GetCameraToSubjectDistance() * HeadScale / p13.headScale);
    p13.headScale = HeadScale;
end;

function u1.GetVRFocus(p14, p15, p16) -- Line: 178
    local v17 = p14.lastCameraFocus or p15;
    local x = p14.cameraTranslationConstraints.x;
    local math_min_ret = math.min(1, p14.cameraTranslationConstraints.y + p16);
    p14.cameraTranslationConstraints = Vector3.new(x, math_min_ret, p14.cameraTranslationConstraints.z);
    local CameraHeight = p14:GetCameraHeight();
    local Vector3_new_ret = Vector3.new(0, CameraHeight, 0);

    return CFrame.new(Vector3.new(p15.x, v17.y, p15.z):Lerp(p15 + Vector3_new_ret, p14.cameraTranslationConstraints.y));
end;

function u1.StartFadeFromBlack(p18) -- Line: 194
    -- upvalues: UserGameSettings (copy), Lighting (copy)
    if UserGameSettings.VignetteEnabled == false then
        return;
    end;

    local VRFade = Lighting:FindFirstChild("VRFade");

    if not VRFade then
        VRFade = Instance.new("ColorCorrectionEffect");
        VRFade.Name = "VRFade";
        VRFade.Parent = Lighting;
    end;

    VRFade.Brightness = -1;
    p18.VRFadeResetTimer = 0.1;
end;

function u1.UpdateFadeFromBlack(p19: table, p20: number) -- Line: 209
    -- upvalues: Lighting (copy)
    local VRFade = Lighting:FindFirstChild("VRFade");

    if p19.VRFadeResetTimer > 0 then
        p19.VRFadeResetTimer = math.max(p19.VRFadeResetTimer - p20, 0);
        local VRFade2 = Lighting:FindFirstChild("VRFade");

        if VRFade2 and VRFade2.Brightness < 0 then
            VRFade2.Brightness = math.min(VRFade2.Brightness + p20 * 10, 0);
        end;
    elseif VRFade then
        VRFade.Brightness = 0;
    end;
end;

function u1.StartVREdgeBlur(p21, p22, p23) -- Line: 225
    -- upvalues: UserGameSettings (copy), RunService (copy), VRService (copy)
    if not p23 and UserGameSettings.VignetteEnabled == false then
        return;
    end;

    local VRBlurPart = workspace.CurrentCamera:FindFirstChild("VRBlurPart");

    if not VRBlurPart then
        VRBlurPart = Instance.new("Part");
        VRBlurPart.Name = "VRBlurPart";
        VRBlurPart.Parent = workspace.CurrentCamera;
        VRBlurPart.CanTouch = false;
        VRBlurPart.CanCollide = false;
        VRBlurPart.CanQuery = false;
        VRBlurPart.Anchored = true;
        VRBlurPart.Size = Vector3.new(0.44, 0.47, 1);
        VRBlurPart.Transparency = 1;
        VRBlurPart.CastShadow = false;
        RunService.RenderStepped:Connect(function(p24) -- Line: 245
            -- upvalues: VRService (ref), VRBlurPart (ref)
            local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head);
            local v25 = workspace.CurrentCamera.CFrame * (CFrame.new(UserCFrame.Position * workspace.CurrentCamera.HeadScale) * (UserCFrame - UserCFrame.Position));
            VRBlurPart.CFrame = v25 * CFrame.Angles(0, 3.141592653589793, 0) + v25.LookVector * (1.05 * workspace.CurrentCamera.HeadScale);
            VRBlurPart.Size = Vector3.new(0.44, 0.47, 1) * workspace.CurrentCamera.HeadScale;
        end);
    end;

    local VRBlurScreen = p22.PlayerGui:FindFirstChild("VRBlurScreen");
    local v26;

    if VRBlurScreen then
        v26 = VRBlurScreen:FindFirstChild("VRBlur");
    else
        v26 = nil;
    end;

    if not v26 then
        local v27 = VRBlurScreen or Instance.new("SurfaceGui");
        v27.Name = "VRBlurScreen";
        v27.Parent = p22.PlayerGui;
        v27.Adornee = VRBlurPart;
        v26 = Instance.new("ImageLabel");
        v26.Name = "VRBlur";
        v26.Parent = v27;
        v26.Image = "rbxasset://textures/ui/VR/edgeBlur.png";
        v26.AnchorPoint = Vector2.new(0.5, 0.5);
        v26.Position = UDim2.new(0.5, 0, 0.5, 0);
        v26.Size = UDim2.fromScale(workspace.CurrentCamera.ViewportSize.X * 2.3 / 512, workspace.CurrentCamera.ViewportSize.Y * 2.3 / 512);
        v26.BackgroundTransparency = 1;
        v26.Active = true;
        v26.ScaleType = Enum.ScaleType.Stretch;
    end;

    v26.Visible = true;
    v26.ImageTransparency = 0;
    p21.VREdgeBlurTimer = 0.14;
end;

function u1.UpdateEdgeBlur(p28, p29, p30) -- Line: 294
    local VRBlurScreen = p29.PlayerGui:FindFirstChild("VRBlurScreen");
    local v31;

    if VRBlurScreen then
        v31 = VRBlurScreen:FindFirstChild("VRBlur");
    else
        v31 = nil;
    end;

    if v31 then
        if p28.VREdgeBlurTimer > 0 then
            p28.VREdgeBlurTimer = p28.VREdgeBlurTimer - p30;
            local VRBlurScreen2 = p29.PlayerGui:FindFirstChild("VRBlurScreen");
            local v32 = VRBlurScreen2 and VRBlurScreen2:FindFirstChild("VRBlur");

            if v32 then
                v32.ImageTransparency = 1 - math.clamp(p28.VREdgeBlurTimer, 0.01, 0.14) * 7.142857142857142;
            end;
        else
            v31.Visible = false;
        end;
    end;
end;

function u1.GetCameraHeight(p33) -- Line: 319
    return p33.inFirstPerson and 0 or 0.25881904510252074 * p33.currentSubjectDistance;
end;

function u1.GetSubjectCFrame(p34) -- Line: 326
    -- upvalues: BaseCamera (copy)
    local SubjectCFrame = BaseCamera.GetSubjectCFrame(p34);
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if workspace_CurrentCamera then
        workspace_CurrentCamera = workspace_CurrentCamera.CameraSubject;
    end;

    if not workspace_CurrentCamera then
        return SubjectCFrame;
    end;

    if workspace_CurrentCamera:IsA("Humanoid") and (workspace_CurrentCamera:GetState() == Enum.HumanoidStateType.Dead and workspace_CurrentCamera == p34.lastSubject) then
        SubjectCFrame = p34.lastSubjectCFrame;
    end;

    if SubjectCFrame then
        p34.lastSubjectCFrame = SubjectCFrame;
    end;

    return SubjectCFrame;
end;

function u1.GetSubjectPosition(p35) -- Line: 352
    -- upvalues: BaseCamera (copy)
    local SubjectPosition = BaseCamera.GetSubjectPosition(p35);
    local CurrentCamera = game.Workspace.CurrentCamera;

    if CurrentCamera then
        CurrentCamera = CurrentCamera.CameraSubject;
    end;

    if not CurrentCamera then
        return nil;
    end;

    if CurrentCamera:IsA("Humanoid") then
        if CurrentCamera:GetState() == Enum.HumanoidStateType.Dead and CurrentCamera == p35.lastSubject then
            SubjectPosition = p35.lastSubjectPosition;
        end;
    elseif CurrentCamera:IsA("VehicleSeat") then
        SubjectPosition = CurrentCamera.CFrame.Position + CurrentCamera.CFrame:vectorToWorldSpace(Vector3.new(0, 4, 0));
    end;

    p35.lastSubjectPosition = SubjectPosition;

    return SubjectPosition;
end;

function u1.getRotation(p36, p37) -- Line: 381
    -- upvalues: CameraInput (copy), UserGameSettings (copy)
    local Rotation = CameraInput.getRotation(p37);

    if UserGameSettings.VRSmoothRotationEnabled then
        return Rotation.X;
    end;

    if math.abs(Rotation.X) > 0.03 then
        if p36.stepRotateTimeout > 0 then
            p36.stepRotateTimeout = p36.stepRotateTimeout - p37;
        end;

        if p36.stepRotateTimeout <= 0 then
            local v38 = (Rotation.X < 0 and -1 or 1) * 0.5235987755982988;
            p36:StartFadeFromBlack();
            p36.stepRotateTimeout = 0.25;

            return v38;
        end;
    elseif math.abs(Rotation.X) < 0.02 then
        p36.stepRotateTimeout = 0;
    end;

    return 0;
end;

function u1.HandleSubjectDistance(p39, p40) -- Line: 416
    if p40 and (p40.IsInFirstPerson and p40:IsInFirstPerson()) then
        p39:SetCameraToSubjectDistance(0);
    end;
end;

return u1;
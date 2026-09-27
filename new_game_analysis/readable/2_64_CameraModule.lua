-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local Camera_Traffic_Handler = require(game:GetService("ReplicatedStorage"):WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Controllers"):WaitForChild("Camera_Traffic_Handler"));
local u2 = { "CameraMinZoomDistance", "CameraMaxZoomDistance", "CameraMode", "DevCameraOcclusionMode", "DevComputerCameraMode", "DevTouchCameraMode", "DevComputerMovementMode", "DevTouchMovementMode", "DevEnableMouseLock" };
local u3 = { "ComputerCameraMovementMode", "ComputerMovementMode", "ControlMode", "GamepadCameraSensitivity", "MouseSensitivity", "RotationType", "TouchCameraMovementMode", "TouchMovementMode" };
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
local VRService = game:GetService("VRService");
local UserGameSettings = UserSettings():GetService("UserGameSettings");
local CommonUtils = require(script.Parent:WaitForChild("CommonUtils"));
local u4 = CommonUtils.get("ConnectionUtil");
local v5 = CommonUtils.get("FlagUtil");
local CameraUtils = require(script:WaitForChild("CameraUtils"));
local CameraInput = require(script:WaitForChild("CameraInput"));
local ClassicCamera = require(script:WaitForChild("ClassicCamera"));
local OrbitalCamera = require(script:WaitForChild("OrbitalCamera"));
local LegacyCamera = require(script:WaitForChild("LegacyCamera"));
local VehicleCamera = require(script:WaitForChild("VehicleCamera"));
local VRCamera = require(script:WaitForChild("VRCamera"));
local VRVehicleCamera = require(script:WaitForChild("VRVehicleCamera"));
local Invisicam = require(script:WaitForChild("Invisicam"));
local Poppercam = require(script:WaitForChild("Poppercam"));
local TransparencyController = require(script:WaitForChild("TransparencyController"));
local MouseLockController = require(script:WaitForChild("MouseLockController"));
local u6 = {};
local u7 = {};

if not Players.LocalPlayer then
    return {};
end;

assert(Players.LocalPlayer, "Strict typing check");
local PlayerScripts = Players.LocalPlayer:WaitForChild("PlayerScripts");
PlayerScripts:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Default);
PlayerScripts:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Follow);
PlayerScripts:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Classic);
PlayerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Default);
PlayerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Follow);
PlayerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Classic);
PlayerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.CameraToggle);
local UserFlag = v5.getUserFlag("UserPlayerConnectionMemoryLeak");
local UserFlag2 = v5.getUserFlag("UserPSFixCameraControllerReset");

function u1.new() -- Line: 149
    -- upvalues: TransparencyController (copy), UserFlag (copy), u4 (copy), u1 (copy), Players (copy), MouseLockController (copy), Camera_Traffic_Handler (copy), u2 (copy), u3 (copy), UserGameSettings (copy), UserInputService (copy)
    local v8 = {
        activeTransparencyController = TransparencyController.new()
    };
    local v9;

    if UserFlag then
        v9 = u4.new();
    else
        v9 = nil;
    end;

    v8.connectionUtil = v9;
    local u10 = setmetatable(v8, u1);
    u10.activeCameraController = nil;
    u10.activeOcclusionModule = nil;
    u10.activeMouseLockController = nil;
    u10.currentComputerCameraMovementMode = nil;
    u10.cameraSubjectChangedConn = nil;
    u10.cameraTypeChangedConn = nil;

    for _, v in pairs(Players:GetPlayers()) do
        u10:OnPlayerAdded(v);
    end;

    Players.PlayerAdded:Connect(function(p11) -- Line: 172
        -- upvalues: u10 (copy)
        u10:OnPlayerAdded(p11);
    end);

    if UserFlag then
        Players.PlayerRemoving:Connect(function(p12) -- Line: 177
            -- upvalues: u10 (copy)
            u10:OnPlayerRemoving(p12);
        end);
    end;

    u10.activeTransparencyController:Enable(true);
    u10.activeMouseLockController = MouseLockController.new();
    assert(u10.activeMouseLockController, "Strict typing check");
    local BindableToggleEvent = u10.activeMouseLockController:GetBindableToggleEvent();

    if BindableToggleEvent then
        BindableToggleEvent:Connect(function() -- Line: 189
            -- upvalues: u10 (copy)
            u10:OnMouseLockToggled();
        end);
    end;

    u10:ActivateCameraController();
    u10:ActivateOcclusionModule(Players.LocalPlayer.DevCameraOcclusionMode);
    u10:OnCurrentCameraChanged();
    Camera_Traffic_Handler.Updated.Event:Connect(function() -- Line: 198
        -- upvalues: u10 (copy)
        if u10.activeCameraController then
            u10.activeCameraController:UpdateMouseBehavior();
        end;
    end);

    for _, v in pairs(u2) do
        Players.LocalPlayer:GetPropertyChangedSignal(v):Connect(function() -- Line: 205
            -- upvalues: u10 (copy), v (copy)
            u10:OnLocalPlayerCameraPropertyChanged(v);
        end);
    end;

    for _, v in pairs(u3) do
        UserGameSettings:GetPropertyChangedSignal(v):Connect(function() -- Line: 211
            -- upvalues: u10 (copy), v (copy)
            u10:OnUserGameSettingsPropertyChanged(v);
        end);
    end;

    game.Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- Line: 215
        -- upvalues: u10 (copy)
        u10:OnCurrentCameraChanged();
    end);
    UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- Line: 218
        -- upvalues: u10 (copy)
        u10:OnPreferredInputChanged();
    end);

    return u10;
end;

function u1.GetCameraMovementModeFromSettings(p13) -- Line: 225
    -- upvalues: Players (copy), CameraUtils (copy), UserInputService (copy), UserGameSettings (copy)
    if Players.LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
        return CameraUtils.ConvertCameraModeEnumToStandard(Enum.ComputerCameraMovementMode.Classic);
    end;

    local v14, v15;

    if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
        v14 = CameraUtils.ConvertCameraModeEnumToStandard(Players.LocalPlayer.DevTouchCameraMode);
        v15 = CameraUtils.ConvertCameraModeEnumToStandard(UserGameSettings.TouchCameraMovementMode);
    else
        v14 = CameraUtils.ConvertCameraModeEnumToStandard(Players.LocalPlayer.DevComputerCameraMode);
        v15 = CameraUtils.ConvertCameraModeEnumToStandard(UserGameSettings.ComputerCameraMovementMode);
    end;

    if v14 == Enum.DevComputerCameraMovementMode.UserChoice then
        return v15;
    end;

    return v14;
end;

function u1.ActivateOcclusionModule(p16, p17) -- Line: 250
    -- upvalues: Poppercam (copy), Invisicam (copy), u7 (copy), Players (copy)
    local v18;

    if p17 == Enum.DevCameraOcclusionMode.Zoom then
        v18 = Poppercam;
    else
        if p17 ~= Enum.DevCameraOcclusionMode.Invisicam then
            warn("CameraScript ActivateOcclusionModule called with unsupported mode");

            return;
        end;

        v18 = Invisicam;
    end;

    p16.occlusionMode = p17;

    if p16.activeOcclusionModule and p16.activeOcclusionModule:GetOcclusionMode() == p17 then
        if not p16.activeOcclusionModule:GetEnabled() then
            p16.activeOcclusionModule:Enable(true);
        end;

        return;
    end;

    local activeOcclusionModule = p16.activeOcclusionModule;
    p16.activeOcclusionModule = u7[v18];

    if not p16.activeOcclusionModule then
        p16.activeOcclusionModule = v18.new();

        if p16.activeOcclusionModule then
            u7[v18] = p16.activeOcclusionModule;
        end;
    end;

    if p16.activeOcclusionModule then
        if p16.activeOcclusionModule:GetOcclusionMode() ~= p17 then
            warn("CameraScript ActivateOcclusionModule mismatch: ", p16.activeOcclusionModule:GetOcclusionMode(), "~=", p17);
        end;

        if activeOcclusionModule then
            if activeOcclusionModule == p16.activeOcclusionModule then
                warn("CameraScript ActivateOcclusionModule failure to detect already running correct module");
            else
                activeOcclusionModule:Enable(false);
            end;
        end;

        if p17 == Enum.DevCameraOcclusionMode.Invisicam then
            if Players.LocalPlayer.Character then
                p16.activeOcclusionModule:CharacterAdded(Players.LocalPlayer.Character, Players.LocalPlayer);
            end;
        else
            for _, v in pairs(Players:GetPlayers()) do
                if v and v.Character then
                    p16.activeOcclusionModule:CharacterAdded(v.Character, v);
                end;
            end;

            p16.activeOcclusionModule:OnCameraSubjectChanged(game.Workspace.CurrentCamera.CameraSubject);
        end;

        p16.activeOcclusionModule:Enable(true);
    end;
end;

function u1.ShouldUseVehicleCamera(p19) -- Line: 329
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if not workspace_CurrentCamera then
        return false;
    end;

    local CameraType = workspace_CurrentCamera.CameraType;
    local CameraSubject = workspace_CurrentCamera.CameraSubject;
    local v20 = CameraType == Enum.CameraType.Custom and true or CameraType == Enum.CameraType.Follow;
    local v21 = CameraSubject and CameraSubject:IsA("VehicleSeat") or false;
    local v22 = p19.occlusionMode ~= Enum.DevCameraOcclusionMode.Invisicam;

    if v21 then
        if not v20 then
            v22 = v20;
        end;
    else
        v22 = v21;
    end;

    return v22;
end;

function u1.ActivateCameraController(p23) -- Line: 345
    -- upvalues: LegacyCamera (copy), VRService (copy), VRCamera (copy), ClassicCamera (copy), OrbitalCamera (copy), VRVehicleCamera (copy), VehicleCamera (copy), u6 (copy), UserFlag2 (copy)
    local CameraType = workspace.CurrentCamera.CameraType;
    local CameraMovementModeFromSettings = p23:GetCameraMovementModeFromSettings();
    local v24 = nil;

    if CameraType == Enum.CameraType.Scriptable then
        if p23.activeCameraController then
            p23.activeCameraController:Enable(false);
            p23.activeCameraController = nil;
        end;

        return;
    end;

    if CameraType == Enum.CameraType.Custom then
        CameraMovementModeFromSettings = p23:GetCameraMovementModeFromSettings();
    elseif CameraType == Enum.CameraType.Track then
        CameraMovementModeFromSettings = Enum.ComputerCameraMovementMode.Classic;
    elseif CameraType == Enum.CameraType.Follow then
        CameraMovementModeFromSettings = Enum.ComputerCameraMovementMode.Follow;
    elseif CameraType == Enum.CameraType.Orbital then
        CameraMovementModeFromSettings = Enum.ComputerCameraMovementMode.Orbital;
    elseif CameraType == Enum.CameraType.Attach or (CameraType == Enum.CameraType.Watch or CameraType == Enum.CameraType.Fixed) then
        v24 = LegacyCamera;
    else
        warn("CameraScript encountered an unhandled Camera.CameraType value: ", CameraType);
    end;

    if not v24 then
        if VRService.VREnabled then
            v24 = VRCamera;
        elseif CameraMovementModeFromSettings == Enum.ComputerCameraMovementMode.Classic or (CameraMovementModeFromSettings == Enum.ComputerCameraMovementMode.Follow or (CameraMovementModeFromSettings == Enum.ComputerCameraMovementMode.Default or CameraMovementModeFromSettings == Enum.ComputerCameraMovementMode.CameraToggle)) then
            v24 = ClassicCamera;
        else
            if CameraMovementModeFromSettings ~= Enum.ComputerCameraMovementMode.Orbital then
                warn("ActivateCameraController did not select a module.");

                return;
            end;

            v24 = OrbitalCamera;
        end;
    end;

    if p23:ShouldUseVehicleCamera() then
        if VRService.VREnabled then
            v24 = VRVehicleCamera;
        else
            v24 = VehicleCamera;
        end;
    end;

    local v25;

    if u6[v24] then
        v25 = u6[v24];

        if UserFlag2 then
            if v25.Reset and p23.activeCameraController ~= v25 then
                v25:Reset();
            end;
        elseif v25.Reset then
            v25:Reset();
        end;
    else
        v25 = v24.new();
        u6[v24] = v25;
    end;

    if p23.activeCameraController then
        if p23.activeCameraController == v25 then
            if not p23.activeCameraController:GetEnabled() then
                p23.activeCameraController:Enable(true);
            end;
        else
            if v25.HandleSubjectDistance then
                v25:HandleSubjectDistance(p23.activeCameraController);
            end;

            p23.activeCameraController:Enable(false);
            p23.activeCameraController = v25;
            p23.activeCameraController:Enable(true);
        end;
    elseif v25 ~= nil then
        p23.activeCameraController = v25;
        assert(p23.activeCameraController, "Strict typing check");
        p23.activeCameraController:Enable(true);
    end;

    if p23.activeCameraController then
        p23.activeCameraController:SetCameraMovementMode(CameraMovementModeFromSettings);
        p23.activeCameraController:SetCameraType(CameraType);
    end;
end;

function u1.OnCameraSubjectChanged(p26) -- Line: 454
    local workspace_CurrentCamera = workspace.CurrentCamera;
    local v27;

    if workspace_CurrentCamera then
        v27 = workspace_CurrentCamera.CameraSubject;
    else
        v27 = nil;
    end;

    if p26.activeTransparencyController then
        p26.activeTransparencyController:SetSubject(v27);
    end;

    if p26.activeOcclusionModule then
        p26.activeOcclusionModule:OnCameraSubjectChanged(v27);
    end;

    p26:ActivateCameraController();
end;

function u1.OnCameraTypeChanged(p28, p29) -- Line: 469
    -- upvalues: UserInputService (copy), CameraUtils (copy)
    if p29 == Enum.CameraType.Scriptable and UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
        CameraUtils.restoreMouseBehavior();
    end;

    p28:ActivateCameraController();
end;

function u1.OnCurrentCameraChanged(u30) -- Line: 481
    local CurrentCamera = game.Workspace.CurrentCamera;

    if not CurrentCamera then
        return;
    end;

    if u30.cameraSubjectChangedConn then
        u30.cameraSubjectChangedConn:Disconnect();
    end;

    if u30.cameraTypeChangedConn then
        u30.cameraTypeChangedConn:Disconnect();
    end;

    u30.cameraSubjectChangedConn = CurrentCamera:GetPropertyChangedSignal("CameraSubject"):Connect(function() -- Line: 493
        -- upvalues: u30 (copy)
        u30:OnCameraSubjectChanged();
    end);
    u30.cameraTypeChangedConn = CurrentCamera:GetPropertyChangedSignal("CameraType"):Connect(function() -- Line: 497
        -- upvalues: u30 (copy), CurrentCamera (copy)
        u30:OnCameraTypeChanged(CurrentCamera.CameraType);
    end);
    u30:OnCameraSubjectChanged();
    u30:OnCameraTypeChanged(CurrentCamera.CameraType);
end;

function u1.OnLocalPlayerCameraPropertyChanged(p31: table, p32: string) -- Line: 505
    -- upvalues: Players (copy)
    if p32 == "CameraMode" then
        if Players.LocalPlayer.CameraMode ~= Enum.CameraMode.LockFirstPerson then
            if Players.LocalPlayer.CameraMode == Enum.CameraMode.Classic then
                p31:ActivateCameraController();

                return;
            end;

            warn("Unhandled value for property player.CameraMode: ", Players.LocalPlayer.CameraMode);

            return;
        end;

        if not p31.activeCameraController or p31.activeCameraController:GetModuleName() ~= "ClassicCamera" then
            p31:ActivateCameraController();
        end;

        if p31.activeCameraController then
            p31.activeCameraController:UpdateForDistancePropertyChange();
        end;
    else
        if p32 == "DevComputerCameraMode" or p32 == "DevTouchCameraMode" then
            p31:ActivateCameraController();

            return;
        end;

        if p32 == "DevCameraOcclusionMode" then
            p31:ActivateOcclusionModule(Players.LocalPlayer.DevCameraOcclusionMode);

            return;
        end;

        if p32 == "CameraMinZoomDistance" or p32 == "CameraMaxZoomDistance" then
            if p31.activeCameraController then
                p31.activeCameraController:UpdateForDistancePropertyChange();
            end;
        else
            if p32 == "DevTouchMovementMode" then
                return;
            end;

            if p32 == "DevComputerMovementMode" then
                return;
            end;

            local _ = p32 == "DevEnableMouseLock";
        end;
    end;
end;

function u1.OnUserGameSettingsPropertyChanged(p33: table, p34: string) -- Line: 547
    if p34 == "ComputerCameraMovementMode" then
        p33:ActivateCameraController();
    end;
end;

function u1.OnPreferredInputChanged(p35) -- Line: 553
    p35:ActivateCameraController();
end;

function u1.Update(p36, p37, p38) -- Line: 563
    -- upvalues: CameraInput (copy)
    if p36.activeCameraController then
        p36.activeCameraController:UpdateMouseBehavior();
        local v39, v40 = p36.activeCameraController:Update(p38);
        CameraInput.resetAssistRotation();

        if p36.activeOcclusionModule and not p36.activeCameraController.skipOcclusion then
            v39, v40 = p36.activeOcclusionModule:Update(p38, v39, v40);
        end;

        local CurrentCamera = game.Workspace.CurrentCamera;
        CurrentCamera.CFrame = v39;
        CurrentCamera.Focus = v40;

        if p36.activeTransparencyController then
            p36.activeTransparencyController:Update(p38);
        end;
    end;
end;

function u1.OnCharacterAdded(p41: table, p42: userdata, p43: userdata) -- Line: 587
    if p41.activeOcclusionModule then
        p41.activeOcclusionModule:CharacterAdded(p42, p43);
    end;
end;

function u1.OnCharacterRemoving(p44, p45, p46) -- Line: 593
    if p44.activeOcclusionModule then
        p44.activeOcclusionModule:CharacterRemoving(p45, p46);
    end;
end;

function u1.OnPlayerAdded(u47: table, u48: userdata) -- Line: 599
    -- upvalues: UserFlag (copy)
    if UserFlag then
        if u47.connectionUtil then
            u47.connectionUtil:trackConnection(`{u48.UserId}CharacterAdded`, u48.CharacterAdded:Connect(function(p49) -- Line: 603
                -- upvalues: u47 (copy), u48 (copy)
                u47:OnCharacterAdded(p49, u48);
            end));
            u47.connectionUtil:trackConnection(`{u48.UserId}CharacterRemoving`, u48.CharacterRemoving:Connect(function(p50) -- Line: 606
                -- upvalues: u47 (copy), u48 (copy)
                u47:OnCharacterRemoving(p50, u48);
            end));
        end;
    else
        u48.CharacterAdded:Connect(function(p51) -- Line: 611
            -- upvalues: u47 (copy), u48 (copy)
            u47:OnCharacterAdded(p51, u48);
        end);
        u48.CharacterRemoving:Connect(function(p52) -- Line: 614
            -- upvalues: u47 (copy), u48 (copy)
            u47:OnCharacterRemoving(p52, u48);
        end);
    end;
end;

function u1.OnPlayerRemoving(p53: table, p54: userdata) -- Line: 620
    if p53.connectionUtil then
        p53.connectionUtil:disconnect((`{p54.UserId}CharacterAdded`));
        p53.connectionUtil:disconnect((`{p54.UserId}CharacterRemoving`));
    end;
end;

function u1.OnMouseLockToggled(p55) -- Line: 628
    if p55.activeMouseLockController then
        local IsMouseLocked = p55.activeMouseLockController:GetIsMouseLocked();
        local MouseLockOffset = p55.activeMouseLockController:GetMouseLockOffset();

        if p55.activeCameraController then
            p55.activeCameraController:SetIsMouseLocked(IsMouseLocked);
            p55.activeCameraController:SetMouseLockOffset(MouseLockOffset);
        end;
    end;
end;

if RunService:IsClient() then
    return u1.new();
end;

return u1;
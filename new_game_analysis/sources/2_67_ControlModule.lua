-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
local GuiService = game:GetService("GuiService");
local Workspace = game:GetService("Workspace");
game:GetService("StarterPlayer");
local UserGameSettings = UserSettings():GetService("UserGameSettings");
local VRService = game:GetService("VRService");
local ContextActionService = game:GetService("ContextActionService");
local v2 = require(script.Parent:WaitForChild("CommonUtils")).get("FlagUtil");
local UserFlag = v2.getUserFlag("UserPlayerScriptsCCLIntegrationD");
local UserFlag2 = v2.getUserFlag("UserPSSpecifySimulationFrequency");
local UserFlag3 = v2.getUserFlag("UserPlayerScriptsBindActivateOnIAS");
local UserFlag4 = v2.getUserFlag("UserPlayerScriptsFireThroughScriptableBindings");
local UserFlag5 = v2.getUserFlag("UserPlayerScriptsUseReplicatedCameraAPI");
local UserFlag6 = v2.getUserFlag("UserPlayerScriptsStopFireCameraAction");
local UserFlag7 = v2.getUserFlag("UserPlayerScriptsSAuthDirectAPIs2");
local UserFlag8 = v2.getUserFlag("UserPlayerScriptsPlayerControlState2");
local UserFlag9 = v2.getUserFlag("UserPlayerScriptsFixSAuthRenderStepMove");
local UserFlag10 = v2.getUserFlag("UserPlayerScriptsSupportMicroGamepad");
local UserFlag11 = v2.getUserFlag("UserAbilitiesUserInterfaceC");
local ActionController = require(script:WaitForChild("ActionController"));
local u3;

if UserFlag or UserFlag8 then
    u3 = require(script:WaitForChild("InputReplication"));
else
    u3 = nil;
end;

local u4;

if UserFlag then
    u4 = require(script:WaitForChild("InputSlots"));
else
    u4 = nil;
end;

local u5;

if RunService:IsClient() then
    u5 = require(script:WaitForChild("DynamicThumbstick"));
else
    u5 = nil;
end;

local ClassicThumbstick = require(script:WaitForChild("ClassicThumbstick"));
local ClickToMoveController = require(script:WaitForChild("ClickToMoveController"));
local TouchJump = require(script:WaitForChild("TouchJump"));
local u6;

if UserFlag then
    u6 = require(script:WaitForChild("TouchAbilities"));
else
    u6 = nil;
end;

local VehicleController = require(script:WaitForChild("VehicleController"));
local u7, u8;

if UserFlag then
    u7 = require(script:WaitForChild("AvatarAbilitiesInterface"));
    u8 = u7.get(Players.LocalPlayer);
else
    u8 = nil;
    u7 = nil;
end;

local CameraRotationAction = script.Parent:WaitForChild("InputContexts"):WaitForChild("CameraContext"):WaitForChild("CameraRotationAction");
local _ = Enum.ContextActionPriority.Medium.Value;
local u9 = {
    [Enum.TouchMovementMode.DPad] = u5,
    [Enum.DevTouchMovementMode.DPad] = u5,
    [Enum.TouchMovementMode.Thumbpad] = u5,
    [Enum.DevTouchMovementMode.Thumbpad] = u5,
    [Enum.TouchMovementMode.Thumbstick] = ClassicThumbstick,
    [Enum.DevTouchMovementMode.Thumbstick] = ClassicThumbstick,
    [Enum.TouchMovementMode.DynamicThumbstick] = u5,
    [Enum.DevTouchMovementMode.DynamicThumbstick] = u5,
    [Enum.TouchMovementMode.ClickToMove] = ClickToMoveController,
    [Enum.DevTouchMovementMode.ClickToMove] = ClickToMoveController,
    [Enum.TouchMovementMode.Default] = u5,
    [Enum.ComputerMovementMode.Default] = ActionController,
    [Enum.ComputerMovementMode.KeyboardMouse] = ActionController,
    [Enum.DevComputerMovementMode.KeyboardMouse] = ActionController,
    [Enum.DevComputerMovementMode.Scriptable] = nil,
    [Enum.ComputerMovementMode.ClickToMove] = ClickToMoveController,
    [Enum.DevComputerMovementMode.ClickToMove] = ClickToMoveController
};

function u1.new() -- Line: 100
    -- upvalues: u1 (copy), RunService (copy), Players (copy), VehicleController (copy), UserGameSettings (copy), UserFlag (copy), u8 (ref), GuiService (copy), UserInputService (copy), UserFlag3 (copy), ContextActionService (copy)
    local u10 = setmetatable({}, u1);

    if RunService:IsServer() then
        return u10;
    end;

    u10.controllers = {};
    u10.activeControlModule = nil;
    u10.activeController = nil;
    u10.touchJumpController = nil;
    u10.touchAbilitiesController = nil;
    u10.moveFunction = Players.LocalPlayer.Move;
    u10.humanoid = nil;
    u10.controlsEnabled = true;
    u10.enabled = false;
    u10.humanoidSeatedConn = nil;
    u10.vehicleController = nil;
    u10.touchControlFrame = nil;
    u10.currentTorsoAngle = 0;
    u10.inputMoveVector = Vector3.new(0, 0, 0);
    u10.vehicleController = VehicleController.new();
    Players.LocalPlayer.CharacterAdded:Connect(function(p11) -- Line: 131
        -- upvalues: u10 (copy)
        u10:OnCharacterAdded(p11);
    end);
    Players.LocalPlayer.CharacterRemoving:Connect(function(p12) -- Line: 132
        -- upvalues: u10 (copy)
        u10:OnCharacterRemoving(p12);
    end);

    if Players.LocalPlayer.Character then
        u10:OnCharacterAdded(Players.LocalPlayer.Character);
    end;

    UserGameSettings:GetPropertyChangedSignal("TouchMovementMode"):Connect(function() -- Line: 137
        -- upvalues: u10 (copy)
        u10:UpdateMovementMode();
    end);
    Players.LocalPlayer:GetPropertyChangedSignal("DevTouchMovementMode"):Connect(function() -- Line: 140
        -- upvalues: u10 (copy)
        u10:UpdateMovementMode();
    end);
    UserGameSettings:GetPropertyChangedSignal("ComputerMovementMode"):Connect(function() -- Line: 144
        -- upvalues: u10 (copy)
        u10:UpdateMovementMode();
    end);
    Players.LocalPlayer:GetPropertyChangedSignal("DevComputerMovementMode"):Connect(function() -- Line: 147
        -- upvalues: u10 (copy)
        u10:UpdateMovementMode();
    end);

    if UserFlag then
        u8:GetEnabledChangedSignal():Connect(function() -- Line: 151
            -- upvalues: u10 (copy)
            u10:UpdateAbilitiesControllers();
        end);
    end;

    u10.playerGui = nil;
    u10.touchGui = nil;
    u10.playerGuiAddedConn = nil;
    GuiService:GetPropertyChangedSignal("TouchControlsEnabled"):Connect(function() -- Line: 161
        -- upvalues: u10 (copy)
        u10:UpdateMovementMode();
        u10:UpdateActiveControlModuleEnabled();
    end);
    UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- Line: 166
        -- upvalues: u10 (copy)
        u10:UpdateMovementMode();
    end);
    u10.playerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui");

    if not u10.playerGui then
        u10.playerGuiAddedConn = Players.LocalPlayer.ChildAdded:Connect(function(p13) -- Line: 172
            -- upvalues: u10 (copy)
            if p13:IsA("PlayerGui") then
                u10.playerGui = p13;
                u10.playerGuiAddedConn:Disconnect();
                u10.playerGuiAddedConn = nil;
                u10:UpdateMovementMode();
            end;
        end);
    end;

    if UserFlag3 then
        ContextActionService:BindActivate(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2);
    end;

    return u10;
end;

local function _fireCustomInputs(u14: userdata) -- Line: 190
    -- upvalues: UserFlag7 (copy), UserGameSettings (copy), UserFlag6 (copy), Workspace (copy), UserFlag4 (copy)
    local InputContexts = u14:FindFirstChild("InputContexts");

    if InputContexts == nil then
        return;
    end;

    local CharacterContext = InputContexts:FindFirstChild("CharacterContext");

    if CharacterContext == nil then
        return;
    end;

    local CameraContext = InputContexts:FindFirstChild("CameraContext");

    if UserFlag7 then
        local RotationAction = CharacterContext:FindFirstChild("RotationAction");
        local v15 = RotationAction and RotationAction:FindFirstChild("RotationScriptableBinding");

        if v15 then
            v15:Fire(UserGameSettings.RotationType == Enum.RotationType.CameraRelative);
        end;
    else
        local v16 = true;

        if UserFlag6 then
            local success, result = pcall(function() -- Line: 214
                -- upvalues: u14 (copy)
                return u14:GetCameraState();
            end);

            if success and (result and (result.CFrame ~= CFrame.identity and (result.FieldOfView > 0 and result.ViewportSize.Magnitude > 0))) then
                v16 = false;
            end;
        end;

        if v16 then
            if CameraContext then
                CameraContext = CameraContext:FindFirstChild("CameraAction");
            end;

            if CameraContext then
                local CurrentCamera = Workspace.CurrentCamera;

                if UserFlag4 then
                    local CameraScriptableBinding = CameraContext:FindFirstChild("CameraScriptableBinding");

                    if CameraScriptableBinding then
                        local success, _ = pcall(function() -- Line: 229
                            -- upvalues: CameraScriptableBinding (copy), CurrentCamera (copy)
                            CameraScriptableBinding.Type = Enum.InputBindingType.Scriptable;
                            CameraScriptableBinding:Fire(CurrentCamera.CFrame.LookVector);
                        end);

                        if not success then
                            CameraContext:Fire(CurrentCamera.CFrame.LookVector);
                        end;
                    else
                        CameraContext:Fire(CurrentCamera.CFrame.LookVector);
                    end;
                else
                    CameraContext:Fire(CurrentCamera.CFrame.LookVector);
                end;
            end;
        end;

        if UserFlag4 then
            local RotationAction = CharacterContext:FindFirstChild("RotationAction");

            if RotationAction then
                local RotationScriptableBinding = RotationAction:FindFirstChild("RotationScriptableBinding");

                if not RotationScriptableBinding then
                    RotationAction:Fire(UserGameSettings.RotationType == Enum.RotationType.CameraRelative);

                    return;
                end;

                local success, _ = pcall(function() -- Line: 250
                    -- upvalues: RotationScriptableBinding (copy), UserGameSettings (ref)
                    RotationScriptableBinding.Type = Enum.InputBindingType.Scriptable;
                    RotationScriptableBinding:Fire(UserGameSettings.RotationType == Enum.RotationType.CameraRelative);
                end);

                if not success then
                    RotationAction:Fire(UserGameSettings.RotationType == Enum.RotationType.CameraRelative);
                end;
            end;
        else
            local RotationAction = CharacterContext.RotationAction;

            if RotationAction then
                RotationAction:Fire(UserGameSettings.RotationType == Enum.RotationType.CameraRelative);
            end;
        end;
    end;
end;

local function _cloneInputs(p17: userdata) -- Line: 271
    local v18 = script.Parent.InputContexts:Clone();
    v18.CharacterContext.Enabled = true;
    v18.CameraContext.Enabled = true;
    v18.Parent = p17;
end;

function u1.InitializeServerAuthority(u19) -- Line: 281
    -- upvalues: RunService (copy), UserFlag (copy), Players (copy), u3 (copy), _cloneInputs (copy), UserFlag8 (copy), UserFlag2 (copy), _fireCustomInputs (copy)
    if RunService:IsServer() then
        if UserFlag then
            for _, v in Players:GetPlayers() do
                u3.CloneInputsIfAbsent(v);
            end;

            Players.PlayerAdded:Connect(u3.CloneInputsIfAbsent);
        else
            for _, v in Players:GetPlayers() do
                local v20 = script.Parent.InputContexts:Clone();
                v20.CharacterContext.Enabled = true;
                v20.CameraContext.Enabled = true;
                v20.Parent = v;
            end;

            Players.PlayerAdded:Connect(_cloneInputs);
        end;

        if UserFlag8 then
            for _, v in Players:GetPlayers() do
                u3.createPlayerControlState(v);
            end;

            Players.PlayerAdded:Connect(u3.createPlayerControlState);
        end;

        if UserFlag2 then
            RunService:BindToSimulation(function(p21) -- Line: 303
                -- upvalues: Players (ref), u19 (copy)
                for _, v in Players:GetPlayers() do
                    u19:ProcessInputs(v, p21);
                end;
            end, Enum.StepFrequency.Hz60);
        else
            RunService:BindToSimulation(function(p22) -- Line: 309
                -- upvalues: Players (ref), u19 (copy)
                for _, v in Players:GetPlayers() do
                    u19:ProcessInputs(v, p22);
                end;
            end);
        end;
    else
        if UserFlag8 then
            u3.watchForPlayerControlState(Players.LocalPlayer);
        end;

        RunService:BindToRenderStep("CameraInput", Enum.RenderPriority.Last.Value, function() -- Line: 320
            -- upvalues: UserFlag8 (ref), u3 (ref), Players (ref), u19 (copy), UserFlag (ref), _fireCustomInputs (ref)
            if UserFlag8 then
                u3.writeInputToPCS(Players.LocalPlayer, u19, true);

                return;
            end;

            if UserFlag then
                u3.FireCustomInputs(Players.LocalPlayer);

                return;
            end;

            _fireCustomInputs(Players.LocalPlayer);
        end);

        if UserFlag2 then
            RunService:BindToSimulation(function(p23) -- Line: 331
                -- upvalues: u19 (copy), Players (ref)
                u19:ProcessInputs(Players.LocalPlayer, p23);
            end, Enum.StepFrequency.Hz60);
        else
            RunService:BindToSimulation(function(p24) -- Line: 335
                -- upvalues: u19 (copy), Players (ref)
                u19:ProcessInputs(Players.LocalPlayer, p24);
            end);
        end;
    end;

    if u19.data and u19.data.eventBus then
        u19.data.isServerAuthority = true;
        u19.data.eventBus:publish("SERVER_AUTHORITY_CHANGED", true);
    end;
end;

local function NormalizeAngle(p25) -- Line: 348
    local v26 = (p25 + 12.566370614359172) % 6.283185307179586;

    if v26 > 3.141592653589793 then
        v26 = v26 - 6.283185307179586;
    end;

    return v26;
end;

local function AverageAngle(p27, p28) -- Line: 356
    local v29 = (p28 - p27 + 12.566370614359172) % 6.283185307179586;

    if v29 > 3.141592653589793 then
        v29 = v29 - 6.283185307179586;
    end;

    local v30 = (p27 + v29 / 2 + 12.566370614359172) % 6.283185307179586;

    if v30 > 3.141592653589793 then
        v30 = v30 - 6.283185307179586;
    end;

    return v30;
end;

function u1.GetEstimatedVRTorsoFrame(p31) -- Line: 361
    -- upvalues: VRService (copy)
    local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head);
    local _, v32, _ = UserCFrame:ToEulerAnglesYXZ();
    local v33 = -v32;

    if VRService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand) and VRService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand) then
        local UserCFrame2 = VRService:GetUserCFrame(Enum.UserCFrame.LeftHand);
        local UserCFrame3 = VRService:GetUserCFrame(Enum.UserCFrame.RightHand);
        local v34 = UserCFrame.Position - UserCFrame2.Position;
        local v35 = UserCFrame.Position - UserCFrame3.Position;
        local v36 = -math.atan2(v34.X, v34.Z);
        local v37 = (-math.atan2(v35.X, v35.Z) - v36 + 12.566370614359172) % 6.283185307179586;

        if v37 > 3.141592653589793 then
            v37 = v37 - 6.283185307179586;
        end;

        local v38 = (v36 + v37 / 2 + 12.566370614359172) % 6.283185307179586;

        if v38 > 3.141592653589793 then
            v38 = v38 - 6.283185307179586;
        end;

        local v39 = (v33 - p31.currentTorsoAngle + 12.566370614359172) % 6.283185307179586;

        if v39 > 3.141592653589793 then
            v39 = v39 - 6.283185307179586;
        end;

        local v40 = (v38 - p31.currentTorsoAngle + 12.566370614359172) % 6.283185307179586;

        if v40 > 3.141592653589793 then
            v40 = v40 - 6.283185307179586;
        end;

        local v41;

        if v40 > -1.5707963267948966 then
            v41 = v40 < 1.5707963267948966;
        else
            v41 = false;
        end;

        if not v41 then
            v40 = v39;
        end;

        local math_min_ret = math.min(v40, v39);
        local math_max_ret = math.max(v40, v39);
        local v42 = 0;

        if math_min_ret > 0 then
            math_max_ret = math_min_ret;
        elseif math_max_ret >= 0 then
            math_max_ret = v42;
        end;

        p31.currentTorsoAngle = math_max_ret + p31.currentTorsoAngle;
    else
        p31.currentTorsoAngle = v33;
    end;

    return CFrame.new(UserCFrame.Position) * CFrame.fromEulerAnglesYXZ(0, -p31.currentTorsoAngle, 0);
end;

function u1.GetActiveController(p43) -- Line: 405
    return p43.activeController;
end;

function u1.UpdateAbilitiesControllers(p44) -- Line: 409
    -- upvalues: UserInputService (copy), ClickToMoveController (copy), ClassicThumbstick (copy), u5 (ref), u8 (ref), TouchJump (copy), u6 (copy)
    local v45 = p44.enabled and p44.touchControlFrame;

    if v45 then
        if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
            v45 = (p44.activeControlModule == ClickToMoveController or p44.activeControlModule == ClassicThumbstick) and true or p44.activeControlModule == u5;
        else
            v45 = false;
        end;
    end;

    local v46;

    if v45 then
        v46 = not u8:isEnabled();
    else
        v46 = v45;
    end;

    if v45 then
        v45 = u8:isEnabled();
    end;

    if v46 then
        if not p44.controllers[TouchJump] then
            p44.controllers[TouchJump] = TouchJump.new(p44.data, p44.playerData);
        end;

        p44.touchJumpController = p44.controllers[TouchJump];
        p44.touchJumpController:Enable(true, p44.touchControlFrame);
    elseif p44.touchJumpController then
        p44.touchJumpController:Enable(false);
    end;

    if not v45 then
        if p44.touchAbilitiesController then
            p44.touchAbilitiesController:Enable(false);
        end;

        return;
    end;

    if not p44.controllers[u6] then
        p44.controllers[u6] = u6.new(p44.touchControlFrame);
    end;

    p44.touchAbilitiesController = p44.controllers[u6];
    p44.touchAbilitiesController:Enable(true);
end;

function u1.UpdateActiveControlModuleEnabled(u47) -- Line: 445
    -- upvalues: UserFlag (copy), u8 (ref), Players (copy), UserInputService (copy), ClickToMoveController (copy), ClassicThumbstick (copy), u5 (ref), TouchJump (copy), GuiService (copy)
    local function v48() -- Line: 447
        -- upvalues: UserFlag (ref), u47 (copy), u8 (ref), Players (ref)
        if UserFlag then
            u47.enabled = false;
        end;

        u47.activeController:Enable(false);

        if UserFlag then
            u47:UpdateAbilitiesControllers();
        elseif u47.touchJumpController then
            u47.touchJumpController:Enable(false);
        end;

        if u47.moveFunction and not (UserFlag and u8:isEnabled()) then
            u47.moveFunction(Players.LocalPlayer, Vector3.new(0, 0, 0), true);
        end;
    end;

    local function v49() -- Line: 467
        -- upvalues: UserFlag (ref), u47 (copy), UserInputService (ref), ClickToMoveController (ref), ClassicThumbstick (ref), u5 (ref), TouchJump (ref), Players (ref)
        if UserFlag then
            u47.enabled = true;
            u47:UpdateAbilitiesControllers();
        elseif u47.touchControlFrame and (UserInputService.PreferredInput == Enum.PreferredInput.Touch and (u47.activeControlModule == ClickToMoveController or (u47.activeControlModule == ClassicThumbstick or u47.activeControlModule == u5))) then
            if not u47.controllers[TouchJump] then
                u47.controllers[TouchJump] = TouchJump.new(u47.data, u47.playerData);
            end;

            u47.touchJumpController = u47.controllers[TouchJump];
            u47.touchJumpController:Enable(true, u47.touchControlFrame);
        elseif u47.touchJumpController then
            u47.touchJumpController:Enable(false);
        end;

        if u47.activeControlModule == ClickToMoveController then
            u47.activeController:Enable(true, Players.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice, u47.touchJumpController);

            return;
        end;

        if u47.touchControlFrame then
            u47.activeController:Enable(true, u47.touchControlFrame);

            return;
        end;

        u47.activeController:Enable(true);
    end;

    if not u47.activeController then
        return;
    end;

    if not u47.controlsEnabled then
        v48();

        return;
    end;

    if GuiService.TouchControlsEnabled or (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or u47.activeControlModule ~= ClickToMoveController and (u47.activeControlModule ~= ClassicThumbstick and u47.activeControlModule ~= u5)) then
        v49();

        return;
    end;

    v48();
end;

function u1.Enable(p50: table, p51: boolean?) -- Line: 532
    local v52 = p51 == nil and true or p51;

    if p50.controlsEnabled == v52 then
        return;
    end;

    p50.controlsEnabled = v52;

    if not p50.activeController then
        return;
    end;

    p50:UpdateActiveControlModuleEnabled();
end;

function u1.Disable(p53) -- Line: 547
    p53:Enable(false);
end;

function u1.SelectComputerMovementModule(p54) -- Line: 553
    -- upvalues: UserFlag10 (copy), UserInputService (copy), ActionController (copy), Players (copy), UserGameSettings (copy), ClickToMoveController (copy), u9 (copy)
    local u55 = false;

    if UserFlag10 then
        pcall(function() -- Line: 556
            -- upvalues: u55 (ref), UserInputService (ref)
            u55 = UserInputService.PreferredInput == Enum.PreferredInput.MicroGamepad;
        end);
    end;

    if UserInputService.PreferredInput ~= Enum.PreferredInput.KeyboardAndMouse and (UserInputService.PreferredInput ~= Enum.PreferredInput.Gamepad and not u55) then
        return nil, false;
    end;

    local v56 = ActionController;
    local DevComputerMovementMode = Players.LocalPlayer.DevComputerMovementMode;

    if DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice then
        if UserGameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove then
            v56 = ClickToMoveController;
        end;
    else
        v56 = u9[DevComputerMovementMode];

        if not v56 and DevComputerMovementMode ~= Enum.DevComputerMovementMode.Scriptable then
            warn("No character control module is associated with DevComputerMovementMode ", DevComputerMovementMode);
        end;
    end;

    if v56 then
        return v56, true;
    end;

    if DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable then
        return nil, true;
    end;

    return nil, false;
end;

function u1.SelectTouchModule(p57) -- Line: 597
    -- upvalues: Players (copy), u9 (copy), UserGameSettings (copy)
    local DevTouchMovementMode = Players.LocalPlayer.DevTouchMovementMode;
    local v58;

    if DevTouchMovementMode == Enum.DevTouchMovementMode.UserChoice then
        v58 = u9[UserGameSettings.TouchMovementMode];
    else
        if DevTouchMovementMode == Enum.DevTouchMovementMode.Scriptable then
            return nil, true;
        end;

        v58 = u9[DevTouchMovementMode];
    end;

    return v58, true;
end;

function u1.calculateRawMoveVector(p59: table, p60: userdata, p61: vector) -- Line: 610
    -- upvalues: Workspace (copy), VRService (copy), CameraRotationAction (copy)
    local CurrentCamera = Workspace.CurrentCamera;

    if not CurrentCamera then
        return p61;
    end;

    local CFrame2 = CurrentCamera.CFrame;

    if VRService.VREnabled and p60.RootPart then
        local EstimatedVRTorsoFrame = p59:GetEstimatedVRTorsoFrame();

        if (CurrentCamera.Focus.Position - CFrame2.Position).Magnitude < 3 then
            CFrame2 = CFrame2 * EstimatedVRTorsoFrame;
        else
            CFrame2 = CurrentCamera.CFrame * (EstimatedVRTorsoFrame.Rotation + EstimatedVRTorsoFrame.Position * CurrentCamera.HeadScale);
        end;
    end;

    if p60:GetState() ~= Enum.HumanoidStateType.Swimming then
        local _, _, _, v62, v63, v64, _, _, v65, _, _, v62 = CFrame2:GetComponents();

        if v65 >= 1 or v65 <= -1 then
            v64 = -v63 * math.sign(v65);
        end;

        local math_sqrt_ret = math.sqrt(v62 * v62 + v64 * v64);

        return Vector3.new((v62 * p61.X + v64 * p61.Z) / math_sqrt_ret, 0, (v62 * p61.Z - v64 * p61.X) / math_sqrt_ret);
    end;

    if not VRService.VREnabled then
        return CFrame2:VectorToWorldSpace(p61);
    end;

    local Vector3_new_ret = Vector3.new(p61.X, 0, p61.Z);

    if Vector3_new_ret.Magnitude < 0.01 then
        return Vector3.new(0, 0, 0);
    end;

    local v66 = not (CameraRotationAction and CameraRotationAction.Enabled) and 0 or -CameraRotationAction:GetState().Y / 2.31;
    local math_atan2_ret = math.atan2(-Vector3_new_ret.X, -Vector3_new_ret.Z);
    local _, v67, _ = CFrame2:ToEulerAnglesYXZ();

    return CFrame.fromEulerAnglesYXZ(v66, math_atan2_ret + v67, 0).LookVector;
end;

function u1.initialize(p68, p69, p70) -- Line: 671
    -- upvalues: ActionController (copy), UserFlag (copy), u4 (copy)
    p68.data = p69;
    p68.playerData = p70;
    p68:UpdateMovementMode();
    ActionController.initializeActions(p68.data, p68.playerData);

    if UserFlag then
        u4.setupSlotActions(p68.playerData.player, p68.data.isServerAuthority);
    end;
end;

function u1.Update(p71, p72, p73, p74) -- Line: 683
    -- upvalues: ActionController (copy), VRService (copy), UserFlag8 (copy), UserFlag (copy), u8 (ref), u3 (copy), Players (copy), UserFlag9 (copy)
    assert(p73.player);
    assert(p73.character);
    ActionController.initializeActions(p72, p73);

    if not (p73.actions.MoveAction and p73.actions.JumpAction) then
        return;
    end;

    if p71.activeController and (p71.activeController.enabled and p71.humanoid) then
        ActionController.update(p73);
        p71:GetClickToMoveController():Update(p73, p74);
        local Vector3_new_ret = Vector3.new(p73.moveVector.X, 0, -p73.moveVector.Y);

        if p71.vehicleController then
            local v75;
            Vector3_new_ret, v75 = p71.vehicleController:Update(Vector3_new_ret, true);
        end;

        local v76 = p71:calculateRawMoveVector(p71.humanoid, Vector3_new_ret);
        p71.inputMoveVector = v76;

        if VRService.VREnabled then
            v76 = p71:updateVRMoveVector(v76);
        end;

        if UserFlag8 then
            if not p72.isServerAuthority then
                if UserFlag and u8:isEnabled() then
                    u3.writeInputToPCS(Players.LocalPlayer, p71, false);

                    return;
                end;

                p71.moveFunction(Players.LocalPlayer, v76, false);
                p71.humanoid.Jump = p73.isJumping;
            end;
        elseif not (UserFlag9 and p72.isServerAuthority or UserFlag and u8:isEnabled()) then
            p71.moveFunction(Players.LocalPlayer, v76, false);
            p71.humanoid.Jump = p73.isJumping;
        end;
    end;
end;

function u1.updateVRMoveVector(p77, p78) -- Line: 739
    -- upvalues: VRService (copy)
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if p78.Magnitude ~= 0 or ((workspace_CurrentCamera.Focus.Position - workspace_CurrentCamera.CFrame.Position).Magnitude >= 5 or not (VRService.AvatarGestures and (p77.humanoid and not p77.humanoid.Sit))) then
        return p78;
    end;

    local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head);
    local v79 = (workspace_CurrentCamera.CFrame * (UserCFrame.Rotation + UserCFrame.Position * workspace_CurrentCamera.HeadScale) * CFrame.new(0, -0.7 * p77.humanoid.RootPart.Size.Y / 2, 0)).Position - p77.humanoid.RootPart.CFrame.Position;

    return Vector3.new(v79.x, 0, v79.z);
end;

function u1.OnHumanoidSeated(p80: table, p81: boolean, p82: userdata) -- Line: 764
    if p81 then
        if p82 and p82:IsA("VehicleSeat") then
            if not p80.vehicleController then
                p80.vehicleController = p80.vehicleController.new();
            end;

            p80.vehicleController:Enable(true, p82);
        end;
    elseif p80.vehicleController then
        p80.vehicleController:Enable(false, p82);
    end;
end;

function u1.OnCharacterAdded(u83, p84) -- Line: 779
    u83.humanoid = p84:FindFirstChildOfClass("Humanoid");

    while not u83.humanoid do
        p84.ChildAdded:wait();
        u83.humanoid = p84:FindFirstChildOfClass("Humanoid");
    end;

    if u83.humanoidSeatedConn then
        u83.humanoidSeatedConn:Disconnect();
        u83.humanoidSeatedConn = nil;
    end;

    u83.humanoidSeatedConn = u83.humanoid.Seated:Connect(function(p85, p86) -- Line: 790
        -- upvalues: u83 (copy)
        u83:OnHumanoidSeated(p85, p86);
    end);
    u83:UpdateMovementMode();
end;

function u1.OnCharacterRemoving(p87, p88) -- Line: 797
    p87.humanoid = nil;
    p87:UpdateMovementMode();
end;

function u1.UpdateTouchGuiVisibility(p89) -- Line: 803
    -- upvalues: GuiService (copy), UserInputService (copy)
    local v90 = p89.humanoid and GuiService.TouchControlsEnabled and UserInputService.PreferredInput == Enum.PreferredInput.Touch;

    if v90 and not p89.touchGui then
        p89:CreateTouchGuiContainer();
    end;

    if p89.touchGui then
        p89.touchGui.Enabled = v90 and true or false;
    end;
end;

function u1.SwitchToController(p91, p92) -- Line: 822
    if p92 then
        if not p91.controllers[p92] then
            p91.controllers[p92] = p92.new(p91.playerData);
        end;

        if p91.activeController ~= p91.controllers[p92] then
            if p91.activeController then
                p91.activeController:Enable(false);
            end;

            p91.activeController = p91.controllers[p92];
            p91.activeControlModule = p92;
            p91:UpdateActiveControlModuleEnabled();
        end;

        return;
    end;

    if p91.activeController then
        p91.activeController:Enable(false);
    end;

    p91.activeController = nil;
    p91.activeControlModule = nil;
end;

function u1.UpdateMovementMode(p93) -- Line: 861
    -- upvalues: UserInputService (copy)
    p93:UpdateTouchGuiVisibility();

    if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
        local v94, v95 = p93:SelectTouchModule();

        if v95 and p93.touchControlFrame then
            p93:SwitchToController(v94);
        end;
    else
        p93:SwitchToController((p93:SelectComputerMovementModule()));
    end;
end;

function u1.CreateTouchGuiContainer(p96) -- Line: 877
    -- upvalues: UserFlag (copy), UserFlag11 (copy)
    if not p96.playerGui then
        return;
    end;

    if p96.touchGui then
        p96.touchGui:Destroy();
    end;

    p96.touchGui = Instance.new("ScreenGui");
    p96.touchGui.Name = "TouchGui";
    p96.touchGui.ResetOnSpawn = false;
    p96.touchGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
    p96.touchGui.DisplayOrder = -1;

    if UserFlag and UserFlag11 then
        p96.touchGui.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets;
    end;

    p96.touchGui.ClipToDeviceSafeArea = false;
    p96.touchControlFrame = Instance.new("Frame");
    p96.touchControlFrame.Name = "TouchControlFrame";
    p96.touchControlFrame.Size = UDim2.new(1, 0, 1, 0);
    p96.touchControlFrame.BackgroundTransparency = 1;
    p96.touchControlFrame.Parent = p96.touchGui;
    p96.touchGui.Parent = p96.playerGui;
end;

function u1.GetClickToMoveController(p97) -- Line: 912
    -- upvalues: ClickToMoveController (copy)
    if not p97.controllers[ClickToMoveController] then
        p97.controllers[ClickToMoveController] = ClickToMoveController.new();
    end;

    return p97.controllers[ClickToMoveController];
end;

function u1.ProcessInputs(p98: table, u99: userdata, p100: number) -- Line: 919
    -- upvalues: UserFlag (copy), u7 (ref), UserFlag8 (copy), u3 (copy), UserFlag7 (copy), UserFlag5 (copy)
    if UserFlag then
        if not u7.get(u99):isEnabled() then
            if UserFlag8 then
                u3.processPCSInputs(u99);

                return;
            end;

            u3.SendInputToHumanoidForServerAuth(u99);
        end;
    else
        if UserFlag8 then
            u3.processPCSInputs(u99);

            return;
        end;

        local Character = u99.Character;

        if Character == nil then
            return;
        end;

        local Humanoid = Character:FindFirstChild("Humanoid");

        if Humanoid == nil then
            return;
        end;

        local InputContexts = u99:FindFirstChild("InputContexts");

        if InputContexts == nil then
            return;
        end;

        local CharacterContext = InputContexts:FindFirstChild("CharacterContext");

        if CharacterContext == nil then
            return;
        end;

        local CameraContext = InputContexts:FindFirstChild("CameraContext");
        local MoveAction = CharacterContext.MoveAction;

        if CameraContext then
            CameraContext = CameraContext.CameraAction;
        end;

        local RotationAction = CharacterContext.RotationAction;
        local JumpAction = CharacterContext.JumpAction;

        local function isValidInput2D(p101) -- Line: 958
            return p101.X == p101.X and (p101.Y == p101.Y and p101.X ~= (1 / 0)) and p101.Y ~= (1 / 0);
        end;

        local function isValidInput3D(p102: vector) -- Line: 966
            return p102.X == p102.X and (p102.Y == p102.Y and (p102.Z == p102.Z and (p102.X ~= (1 / 0) and p102.Y ~= (1 / 0)))) and p102.Z ~= (1 / 0);
        end;

        local v103;

        if MoveAction == nil then
            v103 = Vector2.new(0, 0);
        else
            v103 = MoveAction:GetState();
        end;

        local v104 = nil;
        local v105;

        if UserFlag7 then
            v105 = u99:GetCameraState().CFrame.LookVector;
        elseif UserFlag5 then
            local success, result = pcall(function() -- Line: 981
                -- upvalues: u99 (copy)
                return u99:GetCameraState();
            end);

            if success and result then
                local CFrame2 = result.CFrame;

                if CFrame2 ~= CFrame.identity and (result.FieldOfView > 0 and result.ViewportSize.Magnitude > 0) then
                    v104 = CFrame2.LookVector;
                end;
            end;

            v105 = v104 or (CameraContext == nil and Vector3.new(0, 0, 0) or CameraContext:GetState());
        else
            v105 = CameraContext == nil and Vector3.new(0, 0, 0) or CameraContext:GetState();
        end;

        if not (v103.X ~= v103.X or (v103.Y ~= v103.Y or v103.X == (1 / 0)) or v103.Y == (1 / 0) or (v105.X ~= v105.X or (v105.Y ~= v105.Y or (v105.Z ~= v105.Z or (v105.X == (1 / 0) or v105.Y == (1 / 0)))) or v105.Z == (1 / 0) or v105.Magnitude <= 0)) then
            if Humanoid:GetState() ~= Enum.HumanoidStateType.Swimming then
                v105 = Vector3.new(v105.X, 0, v105.Z).Unit;
            end;

            local Unit = v105:Cross(Vector3.new(0, 1, 0)).Unit;
            Humanoid:Move(v105 * v103.Y + Unit * v103.X);

            if RotationAction:GetState() then
                Humanoid.AutoRotate = false;

                if Humanoid.SeatPart == nil and (Humanoid.RootPart ~= nil and not (Humanoid.Sit or Humanoid.RootPart:IsGrounded())) then
                    Humanoid.RootPart.CFrame = CFrame.new(Humanoid.RootPart.CFrame.Position, Humanoid.RootPart.CFrame.Position + v105);
                end;
            else
                Humanoid.AutoRotate = true;
            end;
        end;

        local v106;

        if JumpAction == nil then
            v106 = false;
        else
            v106 = JumpAction:GetState();
        end;

        Humanoid.Jump = v106;
    end;
end;

if RunService:IsClient() then
    return u1.new();
end;

return u1;
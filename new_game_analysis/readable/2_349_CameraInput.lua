-- Decompiled with Potassium's decompiler.

game:GetService("ContextActionService");
local UserInputService = game:GetService("UserInputService");
local Players = game:GetService("Players");
local UserGameSettings = UserSettings():GetService("UserGameSettings");
game:GetService("VRService");
local GuiService = game:GetService("GuiService");
local Platform_Handler = require(game:GetService("ReplicatedStorage"):WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Controllers"):WaitForChild("Platform_Handler"));
local v1 = require(script.Parent.Parent:WaitForChild("CommonUtils")).get("FlagUtil");
local UserFlag = v1.getUserFlag("UserPSTextboxResetCameraInput");
local UserFlag2 = v1.getUserFlag("UserPlayerScriptsSupportTVRemoteKeycodes");
local CameraContext = script.Parent.Parent:WaitForChild("InputContexts"):WaitForChild("CameraContext");
local CameraRotationAction = CameraContext:WaitForChild("CameraRotationAction");
local CameraZoomAction = CameraContext:WaitForChild("CameraZoomAction");
local GamepadBinding = CameraRotationAction:WaitForChild("GamepadBinding");
local u2;

if UserFlag2 then
    u2 = CameraRotationAction:WaitForChild("MicroGamepadBinding");
else
    u2 = nil;
end;

local MouseBinding = CameraRotationAction:WaitForChild("MouseBinding");
local TrackpadBinding = CameraRotationAction:WaitForChild("TrackpadBinding");
local CameraToggleAction = CameraContext:WaitForChild("CameraToggleAction");
local CameraPanActiveAction = CameraContext:WaitForChild("CameraPanActiveAction");
local u3 = 1;

local function updateCameraYInvert() -- Line: 42
    -- upvalues: UserGameSettings (copy), u3 (ref), CameraRotationAction (copy)
    local CameraYInvertValue = UserGameSettings:GetCameraYInvertValue();

    if CameraYInvertValue == u3 then
        return;
    end;

    u3 = CameraYInvertValue;

    for _, child in CameraRotationAction:GetChildren() do
        if child:IsA("InputBinding") then
            local Vector2Scale = child.Vector2Scale;
            child.Vector2Scale = Vector2.new(Vector2Scale.X, -Vector2Scale.Y);
        end;
    end;
end;

local function updateMouseCameraSensitivity() -- Line: 63
    -- upvalues: UserGameSettings (copy), MouseBinding (copy), TrackpadBinding (copy)
    local MouseSensitivity = UserGameSettings.MouseSensitivity;
    MouseBinding.Scale = MouseSensitivity;
    TrackpadBinding.Scale = MouseSensitivity;
end;

UserGameSettings:GetPropertyChangedSignal("GamepadCameraSensitivity"):Connect(function() -- Line: 56, Name: updateGamepadCameraSensitivity
    -- upvalues: GamepadBinding (copy), UserGameSettings (copy), UserFlag2 (copy), u2 (copy)
    GamepadBinding.Scale = UserGameSettings.GamepadCameraSensitivity;

    if UserFlag2 and u2 then
        u2.Scale = UserGameSettings.GamepadCameraSensitivity;
    end;
end);
GamepadBinding.Scale = UserGameSettings.GamepadCameraSensitivity;

if UserFlag2 and u2 then
    u2.Scale = UserGameSettings.GamepadCameraSensitivity;
end;

UserGameSettings:GetPropertyChangedSignal("MouseSensitivity"):Connect(updateMouseCameraSensitivity);
local MouseSensitivity = UserGameSettings.MouseSensitivity;
MouseBinding.Scale = MouseSensitivity;
TrackpadBinding.Scale = MouseSensitivity;
updateCameraYInvert();

local function adjustTouchPitchSensitivity(p4) -- Line: 79
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if not workspace_CurrentCamera then
        return p4;
    end;

    local v5 = workspace_CurrentCamera.CFrame:ToEulerAnglesYXZ();

    if p4.Y * v5 >= 0 then
        return p4;
    end;

    local v6 = (1 - (math.abs(v5) * 2 / 3.141592653589793) ^ 0.75) * 0.75 + 0.25;

    return Vector2.new(1, v6) * p4;
end;

local v7 = {};
local u8 = 0;

local function incPanInputCount() -- Line: 110
    -- upvalues: u8 (ref)
    u8 = math.max(0, u8 + 1);
end;

local function decPanInputCount() -- Line: 114
    -- upvalues: u8 (ref)
    u8 = math.max(0, u8 - 1);
end;

local function resetPanInputCount() -- Line: 118
    -- upvalues: u8 (ref)
    u8 = 0;
end;

function v7.getRotationActivated() -- Line: 122
    -- upvalues: u8 (ref), CameraRotationAction (copy)
    return u8 > 0 and true or CameraRotationAction:GetState().Magnitude > 0;
end;

function v7.getPanActivated() -- Line: 127
    -- upvalues: u8 (ref)
    return u8 > 0;
end;

local Vector2_zero = Vector2.zero;

function v7.addRotation(p9) -- Line: 140
    -- upvalues: Vector2_zero (ref)
    Vector2_zero = Vector2_zero + p9;
end;

function v7.getAssistRotation() -- Line: 143
    -- upvalues: Vector2_zero (ref)
    return Vector2_zero;
end;

function v7.resetAssistRotation() -- Line: 146
    -- upvalues: Vector2_zero (ref)
    Vector2_zero = Vector2.zero;
end;

local u10 = nil;
local u11 = 0;

local function sunkMouseRotation(p12, p13: number) -- Line: 175
    -- upvalues: UserInputService (copy), u11 (ref), u10 (ref), CameraRotationAction (copy)
    if UserInputService.PreferredInput == Enum.PreferredInput.Touch or UserInputService:GetLastInputType() ~= Enum.UserInputType.MouseMovement then
        u11 = 0;

        return Vector2.zero;
    end;

    local MouseDelta = UserInputService:GetMouseDelta();

    if MouseDelta.Magnitude == 0 then
        u11 = 0;

        return Vector2.zero;
    end;

    if p12.Magnitude <= 0 then
        u11 = u11 + 1;

        if u11 < 2 or (u10 == nil or not CameraRotationAction.Enabled) then
            return Vector2.zero;
        end;

        return Vector2.new(MouseDelta.X * u10.X, MouseDelta.Y * u10.Y);
    end;

    u11 = 0;
    local v14 = p12 * p13;
    local v15 = u10 or Vector2.zero;
    local v16;

    if MouseDelta.X == 0 or v14.X == 0 then
        v16 = v15.X;
    else
        v16 = v14.X / MouseDelta.X;
    end;

    local v17;

    if MouseDelta.Y == 0 or v14.Y == 0 then
        v17 = v15.Y;
    else
        v17 = v14.Y / MouseDelta.Y;
    end;

    u10 = Vector2.new(v16, v17);

    return Vector2.zero;
end;

local u18 = Vector2.new(1, 0.66) * 0.017453292519943295;
local LocalPlayer = Players.LocalPlayer;

local function isInDynamicThumbstickArea(p19: vector) -- Line: 219
    -- upvalues: LocalPlayer (copy)
    local v20 = LocalPlayer:FindFirstChildOfClass("PlayerGui");

    if v20 then
        v20 = v20:FindFirstChild("TouchGui");
    end;

    local v21;

    if v20 then
        v21 = v20:FindFirstChild("TouchControlFrame");
    else
        v21 = v20;
    end;

    if v21 then
        v21 = v21:FindFirstChild("DynamicThumbstickFrame");
    end;

    if not (v21 and v20.Enabled) then
        return false;
    end;

    local AbsolutePosition = v21.AbsolutePosition;
    local v22 = AbsolutePosition + v21.AbsoluteSize;
    local v23;

    if p19.X >= AbsolutePosition.X and (p19.Y >= AbsolutePosition.Y and p19.X <= v22.X) then
        v23 = p19.Y <= v22.Y;
    else
        v23 = false;
    end;

    return v23;
end;

for _, child in CameraRotationAction:GetChildren() do
    if child:IsA("InputBinding") and string.find(child.Name, "Touch") ~= nil then
        child.Scale = 0;
    end;
end;

local u24 = {};
local u25 = nil;
local Vector2_zero2 = Vector2.zero;

local function isAimFinger(p26: userdata) -- Line: 246
    -- upvalues: Platform_Handler (copy)
    local v27 = Platform_Handler.SkillDragTurnsCamera() and Platform_Handler.AimInput() == p26;

    return v27;
end;

local function freeFingerCount() -- Line: 249
    -- upvalues: u24 (ref)
    local v28 = 0;

    for _, v in u24 do
        if not v then
            v28 = v28 + 1;
        end;
    end;

    return v28;
end;

local function pansNow(p29: userdata) -- Line: 260
    -- upvalues: u24 (ref), Platform_Handler (copy)
    local v30 = 0;

    for _, v in u24 do
        if not v then
            v30 = v30 + 1;
        end;
    end;

    if u24[p29] == false then
        return v30 == 1;
    end;

    local v31;

    if v30 == 0 then
        v31 = Platform_Handler.SkillDragTurnsCamera() and Platform_Handler.AimInput() == p29;
    else
        v31 = false;
    end;

    return v31;
end;

local function resetTouchState() -- Line: 265
    -- upvalues: u24 (ref), u8 (ref), u25 (ref), Vector2_zero2 (ref)
    for _, v in u24 do
        if not v then
            u8 = math.max(0, u8 - 1);
        end;
    end;

    u24 = {};
    u25 = nil;
    Vector2_zero2 = Vector2.zero;
end;

UserInputService.InputBegan:Connect(function(p32: userdata, p33: boolean) -- Line: 273
    -- upvalues: u25 (ref), isInDynamicThumbstickArea (copy), u8 (ref), u24 (ref)
    if p32.UserInputType ~= Enum.UserInputType.Touch then
        return;
    end;

    if u25 == nil and (not p33 and isInDynamicThumbstickArea(p32.Position)) then
        u25 = p32;

        return;
    end;

    if not p33 then
        u8 = math.max(0, u8 + 1);
    end;

    u24[p32] = p33;
end);
UserInputService.InputChanged:Connect(function(p34: userdata, p35: boolean) -- Line: 283
    -- upvalues: u25 (ref), u24 (ref), Platform_Handler (copy), Vector2_zero2 (ref)
    if p34.UserInputType ~= Enum.UserInputType.Touch or p34 == u25 then
        return;
    end;

    if u24[p34] == nil then
        u24[p34] = p35;
    end;

    local v36 = 0;

    for _, v in u24 do
        if not v then
            v36 = v36 + 1;
        end;
    end;

    local v37;

    if u24[p34] == false then
        v37 = v36 == 1;
    elseif v36 == 0 then
        v37 = Platform_Handler.SkillDragTurnsCamera() and Platform_Handler.AimInput() == p34;
    else
        v37 = false;
    end;

    if v37 then
        Vector2_zero2 = Vector2_zero2 + Vector2.new(p34.Delta.X, p34.Delta.Y);
    end;
end);
UserInputService.InputEnded:Connect(function(p38: userdata) -- Line: 292
    -- upvalues: u25 (ref), u24 (ref), u8 (ref)
    if p38.UserInputType ~= Enum.UserInputType.Touch then
        return;
    end;

    if p38 == u25 then
        u25 = nil;
    end;

    if u24[p38] == false then
        u8 = math.max(0, u8 - 1);
    end;

    u24[p38] = nil;
end);
UserInputService.WindowFocusReleased:Connect(resetTouchState);
GuiService.MenuOpened:Connect(resetTouchState);

function v7.getRotation(p39) -- Line: 303
    -- upvalues: updateCameraYInvert (copy), CameraRotationAction (copy), sunkMouseRotation (copy), UserInputService (copy), adjustTouchPitchSensitivity (copy), Vector2_zero2 (ref), u18 (copy), UserGameSettings (copy)
    updateCameraYInvert();
    local State = CameraRotationAction:GetState();
    local v40 = State * p39 + sunkMouseRotation(State, p39);

    if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
        v40 = adjustTouchPitchSensitivity(v40);
    end;

    local v41 = adjustTouchPitchSensitivity(Vector2_zero2) * u18;
    local Vector2_new_ret = Vector2.new(v41.X, v41.Y * UserGameSettings:GetCameraYInvertValue());
    Vector2_zero2 = Vector2.zero;

    return v40 + Vector2_new_ret;
end;

function v7.getZoomDelta(p42) -- Line: 318
    -- upvalues: CameraZoomAction (copy)
    return CameraZoomAction:GetState() * p42;
end;

CameraPanActiveAction.Pressed:Connect(incPanInputCount);
CameraPanActiveAction.Released:Connect(decPanInputCount);
local u43 = false;

function v7.setInputEnabled(p44) -- Line: 329
    -- upvalues: u43 (ref), u8 (ref), CameraZoomAction (copy), CameraRotationAction (copy), CameraPanActiveAction (copy)
    if u43 == p44 then
        return;
    end;

    u43 = p44;
    u8 = 0;

    if u43 then
        CameraZoomAction.Enabled = true;
        CameraRotationAction.Enabled = true;
        CameraPanActiveAction.Enabled = true;

        return;
    end;

    CameraZoomAction.Enabled = false;
    CameraRotationAction.Enabled = false;
    CameraPanActiveAction.Enabled = false;
end;

function v7.getInputEnabled() -- Line: 350
    -- upvalues: u43 (ref)
    return u43;
end;

UserInputService.WindowFocused:Connect(resetPanInputCount);
UserInputService.WindowFocusReleased:Connect(resetPanInputCount);
GuiService.MenuOpened:Connect(resetPanInputCount);

if UserFlag then
    UserInputService.TextBoxFocusReleased:Connect(resetPanInputCount);
end;

local u45 = false;
local u46 = false;
local u47 = 0;

function v7.getHoldPan() -- Line: 369
    -- upvalues: u45 (ref)
    return u45;
end;

function v7.getTogglePan() -- Line: 373
    -- upvalues: u46 (ref)
    return u46;
end;

function v7.getPanning() -- Line: 377
    -- upvalues: u46 (ref), u45 (ref)
    return u46 or u45;
end;

function v7.setTogglePan(p48: boolean) -- Line: 381
    -- upvalues: u46 (ref)
    u46 = p48;
end;

local u49 = false;
CameraToggleAction.Pressed:Connect(function() -- Line: 389
    -- upvalues: u45 (ref), u47 (ref)
    u45 = true;
    u47 = tick();
end);
CameraToggleAction.Released:Connect(function() -- Line: 394
    -- upvalues: u45 (ref), u47 (ref), u46 (ref), UserInputService (copy)
    u45 = false;

    if tick() - u47 < 0.3 and (u46 or UserInputService:GetMouseDelta().Magnitude < 2) then
        u46 = not u46;
    end;
end);

function v7.enableCameraToggleInput() -- Line: 401
    -- upvalues: u49 (ref), u45 (ref), u46 (ref), CameraToggleAction (copy)
    if u49 then
        return;
    end;

    u49 = true;
    u45 = false;
    u46 = false;
    CameraToggleAction.Enabled = true;
end;

function v7.disableCameraToggleInput() -- Line: 413
    -- upvalues: u49 (ref), CameraToggleAction (copy)
    if not u49 then
        return;
    end;

    u49 = false;
    CameraToggleAction.Enabled = false;
end;

return v7;
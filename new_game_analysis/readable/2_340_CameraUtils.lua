-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local UserGameSettings = UserSettings():GetService("UserGameSettings");
local u1 = {};

local function round(p2: number) -- Line: 12
    return math.floor(p2 + 0.5);
end;

local u3 = {};
u3.__index = u3;

function u3.new(p4, p5) -- Line: 21
    -- upvalues: u3 (copy)
    return setmetatable({
        vel = 0,
        freq = p4,
        goal = p5,
        pos = p5
    }, u3);
end;

function u3.step(p6: table, p7: number) -- Line: 31
    local v8 = p6.freq * 2 * 3.141592653589793;
    local goal = p6.goal;
    local vel = p6.vel;
    local v9 = p6.pos - goal;
    local math_exp_ret = math.exp(-v8 * p7);
    local v10 = (v9 * (v8 * p7 + 1) + vel * p7) * math_exp_ret + goal;
    p6.pos = v10;
    p6.vel = (vel * (1 - v8 * p7) - v9 * (v8 * v8 * p7)) * math_exp_ret;

    return v10;
end;

u1.Spring = u3;

function u1.map(p11: number, p12: number, p13: number, p14: number, p15: number) -- Line: 53
    return (p11 - p12) * (p15 - p14) / (p13 - p12) + p14;
end;

function u1.mapClamp(p16: number, p17: number, p18: number, p19: number, p20: number) -- Line: 58
    local math_min_ret = math.min(p19, p20);
    local math_max_ret = math.max(p19, p20);

    return math.clamp((p16 - p17) * (p20 - p19) / (p18 - p17) + p19, math_min_ret, math_max_ret);
end;

function u1.getLooseBoundingSphere(p21: table) -- Line: 67
    local table_create_ret = table.create(#p21);

    for i, v in pairs(p21) do
        table_create_ret[i] = v.Position;
    end;

    local v22 = table_create_ret[1];
    local v23 = v22;
    local v24 = 0;

    for _, v in ipairs(table_create_ret) do
        local Magnitude = (v - v22).Magnitude;

        if v24 < Magnitude then
            v23 = v;
            v24 = Magnitude;
        end;
    end;

    local v25 = v23;
    local v26 = 0;

    for _, v in ipairs(table_create_ret) do
        local Magnitude = (v - v23).Magnitude;

        if v26 < Magnitude then
            v25 = v;
            v26 = Magnitude;
        end;
    end;

    local v27 = (v23 + v25) * 0.5;
    local v28 = (v23 - v25).Magnitude * 0.5;

    for _, v in ipairs(table_create_ret) do
        local Magnitude = (v - v27).Magnitude;

        if v28 < Magnitude then
            v27 = v27 + (Magnitude - v28) * 0.5 * (v - v27).Unit;
            v28 = (Magnitude + v28) * 0.5;
        end;
    end;

    return v27, v28;
end;

function u1.sanitizeAngle(p29: number) -- Line: 123
    return (p29 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793;
end;

function u1.Round(p30: number, p31: number) -- Line: 128
    local v32 = 10 ^ p31;

    return math.floor(p30 * v32 + 0.5) / v32;
end;

function u1.IsFinite(p33: number) -- Line: 133
    local v34;

    if p33 == p33 and p33 ~= (1 / 0) then
        v34 = p33 ~= (-1 / 0);
    else
        v34 = false;
    end;

    return v34;
end;

function u1.IsFiniteVector3(p35: vector) -- Line: 137
    -- upvalues: u1 (copy)
    local v36 = u1.IsFinite(p35.X) and u1.IsFinite(p35.Y) and u1.IsFinite(p35.Z);

    return v36;
end;

function u1.GetAngleBetweenXZVectors(p37: vector, p38: vector) -- Line: 142
    return math.atan2(p38.X * p37.Z - p38.Z * p37.X, p38.X * p37.X + p38.Z * p37.Z);
end;

function u1.RotateVectorByAngleAndRound(p39: vector, p40: number, p41: number) -- Line: 146
    if p39.Magnitude <= 0 then
        return 0;
    end;

    local Unit = p39.Unit;
    local math_atan2_ret = math.atan2(Unit.Z, Unit.X);
    local v42 = (math.atan2(Unit.Z, Unit.X) + p40) / p41 + 0.5;

    return math.floor(v42) * p41 - math_atan2_ret;
end;

local function SCurveTranform(p43: number) -- Line: 160
    local math_clamp_ret = math.clamp(p43, -1, 1);

    if math_clamp_ret >= 0 then
        return math_clamp_ret * 0.35 / (0.35 - math_clamp_ret + 1);
    end;

    return -(-math_clamp_ret * 0.8 / (math_clamp_ret + 0.8 + 1));
end;

local function toSCurveSpace(p44: number) -- Line: 169
    return (math.abs(p44) * 2 - 1) * 1.1 - 0.1;
end;

local function fromSCurveSpace(p45: number) -- Line: 173
    return p45 / 2 + 0.5;
end;

function u1.GamepadLinearToCurve(p46) -- Line: 177
    local function onAxis(p47) -- Line: 178
        local math_abs_ret = math.abs(p47);
        local v48 = (math.abs(math_abs_ret) * 2 - 1) * 1.1 - 0.1;
        local math_clamp_ret = math.clamp(v48, -1, 1);
        local v49;

        if math_clamp_ret >= 0 then
            v49 = math_clamp_ret * 0.35 / (0.35 - math_clamp_ret + 1);
        else
            v49 = -(-math_clamp_ret * 0.8 / (math_clamp_ret + 0.8 + 1));
        end;

        return math.clamp((v49 / 2 + 0.5) * (p47 < 0 and -1 or 1), -1, 1);
    end;

    local Vector2_new = Vector2.new;
    local X = p46.X;
    local math_abs_ret = math.abs(X);
    local v50 = (math.abs(math_abs_ret) * 2 - 1) * 1.1 - 0.1;
    local math_clamp_ret = math.clamp(v50, -1, 1);
    local v51;

    if math_clamp_ret >= 0 then
        v51 = math_clamp_ret * 0.35 / (0.35 - math_clamp_ret + 1);
    else
        v51 = -(-math_clamp_ret * 0.8 / (math_clamp_ret + 0.8 + 1));
    end;

    local math_clamp_ret2 = math.clamp((v51 / 2 + 0.5) * (X < 0 and -1 or 1), -1, 1);
    local Y = p46.Y;
    local math_abs_ret2 = math.abs(Y);
    local v52 = (math.abs(math_abs_ret2) * 2 - 1) * 1.1 - 0.1;
    local math_clamp_ret3 = math.clamp(v52, -1, 1);
    local v53;

    if math_clamp_ret3 >= 0 then
        v53 = math_clamp_ret3 * 0.35 / (0.35 - math_clamp_ret3 + 1);
    else
        v53 = -(-math_clamp_ret3 * 0.8 / (math_clamp_ret3 + 0.8 + 1));
    end;

    return Vector2_new(math_clamp_ret2, (math.clamp((v53 / 2 + 0.5) * (Y < 0 and -1 or 1), -1, 1)));
end;

function u1.ConvertCameraModeEnumToStandard(p54) -- Line: 191
    if p54 == Enum.TouchCameraMovementMode.Default then
        return Enum.ComputerCameraMovementMode.Follow;
    end;

    if p54 == Enum.ComputerCameraMovementMode.Default then
        return Enum.ComputerCameraMovementMode.Classic;
    end;

    if p54 == Enum.TouchCameraMovementMode.Classic or (p54 == Enum.DevTouchCameraMovementMode.Classic or (p54 == Enum.DevComputerCameraMovementMode.Classic or p54 == Enum.ComputerCameraMovementMode.Classic)) then
        return Enum.ComputerCameraMovementMode.Classic;
    end;

    if p54 == Enum.TouchCameraMovementMode.Follow or (p54 == Enum.DevTouchCameraMovementMode.Follow or (p54 == Enum.DevComputerCameraMovementMode.Follow or p54 == Enum.ComputerCameraMovementMode.Follow)) then
        return Enum.ComputerCameraMovementMode.Follow;
    end;

    if p54 == Enum.TouchCameraMovementMode.Orbital or (p54 == Enum.DevTouchCameraMovementMode.Orbital or (p54 == Enum.DevComputerCameraMovementMode.Orbital or p54 == Enum.ComputerCameraMovementMode.Orbital)) then
        return Enum.ComputerCameraMovementMode.Orbital;
    end;

    if p54 == Enum.ComputerCameraMovementMode.CameraToggle or p54 == Enum.DevComputerCameraMovementMode.CameraToggle then
        return Enum.ComputerCameraMovementMode.CameraToggle;
    end;

    if p54 == Enum.DevTouchCameraMovementMode.UserChoice or p54 == Enum.DevComputerCameraMovementMode.UserChoice then
        return Enum.DevComputerCameraMovementMode.UserChoice;
    end;

    return Enum.ComputerCameraMovementMode.Classic;
end;

local function getMouse() -- Line: 240
    -- upvalues: Players (copy)
    local LocalPlayer = Players.LocalPlayer;

    if not LocalPlayer then
        Players:GetPropertyChangedSignal("LocalPlayer"):Wait();
        LocalPlayer = Players.LocalPlayer;
    end;

    assert(LocalPlayer);

    return LocalPlayer:GetMouse();
end;

local u55 = "";
local u56 = nil;

function u1.setMouseIconOverride(p57: string) -- Line: 252
    -- upvalues: Players (copy), u56 (ref), u55 (ref)
    local LocalPlayer = Players.LocalPlayer;

    if not LocalPlayer then
        Players:GetPropertyChangedSignal("LocalPlayer"):Wait();
        LocalPlayer = Players.LocalPlayer;
    end;

    assert(LocalPlayer);
    local Mouse = LocalPlayer:GetMouse();

    if Mouse.Icon ~= u56 then
        u55 = Mouse.Icon;
    end;

    Mouse.Icon = p57;
    u56 = p57;
end;

function u1.restoreMouseIcon() -- Line: 263
    -- upvalues: Players (copy), u56 (ref), u55 (ref)
    local LocalPlayer = Players.LocalPlayer;

    if not LocalPlayer then
        Players:GetPropertyChangedSignal("LocalPlayer"):Wait();
        LocalPlayer = Players.LocalPlayer;
    end;

    assert(LocalPlayer);
    local Mouse = LocalPlayer:GetMouse();

    if Mouse.Icon == u56 then
        Mouse.Icon = u55;
    end;

    u56 = nil;
end;

local Default = Enum.MouseBehavior.Default;
local u58 = nil;

function u1.setMouseBehaviorOverride(p59) -- Line: 274
    -- upvalues: UserInputService (copy), u58 (ref), Default (ref)
    if UserInputService.MouseBehavior ~= u58 then
        Default = UserInputService.MouseBehavior;
    end;

    UserInputService.MouseBehavior = p59;
    u58 = p59;
end;

function u1.restoreMouseBehavior() -- Line: 283
    -- upvalues: UserInputService (copy), u58 (ref), Default (ref)
    if UserInputService.MouseBehavior == u58 then
        UserInputService.MouseBehavior = Default;
    end;

    u58 = nil;
end;

local MovementRelative = Enum.RotationType.MovementRelative;
local u60 = nil;

function u1.setRotationTypeOverride(p61) -- Line: 292
    -- upvalues: UserGameSettings (copy), u60 (ref), MovementRelative (ref)
    if UserGameSettings.RotationType ~= u60 then
        MovementRelative = UserGameSettings.RotationType;
    end;

    UserGameSettings.RotationType = p61;
    u60 = p61;
end;

function u1.restoreRotationType() -- Line: 301
    -- upvalues: UserGameSettings (copy), u60 (ref), MovementRelative (ref)
    if UserGameSettings.RotationType == u60 then
        UserGameSettings.RotationType = MovementRelative;
    end;

    u60 = nil;
end;

return u1;
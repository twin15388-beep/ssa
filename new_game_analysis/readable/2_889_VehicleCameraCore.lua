-- Decompiled with Potassium's decompiler.

local CameraUtils = require(script.Parent.Parent.CameraUtils);
local VehicleCameraConfig = require(script.Parent.VehicleCameraConfig);
local map = CameraUtils.map;
local mapClamp = CameraUtils.mapClamp;
local sanitizeAngle = CameraUtils.sanitizeAngle;

local function getYaw(p1) -- Line: 10
    -- upvalues: sanitizeAngle (copy)
    local _, v2 = p1:toEulerAnglesYXZ();

    return sanitizeAngle(v2);
end;

local function getPitch(p3) -- Line: 16
    -- upvalues: sanitizeAngle (copy)
    return sanitizeAngle((p3:toEulerAnglesYXZ()));
end;

local function stepSpringAxis(p4, p5, p6, p7, p8) -- Line: 22
    -- upvalues: sanitizeAngle (copy)
    local v9 = sanitizeAngle(p7 - p6);
    local math_exp_ret = math.exp(-p5 * p4);

    return sanitizeAngle((v9 * (1 + p5 * p4) + p8 * p4) * math_exp_ret + p6), (p8 * (1 - p5 * p4) - v9 * (p5 * p5 * p4)) * math_exp_ret;
end;

local u10 = {};
u10.__index = u10;

function u10.new(p11, p12, p13) -- Line: 36
    -- upvalues: u10 (copy)
    return setmetatable({
        fRising = p11,
        fFalling = p12,
        g = p13,
        p = p13,
        v = p13 * 0
    }, u10);
end;

function u10.step(p14, p15) -- Line: 46
    local fRising = p14.fRising;
    local fFalling = p14.fFalling;
    local g = p14.g;
    local v = p14.v;

    if v > 0 then
        fFalling = fRising or fFalling;
    end;

    local v16 = 6.283185307179586 * fFalling;
    local v17 = p14.p - g;
    local math_exp_ret = math.exp(-v16 * p15);
    local v18 = (v17 * (1 + v16 * p15) + v * p15) * math_exp_ret + g;
    p14.p = v18;
    p14.v = (v * (1 - v16 * p15) - v17 * (v16 * v16 * p15)) * math_exp_ret;

    return v18;
end;

local u19 = {};
u19.__index = u19;

function u19.new(p20) -- Line: 72
    -- upvalues: sanitizeAngle (copy), u10 (copy), VehicleCameraConfig (copy), u19 (copy)
    local v21 = typeof(p20) == "CFrame";
    assert(v21);
    local v22 = {
        yawV = 0,
        pitchV = 0
    };
    local _, v23 = p20:toEulerAnglesYXZ();
    v22.yawG = sanitizeAngle(v23);
    local _, v24 = p20:toEulerAnglesYXZ();
    v22.yawP = sanitizeAngle(v24);
    v22.pitchG = sanitizeAngle((p20:toEulerAnglesYXZ()));
    v22.pitchP = sanitizeAngle((p20:toEulerAnglesYXZ()));
    v22.fSpringYaw = u10.new(VehicleCameraConfig.yawReponseDampingRising, VehicleCameraConfig.yawResponseDampingFalling, 0);
    v22.fSpringPitch = u10.new(VehicleCameraConfig.pitchReponseDampingRising, VehicleCameraConfig.pitchResponseDampingFalling, 0);

    return setmetatable(v22, u19);
end;

function u19.setGoal(p25, p26) -- Line: 99
    -- upvalues: sanitizeAngle (copy)
    local v27 = typeof(p26) == "CFrame";
    assert(v27);
    local _, v28 = p26:toEulerAnglesYXZ();
    p25.yawG = sanitizeAngle(v28);
    p25.pitchG = sanitizeAngle((p26:toEulerAnglesYXZ()));
end;

function u19.getCFrame(p29) -- Line: 106
    return CFrame.fromEulerAnglesYXZ(p29.pitchP, p29.yawP, 0);
end;

function u19.step(p30, p31, p32, p33, p34) -- Line: 110
    -- upvalues: mapClamp (copy), map (copy), VehicleCameraConfig (copy), sanitizeAngle (copy)
    local v35 = typeof(p31) == "number";
    assert(v35);
    local v36 = typeof(p33) == "number";
    assert(v36);
    local v37 = typeof(p32) == "number";
    assert(v37);
    local v38 = typeof(p34) == "number";
    assert(v38);
    local fSpringYaw = p30.fSpringYaw;
    local fSpringPitch = p30.fSpringPitch;
    fSpringYaw.g = mapClamp(map(p34, 0, 1, p33, 0), math.rad(VehicleCameraConfig.cutoffMinAngularVelYaw), math.rad(VehicleCameraConfig.cutoffMaxAngularVelYaw), 1, 0);
    fSpringPitch.g = mapClamp(map(p34, 0, 1, p32, 0), math.rad(VehicleCameraConfig.cutoffMinAngularVelPitch), math.rad(VehicleCameraConfig.cutoffMaxAngularVelPitch), 1, 0);
    local v39 = 6.283185307179586 * VehicleCameraConfig.yawStiffness * fSpringYaw:step(p31);
    local v40 = 6.283185307179586 * VehicleCameraConfig.pitchStiffness * fSpringPitch:step(p31) * map(p34, 0, 1, 1, VehicleCameraConfig.firstPersonResponseMul);
    local v41 = v39 * map(p34, 0, 1, 1, VehicleCameraConfig.firstPersonResponseMul);
    local yawG = p30.yawG;
    local yawV = p30.yawV;
    local v42 = sanitizeAngle(p30.yawP - yawG);
    local math_exp_ret = math.exp(-v41 * p31);
    local v43 = sanitizeAngle((v42 * (1 + v41 * p31) + yawV * p31) * math_exp_ret + yawG);
    p30.yawP = v43;
    p30.yawV = (yawV * (1 - v41 * p31) - v42 * (v41 * v41 * p31)) * math_exp_ret;
    local pitchG = p30.pitchG;
    local pitchV = p30.pitchV;
    local v44 = sanitizeAngle(p30.pitchP - pitchG);
    local math_exp_ret2 = math.exp(-v40 * p31);
    local v45 = sanitizeAngle((v44 * (1 + v40 * p31) + pitchV * p31) * math_exp_ret2 + pitchG);
    p30.pitchP = v45;
    p30.pitchV = (pitchV * (1 - v40 * p31) - v44 * (v40 * v40 * p31)) * math_exp_ret2;

    return p30:getCFrame();
end;

local u46 = {};
u46.__index = u46;

function u46.new(p47) -- Line: 167
    -- upvalues: u19 (copy), u46 (copy)
    local v48 = {
        vrs = u19.new(p47)
    };

    return setmetatable(v48, u46);
end;

function u46.step(p49, p50, p51, p52, p53) -- Line: 173
    return p49.vrs:step(p50, p51, p52, p53);
end;

function u46.setTransform(p54, p55) -- Line: 177
    p54.vrs:setGoal(p55);
end;

return u46;
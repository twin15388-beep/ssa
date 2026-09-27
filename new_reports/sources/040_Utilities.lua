-- Decompiled with Potassium's decompiler.

local HttpService = game:GetService("HttpService");
local Config = require(script.Parent.Parent:WaitForChild("Config"));
local DefaultObjectSettings = require(script.Parent:WaitForChild("DefaultObjectSettings"));
local Profiles = require(script.Parent.Parent:WaitForChild("Profiles"));
local u1 = {
    Block = "Box",
    Ball = "Sphere",
    Capsule = "Capsule",
    Sphere = "Sphere",
    Box = "Box",
    Cylinder = "Cylinder"
};

local function YAxisSafeUnit(p2: vector) -- Line: 15
    return p2.Magnitude <= 1e-6 and Vector3.new(-0, -1, -0) or p2.Unit;
end;

local u56 = {
    LogIndent = 0,

    GetRotationBetween = function(p3: vector, p4: vector) -- Line: 26, Name: GetRotationBetween
        local v5 = p3:Dot(p4);
        local Magnitude = p3:Cross(p4).Magnitude;
        local math_atan2_ret = math.atan2(Magnitude, v5);
        local v6 = p3:Cross(p4);
        local v7 = v6.Magnitude <= 1e-6 and Vector3.new(-0, -1, -0) or v6.Unit;

        if Magnitude >= 1e-6 then
            return CFrame.fromAxisAngle(v7, math_atan2_ret);
        end;

        if v5 > 0 then
            return CFrame.new();
        end;

        local v8 = math.abs(p3.X) > math.abs(p3.Z) and Vector3.new(-p3.Y, p3.X, 0) or Vector3.new(0, -p3.Z, p3.Y);

        return CFrame.fromAxisAngle(v8.Unit, 3.141592653589793);
    end,

    GetCFrameAxis = function(p9, p10: string) -- Line: 45, Name: GetCFrameAxis
        local v11, v12, v13 = p9:ToEulerAnglesXYZ();

        if p10 == "X" then
            return v11;
        end;

        if p10 == "Y" then
            return v12;
        end;

        if p10 == "Z" then
            return v13;
        end;

        return nil;
    end,

    GatherObjectSettings = function(u14: userdata) -- Line: 57, Name: GatherObjectSettings
        -- upvalues: DefaultObjectSettings (copy), Profiles (copy)
        local v15 = {};
        local Attributes = u14:GetAttributes();

        local function Expect(p16: any, p17: string, p18: string) -- Line: 61
            -- upvalues: u14 (copy)
            if typeof(p16) == p17 then
                return true;
            end;

            warn((`[SmartBone][Object] Expected attribute {p18} on {u14.Name} to be of type {p17}, got type {typeof(p16)}`));

            return false;
        end;

        local v19 = DefaultObjectSettings;
        local Profile = Attributes.Profile;

        if Profile ~= nil then
            local v20 = Profiles[Profile];

            if v20 then
                v19 = v20;
            else
                warn((`[SmartBone][Object] Unknown Profile "{Profile}" on {u14.Name}`));
            end;
        end;

        for i, v in DefaultObjectSettings do
            local v21 = Attributes[i];

            if v21 ~= nil then
                local v22 = typeof(v);
                local v23;

                if typeof(v21) == v22 then
                    v23 = true;
                else
                    warn((`[SmartBone][Object] Expected attribute {i} on {u14.Name} to be of type {v22}, got type {typeof(v21)}`));
                    v23 = false;
                end;

                if not v23 then
                    v21 = nil;
                end;
            end;

            if v21 == nil then
                local v24 = v19[i];
                v21 = v24 == nil and v and v or v24;
            end;

            v15[i] = v21;
        end;

        return v15;
    end,

    GatherBoneSettings = function(u25: userdata) -- Line: 105, Name: GatherBoneSettings
        local Attributes = u25:GetAttributes();

        local function Attrib(p26: string) -- Line: 108
            -- upvalues: Attributes (copy)
            return Attributes[p26];
        end;

        local function _(p27: any, p28: string, p29: string) -- Line: 112
            -- upvalues: u25 (copy)
            if typeof(p27) ~= p28 then
                warn((`[SmartBone][Bone] Expected attribute {p29} on {u25.Name} to be of type {p28}, got type {typeof(p27)}`));
            end;
        end;

        local v30 = Attributes.XAxisLocked or false;
        local v31 = Attributes.YAxisLocked or false;
        local v32 = Attributes.ZAxisLocked or false;
        local v33 = Attributes.XAxisLimits or NumberRange.new((-1 / 0), (1 / 0));
        local v34 = Attributes.YAxisLimits or NumberRange.new((-1 / 0), (1 / 0));
        local v35 = Attributes.ZAxisLimits or NumberRange.new((-1 / 0), (1 / 0));
        local v36 = Attributes.Radius or 0.25;
        local v37 = Attributes.RotationLimit or 180;
        local v38 = Attributes.Force or "¬";
        local v39 = Attributes.Gravity or "¬";

        if typeof(v30) ~= "boolean" then
            warn((`[SmartBone][Bone] Expected attribute XAxisLocked on {u25.Name} to be of type boolean, got type {typeof(v30)}`));
        end;

        if typeof(v31) ~= "boolean" then
            warn((`[SmartBone][Bone] Expected attribute YAxisLocked on {u25.Name} to be of type boolean, got type {typeof(v31)}`));
        end;

        if typeof(v32) ~= "boolean" then
            warn((`[SmartBone][Bone] Expected attribute ZAxisLocked on {u25.Name} to be of type boolean, got type {typeof(v32)}`));
        end;

        if typeof(v33) ~= "NumberRange" then
            warn((`[SmartBone][Bone] Expected attribute XAxisLimits on {u25.Name} to be of type NumberRange, got type {typeof(v33)}`));
        end;

        if typeof(v34) ~= "NumberRange" then
            warn((`[SmartBone][Bone] Expected attribute YAxisLimits on {u25.Name} to be of type NumberRange, got type {typeof(v34)}`));
        end;

        if typeof(v35) ~= "NumberRange" then
            warn((`[SmartBone][Bone] Expected attribute ZAxisLimits on {u25.Name} to be of type NumberRange, got type {typeof(v35)}`));
        end;

        if typeof(v36) ~= "number" then
            warn((`[SmartBone][Bone] Expected attribute Radius on {u25.Name} to be of type number, got type {typeof(v36)}`));
        end;

        if typeof(v37) ~= "number" then
            warn((`[SmartBone][Bone] Expected attribute RotationLimit on {u25.Name} to be of type number, got type {typeof(v37)}`));
        end;

        if v38 ~= "¬" and typeof(v38) ~= "Vector3" then
            warn((`[SmartBone][Bone] Expected attribute Force on {u25.Name} to be of type Vector3, got type {typeof(v38)}`));
        end;

        if v39 ~= "¬" and typeof(v39) ~= "Vector3" then
            warn((`[SmartBone][Bone] Expected attribute Gravity on {u25.Name} to be of type Vector3, got type {typeof(v39)}`));
        end;

        return {
            AxisLocked = { v30, v31, v32 },
            XAxisLimits = v33,
            YAxisLimits = v34,
            ZAxisLimits = v35,
            RotationLimit = v37,
            Radius = v36,
            Force = v38,
            Gravity = v39
        };
    end,

    ClosestPointOnLine = function(p40: vector, p41: vector, p42: number, p43: vector) -- Line: 166, Name: ClosestPointOnLine
        local v44 = (p43 - p40):Dot(p41);

        return p40 + p41 * math.clamp(v44, -p42, p42);
    end,

    ClosestPointInBox = function(p45, p46: vector, p47: vector) -- Line: 174, Name: ClosestPointInBox
        local v48 = p45:PointToObjectSpace(p47);
        local X = p46.X;
        local Y = p46.Y;
        local Z = p46.Z;
        local X2 = v48.X;
        local Y2 = v48.Y;
        local Z2 = v48.Z;

        if v48 ~= v48 or p46 ~= p46 then
            return false, p45.Position, Vector3.new(0, 1, 0);
        end;

        local math_clamp_ret = math.clamp(X2, -X * 0.5, X * 0.5);
        local math_clamp_ret2 = math.clamp(Y2, -Y * 0.5, Y * 0.5);
        local math_clamp_ret3 = math.clamp(Z2, -Z * 0.5, Z * 0.5);

        if math_clamp_ret ~= X2 or (math_clamp_ret2 ~= Y2 or math_clamp_ret3 ~= Z2) then
            local v49 = p45 * Vector3.new(math_clamp_ret, math_clamp_ret2, math_clamp_ret3);

            return false, v49, (p47 - v49).unit;
        end;

        local v50 = X2 - X * 0.5;
        local v51 = Y2 - Y * 0.5;
        local v52 = Z2 - Z * 0.5;
        local v53 = -X2 - X * 0.5;
        local v54 = -Y2 - Y * 0.5;
        local v55 = -Z2 - Z * 0.5;
        local math_max_ret = math.max(v50, v51, v52, v53, v54, v55);

        if math_max_ret == v50 then
            return true, p45 * Vector3.new(X * 0.5, Y2, Z2), p45.XVector;
        end;

        if math_max_ret == v51 then
            return true, p45 * Vector3.new(X2, Y * 0.5, Z2), p45.YVector;
        end;

        if math_max_ret == v52 then
            return true, p45 * Vector3.new(X2, Y2, Z * 0.5), p45.ZVector;
        end;

        if math_max_ret == v53 then
            return true, p45 * Vector3.new(-X * 0.5, Y2, Z2), -p45.XVector;
        end;

        if math_max_ret == v54 then
            return true, p45 * Vector3.new(X2, -Y * 0.5, Z2), -p45.YVector;
        end;

        if math_max_ret == v55 then
            return true, p45 * Vector3.new(X2, Y2, -Z * 0.5), -p45.ZVector;
        end;

        warn("CLOSEST POINT ON BOX FAIL");

        return false, Vector3.new(0, 0, 0), Vector3.new(0, 1, 0);
    end
};
local u57 = setmetatable({}, {
    __mode = "k"
});

function u56.GetCollider(p58: userdata) -- Line: 231
    -- upvalues: Config (copy), u57 (copy), HttpService (copy), u1 (copy)
    local v59 = Config.CACHE_COLLIDER_DESCRIPTIONS and u57[p58];

    if v59 then
        return v59;
    end;

    local v60 = p58:FindFirstChild("self.Collider");
    local v61;

    if v60 and v60:IsA("ModuleScript") then
        local u62 = require(v60);
        local u63 = nil;
        pcall(function() -- Line: 248
            -- upvalues: u63 (ref), HttpService (ref), u62 (copy)
            u63 = HttpService:JSONDecode(u62);
        end);
        v61 = u63;
    else
        v61 = nil;
    end;

    if v61 then
        if Config.CACHE_COLLIDER_DESCRIPTIONS then
            u57[p58] = v61;
        end;

        return v61;
    end;

    local function GetShapeName(p64) -- Line: 265
        return p64:GetAttribute("ColliderShape") or (not p64:IsA("Part") and "Box" or p64.Shape.Name);
    end;

    local v65 = {
        {
            ScaleX = 1,
            ScaleY = 1,
            ScaleZ = 1,
            OffsetX = 0,
            OffsetY = 0,
            OffsetZ = 0,
            RotationX = 0,
            RotationY = 0,
            RotationZ = 0,
            Type = u1[p58:GetAttribute("ColliderShape") or (not p58:IsA("Part") and "Box" or p58.Shape.Name)] or "Box"
        }
    };

    if Config.CACHE_COLLIDER_DESCRIPTIONS then
        u57[p58] = v65;
    end;

    return v65;
end;

function u56.SB_INDENT_LOG() -- Line: 303
    -- upvalues: u56 (copy)
    local v66 = u56;
    v66.LogIndent = v66.LogIndent + 1;
end;

function u56.SB_UNINDENT_LOG() -- Line: 307
    -- upvalues: u56 (copy)
    local v67 = u56;
    v67.LogIndent = v67.LogIndent - 1;
    u56.LogIndent = math.max(u56.LogIndent, 0);
end;

function u56.SB_ASSERT_CB(p68, p69, ...) -- Line: 312
    if p68 == false or p68 == nil then
        p69(...);
    end;
end;

function u56.SB_VERBOSE_LOG(p70: string) -- Line: 318
    -- upvalues: Config (copy), u56 (copy)
    if not Config.LOG_VERBOSE then
        return;
    end;

    local string_rep_ret = string.rep("    ", u56.LogIndent);
    print((`{string_rep_ret}[SmartBone][Log]: {p70}`));
end;

function u56.SB_VERBOSE_WARN(p71: string) -- Line: 328
    -- upvalues: Config (copy), u56 (copy)
    if not Config.LOG_VERBOSE then
        return;
    end;

    local string_rep_ret = string.rep("    ", u56.LogIndent);
    warn((`{string_rep_ret}[SmartBone][Warn]: {p71}`));
end;

function u56.SB_VERBOSE_ERROR(p72: string) -- Line: 338
    -- upvalues: Config (copy), u56 (copy)
    if not Config.LOG_VERBOSE then
        return;
    end;

    local string_rep_ret = string.rep("    ", u56.LogIndent);
    error((`{string_rep_ret}[SmartBone][Error]: {p72}`));
end;

return u56;
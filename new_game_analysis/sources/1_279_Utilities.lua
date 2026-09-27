-- Decompiled with Potassium's decompiler.

local HttpService = game:GetService("HttpService");
local Config = require(script.Parent:WaitForChild("Config"));
local DefaultObjectSettings = require(script.Parent:WaitForChild("DefaultObjectSettings"));
local u1 = {
    Block = "Box",
    Ball = "Sphere",
    Capsule = "Capsule",
    Sphere = "Sphere",
    Box = "Box",
    Cylinder = "Cylinder"
};

local function YAxisSafeUnit(p2: vector) -- Line: 14
    return p2.Magnitude <= 1e-6 and Vector3.new(-0, -1, -0) or p2.Unit;
end;

local u58 = {
    LogIndent = 0,

    GetRotationBetween = function(p3: vector, p4: vector) -- Line: 25, Name: GetRotationBetween
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

    GetCFrameAxis = function(p9, p10: string) -- Line: 44, Name: GetCFrameAxis
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

    GatherObjectSettings = function(u14: userdata) -- Line: 56, Name: GatherObjectSettings
        -- upvalues: DefaultObjectSettings (copy)
        local function Expect(p15: any, p16: string, p17: string) -- Line: 59
            -- upvalues: u14 (copy)
            if typeof(p15) == p16 then
                return true;
            end;

            warn((`[SmartBone][Object] Expected attribute {p17} on {u14.Name} to be of type {p16}, got type {typeof(p15)}`));

            return false;
        end;

        local v18 = {};

        for i, v in DefaultObjectSettings do
            local Attribute = u14:GetAttribute(i);

            if Attribute ~= nil then
                local v19 = typeof(v);
                local v20;

                if typeof(Attribute) == v19 then
                    v20 = true;
                else
                    warn((`[SmartBone][Object] Expected attribute {i} on {u14.Name} to be of type {v19}, got type {typeof(Attribute)}`));
                    v20 = false;
                end;

                if not v20 then
                    Attribute = nil;
                end;
            end;

            v18[i] = Attribute == nil and v and v or Attribute;
        end;

        return v18;
    end,

    GatherBoneSettings = function(u21: userdata) -- Line: 83, Name: GatherBoneSettings
        local function Attrib(p22: string) -- Line: 84
            -- upvalues: u21 (copy)
            return u21:GetAttribute(p22);
        end;

        local function _(p23: any, p24: string, p25: string) -- Line: 88
            -- upvalues: u21 (copy)
            if typeof(p23) ~= p24 then
                warn((`[SmartBone][Bone] Expected attribute {p25} on {u21.Name} to be of type {p24}, got type {typeof(p23)}`));
            end;
        end;

        local v26 = u21:GetAttribute("XAxisLocked") or false;
        local v27 = u21:GetAttribute("YAxisLocked") or false;
        local v28 = u21:GetAttribute("ZAxisLocked") or false;
        local v29 = u21:GetAttribute("XAxisLimits") or NumberRange.new((-1 / 0), (1 / 0));
        local v30 = u21:GetAttribute("YAxisLimits") or NumberRange.new((-1 / 0), (1 / 0));
        local v31 = u21:GetAttribute("ZAxisLimits") or NumberRange.new((-1 / 0), (1 / 0));
        local v32 = u21:GetAttribute("Radius") or 0.25;
        local v33 = u21:GetAttribute("RotationLimit") or 180;
        local v34 = u21:GetAttribute("Force") or "¬";
        local v35 = u21:GetAttribute("Gravity") or "¬";

        if typeof(v26) ~= "boolean" then
            warn((`[SmartBone][Bone] Expected attribute XAxisLocked on {u21.Name} to be of type boolean, got type {typeof(v26)}`));
        end;

        if typeof(v27) ~= "boolean" then
            warn((`[SmartBone][Bone] Expected attribute YAxisLocked on {u21.Name} to be of type boolean, got type {typeof(v27)}`));
        end;

        if typeof(v28) ~= "boolean" then
            warn((`[SmartBone][Bone] Expected attribute ZAxisLocked on {u21.Name} to be of type boolean, got type {typeof(v28)}`));
        end;

        if typeof(v29) ~= "NumberRange" then
            warn((`[SmartBone][Bone] Expected attribute XAxisLimits on {u21.Name} to be of type NumberRange, got type {typeof(v29)}`));
        end;

        if typeof(v30) ~= "NumberRange" then
            warn((`[SmartBone][Bone] Expected attribute YAxisLimits on {u21.Name} to be of type NumberRange, got type {typeof(v30)}`));
        end;

        if typeof(v31) ~= "NumberRange" then
            warn((`[SmartBone][Bone] Expected attribute ZAxisLimits on {u21.Name} to be of type NumberRange, got type {typeof(v31)}`));
        end;

        if typeof(v32) ~= "number" then
            warn((`[SmartBone][Bone] Expected attribute Radius on {u21.Name} to be of type number, got type {typeof(v32)}`));
        end;

        if typeof(v33) ~= "number" then
            warn((`[SmartBone][Bone] Expected attribute RotationLimit on {u21.Name} to be of type number, got type {typeof(v33)}`));
        end;

        if v34 ~= "¬" and typeof(v34) ~= "Vector3" then
            warn((`[SmartBone][Bone] Expected attribute Force on {u21.Name} to be of type Vector3, got type {typeof(v34)}`));
        end;

        if v34 ~= "¬" and typeof(v35) ~= "Vector3" then
            warn((`[SmartBone][Bone] Expected attribute Gravity on {u21.Name} to be of type Vector3, got type {typeof(v35)}`));
        end;

        return {
            AxisLocked = { v26, v27, v28 },
            XAxisLimits = v29,
            YAxisLimits = v30,
            ZAxisLimits = v31,
            RotationLimit = v33,
            Radius = v32,
            Force = v34,
            Gravity = v35
        };
    end,

    ClosestPointOnLine = function(p36: vector, p37: vector, p38: number, p39: vector) -- Line: 142, Name: ClosestPointOnLine
        local v40 = (p39 - p36):Dot(p37);

        return p36 + p37 * math.clamp(v40, -p38, p38);
    end,

    ClosestPointInBox = function(p41, p42: vector, p43: vector) -- Line: 150, Name: ClosestPointInBox
        local v44 = p41:PointToObjectSpace(p43);
        local X = p42.X;
        local X2 = p42.X;
        local Z = p42.Z;
        local X3 = v44.X;
        local Y = v44.Y;
        local Z2 = v44.Z;

        if v44 ~= v44 or p42 ~= p42 then
            return false, p41.Position, Vector3.new(0, 1, 0);
        end;

        local math_clamp_ret = math.clamp(X3, -X * 0.5, X * 0.5);
        local math_clamp_ret2 = math.clamp(Y, -X2 * 0.5, X2 * 0.5);
        local math_clamp_ret3 = math.clamp(Z2, -Z * 0.5, Z * 0.5);

        if math_clamp_ret ~= X3 or (math_clamp_ret2 ~= Y or math_clamp_ret3 ~= Z2) then
            local v45 = p41 * Vector3.new(math_clamp_ret, math_clamp_ret2, math_clamp_ret3);

            return false, v45, (p43 - v45).unit;
        end;

        local v46 = X3 - X * 0.5;
        local v47 = Y - X2 * 0.5;
        local v48 = Z2 - Z * 0.5;
        local v49 = -X3 - X * 0.5;
        local v50 = -Y - X2 * 0.5;
        local v51 = -Z2 - Z * 0.5;
        local math_max_ret = math.max(v46, v47, v48, v49, v50, v51);

        if math_max_ret == v46 then
            return true, p41 * Vector3.new(X * 0.5, Y, Z2), p41.XVector;
        end;

        if math_max_ret == v47 then
            return true, p41 * Vector3.new(X3, X2 * 0.5, Z2), p41.YVector;
        end;

        if math_max_ret == v48 then
            return true, p41 * Vector3.new(X3, Y, Z * 0.5), p41.ZVector;
        end;

        if math_max_ret == v49 then
            return true, p41 * Vector3.new(-X * 0.5, Y, Z2), -p41.XVector;
        end;

        if math_max_ret == v50 then
            return true, p41 * Vector3.new(X3, -X2 * 0.5, Z2), -p41.YVector;
        end;

        if math_max_ret == v51 then
            return true, p41 * Vector3.new(X3, Y, -Z * 0.5), -p41.ZVector;
        end;

        warn("CLOSEST POINT ON BOX FAIL");

        return false, Vector3.new(0, 0, 0), Vector3.new(0, 1, 0);
    end,

    GetCollider = function(p52: userdata) -- Line: 205, Name: GetCollider
        -- upvalues: HttpService (copy), u1 (copy)
        local v53 = p52:FindFirstChild("self.Collider");
        local v54;

        if v53 and v53:IsA("ModuleScript") then
            local u55 = require(v53);
            local u56 = nil;
            pcall(function() -- Line: 214
                -- upvalues: u56 (ref), HttpService (ref), u55 (copy)
                u56 = HttpService:JSONDecode(u55);
            end);
            v54 = u56;
        else
            v54 = nil;
        end;

        if v54 then
            return v54;
        end;

        local function GetShapeName(p57) -- Line: 227
            return p57:GetAttribute("ColliderShape") or (not p57:IsA("Part") and "Box" or p57.Shape.Name);
        end;

        return {
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
                Type = u1[p52:GetAttribute("ColliderShape") or (not p52:IsA("Part") and "Box" or p52.Shape.Name)] or "Box"
            }
        };
    end
};

function u58.SB_INDENT_LOG() -- Line: 261
    -- upvalues: u58 (copy)
    local v59 = u58;
    v59.LogIndent = v59.LogIndent + 1;
end;

function u58.SB_UNINDENT_LOG() -- Line: 265
    -- upvalues: u58 (copy)
    local v60 = u58;
    v60.LogIndent = v60.LogIndent - 1;
    u58.LogIndent = math.max(u58.LogIndent, 0);
end;

function u58.SB_ASSERT_CB(p61, p62, ...) -- Line: 270
    if p61 == false or p61 == nil then
        p62(...);
    end;
end;

function u58.SB_VERBOSE_LOG(p63: string) -- Line: 276
    -- upvalues: Config (copy), u58 (copy)
    if not Config.LOG_VERBOSE then
        return;
    end;

    local string_rep_ret = string.rep("    ", u58.LogIndent);
    print((`{string_rep_ret}[SmartBone][Log]: {p63}`));
end;

function u58.SB_VERBOSE_WARN(p64: string) -- Line: 286
    -- upvalues: Config (copy), u58 (copy)
    if not Config.LOG_VERBOSE then
        return;
    end;

    local string_rep_ret = string.rep("    ", u58.LogIndent);
    warn((`{string_rep_ret}[SmartBone][Warn]: {p64}`));
end;

function u58.SB_VERBOSE_ERROR(p65: string) -- Line: 296
    -- upvalues: Config (copy), u58 (copy)
    if not Config.LOG_VERBOSE then
        return;
    end;

    local string_rep_ret = string.rep("    ", u58.LogIndent);
    error((`{string_rep_ret}[SmartBone][Error]: {p65}`));
end;

return u58;
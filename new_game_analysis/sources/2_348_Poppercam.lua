-- Decompiled with Potassium's decompiler.

local v1 = require(script.Parent.Parent:WaitForChild("CommonUtils")).get("FlagUtil");
local ZoomController = require(script.Parent:WaitForChild("ZoomController"));
local UserFlag = v1.getUserFlag("UserFixCameraFPError");
local u2 = {};
u2.__index = u2;
local CFrame_new_ret = CFrame.new();

local function cframeToAxis(p3) -- Line: 17
    local v4, v5 = p3:ToAxisAngle();

    return v4 * v5;
end;

local function axisToCFrame(p6: vector) -- Line: 22
    -- upvalues: CFrame_new_ret (copy)
    local Magnitude = p6.Magnitude;

    if Magnitude > 0.00001 then
        return CFrame.fromAxisAngle(p6, Magnitude);
    end;

    return CFrame_new_ret;
end;

local function extractRotation(p7) -- Line: 30
    local _, _, _, v8, v9, v10, v11, v12, v13, v14, v15, v16 = p7:GetComponents();

    return CFrame.new(0, 0, 0, v8, v9, v10, v11, v12, v13, v14, v15, v16);
end;

function u2.new() -- Line: 35
    -- upvalues: u2 (copy)
    return setmetatable({
        lastCFrame = nil
    }, u2);
end;

function u2.Step(p17: table, p18: number, p19) -- Line: 41
    -- upvalues: CFrame_new_ret (copy)
    local v20 = p17.lastCFrame or p19;
    p17.lastCFrame = p19;
    local Position = p19.Position;
    local _, _, _, v21, v22, v23, v24, v25, v26, v27, v28, v29 = p19:GetComponents();
    local CFrame_new_ret2 = CFrame.new(0, 0, 0, v21, v22, v23, v24, v25, v26, v27, v28, v29);
    local Position2 = v20.Position;
    local _, _, _, v30, v31, v32, v33, v34, v35, v36, v37, v38 = v20:GetComponents();
    local CFrame_new_ret3 = CFrame.new(0, 0, 0, v30, v31, v32, v33, v34, v35, v36, v37, v38);
    local u39 = (Position - Position2) / p18;
    local v40, v41 = (CFrame_new_ret2 * CFrame_new_ret3:inverse()):ToAxisAngle();
    local u42 = v40 * v41 / p18;

    return {
        extrapolate = function(p43) -- Line: 56, Name: extrapolate
            -- upvalues: u39 (copy), Position (copy), u42 (copy), CFrame_new_ret (ref), CFrame_new_ret2 (copy)
            local v44 = u42 * p43;
            local Magnitude = v44.Magnitude;
            local v45;

            if Magnitude > 0.00001 then
                v45 = CFrame.fromAxisAngle(v44, Magnitude);
            else
                v45 = CFrame_new_ret;
            end;

            return v45 * CFrame_new_ret2 + (u39 * p43 + Position);
        end,

        posVelocity = u39,
        rotVelocity = u42
    };
end;

function u2.Reset(p46) -- Line: 69
    p46.lastCFrame = nil;
end;

local BaseOcclusion = require(script.Parent:WaitForChild("BaseOcclusion"));
local u47 = setmetatable({}, BaseOcclusion);
u47.__index = u47;

function u47.new() -- Line: 79
    -- upvalues: BaseOcclusion (copy), u47 (copy), u2 (copy)
    local v48 = BaseOcclusion.new();
    local v49 = setmetatable(v48, u47);
    v49.focusExtrapolator = u2.new();

    return v49;
end;

function u47.GetOcclusionMode(p50) -- Line: 85
    return Enum.DevCameraOcclusionMode.Zoom;
end;

function u47.Enable(p51, p52) -- Line: 89
    p51.focusExtrapolator:Reset();
end;

function u47.Update(p53, p54, p55, p56, p57) -- Line: 93
    -- upvalues: UserFlag (copy), ZoomController (copy)
    local v58;

    if UserFlag then
        v58 = CFrame.lookAlong(p56.Position, -p55.LookVector) * CFrame.new(0, 0, 0, -1, 0, 0, 0, 1, 0, 0, 0, -1);
    else
        v58 = CFrame.new(p56.Position, p55.Position) * CFrame.new(0, 0, 0, -1, 0, 0, 0, 1, 0, 0, 0, -1);
    end;

    local v59 = p53.focusExtrapolator:Step(p54, v58);
    local v60 = ZoomController.Update(p54, v58, v59);

    return v58 * CFrame.new(0, 0, v60), p56;
end;

function u47.CharacterAdded(p61, p62, p63) -- Line: 117
end;

function u47.CharacterRemoving(p64, p65, p66) -- Line: 121
end;

function u47.OnCameraSubjectChanged(p67, p68) -- Line: 124
end;

return u47;
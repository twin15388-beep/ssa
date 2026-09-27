-- Decompiled with Potassium's decompiler.

local Popper = require(script:WaitForChild("Popper"));
local math_clamp = math.clamp;
local math_exp = math.exp;
local math_min = math.min;
local math_max = math.max;
local u1 = nil;
local u2 = nil;
local LocalPlayer = game:GetService("Players").LocalPlayer;
assert(LocalPlayer);

local function updateBounds() -- Line: 23
    -- upvalues: u1 (ref), LocalPlayer (copy), u2 (ref)
    u1 = LocalPlayer.CameraMinZoomDistance;
    u2 = LocalPlayer.CameraMaxZoomDistance;
end;

u1 = LocalPlayer.CameraMinZoomDistance;
u2 = LocalPlayer.CameraMaxZoomDistance;
LocalPlayer:GetPropertyChangedSignal("CameraMinZoomDistance"):Connect(updateBounds);
LocalPlayer:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(updateBounds);
local u3 = {};
u3.__index = u3;

function u3.new(p4: number, p5: number, p6: number, p7: number) -- Line: 37
    -- upvalues: math_clamp (copy), u3 (copy)
    local v8 = math_clamp(p5, p6, p7);

    return setmetatable({
        v = 0,
        freq = p4,
        x = v8,
        minValue = p6,
        maxValue = p7,
        goal = v8
    }, u3);
end;

function u3.Step(p9: table, p10: number) -- Line: 49
    -- upvalues: math_exp (copy)
    local v11 = p9.freq * 2 * 3.141592653589793;
    local v = p9.v;
    local minValue = p9.minValue;
    local maxValue = p9.maxValue;
    local goal = p9.goal;
    local v12 = goal - p9.x;
    local v13 = v11 * p10;
    local v14 = math_exp(-v13);
    local v15 = goal + (v * p10 - v12 * (v13 + 1)) * v14;
    local v16 = ((v12 * v11 - v) * v13 + v) * v14;

    if v15 < minValue then
        maxValue = minValue;
        v16 = 0;
    elseif maxValue < v15 then
        v16 = 0;
    else
        maxValue = v15;
    end;

    p9.x = maxValue;
    p9.v = v16;

    return maxValue;
end;

local u17 = u3.new(4.5, 12.5, 0.5, u2);

local function stepTargetZoom(p18: number, p19: number, p20: number, p21: number) -- Line: 87
    -- upvalues: math_clamp (copy)
    local v22 = math_clamp(p18 + p19 * (p18 * 0.0375 + 1), p20, p21);

    return v22 < 1 and (p19 <= 0 and p20 and p20 or 1) or v22;
end;

local u23 = 0;

return {
    Update = function(p24: number, p25, p26: any) -- Line: 98, Name: Update
        -- upvalues: u17 (copy), u23 (ref), u1 (ref), u2 (ref), math_clamp (copy), math_max (copy), Popper (copy), math_min (copy)
        local v27;

        if u17.goal > 1 then
            local x = u17.x;
            local goal = u17.goal;
            local v28 = u23;
            local v29 = u1;
            local v30 = math_clamp(goal + v28 * (goal * 0.0375 + 1), v29, u2);
            local v31 = math_max(x, v30 < 1 and (v28 <= 0 and v29 and v29 or 1) or v30);
            v27 = Popper(p25 * CFrame.new(0, 0, 0.5), v31 - 0.5, p26) + 0.5;
        else
            v27 = (1 / 0);
        end;

        u17.minValue = 0.5;
        u17.maxValue = math_min(u2, v27);

        return u17:Step(p24);
    end,

    GetZoomRadius = function() -- Line: 122, Name: GetZoomRadius
        -- upvalues: u17 (copy)
        return u17.x;
    end,

    SetZoomParameters = function(p32, p33) -- Line: 126, Name: SetZoomParameters
        -- upvalues: u17 (copy), u23 (ref)
        u17.goal = p32;
        u23 = p33;
    end,

    ReleaseSpring = function() -- Line: 131, Name: ReleaseSpring
        -- upvalues: u17 (copy)
        u17.x = u17.goal;
        u17.v = 0;
    end
};
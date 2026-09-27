-- Decompiled with Potassium's decompiler.

local u1 = {};

function u1.new(p2, p3) -- Line: 38
    -- upvalues: u1 (copy)
    local v4 = p2 or 0;
    local v5 = p3 or os.clock;
    local v6 = {
        _damper = 1,
        _speed = 1,
        _clock = v5,
        _time0 = v5(),
        _position0 = v4,
        _velocity0 = 0 * v4,
        _target = v4
    };

    return setmetatable(v6, u1);
end;

function u1.Impulse(p7, p8) -- Line: 58
    p7.Velocity = p7.Velocity + p8;
end;

function u1.TimeSkip(p9, p10) -- Line: 67
    local v11 = p9._clock();
    local v12, v13 = p9:_positionVelocity(v11 + p10);
    p9._position0 = v12;
    p9._velocity0 = v13;
    p9._time0 = v11;
end;

function u1.__index(p14, p15) -- Line: 143
    -- upvalues: u1 (copy)
    if u1[p15] then
        return u1[p15];
    end;

    if p15 == "Value" or (p15 == "Position" or p15 == "p") then
        local v16, _ = p14:_positionVelocity(p14._clock());

        return v16;
    end;

    if p15 == "Velocity" or p15 == "v" then
        local _, v17 = p14:_positionVelocity(p14._clock());

        return v17;
    end;

    if p15 == "Target" or p15 == "t" then
        return p14._target;
    end;

    if p15 == "Damper" or p15 == "d" then
        return p14._damper;
    end;

    if p15 == "Speed" or p15 == "s" then
        return p14._speed;
    end;

    if p15 == "Clock" then
        return p14._clock;
    end;

    error(("%q is not a valid member of Spring"):format((tostring(p15))), 2);
end;

function u1.__newindex(p18, p19, p20) -- Line: 165
    local v21 = p18._clock();

    if p19 == "Value" or (p19 == "Position" or p19 == "p") then
        local _, v22 = p18:_positionVelocity(v21);
        p18._position0 = p20;
        p18._velocity0 = v22;
        p18._time0 = v21;

        return;
    end;

    if p19 == "Velocity" or p19 == "v" then
        local v23, _ = p18:_positionVelocity(v21);
        p18._position0 = v23;
        p18._velocity0 = p20;
        p18._time0 = v21;

        return;
    end;

    if p19 == "Target" or p19 == "t" then
        local v24, v25 = p18:_positionVelocity(v21);
        p18._position0 = v24;
        p18._velocity0 = v25;
        p18._target = p20;
        p18._time0 = v21;

        return;
    end;

    if p19 == "Damper" or p19 == "d" then
        local v26, v27 = p18:_positionVelocity(v21);
        p18._position0 = v26;
        p18._velocity0 = v27;
        p18._damper = p20;
        p18._time0 = v21;

        return;
    end;

    if p19 == "Speed" or p19 == "s" then
        local v28, v29 = p18:_positionVelocity(v21);
        p18._position0 = v28;
        p18._velocity0 = v29;
        p18._speed = p20 < 0 and 0 or p20;
        p18._time0 = v21;

        return;
    end;

    if p19 ~= "Clock" then
        error(("%q is not a valid member of Spring"):format((tostring(p19))), 2);

        return;
    end;

    local v30, v31 = p18:_positionVelocity(v21);
    p18._position0 = v30;
    p18._velocity0 = v31;
    p18._clock = p20;
    p18._time0 = p20();
end;

function u1._positionVelocity(p32, p33) -- Line: 207
    local _position0 = p32._position0;
    local _velocity0 = p32._velocity0;
    local _target = p32._target;
    local _damper = p32._damper;
    local _speed = p32._speed;
    local v34 = _speed * (p33 - p32._time0);
    local v35 = _damper * _damper;
    local v36, v37, v38;

    if v35 < 1 then
        v36 = math.sqrt(1 - v35);
        local v39 = math.exp(-_damper * v34) / v36;
        v37 = v39 * math.cos(v36 * v34);
        v38 = v39 * math.sin(v36 * v34);
    elseif v35 == 1 then
        v36 = 1;
        v37 = math.exp(-_damper * v34) / v36;
        v38 = v37 * v34;
    else
        v36 = math.sqrt(v35 - 1);
        local v40 = math.exp((-_damper + v36) * v34) / (2 * v36);
        local v41 = math.exp((-_damper - v36) * v34) / (2 * v36);
        v37 = v40 + v41;
        v38 = v40 - v41;
    end;

    return (v36 * v37 + _damper * v38) * _position0 + (1 - (v36 * v37 + _damper * v38)) * _target + v38 / _speed * _velocity0, -_speed * v38 * _position0 + _speed * v38 * _target + (v36 * v37 - _damper * v38) * _velocity0;
end;

return u1;
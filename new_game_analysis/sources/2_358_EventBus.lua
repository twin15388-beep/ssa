-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;

function u1.new() -- Line: 20
    -- upvalues: u1 (copy)
    local v2 = setmetatable({}, u1);
    v2._events = {};

    return v2;
end;

function u1._getOrCreate(p3: table, p4: string) -- Line: 26
    if not p3._events[p4] then
        local BindableEvent = Instance.new("BindableEvent");
        BindableEvent.Name = p4;
        p3._events[p4] = BindableEvent;
    end;

    return p3._events[p4];
end;

function u1.publish(p5: table, p6: string, ...) -- Line: 35
    p5:_getOrCreate(p6):Fire(...);
end;

function u1.subscribe(p7: table, p8: string) -- Line: 40
    return p7:_getOrCreate(p8).Event;
end;

return u1;
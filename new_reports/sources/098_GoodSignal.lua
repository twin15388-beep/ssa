-- Decompiled with Potassium's decompiler.

local u1 = nil;

local function acquireRunnerThreadAndCallEventHandler(p2, ...) -- Line: 34
    -- upvalues: u1 (ref)
    local v3 = u1;
    u1 = nil;
    p2(...);
    u1 = v3;
end;

local function runEventHandlerInFreeThread() -- Line: 45
    -- upvalues: acquireRunnerThreadAndCallEventHandler (copy)
    while true do
        acquireRunnerThreadAndCallEventHandler(coroutine.yield());
    end;
end;

local u4 = {};
u4.__index = u4;

function u4.new(p5, p6) -- Line: 60
    -- upvalues: u4 (copy)
    return setmetatable({
        _connected = true,
        _next = false,
        _signal = p5,
        _fn = p6
    }, u4);
end;

function u4.Disconnect(p7) -- Line: 69
    p7._connected = false;

    if p7._signal._handlerListHead == p7 then
        p7._signal._handlerListHead = p7._next;

        return;
    end;

    local _handlerListHead = p7._signal._handlerListHead;

    while _handlerListHead and _handlerListHead._next ~= p7 do
        _handlerListHead = _handlerListHead._next;
    end;

    if _handlerListHead then
        _handlerListHead._next = p7._next;
    end;
end;

u4.Destroy = u4.Disconnect;
setmetatable(u4, {
    __index = function(p8, p9) -- Line: 92, Name: __index
        error(("Attempt to get Connection::%s (not a valid member)"):format((tostring(p9))), 2);
    end,

    __newindex = function(p10, p11, p12) -- Line: 95, Name: __newindex
        error(("Attempt to set Connection::%s (not a valid member)"):format((tostring(p11))), 2);
    end
});
local u13 = {};
u13.__index = u13;

function u13.new() -- Line: 104
    -- upvalues: u13 (copy)
    return setmetatable({
        _handlerListHead = false
    }, u13);
end;

function u13.Connect(p14, p15) -- Line: 110
    -- upvalues: u4 (copy)
    local v16 = u4.new(p14, p15);

    if not p14._handlerListHead then
        p14._handlerListHead = v16;

        return v16;
    end;

    v16._next = p14._handlerListHead;
    p14._handlerListHead = v16;

    return v16;
end;

function u13.DisconnectAll(p17) -- Line: 123
    p17._handlerListHead = false;
end;

u13.Destroy = u13.DisconnectAll;

function u13.Fire(p18, ...) -- Line: 132
    -- upvalues: u1 (ref), runEventHandlerInFreeThread (copy)
    local _handlerListHead = p18._handlerListHead;

    while _handlerListHead do
        if _handlerListHead._connected then
            if not u1 then
                u1 = coroutine.create(runEventHandlerInFreeThread);
                coroutine.resume(u1);
            end;

            task.spawn(u1, _handlerListHead._fn, ...);
        end;

        _handlerListHead = _handlerListHead._next;
    end;
end;

function u13.Wait(p19) -- Line: 149
    local coroutine_running_ret = coroutine.running();
    local u20 = nil;
    u20 = p19:Connect(function(...) -- Line: 152
        -- upvalues: u20 (ref), coroutine_running_ret (copy)
        u20:Disconnect();
        task.spawn(coroutine_running_ret, ...);
    end);

    return coroutine.yield();
end;

function u13.Once(p21, u22) -- Line: 161
    local u23 = nil;
    u23 = p21:Connect(function(...) -- Line: 163
        -- upvalues: u23 (ref), u22 (copy)
        if u23._connected then
            u23:Disconnect();
        end;

        u22(...);
    end);

    return u23;
end;

setmetatable(u13, {
    __index = function(p24, p25) -- Line: 174, Name: __index
        error(("Attempt to get Signal::%s (not a valid member)"):format((tostring(p25))), 2);
    end,

    __newindex = function(p26, p27, p28) -- Line: 177, Name: __newindex
        error(("Attempt to set Signal::%s (not a valid member)"):format((tostring(p27))), 2);
    end
});

return u13;
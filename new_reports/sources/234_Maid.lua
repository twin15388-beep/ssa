-- Decompiled with Potassium's decompiler.

local u1 = {
    ClassName = "Maid"
};

function u1.new() -- Line: 37
    -- upvalues: u1 (copy)
    return setmetatable({
        _tasks = {}
    }, u1);
end;

function u1.isMaid(p2) -- Line: 54
    local v3;

    if type(p2) == "table" then
        v3 = p2.ClassName == "Maid";
    else
        v3 = false;
    end;

    return v3;
end;

function u1.__index(p4, p5) -- Line: 73
    -- upvalues: u1 (copy)
    if u1[p5] then
        return u1[p5];
    end;

    return p4._tasks[p5];
end;

function u1.__newindex(p6, p7, p8) -- Line: 100
    -- upvalues: u1 (copy)
    if u1[p7] ~= nil then
        error(("Cannot use \'%s\' as a Maid key"):format((tostring(p7))), 2);
    end;

    local _tasks = p6._tasks;
    local v9 = _tasks[p7];

    if v9 == p8 then
        return;
    end;

    _tasks[p7] = p8;

    if v9 then
        if type(v9) == "function" then
            v9();

            return;
        end;

        if type(v9) == "thread" then
            task.cancel(v9);

            return;
        end;

        if typeof(v9) == "RBXScriptConnection" then
            v9:Disconnect();

            return;
        end;

        if v9.Destroy then
            v9:Destroy();
        end;
    end;
end;

function u1.GiveTask(p10, p11) -- Line: 133
    if not p11 then
        error("Task cannot be false or nil", 2);
    end;

    local v12 = #p10._tasks + 1;
    p10[v12] = p11;

    if type(p11) == "table" and not p11.Destroy then
        warn("[Maid.GiveTask] - Gave table task without .Destroy\n\n" .. debug.traceback());
    end;

    return v12;
end;

function u1.GivePromise(u13, p14) -- Line: 154
    if not p14:IsPending() then
        return p14;
    end;

    local v15 = p14.resolved(p14);
    local u16 = u13:GiveTask(v15);
    v15:Finally(function() -- Line: 163
        -- upvalues: u13 (copy), u16 (copy)
        u13[u16] = nil;
    end);

    return v15;
end;

function u1.DoCleaning(p17) -- Line: 186
    local _tasks = p17._tasks;

    for i, v in pairs(_tasks) do
        if typeof(v) == "RBXScriptConnection" then
            _tasks[i] = nil;
            v:Disconnect();
        end;
    end;

    local v18, v19 = next(_tasks);

    while v19 ~= nil do
        _tasks[v18] = nil;

        if type(v19) == "function" then
            v19();
        elseif type(v19) == "thread" then
            task.cancel(v19);
        elseif typeof(v19) == "RBXScriptConnection" then
            v19:Disconnect();
        elseif v19.Destroy then
            v19:Destroy();
        end;

        v18, v19 = next(_tasks);
    end;
end;

u1.Destroy = u1.DoCleaning;

return u1;
-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;

function u1.new() -- Line: 25
    -- upvalues: u1 (copy)
    local v2 = setmetatable({}, u1);
    v2._connections = {};

    return v2;
end;

function u1.trackConnection(p3, p4, u5) -- Line: 33
    if p3._connections[p4] then
        p3._connections[p4]();
    end;

    p3._connections[p4] = function() -- Line: 38
        -- upvalues: u5 (copy)
        u5:Disconnect();
    end;
end;

function u1.trackBoundFunction(p6, p7, p8) -- Line: 41
    if p6._connections[p7] then
        p6._connections[p7]();
    end;

    p6._connections[p7] = p8;
end;

function u1.disconnect(p9, p10) -- Line: 48
    if p9._connections[p10] then
        p9._connections[p10]();
        p9._connections[p10] = nil;
    end;
end;

function u1.disconnectAll(p11) -- Line: 55
    for _, v in pairs(p11._connections) do
        v();
    end;

    p11._connections = {};
end;

return u1;
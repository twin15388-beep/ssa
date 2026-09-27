-- Decompiled with Potassium's decompiler.

local ConnectionUtil = require(script.Parent.ConnectionUtil);
local u1 = {};
u1.__index = u1;

function u1.new() -- Line: 39
    -- upvalues: ConnectionUtil (copy), u1 (copy)
    local v2 = {
        _enabled = false,
        _camera = game.Workspace.CurrentCamera,
        _callbacks = {},
        _connectionUtil = ConnectionUtil.new()
    };

    return setmetatable(v2, u1);
end;

function u1._connectCallbacks(p3) -- Line: 52
    p3._camera = game.Workspace.CurrentCamera;

    if not p3._camera then
        return;
    end;

    for i, v in p3._callbacks do
        p3._connectionUtil:trackConnection(i, p3._camera:GetPropertyChangedSignal(i):Connect(v));
        v();
    end;
end;

function u1.Enable(u4) -- Line: 65
    if u4._enabled then
        return;
    end;

    u4._enabled = true;
    u4._cameraChangedConnection = game.Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- Line: 72
        -- upvalues: u4 (copy)
        u4:_connectCallbacks();
    end);
    u4:_connectCallbacks();
end;

function u1.Disable(p5) -- Line: 79
    if not p5._enabled then
        return;
    end;

    p5._enabled = false;

    if p5._cameraChangedConnection then
        p5._cameraChangedConnection:Disconnect();
        p5._cameraChangedConnection = nil;
    end;

    p5._connectionUtil:disconnectAll();
end;

function u1.Connect(p6: table, p7: string, p8: function) -- Line: 94
    p6._callbacks[p7] = p8;

    if not p6._camera then
        return;
    end;

    p6._connectionUtil:trackConnection(p7, p6._camera:GetPropertyChangedSignal(p7):Connect(p8));
end;

function u1.Disconnect(p9: table, p10: string) -- Line: 104
    p9._connectionUtil:disconnect(p10);
    p9._callbacks[p10] = nil;
end;

function u1.getCamera(p11) -- Line: 110
    return p11._camera;
end;

return u1;
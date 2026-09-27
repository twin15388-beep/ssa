-- Decompiled with Potassium's decompiler.

local v1 = {};
local RemotePlus = game.ReplicatedStorage.RemotePlus;
local Utility = require(RemotePlus.Handlers.Utility);
local Remote = Utility.GetRemote(script, "Function");
local InvokerMain = require(RemotePlus.Handlers.InvokerMain);
local FireFunction = Utility.GetFireFunction(Remote, true);
local FireFunction2 = Utility.GetFireFunction(Remote);

function v1.Connect(p2: table, p3: function) -- Line: 23
    -- upvalues: Remote (copy), InvokerMain (copy)
    if Remote == nil then
        return;
    end;

    InvokerMain.Connect(Remote, p3);
end;

function v1.ToAll(...) -- Line: 27
    -- upvalues: FireFunction (copy), InvokerMain (copy), Remote (copy)
    if FireFunction ~= nil then
        return InvokerMain.ToAll(Remote, FireFunction, ...);
    end;
end;

function v1.ToClient(p4: userdata, ...) -- Line: 31
    -- upvalues: FireFunction2 (copy), InvokerMain (copy), Remote (copy)
    if FireFunction2 ~= nil then
        return InvokerMain.To(Remote, FireFunction2, p4, ...);
    end;
end;

function v1.ToServer(...) -- Line: 35
    -- upvalues: Utility (copy), FireFunction2 (copy), InvokerMain (copy), Remote (copy)
    if not Utility.IsServer and FireFunction2 ~= nil then
        return InvokerMain.To(Remote, FireFunction2, ...);
    end;
end;

function v1.ToAllExcept(p5: userdata, ...) -- Line: 39
    -- upvalues: FireFunction2 (copy), InvokerMain (copy), Remote (copy)
    if FireFunction2 ~= nil then
        return InvokerMain.ToAllExcept(Remote, FireFunction2, p5, ...);
    end;
end;

function v1.ToAllInRange(p6, ...) -- Line: 44
    -- upvalues: FireFunction2 (copy), InvokerMain (copy), Remote (copy)
    if FireFunction2 ~= nil then
        return InvokerMain.ToAllInRange(Remote, FireFunction2, p6, 500, ...);
    end;
end;

function v1.ToOthersInRange(p7, ...) -- Line: 48
    -- upvalues: FireFunction2 (copy), InvokerMain (copy), Remote (copy)
    if FireFunction2 ~= nil then
        return InvokerMain.ToOthersInRange(Remote, FireFunction2, p7, 500, ...);
    end;
end;

return v1;
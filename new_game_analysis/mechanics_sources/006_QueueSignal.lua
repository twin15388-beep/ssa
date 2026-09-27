-- Decompiled with Potassium's decompiler.

local v1 = {};
local RemotePlus = game.ReplicatedStorage.RemotePlus;
local Utility = require(RemotePlus.Handlers.Utility);
local Remote = Utility.GetRemote(script, "Function");
local InvokerMain = require(RemotePlus.Handlers.InvokerMain);
local FireFunction = Utility.GetFireFunction(Remote);

function v1.Connect(p2: table, p3: function) -- Line: 25
    -- upvalues: Remote (copy), InvokerMain (copy)
    if Remote == nil then
        return;
    end;

    InvokerMain.Connect(Remote, p3);
end;

function v1.ToClient(p4: userdata, ...) -- Line: 29
    -- upvalues: FireFunction (copy), InvokerMain (copy), Remote (copy)
    if FireFunction ~= nil then
        return InvokerMain.To(Remote, FireFunction, p4, ...);
    end;
end;

function v1.ToServer(...) -- Line: 33
    -- upvalues: Utility (copy), FireFunction (copy), InvokerMain (copy), Remote (copy)
    if not Utility.IsServer and FireFunction ~= nil then
        return InvokerMain.To(Remote, FireFunction, ...);
    end;
end;

return v1;
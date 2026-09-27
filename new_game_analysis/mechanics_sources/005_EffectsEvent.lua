-- Decompiled with Potassium's decompiler.

local v1 = {};
local RemotePlus = game.ReplicatedStorage.RemotePlus;
local Utility = require(RemotePlus.Handlers.Utility);
local Remote = Utility.GetRemote(script, "Event");
local EventerMain = require(RemotePlus.Handlers.EventerMain);
local FireFunction = Utility.GetFireFunction(Remote, true);
local FireFunction2 = Utility.GetFireFunction(Remote);

function v1.Connect(p2: table, p3: function) -- Line: 23
    -- upvalues: Remote (copy), EventerMain (copy)
    if Remote ~= nil then
        return EventerMain.Connect(Remote, p3);
    end;
end;

function v1.ToAll(...) -- Line: 27
    -- upvalues: FireFunction (copy), EventerMain (copy), Remote (copy)
    if FireFunction == nil then
        return;
    end;

    EventerMain.ToAll(Remote, FireFunction, ...);
end;

function v1.ToClient(p4: userdata, ...) -- Line: 31
    -- upvalues: FireFunction2 (copy), EventerMain (copy), Remote (copy)
    if FireFunction2 == nil then
        return;
    end;

    EventerMain.To(Remote, FireFunction2, p4, ...);
end;

function v1.ToServer(...) -- Line: 35
    -- upvalues: Utility (copy), FireFunction2 (copy), EventerMain (copy), Remote (copy)
    if Utility.IsServer or FireFunction2 == nil then
        return;
    end;

    EventerMain.To(Remote, FireFunction2, ...);
end;

function v1.ToAllExcept(p5: userdata, ...) -- Line: 39
    -- upvalues: FireFunction2 (copy), EventerMain (copy), Remote (copy)
    if FireFunction2 == nil then
        return;
    end;

    EventerMain.ToAllExcept(Remote, FireFunction2, p5, ...);
end;

function v1.ToAllInRange(p6, ...) -- Line: 44
    -- upvalues: FireFunction2 (copy), EventerMain (copy), Remote (copy)
    if FireFunction2 == nil then
        return;
    end;

    if typeof(p6) == "Instance" and (p6:IsA("Model") and p6.PrimaryPart == nil) then
        return;
    end;

    EventerMain.ToAllInRange(Remote, FireFunction2, p6, 500, ...);
end;

function v1.ToOthersInRange(p7, ...) -- Line: 52
    -- upvalues: FireFunction2 (copy), EventerMain (copy), Remote (copy)
    if FireFunction2 == nil then
        return;
    end;

    if typeof(p7) == "Instance" and (p7:IsA("Model") and p7.PrimaryPart == nil) then
        return;
    end;

    EventerMain.ToOthersInRange(Remote, FireFunction2, p7, 500, ...);
end;

return v1;
-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local SignalFunction = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalFunction);
local u1 = {};

for _, v in ipairs(script.Parent:QueryDescendants("ModuleScript")) do
    u1[v.Name] = require(v);
end;

local function v3(p2, ...) -- Line: 12
    -- upvalues: u1 (copy)
    if p2 == nil then
        return;
    end;

    if u1[p2] ~= nil then
        return u1[p2](...);
    end;
end;

SignalEvent:Connect(v3);
SignalFunction:Connect(v3);
SignalEvent.ToServer("ClientReady");
-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Platform_Handler = require(ReplicatedStorage.CAM.Client.Controllers.Platform_Handler);
local SignalEvent = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalEvent);
local u1 = nil;
Platform_Handler.Platform.Changed.Event:Connect(function() -- Line: 14, Name: report
    -- upvalues: Platform_Handler (copy), u1 (ref), SignalEvent (copy)
    local Value = Platform_Handler.Platform.Value;

    if Value == "" or Value == u1 then
        return;
    end;

    u1 = Value;
    SignalEvent.ToServer("Device", Value);
end);
local Value = Platform_Handler.Platform.Value;

if Value ~= "" and Value ~= u1 then
    u1 = Value;
    SignalEvent.ToServer("Device", Value);
end;
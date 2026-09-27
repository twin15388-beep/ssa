-- Decompiled with Potassium's decompiler.

local _ = tick;
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Combat_presets"));
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Packages.cleanit);
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local Players = game:GetService("Players");
local table_clone_ret = table.clone(Utility.Cancel_Values);
table_clone_ret.pause_gameplay = true;
table_clone_ret.Swapping = true;
table_clone_ret.Blocking = true;
local Checker = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Checker"));
local script_RunHandlerSettings = require(script.RunHandlerSettings);
local Platform_Handler = require(ReplicatedStorage.CAM.Client.Controllers.Platform_Handler);
script_RunHandlerSettings.ShiftLockChanged = Instance.new("BindableEvent");

function script_RunHandlerSettings.SetShiftLock(p1: number) -- Line: 35
    -- upvalues: script_RunHandlerSettings (copy)
    local v2 = p1 == 1 and 1 or 0;

    if script_RunHandlerSettings.Shift_lock == v2 then
        return;
    end;

    script_RunHandlerSettings.Shift_lock = v2;
    script_RunHandlerSettings.ShiftLockChanged:Fire(v2);
end;

local u3 = nil;
local u4 = nil;

local function menuOpen() -- Line: 43
    -- upvalues: u3 (ref)
    local v5;

    if u3 == nil then
        v5 = false;
    else
        v5 = u3.Value ~= "";
    end;

    return v5;
end;

local function platformLock() -- Line: 48
    -- upvalues: Platform_Handler (copy)
    return Platform_Handler.IsGamepad() and 1 or 0;
end;

local function applyShiftLock(p6: boolean?) -- Line: 51
    -- upvalues: u3 (ref), u4 (ref), script_RunHandlerSettings (copy), Platform_Handler (copy)
    local v7;

    if u3 == nil then
        v7 = false;
    else
        v7 = u3.Value ~= "";
    end;

    if v7 then
        if u4 == nil then
            u4 = script_RunHandlerSettings.Shift_lock;
        end;

        if p6 then
            u4 = Platform_Handler.IsGamepad() and 1 or 0;
        end;

        script_RunHandlerSettings.SetShiftLock(0);

        return;
    end;

    if u4 ~= nil then
        script_RunHandlerSettings.SetShiftLock(u4);
        u4 = nil;
    end;

    if p6 then
        script_RunHandlerSettings.SetShiftLock(Platform_Handler.IsGamepad() and 1 or 0);

        return;
    end;

    if Platform_Handler.IsGamepad() then
        script_RunHandlerSettings.SetShiftLock(1);
    end;
end;

applyShiftLock();
Platform_Handler.Platform.Changed.Event:Connect(function() -- Line: 79
    -- upvalues: u3 (ref), u4 (ref), script_RunHandlerSettings (copy), Platform_Handler (copy)
    local v8;

    if u3 == nil then
        v8 = false;
    else
        v8 = u3.Value ~= "";
    end;

    if not v8 then
        if u4 ~= nil then
            script_RunHandlerSettings.SetShiftLock(u4);
            u4 = nil;
        end;

        script_RunHandlerSettings.SetShiftLock(Platform_Handler.IsGamepad() and 1 or 0);

        return;
    end;

    if u4 == nil then
        u4 = script_RunHandlerSettings.Shift_lock;
    end;

    u4 = Platform_Handler.IsGamepad() and 1 or 0;
    script_RunHandlerSettings.SetShiftLock(0);
end);
task.spawn(function() -- Line: 84
    -- upvalues: Players (copy), u3 (ref), applyShiftLock (copy)
    local MenuDestination = Players.LocalPlayer:WaitForChild("MenuDestination", 99);

    if MenuDestination == nil or not MenuDestination:IsA("StringValue") then
        return;
    end;

    u3 = MenuDestination;
    MenuDestination.Changed:Connect(applyShiftLock);
    applyShiftLock();
end);

function script_RunHandlerSettings.CanRun() -- Line: 91
    -- upvalues: Checker (copy), Players (copy)
    return Checker.check(Players.LocalPlayer, "Run") == true;
end;

function script_RunHandlerSettings.check_can_run() -- Line: 95
    -- upvalues: script_RunHandlerSettings (copy)
    local v9 = not script_RunHandlerSettings.IsWalking and script_RunHandlerSettings.CanRun();

    return v9;
end;

script_RunHandlerSettings.RunningChanged = Instance.new("BindableEvent");

return script_RunHandlerSettings;
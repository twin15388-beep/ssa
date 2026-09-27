-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local StarterGui = game:GetService("StarterGui");
local valuesfolder = require(ReplicatedStorage.CAM.Global.Utility).getvaluesfolder(Players.LocalPlayer, true);
local u1 = nil;

local function apply(u2: boolean) -- Line: 22
    -- upvalues: u1 (ref), StarterGui (copy)
    if u1 == u2 then
        return;
    end;

    u1 = u2;
    task.spawn(function() -- Line: 26
        -- upvalues: StarterGui (ref), u2 (copy), u1 (ref)
        local v3 = 0;

        while not pcall(StarterGui.SetCore, StarterGui, "ResetButtonCallback", u2) do
            v3 = v3 + 1;

            if v3 > 20 or u1 ~= u2 then
                return;
            end;

            task.wait(0.5);
        end;
    end);
end;

valuesfolder.ChildAdded:Connect(function(p4) -- Line: 36
    -- upvalues: u1 (ref), StarterGui (copy)
    if p4.Name ~= "DisableReset" then
        return;
    end;

    if u1 == false then
        return;
    end;

    u1 = false;
    local u5 = false;
    task.spawn(function() -- Line: 26
        -- upvalues: StarterGui (ref), u5 (copy), u1 (ref)
        local v6 = 0;

        while not pcall(StarterGui.SetCore, StarterGui, "ResetButtonCallback", u5) do
            v6 = v6 + 1;

            if v6 > 20 or u1 ~= u5 then
                return;
            end;

            task.wait(0.5);
        end;
    end);
end);
valuesfolder.ChildRemoved:Connect(function(p7) -- Line: 40
    -- upvalues: valuesfolder (copy), u1 (ref), StarterGui (copy)
    if p7.Name ~= "DisableReset" then
        return;
    end;

    local u8 = valuesfolder:FindFirstChild("DisableReset") == nil;

    if u1 == u8 then
        return;
    end;

    u1 = u8;
    task.spawn(function() -- Line: 26
        -- upvalues: StarterGui (ref), u8 (copy), u1 (ref)
        local v9 = 0;

        while not pcall(StarterGui.SetCore, StarterGui, "ResetButtonCallback", u8) do
            v9 = v9 + 1;

            if v9 > 20 or u1 ~= u8 then
                return;
            end;

            task.wait(0.5);
        end;
    end);
end);
local u10 = valuesfolder:FindFirstChild("DisableReset") == nil;

if u1 ~= u10 then
    u1 = u10;
    task.spawn(function() -- Line: 26
        -- upvalues: StarterGui (copy), u10 (copy), u1 (ref)
        local v11 = 0;

        while not pcall(StarterGui.SetCore, StarterGui, "ResetButtonCallback", u10) do
            v11 = v11 + 1;

            if v11 > 20 or u1 ~= u10 then
                return;
            end;

            task.wait(0.5);
        end;
    end);
end;
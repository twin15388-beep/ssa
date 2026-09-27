-- Decompiled with Potassium's decompiler.

local u1 = false;
local Run_Handler = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Modules"):WaitForChild("GamePlay"):WaitForChild("Run_Handler"));
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local InputHandler = require(ReplicatedStorage.CAM.Client.Components.Client.InputHandler);
local DataValue = require(ReplicatedStorage.CAM.Client.Modules.DataValue);
local SettingsKeys = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.SettingsKeys);
local cleanit = require(ReplicatedStorage.Packages.cleanit);
local LocalPlayer = game.Players.LocalPlayer;

if Run_Handler.LifeCleaner ~= nil then
    Run_Handler.LifeCleaner:Clean();
end;

local v2 = cleanit.new();
Run_Handler.LifeCleaner = v2;
Run_Handler.Toggled = false;
task.spawn(function() -- Line: 20
    -- upvalues: LocalPlayer (copy), Run_Handler (copy)
    local Humanoid = (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):WaitForChild("Humanoid", 10);

    if Humanoid == nil then
        return;
    end;

    Humanoid.Died:Connect(function() -- Line: 24
        -- upvalues: Run_Handler (ref)
        Run_Handler.Toggled = false;
    end);
end);
local u3 = v2:Add(DataValue.new(SettingsKeys.RunToggle.Path, SettingsKeys.RunToggle.Default, SettingsKeys.Scope));

local function toggles() -- Line: 40
    -- upvalues: u3 (copy)
    return u3:Get() == true;
end;

local u4 = v2:Add(DataValue.new(SettingsKeys.StrictShiftLock.Path, SettingsKeys.StrictShiftLock.Default, SettingsKeys.Scope));
Run_Handler.RunToggles = u4:Get() == true;
u3.Changed:Connect(function() -- Line: 64
    -- upvalues: u1 (ref), Run_Handler (copy)
    u1 = false;
    Run_Handler.Toggled = false;
end);
u4.Changed:Connect(function() -- Line: 60, Name: publishMode
    -- upvalues: Run_Handler (copy), u4 (copy)
    Run_Handler.RunToggles = u4:Get() == true;
end);
v2:Add(InputHandler.ListenTo("Run", function(p5, p6) -- Line: 75
    -- upvalues: u3 (copy), Run_Handler (copy), u1 (ref)
    if p5 ~= "Down" then
        if p5 == "Up" then
            if u3:Get() == true then
                return;
            end;

            u1 = false;
        end;

        return;
    end;

    if p6 then
        return;
    end;

    if u3:Get() == true then
        Run_Handler.Toggled = not Run_Handler.Toggled;

        return;
    end;

    u1 = true;
end));
u1 = u3:Get() ~= true and InputHandler.IsDown("Run") and true or u1;
require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Subsets"):WaitForChild("Gameplay"):WaitForChild("StatsFetch"));
local valuesfolder = require(ReplicatedStorage.CAM.Global.Utility).getvaluesfolder(LocalPlayer);

while true do
    local v7 = false;

    if valuesfolder:FindFirstChild("CombatStun") == nil and (valuesfolder:FindFirstChild("Strict_Stun") == nil and (valuesfolder:FindFirstChild("Ragdoll") == nil and (valuesfolder:FindFirstChild("RagDoll") == nil and (u1 == true or Run_Handler.Toggled == true)))) then
        v7 = Run_Handler.check_can_run() == true and true or v7;
    end;

    if Run_Handler.Is_Running ~= v7 then
        Run_Handler.Is_Running = v7;
        Run_Handler.RunningChanged:Fire(v7);
    end;

    task.wait(0.1);
end;
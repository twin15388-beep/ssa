-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local LocalPlayer = Players.LocalPlayer;
local v1 = ReplicatedStorage:WaitForChild("Funções");
local WerewolfSense = require(v1:WaitForChild("WerewolfSense"));

local function followCharacter(u2) -- Line: 9
    -- upvalues: LocalPlayer (copy), Workspace (copy)
    local Humanoid = u2:WaitForChild("Humanoid", 10);

    if not Humanoid then
        return;
    end;

    task.defer(function() -- Line: 15
        -- upvalues: LocalPlayer (ref), u2 (copy), Workspace (ref), Humanoid (copy)
        local v3 = LocalPlayer.Character == u2 and Workspace.CurrentCamera;

        if v3 then
            v3.CameraType = Enum.CameraType.Custom;
            v3.CameraSubject = Humanoid;
        end;
    end);
end;

LocalPlayer.CharacterAdded:Connect(followCharacter);

if LocalPlayer.Character then
    task.spawn(followCharacter, LocalPlayer.Character);
end;

WerewolfSense.Start();
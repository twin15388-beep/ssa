-- Decompiled with Potassium's decompiler.

local SoundService = game:GetService("SoundService");
local RunService = game:GetService("RunService");
script:WaitForChild("FootstepSounds").Parent = SoundService;
local FootstepSounds = SoundService:WaitForChild("FootstepSounds");
local LocalPlayer = game.Players.LocalPlayer;

repeat
    task.wait();
until LocalPlayer.Character;

local Character = LocalPlayer.Character;
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart");
local Humanoid = Character:WaitForChild("Humanoid");
local u1 = nil;
Humanoid.Running:connect(function(p2) -- Line: 12
    -- upvalues: Humanoid (copy), u1 (ref)
    if Humanoid.WalkSpeed / 2 < p2 then
        u1 = true;

        return;
    end;

    u1 = false;
end);

function getMaterial()
    -- upvalues: Humanoid (copy)
    return string.split(tostring(Humanoid.FloorMaterial or "Air"), "Enum.Material.")[2];
end;

local u3 = nil;
RunService.Heartbeat:connect(function() -- Line: 29
    -- upvalues: u1 (ref), HumanoidRootPart (copy), u3 (ref), FootstepSounds (copy), Humanoid (copy)
    if not u1 or HumanoidRootPart.Anchored then
        for _, child in pairs(FootstepSounds:GetChildren()) do
            child.Playing = false;
        end;

        return;
    end;

    local v4 = getMaterial();

    if v4 ~= u3 and u3 ~= nil then
        FootstepSounds[u3].Playing = false;
    end;

    local v5 = FootstepSounds[v4];
    v5.PlaybackSpeed = Humanoid.WalkSpeed / 12;
    v5.Playing = true;
    u3 = v4;
end);
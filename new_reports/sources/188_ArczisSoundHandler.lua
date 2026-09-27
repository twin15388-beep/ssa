-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Debris = game:GetService("Debris");
local ArczisCombat = ReplicatedStorage:WaitForChild("ArczisCombat");
local SoundEvent = ArczisCombat:WaitForChild("Remotes"):WaitForChild("SoundEvent");
local CombatConfig = require(ArczisCombat:WaitForChild("CombatConfig"));
SoundEvent.OnClientEvent:Connect(function(p1, p2, p3) -- Line: 8
    -- upvalues: CombatConfig (copy), Debris (copy)
    if typeof(p1) ~= "Vector3" or (type(p2) ~= "string" or p2 == "") then
        return;
    end;

    local Part = Instance.new("Part");
    Part.Name = "ArczisCombatSound";
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.Transparency = 1;
    Part.Size = Vector3.new(0.1, 0.1, 0.1);
    Part.Position = p1;
    Part.Parent = workspace;
    local Sound = Instance.new("Sound");
    Sound.SoundId = p2;
    Sound.Volume = tonumber(p3) or (CombatConfig.SoundVolume or 1);
    Sound.RollOffMinDistance = 5;
    Sound.RollOffMaxDistance = CombatConfig.SoundRange or 50;
    Sound.RollOffMode = Enum.RollOffMode.Linear;
    Sound.Parent = Part;
    Sound:Play();
    Sound.Ended:Connect(function() -- Line: 29
        -- upvalues: Part (copy)
        if Part.Parent then
            Part:Destroy();
        end;
    end);
    Debris:AddItem(Part, 6);
end);
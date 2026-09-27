-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local u1 = setmetatable({}, {
    __mode = "k"
});

local function silenceDefaultDeathSound(p2) -- Line: 5
    if p2:IsA("Sound") and p2.Name == "Died" then
        p2.SoundId = "";
        p2.Volume = 0;
    end;
end;

local function watchCharacter(p3) -- Line: 12
    -- upvalues: u1 (copy), silenceDefaultDeathSound (copy)
    if u1[p3] then
        return;
    end;

    u1[p3] = true;

    for _, descendant in p3:GetDescendants() do
        if descendant:IsA("Sound") and descendant.Name == "Died" then
            descendant.SoundId = "";
            descendant.Volume = 0;
        end;
    end;

    p3.DescendantAdded:Connect(function(p4) -- Line: 22
        -- upvalues: silenceDefaultDeathSound (ref)
        if p4:IsA("Sound") and p4.Name == "Died" then
            task.defer(silenceDefaultDeathSound, p4);
        end;
    end);
end;

Players.PlayerAdded:Connect(function(p5) -- Line: 29, Name: watchPlayer
    -- upvalues: watchCharacter (copy)
    p5.CharacterAdded:Connect(watchCharacter);

    if p5.Character then
        task.spawn(watchCharacter, p5.Character);
    end;
end);

for _, v in Players:GetPlayers() do
    v.CharacterAdded:Connect(watchCharacter);

    if v.Character then
        task.spawn(watchCharacter, v.Character);
    end;
end;
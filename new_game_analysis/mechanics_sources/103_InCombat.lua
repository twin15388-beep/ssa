-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local InCombat = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.InCombat);

return function(p1: boolean, p2: table) -- Line: 8
    -- upvalues: Players (copy), InCombat (copy)
    local LocalPlayer = Players.LocalPlayer;

    if LocalPlayer == nil then
        return;
    end;

    if InCombat.RegularIncludeAI(LocalPlayer) == true == p1 then
        return;
    end;

    table.insert(p2, {
        Image = "rbxassetid://92644032824443",
        Text = p1 and "Must be in combat" or "Must not be in combat"
    });
end;
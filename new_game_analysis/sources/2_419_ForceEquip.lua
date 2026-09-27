-- Decompiled with Potassium's decompiler.

local LocalPlayer = game:GetService("Players").LocalPlayer;

return function(p1: number?) -- Line: 7
    -- upvalues: LocalPlayer (copy)
    if p1 == nil then
        return;
    end;

    local Items_Config = LocalPlayer:FindFirstChild("Items_Config");

    if Items_Config == nil then
        return;
    end;

    local Equipped = Items_Config:FindFirstChild("Equipped");

    if Equipped == nil then
        return;
    end;

    if Equipped.Value ~= p1 then
        Equipped.Value = p1;
    end;
end;
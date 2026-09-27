-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");

return function(p1) -- Line: 5
    -- upvalues: ReplicatedStorage (copy)
    if type(p1) ~= "table" then
        return;
    end;

    local v2 = ReplicatedStorage:FindFirstChild("Minigames Place");
    local v3;

    if v2 == nil then
        v3 = nil;
    else
        v3 = v2:FindFirstChild("Minigames") or nil;
    end;

    local v4;

    if v3 == nil then
        v4 = nil;
    else
        v4 = v3:FindFirstChild("Ouwigahara") or nil;
    end;

    if v4 == nil then
        return;
    end;

    require(v4.Score).BoardReceived:Fire(p1);
end;
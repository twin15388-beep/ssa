-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local faye = require(ReplicatedStorage.Packages.faye);

return function(p1: any, p2: table?) -- Line: 25
    -- upvalues: faye (copy)
    local v3 = p2 or {};
    local _ = v3.Stop;
    local u4 = v3.Thread and v3.Thread:Extend() or faye.new();

    return function() -- Line: 34
        -- upvalues: u4 (copy)
        u4:Destroy();
    end;
end;
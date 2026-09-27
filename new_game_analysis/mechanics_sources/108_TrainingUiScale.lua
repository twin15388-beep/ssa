-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Platform_Handler = require(ReplicatedStorage.CAM.Client.Controllers.Platform_Handler);
local u1 = {
    Factor = function() -- Line: 24, Name: Factor
        -- upvalues: Platform_Handler (copy)
        return Platform_Handler.Platform.Value == "Mobile" and 1.2 or 1;
    end
};

function u1.Size(p2) -- Line: 28
    -- upvalues: u1 (copy)
    local v3 = u1.Factor();

    if v3 == 1 then
        return p2;
    end;

    return UDim2.new(p2.X.Scale * v3, p2.X.Offset * v3, p2.Y.Scale * v3, p2.Y.Offset * v3);
end;

function u1.Of(p4: number) -- Line: 37
    -- upvalues: u1 (copy)
    return p4 * u1.Factor();
end;

return u1;
-- Decompiled with Potassium's decompiler.

local WeaponAuras = require(script.Parent:WaitForChild("WeaponAuras"));
local u1 = {
    anchorParts = {
        Blade = true,
        Blade2 = true
    }
};

return function(p2, p3, p4) -- Line: 12
    -- upvalues: WeaponAuras (copy), u1 (copy)
    WeaponAuras(p2, p3, p4, u1);
end;
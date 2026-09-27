-- Decompiled with Potassium's decompiler.

local WeaponAuras = require(script.Parent:WaitForChild("WeaponAuras"));
local u1 = {
    anchorParts = {
        Spear = true,
        ["Meshes/PS2 WEAPONS_Plane.003"] = true
    }
};

return function(p2, p3, p4) -- Line: 11
    -- upvalues: WeaponAuras (copy), u1 (copy)
    WeaponAuras(p2, p3, p4, u1);
end;
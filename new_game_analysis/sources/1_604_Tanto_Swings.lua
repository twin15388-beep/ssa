-- Decompiled with Potassium's decompiler.

local WeaponAuras = require(script.Parent:WaitForChild("WeaponAuras"));
local Combat_Swings = require(script.Parent:WaitForChild("Combat_Swings"));
local u1 = {
    anchorParts = {
        Blade = true
    }
};

return function(p2, p3, p4) -- Line: 14
    -- upvalues: Combat_Swings (copy), WeaponAuras (copy), u1 (copy)
    if p3 == 5 then
        Combat_Swings(p2, p3, p4);

        return;
    end;

    WeaponAuras(p2, p3, p4, u1);
end;
-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Combat_presets = require(ReplicatedStorage.CAM.Global.Combat_presets);

return {
    GetCombatCooldown = function() -- Line: 7, Name: GetCombatCooldown
        -- upvalues: Combat_presets (copy)
        local v1 = os.clock() - Combat_presets.Last_Punched;
        local default = Combat_presets.Presets.Normal.default;

        if not (Combat_presets.Last_Combo ~= 5 and Combat_presets.Last_Combo ~= 7 or Combat_presets.Last_Combo == 5 and Combat_presets.Is_Air_Combo == true) then
            default = Combat_presets.Presets.Normal.final;
        end;

        return v1, default;
    end
};
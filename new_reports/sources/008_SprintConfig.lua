-- Decompiled with Potassium's decompiler.

local u1 = {
    Humans = {
        WalkSpeed = 16,
        SprintSpeed = 24,
        JumpHeight = 7.2,
        JumpStaminaCost = 8,
        MaxStamina = 100,
        DrainPerSecond = 24,
        RegenPerSecond = 18,
        RegenDelay = 1.25
    },
    VampireHunter = {
        WalkSpeed = 16,
        SprintSpeed = 24,
        JumpHeight = 7.2,
        JumpStaminaCost = 8,
        MaxStamina = 100,
        DrainPerSecond = 24,
        RegenPerSecond = 18,
        RegenDelay = 1.25
    },
    Vampires = {
        WalkSpeed = 18,
        SprintSpeed = 50,
        JumpHeight = 11.5,
        JumpStaminaCost = 12,
        MaxStamina = 200,
        DrainPerSecond = 20,
        RegenPerSecond = 25,
        RegenDelay = 1
    },
    Werewolfs = {
        WalkSpeed = 18,
        SprintSpeed = 65,
        JumpHeight = 11.5,
        JumpStaminaCost = 12,
        MaxStamina = 200,
        DrainPerSecond = 20,
        RegenPerSecond = 25,
        RegenDelay = 1
    },
    Witches = {
        WalkSpeed = 21,
        SprintSpeed = 38,
        JumpHeight = 8.5,
        JumpStaminaCost = 7,
        MaxStamina = 350,
        DrainPerSecond = 16,
        RegenPerSecond = 30,
        RegenDelay = 0.65
    },
    TransformedVampires = {
        WalkSpeed = 18,
        SprintSpeed = 50,
        JumpHeight = 11.5,
        JumpStaminaCost = 12,
        MaxStamina = 200,
        DrainPerSecond = 20,
        RegenPerSecond = 25,
        RegenDelay = 1
    },
    RingBuffs = {
        SprintSpeedBonus = 15
    },
    VampireProgression = {
        MaximumYear = 50,
        WalkSpeedPerYear = 0.25,
        SprintSpeedPerYear = 0.6,
        StaminaPerYear = 15,
        MaxWalkSpeed = 30.5,
        MaxSprintSpeed = 80,
        MaxStamina = 950,
        JumpHeightPerYear = 0.08,
        MaxJumpHeight = 15.5
    }
};

function u1.GetForTeam(p2) -- Line: 89
    -- upvalues: u1 (copy)
    return u1[p2 == "Cannibal Raised" and "Vampires" or p2] or u1.Humans;
end;

local u3 = {};

local function applyQuestSpeedRestriction(p4, p5, p6) -- Line: 96
    if not p6 or p6:GetAttribute("QuestDeliverySpeedRestricted") ~= true then
        return p4;
    end;

    local v7 = {};

    for i, v in pairs(p4) do
        v7[i] = v;
    end;

    v7.WalkSpeed = 16;
    v7.SprintSpeed = 26;

    return v7;
end;

local function applyStrengthSpeed(p8, p9) -- Line: 111
    local v10 = p9 and tonumber(p9:GetAttribute("StrengthSpeedMultiplier")) or 1;
    local math_clamp_ret = math.clamp(v10 or 1, 1, 1.2);

    if math_clamp_ret <= 1 then
        return p8;
    end;

    local v11 = {};

    for i, v in pairs(p8) do
        v11[i] = v;
    end;

    v11.WalkSpeed = (tonumber(p8.WalkSpeed) or 0) * math_clamp_ret;
    v11.SprintSpeed = (tonumber(p8.SprintSpeed) or 0) * math_clamp_ret;

    return v11;
end;

local function applyWitchInvisibleSpeed(p12, p13, p14) -- Line: 126
    if p13 ~= "Witches" or (not p14 or p14:GetAttribute("WitchInvisibleActive") ~= true) then
        return p12;
    end;

    local v15 = tonumber(p14:GetAttribute("WitchInvisibleSpeedMultiplier")) or 2;
    local math_clamp_ret = math.clamp(v15, 1, 2);
    local table_clone_ret = table.clone(p12);
    table_clone_ret.WalkSpeed = (tonumber(p12.WalkSpeed) or 0) * math_clamp_ret;
    table_clone_ret.SprintSpeed = (tonumber(p12.SprintSpeed) or 0) * math_clamp_ret;

    return table_clone_ret;
end;

local function applyCannibalAgility(p16, p17, p18) -- Line: 137
    if not ((p17 == "Vampires" or p17 == "Cannibal Raised") and (p18 and p18:GetAttribute("CannibalVampire") == true)) then
        return p16;
    end;

    local v19 = {};

    for i, v in pairs(p16) do
        v19[i] = v;
    end;

    v19.WalkSpeed = (tonumber(p16.WalkSpeed) or 0) * 1.1;
    v19.SprintSpeed = (tonumber(p16.SprintSpeed) or 0) * 1.1;

    return v19;
end;

local u20 = require(script.Parent.Parent:WaitForChild("UpgradesModule"))[3];

local function applyVampireSkillSpeed(p21, p22, p23) -- Line: 151
    -- upvalues: u20 (copy)
    if not (p23 and (p22 == "Vampires" or p22 == "Cannibal Raised")) or p23:GetAttribute("QuestDeliverySpeedRestricted") == true then
        return p21;
    end;

    local v24 = tonumber(p23:GetAttribute("VampireSpeedUpgradeLevel")) or 0;
    local math_floor_ret = math.floor(v24);
    local math_clamp_ret = math.clamp(math_floor_ret, 0, u20.maxUpgradeLevel);

    if math_clamp_ret == 0 then
        return p21;
    end;

    local table_clone_ret = table.clone(p21);
    table_clone_ret.WalkSpeed = (p21.WalkSpeed or 0) + math_clamp_ret * u20.speedBonusPerUpgrade;
    table_clone_ret.SprintSpeed = (p21.SprintSpeed or 0) + math_clamp_ret * u20.sprintBonusPerUpgrade;

    return table_clone_ret;
end;

function u1.GetForPlayer(p25, p26, p27, p28) -- Line: 162
    -- upvalues: u1 (copy), applyStrengthSpeed (copy), applyQuestSpeedRestriction (copy), applyWitchInvisibleSpeed (copy), u3 (copy), applyCannibalAgility (copy), applyVampireSkillSpeed (copy)
    local v29 = p25 == "VampireHunter";

    if p25 ~= "Vampires" and (p25 ~= "Cannibal Raised" and not v29) then
        local ForTeam = u1.GetForTeam(p25);

        if p25 ~= "Humans" or not (p28 and (p28.Character and p28.Character:GetAttribute("VampireInfected") == true)) then
            return applyWitchInvisibleSpeed(applyStrengthSpeed(applyQuestSpeedRestriction(ForTeam, p25, p28), p28), p25, p28), 0;
        end;

        local v30 = {};

        for i, v in pairs(ForTeam) do
            v30[i] = v;
        end;

        v30.WalkSpeed = ForTeam.WalkSpeed + 4;
        v30.SprintSpeed = ForTeam.SprintSpeed + 6;

        return applyStrengthSpeed(applyQuestSpeedRestriction(v30, p25, p28), p28), 0;
    end;

    local v31 = not v29 and p26 == "Transformed";
    local v32 = v29 and u1.VampireHunter or (v31 and u1.TransformedVampires or u1.Vampires);
    local VampireProgression = u1.VampireProgression;
    local v33 = tonumber(p27) or 0;
    local math_floor_ret = math.floor(v33);
    local math_max_ret = math.max(0, math_floor_ret);
    local math_min_ret = math.min(math_max_ret, VampireProgression.MaximumYear);
    local v34 = (v29 and "Hunter_" or (v31 and "Transformed_" or "Born_")) .. tostring(math_min_ret);
    local v35 = u3[v34];

    if not v35 then
        v35 = {
            WalkSpeed = math.min(VampireProgression.MaxWalkSpeed, v32.WalkSpeed + VampireProgression.WalkSpeedPerYear * math_min_ret),
            SprintSpeed = math.min(VampireProgression.MaxSprintSpeed, v32.SprintSpeed + VampireProgression.SprintSpeedPerYear * math_min_ret),
            JumpHeight = math.min(VampireProgression.MaxJumpHeight, v32.JumpHeight + VampireProgression.JumpHeightPerYear * math_min_ret),
            JumpStaminaCost = v32.JumpStaminaCost,
            MaxStamina = math.min(VampireProgression.MaxStamina, v32.MaxStamina + VampireProgression.StaminaPerYear * math_min_ret),
            DrainPerSecond = v32.DrainPerSecond,
            RegenPerSecond = v32.RegenPerSecond,
            RegenDelay = v32.RegenDelay
        };
        u3[v34] = v35;
    end;

    if p28 and p28.Character then
        local EquippedRing = p28.Character:FindFirstChild("EquippedRing");

        if EquippedRing and EquippedRing:IsA("BasePart") then
            local v36 = {};

            for i, v in pairs(v35) do
                v36[i] = v;
            end;

            local SprintSpeed = v35.SprintSpeed;
            local v37 = tonumber(u1.RingBuffs.SprintSpeedBonus) or 0;
            v36.SprintSpeed = SprintSpeed + math.max(0, v37);

            return applyVampireSkillSpeed(applyCannibalAgility(applyStrengthSpeed(applyQuestSpeedRestriction(v36, p25, p28), p28), p25, p28), p25, p28), math_min_ret;
        end;
    end;

    return applyVampireSkillSpeed(applyCannibalAgility(applyStrengthSpeed(applyQuestSpeedRestriction(v35, p25, p28), p28), p25, p28), p25, p28), math_min_ret;
end;

return u1;
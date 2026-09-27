-- Decompiled with Potassium's decompiler.

return {
    {
        name = "Sleep",
        level = 100,
        maxUpgradeLevel = 10,
        upgradeCost = 10,
        xpBonusPerUpgrade = 0.25,
        description = "Sleep upside down under a ceiling. Each upgrade adds 25% XP earned from Sleep, up to +250%. XP is awarded every 30 seconds while sleeping."
    },
    {
        name = "Vampire Bloodline",
        level = 800,
        description = "Unlock your own vampire bloodline. Vampires you transform can become your descendants until they reach level 300."
    },
    {
        name = "Vampire Speed",
        level = 30,
        maxUpgradeLevel = 30,
        upgradeCost = 5,
        speedBonusPerUpgrade = 0.3,
        sprintBonusPerUpgrade = 0.6,
        description = "Increases vampire walking speed by 0.30 and sprint speed by 0.60 per upgrade. Maximum: +9 walk, +18 sprint."
    },
    {
        name = "Vampire Regen",
        level = 170,
        maxUpgradeLevel = 30,
        upgradeCost = 15,
        regenBonusPerUpgrade = 0.025,
        description = "Increases vampire health regeneration by 2.5% per upgrade, up to +75%. Does not bypass regeneration blocks."
    },
    {
        name = "Vampiric Reflexes",
        level = 400,
        maxUpgradeLevel = 30,
        upgradeCost = 15,
        activationChancePerUpgrade = 0.035,
        healthThreshold = 0.25,
        dodgeInvulnerability = 0.45,
        dodgeCooldown = 1.5,
        description = "When an attack leaves you at 25% health or less, you may evade it completely. Each upgrade adds 3.5% activation chance, reaching 100% at the highest levels."
    }
};
-- Decompiled with Potassium's decompiler.

return {
    HeartRipping = {
        UnlockYears = 100,
        ManaCost = 100,
        SelectionTime = 10,
        MaximumDistance = 15,
        Cooldown = 90,
        TrembleDuration = 2.5,
        FloatDuration = 1,
        SoundId = "rbxassetid://81982330626573"
    },
    Strength = {
        Incantation = "Strength!",
        UnlockYears = 25,
        ManaCost = 30,
        SelectionTime = 10,
        MaximumDistance = 60,
        Duration = 45,
        Cooldown = 30,
        SpeedMultiplier = 1.2,
        PunchDamageMultiplier = 1.35
    },
    Incendia = {
        AnimationId = "rbxassetid://135637925657898",
        MaximumDistance = 80,
        Cooldown = 10,
        BurnDuration = 6,
        DamagePerTick = 16,
        VampireMaxHealthPercentPerTick = 0.14,
        DamageTickRate = 0.75,
        GroundEffectDuration = 4,
        AimTimeout = 12,
        ManaCost = 10,
        OutleveledMinimumHealthPercent = 0.3
    },
    LifeDrain = {
        MaximumDistance = 14,
        ChannelSeconds = 3,
        TickSeconds = 0.5,
        Cooldown = 38,
        FloatHeight = 2.6,
        ManaRestoredPerDamage = 0.75,
        FarmXpPerTick = 2,
        DamagePerTick = 30,
        VampireMaxHealthPercentPerTick = 0.18,
        OutleveledMinimumHealthPercent = 0.3,
        VampireLevelAdvantage = 60,
        AnimationId = "rbxassetid://126756808991040"
    },
    Invisible = {
        UnlockYears = 25,
        Cooldown = 25,
        Duration = 10,
        SpeedMultiplier = 2,
        KeyboardKey = "C",
        GamepadKey = "ButtonX"
    },
    BreakNeck = {
        UnlockYears = 25,
        ManaCost = 80,
        Cooldown = 15,
        MaximumDistance = 40,
        FloatHeight = 4,
        AttackTimeout = 9,
        AttackerAnimationId = "rbxassetid://133339626945358",
        TargetAnimationId = "rbxassetid://81756797328269",
        LiftSoundId = "rbxassetid://85064677546638",
        BreakSoundId = "rbxassetid://135076986499326",
        LiftMarker = "LEVANTA",
        BreakMarker = "BREAK",
        VampireHealthAtUnlock = 0.5,
        VampireHealthAtMaxLevel = 0.15,
        OutleveledExecutionHealthAtSmallGap = 0.35,
        OutleveledExecutionHealthAtMaximumGap = 0.15,
        OutleveledDamageAtSmallGap = 0.45,
        OutleveledDamageAtMaximumGap = 0.25,
        MaximumProtectedLevelGap = 100
    },
    Petrification = {
        UnlockYears = 15,
        ManaCost = 45,
        SelectionTime = 10,
        MaximumDistance = 60,
        Duration = 15,
        Cooldown = 25,
        SoundId = "rbxassetid://81982330626573"
    },
    PainInfliction = {
        UnlockYears = 140,
        MaximumDistance = 40,
        Cooldown = 35,
        MaximumChannelSeconds = 8,
        TickSeconds = 0.2,
        ManaPerSecond = 24,
        SelfDamageAfterHalfPercentPerSecond = 0.08,
        DamagePerTickAtUnlock = 8,
        DamagePerTickAtLevel300 = 20,
        PlayerMaxHealthPercentPerTickAtUnlock = 0.012,
        PlayerMaxHealthPercentPerTickAtLevel300 = 0.028,
        AttackerAnimationId = "rbxassetid://99031074257990",
        TargetAnimationId = "rbxassetid://137357649326820",
        StartSoundId = "rbxassetid://85064677546638",
        PainSoundId = "rbxassetid://79036937914183",
        PainMarker = "DOR"
    }
};
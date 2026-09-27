-- Decompiled with Potassium's decompiler.

local u1 = {
    M1StaminaCost = 12,
    HeavyStaminaCost = 35,
    MinStaminaToAct = 15,
    BlockStaminaDrainPerHit = 25,
    BlockStaminaDrainPerHeavy = 40,
    M1Damage = 8,
    HeavyDamage = 20,
    BlockedDamageReduction = 0.8,
    ClashWinDamage = 12,
    M1Cooldown = 0.18,
    M1AnimationLock = 0.58,
    HeavyCooldown = 1.2,
    HeavyAnimationLock = 0.72,
    M1StunDuration = 0.4,
    HeavyStunDuration = 1.2,
    GuardBreakStunDuration = 1.5,
    BlockStunDuration = 0.2,
    HitboxSize = Vector3.new(7, 7, 7),
    HitboxOffset = 3.5,
    M1HitboxDelay = 0.24,
    HeavyHitboxDelay = 0.42,
    M1Knockback = 15,
    HeavyKnockback = 40,
    GuardBreakKnockback = 25,
    SuperPunchMinimumYears = 200,
    SuperPunchChance = 0.15,
    SuperPunchDamageMultiplier = 2.5,
    SuperPunchKnockback = 85,
    SuperPunchVerticalKnockback = 30,
    SuperPunchRagdollDuration = 2.5,
    BlockWalkSpeedMultiplier = 0.3,
    HitStunWalkSpeedMultiplier = 0.3,
    AttackingWalkSpeedMultiplier = 0.3,
    ClashDetectionWindow = 0.35,
    ClashButtonPressWindow = 3,
    ClashBarMaxLead = 18,
    ClashLevelPerPressBonus = 250,
    ClashPressWeightCap = 4,
    ClashStartingAdvantagePerLevel = 0.01,
    ClashStartingAdvantageCap = 8
};

function u1.GetClashPressWeight(p2) -- Line: 54
    -- upvalues: u1 (copy)
    local v3 = tonumber(p2) or 0;
    local v4 = 1 + math.max(0, v3) / u1.ClashLevelPerPressBonus;

    return math.clamp(v4, 1, u1.ClashPressWeightCap);
end;

function u1.GetClashStartingAdvantage(p5, p6) -- Line: 63
    -- upvalues: u1 (copy)
    local v7 = tonumber(p5) or 0;
    local math_max_ret = math.max(0, v7);
    local v8 = tonumber(p6) or 0;
    local v9 = (math_max_ret - math.max(0, v8)) * u1.ClashStartingAdvantagePerLevel;

    return math.clamp(v9, -u1.ClashStartingAdvantageCap, u1.ClashStartingAdvantageCap);
end;

u1.ClashWinPunchDelay = 0.83;
u1.ClashWinStunDuration = 1.2;
u1.ClashWinKnockback = 20;
u1.ClashWinVerticalKnockback = 60;
u1.ClashWinRagdollMinDuration = 2.2;
u1.ClashWinRagdollMaxDuration = 5;
u1.ClashWinnerSlideBack = 25;
u1.ClashDistance = 3.5;
u1.Animations = {
    M1_Punch1 = "rbxassetid://83190916082782",
    M1_Punch2 = "rbxassetid://112732666359125",
    M1_Punch2Alt = "rbxassetid://90409578546522",
    CombatWalk = "rbxassetid://124280205583832",
    CombatRun = "rbxassetid://107219456846566",
    ClashLoop = "rbxassetid://72085985794612",
    BlockHit = "rbxassetid://137004675247935",
    ClashWin = "rbxassetid://91100592371180",
    Equip = "rbxassetid://124529291037045",
    HitReactionM1_1 = "rbxassetid://122252089243597",
    HitReactionM1_2 = "rbxassetid://87327894526152",
    Block = "rbxassetid://125620388545857",
    HeavyPunch = "rbxassetid://108665020824395",
    GuardBreak = "rbxassetid://96946000466985"
};
u1.Sounds = {
    Equip = "rbxassetid://4549835866",
    SwingHeavy = "rbxassetid://74238153433253",
    HitHeavy = "rbxassetid://9117969687",
    BlockHit = "rbxassetid://72616318807516",
    GuardBreak = "rbxassetid://4086172420",
    ClashStart = "rbxassetid://8595974357",
    Swing = { "rbxassetid://101467914599270", "rbxassetid://74238153433253" },
    Hit = { "rbxassetid://8595980577", "rbxassetid://9117969687" }
};
u1.SoundVolume = 1;
u1.SoundRange = 50;

return u1;
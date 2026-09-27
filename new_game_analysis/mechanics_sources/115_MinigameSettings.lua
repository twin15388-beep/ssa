-- Decompiled with Potassium's decompiler.

local u1 = {
    FinalSelection = {
        NoQuestCategoryLimit = true,
        NoCrowBoard = true
    },
    Ouwigahara = {
        Modes = {
            Normal = {
                Title = "Normal",
                Lives = 3
            },
            Roguelike = {
                Title = "Roguelike",
                FreshStart = true,
                Lives = 3
            }
        },
        Ranked = {
            Lives = 1,
            Solo = true,
            VerifiedLevel = Enum.VerifiedLevel.High
        },
        NoReputationLeaderstat = true,
        NoSunDamage = true,
        NoPlayerVersusPlayer = true,
        NoPartyHud = true,
        NoSoulDrop = true,
        SeasonOrigin = {
            Year = 2026,
            Month = 9
        },
        HistogramBucket = 250,
        HistogramBuckets = 40,
        ReadyHold = 0.5,
        ReadyWindow = 20,
        RewardHandSize = 3,
        RewardPickWindow = 30,
        RewardPickedLinger = 1,
        WaveBreak = 10,
        FloorsPerMap = 10,
        MilestonePicks = 3,
        RoguelikeStatPicks = 1,
        SoloEventPicks = 1,
        SoloPointsScale = 0.6,
        StartWeapon = "Fancy Katana",
        StartPotion = "Health Potion",
        StartPotions = 3,
        RunMastery = 150,
        RunLevel = 150,
        RewardRarityBiasPerFloor = 0.012,
        RunRerolls = 2,
        FreshStartOpeningType = "Skill",
        PivotSkillOdds = 2,
        ClanSkillOdds = 4,
        RarityFirstFloor = {
            [4] = 8,
            [5] = 14,
            [6] = 22,
            [7] = 30
        },
        RunStatCaps = {
            ["Damage Reduction Factor"] = 0.35,
            ["Cooldown Reduction Factor"] = 0.5,
            ["Additional Damage Factor"] = 2,
            ["Max Stamina"] = 400
        },
        RewardPity = {
            [5] = {
                After = 3,
                Per = 0.6,
                Max = 4
            },
            [6] = {
                After = 5,
                Per = 0.8,
                Max = 5
            },
            [7] = {
                After = 8,
                Per = 1.2,
                Max = 6
            }
        },
        KillPoints = {
            Normal = 15,
            Elite = 75,
            Boss = 375
        },
        Enemies = {
            Elite = { "Rengu", "Zentaro", "Giyen", "Saneri", "Gyorei", "Obari", "Shinora", "Tengai", "Reaper", "Nezura", "Sumari", "Akazo", "Gyutai", "Enru", "Datai", "Domae", "Yahari" },
            Boss = { "HandDemon", "YetiDemon" },
            Exclude = { "Horse", "Civilian" },
            RigAlias = {
                KanoeDemonSlayer = "Mizunoto",
                MizunoeDemonSlayer = "Mizunoto",
                Mizunoto_MistfallHarbor = "Mizunoto"
            }
        },
        Waves = {
            NormalBase = 4,
            NormalPerFloor = 0.15,
            BandTop = 0.05,
            BandPerFloor = 0.04,
            BandTrail = 0.35,
            EliteFirstFloor = 5,
            EliteAppearsEveryFloors = 1,
            EliteOneMoreEveryFloors = 18,
            BossFirstFloor = 10,
            BossAppearsEveryFloors = 5,
            BossOneMoreEveryFloors = 30,
            PerExtraPlayer = 0.35,
            MaxConcurrent = 14,
            AggroBase = 3,
            AggroPerFloor = 0.2,
            AggroMax = 4,
            AttackersBase = 0.6,
            AttackersPerFloor = 0.045,
            AttackersMax = 4,
            CaptureDistance = 350,
            LetGoDistance = 700,
            NormalHealthBase = 60,
            NormalDamageBase = 4.55,
            EliteHealthMult = 3,
            EliteDamageMult = 1.8,
            BossHealthMult = 6,
            BossDamageMult = 2.4,
            SkillFloor = 6,
            SkillsPerFloor = 0.15,
            SkillsMax = 4,
            BossSkillFloor = 15,
            BossSkillsPerFloor = 0.08,
            BossSkillsMax = 3,
            DeepFloor = 50,
            DeepRateDoubleFloors = 15,
            DeepDamagePerFloor = 0.065,
            DeepHealthPerFloor = 0.035,
            HealthPerFloor = 0.04,
            DamagePerFloor = 0.025,
            HealthScalePerPlayer = 0.35,
            DamageScalePerPlayer = 0.04
        },
        FloorScoreBonus = 0.15,
        FloorScoreBonusCap = 3,
        RewardRarities = {
            Heal = 1,
            Points = 2,
            Skill = 3,
            Event = 3,
            SwapMap = 3,
            Stat = 4,
            Clan = 4,
            Weapon = 4,
            Potion = 5,
            Reroll = 5,
            ExtraLife = 6,
            Revive = 7,
            Fortune = 6,
            Trade = 4,
            SkillSwap = 4,
            AscendClan = 5,
            Forge = 5
        }
    },
    PvP = {
        ForcePartyProtection = true,
        NoReputationLeaderstat = true,
        NoMultiplierClock = true,
        TrackMatchRecord = true,
        TrackStreak = true,
        MaxHearts = 3,
        NoDrowning = true,
        LoadoutLockedWhileFielded = true,
        JoinWindow = 15,
        VoteWindow = 20,
        ReturnCountdown = 15,
        NoDeathPassives = {
            ["Venomous Precision"] = true,
            ["Toxic Essence"] = true
        },
        LockedItemCategories = {
            Mounts = true,
            Potions = true
        },
        Ranked = {
            PlacementCount = 5,
            PlacementCapTier = 4,
            PlacementConfidence = 0.5,
            WinPoints = 20,
            LossPoints = 15,
            GapBonus = 0.5,
            GapScale = 300,
            OddsBonus = 1,
            DodgePoints = 30,
            DodgeWindow = 86400,
            DisplayBase = 1500,
            DisplayScale = 60,
            SeedSigma = 6,
            SeasonSigma = 6,
            FloorTierMax = 5,
            RepeatLimit = 3,
            RepeatWindow = 86400,
            HistogramBucket = 200,
            HistogramBuckets = 40,
            MarginBase = 100,
            MarginStep = 100,
            MarginStepTime = 15,
            MarginCap = 1200,
            VerifiedLevel = Enum.VerifiedLevel.High,
            DodgeLocks = { 60, 300, 900 },
            Tiers = { {
                    Name = "Bronze",
                    Threshold = 0,
                    Anchor = 1250
                }, {
                    Name = "Silver",
                    Threshold = 100,
                    Anchor = 1400
                }, {
                    Name = "Gold",
                    Threshold = 250,
                    Anchor = 1500
                }, {
                    Name = "Diamond",
                    Threshold = 450,
                    Anchor = 1600
                }, {
                    Name = "Master",
                    Threshold = 700,
                    Anchor = 1750
                }, {
                    Name = "Grandmaster",
                    Threshold = 1000,
                    Anchor = 1900
                }, {
                    Name = "Challenger",
                    Threshold = 1400,
                    Anchor = 2100
                } },
            Rewards = {
                Modes = { {
                        Band = "Top",
                        Percent = 5
                    } },
                TourneySlayer = { {
                        Band = "Hashira",
                        Percent = 1
                    } },
                TourneyDemon = { {
                        Band = "UpperMoon",
                        Percent = 1
                    }, {
                        Band = "LowerMoon",
                        Percent = 3
                    } }
            }
        }
    }
};
local u2 = {
    Settings = u1,

    Active = function() -- Line: 446, Name: Active
        -- upvalues: u1 (copy)
        local Attribute = workspace:GetAttribute("MinigameKey");

        if Attribute == nil then
            return nil;
        end;

        return u1[Attribute];
    end
};

function u2.Get(p3: string) -- Line: 452
    -- upvalues: u2 (copy)
    local v4 = u2.Active();

    if v4 == nil then
        return nil;
    end;

    return v4[p3];
end;

return u2;
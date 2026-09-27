-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage.CAM.Global.Types.ItemTypes);

return {
    Icon = "rbxassetid://82912004827960",
    Description = "Violet plates wrap the fists, turning flash step work into shattering footing and heavy throws.",
    Rarity = 6,
    NoSell = true,
    DemonArt = "All,exceptBlood Manipulation",
    HasCombat = true,
    CombatPreset = "Gauntlet",
    Mastery = "Gauntlet",
    SkillCategory = "Gauntlet",
    EquipType = Menum.ItemEquipType.Toolbar,
    Price = {
        ["Mythic Refinement Ore"] = 4
    },
    ActiveToolStats = {
        ["Additional Damage"] = 4,
        ["Additional Damage Factor"] = 0.076,
        ["Block Points"] = 4.5,
        ["Block Regen"] = 0.7
    },
    Skills = { {
            Name = "Blocking",
            Key = "F",
            CoolDown = 1,
            icon = "http://www.roblox.com/asset/?id=12529007524"
        }, {
            Name = "Flash Fist",
            CoolDown = 12,
            icon = "rbxassetid://117576772610807",
            Max_Hold = 3,
            Stamina = 20,
            SkillStats = {
                strict_stun = true,
                additional_damage_scale = 0.5
            }
        }, {
            Name = "Shatter Step",
            CoolDown = 15,
            icon = "rbxassetid://120836341224394",
            Max_Hold = 3,
            Stamina = 24
        }, {
            Name = "Shoulder Throw",
            CoolDown = 14,
            icon = "rbxassetid://128375584273842",
            Max_Hold = 5,
            Stamina = 22
        } }
};
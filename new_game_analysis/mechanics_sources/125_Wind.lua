-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.CAM.Global.Types.MiscTypes);

return {
    Icon = "rbxassetid://108992109755110",
    Skills = { {
            Name = "Blocking",
            Key = "F",
            CoolDown = 1,
            icon = "http://www.roblox.com/asset/?id=12529007524"
        }, {
            Name = "Mountain Wind",
            Key = "Z",
            CoolDown = 13,
            Stamina = 18,
            icon = "rbxassetid://115086616432186",
            Max_Hold = 5
        }, {
            Name = "Purifying Claws",
            Key = "X",
            CoolDown = 12,
            Stamina = 18,
            icon = "rbxassetid://108896110591449",
            Max_Hold = 5
        }, {
            Name = "Rising Dust Storm",
            Key = "C",
            CoolDown = 18,
            Stamina = 28,
            icon = "rbxassetid://79645974156344",
            Max_Hold = 5,
            SkillStats = {
                additional_damage_scale = 0.3
            }
        }, {
            Name = "Whirlwind Cutter",
            Key = "V",
            CoolDown = 17,
            Stamina = 26,
            icon = "rbxassetid://136534162394232",
            Max_Hold = 1.2
        }, {
            Name = "Idaten Typhoon",
            Key = "B",
            CoolDown = 50,
            Stamina = 35,
            icon = "rbxassetid://82109759217184",
            Boss = "Saneri",
            Max_Hold = 5,
            SkillStats = {
                additional_damage_scale = 0.32
            }
        } }
};
-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage.CAM.Global.Types.ItemTypes);

return {
    Icon = "rbxassetid://17802518184",
    Description = "A coastal smith\'s katana, named for the wave its temper line traces rather than for anything it does in the hand.",
    Rarity = 2,
    HasCombat = true,
    Breathing = "All",
    Mastery = "Sword",
    EquipType = Menum.ItemEquipType.Toolbar,
    Price = {
        ["Metal Scraps"] = 6
    },
    Skills = { {
            Name = "Blocking",
            Key = "F",
            CoolDown = 1,
            icon = "http://www.roblox.com/asset/?id=12529007524"
        } },
    ActiveToolStats = {
        ["Additional Damage"] = 1
    }
};
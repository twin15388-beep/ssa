-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage.CAM.Global.Types.ItemTypes);

return {
    Icon = "rbxassetid://113589540074508",
    Description = "Thin stimulant for spent lungs and legs. Drink it to quicken stamina recovery for a brief push.",
    Rarity = 1,
    ShowRemainder = true,
    ToolScript = "Health Potion",
    NoSell = true,
    EquipType = Menum.ItemEquipType.Toolbar
};
-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage.CAM.Global.Types.ItemTypes);

return {
    Icon = "rbxassetid://99563083225291",
    Description = "Bitter medicine that hastens natural healing for a short while once swallowed.",
    Rarity = 1,
    ShowRemainder = true,
    ToolScript = "Health Potion",
    NoSell = true,
    EquipType = Menum.ItemEquipType.Toolbar
};
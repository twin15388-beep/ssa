-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage.CAM.Global.Types.ItemTypes);

return {
    Icon = "rbxassetid://138778984185245",
    Description = "A richer healing draught from Meku\'s shelf. Drinking it closes deeper wounds than the field bottle can manage.",
    Rarity = 2,
    ShowRemainder = true,
    ToolScript = "Health Potion",
    EquipType = Menum.ItemEquipType.Toolbar
};
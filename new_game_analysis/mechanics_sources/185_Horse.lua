-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
require(game.ReplicatedStorage.CAM.Global.Types.ItemTypes);

return {
    Icon = "rbxassetid://130298231932875",
    Description = "Calls a rideable horse for the open road. It changes gait while moving, jumps from solid ground, and dismounts on command.",
    Rarity = 5,
    NoToolIdle = true,
    EquipType = Menum.ItemEquipType.Toolbar,
    Price = {
        Wen = 15000
    },
    ViewmodelSettings = {
        CFrameOffset = CFrame.new(0, 3, 7.5)
    }
};
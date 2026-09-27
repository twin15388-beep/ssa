-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.CAM.Global.Types.ItemTypes);
Cooldowns = {
    Blocking = 2
};

return {
    Blocking = {
        Icon = "rbxassetid://13735172949",
        Locked = false,
        Cooldown = Cooldowns.Blocking
    },
    Dash = {
        Cooldown = 1,
        Stamina = 10
    },
    ["Double Jump"] = {
        Icon = "rbxassetid://76136876197533",
        Cooldown = 2,
        Stamina = 10,
        Category = "Innate Skills",
        Index = 1
    },
    ["Wall Climb"] = {
        Icon = "rbxassetid://76503830534647",
        Cooldown = 2,
        Category = "Innate Skills",
        Index = 2
    }
};
-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");

return require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests.DepositState).forTasks(
    "Ill restock the infirmary(Lv 70)",
    { "Health Elixirs stocked", "Health Regen Elixirs stocked", "Stamina Regen Elixirs stocked" },
    {
        ObjectText = "Infirmary Crates",
        ActionText = "Stock",
        Title = "Infirmary Restock",
        Interval = 0.15,
        BurstAt = Vector3.new(-1848.23, 315.086, -125.179),
        BillboardAt = Vector3.new(-1848.23, 319.886, -119.539),
        VfxScale = 1.5
    }
);
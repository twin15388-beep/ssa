-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");

return require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests.DepositState).forTasks(
    "Ill help you survive the winter(Lv 100)",
    { "Cooked Bear Meat stocked", "Health Elixirs stocked" },
    {
        ObjectText = "Gate Stores",
        ActionText = "Load",
        Title = "Supply the Settlement",
        Interval = 0.15,
        BurstAt = Vector3.new(-111.113, 1354.286, -2524.389),
        BillboardAt = Vector3.new(-111.113, 1363.086, -2524.389),
        VfxScale = 2
    }
);
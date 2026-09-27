-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");

return require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.Quests.DepositState).forTasks(
    "Ill stock the reserves(Lv 75)",
    { "Golden Fish crated", "Clown Fish crated", "Zebra Fish crated" },
    {
        ObjectText = "Infirmary Crates",
        ActionText = "Stock",
        Title = "The Full Pantry",
        Interval = 0.15,
        BurstAt = Vector3.new(-1848.23, 315.086, -125.179),
        BillboardAt = Vector3.new(-1848.23, 319.886, -119.539),
        VfxScale = 1.5
    }
);
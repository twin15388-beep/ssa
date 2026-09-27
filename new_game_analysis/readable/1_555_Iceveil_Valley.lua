-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
local v1 = {
    ["Iceveil Settlement"] = {
        Village = true,
        IndependentMarkers = true,
        Grid = {
            {
                Center = Vector2.new(-320.215, -2903.84),
                Radius = Vector2.new(245.825, 727.88),
                Type = Menum.AreaType.Rectangle
            },
            {
                Center = Vector2.new(68.28, -2699.06),
                Radius = Vector2.new(393.28, 247.4),
                Type = Menum.AreaType.Rectangle
            }
        },
        CrystalAt = CFrame.new(-208.841, 1352.665, -2596.467, 1, 0, 0, 0, 1, 0, 0, 0, 1),
        Spawns = { Vector3.new(-192.6, 1348.982, -2598.405), Vector3.new(-192.486, 1348.996, -2592.366), Vector3.new(-203.824, 1348.805, -2580.919) }
    }
};
local v2 = {
    Area = {
        Grid = {
            {
                IsParent = true,
                Center = Vector2.new(683.81, -2443.45),
                Radius = Vector2.new(604.61, 1024),
                Type = Menum.AreaType.Rectangle,
                ChildAreas = v1
            },
            {
                IsParent = true,
                Center = Vector2.new(-695.535, -2811.93),
                Radius = Vector2.new(813.035, 661.04),
                Type = Menum.AreaType.Rectangle,
                ChildAreas = v1
            },
            {
                IsParent = true,
                Center = Vector2.new(267.8, -3722.355),
                Radius = Vector2.new(1024, 255.405),
                Type = Menum.AreaType.Rectangle,
                ChildAreas = v1
            },
            {
                IsParent = true,
                Center = Vector2.new(-1420.525, -4161.9),
                Radius = Vector2.new(670.385, 703.67),
                Type = Menum.AreaType.Rectangle,
                ChildAreas = v1
            }
        }
    },
    Shrines = {
        {
            Name = "Frost Veil Shrine",
            Price = {
                Wen = 45000
            },
            At = CFrame.new(
                142.125137,
                1385.08752,
                -2783.1521,
                -0.331576884,
                -0.0178111345,
                0.943260193,
                -0.0249441415,
                0.999637902,
                0.0101072602,
                -0.943098426,
                -0.0201774891,
                -0.331900656
            )
        }
    },
    Npcs = {}
};
local AreaContentLoader = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Subsets"):WaitForChild("Areas"):WaitForChild("AreaContentLoader"));
v2.Npcs = AreaContentLoader.loadNpcs(script, v2.Area);
local NpcContents = script:FindFirstChild("NpcContents");

if NpcContents then
    NpcContents = NpcContents:FindFirstChild("Dialogues");
end;

if NpcContents then
    v2.Dialogues = AreaContentLoader.mergeModules(NpcContents:FindFirstChild("Yap"));
    v2.DialogueFunctions = AreaContentLoader.mergeModules(NpcContents:FindFirstChild("Functions"));
    v2.Quests = AreaContentLoader.mergeModules(NpcContents:FindFirstChild("Quests"));
end;

return v2;
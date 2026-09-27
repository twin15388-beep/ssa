-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
local v1 = {
    ["Seasons Crossing"] = {
        IndependentMarkers = true,
        Grid = {
            {
                Center = Vector2.new(-636.764, -25.16),
                Radius = Vector2.new(301.992, 259.716),
                Type = Menum.AreaType.Rectangle
            }
        }
    },
    ["Dreamfall Hollow"] = {
        Cave = true,
        IndependentMarkers = true,
        Grid = {
            {
                Center = Vector2.new(715.702, 787.728),
                Radius = Vector2.new(237.307, 337.597),
                Type = Menum.AreaType.Rectangle,
                YLimits = Vector2.new(788, 923)
            }
        }
    }
};
local v2 = {
    Area = {
        Grid = {
            {
                IsParent = true,
                Center = Vector2.new(-624, -37.697),
                Radius = Vector2.new(400, 285.607),
                Type = Menum.AreaType.Rectangle,
                ChildAreas = v1
            },
            {
                IsParent = true,
                Center = Vector2.new(126.655, 624.708),
                Radius = Vector2.new(353.345, 559.268),
                Type = Menum.AreaType.Rectangle,
                ChildAreas = v1
            },
            {
                IsParent = true,
                Center = Vector2.new(715.702, 787.728),
                Radius = Vector2.new(237.307, 337.597),
                Type = Menum.AreaType.Rectangle,
                YLimits = Vector2.new(788, 923),
                ChildAreas = v1
            },
            {
                IsParent = true,
                Center = Vector2.new(-497.081, 502.155),
                Radius = Vector2.new(280.325, 259.385),
                Type = Menum.AreaType.Rectangle,
                ChildAreas = v1
            }
        }
    },
    CrystalAt = CFrame.new(136.539932, 873.900024, 733.369995, 0, 0, 1, 0, 1, 0, -1, 0, 0),
    Spawns = { Vector3.new(140.73, 873.5, 728.215), Vector3.new(144.165, 873.5, 735.097) },
    Shrines = {
        {
            Name = "Mistfall Harbor Shrine",
            Price = {
                Wen = 25000
            },
            At = CFrame.new(
                16.9635143,
                967.723755,
                372.266876,
                0.609892726,
                0.00074212387,
                -0.792484641,
                -0.00121682766,
                0.999999702,
                -4.74233142e-9,
                0.792484403,
                0.000964284874,
                0.609889209
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
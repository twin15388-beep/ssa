-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
local v1 = {
    ["Final Selection"] = {
        Village = true,
        Grid = {
            {
                Center = Vector2.new(-2618.765, 3.21),
                Radius = Vector2.new(271.405, 371.94),
                Type = Menum.AreaType.Rectangle
            },
            {
                Center = Vector2.new(-1994, 1050),
                Radius = Vector2.new(103, 103),
                Type = Menum.AreaType.Rectangle
            }
        },
        CrystalAt = CFrame.new(-2547.569, 278, 31.729, 1, 0, 0, 0, 1, 0, 0, 0, 1),
        Spawns = { Vector3.new(-2555.054, 275, 16.436), Vector3.new(-2558.883, 275, 28.715), Vector3.new(-2544.462, 275, 21.486) }
    },
    ["The White Terror Lair"] = {
        Cave = true,
        IndependentMarkers = true,
        Grid = {
            {
                Center = Vector2.new(-1615.071, 505.244),
                Radius = Vector2.new(364.128, 215.824),
                Type = Menum.AreaType.Rectangle,
                YLimits = Vector2.new(-40, 160)
            }
        }
    }
};
local v2 = {
    Area = {
        Grid = {
            {
                IsParent = true,
                Center = Vector2.new(-1994.12, 1050.13),
                Radius = Vector2.new(820.79, 307.87),
                Type = Menum.AreaType.Rectangle,
                YLimits = Vector2.new(12, 592),
                ChildAreas = v1
            },
            {
                IsParent = true,
                Center = Vector2.new(-2618.945, 190.89),
                Radius = Vector2.new(277.035, 561.08),
                Type = Menum.AreaType.Rectangle,
                ChildAreas = v1
            },
            {
                IsParent = true,
                Center = Vector2.new(-2903, 384),
                Radius = Vector2.new(50, 50),
                Type = Menum.AreaType.Rectangle,
                ChildAreas = v1
            },
            {
                IsParent = true,
                Center = Vector2.new(-1834.05, 480),
                Radius = Vector2.new(240, 175),
                Type = Menum.AreaType.Rectangle,
                YLimits = Vector2.new(-40, 160),
                ChildAreas = v1
            }
        }
    },
    Situations = {
        {
            Name = "Safezone",
            SecondaryName = "Final Selection",
            Center = Vector2.new(-2625.25, -78),
            Size = Vector2.new(184, 299)
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
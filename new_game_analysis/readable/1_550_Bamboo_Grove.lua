-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
local v1 = {
    ["Bamboo Grove Sanctuary"] = {
        Grid = {
            {
                Center = Vector2.new(635.273, -388.303),
                Radius = Vector2.new(417.878, 452.769),
                Type = Menum.AreaType.Rectangle
            },
            {
                Center = Vector2.new(767.618, 151.514),
                Radius = Vector2.new(285.179, 103.514),
                Type = Menum.AreaType.Rectangle
            }
        },
        CrystalAt = CFrame.new(627.065, 1020, -194.484, 1, 0, 0, 0, 1, 0, 0, 0, 1),
        Spawns = { Vector3.new(620.506, 1017, -199.069), Vector3.new(621.174, 1017, -190.334) }
    }
};
local v2 = {
    Area = {
        Grid = {
            {
                IsParent = true,
                Center = Vector2.new(442.676, -677.636),
                Radius = Vector2.new(613.176, 743.015),
                Type = Menum.AreaType.Rectangle,
                ChildAreas = v1
            },
            {
                IsParent = true,
                Center = Vector2.new(768.071, 141.377),
                Radius = Vector2.new(287.929, 114.623),
                Type = Menum.AreaType.Rectangle,
                ChildAreas = v1
            }
        }
    },
    CrystalAt = CFrame.new(
        367.688965,
        1129.47925,
        -941.085938,
        1.22464698e-16,
        7.54979013e-8,
        -1,
        1.22464672e-16,
        1,
        7.54979013e-8,
        1,
        -1.22464685e-16,
        1.22464685e-16
    ),
    Spawns = { Vector3.new(422, 1128, -915), Vector3.new(423, 1128, -892) },
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
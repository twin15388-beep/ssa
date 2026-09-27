-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
local v1 = {
    Area = {
        Village = true,
        Grid = {
            {
                Center = Vector2.new(1801.21, -354.98),
                Radius = Vector2.new(302.88, 690.67),
                Type = Menum.AreaType.Rectangle,
                YLimits = Vector2.new(550, 845)
            }
        }
    },
    CrystalAt = CFrame.new(1640, 606.3, -125, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Spawns = { Vector3.new(1651.024, 607.3, -124), Vector3.new(1644, 605.796, -112) },
    Shrines = {
        {
            Name = "Hidden Mist Village Shrine",
            Price = {
                Wen = 35000
            },
            At = CFrame.new(
                1266.15491,
                980.876465,
                -482.316437,
                -0.536102057,
                -0.00247755041,
                -0.844153821,
                -0.019812597,
                0.999755621,
                0.0096482886,
                0.843923807,
                0.0218971502,
                -0.536020577
            )
        }
    },
    Npcs = {}
};
local AreaContentLoader = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Subsets"):WaitForChild("Areas"):WaitForChild("AreaContentLoader"));

if script:FindFirstChild("Npcs") ~= nil then
    v1.Npcs = AreaContentLoader.loadNpcs(script, v1.Area);
end;

local NpcContents = script:FindFirstChild("NpcContents");

if NpcContents then
    NpcContents = NpcContents:FindFirstChild("Dialogues");
end;

if NpcContents then
    v1.Dialogues = AreaContentLoader.mergeModules(NpcContents:FindFirstChild("Yap"));
    v1.DialogueFunctions = AreaContentLoader.mergeModules(NpcContents:FindFirstChild("Functions"));
    v1.Quests = AreaContentLoader.mergeModules(NpcContents:FindFirstChild("Quests"));
end;

return v1;
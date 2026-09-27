-- Decompiled with Potassium's decompiler.

local Menum = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Menum"));
local v1 = {
    Area = {
        Grid = {
            {
                Center = Vector2.new(2564.096, -590.007),
                Radius = Vector2.new(348.101, 455.86),
                Type = Menum.AreaType.Rectangle
            }
        }
    },
    Npcs = {}
};
local AreaContentLoader = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Subsets"):WaitForChild("Areas"):WaitForChild("AreaContentLoader"));
v1.Npcs = AreaContentLoader.loadNpcs(script, v1.Area);
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
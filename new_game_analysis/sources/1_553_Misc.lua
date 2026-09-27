-- Decompiled with Potassium's decompiler.

local v1 = {
    Situations = { require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("MuzanSettings")).LairSituation },
    Npcs = {}
};
local AreaContentLoader = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Subsets"):WaitForChild("Areas"):WaitForChild("AreaContentLoader"));
v1.Npcs = AreaContentLoader.loadNpcs(script);
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
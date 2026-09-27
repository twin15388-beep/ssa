-- Decompiled with Potassium's decompiler.

local AreaLocator = game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Subsets"):WaitForChild("Areas"):WaitForChild("AreaLocator");
local v1 = require(AreaLocator);
local Locator = require(AreaLocator:WaitForChild("Locator"));
local Regions = require(game.ReplicatedStorage:WaitForChild("Regions"));

for _, v in pairs(Regions.Regions) do
    if v.Area then
        v1.CurrentAreas[v.Name] = v.Area;
    end;
end;

for i, v in Regions.Biomes do
    Locator.Biomes[i] = v;
end;
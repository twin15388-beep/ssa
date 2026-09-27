-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Teleporter = require(ReplicatedStorage.CAM.Client.Modules.Teleporter);
local Worlds = require(ReplicatedStorage.CAM.Worlds);

if not require(ReplicatedStorage.CAM.Global.gameSettings).loadingScreenEnabled then
    return;
end;

local v1 = Worlds.ById[game.PlaceId];
local Attribute = workspace:GetAttribute("Minigame");
local v2;

if v1 == nil or v1.Ignore then
    if Attribute == nil then
        return;
    end;

    v2 = {
        Title = "Minigame",
        SubTitle = tostring(Attribute)
    };
else
    v2 = {
        Title = v1.Name
    };
end;

local os_clock_ret = os.clock();
Teleporter.ShowCover(v2);

repeat
    task.wait(0.1);
until os.clock() - os_clock_ret >= 1.25 and (game:IsLoaded() or os.clock() - os_clock_ret >= 3);

Teleporter.HideCover();
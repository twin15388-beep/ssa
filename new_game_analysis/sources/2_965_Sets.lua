-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SettingsKeys = require(ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Global"):WaitForChild("Subsets"):WaitForChild("Gameplay"):WaitForChild("SettingsKeys"));
local Visibility = ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Components"):WaitForChild("Layout"):WaitForChild("Visibility");
local v1 = {
    [Visibility.HUD] = { "MenuOpened", "MapOpened", "SummonCamera", "Cutscene", "Dialogue", "Training", "MinigameVictory", "FishingBite" },
    [Visibility.Menu] = { "MenuClosed", "SummonCamera", "Cutscene", "Dialogue", "Training", "MinigameVictory", "FishingBite" },
    [Visibility.Prompts] = { "SummonCamera", "Cutscene", "Dialogue", "Training", "MinigameVictory", "FishingBite" },
    [Visibility.Markers.Default] = { "Training", "Dialogue", "Cutscene", "MenuOpened", "MapOpened", "MuzanLair", "MinigameVictory", "FishingBite" },
    [Visibility.Overhead.All] = { "SummonCamera", "Cutscene", "CameralessCutscene", "Dialogue", "Training", "MinigameVictory", "FishingBite" },
    [Enum.CoreGuiType.Chat.Name] = { "MenuOpened", "MapOpened", "SummonCamera", "Cutscene", "Dialogue", "Training", "LoadingScreen", "FishingBite" },
    [Enum.CoreGuiType.PlayerList.Name] = { "Skill Tree", "LoadingScreen", "FishingBite", "Cutscene" },
    [Visibility.BossUI] = {
        SettingsKeys.BossUIAttribute,
        "MenuOpened",
        "MapOpened",
        "SummonCamera",
        "Cutscene",
        "MinigameVictory",
        "TrialEnding"
    },
    [script.Billboards] = { "SummonCamera", "Cutscene", "Dialogue", "Training", "MinigameVictory", "FishingBite" }
};
local Minimap = Visibility:FindFirstChild("Minimap");

if Minimap == nil then
    Minimap = Instance.new("BoolValue");
    Minimap.Name = "Minimap";
    Minimap.Value = true;
    Minimap.Parent = Visibility;
end;

v1[Minimap] = { "MenuOpened", "SummonCamera", "Cutscene", "Dialogue", "Training", "MuzanLair", "MinigameVictory", "FishingBite" };
local Compass = Visibility:FindFirstChild("Compass");

if Compass == nil then
    Compass = Instance.new("BoolValue");
    Compass.Name = "Compass";
    Compass.Value = true;
    Compass.Parent = Visibility;
end;

v1[Compass] = { "MapOpened" };
local ParkourMarkers = Visibility.Markers:FindFirstChild("ParkourMarkers");

if ParkourMarkers ~= nil then
    v1[ParkourMarkers] = { "MenuOpened", "Cutscene", "Dialogue" };
end;

local AllMarkers = Visibility.Markers:FindFirstChild("AllMarkers");

if AllMarkers == nil then
    AllMarkers = Instance.new("BoolValue");
    AllMarkers.Name = "AllMarkers";
    AllMarkers.Value = true;
    AllMarkers.Parent = Visibility.Markers;
end;

v1[AllMarkers] = { "MapOpened" };
local Controls = Visibility:FindFirstChild("Controls");

if Controls == nil then
    Controls = Instance.new("BoolValue");
    Controls.Name = "Controls";
    Controls.Value = true;
    Controls.Parent = Visibility;
end;

v1[Controls] = { "MenuOpened", "MapOpened", "SummonCamera", "Cutscene", "Dialogue", "MinigameVictory", "FishingBite" };

return v1;
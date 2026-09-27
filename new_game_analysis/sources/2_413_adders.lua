-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Utility = require(ReplicatedStorage.CAM.Global.Utility);
local LocalPlayer = Players.LocalPlayer;
local Data = Utility.GetData(LocalPlayer, true);

for _, v in script:QueryDescendants("ModuleScript") do
    require(v)(LocalPlayer, Data);
end;
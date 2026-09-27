-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local DataValue = require(ReplicatedStorage.CAM.Client.Modules.DataValue);
local SettingsKeys = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.SettingsKeys);
local LocalPlayer = Players.LocalPlayer;
local u1 = DataValue.new(SettingsKeys.BossUI.Path, SettingsKeys.BossUI.Default, SettingsKeys.Scope);
u1.Changed:Connect(function() -- Line: 27, Name: apply
    -- upvalues: LocalPlayer (copy), SettingsKeys (copy), u1 (copy)
    LocalPlayer:SetAttribute(SettingsKeys.BossUIAttribute, u1:Get() ~= true);
end);
LocalPlayer:SetAttribute(SettingsKeys.BossUIAttribute, u1:Get() ~= true);
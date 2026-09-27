-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local DataValue = require(ReplicatedStorage.CAM.Client.Modules.DataValue);
local Platform_Handler = require(ReplicatedStorage.CAM.Client.Controllers.Platform_Handler);
local SettingsKeys = require(ReplicatedStorage.CAM.Global.Subsets.Gameplay.SettingsKeys);
local u1 = DataValue.new(SettingsKeys.ForcePlatform.Path, SettingsKeys.ForcePlatform.Default, SettingsKeys.Scope);
u1.Changed:Connect(function() -- Line: 24, Name: apply
    -- upvalues: u1 (copy), Platform_Handler (copy), SettingsKeys (copy)
    local v2 = u1:Get();
    Platform_Handler.Forced = not SettingsKeys.IsPlatformChoice(v2) and "" or v2;
    Platform_Handler.Apply();
end);
local v3 = u1:Get();
Platform_Handler.Forced = not SettingsKeys.IsPlatformChoice(v3) and "" or v3;
Platform_Handler.Apply();
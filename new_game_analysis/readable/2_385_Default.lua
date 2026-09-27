-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local DayAndNightHandler = require(ReplicatedStorage.CAM.Global.DayAndNightHandler);
local NightIllumination = require(ReplicatedStorage.CAM.Client.Modules.NightIllumination);
local gameSettings = require(ReplicatedStorage.CAM.Global.gameSettings);
local u1 = require(ReplicatedStorage.Packages.cleanit).new();
local Color3_fromRGB_ret = Color3.fromRGB(70, 70, 70);

return {
    Properties = {
        Brightness = 2.5,
        EnvironmentDiffuseScale = 1,
        EnvironmentSpecularScale = 1,
        GlobalShadows = true,
        ShadowSoftness = 0.4,
        ClockTime = 12.5,
        GeographicLatitude = 45,
        ExposureCompensation = 0.1,
        FogEnd = 100000,
        FogStart = 0,
        Ambient = Color3_fromRGB_ret,
        ColorShift_Bottom = Color3.new(),
        ColorShift_Top = Color3.new(),
        OutdoorAmbient = Color3.fromRGB(70, 70, 70),
        FogColor = Color3.fromRGB(192, 192, 192)
    },

    Do = function() -- Line: 31, Name: Do
        -- upvalues: gameSettings (copy), NightIllumination (copy), Color3_fromRGB_ret (copy), u1 (copy), DayAndNightHandler (copy)
        if not gameSettings.IsMinigame then
            NightIllumination.Start({
                Day = {
                    ExposureCompensation = 0.1,
                    Ambient = Color3_fromRGB_ret
                }
            });
        end;

        u1:Add(task.spawn(function() -- Line: 40
            -- upvalues: DayAndNightHandler (ref)
            while true do
                DayAndNightHandler.Apply();
                task.wait(0.5);
            end;
        end));
    end,

    Stop = function() -- Line: 47, Name: Stop
        -- upvalues: u1 (copy), NightIllumination (copy), DayAndNightHandler (copy)
        u1:Clean();
        NightIllumination.Stop();
        DayAndNightHandler:Reset();
    end,

    Instances = script:GetChildren()
};
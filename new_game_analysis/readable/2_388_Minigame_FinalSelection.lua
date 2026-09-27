-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local NightIllumination = require(ReplicatedStorage.CAM.Client.Modules.NightIllumination);
local Color3_fromRGB_ret = Color3.fromRGB(100, 100, 100);

return {
    Properties = {
        ClockTime = 5,
        ExposureCompensation = 0.75,
        Brightness = 2.5,
        EnvironmentDiffuseScale = 1,
        EnvironmentSpecularScale = 1,
        GeographicLatitude = 30.753,
        Ambient = Color3_fromRGB_ret,
        ColorShift_Bottom = Color3.new(),
        ColorShift_Top = Color3.new(),
        OutdoorAmbient = Color3.fromRGB(70, 70, 70)
    },

    Do = function() -- Line: 30, Name: Do
        -- upvalues: NightIllumination (copy), Color3_fromRGB_ret (copy)
        NightIllumination.Start({
            AlwaysNight = true,
            Night = {
                ExposureCompensation = 0.75,
                Ambient = Color3_fromRGB_ret
            }
        });
    end,

    Stop = function() -- Line: 36, Name: Stop
        -- upvalues: NightIllumination (copy)
        NightIllumination.Stop();
    end,

    Instances = script:GetChildren()
};
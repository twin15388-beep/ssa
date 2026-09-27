-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.CAM.Global.DayAndNightHandler);
require(ReplicatedStorage.Packages.cleanit).new();

return {
    Properties = {
        Brightness = 3,
        EnvironmentDiffuseScale = 0.808,
        EnvironmentSpecularScale = 0.718,
        GlobalShadows = true,
        ShadowSoftness = 0.2,
        ClockTime = 11.378,
        GeographicLatitude = 20.347,
        ExposureCompensation = 0,
        Ambient = Color3.fromRGB(126, 105, 105),
        ColorShift_Bottom = Color3.new(),
        ColorShift_Top = Color3.fromRGB(202, 141, 56),
        OutdoorAmbient = Color3.fromRGB(70, 70, 70)
    },
    Instances = script:GetChildren()
};
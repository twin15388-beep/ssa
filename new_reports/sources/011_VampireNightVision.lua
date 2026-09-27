-- Decompiled with Potassium's decompiler.

local Lighting = game:GetService("Lighting");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local v1 = {};
local LocalPlayer = Players.LocalPlayer;
local v2 = ReplicatedStorage:WaitForChild("Funções");
local DayNightConfig = require(v2:WaitForChild("DayNightConfig"));
local u3 = false;
local u4 = false;
local u5 = {
    Brightness = Lighting.Brightness,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    ExposureCompensation = Lighting.ExposureCompensation
};
local u6 = (function() -- Line: 23, Name: getOrCreateEffect
    -- upvalues: Lighting (copy)
    local VampireNightVisionEffect = Lighting:FindFirstChild("VampireNightVisionEffect");

    if VampireNightVisionEffect then
        VampireNightVisionEffect:Destroy();
    end;

    local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
    ColorCorrectionEffect.Name = "VampireNightVisionEffect";
    ColorCorrectionEffect.Enabled = false;
    ColorCorrectionEffect.Brightness = 0.06;
    ColorCorrectionEffect.Contrast = -0.04;
    ColorCorrectionEffect.Saturation = -0.02;
    ColorCorrectionEffect.TintColor = Color3.fromRGB(232, 240, 255);
    ColorCorrectionEffect.Parent = Lighting;

    return ColorCorrectionEffect;
end)();

local function hasPotionNightVision() -- Line: 43
    -- upvalues: LocalPlayer (copy)
    local v7 = tonumber(LocalPlayer:GetAttribute("NightVisionPotionExpiresAt")) or 0;
    local ServerTimeNow = workspace:GetServerTimeNow();

    return math.floor(ServerTimeNow) < v7;
end;

local function shouldUseNightVision() -- Line: 48
    -- upvalues: LocalPlayer (copy), DayNightConfig (copy), Lighting (copy)
    local v8 = LocalPlayer.Team and LocalPlayer.Team.Name;
    local v9 = LocalPlayer.Character and LocalPlayer.Character:GetAttribute("VampireInfected") == true;
    local v10 = LocalPlayer:GetAttribute("LanternEquipped") == true;
    local v11 = (v8 == "Vampires" or v8 == "Cannibal Raised") and true or (v8 == "Werewolfs" and true or v9);

    if not v11 then
        local v12 = tonumber(LocalPlayer:GetAttribute("NightVisionPotionExpiresAt")) or 0;
        local ServerTimeNow = workspace:GetServerTimeNow();
        v11 = math.floor(ServerTimeNow) < v12 or v10;
    end;

    return v11 and not DayNightConfig.IsDay(Lighting.ClockTime);
end;

local function applyNightVision(p13) -- Line: 60
    -- upvalues: u4 (ref), LocalPlayer (copy), Lighting (copy), u5 (copy), u6 (copy)
    if u4 == p13 then
        return;
    end;

    u4 = p13;
    LocalPlayer:SetAttribute("VampireNightVisionActive", u4);
    LocalPlayer:SetAttribute("NightVisionActive", u4);

    if p13 then
        Lighting.Brightness = math.max(u5.Brightness, 3.25);
        Lighting.Ambient = Color3.fromRGB(105, 110, 125);
        Lighting.OutdoorAmbient = Color3.fromRGB(125, 130, 145);
        Lighting.ExposureCompensation = u5.ExposureCompensation + 0.65;
        u6.Enabled = true;

        return;
    end;

    Lighting.Brightness = u5.Brightness;
    Lighting.Ambient = u5.Ambient;
    Lighting.OutdoorAmbient = u5.OutdoorAmbient;
    Lighting.ExposureCompensation = u5.ExposureCompensation;
    u6.Enabled = false;
end;

local function update() -- Line: 83
    -- upvalues: applyNightVision (copy), shouldUseNightVision (copy)
    applyNightVision((shouldUseNightVision()));
end;

function v1.Start() -- Line: 87
    -- upvalues: u3 (ref), LocalPlayer (copy), update (copy), Lighting (copy), applyNightVision (copy), shouldUseNightVision (copy)
    if u3 then
        return;
    end;

    u3 = true;
    LocalPlayer:GetPropertyChangedSignal("Team"):Connect(update);
    LocalPlayer:GetAttributeChangedSignal("LanternEquipped"):Connect(update);
    Lighting:GetPropertyChangedSignal("ClockTime"):Connect(update);
    LocalPlayer:GetAttributeChangedSignal("NightVisionPotionExpiresAt"):Connect(function() -- Line: 96
        -- upvalues: applyNightVision (ref), shouldUseNightVision (ref), LocalPlayer (ref)
        applyNightVision((shouldUseNightVision()));
        local u14 = tonumber(LocalPlayer:GetAttribute("NightVisionPotionExpiresAt")) or 0;
        local ServerTimeNow = workspace:GetServerTimeNow();
        local v15 = u14 - math.floor(ServerTimeNow);

        if v15 > 0 then
            task.delay(v15 + 0.2, function() -- Line: 101
                -- upvalues: LocalPlayer (ref), u14 (copy), applyNightVision (ref), shouldUseNightVision (ref)
                if (tonumber(LocalPlayer:GetAttribute("NightVisionPotionExpiresAt")) or 0) == u14 then
                    applyNightVision((shouldUseNightVision()));
                end;
            end);
        end;
    end);
    LocalPlayer.CharacterAdded:Connect(function(p16) -- Line: 109
        -- upvalues: update (ref), applyNightVision (ref), shouldUseNightVision (ref)
        p16:GetAttributeChangedSignal("VampireInfected"):Connect(update);
        applyNightVision((shouldUseNightVision()));
    end);

    if LocalPlayer.Character then
        LocalPlayer.Character:GetAttributeChangedSignal("VampireInfected"):Connect(update);
    end;

    LocalPlayer:SetAttribute("VampireNightVisionActive", false);
    LocalPlayer:SetAttribute("NightVisionActive", false);
    applyNightVision((shouldUseNightVision()));
end;

return v1;
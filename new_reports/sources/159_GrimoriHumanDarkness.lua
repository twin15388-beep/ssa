-- Decompiled with Potassium's decompiler.

local Lighting = game:GetService("Lighting");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer;
local GrimoriDarknessGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("GrimoriDarknessGui");

if GrimoriDarknessGui then
    GrimoriDarknessGui:Destroy();
end;

local GrimoriHumanDarkness = Lighting:FindFirstChild("GrimoriHumanDarkness");

if GrimoriHumanDarkness then
    GrimoriHumanDarkness:Destroy();
end;

local u1 = 0;
local Ambient = Lighting.Ambient;
local OutdoorAmbient = Lighting.OutdoorAmbient;
local Brightness = Lighting.Brightness;

local function findGrimori() -- Line: 30
    local ITENS = workspace:FindFirstChild("ITENS");

    if ITENS then
        ITENS = ITENS:FindFirstChild("Grimori");
    end;

    return ITENS or workspace:FindFirstChild("Grimori");
end;

local function getTargetIntensity() -- Line: 36
    -- upvalues: LocalPlayer (copy)
    if not LocalPlayer.Team or LocalPlayer.Team.Name ~= "Humans" then
        return 0;
    end;

    local Character = LocalPlayer.Character;
    local v2;

    if Character then
        v2 = Character:FindFirstChild("HumanoidRootPart");
    else
        v2 = Character;
    end;

    if Character then
        Character = Character:FindFirstChildOfClass("Humanoid");
    end;

    local ITENS = workspace:FindFirstChild("ITENS");

    if ITENS then
        ITENS = ITENS:FindFirstChild("Grimori");
    end;

    local v3 = ITENS or workspace:FindFirstChild("Grimori");

    if not (v2 and (Character and (Character.Health > 0 and (v3 and (v3:IsA("Model") and v3:GetAttribute("HumanDarknessEnabled") ~= false))))) then
        return 0;
    end;

    local Attribute = v3:GetAttribute("HumanDarknessRadius");
    local v4 = (type(Attribute) ~= "number" or Attribute <= 0) and 14 or Attribute;
    local Attribute2 = v3:GetAttribute("HumanDarknessFullRadius");
    local v5 = (type(Attribute2) ~= "number" or Attribute2 < 0) and 5 or Attribute2;
    local math_min_ret = math.min(v5, v4 - 0.1);
    local Magnitude = (v2.Position - v3:GetPivot().Position).Magnitude;

    return v4 <= Magnitude and 0 or (Magnitude <= math_min_ret and 1 or 1 - (Magnitude - math_min_ret) / (v4 - math_min_ret));
end;

local u9 = RunService.RenderStepped:Connect(function(p6) -- Line: 77
    -- upvalues: getTargetIntensity (copy), u1 (ref), Ambient (ref), Lighting (copy), OutdoorAmbient (ref), Brightness (ref)
    local v7 = getTargetIntensity();
    local v8 = 1 - math.exp(-8 * p6);
    u1 = u1 + (v7 - u1) * v8;

    if v7 ~= 0 or u1 >= 0.003 then
        Lighting.Ambient = Ambient:Lerp(Color3.new(0, 0, 0), u1);
        Lighting.OutdoorAmbient = OutdoorAmbient:Lerp(Color3.new(0, 0, 0), u1);
        Lighting.Brightness = Brightness * (1 - u1);

        return;
    end;

    u1 = 0;
    Ambient = Lighting.Ambient;
    OutdoorAmbient = Lighting.OutdoorAmbient;
    Brightness = Lighting.Brightness;
end);
script.Destroying:Connect(function() -- Line: 97
    -- upvalues: u9 (copy), Lighting (copy), Ambient (ref), OutdoorAmbient (ref), Brightness (ref)
    u9:Disconnect();
    Lighting.Ambient = Ambient;
    Lighting.OutdoorAmbient = OutdoorAmbient;
    Lighting.Brightness = Brightness;
end);
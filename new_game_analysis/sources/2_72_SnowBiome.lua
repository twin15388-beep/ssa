-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local AreaLocator = require(ReplicatedStorage.CAM.Global.Subsets.Areas.AreaLocator);
local NightIllumination = require(ReplicatedStorage.CAM.Client.Modules.NightIllumination);
local CFrame_Angles_ret = CFrame.Angles(0, 0, 1.5707963267948966);
local u1 = script:FindFirstChildWhichIsA("BasePart");

if u1 == nil then
    warn("[SnowBiome] no BasePart directly under the script, snow particles are off. Children:", script:GetChildren());
end;

local u2 = nil;

local function stop() -- Line: 29
    -- upvalues: u2 (ref), RunService (copy)
    if u2 ~= nil then
        RunService:UnbindFromRenderStep("SnowBiomeFollow");
        u2:Destroy();
        u2 = nil;
    end;
end;

local function start() -- Line: 37
    -- upvalues: u1 (copy), u2 (ref), RunService (copy), CFrame_Angles_ret (copy)
    if u1 == nil or u2 ~= nil then
        return;
    end;

    local u3 = u1:Clone();
    u3.Anchored = true;
    u3.CanCollide = false;
    u3.CanQuery = false;
    u3.CanTouch = false;
    u3.Parent = workspace.Debree;
    u2 = u3;
    RunService:BindToRenderStep("SnowBiomeFollow", Enum.RenderPriority.Camera.Value + 1, function() -- Line: 47
        -- upvalues: u3 (copy), CFrame_Angles_ret (ref)
        u3.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position + Vector3.new(0, 10, 0)) * CFrame_Angles_ret;
    end);
end;

AreaLocator.AreaEquipped.BiomeUpdate:Connect(function(p4: string?) -- Line: 53, Name: apply
    -- upvalues: start (copy), NightIllumination (copy), u2 (ref), RunService (copy)
    if p4 == "Snow" then
        start();
        NightIllumination.SetDensityBonus("Snow", 0.1);

        return;
    end;

    if u2 ~= nil then
        RunService:UnbindFromRenderStep("SnowBiomeFollow");
        u2:Destroy();
        u2 = nil;
    end;

    NightIllumination.SetDensityBonus("Snow", nil);
end);

if AreaLocator.AreaEquipped.Biome == "Snow" then
    start();
    NightIllumination.SetDensityBonus("Snow", 0.1);
else
    if u2 ~= nil then
        RunService:UnbindFromRenderStep("SnowBiomeFollow");
        u2:Destroy();
        u2 = nil;
    end;

    NightIllumination.SetDensityBonus("Snow", nil);
end;
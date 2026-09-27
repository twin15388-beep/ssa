-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ControlModule = require(script.Parent:WaitForChild("ControlModule"));
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local CommonUtils = require(script.Parent:WaitForChild("CommonUtils"));
local v2 = CommonUtils.get("FlagUtil");
local u3 = CommonUtils.get("PlayerModuleEventBus");
local UserFlag = v2.getUserFlag("UserDisableForceLocalHumanoidPrediction");
local u4 = false;

function u1.PredictLocalHumanoid() -- Line: 26
    -- upvalues: RunService (copy), Players (copy)
    local function v6(p5: userdata) -- Line: 27
        -- upvalues: RunService (ref)
        RunService:SetPredictionMode(p5:WaitForChild("HumanoidRootPart"), Enum.PredictionMode.On);
    end;

    if Players.LocalPlayer.Character then
        RunService:SetPredictionMode(Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart"), Enum.PredictionMode.On);

        return;
    end;

    Players.LocalPlayer.CharacterAdded:Connect(v6);
end;

function u1.initialize(p7) -- Line: 38
    -- upvalues: u4 (ref)
    p7.isServerAuthority = u4;
end;

function u1.Initialize() -- Line: 42
    -- upvalues: UserFlag (copy), RunService (copy), u1 (copy), u3 (copy), ControlModule (copy), u4 (ref)
    if not UserFlag and RunService:IsClient() then
        u1.PredictLocalHumanoid();
    end;

    if not u3.data.inputsSetupComplete and RunService:IsServer() then
        u3:subscribe("INPUTS_SETUP"):Wait();
    end;

    ControlModule:InitializeServerAuthority();
    u4 = true;
end;

return u1;
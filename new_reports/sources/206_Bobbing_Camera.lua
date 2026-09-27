-- Decompiled with Potassium's decompiler.

local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
local Workspace = game:GetService("Workspace");
local LocalPlayer = Players.LocalPlayer;
local script_Parent = script.Parent;
local Humanoid = script_Parent:WaitForChild("Humanoid");
local HumanoidRootPart = script_Parent:WaitForChild("HumanoidRootPart");
local u1 = "SmoothBobbingCamera_" .. LocalPlayer.UserId .. "_" .. HttpService:GenerateGUID(false);
local u2 = 0;
local u3 = 0;
local u4 = 0;
local u5 = 0;
local u6 = 0;
local u7 = false;
UserInputService.MouseIconEnabled = true;

local function smooth(p8, p9, p10, p11) -- Line: 30
    local v12 = 1 - math.exp(-p10 * p11);

    return p8 + (p9 - p8) * v12;
end;

local function stop() -- Line: 35
    -- upvalues: u7 (ref), RunService (copy), u1 (copy), UserInputService (copy)
    if u7 then
        return;
    end;

    u7 = true;
    RunService:UnbindFromRenderStep(u1);
    UserInputService.MouseIconEnabled = true;
end;

RunService:BindToRenderStep(u1, Enum.RenderPriority.Camera.Value + 1, function(p13) -- Line: 47
    -- upvalues: Humanoid (copy), script_Parent (copy), u7 (ref), RunService (copy), u1 (copy), UserInputService (copy), Workspace (copy), HumanoidRootPart (copy), u2 (ref), u3 (ref), u4 (ref), u5 (ref), u6 (ref)
    if Humanoid.Health <= 0 or not script_Parent.Parent then
        if u7 then
            return;
        end;

        u7 = true;
        RunService:UnbindFromRenderStep(u1);
        UserInputService.MouseIconEnabled = true;

        return;
    end;

    local CurrentCamera = Workspace.CurrentCamera;

    if not CurrentCamera then
        return;
    end;

    local math_min_ret = math.min(p13, 0.05);
    local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity;
    local Magnitude = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude;
    local v14 = Humanoid.FloorMaterial ~= Enum.Material.Air;

    if v14 then
        if Humanoid.MoveDirection.Magnitude > 0.05 then
            v14 = Magnitude > 0.5;
        else
            v14 = false;
        end;
    end;

    local v15 = v14 and math.clamp(Magnitude / 24, 0, 1) or 0;

    if v14 then
        u2 = u2 + math_min_ret * (4.5 + v15);
    end;

    local v16 = math.cos(u2 * 0.5) * 0.003 * v15;
    local v17 = math.sin(u2) * 0.005 * v15;
    local v18 = math.sin(u2) * 0.00017453292519943296 * v15;
    local v19 = math.cos(u2 * 0.5) * 0.0002617993877991494 * v15;
    local v20 = u3;
    local v21 = 1 - math.exp(-5 * math_min_ret);
    u3 = v20 + (v16 - v20) * v21;
    local v22 = u4;
    local v23 = 1 - math.exp(-5 * math_min_ret);
    u4 = v22 + (v17 - v22) * v23;
    local v24 = u5;
    local v25 = 1 - math.exp(-4 * math_min_ret);
    u5 = v24 + (v18 - v24) * v25;
    local v26 = u6;
    local v27 = 1 - math.exp(-4 * math_min_ret);
    u6 = v26 + (v19 - v26) * v27;
    CurrentCamera.CFrame = CurrentCamera.CFrame * CFrame.new(u3, u4, 0) * CFrame.Angles(u5, 0, u6);
end);
Humanoid.Died:Connect(stop);
script.Destroying:Connect(stop);
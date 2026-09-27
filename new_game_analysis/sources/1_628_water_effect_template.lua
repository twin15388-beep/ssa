-- Decompiled with Potassium's decompiler.

game:GetService("Players");
game:GetService("TweenService");
game:GetService("RunService");
local CAM = game:GetService("ReplicatedStorage").CAM;
local Modules = CAM.Client.Modules;
local _ = workspace.Debree;
script:FindFirstChild("Assets");
script:FindFirstChild("Sounds");
require(CAM.DebrisModule);
require(Modules.Effects.Cam_Shaker);
require(Modules.Effects.Craters.CraterHandler);
require(Modules.Effects.BoatTween);
require(game.ReplicatedStorage.CAM.Client.Modules.Effects.vfxUtility);
local _ = game.Players.LocalPlayer;
local workspace_CurrentCamera = workspace.CurrentCamera;
local RaycastParams_new_ret = RaycastParams.new();
RaycastParams_new_ret.FilterDescendantsInstances = { workspace.Map };
RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;

return function(p1: userdata, p2: any) -- Line: 46
    -- upvalues: workspace_CurrentCamera (copy)
    local v3 = p1:FindFirstChild("HumanoidRootPart") or p1.PrimaryPart;
    p1:FindFirstChild("UpperTorso");

    if p2 == "Cancel" or (v3.Position - workspace_CurrentCamera.CFrame.Position).Magnitude <= 250 then
    end;
end;
-- Decompiled with Potassium's decompiler.

local workspace_CurrentCamera = workspace.CurrentCamera;
local Cam_Shaker = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Modules"):WaitForChild("Effects"):WaitForChild("Cam_Shaker"));
local vfxUtility = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Modules"):WaitForChild("Effects"):WaitForChild("vfxUtility"));
local TweenService = game:GetService("TweenService");
local DebrisModule = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));

return function(p1) -- Line: 6
    -- upvalues: workspace_CurrentCamera (copy), vfxUtility (copy), Cam_Shaker (copy), TweenService (copy), DebrisModule (copy)
    if (p1.Position - workspace_CurrentCamera.CFrame.Position).Magnitude >= 400 then
        return;
    end;

    local v2 = script.Part:Clone();
    v2.Parent = workspace.Debree;
    v2.CFrame = p1;
    v2.Transparency = 1;
    vfxUtility.EmitAll(v2.Attachment);
    v2.Attachment.Sound:Play();
    Cam_Shaker(p1.Position, "tinyshake_preset");
    TweenService:Create(v2.Attachment.PointLight, TweenInfo.new(0.4), {
        Brightness = 0
    }):Play();
    DebrisModule:AddItem(v2, 2);
end;
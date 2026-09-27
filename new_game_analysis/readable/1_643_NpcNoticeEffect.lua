-- Decompiled with Potassium's decompiler.

local workspace_CurrentCamera = workspace.CurrentCamera;
local vfxUtility = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("Client"):WaitForChild("Modules"):WaitForChild("Effects"):WaitForChild("vfxUtility"));
local DebrisModule = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));

return function(p1) -- Line: 4
    -- upvalues: workspace_CurrentCamera (copy), vfxUtility (copy), DebrisModule (copy)
    if p1 ~= nil then
        local Head = p1:FindFirstChild("Head");

        if Head == nil then
            return;
        end;

        if (workspace_CurrentCamera.CFrame.Position - Head.Position).Magnitude >= 150 then
            return;
        end;

        local v2 = script.Part:Clone();
        v2.CFrame = Head.CFrame * CFrame.new(0, 2.2, 0);
        v2.Parent = workspace.Debree;
        v2.Sound:Play();
        vfxUtility.EmitAll(v2);
        DebrisModule:AddItem(v2, 2.25);
    end;
end;
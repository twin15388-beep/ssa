-- Decompiled with Potassium's decompiler.

local DebrisModule = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));
local _ = table.find;
local Normal = game.ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Combat_Package"):WaitForChild("Normal");

return function(p1, p2, p3) -- Line: 4
    -- upvalues: Normal (copy), DebrisModule (copy)
    if p1 == nil then
        return;
    end;

    local v4 = p3 == true and p2 == 1 and 0 or p2;
    local HumanoidRootPart = p1:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart ~= nil and (HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude <= 100 then
        local v5 = Normal.Swing_Sounds:FindFirstChild("Swing" .. v4) or Normal.Swing_Sounds.Swing5;

        if v5 ~= nil then
            local v6 = v5:Clone();
            v6.Parent = HumanoidRootPart;
            v6:Play();
            DebrisModule:AddItem(v6, v6.TimeLength);
        end;
    end;
end;
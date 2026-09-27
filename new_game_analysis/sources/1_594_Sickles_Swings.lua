-- Decompiled with Potassium's decompiler.

local DebrisModule = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));
local WeaponAuras = require(script.Parent:WaitForChild("WeaponAuras"));
local u1 = {
    skipSound = true,
    skipTrails = true,
    anchorParts = {
        SickleR = true,
        SickleL = true,
        SickleRight = true,
        SickleLeft = true
    }
};

return function(p2, p3, p4) -- Line: 31
    -- upvalues: WeaponAuras (copy), u1 (copy), DebrisModule (copy)
    if p2 == nil then
        return;
    end;

    local HumanoidRootPart = p2:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart == nil then
        return;
    end;

    if (HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude > 100 then
        return;
    end;

    WeaponAuras(p2, p3, p4, u1);
    local Tool_Accessories = p2:FindFirstChild("Tool_Accessories");
    local v5;

    if Tool_Accessories == nil then
        v5 = nil;
    else
        v5 = Tool_Accessories:FindFirstChild("SickleRight") or nil;
    end;

    local v6;

    if v5 == nil then
        v6 = false;
    else
        v6 = v5:FindFirstChild("Part") ~= nil;
    end;

    local v7 = v6 and script:FindFirstChild("BloodSwingSharp") or script:FindFirstChild("SwingSharp");

    if v7 == nil then
        return;
    end;

    local v8 = v7:Clone();
    v8.Parent = HumanoidRootPart;
    v8:Play();
    DebrisModule:AddItem(v8, 1);
end;
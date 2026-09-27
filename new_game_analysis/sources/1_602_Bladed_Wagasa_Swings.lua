-- Decompiled with Potassium's decompiler.

local DebrisModule = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));
local WeaponAuras = require(script.Parent:WaitForChild("WeaponAuras"));
local u1 = {
    skipParticles = true,
    skipSound = true,
    anchorParts = {
        ["Cone.013"] = true,
        ["Cone.003"] = true
    }
};

return function(p2, p3, p4) -- Line: 23
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
    local UmbrellaSwing = script:FindFirstChild("UmbrellaSwing");

    if UmbrellaSwing == nil then
        return;
    end;

    local v5 = UmbrellaSwing:Clone();
    v5.Parent = HumanoidRootPart;
    v5:Play();
    DebrisModule:AddItem(v5, 1);
end;
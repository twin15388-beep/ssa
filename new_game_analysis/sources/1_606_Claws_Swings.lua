-- Decompiled with Potassium's decompiler.

local DebrisModule = require(game.ReplicatedStorage:WaitForChild("CAM"):WaitForChild("DebrisModule"));
local WeaponAuras = require(script.Parent:WaitForChild("WeaponAuras"));
local u1 = {
    skipTrails = true,
    skipSound = true,
    anchorParts = {
        Blade = true
    }
};

return function(p2, p3, p4) -- Line: 21
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
    local v5 = script:FindFirstChild("PS2clawSLASH" .. tostring(p3 or 1));

    if v5 == nil then
        v5 = script:FindFirstChild("PS2clawSLASH1") or script:FindFirstChildWhichIsA("Sound");
    end;

    if v5 == nil then
        return;
    end;

    local v6 = v5:Clone();
    v6.Parent = HumanoidRootPart;
    v6:Play();
    DebrisModule:AddItem(v6, 1);
end;
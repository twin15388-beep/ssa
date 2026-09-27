-- Decompiled with Potassium's decompiler.

local CameraInput = require(script.Parent:WaitForChild("CameraInput"));
local CameraUI = require(script.Parent:WaitForChild("CameraUI"));
local CameraUtils = require(script.Parent:WaitForChild("CameraUtils"));
local u1 = false;
local u2 = tick();
local u3 = false;
local u4 = false;
local u5 = false;
CameraUI.setCameraModeToastEnabled(false);

return function(p6: boolean) -- Line: 16
    -- upvalues: CameraInput (copy), u1 (ref), u3 (ref), u2 (ref), CameraUI (copy), u5 (ref), u4 (ref), CameraUtils (copy)
    local TogglePan = CameraInput.getTogglePan();

    if p6 and TogglePan ~= u1 then
        u3 = true;
    end;

    if u1 ~= TogglePan or tick() - u2 > 3 then
        local v7;

        if TogglePan then
            v7 = tick() - u2 < 3;
        else
            v7 = TogglePan;
        end;

        CameraUI.setCameraModeToastOpen(v7);

        if TogglePan then
            u3 = false;
        end;

        u2 = tick();
        u1 = TogglePan;
    end;

    if p6 ~= u5 then
        if p6 then
            u4 = CameraInput.getTogglePan();
            CameraInput.setTogglePan(true);
        elseif not u3 then
            CameraInput.setTogglePan(u4);
        end;
    end;

    if p6 then
        if CameraInput.getTogglePan() then
            CameraUtils.setMouseIconOverride("rbxasset://textures/Cursors/CrossMouseIcon.png");
            CameraUtils.setMouseBehaviorOverride(Enum.MouseBehavior.LockCenter);
            CameraUtils.setRotationTypeOverride(Enum.RotationType.CameraRelative);
        else
            CameraUtils.restoreMouseIcon();
            CameraUtils.restoreMouseBehavior();
            CameraUtils.setRotationTypeOverride(Enum.RotationType.CameraRelative);
        end;
    elseif CameraInput.getTogglePan() then
        CameraUtils.setMouseIconOverride("rbxasset://textures/Cursors/CrossMouseIcon.png");
        CameraUtils.setMouseBehaviorOverride(Enum.MouseBehavior.LockCenter);
        CameraUtils.setRotationTypeOverride(Enum.RotationType.MovementRelative);
    elseif CameraInput.getHoldPan() then
        CameraUtils.restoreMouseIcon();
        CameraUtils.setMouseBehaviorOverride(Enum.MouseBehavior.LockCurrentPosition);
        CameraUtils.setRotationTypeOverride(Enum.RotationType.MovementRelative);
    else
        CameraUtils.restoreMouseIcon();
        CameraUtils.restoreMouseBehavior();
        CameraUtils.restoreRotationType();
    end;

    u5 = p6;
end;
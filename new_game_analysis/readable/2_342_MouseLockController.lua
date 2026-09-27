-- Decompiled with Potassium's decompiler.

local v1 = require(script.Parent.Parent:WaitForChild("CommonUtils")).get("FlagUtil");
local MouseLockSwitchAction = script.Parent.Parent:WaitForChild("InputContexts"):WaitForChild("CameraContext"):WaitForChild("MouseLockSwitchAction");
local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local GameSettings = UserSettings().GameSettings;
local CameraUtils = require(script.Parent:WaitForChild("CameraUtils"));
local UserFlag = v1.getUserFlag("UserFixStuckShiftLock");
local u2 = {};
u2.__index = u2;

function u2.new() -- Line: 33
    -- upvalues: u2 (copy), GameSettings (copy), Players (copy), UserInputService (copy), MouseLockSwitchAction (copy)
    local u3 = setmetatable({}, u2);
    u3.isMouseLocked = false;
    u3.savedMouseCursor = nil;
    u3.enabled = false;
    u3.mouseLockToggledEvent = Instance.new("BindableEvent");
    GameSettings.Changed:Connect(function(p4) -- Line: 43
        -- upvalues: u3 (copy)
        if p4 == "ControlMode" or p4 == "ComputerMovementMode" then
            u3:UpdateMouseLockAvailability();
        end;
    end);
    Players.LocalPlayer:GetPropertyChangedSignal("DevEnableMouseLock"):Connect(function() -- Line: 50
        -- upvalues: u3 (copy)
        u3:UpdateMouseLockAvailability();
    end);
    Players.LocalPlayer:GetPropertyChangedSignal("DevComputerMovementMode"):Connect(function() -- Line: 55
        -- upvalues: u3 (copy)
        u3:UpdateMouseLockAvailability();
    end);
    UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- Line: 59
        -- upvalues: u3 (copy)
        u3:UpdateMouseLockAvailability();
    end);
    u3:UpdateMouseLockAvailability();
    MouseLockSwitchAction.Pressed:Connect(function() -- Line: 65
        -- upvalues: u3 (copy)
        u3:OnMouseLockToggled();
    end);

    return u3;
end;

function u2.GetIsMouseLocked(p5) -- Line: 72
    return p5.isMouseLocked;
end;

function u2.GetBindableToggleEvent(p6) -- Line: 76
    return p6.mouseLockToggledEvent.Event;
end;

function u2.GetMouseLockOffset(p7) -- Line: 80
    return Vector3.new(1.75, 0, 0);
end;

function u2.UpdateMouseLockAvailability(p8) -- Line: 84
    -- upvalues: Players (copy), GameSettings (copy), UserInputService (copy)
    local v9 = UserInputService.PreferredInput == Enum.PreferredInput.KeyboardAndMouse and (Players.LocalPlayer.DevEnableMouseLock and (GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch and GameSettings.ComputerMovementMode ~= Enum.ComputerMovementMode.ClickToMove)) and not (Players.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable);

    if v9 ~= p8.enabled then
        p8:EnableMouseLock(v9);
    end;
end;

function u2.OnMouseLockToggled(p10) -- Line: 98
    -- upvalues: CameraUtils (copy)
    p10.isMouseLocked = not p10.isMouseLocked;

    if p10.isMouseLocked then
        local CursorImage = script:FindFirstChild("CursorImage");

        if CursorImage and (CursorImage:IsA("StringValue") and CursorImage.Value) then
            CameraUtils.setMouseIconOverride(CursorImage.Value);
        else
            if CursorImage then
                CursorImage:Destroy();
            end;

            local StringValue = Instance.new("StringValue");
            assert(StringValue, "");
            StringValue.Name = "CursorImage";
            StringValue.Value = "rbxasset://textures/MouseLockedCursor.png";
            StringValue.Parent = script;
            CameraUtils.setMouseIconOverride("rbxasset://textures/MouseLockedCursor.png");
        end;
    else
        CameraUtils.restoreMouseIcon();
    end;

    p10.mouseLockToggledEvent:Fire();
end;

function u2.IsMouseLocked(p11) -- Line: 123
    return p11.enabled and p11.isMouseLocked;
end;

function u2.EnableMouseLock(p12: table, p13: boolean) -- Line: 127
    -- upvalues: MouseLockSwitchAction (copy), CameraUtils (copy), UserFlag (copy)
    if p13 == p12.enabled then
        return;
    end;

    p12.enabled = p13;

    if p12.enabled then
        MouseLockSwitchAction.Enabled = true;

        return;
    end;

    CameraUtils.restoreMouseIcon();
    MouseLockSwitchAction.Enabled = false;

    if UserFlag then
        if p12.isMouseLocked then
            p12.isMouseLocked = false;
            p12.mouseLockToggledEvent:Fire();
        end;
    else
        if p12.isMouseLocked then
            p12.mouseLockToggledEvent:Fire();
        end;

        p12.isMouseLocked = false;
    end;
end;

return u2;
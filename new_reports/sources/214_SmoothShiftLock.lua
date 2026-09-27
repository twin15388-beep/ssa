-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local Players = game:GetService("Players");
local Workspace = game:GetService("Workspace");
local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
game:GetService("TweenService");
local Maid = require(script.Utils:WaitForChild("Maid"));
local Spring = require(script.Utils:WaitForChild("Spring"));
local LocalPlayer = Players.LocalPlayer;
local ToggleShiftLock = script:WaitForChild("ToggleShiftLock");
local EditConfig = script:WaitForChild("EditConfig");
local u2 = {
    CHARACTER_SMOOTH_ROTATION = false,
    MANUALLY_TOGGLEABLE = true,
    CHARACTER_ROTATION_SPEED = 3,
    TRANSITION_SPRING_DAMPER = 0.7,
    CAMERA_TRANSITION_IN_SPEED = 10,
    CAMERA_TRANSITION_OUT_SPEED = 14,
    LOCKED_CAMERA_OFFSET = Vector3.new(1.75, 1.25, 0),
    LOCKED_MOUSE_ICON = "http://www.roblox.com/asset/?id=11783958279",
    SHIFT_LOCK_KEYBINDS = { Enum.KeyCode.LeftControl, Enum.KeyCode.RightControl }
};
local u3 = false;

local function isCharacterMovementLocked(p4) -- Line: 68
    return not p4 and true or ((p4:GetAttribute("ActionLocked") == true or (p4:GetAttribute("HypnosisControlLocked") == true or (p4:GetAttribute("Ragdolled") == true or (p4:GetAttribute("Hibernating") == true or p4:GetAttribute("BreakNeckRecovering") == true)))) and true or p4:GetAttribute("BeingCarried") == true);
end;

local u5 = Maid.new();

function u1.Init(u6) -- Line: 87
    -- upvalues: Maid (copy), LocalPlayer (copy)
    Maid.new():GiveTask(LocalPlayer.CharacterAdded:Connect(function() -- Line: 90
        -- upvalues: u6 (copy)
        u6:CharacterAdded();
    end));

    if LocalPlayer.Character then
        task.defer(function() -- Line: 97
            -- upvalues: u6 (copy)
            u6:CharacterAdded();
        end);
    end;
end;

function u1.CharacterAdded(p7) -- Line: 104
    -- upvalues: u1 (copy), LocalPlayer (copy), Workspace (copy), Maid (copy), Spring (copy), u2 (copy), UserInputService (copy), isCharacterMovementLocked (copy), u3 (ref), RunService (copy), ToggleShiftLock (copy), EditConfig (copy)
    local u8 = setmetatable({}, u1);
    u8.Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait();
    u8.RootPart = u8.Character:WaitForChild("HumanoidRootPart");
    u8.Humanoid = u8.Character:WaitForChild("Humanoid");
    u8.Head = u8.Character:WaitForChild("Head");
    u8.Camera = Workspace.CurrentCamera;
    u8.connectionsMaid = Maid.new();
    u8.camOffsetSpring = Spring.new(Vector3.new(0, 0, 0));
    u8.camOffsetSpring.Damper = u2.TRANSITION_SPRING_DAMPER;
    u8.connectionsMaid:GiveTask(UserInputService.InputBegan:Connect(function(p9, p10) -- Line: 119
        -- upvalues: u2 (ref), u8 (copy), isCharacterMovementLocked (ref), u3 (ref)
        if not u2.MANUALLY_TOGGLEABLE then
            return;
        end;

        if p10 and (p9.KeyCode ~= Enum.KeyCode.LeftControl and p9.KeyCode ~= Enum.KeyCode.RightControl) then
            return;
        end;

        for _, v in pairs(u2.SHIFT_LOCK_KEYBINDS) do
            if p9.KeyCode == v and (u8.Humanoid and u8.Humanoid.Health ~= 0) then
                if isCharacterMovementLocked(u8.Character) then
                    if u3 then
                        u8:ToggleShiftLock(false);
                    end;

                    return;
                end;

                u8:ToggleShiftLock(not u3);
            end;
        end;
    end));

    for _, v in ipairs({ "ActionLocked", "HypnosisControlLocked", "Ragdolled", "Hibernating", "BreakNeckRecovering", "BeingCarried" }) do
        u8.connectionsMaid:GiveTask(u8.Character:GetAttributeChangedSignal(v):Connect(function() -- Line: 145
            -- upvalues: u3 (ref), isCharacterMovementLocked (ref), u8 (copy)
            if u3 and isCharacterMovementLocked(u8.Character) then
                u8:ToggleShiftLock(false);
            end;
        end));
    end;

    u8.connectionsMaid:GiveTask(RunService.RenderStepped:Connect(function() -- Line: 153
        -- upvalues: u3 (ref), isCharacterMovementLocked (ref), u8 (copy), UserInputService (ref)
        if u3 and isCharacterMovementLocked(u8.Character) then
            u8:ToggleShiftLock(false);
        end;

        if u8.Head.LocalTransparencyModifier > 0.6 then
            return;
        end;

        if (u8.Head.Position - u8.Camera.CoordinateFrame.p).magnitude > 1 then
            u8.Camera.CFrame = u8.Camera.CFrame * CFrame.new(u8.camOffsetSpring.Position);

            if u3 and UserInputService.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
                u8:SetMouseState(u3);
            end;
        end;
    end));
    u8.connectionsMaid:GiveTask(ToggleShiftLock.Event:Connect(function(p11: boolean) -- Line: 173
        -- upvalues: u8 (copy), isCharacterMovementLocked (ref)
        if u8.Humanoid and u8.Humanoid.Health ~= 0 then
            if p11 and isCharacterMovementLocked(u8.Character) then
                u8:ToggleShiftLock(false);

                return;
            end;

            u8:ToggleShiftLock(p11);
        end;
    end));
    u8.connectionsMaid:GiveTask(EditConfig.Event:Connect(function(p12, p13) -- Line: 183
        -- upvalues: u2 (ref)
        if u2[p12] ~= nil then
            u2[p12] = p13;
        end;
    end));
    u8.connectionsMaid:GiveTask(u8.Humanoid.Died:Connect(function() -- Line: 190
        -- upvalues: u8 (copy)
        u8:CharacterDiedOrRemoved();
    end));
    u8.connectionsMaid:GiveTask(LocalPlayer.CharacterRemoving:Connect(function() -- Line: 196
        -- upvalues: u8 (copy)
        u8:CharacterDiedOrRemoved();
    end));

    return u8;
end;

function u1.CharacterDiedOrRemoved(p14) -- Line: 205
    -- upvalues: u5 (copy)
    p14:ToggleShiftLock(false);

    if p14.connectionsMaid ~= nil then
        p14.connectionsMaid:Destroy();
    end;

    u5:DoCleaning();
end;

function u1.IsEnabled(p15) -- Line: 216
    -- upvalues: u3 (ref)
    return u3;
end;

function u1.SetMouseState(p16: table, p17: boolean) -- Line: 221
    -- upvalues: UserInputService (copy)
    UserInputService.MouseBehavior = p17 and Enum.MouseBehavior.LockCenter or Enum.MouseBehavior.Default;
end;

function u1.SetMouseIcon(p18: table, p19: boolean) -- Line: 226
    -- upvalues: UserInputService (copy), u2 (copy)
    UserInputService.MouseIcon = p19 and u2.LOCKED_MOUSE_ICON or "";
end;

function u1.TransitionLockOffset(p20: table, p21: boolean) -- Line: 231
    -- upvalues: u2 (copy)
    if p21 then
        p20.camOffsetSpring.Speed = u2.CAMERA_TRANSITION_IN_SPEED;
        p20.camOffsetSpring.Target = u2.LOCKED_CAMERA_OFFSET;

        return;
    end;

    p20.camOffsetSpring.Speed = u2.CAMERA_TRANSITION_OUT_SPEED;
    p20.camOffsetSpring.Target = Vector3.new(0, 0, 0);
end;

function u1.ToggleShiftLock(u22: table, p23: boolean) -- Line: 242
    -- upvalues: u3 (ref), u5 (copy), RunService (copy), isCharacterMovementLocked (copy), u2 (copy)
    local v24 = typeof(p23) == "boolean";
    assert(v24, "Enable value is not a boolean.");
    u3 = p23;
    u22:SetMouseState(u3);
    u22:SetMouseIcon(u3);
    u22:TransitionLockOffset(u3);

    if u3 then
        u5:GiveTask(RunService.RenderStepped:Connect(function(p25) -- Line: 252
            -- upvalues: u22 (copy), u3 (ref), isCharacterMovementLocked (ref), u2 (ref), u5 (ref)
            if u22.Humanoid and u22.RootPart then
                u22.Humanoid.AutoRotate = not u3;
            end;

            if u3 and not (isCharacterMovementLocked(u22.Character) or u22.Character:GetAttribute("Stunned")) then
                if u22.Humanoid.Sit or not u2.CHARACTER_SMOOTH_ROTATION then
                    if not u22.Humanoid.Sit then
                        local _, v26, _ = u22.Camera.CFrame:ToOrientation();
                        u22.RootPart.CFrame = CFrame.new(u22.RootPart.Position) * CFrame.Angles(0, v26, 0);
                    end;
                else
                    local _, v27, _ = u22.Camera.CFrame:ToOrientation();
                    u22.RootPart.CFrame = u22.RootPart.CFrame:Lerp(CFrame.new(u22.RootPart.Position) * CFrame.Angles(0, v27, 0), p25 * 5 * u2.CHARACTER_ROTATION_SPEED);
                end;
            end;

            if not u3 then
                u5:Destroy();
            end;
        end));
    end;

    return u22;
end;

return u1;
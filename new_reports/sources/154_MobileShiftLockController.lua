-- Decompiled with Potassium's decompiler.

local TeamGuiLayout = require(game:GetService("ReplicatedStorage"):WaitForChild("TeamGuiLayout"));
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ContextActionService = game:GetService("ContextActionService");
local UserInputService = game:GetService("UserInputService");
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local v1 = ReplicatedStorage:WaitForChild("Funções");
local AltShiftLock = require(v1:WaitForChild("AltShiftLock"));
local Color3_fromRGB_ret = Color3.fromRGB(100, 255, 130);
local Color3_fromRGB_ret2 = Color3.fromRGB(255, 255, 255);
local u2 = nil;
local u3 = nil;

local function updateVisual() -- Line: 19
    -- upvalues: u2 (ref), AltShiftLock (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy)
    if not (u2 and u2.Parent) then
        return;
    end;

    local v4 = AltShiftLock.IsLocked();
    u2.ImageColor3 = v4 and Color3_fromRGB_ret or Color3_fromRGB_ret2;
    u2:SetAttribute("ShiftLockEnabled", v4);
end;

local function bindButton() -- Line: 29
    -- upvalues: PlayerGui (copy), TeamGuiLayout (copy), u2 (ref), AltShiftLock (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy), u3 (ref)
    local VampireMOBILE = PlayerGui:WaitForChild("TEAMS"):WaitForChild("VampireMOBILE");
    local Menu = TeamGuiLayout.GetMenu(VampireMOBILE);
    local v5 = Menu:FindFirstChild("SHIFTLOCK", true) or Menu:FindFirstChild("ShiftLock", true);

    while not v5 do
        Menu.DescendantAdded:Wait();
        v5 = Menu:FindFirstChild("SHIFTLOCK", true) or Menu:FindFirstChild("ShiftLock", true);
    end;

    if u2 == v5 then
        if u2 then
            if not u2.Parent then
                return;
            end;

            local v6 = AltShiftLock.IsLocked();
            u2.ImageColor3 = v6 and Color3_fromRGB_ret or Color3_fromRGB_ret2;
            u2:SetAttribute("ShiftLockEnabled", v6);
        end;

        return;
    end;

    if u3 then
        u3:Disconnect();
    end;

    u2 = v5;
    u3 = u2.Activated:Connect(function() -- Line: 47
        -- upvalues: u2 (ref), AltShiftLock (ref), Color3_fromRGB_ret (ref), Color3_fromRGB_ret2 (ref)
        local Parent = u2.Parent;

        if Parent and Parent:GetAttribute("IsDragging") == true then
            return;
        end;

        AltShiftLock.Toggle();

        if u2 then
            if not u2.Parent then
                return;
            end;

            local v7 = AltShiftLock.IsLocked();
            u2.ImageColor3 = v7 and Color3_fromRGB_ret or Color3_fromRGB_ret2;
            u2:SetAttribute("ShiftLockEnabled", v7);
        end;
    end);

    if u2 then
        if not u2.Parent then
            return;
        end;

        local v8 = AltShiftLock.IsLocked();
        u2.ImageColor3 = v8 and Color3_fromRGB_ret or Color3_fromRGB_ret2;
        u2:SetAttribute("ShiftLockEnabled", v8);
    end;
end;

AltShiftLock.Start();
ContextActionService:BindActionAtPriority("ConsoleShiftLockToggle", function(p9, p10) -- Line: 62, Name: consoleShiftLockAction
    -- upvalues: UserInputService (copy), AltShiftLock (copy), u2 (ref), Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy)
    if p10 ~= Enum.UserInputState.Begin then
        return Enum.ContextActionResult.Sink;
    end;

    if not UserInputService.GamepadEnabled then
        return Enum.ContextActionResult.Pass;
    end;

    AltShiftLock.Toggle();

    if u2 and u2.Parent then
        local v11 = AltShiftLock.IsLocked();
        u2.ImageColor3 = v11 and Color3_fromRGB_ret or Color3_fromRGB_ret2;
        u2:SetAttribute("ShiftLockEnabled", v11);
    end;

    return Enum.ContextActionResult.Sink;
end, false, 2500, Enum.KeyCode.ButtonR3);
bindButton();
LocalPlayer:GetAttributeChangedSignal("AltShiftLockEnabled"):Connect(updateVisual);
PlayerGui.ChildAdded:Connect(function(p12) -- Line: 85
    -- upvalues: bindButton (copy)
    if p12.Name == "TEAMS" then
        task.defer(bindButton);
    end;
end);
LocalPlayer.CharacterAdded:Connect(function() -- Line: 90
    -- upvalues: bindButton (copy)
    task.defer(bindButton);
end);
-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
game:GetService("GuiService");
local LocalPlayer = Players.LocalPlayer;
local script_Parent = script.Parent;
local DrinkPotionRemote = ReplicatedStorage:WaitForChild("Funções"):WaitForChild("Eventos"):WaitForChild("DrinkPotionRemote");
local u1 = false;
local u2 = false;
local u3 = nil;

local function tryDrink() -- Line: 17
    -- upvalues: u1 (ref), u2 (ref), LocalPlayer (copy), script_Parent (copy), DrinkPotionRemote (copy)
    if u1 or not u2 then
        return;
    end;

    local Character = LocalPlayer.Character;

    if not Character or script_Parent.Parent ~= Character then
        return;
    end;

    local v4 = Character:FindFirstChildOfClass("Humanoid");

    if not v4 or v4.Health <= 0 then
        return;
    end;

    if Character:GetAttribute("ActionLocked") and not Character:GetAttribute("DrinkingPotion") then
        return;
    end;

    u1 = true;
    DrinkPotionRemote:FireServer(script_Parent);
    task.delay(1.5, function() -- Line: 29
        -- upvalues: u1 (ref)
        u1 = false;
    end);
end;

script_Parent.Equipped:Connect(function() -- Line: 34
    -- upvalues: u2 (ref), script_Parent (copy), u3 (ref)
    u2 = true;
    local Parent = script_Parent.Parent;

    if Parent then
        Parent = Parent:FindFirstChildOfClass("Humanoid");
    end;

    if Parent then
        Parent = Parent:FindFirstChildOfClass("Animator");
    end;

    local EquipAnimation = script_Parent:FindFirstChild("EquipAnimation");

    if Parent and EquipAnimation then
        local success, result = pcall(function() -- Line: 41
            -- upvalues: Parent (copy), EquipAnimation (copy)
            return Parent:LoadAnimation(EquipAnimation);
        end);

        if success and result then
            u3 = result;
            result.Priority = Enum.AnimationPriority.Action4;
            result.Looped = false;
            result:Play(0.1);
        end;
    end;
end);
script_Parent.Unequipped:Connect(function() -- Line: 53
    -- upvalues: u2 (ref), u3 (ref)
    u2 = false;

    if u3 then
        pcall(function() -- Line: 56
            -- upvalues: u3 (ref)
            u3:Stop(0.1);
            u3:Destroy();
        end);
        u3 = nil;
    end;
end);
script_Parent.Activated:Connect(function() -- Line: 64
    -- upvalues: tryDrink (copy)
    tryDrink();
end);
UserInputService.InputBegan:Connect(function(p5, p6) -- Line: 68
    -- upvalues: u2 (ref), tryDrink (copy)
    if not u2 or p6 then
        return;
    end;

    if p5.UserInputType == Enum.UserInputType.MouseButton1 or (p5.UserInputType == Enum.UserInputType.Touch or p5.KeyCode == Enum.KeyCode.ButtonR2) then
        tryDrink();
    end;
end);
-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local script_Parent = script.Parent;
local RingActivate = ReplicatedStorage:WaitForChild("Funções"):WaitForChild("Eventos"):WaitForChild("RingActivate");
local u1 = 0;
local u2 = script_Parent:GetAttribute("RingTransition") ~= nil;

local function unequipLocallyAfterTransition() -- Line: 10
    -- upvalues: script_Parent (copy)
    local Parent = script_Parent.Parent;

    if Parent then
        Parent = Parent:FindFirstChildOfClass("Humanoid");
    end;

    if Parent then
        Parent:UnequipTools();
    end;
end;

script_Parent.Equipped:Connect(function() -- Line: 20
    -- upvalues: u1 (ref)
    u1 = u1 + 1;
end);
script_Parent.Activated:Connect(function() -- Line: 24
    -- upvalues: script_Parent (copy), RingActivate (copy)
    if not script_Parent.Enabled then
        return;
    end;

    local Parent = script_Parent.Parent;

    if not (Parent and Parent:FindFirstChildOfClass("Humanoid")) then
        return;
    end;

    RingActivate:FireServer(script_Parent);
end);
script_Parent:GetAttributeChangedSignal("RingTransition"):Connect(function() -- Line: 35
    -- upvalues: script_Parent (copy), u2 (ref), unequipLocallyAfterTransition (copy)
    if script_Parent:GetAttribute("RingTransition") == nil then
        if u2 then
            u2 = false;
            task.defer(unequipLocallyAfterTransition);
        end;

        return;
    end;

    u2 = true;
end);
script_Parent.Unequipped:Connect(function() -- Line: 45
    -- upvalues: u1 (ref)
    u1 = u1 + 1;
end);
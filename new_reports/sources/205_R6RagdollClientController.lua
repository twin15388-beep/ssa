-- Decompiled with Potassium's decompiler.

local script_Parent = script.Parent;
local Humanoid = script_Parent:WaitForChild("Humanoid");
local u1 = {
    Neck = true,
    ["Left Shoulder"] = true,
    ["Right Shoulder"] = true,
    ["Left Hip"] = true,
    ["Right Hip"] = true
};

local function restoreR6Motors() -- Line: 17
    -- upvalues: script_Parent (copy), u1 (copy)
    for _, descendant in script_Parent:GetDescendants() do
        if descendant:IsA("Motor6D") and u1[descendant.Name] then
            descendant.Enabled = true;
        end;
    end;
end;

local u2 = 0;

local function applyNormalState() -- Line: 27
    -- upvalues: restoreR6Motors (copy), Humanoid (copy)
    restoreR6Motors();
    Humanoid.PlatformStand = false;
    Humanoid.AutoRotate = true;
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true);
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true);

    if Humanoid.Health > 0 then
        Humanoid.Jump = false;
        Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp);
    end;
end;

local function updateRagdollState() -- Line: 39
    -- upvalues: u2 (ref), script_Parent (copy), Humanoid (copy), applyNormalState (copy)
    u2 = u2 + 1;
    local u3 = u2;

    if script_Parent:GetAttribute("Ragdolled") == true then
        Humanoid.AutoRotate = false;
        Humanoid.PlatformStand = true;

        if Humanoid.Health > 0 then
            Humanoid:ChangeState(Enum.HumanoidStateType.Physics);
        end;
    elseif Humanoid.Health > 0 then
        applyNormalState();
        task.spawn(function() -- Line: 52
            -- upvalues: u2 (ref), u3 (copy), script_Parent (ref), Humanoid (ref), applyNormalState (ref)
            local v4 = os.clock() + 1.5;

            while u2 == u3 and (script_Parent.Parent and (script_Parent:GetAttribute("Ragdolled") ~= true and Humanoid.Health > 0)) do
                applyNormalState();
                task.wait(0.1);

                if v4 <= os.clock() then
                    return;
                end;
            end;
        end);
    end;
end;

script_Parent:GetAttributeChangedSignal("Ragdolled"):Connect(updateRagdollState);
updateRagdollState();
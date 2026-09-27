-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
local LocalPlayer = Players.LocalPlayer;
local u1 = {};
local u2 = false;
local u3 = false;
local u4 = nil;
local u5 = nil;

local function getCharacterParts() -- Line: 15
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;
    local v6;

    if Character then
        v6 = Character:FindFirstChildOfClass("Humanoid");
    else
        v6 = Character;
    end;

    local v7;

    if Character then
        v7 = Character:FindFirstChild("HumanoidRootPart");
    else
        v7 = Character;
    end;

    return Character, v6, v7;
end;

local function canRotate(p8, p9, p10) -- Line: 22
    local v11;

    if p8 == nil or (p9 == nil or (p10 == nil or p9.Health <= 0)) then
        v11 = false;
    else
        v11 = not p9.Sit;

        if v11 then
            if p8:GetAttribute("ActionLocked") == true or p8:GetAttribute("Ragdolled") == true then
                v11 = false;
            else
                v11 = p8:GetAttribute("Hibernating") ~= true;
            end;
        end;
    end;

    return v11;
end;

local function applyState() -- Line: 33
    -- upvalues: LocalPlayer (copy), u3 (ref)
    local Character = LocalPlayer.Character;
    local v12;

    if Character then
        v12 = Character:FindFirstChildOfClass("Humanoid");
    else
        v12 = Character;
    end;

    if Character then
        Character:FindFirstChild("HumanoidRootPart");
    end;

    if v12 then
        v12.CameraOffset = u3 and Vector3.new(1.65, 0.35, 0) or Vector3.new(0, 0, 0);

        if not u3 and (Character and (Character:GetAttribute("ActionLocked") ~= true and Character:GetAttribute("Ragdolled") ~= true)) then
            v12.AutoRotate = true;
        end;
    end;

    LocalPlayer:SetAttribute("AltShiftLockEnabled", u3);
end;

function u1.IsLocked() -- Line: 47
    -- upvalues: u3 (ref)
    return u3;
end;

function u1.SetLocked(p13) -- Line: 51
    -- upvalues: u3 (ref), applyState (copy)
    u3 = p13 == true;
    applyState();

    return u3;
end;

function u1.Toggle() -- Line: 57
    -- upvalues: u1 (copy), u3 (ref)
    return u1.SetLocked(not u3);
end;

function u1.Start() -- Line: 61
    -- upvalues: u2 (ref), applyState (copy), LocalPlayer (copy), u3 (ref), u5 (ref), u4 (ref), RunService (copy), canRotate (copy), UserInputService (copy)
    if u2 then
        applyState();

        return;
    end;

    u2 = true;
    LocalPlayer:SetAttribute("AltShiftLockEnabled", u3);
    u5 = LocalPlayer.CharacterAdded:Connect(function() -- Line: 69
        -- upvalues: applyState (ref)
        task.defer(applyState);
    end);
    u4 = RunService.RenderStepped:Connect(function() -- Line: 73
        -- upvalues: u3 (ref), LocalPlayer (ref), canRotate (ref), UserInputService (ref)
        if not u3 then
            return;
        end;

        local Character = LocalPlayer.Character;
        local v14;

        if Character then
            v14 = Character:FindFirstChildOfClass("Humanoid");
        else
            v14 = Character;
        end;

        local v15;

        if Character then
            v15 = Character:FindFirstChild("HumanoidRootPart");
        else
            v15 = Character;
        end;

        if not canRotate(Character, v14, v15) then
            return;
        end;

        local workspace_CurrentCamera = workspace.CurrentCamera;

        if not workspace_CurrentCamera then
            return;
        end;

        v14.AutoRotate = false;
        local LookVector = workspace_CurrentCamera.CFrame.LookVector;
        local Vector3_new_ret = Vector3.new(LookVector.X, 0, LookVector.Z);

        if Vector3_new_ret.Magnitude > 0.001 then
            v15.CFrame = CFrame.lookAt(v15.Position, v15.Position + Vector3_new_ret.Unit);
        end;

        if not UserInputService.TouchEnabled then
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
        end;
    end);
    applyState();
end;

return u1;
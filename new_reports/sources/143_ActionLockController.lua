-- Decompiled with Potassium's decompiler.

local ContextActionService = game:GetService("ContextActionService");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local u1 = false;
local u2 = nil;
task.spawn(function() -- Line: 12
    -- upvalues: LocalPlayer (copy), u2 (ref), u1 (ref)
    local PlayerModule = LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule", 10);

    if not PlayerModule then
        return;
    end;

    local success, result = pcall(function() -- Line: 18
        -- upvalues: PlayerModule (copy)
        return require(PlayerModule):GetControls();
    end);

    if success then
        u2 = result;

        if u1 then
            u2:Disable();
        end;
    end;
end);
local u3 = {};

local function sink() -- Line: 30
    return Enum.ContextActionResult.Sink;
end;

local function setLocked(p4) -- Line: 34
    -- upvalues: u1 (ref), u2 (ref), ContextActionService (copy), sink (copy)
    if u1 == p4 then
        return;
    end;

    u1 = p4;

    if u1 then
        if u2 then
            u2:Disable();
        end;

        ContextActionService:BindActionAtPriority("BloodDrinkActionLock", sink, false, 10000, Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.KeyCode.Space, Enum.PlayerActions.CharacterForward, Enum.PlayerActions.CharacterBackward, Enum.PlayerActions.CharacterLeft, Enum.PlayerActions.CharacterRight, Enum.PlayerActions.CharacterJump);

        return;
    end;

    ContextActionService:UnbindAction("BloodDrinkActionLock");

    if u2 then
        u2:Enable();
    end;
end;

local function setupCharacter(u5) -- Line: 68
    -- upvalues: u3 (copy), LocalPlayer (copy), setLocked (copy)
    for _, v in u3 do
        v:Disconnect();
    end;

    table.clear(u3);

    local function refresh() -- Line: 74
        -- upvalues: u5 (copy), LocalPlayer (ref), setLocked (ref)
        local v6 = u5:GetAttribute("HypnosisPossessing") == true;
        local v7 = LocalPlayer:GetAttribute("SpiritWorldActive") ~= true and ((u5:GetAttribute("ActionLocked") == true or (u5:GetAttribute("ToolEquipLocked") == true or u5:GetAttribute("HypnosisControlLocked") == true)) and true or (u5:GetAttribute("Ragdolled") == true and not v6 or ((u5:GetAttribute("Hibernating") == true or u5:GetAttribute("BreakNeckRecovering") == true) and true or u5:GetAttribute("BeingCarried") == true)));
        setLocked(v7);
    end;

    for _, v in ipairs({ "ActionLocked", "ToolEquipLocked", "HypnosisControlLocked", "HypnosisPossessing", "Ragdolled", "Hibernating", "BreakNeckRecovering", "BeingCarried" }) do
        local AttributeChangedSignal = u5:GetAttributeChangedSignal(v);
        table.insert(u3, AttributeChangedSignal:Connect(refresh));
    end;

    local AttributeChangedSignal = LocalPlayer:GetAttributeChangedSignal("SpiritWorldActive");
    table.insert(u3, AttributeChangedSignal:Connect(refresh));
    table.insert(u3, u5.Destroying:Connect(function() -- Line: 102
        -- upvalues: setLocked (ref)
        setLocked(false);
    end));
    refresh();
end;

LocalPlayer.CharacterAdded:Connect(setupCharacter);

if LocalPlayer.Character then
    setupCharacter(LocalPlayer.Character);
end;
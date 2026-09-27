-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent:WaitForChild("CommonUtils")).get("FlagUtil");
local u1 = {};
u1.__index = u1;

function u1.new() -- Line: 22
    -- upvalues: u1 (copy)
    local v2 = setmetatable({}, u1);
    v2.enabled = true;

    return v2;
end;

function u1.initializeActions(u3, u4) -- Line: 30
    u3.connectionUtil:trackConnection("SERVER_AUTHORITY_CHANGED", u3.eventBus:subscribe("SERVER_AUTHORITY_CHANGED"):Connect(function() -- Line: 32
        -- upvalues: u4 (copy)
        u4.actions = {};
    end));

    if u4.actions.MoveAction and u4.actions.JumpAction then
        return;
    end;

    if not u4.player then
        return;
    end;

    pcall(function() -- Line: 41
        -- upvalues: u3 (copy), u4 (copy)
        local InputContexts = script.Parent.Parent.InputContexts;

        if u3.isServerAuthority then
            InputContexts = u4.player.InputContexts;
        end;

        local CharacterContext = InputContexts.CharacterContext;
        u4.actions = {
            MoveAction = CharacterContext.MoveAction,
            JumpAction = CharacterContext.JumpAction
        };
        u3.eventBus:publish("ACTIONS_RELOADED");
    end);
end;

function u1.update(p5) -- Line: 57
    p5.moveVector = p5.actions.MoveAction:GetState();
    p5.isJumping = p5.actions.JumpAction:GetState();
end;

function u1.Enable(p6: table, p7: boolean) -- Line: 62
end;

return u1;
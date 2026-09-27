-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local u1 = {
    _connectionUtil = require(script.Parent).get("ConnectionUtil").new(),
    _boundEvents = {},

    getLocalPlayer = function() -- Line: 55, Name: getLocalPlayer
        -- upvalues: Players (copy)
        return Players.LocalPlayer;
    end
};

function u1.onLocalPlayer(p2) -- Line: 59
    -- upvalues: u1 (copy), Players (copy)
    local LocalPlayer = u1.getLocalPlayer();

    if LocalPlayer then
        p2(LocalPlayer);
    end;

    u1._connectionUtil:trackConnection("LOCAL_PLAYER", Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function() -- Line: 68
        -- upvalues: u1 (ref)
        local LocalPlayer2 = u1.getLocalPlayer();
        assert(LocalPlayer2);
        u1._getOrCreateBoundEvent("LOCAL_PLAYER"):Fire(LocalPlayer2);
    end));

    return u1._getOrCreateBoundEvent("LOCAL_PLAYER").Event:Connect(p2);
end;

function u1.getCharacter() -- Line: 79
    -- upvalues: u1 (copy)
    local LocalPlayer = u1.getLocalPlayer();

    if LocalPlayer then
        return LocalPlayer.Character;
    end;

    return nil;
end;

function u1.onCharacter(u3) -- Line: 87
    -- upvalues: u1 (copy)
    u1._connectionUtil:trackConnection("ON_LOCAL_PLAYER", u1.onLocalPlayer(function(p4) -- Line: 91
        -- upvalues: u1 (ref), u3 (copy)
        local Character = u1.getCharacter();

        if Character then
            u3(Character);
        end;

        u1._connectionUtil:trackConnection("CHARACTER_ADDED", p4.CharacterAdded:Connect(function(p5) -- Line: 100
            -- upvalues: u1 (ref)
            assert(p5);
            u1._getOrCreateBoundEvent("CHARACTER_ADDED"):Fire(p5);
        end));
    end));

    return u1._getOrCreateBoundEvent("CHARACTER_ADDED").Event:Connect(u3);
end;

function u1.getChild(p6: string, p7: string) -- Line: 112
    -- upvalues: u1 (copy)
    local Character = u1.getCharacter();

    if not Character then
        return nil;
    end;

    local v8 = Character:FindFirstChild(p6);

    if v8 and v8:IsA(p7) then
        return v8;
    end;

    return nil;
end;

function u1.onChild(u9: string, u10: string, u11: any) -- Line: 124
    -- upvalues: u1 (copy)
    u1._connectionUtil:trackConnection("ON_CHARACTER", u1.onCharacter(function(p12) -- Line: 128
        -- upvalues: u1 (ref), u9 (copy), u10 (copy), u11 (copy)
        local Child = u1.getChild(u9, u10);

        if Child then
            u11(Child);
        end;

        u1._connectionUtil:trackConnection("CHARACTER_CHILD_ADDED", p12.ChildAdded:Connect(function(p13) -- Line: 137
            -- upvalues: u9 (ref), u10 (ref), u1 (ref)
            if p13.Name == u9 and p13:IsA(u10) then
                u1._getOrCreateBoundEvent("CHARACTER_CHILD_ADDED" .. u9 .. u10):Fire(p13);
            end;
        end));
    end));

    return u1._getOrCreateBoundEvent("CHARACTER_CHILD_ADDED" .. u9 .. u10).Event:Connect(u11);
end;

function u1._getOrCreateBoundEvent(p14: string) -- Line: 151
    -- upvalues: u1 (copy)
    if not u1._boundEvents[p14] then
        u1._boundEvents[p14] = Instance.new("BindableEvent");
    end;

    return u1._boundEvents[p14];
end;

return u1;
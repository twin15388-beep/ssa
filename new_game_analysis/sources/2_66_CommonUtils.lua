-- Decompiled with Potassium's decompiler.

local u1 = {
    _mocks = {}
};

function u1.mock(p2, p3) -- Line: 16
    -- upvalues: u1 (copy)
    u1._mocks[p2] = p3;
end;

function u1.get(p4: string) -- Line: 20
    -- upvalues: u1 (copy)
    if u1._mocks[p4] then
        return require(u1._mocks[p4]);
    end;

    if script:FindFirstChild(p4) then
        return require(script:FindFirstChild(p4));
    end;

    assert(false, "Util does not exist: " .. p4);
end;

return u1;
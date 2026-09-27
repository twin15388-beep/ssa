-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
setmetatable(u1, {
    __call = function(p2, ...) -- Line: 10, Name: __call
        -- upvalues: u1 (copy)
        return u1.new(...);
    end
});

function u1.new() -- Line: 15
    -- upvalues: u1 (copy)
    return setmetatable({}, u1);
end;

function u1.CharacterAdded(p3: table, p4: userdata, p5: userdata) -- Line: 21
end;

function u1.CharacterRemoving(p6: table, p7: userdata, p8: userdata) -- Line: 25
end;

function u1.OnCameraSubjectChanged(p9, p10) -- Line: 28
end;

function u1.GetOcclusionMode(p11) -- Line: 32
    warn("BaseOcclusion GetOcclusionMode must be overridden by derived classes");

    return nil;
end;

function u1.Enable(p12: table, p13: boolean) -- Line: 38
    warn("BaseOcclusion Enable must be overridden by derived classes");
end;

function u1.Update(p14: table, p15: number, p16, p17) -- Line: 42
    warn("BaseOcclusion Update must be overridden by derived classes");

    return p16, p17;
end;

return u1;
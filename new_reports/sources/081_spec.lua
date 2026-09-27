-- Decompiled with Potassium's decompiler.

local DistanceConstraint = require(script.Parent:WaitForChild("DistanceConstraint"));

local function CreateBone(p1, p2, p3) -- Line: 3
    return {
        Position = p1,
        FreeLength = p2,
        ParentIndex = p3
    };
end;

return function() -- Line: 11
    -- upvalues: DistanceConstraint (copy)
    local u4 = {
        Bones = { {
                Position = Vector3.new(0, 0, 0),
                FreeLength = 3,
                ParentIndex = 0
            }, {
                Position = Vector3.new(0, 1, 0),
                FreeLength = 3,
                ParentIndex = 1
            } }
    };
    describe("Distance Constraint", function() -- Line: 19
        -- upvalues: u4 (copy), DistanceConstraint (ref)
        local u5 = u4.Bones[2];

        local function Callback() -- Line: 22
            -- upvalues: DistanceConstraint (ref), u5 (copy), u4 (ref)
            local v6 = DistanceConstraint(u5, u5.Position, u4);
            expect(v6.Magnitude).to.equal(u5.FreeLength);
            u5.Position = v6;
        end;

        for i = 1, 10 do
            it(`Should limit to {u5.FreeLength} studs #{i}`, Callback);
            u5.FreeLength = math.random(1, 20);
            local _ = i;
        end;
    end);
end;
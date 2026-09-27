-- Decompiled with Potassium's decompiler.

local RopeConstraint = require(script.Parent:WaitForChild("RopeConstraint"));

local function CreateBone(p1, p2, p3) -- Line: 3
    return {
        Position = p1,
        FreeLength = p2,
        ParentIndex = p3
    };
end;

return function() -- Line: 11
    -- upvalues: RopeConstraint (copy)
    local u4 = {
        Bones = { {
                Position = Vector3.new(0, 0, 0),
                FreeLength = 3,
                ParentIndex = 0
            }, {
                Position = Vector3.new(0, 10, 0),
                FreeLength = 3,
                ParentIndex = 1
            } }
    };
    describe("Rope Constraint", function() -- Line: 19
        -- upvalues: u4 (copy), RopeConstraint (ref)
        local u5 = u4.Bones[2];
        local u6 = 0;
        local u7 = nil;

        local function LimitCallback() -- Line: 25
            -- upvalues: RopeConstraint (ref), u5 (copy), u4 (ref), u7 (ref)
            local v8 = RopeConstraint(u5, u5.Position, u4);
            expect(v8.Magnitude).to.equal(u5.FreeLength);
            u5.FreeLength = math.random(1, 20);
            u7();
        end;

        local function SameCallback() -- Line: 35
            -- upvalues: RopeConstraint (ref), u5 (copy), u4 (ref), u7 (ref)
            local v9 = RopeConstraint(u5, u5.Position, u4);
            expect(v9.Magnitude).to.equal(u5.Position.Magnitude);
            u5.FreeLength = math.random(1, 20);
            u7();
        end;

        u7 = function() -- Line: 45
            -- upvalues: u6 (ref), u5 (copy), SameCallback (copy), LimitCallback (copy)
            if u6 >= 10 then
                return;
            end;

            u6 = u6 + 1;

            if u5.Position.Magnitude < u5.FreeLength then
                it(`Should stay the same #{u6}`, SameCallback);

                return;
            end;

            it(`Should limit to {u5.FreeLength} studs #{u6}`, LimitCallback);
        end;

        u7();
    end);
end;
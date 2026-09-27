-- Decompiled with Potassium's decompiler.

local Frustum = require(script.Parent:WaitForChild("Frustum"));

return function() -- Line: 3
    -- upvalues: Frustum (copy)
    local u1 = {
        FieldOfView = 70,
        CFrame = CFrame.identity,
        ViewportSize = Vector2.new(1920, 1080)
    };
    local u2 = {};
    describe("Generates CFrames", function() -- Line: 12
        -- upvalues: u2 (ref), Frustum (ref), u1 (copy)
        local os_clock_ret = os.clock();
        u2 = table.pack(Frustum.GetCFrames(u1, 500));
        local os_clock_ret2 = os.clock();
        u2.n = nil;
        print((`Solved view frustum in {string.format("%.2f", (os_clock_ret2 - os_clock_ret) * 1000000)}μs`));
    end);
    describe("Point In View", function() -- Line: 24
        -- upvalues: Frustum (ref), u2 (ref)
        it("Close In View Point", function() -- Line: 29
            -- upvalues: Frustum (ref), u2 (ref)
            expect(Frustum.InViewFrustum(Vector3.new(0, 0, -5), table.unpack(u2))).to.equal(true);
        end);
        it("Past FarPlane Point", function() -- Line: 33
            -- upvalues: Frustum (ref), u2 (ref)
            expect(Frustum.InViewFrustum(Vector3.new(0, 0, -550), table.unpack(u2))).to.equal(false);
        end);
        it("Out Of View Point", function() -- Line: 37
            -- upvalues: Frustum (ref), u2 (ref)
            expect(Frustum.InViewFrustum(Vector3.new(0, 0, 5), table.unpack(u2))).to.equal(false);
        end);
    end);
    describe("Object In View", function() -- Line: 42
        -- upvalues: Frustum (ref), u2 (ref)
        local u3 = {
            Size = Vector3.new(1, 1, 3),
            CFrame = CFrame.new(0, 0, -5)
        };
        local u4 = {
            Size = Vector3.new(1, 1, 3),
            CFrame = CFrame.new(0, 0, -550)
        };
        local u5 = {
            Size = Vector3.new(1, 1, 3),
            CFrame = CFrame.new(0, 0, 5)
        };
        it("Close In View Object", function() -- Line: 58
            -- upvalues: Frustum (ref), u3 (copy), u2 (ref)
            expect(Frustum.ObjectInFrustum(u3, table.unpack(u2))).to.equal(true);
        end);
        it("Past FarPlane Object", function() -- Line: 62
            -- upvalues: Frustum (ref), u4 (copy), u2 (ref)
            expect(Frustum.ObjectInFrustum(u4, table.unpack(u2))).to.equal(false);
        end);
        it("Out Of View Object", function() -- Line: 66
            -- upvalues: Frustum (ref), u5 (copy), u2 (ref)
            expect(Frustum.ObjectInFrustum(u5, table.unpack(u2))).to.equal(false);
        end);
    end);
end;
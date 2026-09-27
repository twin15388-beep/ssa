-- Decompiled with Potassium's decompiler.

local VehicleContext = script.Parent.Parent:WaitForChild("InputContexts"):WaitForChild("VehicleContext");
local ThrottleAction = VehicleContext:WaitForChild("ThrottleAction");
local SteerAction = VehicleContext:WaitForChild("SteerAction");
require(script.Parent.Parent:WaitForChild("CommonUtils")).get("FlagUtil");
local u1 = {};
u1.__index = u1;

function u1.new() -- Line: 23
    -- upvalues: u1 (copy)
    local v2 = setmetatable({}, u1);
    v2.enabled = false;
    v2.vehicleSeat = nil;

    return v2;
end;

function u1.Enable(p3: table, p4: boolean, p5: userdata) -- Line: 32
    -- upvalues: VehicleContext (copy)
    if p4 == p3.enabled and p5 == p3.vehicleSeat then
        return;
    end;

    p3.enabled = p4;

    if not p4 then
        VehicleContext.Enabled = false;
        p3.vehicleSeat = nil;

        return;
    end;

    if not p5 then
        return;
    end;

    p3.vehicleSeat = p5;
    VehicleContext.Enabled = true;
end;

function u1.Update(p6: table, p7: vector, p8: boolean) -- Line: 53
    -- upvalues: ThrottleAction (copy), SteerAction (copy)
    if not p6.vehicleSeat then
        return p7, false;
    end;

    if not p8 then
        local v9 = p6.vehicleSeat.Occupant.RootPart.CFrame:VectorToObjectSpace(p7);
        p6.vehicleSeat.ThrottleFloat = p6:ComputeThrottle(v9);
        p6.vehicleSeat.SteerFloat = p6:ComputeSteer(v9);

        return Vector3.new(0, 0, 0), true;
    end;

    local State = ThrottleAction:GetState();
    local State2 = SteerAction:GetState();
    local v10 = p7 + Vector3.new(State2, 0, -State);
    p6.vehicleSeat.ThrottleFloat = -v10.Z;
    p6.vehicleSeat.SteerFloat = v10.X;

    return v10, true;
end;

function u1.ComputeThrottle(p11, p12) -- Line: 80
    return p12 == Vector3.new(0, 0, 0) and 0 or -p12.Z;
end;

function u1.ComputeSteer(p13, p14) -- Line: 88
    return p14 == Vector3.new(0, 0, 0) and 0 or -math.atan2(-p14.x, -p14.z) * 57.29577951308232;
end;

return u1;
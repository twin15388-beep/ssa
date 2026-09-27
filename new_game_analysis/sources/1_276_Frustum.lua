-- Decompiled with Potassium's decompiler.

local script_Parent = script.Parent;
local Config = require(script_Parent:WaitForChild("Config"));
local Utilities = require(script_Parent:WaitForChild("Utilities"));
local u22 = {
    GetCFrames = function(p1, p2) -- Line: 8, Name: GetCFrames
        local CFrame2 = p1.CFrame;
        local Position = CFrame2.Position;
        local RightVector = CFrame2.RightVector;
        local UpVector = CFrame2.UpVector;
        local v3 = p2 * 0.5;
        local v4 = math.tan((p1.FieldOfView + 5) * 0.5 * 0.017453) * p2;
        local v5 = v4 * (p1.ViewportSize.X / p1.ViewportSize.Y);
        local v6 = CFrame2 * CFrame.new(0, 0, -p2);
        local v7 = v6 * Vector3.new(v5, v4, 0);
        local v8 = v6 * Vector3.new(-v5, -v4, 0);
        local v9 = v6 * Vector3.new(v5, -v4, 0);

        return (CFrame2 * CFrame.new(0, 0, -v3)):Inverse(), v5, v4, v3, UpVector:Cross(v9 - Position).Unit, UpVector:Cross(v8 - Position).Unit, RightVector:Cross(Position - v7).Unit, RightVector:Cross(Position - v9).Unit, CFrame2;
    end,

    InViewFrustum = function(p10, p11, p12, p13, p14, p15, p16, p17, p18, p19) -- Line: 32, Name: InViewFrustum
        local v20 = p11 * p10;

        if p12 < v20.X or (v20.X < -p12 or (p13 < v20.Y or (v20.Y < -p13 or (p14 < v20.Z or v20.Z < -p14)))) then
            return false;
        end;

        local v21 = p10 - p19.Position;

        return p15:Dot(v21) >= 0 and (p16:Dot(v21) <= 0 and (p17:Dot(v21) >= 0 and p18:Dot(v21) <= 0));
    end
};

function u22.ObjectInFrustum(p23, p24, p25, p26, p27, p28, p29, p30, p31, p32) -- Line: 73
    -- upvalues: Config (copy), Utilities (copy), u22 (copy)
    local CFrame2 = p23.CFrame;
    local Size = p23.Size;
    local v33 = Config.FAR_PLANE * 0.5;
    local v34 = Utilities.ClosestPointOnLine(p32.Position + p32.LookVector * v33, p32.LookVector, v33, CFrame2.Position);
    local v35, v36 = Utilities.ClosestPointInBox(CFrame2, Size, v34);

    return v35 and true or (u22.InViewFrustum(v36, p24, p25, p26, p27, p28, p29, p30, p31, p32) and true or false);
end;

return u22;
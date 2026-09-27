-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer;
local u1 = nil;
local u2 = nil;
local u3 = nil;
local u4 = false;
local u5 = true;
local u6 = 0;
local u7 = 0;
local u8 = 0;

local function horizontal(p9) -- Line: 29
    local Vector3_new_ret = Vector3.new(p9.X, 0, p9.Z);

    if Vector3_new_ret.Magnitude < 0.001 then
        return nil;
    end;

    return Vector3_new_ret.Unit;
end;

local function setCarrying(p10) -- Line: 64
    -- upvalues: u4 (ref), u2 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref)
    if u4 == p10 then
        return;
    end;

    u4 = p10;

    if not u2 then
        return;
    end;

    if not u4 then
        u2.AutoRotate = u5;
        u6 = 0;
        u7 = 0;
        u8 = 0;

        return;
    end;

    u5 = u2.AutoRotate;
    u2.AutoRotate = false;
    u6 = 0;
    u7 = 0;
    u8 = 0;
end;

local function updateCarrying() -- Line: 94
    -- upvalues: LocalPlayer (copy), u4 (ref), u2 (ref), u5 (ref), u6 (ref), u7 (ref), u8 (ref)
    local v11 = LocalPlayer:GetAttribute("CarryingCargoCart") == true;

    if u4 == v11 then
        return;
    end;

    u4 = v11;

    if not u2 then
        return;
    end;

    if not u4 then
        u2.AutoRotate = u5;
        u6 = 0;
        u7 = 0;
        u8 = 0;

        return;
    end;

    u5 = u2.AutoRotate;
    u2.AutoRotate = false;
    u6 = 0;
    u7 = 0;
    u8 = 0;
end;

LocalPlayer.CharacterAdded:Connect(function(p12) -- Line: 43, Name: setupCharacter
    -- upvalues: u1 (ref), u2 (ref), u3 (ref), u6 (ref), u7 (ref), u8 (ref), u4 (ref), u5 (ref)
    u1 = p12;
    u2 = u1:WaitForChild("Humanoid");
    u3 = u1:WaitForChild("HumanoidRootPart");
    u6 = 0;
    u7 = 0;
    u8 = 0;

    if u4 then
        u5 = u2.AutoRotate;
        u2.AutoRotate = false;
    end;
end);

if LocalPlayer.Character then
    u1 = LocalPlayer.Character;
    u2 = u1:WaitForChild("Humanoid");
    u3 = u1:WaitForChild("HumanoidRootPart");
    u6 = 0;
    u7 = 0;
    u8 = 0;

    if u4 then
        u5 = u2.AutoRotate;
        u2.AutoRotate = false;
    end;
end;

LocalPlayer:GetAttributeChangedSignal("CarryingCargoCart"):Connect(updateCarrying);
local v13 = LocalPlayer:GetAttribute("CarryingCargoCart") == true;

if u4 ~= v13 then
    u4 = v13;

    if u2 then
        if u4 then
            u5 = u2.AutoRotate;
            u2.AutoRotate = false;
            u6 = 0;
            u7 = 0;
            u8 = 0;
        else
            u2.AutoRotate = u5;
            u6 = 0;
            u7 = 0;
            u8 = 0;
        end;
    end;
end;

RunService:BindToRenderStep("CargoCartMovement", Enum.RenderPriority.Last.Value, function(p14) -- Line: 123
    -- upvalues: u4 (ref), u1 (ref), u2 (ref), u3 (ref), u6 (ref), u8 (ref), u7 (ref)
    if not (u4 and (u1 and (u2 and (u3 and u2.Health > 0)))) then
        return;
    end;

    u2.AutoRotate = false;
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if not workspace_CurrentCamera then
        return;
    end;

    local MoveDirection = u2.MoveDirection;
    local LookVector = workspace_CurrentCamera.CFrame.LookVector;
    local Vector3_new_ret = Vector3.new(LookVector.X, 0, LookVector.Z);
    local v15;

    if Vector3_new_ret.Magnitude < 0.001 then
        v15 = nil;
    else
        v15 = Vector3_new_ret.Unit;
    end;

    local RightVector = workspace_CurrentCamera.CFrame.RightVector;
    local Vector3_new_ret2 = Vector3.new(RightVector.X, 0, RightVector.Z);
    local v16;

    if Vector3_new_ret2.Magnitude < 0.001 then
        v16 = nil;
    else
        v16 = Vector3_new_ret2.Unit;
    end;

    if not v15 then
        local LookVector2 = u3.CFrame.LookVector;
        local Vector3_new_ret3 = Vector3.new(LookVector2.X, 0, LookVector2.Z);

        if Vector3_new_ret3.Magnitude < 0.001 then
            v15 = nil;
        else
            v15 = Vector3_new_ret3.Unit;
        end;
    end;

    if not v16 then
        local RightVector2 = u3.CFrame.RightVector;
        local Vector3_new_ret3 = Vector3.new(RightVector2.X, 0, RightVector2.Z);

        if Vector3_new_ret3.Magnitude < 0.001 then
            v16 = nil;
        else
            v16 = Vector3_new_ret3.Unit;
        end;
    end;

    if not (v15 and v16) then
        return;
    end;

    local v17 = MoveDirection:Dot(v15);
    local v18 = MoveDirection:Dot(v16);
    local v19 = math.abs(v17) >= 0.12 and (v17 > 0 and 1 or -1) or 0;
    local math_clamp_ret = math.clamp(v18 * 1.35, -1, 1);
    local v20 = math.abs(math_clamp_ret) < 0.08 and 0 or math_clamp_ret;
    local v21 = math.abs(v19) > math.abs(u6) and 7 or 10;
    local v22 = 1 - math.exp(-v21 * p14);
    u6 = u6 + (v19 - u6) * v22;
    u8 = u8 + (v20 - u7) * 18 * p14;
    u8 = u8 * math.exp(-7 * p14);
    u7 = u7 + u8 * p14;
    u7 = math.clamp(u7, -1, 1);
    local LookVector2 = u3.CFrame.LookVector;
    local Vector3_new_ret3 = Vector3.new(LookVector2.X, 0, LookVector2.Z);
    local v23;

    if Vector3_new_ret3.Magnitude < 0.001 then
        v23 = nil;
    else
        v23 = Vector3_new_ret3.Unit;
    end;

    if not v23 then
        return;
    end;

    local math_abs_ret = math.abs(u6);

    if math_abs_ret <= 0.03 then
        u2:Move(Vector3.new(0, 0, 0), false);

        return;
    end;

    local math_clamp_ret2 = math.clamp(math_abs_ret, 0, 1);
    local v24 = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), -u7 * (u6 >= 0 and 1.0122909661567112 or 0.7330382858376184) * math_clamp_ret2 * p14):VectorToWorldSpace(v23);
    u3.CFrame = CFrame.lookAt(u3.Position, u3.Position + v24, Vector3.new(0, 1, 0));
    u2:Move(v24 * u6, false);
end);
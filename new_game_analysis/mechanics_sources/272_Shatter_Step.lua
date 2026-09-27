-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local CAM = ReplicatedStorage.CAM;
local Skills = ReplicatedStorage.Skills;
local u1 = require(ReplicatedStorage.Packages.cleanit).new();
local RaycastHelper = require(CAM.Global.RaycastHelper);
local Platform_Handler = require(CAM.Client.Controllers.Platform_Handler);
local Utility = require(CAM.Global.Utility);
local Config = require(script.Parent.Config);
local u2 = {
    Id = 0
};
local script_ShatterStep = script.ShatterStep;
local script_ShatterStepAir = script.ShatterStepAir;
local skill_stand_still = Skills.holder.skill_stand_still;
local u3 = nil;
local u4 = nil;

function u2.Hold(p5: userdata) -- Line: 32
    -- upvalues: u1 (copy), u3 (ref), u4 (ref), u2 (copy), skill_stand_still (copy), Platform_Handler (copy), Config (copy), Utility (copy), RunService (copy), script_ShatterStep (copy)
    u1:Clean();

    if u3 then
        u3:Stop();
        u3 = nil;
    end;

    if u4 then
        u4:Disconnect();
        u4 = nil;
    end;

    local Character = p5.Character;
    local u6;

    if Character then
        u6 = Character.HumanoidRootPart;
    else
        u6 = Character;
    end;

    if Character then
        Character = Character.Humanoid:FindFirstChildOfClass("Animator");
    end;

    if not (Character and u6) then
        return;
    end;

    local Id = u2.Id;
    local v7 = skill_stand_still:Clone();
    v7.Parent = u6;
    u1:Add(v7);
    local v8 = Platform_Handler.mousepos(Config.MOUSE_RANGE);
    local u9, v10 = Utility.CreateAlignOrientationWithAttachment(u6, "skill_look_at", {
        Responsiveness = 70,
        MaxTorque = 500000,
        AlignType = Enum.AlignType.PrimaryAxisParallel,
        CFrame = Utility.SafeLookAt(u6.Position, Vector3.new(v8.X, u6.Position.Y, v8.Z), u6.CFrame)
    });
    u1:Add(u9);
    u1:Add(v10);
    u4 = RunService.PostSimulation:Connect(function() -- Line: 59
        -- upvalues: u2 (ref), Id (copy), Platform_Handler (ref), Config (ref), u9 (copy), Utility (ref), u6 (copy)
        if u2.Id ~= Id then
            return;
        end;

        local v11 = Platform_Handler.mousepos(Config.MOUSE_RANGE);
        u9.CFrame = Utility.SafeLookAt(u6.Position, Vector3.new(v11.X, u6.Position.Y, v11.Z), u9.CFrame);
    end);
    u3 = Character:LoadAnimation(script_ShatterStep);
    u3:Play();
    task.delay(Config.HOLD_PAUSE, function() -- Line: 69
        -- upvalues: u2 (ref), Id (copy), u3 (ref)
        if u2.Id ~= Id then
            return;
        end;

        if u3 and u3.IsPlaying then
            u3:AdjustSpeed(0);
        end;
    end);
end;

function u2.UnHold(p12: userdata) -- Line: 75
    -- upvalues: u2 (copy), u4 (ref), u3 (ref), Config (copy), u1 (copy)
    local Id = u2.Id;

    if u4 then
        u4:Disconnect();
        u4 = nil;
    end;

    if u3 then
        if u3.TimePosition < Config.HOLD_PAUSE then
            u3.TimePosition = Config.HOLD_PAUSE;
        end;

        u3:AdjustSpeed(1);
    end;

    task.delay(Config.STAGE1_END, function() -- Line: 89
        -- upvalues: u2 (ref), Id (copy), u1 (ref), u3 (ref)
        if u2.Id ~= Id then
            return;
        end;

        u1:Clean();

        if u3 then
            u3:Stop();
            u3 = nil;
        end;
    end);

    return true;
end;

function u2.Switch(p13: userdata) -- Line: 100
    -- upvalues: u3 (ref), u4 (ref), u1 (copy), u2 (copy), Utility (copy), Platform_Handler (copy), Config (copy), script_ShatterStepAir (copy), skill_stand_still (copy), RunService (copy), RaycastHelper (copy)
    if u3 then
        u3:Stop();
        u3 = nil;
    end;

    if u4 then
        u4:Disconnect();
        u4 = nil;
    end;

    u1:Clean();
    local Character = p13.Character;
    local Humanoid = Character.Humanoid;
    local Animator = Humanoid.Animator;
    local HumanoidRootPart = Character.HumanoidRootPart;
    local Id = u2.Id;
    local valuesfolder = Utility.getvaluesfolder(Character);

    if valuesfolder then
        valuesfolder = valuesfolder:FindFirstChild("ShatterStepTarget");
    end;

    if valuesfolder then
        valuesfolder = valuesfolder.Value;
    end;

    local function getAim() -- Line: 117
        -- upvalues: valuesfolder (copy), Platform_Handler (ref), Config (ref)
        local v14 = valuesfolder and valuesfolder:FindFirstChild("HumanoidRootPart");

        if v14 then
            return v14.Position;
        end;

        return Platform_Handler.mousepos(Config.MOUSE_RANGE);
    end;

    local v15 = Animator:LoadAnimation(script_ShatterStepAir);
    u1:Add(v15);
    v15:Play();
    local v16 = skill_stand_still:Clone();
    v16.LinearVelocity.ForceLimitMode = Enum.ForceLimitMode.PerAxis;
    v16.LinearVelocity.MaxAxesForce = Vector3.new(1000000, 1000000, 1000000);
    v16.LinearVelocity.VectorVelocity = Vector3.new(0, 0, 0);
    v16.Parent = HumanoidRootPart;
    u1:Add(v16);
    local u17 = nil;

    local function writeAim(p18: vector) -- Line: 136
        -- upvalues: u17 (ref), Character (copy), Config (ref)
        u17 = u17 or Character:FindFirstChild(Config.POS_PART_NAME);

        if u17 then
            u17.Position = p18;
            u17.bp.Position = p18;
        end;
    end;

    local CreateAlignOrientationWithAttachment = Utility.CreateAlignOrientationWithAttachment;
    local v19 = {
        Responsiveness = 70,
        MaxTorque = 500000,
        AlignType = Enum.AlignType.PrimaryAxisParallel
    };
    local SafeLookAt = Utility.SafeLookAt;
    local Position = HumanoidRootPart.Position;
    local v20;

    if valuesfolder then
        v20 = valuesfolder:FindFirstChild("HumanoidRootPart");
    else
        v20 = valuesfolder;
    end;

    local v21;

    if v20 then
        v21 = v20.Position;
    else
        v21 = Platform_Handler.mousepos(Config.MOUSE_RANGE);
    end;

    v19.CFrame = SafeLookAt(Position, v21, HumanoidRootPart.CFrame);
    local u22, v23 = CreateAlignOrientationWithAttachment(HumanoidRootPart, "skill_look_at", v19);
    u1:Add(u22);
    u1:Add(v23);
    local u24 = true;
    u1:Connect(RunService.PostSimulation, function() -- Line: 154
        -- upvalues: u24 (ref), u2 (ref), Id (copy), valuesfolder (copy), Platform_Handler (ref), Config (ref), u22 (copy), Utility (ref), HumanoidRootPart (copy), u17 (ref), Character (copy)
        if not u24 or u2.Id ~= Id then
            return;
        end;

        local v25 = valuesfolder and valuesfolder:FindFirstChild("HumanoidRootPart");
        local v26;

        if v25 then
            v26 = v25.Position;
        else
            v26 = Platform_Handler.mousepos(Config.MOUSE_RANGE);
        end;

        u22.CFrame = Utility.SafeLookAt(HumanoidRootPart.Position, Vector3.new(v26.X, HumanoidRootPart.Position.Y, v26.Z), u22.CFrame);
        u17 = u17 or Character:FindFirstChild(Config.POS_PART_NAME);

        if u17 then
            u17.Position = v26;
            u17.bp.Position = v26;
        end;
    end);
    task.wait(0.03333333333333333);

    if u2.Id ~= Id then
        return;
    end;

    local Y = HumanoidRootPart.Position.Y;
    v16.LinearVelocity.VectorVelocity = Vector3.new(0, Config.JUMP_HEIGHT / 0.3, 0);
    task.wait(0.3);

    if u2.Id ~= Id then
        return;
    end;

    v16.LinearVelocity.VectorVelocity = Vector3.new(0, 0, 0);
    task.wait(0.6333333333333333);

    if u2.Id ~= Id then
        return;
    end;

    u24 = false;

    if valuesfolder then
        valuesfolder = valuesfolder:FindFirstChild("HumanoidRootPart");
    end;

    local v27;

    if valuesfolder then
        v27 = valuesfolder.Position;
    else
        v27 = Platform_Handler.mousepos(Config.MOUSE_RANGE);
    end;

    u17 = u17 or Character:FindFirstChild(Config.POS_PART_NAME);

    if u17 then
        u17.Position = v27;
        u17.bp.Position = v27;
    end;

    local Unit = ((v27 - HumanoidRootPart.Position) * Vector3.new(1, 0, 1)).Unit;
    HumanoidRootPart.CFrame = Utility.SafeLookAt(HumanoidRootPart.Position, HumanoidRootPart.Position + Unit, HumanoidRootPart.CFrame);
    local Position2 = HumanoidRootPart.Position;
    local u28 = Y - Config.DIVE_MAX_DROP;

    local function groundGoal(p29: vector) -- Line: 189
        -- upvalues: Position2 (copy), RaycastHelper (ref), Config (ref), Humanoid (copy), HumanoidRootPart (copy), u28 (copy)
        local v30 = workspace:Raycast(Vector3.new(p29.X, Position2.Y, p29.Z), Vector3.new(0, -80, 0), RaycastHelper.Crater);
        local v31 = (v30 and v30.Position or p29 - Vector3.new(0, Config.JUMP_HEIGHT, 0)) + Vector3.new(0, Humanoid.HipHeight + HumanoidRootPart.Size.Y / 2, 0);

        if v31.Y < u28 then
            v31 = Vector3.new(v31.X, u28, v31.Z);
        end;

        return v31;
    end;

    local v32 = groundGoal(Position2 + Unit * Config.DIVE_FORWARD);
    local v33 = workspace:Spherecast(Position2, Config.DIVE_PROBE_RADIUS, v32 - Position2, RaycastHelper.Crater);

    if v33 then
        v32 = groundGoal(v33.Position + v33.Normal * Config.DIVE_WALL_OFFSET);
    end;

    v16.LinearVelocity.VectorVelocity = (v32 - HumanoidRootPart.Position) / 0.06666666666666667;
    task.wait(0.06666666666666667);

    if u2.Id ~= Id then
        return;
    end;

    v16.LinearVelocity.VectorVelocity = Vector3.new(0, 0, 0);
    HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
    HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
    HumanoidRootPart.CFrame = CFrame.lookAt(v32, v32 + Unit);
    task.wait(0.06666666666666667);

    if u2.Id ~= Id then
        return;
    end;

    v16:Destroy();
    u22:Destroy();
    v23:Destroy();
    task.wait(0.6833333333333333);

    if u2.Id ~= Id then
        return;
    end;

    u1:Clean();
end;

function u2.Cancel(p34: userdata) -- Line: 233
    -- upvalues: u4 (ref), u1 (copy), u3 (ref)
    if u4 then
        u4:Disconnect();
        u4 = nil;
    end;

    u1:Clean();

    if u3 then
        u3:Stop();
        u3 = nil;
    end;
end;

return u2;
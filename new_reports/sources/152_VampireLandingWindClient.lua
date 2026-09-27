-- Decompiled with Potassium's decompiler.

local Workspace = game:GetService("Workspace");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ContentProvider = game:GetService("ContentProvider");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local LocalPlayer = Players.LocalPlayer;
local VampireLandingWind = ReplicatedStorage:WaitForChild("Efeitos"):WaitForChild("Pulo"):WaitForChild("VampireLandingWind");
local u1 = setmetatable({}, {
    __mode = "k"
});
task.spawn(function() -- Line: 12
    -- upvalues: ReplicatedStorage (copy), ContentProvider (copy)
    local VENTO = ReplicatedStorage:WaitForChild("Efeitos"):WaitForChild("Pulo"):WaitForChild("VENTO");
    pcall(function() -- Line: 14
        -- upvalues: ContentProvider (ref), VENTO (copy)
        ContentProvider:PreloadAsync({ VENTO });
    end);
end);

local function tryEmit(u2) -- Line: 17
    -- upvalues: u1 (copy), Workspace (copy), RunService (copy)
    if not u2:IsA("ParticleEmitter") or u1[u2] then
        return;
    end;

    local Parent = u2.Parent;

    if not (Parent and (Parent:IsA("BasePart") and (Parent.Name == "VampireLandingVento" and Parent.Parent == Workspace))) then
        return;
    end;

    local Attribute = Parent:GetAttribute("LandingWindCreatedAt");

    if type(Attribute) ~= "number" then
        return;
    end;

    u1[u2] = true;
    task.spawn(function() -- Line: 28
        -- upvalues: RunService (ref), Parent (copy), Workspace (ref), u2 (copy), Attribute (copy)
        RunService.RenderStepped:Wait();

        if not Parent:IsDescendantOf(Workspace) or u2.Parent ~= Parent then
            return;
        end;

        if Workspace:GetServerTimeNow() - Attribute > 1.5 then
            return;
        end;

        u2.Enabled = false;
        local v3 = tonumber(u2:GetAttribute("EmitCount")) or 5;
        local math_floor_ret = math.floor(v3);
        u2:Emit((math.max(1, math_floor_ret)));
    end);
end;

Workspace.DescendantAdded:Connect(tryEmit);
Workspace.ChildAdded:Connect(function(p4) -- Line: 41
    -- upvalues: tryEmit (copy)
    if p4.Name == "VampireLandingVento" and p4:IsA("BasePart") then
        for _, child in ipairs(p4:GetChildren()) do
            tryEmit(child);
        end;
    end;
end);

for _, child in ipairs(Workspace:GetChildren()) do
    if child.Name == "VampireLandingVento" and child:IsA("BasePart") then
        for _, child2 in ipairs(child:GetChildren()) do
            tryEmit(child2);
        end;
    end;
end;

local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = false;
local u9 = false;
local u10 = false;
local u11 = 0;
local u12 = false;
local u13 = false;

local function isVampireReady() -- Line: 63
    -- upvalues: LocalPlayer (copy), u5 (ref), u6 (ref), u7 (ref)
    local Team = LocalPlayer.Team;

    if Team then
        if LocalPlayer.Team.Name == "Vampires" or LocalPlayer.Team.Name == "Cannibal Raised" then
            Team = u5 and (u6 and u7);

            if Team then
                if u6.Health > 0 and (u5:GetAttribute("ActionLocked") ~= true and u5:GetAttribute("Hibernating") ~= true) then
                    Team = u5:GetAttribute("Ragdolled") ~= true;
                else
                    Team = false;
                end;
            end;
        else
            Team = false;
        end;
    end;

    return Team;
end;

local function requestLanding() -- Line: 72
    -- upvalues: u8 (ref), u9 (ref), u10 (ref), u12 (ref), u13 (ref), u11 (ref), isVampireReady (copy), VampireLandingWind (copy), u7 (ref)
    if not u8 then
        return;
    end;

    u8 = false;
    u9 = false;
    u10 = false;
    u12 = false;
    u13 = false;
    u11 = 0;

    if isVampireReady() then
        VampireLandingWind:FireServer(u7.Position);
    end;
end;

local function performDoubleJump() -- Line: 87
    -- upvalues: isVampireReady (copy), u9 (ref), u10 (ref), u6 (ref), u13 (ref), u8 (ref), u7 (ref), Workspace (copy)
    if not (isVampireReady() and (u9 and not u10)) then
        return false;
    end;

    local State = u6:GetState();

    if State ~= Enum.HumanoidStateType.Jumping and State ~= Enum.HumanoidStateType.Freefall then
        return false;
    end;

    u10 = true;
    u9 = false;
    u13 = false;
    u8 = true;
    local AssemblyLinearVelocity = u7.AssemblyLinearVelocity;
    local v14 = u6.UseJumpPower and u6.JumpPower or math.sqrt(2 * Workspace.Gravity * u6.JumpHeight);
    local X = AssemblyLinearVelocity.X;
    local math_max_ret = math.max(v14, 1);
    u7.AssemblyLinearVelocity = Vector3.new(X, math_max_ret, AssemblyLinearVelocity.Z);
    u6:ChangeState(Enum.HumanoidStateType.Jumping);

    return true;
end;

local function setupCharacter(p15) -- Line: 107
    -- upvalues: u5 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), u10 (ref), u12 (ref), u13 (ref), u11 (ref), performDoubleJump (copy), isVampireReady (copy), VampireLandingWind (copy)
    u5 = p15;
    u6 = p15:WaitForChild("Humanoid");
    u7 = p15:WaitForChild("HumanoidRootPart");
    u8 = false;
    u9 = false;
    u10 = false;
    u12 = false;
    u13 = false;
    u11 = 0;
    local u16 = u6;
    u16.StateChanged:Connect(function(p17, p18) -- Line: 119
        -- upvalues: u16 (copy), u6 (ref), u10 (ref), u11 (ref), u8 (ref), u9 (ref), u13 (ref), performDoubleJump (ref), u12 (ref), isVampireReady (ref), VampireLandingWind (ref), u7 (ref)
        if u16 ~= u6 then
            return;
        end;

        if p18 == Enum.HumanoidStateType.Jumping then
            if u10 or os.clock() - u11 <= 0.5 then
                u8 = true;

                if not u10 then
                    u9 = true;
                end;

                if u13 then
                    task.defer(performDoubleJump);
                end;
            end;
        elseif p18 == Enum.HumanoidStateType.Freefall then
            if u8 and not u10 then
                u9 = true;

                if u13 then
                    task.defer(performDoubleJump);
                end;
            end;
        elseif p18 == Enum.HumanoidStateType.Landed or p17 == Enum.HumanoidStateType.Freefall and (p18 == Enum.HumanoidStateType.Running or p18 == Enum.HumanoidStateType.RunningNoPhysics) then
            if not u8 then
                return;
            end;

            u8 = false;
            u9 = false;
            u10 = false;
            u12 = false;
            u13 = false;
            u11 = 0;

            if isVampireReady() then
                VampireLandingWind:FireServer(u7.Position);
            end;
        elseif p18 == Enum.HumanoidStateType.Dead or (p18 == Enum.HumanoidStateType.Swimming or (p18 == Enum.HumanoidStateType.Climbing or p18 == Enum.HumanoidStateType.Seated)) then
            u8 = false;
            u9 = false;
        end;
    end);
end;

UserInputService.JumpRequest:Connect(function() -- Line: 148
    -- upvalues: u11 (ref), isVampireReady (copy), u10 (ref), u6 (ref), u8 (ref), u9 (ref), performDoubleJump (copy), u12 (ref), u13 (ref)
    u11 = os.clock();

    if not isVampireReady() or u10 then
        return;
    end;

    local State = u6:GetState();
    local v19 = State == Enum.HumanoidStateType.Jumping and true or State == Enum.HumanoidStateType.Freefall;

    if not (u8 and v19) then
        if not u8 then
            if u12 then
                u13 = true;

                return;
            end;

            u12 = true;

            if v19 then
                u8 = true;
                u9 = true;
            end;
        end;

        return;
    end;

    u9 = true;
    performDoubleJump();
end);
LocalPlayer.CharacterAdded:Connect(setupCharacter);

if LocalPlayer.Character then
    task.spawn(setupCharacter, LocalPlayer.Character);
end;
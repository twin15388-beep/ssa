-- Decompiled with Potassium's decompiler.

local UserInputService = game:GetService("UserInputService");
local Players = game:GetService("Players");
local Debris = game:GetService("Debris");
local LocalPlayer = Players.LocalPlayer;
local HumanStatsAction = game:GetService("ReplicatedStorage"):WaitForChild("Funções"):WaitForChild("Eventos"):WaitForChild("HumanStatsAction");
local Q = Enum.KeyCode.Q;
local u1 = true;
UserInputService.InputBegan:Connect(function(p2, p3) -- Line: 19, Name: onInputBegan
    -- upvalues: Q (copy), LocalPlayer (copy), u1 (ref), HumanStatsAction (copy), Debris (copy)
    if p3 or p2.KeyCode ~= Q and p2.KeyCode ~= Enum.KeyCode.ButtonB then
        return;
    end;

    if not LocalPlayer.Team or LocalPlayer.Team.Name ~= "Humans" then
        return;
    end;

    local Character = LocalPlayer.Character;

    if not Character then
        return;
    end;

    local Humanoid = Character:FindFirstChild("Humanoid");
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

    if not (Humanoid and (HumanoidRootPart and Humanoid.Health > 0)) then
        return;
    end;

    if not u1 then
        return;
    end;

    u1 = false;
    HumanStatsAction:FireServer("Dash");
    local Sound = Instance.new("Sound");
    Sound.SoundId = "rbxassetid://136880713327520";
    Sound.Parent = HumanoidRootPart;
    Sound.Volume = 1;
    Sound:Play();
    Debris:AddItem(Sound, 2);
    local Animator = Humanoid:FindFirstChild("Animator");

    if Animator then
        local Animation = Instance.new("Animation");
        Animation.AnimationId = "rbxassetid://111788446864422";
        local v4 = Animator:LoadAnimation(Animation);
        v4.Priority = Enum.AnimationPriority.Action4;
        v4:Play();
    end;

    local MoveDirection = Humanoid.MoveDirection;

    if MoveDirection.Magnitude < 0.1 then
        MoveDirection = HumanoidRootPart.CFrame.LookVector;
    end;

    local BodyVelocity = Instance.new("BodyVelocity");
    BodyVelocity.MaxForce = Vector3.new(100000, 0, 100000);
    BodyVelocity.Velocity = MoveDirection * 45;
    BodyVelocity.Parent = HumanoidRootPart;
    Debris:AddItem(BodyVelocity, 0.15);
    task.delay(3, function() -- Line: 77
        -- upvalues: u1 (ref)
        u1 = true;
    end);
end);
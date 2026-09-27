-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
local LocalPlayer = Players.LocalPlayer;
local BatFormRemote = ReplicatedStorage:WaitForChild("Funções"):WaitForChild("Eventos"):WaitForChild("BatFormRemote");
local BatFormConfig = require(ReplicatedStorage:WaitForChild("Funções"):WaitForChild("BatFormConfig"));
local u1 = false;
local u2 = 0;
local u3 = 0;
local u4 = nil;
local u5 = nil;
local u6 = {
    BatWind = true,
    BatWings = true,
    BatCall = true
};

local function muteCharacterSound(u7) -- Line: 25
    -- upvalues: u6 (copy)
    if (u7:IsA("Sound") or u7:IsA("AudioPlayer")) and not u6[u7.Name] then
        u7.Volume = 0;

        if u7:IsA("Sound") then
            u7:Stop();

            return;
        end;

        pcall(function() -- Line: 31
            -- upvalues: u7 (copy)
            u7:Stop();
        end);
    end;
end;

local function stopBatAnimation() -- Line: 38
    -- upvalues: u5 (ref)
    if u5 then
        pcall(function() -- Line: 40
            -- upvalues: u5 (ref)
            u5:Stop(0.08);
            u5:Destroy();
        end);
        u5 = nil;
    end;
end;

local function playBatAnimation() -- Line: 48
    -- upvalues: u5 (ref), LocalPlayer (copy), BatFormConfig (copy)
    if u5 then
        pcall(function() -- Line: 40
            -- upvalues: u5 (ref)
            u5:Stop(0.08);
            u5:Destroy();
        end);
        u5 = nil;
    end;

    local v8 = os.clock() + 2;
    local Character = LocalPlayer.Character;

    while (not Character or Character:GetAttribute("BatFormCharacter") ~= true) and os.clock() < v8 do
        task.wait();
        Character = LocalPlayer.Character;
    end;

    if not Character or Character:GetAttribute("BatFormCharacter") ~= true then
        return;
    end;

    local u9 = Character:FindFirstChildWhichIsA("AnimationController", true);

    if u9 then
        u9 = u9:FindFirstChildOfClass("Animator");
    end;

    if not u9 then
        return;
    end;

    for _, v in ipairs(u9:GetPlayingAnimationTracks()) do
        v:Stop(0);
    end;

    local Animation = Instance.new("Animation");
    Animation.Name = "BatFlying";
    Animation.AnimationId = BatFormConfig.FlyingAnimationId;
    local success, result = pcall(function() -- Line: 74
        -- upvalues: u9 (copy), Animation (copy)
        return u9:LoadAnimation(Animation);
    end);
    Animation:Destroy();

    if success and result then
        u5 = result;
        result.Looped = true;
        result.Priority = Enum.AnimationPriority.Action4;
        result:Play(0.05, 1, 1);
    end;
end;

local function beginMutingCharacterSounds() -- Line: 86
    -- upvalues: u4 (ref), LocalPlayer (copy), muteCharacterSound (copy)
    if u4 then
        u4:Disconnect();
        u4 = nil;
    end;

    local Character = LocalPlayer.Character;

    if not Character then
        return;
    end;

    for _, descendant in Character:GetDescendants() do
        muteCharacterSound(descendant);
    end;

    u4 = Character.DescendantAdded:Connect(function(p10) -- Line: 98
        -- upvalues: muteCharacterSound (ref)
        task.defer(muteCharacterSound, p10);
    end);
end;

local function stopMutingCharacterSounds() -- Line: 103
    -- upvalues: u4 (ref)
    if u4 then
        u4:Disconnect();
        u4 = nil;
    end;
end;

local function getVerticalInput() -- Line: 110
    -- upvalues: UserInputService (copy), u3 (ref)
    local v11 = 0;

    if UserInputService:IsKeyDown(Enum.KeyCode.Space) or (UserInputService:IsKeyDown(Enum.KeyCode.ButtonA) or os.clock() < u3) then
        v11 = v11 + 1;
    end;

    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or (UserInputService:IsKeyDown(Enum.KeyCode.RightControl) or UserInputService:IsKeyDown(Enum.KeyCode.ButtonB)) then
        v11 = v11 - 1;
    end;

    return v11;
end;

UserInputService.JumpRequest:Connect(function() -- Line: 127
    -- upvalues: u1 (ref), u3 (ref)
    if u1 then
        u3 = os.clock() + 0.22;
    end;
end);
BatFormRemote.OnClientEvent:Connect(function(p12) -- Line: 133
    -- upvalues: u1 (ref), playBatAnimation (copy), u2 (ref), beginMutingCharacterSounds (copy), u5 (ref), u3 (ref), u4 (ref)
    if p12 ~= "FlightStarted" then
        if p12 == "FlightEnded" then
            u1 = false;

            if u5 then
                pcall(function() -- Line: 40
                    -- upvalues: u5 (ref)
                    u5:Stop(0.08);
                    u5:Destroy();
                end);
                u5 = nil;
            end;

            u3 = 0;

            if u4 then
                u4:Disconnect();
                u4 = nil;
            end;
        end;

        return;
    end;

    u1 = true;
    task.spawn(playBatAnimation);
    u2 = 0;
    beginMutingCharacterSounds();
end);
RunService.RenderStepped:Connect(function() -- Line: 147
    -- upvalues: u1 (ref), u2 (ref), LocalPlayer (copy), getVerticalInput (copy), BatFormRemote (copy)
    if not u1 or os.clock() - u2 < 0.075 then
        return;
    end;

    local Character = LocalPlayer.Character;
    local v13;

    if Character then
        v13 = Character:FindFirstChildOfClass("Humanoid");
    else
        v13 = Character;
    end;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    local workspace_CurrentCamera = workspace.CurrentCamera;

    if not (v13 and (v13.Health > 0 and (Character and workspace_CurrentCamera))) then
        u1 = false;

        return;
    end;

    local MoveDirection = v13.MoveDirection;
    local Vector3_new_ret = Vector3.new(MoveDirection.X, 0, MoveDirection.Z);

    if Vector3_new_ret.Magnitude > 1 then
        Vector3_new_ret = Vector3_new_ret.Unit;
    end;

    local v14 = getVerticalInput();
    local v15 = Vector3_new_ret + Vector3.new(0, v14, 0);

    if v15.Magnitude > 1 then
        v15 = v15.Unit;
    end;

    u2 = os.clock();
    BatFormRemote:FireServer("Move", v15, workspace_CurrentCamera.CFrame.LookVector);
end);
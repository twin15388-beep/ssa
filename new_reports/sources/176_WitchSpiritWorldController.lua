-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Lighting = game:GetService("Lighting");
local RunService = game:GetService("RunService");
local StarterGui = game:GetService("StarterGui");
local TextChatService = game:GetService("TextChatService");
local UserInputService = game:GetService("UserInputService");
local SprintConfig = require(ReplicatedStorage:WaitForChild("Funções"):WaitForChild("SprintConfig"));
local LocalPlayer = Players.LocalPlayer;
local v1 = ReplicatedStorage:WaitForChild("Funções");
local WitchSpiritWorldRemote = v1:WaitForChild("Eventos"):FindFirstChild("WitchSpiritWorldRemote");

if not (WitchSpiritWorldRemote and WitchSpiritWorldRemote:IsA("RemoteEvent")) then
    return;
end;

local u2 = v1:WaitForChild("SpiritWorldAssets"):WaitForChild("ground dust");
local u3 = false;
local u4 = false;
local u5 = nil;
local u6 = {};
local u7 = {};
local u8 = setmetatable({}, {
    __mode = "k"
});
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = false;
local u18 = {};
local u19 = {};
local u20 = false;
local u21 = nil;
local u22 = nil;

local function disconnectAll(p23) -- Line: 42
    for _, v in ipairs(p23) do
        v:Disconnect();
    end;

    table.clear(p23);
end;

local function saveLighting() -- Line: 49
    -- upvalues: Lighting (copy)
    return {
        FogColor = Lighting.FogColor,
        FogStart = Lighting.FogStart,
        FogEnd = Lighting.FogEnd,
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        Brightness = Lighting.Brightness,
        ColorShift_Top = Lighting.ColorShift_Top,
        ColorShift_Bottom = Lighting.ColorShift_Bottom
    };
end;

local function applyWhiteWorld() -- Line: 62
    -- upvalues: Lighting (copy)
    Lighting.FogColor = Color3.new(1, 1, 1);
    Lighting.FogStart = 0;
    Lighting.FogEnd = 8;
    Lighting.Ambient = Color3.new(1, 1, 1);
    Lighting.OutdoorAmbient = Color3.new(1, 1, 1);
    Lighting.Brightness = math.max(Lighting.Brightness, 4);
    Lighting.ColorShift_Top = Color3.new(1, 1, 1);
    Lighting.ColorShift_Bottom = Color3.new(1, 1, 1);
end;

local function restoreLighting() -- Line: 73
    -- upvalues: u12 (ref), Lighting (copy)
    if not u12 then
        return;
    end;

    for i, v in pairs(u12) do
        pcall(function() -- Line: 76
            -- upvalues: Lighting (ref), i (copy), v (copy)
            Lighting[i] = v;
        end);
    end;

    u12 = nil;
end;

local function makeFlash() -- Line: 83
    -- upvalues: LocalPlayer (copy), u10 (ref), u3 (ref)
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "WitchSpiritFlash";
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.DisplayOrder = 100000;
    local Frame = Instance.new("Frame");
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.BackgroundColor3 = Color3.new(1, 1, 1);
    Frame.BorderSizePixel = 0;
    Frame.BackgroundTransparency = 1;
    Frame.Parent = ScreenGui;
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui");
    u10 = ScreenGui;
    task.spawn(function() -- Line: 97
        -- upvalues: u3 (ref), Frame (copy)
        for i = 1, 5 do
            if not (u3 and Frame.Parent) then
                return;
            end;

            Frame.BackgroundTransparency = i % 2 == 1 and 0 or 1;
            task.wait(0.1);
            local _ = i;
        end;

        if Frame.Parent then
            Frame.BackgroundTransparency = 1;
        end;
    end);
end;

local function setOwnTransparency(p24, p25) -- Line: 107
    -- upvalues: u8 (copy)
    if not p24 then
        return;
    end;

    for _, descendant in ipairs(p24:GetDescendants()) do
        if descendant:IsA("BasePart") then
            if p25 then
                if u8[descendant] == nil then
                    u8[descendant] = descendant.LocalTransparencyModifier;
                end;

                descendant.LocalTransparencyModifier = math.max(descendant.LocalTransparencyModifier, 0.72);
            else
                local v26 = u8[descendant];

                if v26 ~= nil then
                    descendant.LocalTransparencyModifier = v26;
                    u8[descendant] = nil;
                end;
            end;
        end;
    end;
end;

local function restoreAllTransparency() -- Line: 127
    -- upvalues: u8 (copy)
    for i, v in pairs(u8) do
        if i and (i.Parent and i:IsA("BasePart")) then
            i.LocalTransparencyModifier = v;
        end;

        u8[i] = nil;
    end;
end;

local function setChatBlocked(p27) -- Line: 136
    -- upvalues: TextChatService (copy), u13 (ref), u18 (copy), StarterGui (copy)
    local v28 = TextChatService:FindFirstChildOfClass("ChatInputBarConfiguration");

    if v28 then
        if p27 then
            if u13 == nil then
                u13 = v28.Enabled;
            end;

            v28.Enabled = false;
        elseif u13 ~= nil then
            v28.Enabled = u13;
            u13 = nil;
        end;
    end;

    for _, v in ipairs({ Enum.CoreGuiType.Chat, Enum.CoreGuiType.Backpack }) do
        if p27 then
            if u18[v] == nil then
                local success, result = pcall(function() -- Line: 151
                    -- upvalues: StarterGui (ref), v (copy)
                    return StarterGui:GetCoreGuiEnabled(v);
                end);

                if success then
                    u18[v] = result;
                end;
            end;

            pcall(function() -- Line: 154
                -- upvalues: StarterGui (ref), v (copy)
                StarterGui:SetCoreGuiEnabled(v, false);
            end);
        else
            local u29 = u18[v];

            if u29 ~= nil then
                pcall(function() -- Line: 158
                    -- upvalues: StarterGui (ref), v (copy), u29 (copy)
                    StarterGui:SetCoreGuiEnabled(v, u29);
                end);
                u18[v] = nil;
            end;
        end;
    end;
end;

local function setPromptBlocked(p30) -- Line: 165
    -- upvalues: u19 (copy)
    if p30 then
        for _, descendant in ipairs(workspace:GetDescendants()) do
            if descendant:IsA("ProximityPrompt") then
                if u19[descendant] == nil then
                    u19[descendant] = descendant.Enabled;
                end;

                descendant.Enabled = false;
            end;
        end;

        return;
    end;

    for i, v in pairs(u19) do
        if i and (i.Parent and i:IsA("ProximityPrompt")) then
            i.Enabled = v;
        end;

        u19[i] = nil;
    end;
end;

local function installResetOverride() -- Line: 185
    -- upvalues: u11 (ref), u3 (ref), WitchSpiritWorldRemote (copy), StarterGui (copy)
    if u11 then
        return;
    end;

    u11 = Instance.new("BindableEvent");
    u11.Name = "WitchSpiritReset";
    u11.Event:Connect(function() -- Line: 189
        -- upvalues: u3 (ref), WitchSpiritWorldRemote (ref)
        if u3 then
            WitchSpiritWorldRemote:FireServer("ExitRequest");
        end;
    end);
    task.spawn(function() -- Line: 194
        -- upvalues: u3 (ref), StarterGui (ref), u11 (ref)
        for i = 1, 30 do
            if not u3 then
                return;
            end;

            if pcall(function() -- Line: 197
                -- upvalues: StarterGui (ref), u11 (ref)
                StarterGui:SetCore("ResetButtonCallback", u11);
            end) then
                return;
            end;

            task.wait(0.1);
            local _ = i;
        end;
    end);
end;

local function restoreReset() -- Line: 206
    -- upvalues: StarterGui (copy), u11 (ref)
    pcall(function() -- Line: 207
        -- upvalues: StarterGui (ref)
        StarterGui:SetCore("ResetButtonCallback", true);
    end);

    if u11 then
        u11:Destroy();
        u11 = nil;
    end;
end;

local function createLocalSpirit() -- Line: 216
    -- upvalues: LocalPlayer (copy), Players (copy), SprintConfig (copy), u14 (ref), u15 (ref), u16 (ref)
    local Character = LocalPlayer.Character;
    local u31;

    if Character then
        u31 = Character:FindFirstChildOfClass("Humanoid");
    else
        u31 = Character;
    end;

    local v32;

    if Character then
        v32 = Character:FindFirstChild("HumanoidRootPart");
    else
        v32 = Character;
    end;

    local v33;

    if Character then
        v33 = Character:FindFirstChild("Animate");
    else
        v33 = Character;
    end;

    if not (Character and (u31 and v32)) then
        return false;
    end;

    local success, result = pcall(function() -- Line: 223
        -- upvalues: u31 (copy)
        return u31:GetAppliedDescription();
    end);

    if not (success and result) then
        return false;
    end;

    local success2, result2 = pcall(function() -- Line: 228
        -- upvalues: Players (ref), result (copy), u31 (copy)
        return Players:CreateHumanoidModelFromDescription(result, u31.RigType);
    end);

    if not (success2 and result2) then
        return false;
    end;

    result2.Name = LocalPlayer.Name .. "_SpiritLocal";
    result2:SetAttribute("SpiritWorldProxy", true);
    result2:SetAttribute("SpiritWorldActive", true);
    result2:SetAttribute("ActionLocked", true);
    result2:SetAttribute("Ragdolled", false);
    result2:SetAttribute("Hibernating", false);
    result2:SetAttribute("BeingCarried", false);
    result2:SetAttribute("Invulnerable", true);
    local v34 = result2:FindFirstChildOfClass("Humanoid");

    if not (v34 and result2:FindFirstChild("HumanoidRootPart")) then
        result2:Destroy();

        return false;
    end;

    for _, descendant in ipairs(result2:GetDescendants()) do
        if descendant:IsA("Script") or (descendant:IsA("LocalScript") or descendant:IsA("Tool")) then
            descendant:Destroy();
        elseif descendant:IsA("BasePart") then
            descendant.Transparency = math.max(descendant.Transparency, descendant.Name == "HumanoidRootPart" and 1 or 0.55);
            descendant.CanCollide = false;
            descendant.CanTouch = false;
            descendant.CanQuery = false;
        elseif descendant:IsA("BillboardGui") then
            descendant.Enabled = false;
        elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
            descendant.Transparency = math.max(descendant.Transparency, 0.45);
        end;
    end;

    v34.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None;
    v34.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff;
    v34.NameDisplayDistance = 0;
    v34.HealthDisplayDistance = 0;
    v34.WalkSpeed = SprintConfig.GetForTeam("Witches").WalkSpeed or 21;
    v34.AutoRotate = true;
    v34.PlatformStand = false;
    v34.Sit = false;
    result2:PivotTo(v32.CFrame * CFrame.new(0, 2.5, 0));
    result2.Parent = workspace;
    u14 = Character;
    u15 = result2;
    local workspace_CurrentCamera = workspace.CurrentCamera;
    local v35;

    if workspace_CurrentCamera then
        v35 = workspace_CurrentCamera.CameraSubject or nil;
    else
        v35 = nil;
    end;

    u16 = v35;
    LocalPlayer.Character = result2;

    if v33 and v33:IsA("LocalScript") then
        local v36 = v33:Clone();
        v36.Enabled = true;
        v36.Parent = result2;
    end;

    if workspace_CurrentCamera then
        workspace_CurrentCamera.CameraSubject = v34;
    end;

    return true;
end;

local function restoreLocalSpirit() -- Line: 289
    -- upvalues: u14 (ref), LocalPlayer (copy), u16 (ref), u15 (ref)
    local workspace_CurrentCamera = workspace.CurrentCamera;
    local v37 = u14;

    if v37 and v37.Parent then
        LocalPlayer.Character = v37;
        local v38 = v37:FindFirstChildOfClass("Humanoid");

        if workspace_CurrentCamera and v38 then
            workspace_CurrentCamera.CameraSubject = v38;
        end;
    elseif workspace_CurrentCamera and u16 then
        workspace_CurrentCamera.CameraSubject = u16;
    end;

    if u15 and u15.Parent then
        u15:Destroy();
    end;

    u15 = nil;
    u14 = nil;
    u16 = nil;
end;

local function enter() -- Line: 305
    -- upvalues: u3 (ref), u4 (ref), createLocalSpirit (copy), WitchSpiritWorldRemote (copy), u17 (ref), u12 (ref), Lighting (copy), applyWhiteWorld (copy), makeFlash (copy), setChatBlocked (copy), u19 (copy), installResetOverride (copy), setOwnTransparency (copy), u14 (ref), u15 (ref), u9 (ref), u2 (copy), u6 (copy), LocalPlayer (copy), u7 (copy), u8 (copy), u21 (ref), u22 (ref), UserInputService (copy), u20 (ref), u5 (ref), RunService (copy), SprintConfig (copy)
    if u3 or u4 then
        return;
    end;

    u4 = true;

    if not createLocalSpirit() then
        u4 = false;
        WitchSpiritWorldRemote:FireServer("ExitRequest");

        return;
    end;

    u3 = true;
    u4 = false;
    u17 = false;
    u12 = {
        FogColor = Lighting.FogColor,
        FogStart = Lighting.FogStart,
        FogEnd = Lighting.FogEnd,
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        Brightness = Lighting.Brightness,
        ColorShift_Top = Lighting.ColorShift_Top,
        ColorShift_Bottom = Lighting.ColorShift_Bottom
    };
    applyWhiteWorld();
    makeFlash();
    setChatBlocked(true);

    for _, descendant in ipairs(workspace:GetDescendants()) do
        if descendant:IsA("ProximityPrompt") then
            if u19[descendant] == nil then
                u19[descendant] = descendant.Enabled;
            end;

            descendant.Enabled = false;
        end;
    end;

    installResetOverride();
    setOwnTransparency(u14, true);
    setOwnTransparency(u15, true);
    u9 = u2:Clone();
    u9.Name = "SpiritWorldGroundDust";
    u9.Anchored = true;
    u9.CanCollide = false;
    u9.CanTouch = false;
    u9.CanQuery = false;
    u9.Transparency = 1;
    u9.Parent = workspace;
    table.insert(u6, workspace.DescendantAdded:Connect(function(p39) -- Line: 334
        -- upvalues: u3 (ref), u19 (ref)
        if p39:IsA("ProximityPrompt") and u3 then
            if u19[p39] == nil then
                u19[p39] = p39.Enabled;
            end;

            p39.Enabled = false;
        end;
    end));

    if LocalPlayer.Character then
        local v40 = u7;

        for _, v in ipairs(v40) do
            v:Disconnect();
        end;

        table.clear(v40);
        table.insert(u7, LocalPlayer.Character.DescendantAdded:Connect(function(p41) -- Line: 345
            -- upvalues: u3 (ref), u8 (ref)
            if not u3 then
                return;
            end;

            if not p41:IsA("BasePart") then
                if p41:IsA("BillboardGui") then
                    p41.Enabled = false;
                end;

                return;
            end;

            if u8[p41] == nil then
                u8[p41] = p41.LocalTransparencyModifier;
            end;

            p41.LocalTransparencyModifier = math.max(p41.LocalTransparencyModifier, 0.72);
            p41.CanCollide = false;
            p41.CanTouch = false;
            p41.CanQuery = false;
        end));
    end;

    local RaycastParams_new_ret = RaycastParams.new();
    RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Include;
    RaycastParams_new_ret.FilterDescendantsInstances = { workspace.Terrain };
    u21 = u15 and u15:GetPivot().Position or nil;
    u22 = u15 and u15:GetPivot() or nil;
    table.insert(u6, UserInputService.InputBegan:Connect(function(p42, p43) -- Line: 367
        -- upvalues: u3 (ref), u20 (ref)
        if not u3 or p43 then
            return;
        end;

        if p42.KeyCode == Enum.KeyCode.LeftShift or p42.KeyCode == Enum.KeyCode.RightShift then
            u20 = true;
        end;
    end));
    table.insert(u6, UserInputService.InputEnded:Connect(function(p44) -- Line: 373
        -- upvalues: u20 (ref)
        if p44.KeyCode == Enum.KeyCode.LeftShift or p44.KeyCode == Enum.KeyCode.RightShift then
            u20 = false;
        end;
    end));
    u5 = RunService.RenderStepped:Connect(function() -- Line: 379
        -- upvalues: u3 (ref), applyWhiteWorld (ref), u15 (ref), SprintConfig (ref), u20 (ref), RaycastParams_new_ret (copy), u22 (ref), u21 (ref), u17 (ref), WitchSpiritWorldRemote (ref), u9 (ref)
        if not u3 then
            return;
        end;

        applyWhiteWorld();
        local v45 = u15;
        local v46;

        if v45 then
            v46 = v45:FindFirstChild("HumanoidRootPart");
        else
            v46 = v45;
        end;

        local v47;

        if v45 then
            v47 = v45:FindFirstChildOfClass("Humanoid");
        else
            v47 = v45;
        end;

        if v45 then
            for _, descendant in ipairs(v45:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    descendant.CanCollide = false;
                    descendant.CanTouch = false;
                    descendant.CanQuery = false;
                elseif descendant:IsA("BillboardGui") then
                    descendant.Enabled = false;
                end;
            end;
        end;

        if v46 and v47 then
            local ForTeam = SprintConfig.GetForTeam("Witches");
            local v48;

            if u20 then
                v48 = ForTeam.SprintSpeed or 38;
            else
                v48 = ForTeam.WalkSpeed or 21;
            end;

            v47.WalkSpeed = v48;
            v47.AutoRotate = true;
            local v49 = workspace:Raycast(v46.Position + Vector3.new(0, 8, 0), Vector3.new(0, -24, 0), RaycastParams_new_ret);

            if v49 and v49.Normal.Y > 0.2 then
                local v50 = v49.Position.Y + v47.HipHeight + v46.Size.Y * 0.5;

                if v46.Position.Y < v50 then
                    local CFrame2 = v46.CFrame;
                    v46.CFrame = CFrame.new(CFrame2.X, v50, CFrame2.Z) * CFrame2.Rotation;
                    local X = v46.AssemblyLinearVelocity.X;
                    local math_max_ret = math.max(0, v46.AssemblyLinearVelocity.Y);
                    v46.AssemblyLinearVelocity = Vector3.new(X, math_max_ret, v46.AssemblyLinearVelocity.Z);
                    v47:ChangeState(Enum.HumanoidStateType.Running);
                end;

                u22 = v46.CFrame;
            elseif u22 and v46.Position.Y <= workspace.FallenPartsDestroyHeight + 30 then
                v46.CFrame = u22;
                v46.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
                v47:ChangeState(Enum.HumanoidStateType.Running);
            end;

            u21 = v46.Position;
        end;

        if not (u17 or v45 and (v45.Parent and (v46 and v46.Position.Y > workspace.FallenPartsDestroyHeight + 8))) then
            u17 = true;
            WitchSpiritWorldRemote:FireServer("ExitRequest", "Void");
        end;

        if v46 and (u9 and u9.Parent) then
            local v51 = v46.Position.Y - 3;
            local RaycastParams_new_ret2 = RaycastParams.new();
            RaycastParams_new_ret2.FilterType = Enum.RaycastFilterType.Exclude;
            RaycastParams_new_ret2.FilterDescendantsInstances = v45 and { v45 } or {};
            local v52 = workspace:Raycast(v46.Position + Vector3.new(0, 5, 0), Vector3.new(0, -30, 0), RaycastParams_new_ret2);

            if v52 then
                v51 = v52.Position.Y + 0.05;
            end;

            u9.CFrame = CFrame.new(v46.Position.X, v51, v46.Position.Z);
        end;
    end);
end;

local function exit() -- Line: 435
    -- upvalues: u3 (ref), u4 (ref), u17 (ref), u20 (ref), u21 (ref), u22 (ref), LocalPlayer (copy), u5 (ref), u6 (copy), u7 (copy), u9 (ref), u10 (ref), restoreAllTransparency (copy), setChatBlocked (copy), u19 (copy), restoreReset (copy), restoreLighting (copy), restoreLocalSpirit (copy)
    if not (u3 or u4) then
        return;
    end;

    u3 = false;
    u4 = false;
    u17 = false;
    u20 = false;
    u21 = nil;
    u22 = nil;
    LocalPlayer:SetAttribute("SpiritWorldClientCleanupStep", "Start");

    if u5 then
        u5:Disconnect();
        u5 = nil;
    end;

    local v53 = u6;

    for _, v in ipairs(v53) do
        v:Disconnect();
    end;

    table.clear(v53);
    local v54 = u7;

    for _, v in ipairs(v54) do
        v:Disconnect();
    end;

    table.clear(v54);
    LocalPlayer:SetAttribute("SpiritWorldClientCleanupStep", "Effects");

    if u9 then
        pcall(function() -- Line: 454
            -- upvalues: u9 (ref)
            if u9.Parent then
                u9:Destroy();
            end;
        end);
        u9 = nil;
    end;

    for _, child in ipairs(workspace:GetChildren()) do
        if child.Name == "SpiritWorldGroundDust" or child.Name == LocalPlayer.Name .. "_SpiritLocal" then
            pcall(function() -- Line: 459
                -- upvalues: child (copy)
                child:Destroy();
            end);
        end;
    end;

    if u10 then
        pcall(function() -- Line: 463
            -- upvalues: u10 (ref)
            if u10.Parent then
                u10:Destroy();
            end;
        end);
        u10 = nil;
    end;

    LocalPlayer:SetAttribute("SpiritWorldClientCleanupStep", "Visuals");
    pcall(restoreAllTransparency);
    pcall(function() -- Line: 469
        -- upvalues: setChatBlocked (ref)
        setChatBlocked(false);
    end);
    pcall(function() -- Line: 470
        -- upvalues: u19 (ref)
        for i, v in pairs(u19) do
            if i and (i.Parent and i:IsA("ProximityPrompt")) then
                i.Enabled = v;
            end;

            u19[i] = nil;
        end;
    end);
    pcall(restoreReset);
    pcall(restoreLighting);
    LocalPlayer:SetAttribute("SpiritWorldClientCleanupStep", "Character");
    pcall(restoreLocalSpirit);
    LocalPlayer:SetAttribute("SpiritWorldClientCleanupStep", "Done");
end;

WitchSpiritWorldRemote.OnClientEvent:Connect(function(p55) -- Line: 480
    -- upvalues: enter (copy), exit (copy)
    if p55 == "Enter" then
        enter();

        return;
    end;

    if p55 == "Exit" then
        exit();
    end;
end);
LocalPlayer:GetAttributeChangedSignal("SpiritWorldActive"):Connect(function() -- Line: 488
    -- upvalues: LocalPlayer (copy), enter (copy), exit (copy)
    if LocalPlayer:GetAttribute("SpiritWorldActive") == true then
        enter();

        return;
    end;

    exit();
end);
LocalPlayer.CharacterAdded:Connect(function(p56) -- Line: 496
    -- upvalues: u3 (ref), setOwnTransparency (copy), u7 (copy), u8 (copy), exit (copy)
    if not u3 or p56:GetAttribute("SpiritWorldProxy") ~= true then
        if u3 then
            exit();
        end;

        return;
    end;

    setOwnTransparency(p56, true);
    local v57 = u7;

    for _, v in ipairs(v57) do
        v:Disconnect();
    end;

    table.clear(v57);
    table.insert(u7, p56.DescendantAdded:Connect(function(p58) -- Line: 500
        -- upvalues: u3 (ref), u8 (ref)
        if u3 and p58:IsA("BasePart") then
            if u8[p58] == nil then
                u8[p58] = p58.LocalTransparencyModifier;
            end;

            p58.LocalTransparencyModifier = math.max(p58.LocalTransparencyModifier, 0.72);
        end;
    end));
end);

if LocalPlayer:GetAttribute("SpiritWorldActive") == true then
    enter();
end;
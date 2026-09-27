-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local LocalPlayer = Players.LocalPlayer;
local script_Parent = script.Parent;
local Powers = script_Parent:WaitForChild("Powers");
local v1 = ReplicatedStorage:WaitForChild("Funções");
local Eventos = v1:WaitForChild("Eventos");
local MobileHudLayoutRemote = Eventos:WaitForChild("MobileHudLayoutRemote");
local SprintRequest = Eventos:WaitForChild("SprintRequest");
local SprintConfig = require(v1:WaitForChild("SprintConfig"));
local u2 = { {
        ui = "RUN",
        save = "VampireRun",
        x = 0.13,
        y = 0.42
    }, {
        ui = "DROP",
        save = "VampireDrop",
        x = 0.13,
        y = 0.6
    }, {
        ui = "BreakNeck",
        save = "VampireBreakNeck",
        x = 0.29,
        y = 0.61
    }, {
        ui = "Track",
        save = "VampireTrack",
        x = 0.38,
        y = 0.61
    }, {
        ui = "DrinkBlood",
        save = "VampireDrinkBlood",
        x = 0.47,
        y = 0.61
    }, {
        ui = "Infect",
        save = "VampireInfect",
        x = 0.56,
        y = 0.61
    }, {
        ui = "Hipnose",
        save = "VampireHipnose",
        x = 0.65,
        y = 0.61
    }, {
        ui = "Heart-Ripping",
        save = "VampireHeartRipping",
        x = 0.74,
        y = 0.61
    }, {
        ui = "Sleep",
        save = "VampireSleep",
        x = 0.83,
        y = 0.61
    }, {
        ui = "ShiftLock",
        save = "VampireShiftLock",
        x = 0.84,
        y = 0.2
    }, {
        ui = "LockOn",
        save = "VampireLockOn",
        x = 0.75,
        y = 0.2
    } };
local u3 = {};

for _, v in ipairs(u2) do
    v.button = Powers:WaitForChild(v.ui);
    v.button.Active = true;

    if v.button:IsA("GuiButton") then
        v.button.Interactable = true;
    end;

    u3[v.save] = v;
end;

local RUN = Powers:WaitForChild("RUN");
local ImageColor3 = RUN.ImageColor3;
local u4 = false;

local function getRunSpeeds() -- Line: 60
    -- upvalues: LocalPlayer (copy), SprintConfig (copy)
    local v5 = LocalPlayer.Team and LocalPlayer.Team.Name or "Humans";
    local ForPlayer = SprintConfig.GetForPlayer(v5, LocalPlayer:GetAttribute("VampireOrigin"), LocalPlayer:GetAttribute("Years"), LocalPlayer);
    local v6 = v5 == "Humans" and (tonumber(LocalPlayer:GetAttribute("SpeedBonus")) or 0) or 0;
    local v7 = tonumber(LocalPlayer:GetAttribute("StrengthSpeedMultiplier")) or 1;
    local v8 = v6 * math.clamp(v7, 1, 1.2);

    return (tonumber(ForPlayer.WalkSpeed) or 16) + v8, (tonumber(ForPlayer.SprintSpeed) or 24) + v8;
end;

local function applyRunSpeed(p9) -- Line: 75
    -- upvalues: LocalPlayer (copy), getRunSpeeds (copy)
    local Character = LocalPlayer.Character;
    local v10;

    if Character then
        v10 = Character:FindFirstChildOfClass("Humanoid");
    else
        v10 = Character;
    end;

    if not v10 then
        return;
    end;

    if Character:GetAttribute("ActionLocked") == true or Character:GetAttribute("Petrified") == true then
        v10.WalkSpeed = 0;

        return;
    end;

    local v11, v12 = getRunSpeeds();

    if p9 then
        v11 = v12 or v11;
    end;

    v10.WalkSpeed = v11;
end;

local function updateRunVisual() -- Line: 89
    -- upvalues: RUN (copy), u4 (ref), ImageColor3 (copy)
    RUN:SetAttribute("RunEnabled", u4);
    RUN.ImageColor3 = u4 and Color3.fromRGB(125, 255, 150) or ImageColor3;
end;

local function stopRunning() -- Line: 94
    -- upvalues: u4 (ref), SprintRequest (copy), applyRunSpeed (copy), RUN (copy), ImageColor3 (copy)
    if u4 then
        u4 = false;
        SprintRequest:FireServer(false);
    end;

    applyRunSpeed(false);
    RUN:SetAttribute("RunEnabled", u4);
    RUN.ImageColor3 = u4 and Color3.fromRGB(125, 255, 150) or ImageColor3;
end;

local Vector2_zero = Vector2.zero;
local Vector2_zero2 = Vector2.zero;

local function viewport() -- Line: 110
    local workspace_CurrentCamera = workspace.CurrentCamera;

    return workspace_CurrentCamera and workspace_CurrentCamera.ViewportSize or Vector2.new(750, 361);
end;

local function clampPosition(p13, p14, p15) -- Line: 115
    local workspace_CurrentCamera = workspace.CurrentCamera;
    local v16 = workspace_CurrentCamera and workspace_CurrentCamera.ViewportSize or Vector2.new(750, 361);
    local v17 = p15.AbsoluteSize * 0.5;
    local v18 = (v17.X + 6) / math.max(v16.X, 1);
    local math_clamp_ret = math.clamp(v18, 0.02, 0.48);
    local v19 = (v17.Y + 6) / math.max(v16.Y, 1);
    local math_clamp_ret2 = math.clamp(v19, 0.02, 0.48);

    return math.clamp(p13, math_clamp_ret, 1 - math_clamp_ret), math.clamp(p14, math_clamp_ret2, 1 - math_clamp_ret2);
end;

local function place(p20, p21, p22) -- Line: 123
    -- upvalues: Powers (copy)
    local button = p20.button;
    local workspace_CurrentCamera = workspace.CurrentCamera;
    local v23 = workspace_CurrentCamera and workspace_CurrentCamera.ViewportSize or Vector2.new(750, 361);
    local workspace_CurrentCamera2 = workspace.CurrentCamera;
    local v24 = workspace_CurrentCamera2 and workspace_CurrentCamera2.ViewportSize or Vector2.new(750, 361);
    local v25 = button.AbsoluteSize * 0.5;
    local v26 = (v25.X + 6) / math.max(v24.X, 1);
    local math_clamp_ret = math.clamp(v26, 0.02, 0.48);
    local v27 = (v25.Y + 6) / math.max(v24.Y, 1);
    local math_clamp_ret2 = math.clamp(v27, 0.02, 0.48);
    local math_clamp_ret3 = math.clamp(p21, math_clamp_ret, 1 - math_clamp_ret);
    local math_clamp_ret4 = math.clamp(p22, math_clamp_ret2, 1 - math_clamp_ret2);
    local v28 = Vector2.new(v23.X * math_clamp_ret3, v23.Y * math_clamp_ret4) - Powers.AbsolutePosition;
    button.AnchorPoint = Vector2.new(0.5, 0.5);
    button.Position = UDim2.fromOffset(v28.X, v28.Y);
    button:SetAttribute("NormalizedX", math_clamp_ret3);
    button:SetAttribute("NormalizedY", math_clamp_ret4);
end;

local function updateLayout() -- Line: 135
    -- upvalues: script_Parent (copy), Powers (copy), u2 (copy), place (copy)
    local workspace_CurrentCamera = workspace.CurrentCamera;
    local v29 = workspace_CurrentCamera and workspace_CurrentCamera.ViewportSize or Vector2.new(750, 361);

    if v29.X < 200 or v29.Y < 160 then
        return;
    end;

    script_Parent.AnchorPoint = Vector2.zero;
    script_Parent.Position = UDim2.fromScale(0, 0);
    script_Parent.Size = UDim2.fromScale(1, 1);
    script_Parent.BackgroundTransparency = 1;
    script_Parent.ClipsDescendants = false;
    Powers.AnchorPoint = Vector2.zero;
    Powers.Position = UDim2.fromScale(0, 0);
    Powers.Size = UDim2.fromScale(1, 1);
    Powers.BackgroundTransparency = 1;
    Powers.ClipsDescendants = false;
    local math_min_ret = math.min(v29.X * 0.075, v29.Y * 0.15);
    local math_clamp_ret = math.clamp(math_min_ret, 28, 58);

    for _, v in ipairs(u2) do
        local button = v.button;
        button.Size = UDim2.fromOffset(math_clamp_ret, math_clamp_ret);
        button.ScaleType = Enum.ScaleType.Fit;
        button.ZIndex = math.max(button.ZIndex, 20);
        place(v, tonumber(button:GetAttribute("NormalizedX")) or v.x, tonumber(button:GetAttribute("NormalizedY")) or v.y);
    end;
end;

local function saveAll() -- Line: 161
    -- upvalues: u2 (copy), MobileHudLayoutRemote (copy)
    local u30 = {};

    for _, v in ipairs(u2) do
        local v31 = tonumber(v.button:GetAttribute("NormalizedX"));
        local v32 = tonumber(v.button:GetAttribute("NormalizedY"));

        if v31 and v32 then
            u30[v.save] = {
                X = v31,
                Y = v32
            };
        end;
    end;

    if next(u30) then
        pcall(function() -- Line: 171
            -- upvalues: MobileHudLayoutRemote (ref), u30 (copy)
            MobileHudLayoutRemote:InvokeServer("Merge", u30);
        end);
    end;
end;

local u33 = nil;
local u34 = nil;
local u35 = false;
local u36 = nil;

local function canRun() -- Line: 42
    -- upvalues: LocalPlayer (copy), UserInputService (copy), script_Parent (copy)
    local Character = LocalPlayer.Character;
    local v37;

    if Character then
        v37 = Character:FindFirstChildOfClass("Humanoid");
    else
        v37 = Character;
    end;

    local v38 = UserInputService.TouchEnabled and script_Parent.Visible;

    if v38 then
        if LocalPlayer:GetAttribute("MobileHudEditMode") == true or (v37 == nil or (v37.Health <= 0 or (Character:GetAttribute("Hibernating") == true or (Character:GetAttribute("ActionLocked") == true or (Character:GetAttribute("Ragdolled") == true or (Character:GetAttribute("HypnosisPossessing") == true or (Character:GetAttribute("FlyingBroom") == true or (Character:GetAttribute("BatFormActive") == true or Character:GetAttribute("BatFormTransforming") == true)))))))) then
            v38 = false;
        else
            v38 = (tonumber(LocalPlayer:GetAttribute("Stamina")) or 0) > 0;
        end;
    end;

    return v38;
end;

local function restore() -- Line: 177
    -- upvalues: LocalPlayer (copy), MobileHudLayoutRemote (copy), u3 (copy), updateLayout (copy)
    while LocalPlayer.Parent and LocalPlayer:GetAttribute("DataLoaded") ~= true do
        LocalPlayer:GetAttributeChangedSignal("DataLoaded"):Wait();
    end;

    if not LocalPlayer.Parent then
        return;
    end;

    local success, result = pcall(function() -- Line: 182
        -- upvalues: MobileHudLayoutRemote (ref)
        return MobileHudLayoutRemote:InvokeServer("Load");
    end);

    if success and type(result) == "table" then
        for i, v in pairs(u3) do
            local v39 = result[i];
            local v40;

            if type(v39) == "table" then
                v40 = tonumber(v39.X);
            else
                v40 = false;
            end;

            local v41;

            if type(v39) == "table" then
                v41 = tonumber(v39.Y);
            else
                v41 = false;
            end;

            if v40 and v41 then
                v.button:SetAttribute("CustomPosition", true);
                v.button:SetAttribute("NormalizedX", v40);
                v.button:SetAttribute("NormalizedY", v41);
            end;
        end;
    end;

    updateLayout();
end;

for _, v in ipairs(u2) do
    local button = v.button;
    button.InputBegan:Connect(function(u42) -- Line: 202
        -- upvalues: LocalPlayer (copy), u33 (ref), u34 (ref), v (copy), Vector2_zero (ref), Vector2_zero2 (ref), button (copy), u35 (ref), script_Parent (copy), saveAll (copy)
        if LocalPlayer:GetAttribute("MobileHudEditMode") ~= true or (u42.UserInputType ~= Enum.UserInputType.Touch or u33 ~= nil) then
            return;
        end;

        u33 = u42;
        u34 = v;
        Vector2_zero = Vector2.new(u42.Position.X, u42.Position.Y);
        Vector2_zero2 = button.AbsolutePosition + button.AbsoluteSize * 0.5;
        u35 = true;
        script_Parent:SetAttribute("IsDragging", true);
        u42.Changed:Connect(function() -- Line: 214
            -- upvalues: u42 (copy), u33 (ref), u34 (ref), u35 (ref), script_Parent (ref), saveAll (ref)
            if u42.UserInputState == Enum.UserInputState.End and u33 == u42 then
                u33 = nil;
                u34 = nil;
                u35 = false;
                script_Parent:SetAttribute("IsDragging", false);
                task.spawn(saveAll);
            end;
        end);
    end);
end;

UserInputService.InputChanged:Connect(function(p43) -- Line: 226
    -- upvalues: u35 (ref), u33 (ref), u34 (ref), Vector2_zero2 (ref), Vector2_zero (ref), place (copy)
    if not (u35 and (p43 == u33 and u34)) then
        return;
    end;

    local workspace_CurrentCamera = workspace.CurrentCamera;
    local v44 = workspace_CurrentCamera and workspace_CurrentCamera.ViewportSize or Vector2.new(750, 361);
    local v45 = Vector2_zero2 + (Vector2.new(p43.Position.X, p43.Position.Y) - Vector2_zero);
    local button = u34.button;
    local v46 = button.AbsoluteSize * 0.5;
    local Vector2_new_ret = Vector2.new(math.clamp(v45.X, v46.X + 6, v44.X - v46.X - 6), (math.clamp(v45.Y, v46.Y + 6, v44.Y - v46.Y - 6)));
    local v47 = Vector2_new_ret.X / v44.X;
    local v48 = Vector2_new_ret.Y / v44.Y;
    local workspace_CurrentCamera2 = workspace.CurrentCamera;
    local v49 = workspace_CurrentCamera2 and workspace_CurrentCamera2.ViewportSize or Vector2.new(750, 361);
    local v50 = button.AbsoluteSize * 0.5;
    local v51 = (v50.X + 6) / math.max(v49.X, 1);
    local math_clamp_ret = math.clamp(v51, 0.02, 0.48);
    local v52 = (v50.Y + 6) / math.max(v49.Y, 1);
    local math_clamp_ret2 = math.clamp(v52, 0.02, 0.48);
    local math_clamp_ret3 = math.clamp(v47, math_clamp_ret, 1 - math_clamp_ret);
    local math_clamp_ret4 = math.clamp(v48, math_clamp_ret2, 1 - math_clamp_ret2);
    button:SetAttribute("CustomPosition", true);
    place(u34, math_clamp_ret3, math_clamp_ret4);
end);
RUN.Activated:Connect(function() -- Line: 242
    -- upvalues: script_Parent (copy), LocalPlayer (copy), canRun (copy), u4 (ref), SprintRequest (copy), applyRunSpeed (copy), RUN (copy), ImageColor3 (copy)
    if script_Parent:GetAttribute("IsDragging") == true or LocalPlayer:GetAttribute("MobileHudEditMode") == true then
        return;
    end;

    if not canRun() then
        if u4 then
            u4 = false;
            SprintRequest:FireServer(false);
        end;

        applyRunSpeed(false);
        RUN:SetAttribute("RunEnabled", u4);
        RUN.ImageColor3 = u4 and Color3.fromRGB(125, 255, 150) or ImageColor3;

        return;
    end;

    u4 = not u4;
    applyRunSpeed(u4);
    SprintRequest:FireServer(u4);
    RUN:SetAttribute("RunEnabled", u4);
    RUN.ImageColor3 = u4 and Color3.fromRGB(125, 255, 150) or ImageColor3;
end);
LocalPlayer:GetAttributeChangedSignal("MobileHudEditMode"):Connect(function() -- Line: 256
    -- upvalues: LocalPlayer (copy), saveAll (copy), u33 (ref), u34 (ref), u35 (ref), script_Parent (copy)
    if LocalPlayer:GetAttribute("MobileHudEditMode") ~= true then
        task.spawn(saveAll);
    end;

    u33 = nil;
    u34 = nil;
    u35 = false;
    script_Parent:SetAttribute("IsDragging", false);
end);
LocalPlayer:GetAttributeChangedSignal("MobileHudResetRevision"):Connect(function() -- Line: 266
    -- upvalues: u2 (copy), updateLayout (copy)
    for _, v in ipairs(u2) do
        v.button:SetAttribute("CustomPosition", false);
        v.button:SetAttribute("NormalizedX", nil);
        v.button:SetAttribute("NormalizedY", nil);
    end;

    updateLayout();
end);

local function bindViewport() -- Line: 275
    -- upvalues: u36 (ref), updateLayout (copy)
    if u36 then
        u36:Disconnect();
    end;

    updateLayout();
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if workspace_CurrentCamera then
        u36 = workspace_CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateLayout);
    end;
end;

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindViewport);
LocalPlayer.CharacterAdded:Connect(function() -- Line: 286
    -- upvalues: u4 (ref), SprintRequest (copy), applyRunSpeed (copy), RUN (copy), ImageColor3 (copy), updateLayout (copy)
    if u4 then
        u4 = false;
        SprintRequest:FireServer(false);
    end;

    applyRunSpeed(false);
    RUN:SetAttribute("RunEnabled", u4);
    RUN.ImageColor3 = u4 and Color3.fromRGB(125, 255, 150) or ImageColor3;
    task.defer(updateLayout);
end);
LocalPlayer:GetAttributeChangedSignal("Stamina"):Connect(function() -- Line: 291
    -- upvalues: u4 (ref), canRun (copy), SprintRequest (copy), applyRunSpeed (copy), RUN (copy), ImageColor3 (copy)
    if u4 and not canRun() then
        if u4 then
            u4 = false;
            SprintRequest:FireServer(false);
        end;

        applyRunSpeed(false);
        RUN:SetAttribute("RunEnabled", u4);
        RUN.ImageColor3 = u4 and Color3.fromRGB(125, 255, 150) or ImageColor3;
    end;
end);
script_Parent:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 297
    -- upvalues: script_Parent (copy), u4 (ref), SprintRequest (copy), applyRunSpeed (copy), RUN (copy), ImageColor3 (copy)
    if not script_Parent.Visible then
        if u4 then
            u4 = false;
            SprintRequest:FireServer(false);
        end;

        applyRunSpeed(false);
        RUN:SetAttribute("RunEnabled", u4);
        RUN.ImageColor3 = u4 and Color3.fromRGB(125, 255, 150) or ImageColor3;
    end;
end);
script_Parent:SetAttribute("IsDragging", false);

if u36 then
    u36:Disconnect();
end;

updateLayout();
local workspace_CurrentCamera = workspace.CurrentCamera;

if workspace_CurrentCamera then
    u36 = workspace_CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateLayout);
end;

RUN:SetAttribute("RunEnabled", u4);
local v53;

if u4 then
    v53 = Color3.fromRGB(125, 255, 150) or ImageColor3;
else
    v53 = ImageColor3;
end;

RUN.ImageColor3 = v53;
task.spawn(restore);
task.spawn(function() -- Line: 308
    -- upvalues: u4 (ref), canRun (copy), SprintRequest (copy), applyRunSpeed (copy), RUN (copy), ImageColor3 (copy)
    while script.Parent do
        if u4 and not canRun() then
            if u4 then
                u4 = false;
                SprintRequest:FireServer(false);
            end;

            applyRunSpeed(false);
            RUN:SetAttribute("RunEnabled", u4);
            RUN.ImageColor3 = u4 and Color3.fromRGB(125, 255, 150) or ImageColor3;
        end;

        task.wait(0.2);
    end;
end);
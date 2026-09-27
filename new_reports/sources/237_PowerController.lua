-- Decompiled with Potassium's decompiler.

local TeamGuiLayout = require(game:GetService("ReplicatedStorage"):WaitForChild("TeamGuiLayout"));
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local LocalPlayer = Players.LocalPlayer;
local script_Parent = script.Parent;
local Parent = script_Parent.Parent;
local v1 = ReplicatedStorage:WaitForChild("Funções");
local Eventos = v1:WaitForChild("Eventos");
local SprintRequest = Eventos:WaitForChild("SprintRequest");
local MobileHudLayoutRemote = Eventos:WaitForChild("MobileHudLayoutRemote");
local SprintConfig = require(v1:WaitForChild("SprintConfig"));
local AltShiftLock = require(v1:WaitForChild("AltShiftLock"));
local u2 = { {
        ui = "RUN",
        save = "WitchRun",
        x = 0.13,
        y = 0.42
    }, {
        ui = "DROP",
        save = "WitchDrop",
        x = 0.13,
        y = 0.6
    }, {
        ui = "PainInfliction",
        save = "WitchPainInfliction",
        x = 0.29,
        y = 0.61
    }, {
        ui = "Soul",
        save = "WitchSoul",
        x = 0.38,
        y = 0.61
    }, {
        ui = "incendia",
        save = "WitchIncendia",
        x = 0.47,
        y = 0.61
    }, {
        ui = "BreakNeck",
        save = "WitchBreakNeck",
        x = 0.56,
        y = 0.61
    }, {
        ui = "Petrification",
        save = "WitchPetrification",
        x = 0.65,
        y = 0.61
    }, {
        ui = "Heart-Ripping",
        save = "WitchHeartRipping",
        x = 0.74,
        y = 0.61
    }, {
        ui = "Invisible",
        save = "WitchInvisible",
        x = 0.83,
        y = 0.61
    }, {
        ui = "ShiftLock",
        save = "WitchShiftLock",
        x = 0.84,
        y = 0.2
    }, {
        ui = "LockOn",
        save = "WitchLockOn",
        x = 0.75,
        y = 0.2
    } };
local u3 = {};

for _, v in ipairs(u2) do
    v.button = script_Parent:WaitForChild(v.ui);
    v.button.Active = true;

    if v.button:IsA("GuiButton") then
        v.button.Interactable = true;
    end;

    u3[v.save] = v;
end;

local RUN = script_Parent:WaitForChild("RUN");
local ShiftLock = script_Parent:WaitForChild("ShiftLock");
local ImageColor3 = RUN.ImageColor3;
local ImageColor32 = ShiftLock.ImageColor3;
local u4 = false;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = false;
local u9 = false;
local u10 = 0;
local Vector2_zero = Vector2.zero;
local Vector2_zero2 = Vector2.zero;
local u11 = 0;

local function isHudEditMode() -- Line: 60
    -- upvalues: UserInputService (copy), LocalPlayer (copy)
    local v12 = UserInputService.TouchEnabled and LocalPlayer:GetAttribute("MobileHudEditMode") == true;

    return v12;
end;

local function isWitch() -- Line: 64
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer.Team and LocalPlayer.Team.Name == "Witches";
end;

local function shouldShow() -- Line: 68
    -- upvalues: TeamGuiLayout (copy), LocalPlayer (copy)
    local v13;

    if TeamGuiLayout.GetMode() == "MOBILE" then
        v13 = LocalPlayer.Team and LocalPlayer.Team.Name == "Witches";
    else
        v13 = false;
    end;

    return v13;
end;

local function canUseControls() -- Line: 72
    -- upvalues: LocalPlayer (copy), TeamGuiLayout (copy)
    local Character = LocalPlayer.Character;
    local v14;

    if Character then
        v14 = Character:FindFirstChildOfClass("Humanoid");
    else
        v14 = Character;
    end;

    local v15;

    if TeamGuiLayout.GetMode() == "MOBILE" then
        v15 = LocalPlayer.Team and LocalPlayer.Team.Name == "Witches";
    else
        v15 = false;
    end;

    if v15 then
        if v14 == nil or (v14.Health <= 0 or (Character:GetAttribute("Hibernating") == true or (Character:GetAttribute("ActionLocked") == true or Character:GetAttribute("Ragdolled") == true))) then
            v15 = false;
        else
            v15 = Character:GetAttribute("HypnosisPossessing") ~= true;
        end;
    end;

    return v15;
end;

local function canRun() -- Line: 84
    -- upvalues: LocalPlayer (copy), canUseControls (copy)
    local Character = LocalPlayer.Character;
    local v16 = canUseControls();

    if v16 then
        if Character == nil or Character:GetAttribute("FlyingBroom") == true then
            v16 = false;
        else
            v16 = (tonumber(LocalPlayer:GetAttribute("Stamina")) or 0) > 0;
        end;
    end;

    return v16;
end;

local function getRunSpeeds() -- Line: 92
    -- upvalues: LocalPlayer (copy), SprintConfig (copy)
    local v17 = LocalPlayer.Team and LocalPlayer.Team.Name or "Humans";
    local ForPlayer = SprintConfig.GetForPlayer(v17, LocalPlayer:GetAttribute("VampireOrigin"), LocalPlayer:GetAttribute("Years"), LocalPlayer);
    local v18 = v17 == "Humans" and (tonumber(LocalPlayer:GetAttribute("SpeedBonus")) or 0) or 0;
    local v19 = tonumber(LocalPlayer:GetAttribute("StrengthSpeedMultiplier")) or 1;
    local v20 = v18 * math.clamp(v19, 1, 1.2);

    return (tonumber(ForPlayer.WalkSpeed) or 16) + v20, (tonumber(ForPlayer.SprintSpeed) or 24) + v20;
end;

local function applyRunSpeed(p21) -- Line: 107
    -- upvalues: LocalPlayer (copy), getRunSpeeds (copy)
    local Character = LocalPlayer.Character;
    local v22;

    if Character then
        v22 = Character:FindFirstChildOfClass("Humanoid");
    else
        v22 = Character;
    end;

    if not v22 then
        return;
    end;

    if Character:GetAttribute("ActionLocked") == true or Character:GetAttribute("Petrified") == true then
        v22.WalkSpeed = 0;

        return;
    end;

    local v23, v24 = getRunSpeeds();

    if p21 then
        v23 = v24 or v23;
    end;

    v22.WalkSpeed = v23;
end;

local function stopRunning() -- Line: 121
    -- upvalues: u4 (ref), SprintRequest (copy), applyRunSpeed (copy)
    if u4 then
        u4 = false;
        SprintRequest:FireServer(false);
    end;

    applyRunSpeed(false);
end;

local function updateVisuals() -- Line: 129
    -- upvalues: TeamGuiLayout (copy), LocalPlayer (copy), RUN (copy), u4 (ref), ImageColor3 (copy), AltShiftLock (copy), ShiftLock (copy), ImageColor32 (copy)
    local v25;

    if TeamGuiLayout.GetMode() == "MOBILE" then
        v25 = LocalPlayer.Team and LocalPlayer.Team.Name == "Witches";
    else
        v25 = false;
    end;

    RUN:SetAttribute("RunEnabled", u4 and v25);
    RUN.ImageColor3 = u4 and Color3.fromRGB(125, 255, 150) or ImageColor3;
    local v26 = AltShiftLock.IsLocked();
    ShiftLock:SetAttribute("ShiftLockEnabled", v26);
    ShiftLock.ImageColor3 = v26 and Color3.fromRGB(125, 255, 150) or ImageColor32;
end;

local function getViewport() -- Line: 141
    local workspace_CurrentCamera = workspace.CurrentCamera;

    return workspace_CurrentCamera and workspace_CurrentCamera.ViewportSize or Vector2.new(750, 361);
end;

local function clampNormalizedPosition(p27, p28, p29) -- Line: 146
    local workspace_CurrentCamera = workspace.CurrentCamera;
    local v30 = workspace_CurrentCamera and workspace_CurrentCamera.ViewportSize or Vector2.new(750, 361);
    local v31 = p29.AbsoluteSize * 0.5;
    local v32 = (v31.X + 6) / math.max(v30.X, 1);
    local math_clamp_ret = math.clamp(v32, 0.02, 0.48);
    local v33 = (v31.Y + 6) / math.max(v30.Y, 1);
    local math_clamp_ret2 = math.clamp(v33, 0.02, 0.48);

    return math.clamp(p27, math_clamp_ret, 1 - math_clamp_ret), math.clamp(p28, math_clamp_ret2, 1 - math_clamp_ret2);
end;

local function placeButtonAtScreenPosition(p34, p35, p36) -- Line: 157
    -- upvalues: script_Parent (copy)
    local workspace_CurrentCamera = workspace.CurrentCamera;
    local v37 = workspace_CurrentCamera and workspace_CurrentCamera.ViewportSize or Vector2.new(750, 361);
    local workspace_CurrentCamera2 = workspace.CurrentCamera;
    local v38 = workspace_CurrentCamera2 and workspace_CurrentCamera2.ViewportSize or Vector2.new(750, 361);
    local v39 = p34.AbsoluteSize * 0.5;
    local v40 = (v39.X + 6) / math.max(v38.X, 1);
    local math_clamp_ret = math.clamp(v40, 0.02, 0.48);
    local v41 = (v39.Y + 6) / math.max(v38.Y, 1);
    local math_clamp_ret2 = math.clamp(v41, 0.02, 0.48);
    local math_clamp_ret3 = math.clamp(p35, math_clamp_ret, 1 - math_clamp_ret);
    local math_clamp_ret4 = math.clamp(p36, math_clamp_ret2, 1 - math_clamp_ret2);
    local v42 = Vector2.new(v37.X * math_clamp_ret3, v37.Y * math_clamp_ret4) - script_Parent.AbsolutePosition;
    p34.AnchorPoint = Vector2.new(0.5, 0.5);
    p34.Position = UDim2.fromOffset(v42.X, v42.Y);
    p34:SetAttribute("NormalizedX", math_clamp_ret3);
    p34:SetAttribute("NormalizedY", math_clamp_ret4);
end;

local function updateLayout() -- Line: 168
    -- upvalues: Parent (copy), script_Parent (copy), u2 (copy), placeButtonAtScreenPosition (copy)
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if not workspace_CurrentCamera then
        return;
    end;

    local ViewportSize = workspace_CurrentCamera.ViewportSize;

    if ViewportSize.X < 200 or ViewportSize.Y < 160 then
        return;
    end;

    Parent.AnchorPoint = Vector2.zero;
    Parent.Position = UDim2.fromScale(0, 0);
    Parent.Size = UDim2.fromScale(1, 1);
    Parent.BackgroundTransparency = 1;
    Parent.ClipsDescendants = false;
    script_Parent.AnchorPoint = Vector2.zero;
    script_Parent.Position = UDim2.fromScale(0, 0);
    script_Parent.Size = UDim2.fromScale(1, 1);
    script_Parent.BackgroundTransparency = 1;
    script_Parent.ClipsDescendants = false;
    local math_min_ret = math.min(ViewportSize.X * 0.075, ViewportSize.Y * 0.15);
    local math_clamp_ret = math.clamp(math_min_ret, 28, 58);
    local _ = (math_clamp_ret + 8) / math.max(ViewportSize.X, 1);
    local _ = (math_clamp_ret + 8) / math.max(ViewportSize.Y, 1);
    local v43 = {};

    for _, v in ipairs(u2) do
        local button = v.button;
        button.Size = UDim2.fromOffset(math_clamp_ret, math_clamp_ret);
        button.ScaleType = Enum.ScaleType.Fit;
        button.ZIndex = math.max(button.ZIndex, 20);
        local _ = button:GetAttribute("CustomPosition") == true;
        local v44 = tonumber(button:GetAttribute("NormalizedX")) or v.x;
        local v45 = tonumber(button:GetAttribute("NormalizedY")) or v.y;
        local workspace_CurrentCamera2 = workspace.CurrentCamera;
        local v46 = workspace_CurrentCamera2 and workspace_CurrentCamera2.ViewportSize or Vector2.new(750, 361);
        local v47 = button.AbsoluteSize * 0.5;
        local v48 = (v47.X + 6) / math.max(v46.X, 1);
        local math_clamp_ret2 = math.clamp(v48, 0.02, 0.48);
        local v49 = (v47.Y + 6) / math.max(v46.Y, 1);
        local math_clamp_ret3 = math.clamp(v49, 0.02, 0.48);
        local math_clamp_ret4 = math.clamp(v44, math_clamp_ret2, 1 - math_clamp_ret2);
        local math_clamp_ret5 = math.clamp(v45, math_clamp_ret3, 1 - math_clamp_ret3);
        placeButtonAtScreenPosition(button, math_clamp_ret4, math_clamp_ret5);
        table.insert(v43, {
            x = math_clamp_ret4,
            y = math_clamp_ret5
        });
    end;
end;

local function finishDrag(p50) -- Line: 273
    -- upvalues: u6 (ref), u8 (ref), u7 (ref), u9 (ref), u11 (ref), script_Parent (copy)
    if p50 ~= u6 then
        return;
    end;

    u8 = false;
    u6 = nil;
    u7 = nil;

    if u9 then
        u11 = u11 + 1;
        local u51 = u11;
        task.delay(0.25, function() -- Line: 281
            -- upvalues: u11 (ref), u51 (copy), script_Parent (ref)
            if u11 == u51 then
                script_Parent:SetAttribute("IsDragging", false);
            end;
        end);
    else
        script_Parent:SetAttribute("IsDragging", false);
    end;

    u9 = false;
end;

local function savePosition(u52) -- Line: 207
    -- upvalues: placeButtonAtScreenPosition (copy), MobileHudLayoutRemote (copy)
    local button = u52.button;
    local workspace_CurrentCamera = workspace.CurrentCamera;
    local v53 = workspace_CurrentCamera and workspace_CurrentCamera.ViewportSize or Vector2.new(750, 361);

    if v53.X <= 0 or v53.Y <= 0 then
        return;
    end;

    local v54 = button.AbsolutePosition + button.AbsoluteSize * 0.5;
    local v55 = v54.X / v53.X;
    local v56 = v54.Y / v53.Y;
    local workspace_CurrentCamera2 = workspace.CurrentCamera;
    local v57 = workspace_CurrentCamera2 and workspace_CurrentCamera2.ViewportSize or Vector2.new(750, 361);
    local v58 = button.AbsoluteSize * 0.5;
    local v59 = (v58.X + 6) / math.max(v57.X, 1);
    local math_clamp_ret = math.clamp(v59, 0.02, 0.48);
    local v60 = (v58.Y + 6) / math.max(v57.Y, 1);
    local math_clamp_ret2 = math.clamp(v60, 0.02, 0.48);
    local math_clamp_ret3 = math.clamp(v55, math_clamp_ret, 1 - math_clamp_ret);
    local math_clamp_ret4 = math.clamp(v56, math_clamp_ret2, 1 - math_clamp_ret2);
    local u61 = math_clamp_ret3;
    local u62 = math_clamp_ret4;
    button:SetAttribute("CustomPosition", true);
    placeButtonAtScreenPosition(button, u61, u62);
    button:SetAttribute("NormalizedX", u61);
    button:SetAttribute("NormalizedY", u62);
    task.spawn(function() -- Line: 220
        -- upvalues: MobileHudLayoutRemote (ref), u52 (copy), u61 (ref), u62 (ref)
        pcall(function() -- Line: 221
            -- upvalues: MobileHudLayoutRemote (ref), u52 (ref), u61 (ref), u62 (ref)
            MobileHudLayoutRemote:InvokeServer("Merge", {
                [u52.save] = {
                    X = u61,
                    Y = u62
                }
            });
        end);
    end);
end;

local function saveAllPositions() -- Line: 229
    -- upvalues: TeamGuiLayout (copy), LocalPlayer (copy), u2 (copy), MobileHudLayoutRemote (copy)
    local v63;

    if TeamGuiLayout.GetMode() == "MOBILE" then
        v63 = LocalPlayer.Team and LocalPlayer.Team.Name == "Witches";
    else
        v63 = false;
    end;

    if not v63 then
        return;
    end;

    local workspace_CurrentCamera = workspace.CurrentCamera;
    local v64 = workspace_CurrentCamera and workspace_CurrentCamera.ViewportSize or Vector2.new(750, 361);

    if v64.X <= 0 or v64.Y <= 0 then
        return;
    end;

    local u65 = {};

    for _, v in ipairs(u2) do
        local button = v.button;
        local v66 = button.AbsolutePosition + button.AbsoluteSize * 0.5;
        local v67 = v66.X / v64.X;
        local v68 = v66.Y / v64.Y;
        local workspace_CurrentCamera2 = workspace.CurrentCamera;
        local v69 = workspace_CurrentCamera2 and workspace_CurrentCamera2.ViewportSize or Vector2.new(750, 361);
        local v70 = button.AbsoluteSize * 0.5;
        local v71 = (v70.X + 6) / math.max(v69.X, 1);
        local math_clamp_ret = math.clamp(v71, 0.02, 0.48);
        local v72 = (v70.Y + 6) / math.max(v69.Y, 1);
        local math_clamp_ret2 = math.clamp(v72, 0.02, 0.48);
        local math_clamp_ret3 = math.clamp(v67, math_clamp_ret, 1 - math_clamp_ret);
        local math_clamp_ret4 = math.clamp(v68, math_clamp_ret2, 1 - math_clamp_ret2);
        u65[v.save] = {
            X = math_clamp_ret3,
            Y = math_clamp_ret4
        };
    end;

    pcall(function() -- Line: 242
        -- upvalues: MobileHudLayoutRemote (ref), u65 (copy)
        MobileHudLayoutRemote:InvokeServer("Merge", u65);
    end);
end;

local function restorePositions() -- Line: 247
    -- upvalues: LocalPlayer (copy), MobileHudLayoutRemote (copy), u3 (copy), placeButtonAtScreenPosition (copy), updateLayout (copy)
    while LocalPlayer.Parent and LocalPlayer:GetAttribute("DataLoaded") ~= true do
        LocalPlayer:GetAttributeChangedSignal("DataLoaded"):Wait();
    end;

    if not LocalPlayer.Parent then
        return;
    end;

    local success, result = pcall(function() -- Line: 253
        -- upvalues: MobileHudLayoutRemote (ref)
        return MobileHudLayoutRemote:InvokeServer("Load");
    end);

    if not success or type(result) ~= "table" then
        return;
    end;

    for i, v in pairs(u3) do
        local v73 = result[i];
        local v74;

        if type(v73) == "table" then
            v74 = tonumber(v73.X) or nil;
        else
            v74 = nil;
        end;

        local v75;

        if type(v73) == "table" then
            v75 = tonumber(v73.Y) or nil;
        else
            v75 = nil;
        end;

        if v74 and v75 then
            local button = v.button;
            local workspace_CurrentCamera = workspace.CurrentCamera;
            local v76 = workspace_CurrentCamera and workspace_CurrentCamera.ViewportSize or Vector2.new(750, 361);
            local v77 = button.AbsoluteSize * 0.5;
            local v78 = (v77.X + 6) / math.max(v76.X, 1);
            local math_clamp_ret = math.clamp(v78, 0.02, 0.48);
            local v79 = (v77.Y + 6) / math.max(v76.Y, 1);
            local math_clamp_ret2 = math.clamp(v79, 0.02, 0.48);
            local math_clamp_ret3 = math.clamp(v74, math_clamp_ret, 1 - math_clamp_ret);
            local math_clamp_ret4 = math.clamp(v75, math_clamp_ret2, 1 - math_clamp_ret2);
            v.button:SetAttribute("CustomPosition", true);
            v.button:SetAttribute("NormalizedX", math_clamp_ret3);
            v.button:SetAttribute("NormalizedY", math_clamp_ret4);
            placeButtonAtScreenPosition(v.button, math_clamp_ret3, math_clamp_ret4);
        end;
    end;

    updateLayout();
end;

for _, v in ipairs(u2) do
    local button = v.button;
    button.InputBegan:Connect(function(u80) -- Line: 294
        -- upvalues: UserInputService (copy), LocalPlayer (copy), u6 (ref), u8 (ref), u9 (ref), u7 (ref), v (copy), u10 (ref), Vector2_zero (ref), Vector2_zero2 (ref), button (copy), u11 (ref), script_Parent (copy), savePosition (copy), finishDrag (copy)
        local v81 = UserInputService.TouchEnabled and LocalPlayer:GetAttribute("MobileHudEditMode") == true;

        if not v81 then
            return;
        end;

        if u80.UserInputType ~= Enum.UserInputType.Touch or u6 ~= nil then
            return;
        end;

        u8 = true;
        u9 = true;
        u6 = u80;
        u7 = v;
        u10 = os.clock();
        Vector2_zero = Vector2.new(u80.Position.X, u80.Position.Y);
        Vector2_zero2 = button.AbsolutePosition + button.AbsoluteSize * 0.5;
        u11 = u11 + 1;
        script_Parent:SetAttribute("IsDragging", true);
        u80.Changed:Connect(function() -- Line: 307
            -- upvalues: u80 (copy), u9 (ref), u7 (ref), v (ref), savePosition (ref), finishDrag (ref)
            if u80.UserInputState == Enum.UserInputState.End then
                if u9 and u7 == v then
                    savePosition(v);
                end;

                finishDrag(u80);
            end;
        end);
    end);
end;

UserInputService.InputChanged:Connect(function(p82) -- Line: 318
    -- upvalues: u8 (ref), u6 (ref), u7 (ref), Vector2_zero (ref), u9 (ref), u10 (ref), u11 (ref), Vector2_zero2 (ref), placeButtonAtScreenPosition (copy)
    if not (u8 and (u6 and (p82 == u6 and u7))) then
        return;
    end;

    local v83 = Vector2.new(p82.Position.X, p82.Position.Y) - Vector2_zero;

    if not u9 then
        if v83.Magnitude > 14 and os.clock() - u10 < 0.85 then
            u8 = false;
            u6 = nil;
            u7 = nil;
            u11 = u11 + 1;
        end;

        return;
    end;

    local button = u7.button;
    local workspace_CurrentCamera = workspace.CurrentCamera;
    local v84 = workspace_CurrentCamera and workspace_CurrentCamera.ViewportSize or Vector2.new(750, 361);
    local v85 = button.AbsoluteSize * 0.5;
    local v86 = Vector2_zero2 + v83;
    local Vector2_new_ret = Vector2.new(math.clamp(v86.X, v85.X + 6, v84.X - v85.X - 6), (math.clamp(v86.Y, v85.Y + 6, v84.Y - v85.Y - 6)));
    local v87 = Vector2_new_ret.X / v84.X;
    local v88 = Vector2_new_ret.Y / v84.Y;
    button:SetAttribute("CustomPosition", true);
    placeButtonAtScreenPosition(button, v87, v88);
    button:SetAttribute("NormalizedX", v87);
    button:SetAttribute("NormalizedY", v88);
end);
RUN.Activated:Connect(function() -- Line: 348
    -- upvalues: script_Parent (copy), LocalPlayer (copy), canUseControls (copy), u4 (ref), SprintRequest (copy), applyRunSpeed (copy), updateVisuals (copy)
    if script_Parent:GetAttribute("IsDragging") == true then
        return;
    end;

    local Character = LocalPlayer.Character;
    local v89 = canUseControls();

    if v89 then
        if Character == nil or Character:GetAttribute("FlyingBroom") == true then
            v89 = false;
        else
            v89 = (tonumber(LocalPlayer:GetAttribute("Stamina")) or 0) > 0;
        end;
    end;

    if not v89 then
        if u4 then
            u4 = false;
            SprintRequest:FireServer(false);
        end;

        applyRunSpeed(false);
        updateVisuals();

        return;
    end;

    u4 = not u4;
    applyRunSpeed(u4);
    SprintRequest:FireServer(u4);
    updateVisuals();
end);
ShiftLock.Activated:Connect(function() -- Line: 361
    -- upvalues: script_Parent (copy), canUseControls (copy), AltShiftLock (copy), updateVisuals (copy)
    if script_Parent:GetAttribute("IsDragging") == true or not canUseControls() then
        return;
    end;

    AltShiftLock.Toggle();
    updateVisuals();
end);
LocalPlayer:GetAttributeChangedSignal("AltShiftLockEnabled"):Connect(updateVisuals);
LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function() -- Line: 368
    -- upvalues: LocalPlayer (copy), u4 (ref), SprintRequest (copy), applyRunSpeed (copy), updateLayout (copy), updateVisuals (copy)
    if not (LocalPlayer.Team and LocalPlayer.Team.Name == "Witches") then
        if u4 then
            u4 = false;
            SprintRequest:FireServer(false);
        end;

        applyRunSpeed(false);
    end;

    updateLayout();
    updateVisuals();
end);
LocalPlayer:GetAttributeChangedSignal("MobileHudResetRevision"):Connect(function() -- Line: 374
    -- upvalues: u2 (copy), updateLayout (copy)
    for _, v in ipairs(u2) do
        v.button:SetAttribute("CustomPosition", false);
        v.button:SetAttribute("NormalizedX", nil);
        v.button:SetAttribute("NormalizedY", nil);
    end;

    updateLayout();
end);
LocalPlayer:GetAttributeChangedSignal("MobileHudEditMode"):Connect(function() -- Line: 382
    -- upvalues: LocalPlayer (copy), saveAllPositions (copy), u8 (ref), u9 (ref), u6 (ref), u7 (ref), u11 (ref), script_Parent (copy)
    if LocalPlayer:GetAttribute("MobileHudEditMode") ~= true then
        task.spawn(saveAllPositions);
    end;

    u8 = false;
    u9 = false;
    u6 = nil;
    u7 = nil;
    u11 = u11 + 1;
    script_Parent:SetAttribute("IsDragging", false);
end);
LocalPlayer.CharacterAdded:Connect(function() -- Line: 394
    -- upvalues: u4 (ref), SprintRequest (copy), applyRunSpeed (copy), updateLayout (copy), updateVisuals (copy)
    if u4 then
        u4 = false;
        SprintRequest:FireServer(false);
    end;

    applyRunSpeed(false);
    task.defer(function() -- Line: 396
        -- upvalues: updateLayout (ref), updateVisuals (ref)
        updateLayout();
        updateVisuals();
    end);
end);
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- Line: 402
    -- upvalues: u5 (ref), updateLayout (copy)
    if u5 then
        u5:Disconnect();
    end;

    local workspace_CurrentCamera = workspace.CurrentCamera;
    updateLayout();

    if workspace_CurrentCamera then
        u5 = workspace_CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateLayout);
    end;
end);
local workspace_CurrentCamera = workspace.CurrentCamera;

if workspace_CurrentCamera then
    u5 = workspace_CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateLayout);
end;

script_Parent:SetAttribute("IsDragging", false);
updateLayout();
updateVisuals();
task.spawn(restorePositions);
task.spawn(function() -- Line: 421
    -- upvalues: u4 (ref), LocalPlayer (copy), canUseControls (copy), SprintRequest (copy), applyRunSpeed (copy), updateVisuals (copy)
    while script.Parent do
        if u4 then
            local Character = LocalPlayer.Character;
            local v90 = canUseControls();

            if v90 then
                if Character == nil or Character:GetAttribute("FlyingBroom") == true then
                    v90 = false;
                else
                    v90 = (tonumber(LocalPlayer:GetAttribute("Stamina")) or 0) > 0;
                end;
            end;

            if not v90 then
                if u4 then
                    u4 = false;
                    SprintRequest:FireServer(false);
                end;

                applyRunSpeed(false);
            end;
        end;

        updateVisuals();
        task.wait(0.2);
    end;
end);
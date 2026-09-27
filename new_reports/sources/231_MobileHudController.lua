-- Decompiled with Potassium's decompiler.

require(game:GetService("ReplicatedStorage"):WaitForChild("TeamGuiLayout"));
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local LocalPlayer = Players.LocalPlayer;
local script_Parent = script.Parent;
local Eventos = ReplicatedStorage:WaitForChild("Funções"):WaitForChild("Eventos");
local MobileHudLayoutRemote = Eventos:WaitForChild("MobileHudLayoutRemote");
local SprintRequest = Eventos:WaitForChild("SprintRequest");
local SprintConfig = require(ReplicatedStorage:WaitForChild("Funções"):WaitForChild("SprintConfig"));
local u1 = { {
        ui = "RUN",
        save = "Run",
        x = 0.1249,
        y = 0.4617
    }, {
        ui = "SHIFTLOCK",
        save = "shiftlock",
        x = 0.8493,
        y = 0.1856
    }, {
        ui = "DROP",
        save = "Drop",
        x = 0.1246,
        y = 0.615
    }, {
        ui = "LockOn",
        save = "HumanLockOn",
        x = 0.8493,
        y = 0.34
    } };
local v2 = {};
local u3 = {};

for _, v in ipairs(u1) do
    local v4 = script_Parent:WaitForChild(v.ui);
    v.button = v4;
    v4.Active = true;

    if v4:IsA("GuiButton") then
        v4.Interactable = true;
    end;

    v2[v4] = v;
    u3[v.save] = v;
end;

local RUN = script_Parent:WaitForChild("RUN");
local ImageColor3 = RUN.ImageColor3;
local u5 = false;
local Vector2_zero = Vector2.zero;
local u6 = nil;
local u7 = 0;
local u8 = nil;
local u9 = nil;
local u10 = false;
local u11 = false;
local Vector2_zero2 = Vector2.zero;
local Vector2_zero3 = Vector2.zero;

local function isHudEditMode() -- Line: 52
    -- upvalues: UserInputService (copy), LocalPlayer (copy)
    local v12 = UserInputService.TouchEnabled and LocalPlayer:GetAttribute("MobileHudEditMode") == true;

    return v12;
end;

local function isHuman() -- Line: 56
    -- upvalues: LocalPlayer (copy)
    local Team = LocalPlayer.Team;

    if Team then
        Team = Team.Name == "Humans";
    end;

    return Team;
end;

local function getRunSpeeds() -- Line: 79
    -- upvalues: LocalPlayer (copy), SprintConfig (copy)
    local v13 = LocalPlayer.Team and LocalPlayer.Team.Name or "Humans";
    local ForPlayer = SprintConfig.GetForPlayer(v13, LocalPlayer:GetAttribute("VampireOrigin"), LocalPlayer:GetAttribute("Years"), LocalPlayer);
    local v14 = v13 == "Humans" and (tonumber(LocalPlayer:GetAttribute("SpeedBonus")) or 0) or 0;
    local v15 = tonumber(LocalPlayer:GetAttribute("StrengthSpeedMultiplier")) or 1;
    local v16 = v14 * math.clamp(v15, 1, 1.2);

    return (tonumber(ForPlayer.WalkSpeed) or 16) + v16, (tonumber(ForPlayer.SprintSpeed) or 24) + v16;
end;

local function applyRunSpeed(p17) -- Line: 94
    -- upvalues: LocalPlayer (copy), getRunSpeeds (copy)
    local Character = LocalPlayer.Character;
    local v18;

    if Character then
        v18 = Character:FindFirstChildOfClass("Humanoid");
    else
        v18 = Character;
    end;

    if not v18 then
        return;
    end;

    if Character:GetAttribute("ActionLocked") == true or Character:GetAttribute("Petrified") == true then
        v18.WalkSpeed = 0;

        return;
    end;

    local v19, v20 = getRunSpeeds();

    if p17 then
        v19 = v20 or v19;
    end;

    v18.WalkSpeed = v19;
end;

local function setRunVisual() -- Line: 108
    -- upvalues: RUN (copy), u5 (ref), ImageColor3 (copy)
    RUN:SetAttribute("RunEnabled", u5);
    RUN.ImageColor3 = u5 and Color3.fromRGB(125, 255, 150) or ImageColor3;
end;

local function stopRunning() -- Line: 113
    -- upvalues: u5 (ref), SprintRequest (copy), applyRunSpeed (copy), RUN (copy), ImageColor3 (copy)
    if u5 then
        u5 = false;
        SprintRequest:FireServer(false);
    end;

    applyRunSpeed(false);
    RUN:SetAttribute("RunEnabled", u5);
    RUN.ImageColor3 = u5 and Color3.fromRGB(125, 255, 150) or ImageColor3;
end;

local function getMenuRect() -- Line: 122
    -- upvalues: script_Parent (copy)
    local AbsoluteSize = script_Parent.AbsoluteSize;

    if AbsoluteSize.X <= 1 or AbsoluteSize.Y <= 1 then
        local workspace_CurrentCamera = workspace.CurrentCamera;
        AbsoluteSize = workspace_CurrentCamera and workspace_CurrentCamera.ViewportSize or Vector2.new(750, 361);
    end;

    return script_Parent.AbsolutePosition, AbsoluteSize;
end;

local function clampNormalizedPosition(p21, p22, p23) -- Line: 131
    -- upvalues: script_Parent (copy)
    local AbsoluteSize = script_Parent.AbsoluteSize;

    if AbsoluteSize.X <= 1 or AbsoluteSize.Y <= 1 then
        local workspace_CurrentCamera = workspace.CurrentCamera;
        AbsoluteSize = workspace_CurrentCamera and workspace_CurrentCamera.ViewportSize or Vector2.new(750, 361);
    end;

    local _ = script_Parent.AbsolutePosition;
    local v24 = p23.AbsoluteSize * 0.5;
    local v25 = (v24.X + 6) / math.max(AbsoluteSize.X, 1);
    local math_clamp_ret = math.clamp(v25, 0.02, 0.48);
    local v26 = (v24.Y + 6) / math.max(AbsoluteSize.Y, 1);
    local math_clamp_ret2 = math.clamp(v26, 0.02, 0.48);

    return math.clamp(p21, math_clamp_ret, 1 - math_clamp_ret), math.clamp(p22, math_clamp_ret2, 1 - math_clamp_ret2);
end;

local function updateResponsiveLayout() -- Line: 142
    -- upvalues: Vector2_zero (ref), script_Parent (copy), u1 (copy)
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if not workspace_CurrentCamera then
        return;
    end;

    local ViewportSize = workspace_CurrentCamera.ViewportSize;

    if ViewportSize.X < 200 or ViewportSize.Y < 160 then
        return;
    end;

    Vector2_zero = ViewportSize;
    script_Parent.AnchorPoint = Vector2.zero;
    script_Parent.Position = UDim2.fromScale(0, 0);
    script_Parent.Size = UDim2.fromScale(1, 1);
    script_Parent.BackgroundTransparency = 1;
    script_Parent.ClipsDescendants = false;
    local math_min_ret = math.min(ViewportSize.X * 0.068, ViewportSize.Y * 0.145);
    local math_clamp_ret = math.clamp(math_min_ret, 30, 60);
    local _ = (math_clamp_ret + 8) / math.max(ViewportSize.X, 1);
    local _ = (math_clamp_ret + 8) / math.max(ViewportSize.Y, 1);
    local v27 = {};

    for _, v in ipairs(u1) do
        local button = v.button;
        button.AnchorPoint = Vector2.new(0.5, 0.5);
        button.Size = UDim2.fromOffset(math_clamp_ret, math_clamp_ret);
        button.ScaleType = Enum.ScaleType.Fit;
        button.ZIndex = math.max(button.ZIndex, 10);
        local v28 = button:GetAttribute("CustomPosition") == true;
        local v29 = v28 and button.Position.X.Scale or v.x;
        local v30 = v28 and button.Position.Y.Scale or v.y;
        local AbsoluteSize = script_Parent.AbsoluteSize;

        if AbsoluteSize.X <= 1 or AbsoluteSize.Y <= 1 then
            local workspace_CurrentCamera2 = workspace.CurrentCamera;
            AbsoluteSize = workspace_CurrentCamera2 and workspace_CurrentCamera2.ViewportSize or Vector2.new(750, 361);
        end;

        local _ = script_Parent.AbsolutePosition;
        local v31 = button.AbsoluteSize * 0.5;
        local v32 = (v31.X + 6) / math.max(AbsoluteSize.X, 1);
        local math_clamp_ret2 = math.clamp(v32, 0.02, 0.48);
        local v33 = (v31.Y + 6) / math.max(AbsoluteSize.Y, 1);
        local math_clamp_ret3 = math.clamp(v33, 0.02, 0.48);
        local math_clamp_ret4 = math.clamp(v29, math_clamp_ret2, 1 - math_clamp_ret2);
        local math_clamp_ret5 = math.clamp(v30, math_clamp_ret3, 1 - math_clamp_ret3);
        button.Position = UDim2.fromScale(math_clamp_ret4, math_clamp_ret5);
        table.insert(v27, {
            x = math_clamp_ret4,
            y = math_clamp_ret5
        });
    end;
end;

local function finishDrag(p34) -- Line: 242
    -- upvalues: u8 (ref), u10 (ref), u9 (ref), u11 (ref), u7 (ref), script_Parent (copy)
    if p34 ~= u8 then
        return;
    end;

    u10 = false;
    u8 = nil;
    u9 = nil;

    if u11 then
        u7 = u7 + 1;
        local u35 = u7;
        task.delay(0.25, function() -- Line: 250
            -- upvalues: u7 (ref), u35 (copy), script_Parent (ref)
            if u7 == u35 then
                script_Parent:SetAttribute("IsDragging", false);
            end;
        end);
    else
        script_Parent:SetAttribute("IsDragging", false);
    end;

    u11 = false;
end;

local u36 = 0;

local function savePosition(u37) -- Line: 178
    -- upvalues: script_Parent (copy), MobileHudLayoutRemote (copy)
    local button = u37.button;
    local AbsoluteSize = script_Parent.AbsoluteSize;

    if AbsoluteSize.X <= 1 or AbsoluteSize.Y <= 1 then
        local workspace_CurrentCamera = workspace.CurrentCamera;
        AbsoluteSize = workspace_CurrentCamera and workspace_CurrentCamera.ViewportSize or Vector2.new(750, 361);
    end;

    local AbsolutePosition = script_Parent.AbsolutePosition;

    if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
        return;
    end;

    local v38 = button.AbsolutePosition + button.AbsoluteSize * 0.5;
    local v39 = (v38.X - AbsolutePosition.X) / AbsoluteSize.X;
    local v40 = (v38.Y - AbsolutePosition.Y) / AbsoluteSize.Y;
    local AbsoluteSize2 = script_Parent.AbsoluteSize;

    if AbsoluteSize2.X <= 1 or AbsoluteSize2.Y <= 1 then
        local workspace_CurrentCamera = workspace.CurrentCamera;
        AbsoluteSize2 = workspace_CurrentCamera and workspace_CurrentCamera.ViewportSize or Vector2.new(750, 361);
    end;

    local _ = script_Parent.AbsolutePosition;
    local v41 = button.AbsoluteSize * 0.5;
    local v42 = (v41.X + 6) / math.max(AbsoluteSize2.X, 1);
    local math_clamp_ret = math.clamp(v42, 0.02, 0.48);
    local v43 = (v41.Y + 6) / math.max(AbsoluteSize2.Y, 1);
    local math_clamp_ret2 = math.clamp(v43, 0.02, 0.48);
    local math_clamp_ret3 = math.clamp(v39, math_clamp_ret, 1 - math_clamp_ret);
    local math_clamp_ret4 = math.clamp(v40, math_clamp_ret2, 1 - math_clamp_ret2);
    local u44 = math_clamp_ret3;
    local u45 = math_clamp_ret4;
    button.AnchorPoint = Vector2.new(0.5, 0.5);
    button.Position = UDim2.fromScale(u44, u45);
    button:SetAttribute("CustomPosition", true);
    task.spawn(function() -- Line: 190
        -- upvalues: MobileHudLayoutRemote (ref), u37 (copy), u44 (ref), u45 (ref)
        pcall(function() -- Line: 191
            -- upvalues: MobileHudLayoutRemote (ref), u37 (ref), u44 (ref), u45 (ref)
            MobileHudLayoutRemote:InvokeServer("Merge", {
                [u37.save] = {
                    X = u44,
                    Y = u45
                }
            });
        end);
    end);
end;

local function saveAllPositions() -- Line: 199
    -- upvalues: script_Parent (copy), script_Parent (copy), u1 (copy), MobileHudLayoutRemote (copy)
    if not script_Parent.Visible then
        return;
    end;

    local AbsoluteSize = script_Parent.AbsoluteSize;

    if AbsoluteSize.X <= 1 or AbsoluteSize.Y <= 1 then
        local workspace_CurrentCamera = workspace.CurrentCamera;
        AbsoluteSize = workspace_CurrentCamera and workspace_CurrentCamera.ViewportSize or Vector2.new(750, 361);
    end;

    local AbsolutePosition = script_Parent.AbsolutePosition;

    if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
        return;
    end;

    local u46 = {};

    for _, v in ipairs(u1) do
        local button = v.button;
        local v47 = button.AbsolutePosition + button.AbsoluteSize * 0.5;
        local v48 = (v47.X - AbsolutePosition.X) / AbsoluteSize.X;
        local v49 = (v47.Y - AbsolutePosition.Y) / AbsoluteSize.Y;
        local AbsoluteSize2 = script_Parent.AbsoluteSize;

        if AbsoluteSize2.X <= 1 or AbsoluteSize2.Y <= 1 then
            local workspace_CurrentCamera = workspace.CurrentCamera;
            AbsoluteSize2 = workspace_CurrentCamera and workspace_CurrentCamera.ViewportSize or Vector2.new(750, 361);
        end;

        local _ = script_Parent.AbsolutePosition;
        local v50 = button.AbsoluteSize * 0.5;
        local v51 = (v50.X + 6) / math.max(AbsoluteSize2.X, 1);
        local math_clamp_ret = math.clamp(v51, 0.02, 0.48);
        local v52 = (v50.Y + 6) / math.max(AbsoluteSize2.Y, 1);
        local math_clamp_ret2 = math.clamp(v52, 0.02, 0.48);
        local math_clamp_ret3 = math.clamp(v48, math_clamp_ret, 1 - math_clamp_ret);
        local math_clamp_ret4 = math.clamp(v49, math_clamp_ret2, 1 - math_clamp_ret2);
        u46[v.save] = {
            X = math_clamp_ret3,
            Y = math_clamp_ret4
        };
    end;

    pcall(function() -- Line: 212
        -- upvalues: MobileHudLayoutRemote (ref), u46 (copy)
        MobileHudLayoutRemote:InvokeServer("Merge", u46);
    end);
end;

local function canRun() -- Line: 61
    -- upvalues: LocalPlayer (copy), UserInputService (copy), script_Parent (copy)
    local Character = LocalPlayer.Character;
    local v53;

    if Character then
        v53 = Character:FindFirstChildOfClass("Humanoid");
    else
        v53 = Character;
    end;

    local v54 = UserInputService.TouchEnabled and script_Parent.Visible;

    if v54 then
        v54 = LocalPlayer.Team;

        if v54 then
            v54 = v54.Name == "Humans";
        end;

        if v54 then
            if v53 == nil or (v53.Health <= 0 or (Character:GetAttribute("Hibernating") == true or (Character:GetAttribute("ActionLocked") == true or (Character:GetAttribute("Ragdolled") == true or (Character:GetAttribute("HypnosisPossessing") == true or (Character:GetAttribute("FlyingBroom") == true or (Character:GetAttribute("BatFormActive") == true or Character:GetAttribute("BatFormTransforming") == true))))))) then
                v54 = false;
            else
                v54 = (tonumber(LocalPlayer:GetAttribute("Stamina")) or 0) > 0;
            end;
        end;
    end;

    return v54;
end;

local function restorePositions() -- Line: 217
    -- upvalues: LocalPlayer (copy), MobileHudLayoutRemote (copy), u3 (copy), script_Parent (copy), updateResponsiveLayout (copy)
    while LocalPlayer.Parent and LocalPlayer:GetAttribute("DataLoaded") ~= true do
        LocalPlayer:GetAttributeChangedSignal("DataLoaded"):Wait();
    end;

    if not LocalPlayer.Parent then
        return;
    end;

    local success, result = pcall(function() -- Line: 223
        -- upvalues: MobileHudLayoutRemote (ref)
        return MobileHudLayoutRemote:InvokeServer("Load");
    end);

    if not success or type(result) ~= "table" then
        return;
    end;

    for i, v in pairs(u3) do
        local v55 = result[i];
        local v56;

        if type(v55) == "table" then
            v56 = tonumber(v55.X) or nil;
        else
            v56 = nil;
        end;

        local v57;

        if type(v55) == "table" then
            v57 = tonumber(v55.Y) or nil;
        else
            v57 = nil;
        end;

        if v56 and v57 then
            local button = v.button;
            local AbsoluteSize = script_Parent.AbsoluteSize;

            if AbsoluteSize.X <= 1 or AbsoluteSize.Y <= 1 then
                local workspace_CurrentCamera = workspace.CurrentCamera;
                AbsoluteSize = workspace_CurrentCamera and workspace_CurrentCamera.ViewportSize or Vector2.new(750, 361);
            end;

            local _ = script_Parent.AbsolutePosition;
            local v58 = button.AbsoluteSize * 0.5;
            local v59 = (v58.X + 6) / math.max(AbsoluteSize.X, 1);
            local math_clamp_ret = math.clamp(v59, 0.02, 0.48);
            local v60 = (v58.Y + 6) / math.max(AbsoluteSize.Y, 1);
            local math_clamp_ret2 = math.clamp(v60, 0.02, 0.48);
            local math_clamp_ret3 = math.clamp(v56, math_clamp_ret, 1 - math_clamp_ret);
            local math_clamp_ret4 = math.clamp(v57, math_clamp_ret2, 1 - math_clamp_ret2);
            v.button:SetAttribute("CustomPosition", true);
            v.button.AnchorPoint = Vector2.new(0.5, 0.5);
            v.button.Position = UDim2.fromScale(math_clamp_ret3, math_clamp_ret4);
        end;
    end;

    updateResponsiveLayout();
end;

for _, v in ipairs(u1) do
    local button = v.button;
    button.InputBegan:Connect(function(u61) -- Line: 263
        -- upvalues: UserInputService (copy), LocalPlayer (copy), u8 (ref), u10 (ref), u11 (ref), u9 (ref), v (copy), u36 (ref), Vector2_zero2 (ref), Vector2_zero3 (ref), button (copy), u7 (ref), script_Parent (copy), savePosition (copy), finishDrag (copy)
        local v62 = UserInputService.TouchEnabled and LocalPlayer:GetAttribute("MobileHudEditMode") == true;

        if not v62 then
            return;
        end;

        if u61.UserInputType ~= Enum.UserInputType.Touch or u8 ~= nil then
            return;
        end;

        u10 = true;
        u11 = true;
        u8 = u61;
        u9 = v;
        u36 = os.clock();
        Vector2_zero2 = Vector2.new(u61.Position.X, u61.Position.Y);
        Vector2_zero3 = button.AbsolutePosition + button.AbsoluteSize * 0.5;
        u7 = u7 + 1;
        script_Parent:SetAttribute("IsDragging", true);
        u61.Changed:Connect(function() -- Line: 280
            -- upvalues: u61 (copy), u11 (ref), u9 (ref), v (ref), savePosition (ref), finishDrag (ref)
            if u61.UserInputState == Enum.UserInputState.End then
                if u11 and u9 == v then
                    savePosition(v);
                end;

                finishDrag(u61);
            end;
        end);
    end);
end;

UserInputService.InputChanged:Connect(function(p63) -- Line: 291
    -- upvalues: u10 (ref), u8 (ref), u9 (ref), Vector2_zero2 (ref), u11 (ref), u36 (ref), u7 (ref), script_Parent (copy), Vector2_zero3 (ref)
    if not (u10 and (u8 and (p63 == u8 and u9))) then
        return;
    end;

    local v64 = Vector2.new(p63.Position.X, p63.Position.Y) - Vector2_zero2;

    if not u11 then
        if v64.Magnitude > 14 and os.clock() - u36 < 0.85 then
            u10 = false;
            u8 = nil;
            u9 = nil;
            u7 = u7 + 1;
        end;

        return;
    end;

    local button = u9.button;
    local AbsoluteSize = script_Parent.AbsoluteSize;

    if AbsoluteSize.X <= 1 or AbsoluteSize.Y <= 1 then
        local workspace_CurrentCamera = workspace.CurrentCamera;
        AbsoluteSize = workspace_CurrentCamera and workspace_CurrentCamera.ViewportSize or Vector2.new(750, 361);
    end;

    local AbsolutePosition = script_Parent.AbsolutePosition;
    local v65 = button.AbsoluteSize * 0.5;
    local v66 = Vector2_zero3 + v64;
    local Vector2_new_ret = Vector2.new(math.clamp(v66.X, AbsolutePosition.X + v65.X + 6, AbsolutePosition.X + AbsoluteSize.X - v65.X - 6), (math.clamp(v66.Y, AbsolutePosition.Y + v65.Y + 6, AbsolutePosition.Y + AbsoluteSize.Y - v65.Y - 6)));
    local v67 = (Vector2_new_ret.X - AbsolutePosition.X) / AbsoluteSize.X;
    local v68 = (Vector2_new_ret.Y - AbsolutePosition.Y) / AbsoluteSize.Y;
    button:SetAttribute("CustomPosition", true);
    button.AnchorPoint = Vector2.new(0.5, 0.5);
    button.Position = UDim2.fromScale(v67, v68);
end);
RUN.Activated:Connect(function() -- Line: 322
    -- upvalues: script_Parent (copy), canRun (copy), u5 (ref), SprintRequest (copy), applyRunSpeed (copy), RUN (copy), ImageColor3 (copy)
    if script_Parent:GetAttribute("IsDragging") == true then
        return;
    end;

    if not canRun() then
        if u5 then
            u5 = false;
            SprintRequest:FireServer(false);
        end;

        applyRunSpeed(false);
        RUN:SetAttribute("RunEnabled", u5);
        RUN.ImageColor3 = u5 and Color3.fromRGB(125, 255, 150) or ImageColor3;

        return;
    end;

    u5 = not u5;
    applyRunSpeed(u5);
    SprintRequest:FireServer(u5);
    RUN:SetAttribute("RunEnabled", u5);
    RUN.ImageColor3 = u5 and Color3.fromRGB(125, 255, 150) or ImageColor3;
end);

local function bindViewport() -- Line: 334
    -- upvalues: u6 (ref), updateResponsiveLayout (copy)
    if u6 then
        u6:Disconnect();
        u6 = nil;
    end;

    updateResponsiveLayout();
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if workspace_CurrentCamera then
        u6 = workspace_CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateResponsiveLayout);
    end;
end;

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindViewport);
LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function() -- Line: 347
    -- upvalues: LocalPlayer (copy), u5 (ref), SprintRequest (copy), applyRunSpeed (copy), RUN (copy), ImageColor3 (copy)
    local Team = LocalPlayer.Team;

    if Team then
        Team = Team.Name == "Humans";
    end;

    if not Team then
        if u5 then
            u5 = false;
            SprintRequest:FireServer(false);
        end;

        applyRunSpeed(false);
        RUN:SetAttribute("RunEnabled", u5);
        RUN.ImageColor3 = u5 and Color3.fromRGB(125, 255, 150) or ImageColor3;
    end;
end);
LocalPlayer:GetAttributeChangedSignal("MobileHudResetRevision"):Connect(function() -- Line: 352
    -- upvalues: u1 (copy), updateResponsiveLayout (copy)
    for _, v in ipairs(u1) do
        v.button:SetAttribute("CustomPosition", false);
    end;

    updateResponsiveLayout();
end);
LocalPlayer:GetAttributeChangedSignal("MobileHudEditMode"):Connect(function() -- Line: 358
    -- upvalues: LocalPlayer (copy), saveAllPositions (copy), u10 (ref), u11 (ref), u8 (ref), u9 (ref), u7 (ref), script_Parent (copy)
    if LocalPlayer:GetAttribute("MobileHudEditMode") ~= true then
        task.spawn(saveAllPositions);
    end;

    u10 = false;
    u11 = false;
    u8 = nil;
    u9 = nil;
    u7 = u7 + 1;
    script_Parent:SetAttribute("IsDragging", false);
end);
LocalPlayer.CharacterAdded:Connect(function() -- Line: 370
    -- upvalues: u5 (ref), SprintRequest (copy), applyRunSpeed (copy), RUN (copy), ImageColor3 (copy), updateResponsiveLayout (copy)
    if u5 then
        u5 = false;
        SprintRequest:FireServer(false);
    end;

    applyRunSpeed(false);
    RUN:SetAttribute("RunEnabled", u5);
    RUN.ImageColor3 = u5 and Color3.fromRGB(125, 255, 150) or ImageColor3;
    task.defer(updateResponsiveLayout);
end);
script_Parent:SetAttribute("IsDragging", false);

if u6 then
    u6:Disconnect();
    u6 = nil;
end;

updateResponsiveLayout();
local workspace_CurrentCamera = workspace.CurrentCamera;

if workspace_CurrentCamera then
    u6 = workspace_CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateResponsiveLayout);
end;

RUN:SetAttribute("RunEnabled", u5);
local v69;

if u5 then
    v69 = Color3.fromRGB(125, 255, 150) or ImageColor3;
else
    v69 = ImageColor3;
end;

RUN.ImageColor3 = v69;
task.spawn(restorePositions);
task.spawn(function() -- Line: 380
    -- upvalues: u5 (ref), canRun (copy), SprintRequest (copy), applyRunSpeed (copy), RUN (copy), ImageColor3 (copy)
    while script.Parent do
        if u5 and not canRun() then
            if u5 then
                u5 = false;
                SprintRequest:FireServer(false);
            end;

            applyRunSpeed(false);
            RUN:SetAttribute("RunEnabled", u5);
            RUN.ImageColor3 = u5 and Color3.fromRGB(125, 255, 150) or ImageColor3;
        end;

        task.wait(0.2);
    end;
end);
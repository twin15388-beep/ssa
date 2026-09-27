-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local LocalPlayer = Players.LocalPlayer;
local Eventos = ReplicatedStorage:WaitForChild("Funções"):WaitForChild("Eventos");
local PartyRemote = Eventos:WaitForChild("PartyRemote");
local MobileHudLayoutRemote = Eventos:WaitForChild("MobileHudLayoutRemote");
local script_Parent = script.Parent;
local BASE = script_Parent:WaitForChild("BASE");
local MakeParty = BASE:WaitForChild("MakeParty");
local PARTYPLAYERS = BASE:WaitForChild("PARTYPLAYERS");
local PARTYADD = BASE:WaitForChild("PARTYADD");
local PARTYINVITED = BASE:WaitForChild("PARTYINVITED");
local ADDPLAYER = PARTYPLAYERS:WaitForChild("ADDPLAYER");
local DELETPARTY = PARTYPLAYERS:WaitForChild("DELETPARTY");
local MINIMIZEPARTY = PARTYPLAYERS:WaitForChild("MINIMIZEPARTY");
local TextBox = PARTYADD:WaitForChild("TextBox");
local ADDPLAYER2 = PARTYADD:WaitForChild("ADDPLAYER");
local NOMEJOGADOR = PARTYINVITED:WaitForChild("NOMEJOGADOR");
local YES = PARTYINVITED:WaitForChild("YES");
local NO = PARTYINVITED:WaitForChild("NO");
local PVP = BASE:FindFirstChild("PVP");
local Achivmentes = BASE:FindFirstChild("Achivmentes");
local u1 = {};
local u2 = {};

for i = 1, 5 do
    local v3 = PARTYPLAYERS:WaitForChild("PLAYER" .. i);
    u1[i] = v3;
    u2[i] = v3.Image;
    local _ = i;
end;

local function responsiveScale(p4) -- Line: 36
    local PartyResponsiveScale = p4:FindFirstChild("PartyResponsiveScale");

    if not PartyResponsiveScale then
        PartyResponsiveScale = Instance.new("UIScale");
        PartyResponsiveScale.Name = "PartyResponsiveScale";
        PartyResponsiveScale.Parent = p4;
    end;

    return PartyResponsiveScale;
end;

local PartyResponsiveScale = PARTYPLAYERS:FindFirstChild("PartyResponsiveScale");

if not PartyResponsiveScale then
    PartyResponsiveScale = Instance.new("UIScale");
    PartyResponsiveScale.Name = "PartyResponsiveScale";
    PartyResponsiveScale.Parent = PARTYPLAYERS;
end;

local PartyResponsiveScale2 = PARTYADD:FindFirstChild("PartyResponsiveScale");

if not PartyResponsiveScale2 then
    PartyResponsiveScale2 = Instance.new("UIScale");
    PartyResponsiveScale2.Name = "PartyResponsiveScale";
    PartyResponsiveScale2.Parent = PARTYADD;
end;

local PartyResponsiveScale3 = PARTYINVITED:FindFirstChild("PartyResponsiveScale");

if not PartyResponsiveScale3 then
    PartyResponsiveScale3 = Instance.new("UIScale");
    PartyResponsiveScale3.Name = "PartyResponsiveScale";
    PartyResponsiveScale3.Parent = PARTYINVITED;
end;

local u5 = nil;
local u6 = 0;

local function alignAchievementsButton() -- Line: 52
    -- upvalues: Achivmentes (copy), BASE (copy), MakeParty (copy), UserInputService (copy), PVP (copy)
    if not (Achivmentes and Achivmentes.Parent) then
        return;
    end;

    local AbsolutePosition = BASE.AbsolutePosition;
    local AbsoluteSize = BASE.AbsoluteSize;
    local AbsoluteSize2 = MakeParty.AbsoluteSize;
    local AbsoluteSize3 = Achivmentes.AbsoluteSize;

    if AbsoluteSize.X <= 0 or (AbsoluteSize.Y <= 0 or (AbsoluteSize2.X <= 0 or AbsoluteSize3.X <= 0)) then
        return;
    end;

    local v7 = UserInputService.TouchEnabled or AbsoluteSize.X < 700;
    local v8 = v7 and 8 or 12;
    local v9 = v7 and 10 or 12;
    local v10 = MakeParty.AbsolutePosition - AbsolutePosition;

    local function overlaps(p11, p12, p13) -- Line: 65
        -- upvalues: AbsolutePosition (copy), AbsoluteSize3 (copy)
        if not (p13 and (p13.Visible and p13.AbsoluteSize.X > 0)) then
            return false;
        end;

        local v14 = p13.AbsolutePosition - AbsolutePosition;
        local AbsoluteSize4 = p13.AbsoluteSize;
        local v15;

        if p11 < v14.X + AbsoluteSize4.X and (p11 + AbsoluteSize3.X > v14.X and p12 < v14.Y + AbsoluteSize4.Y) then
            v15 = p12 + AbsoluteSize3.Y > v14.Y;
        else
            v15 = false;
        end;

        return v15;
    end;

    local v16 = v10.X + (AbsoluteSize2.X - AbsoluteSize3.X) * 0.5;
    local v17 = v10.Y + (AbsoluteSize2.Y - AbsoluteSize3.Y) * 0.5;
    local v18;

    if v7 then
        v18 = {
            { v16, v10.Y - AbsoluteSize3.Y - v9 },
            { v16, v10.Y + AbsoluteSize2.Y + v9 },
            { v10.X - AbsoluteSize3.X - v9, v17 },
            { v10.X + AbsoluteSize2.X + v9, v17 }
        };
    else
        v18 = {
            { v16, v10.Y - AbsoluteSize3.Y - v9 },
            { v10.X - AbsoluteSize3.X - v9, v17 },
            { v10.X + AbsoluteSize2.X + v9, v17 },
            { v16, v10.Y + AbsoluteSize2.Y + v9 }
        };
    end;

    local v19 = nil;
    local v20 = nil;

    for _, v in ipairs(v18) do
        local v21 = v[1];
        local v22 = v[2];
        local v23;

        if v8 <= v21 and (v8 <= v22 and v21 + AbsoluteSize3.X <= AbsoluteSize.X - v8) then
            v23 = v22 + AbsoluteSize3.Y <= AbsoluteSize.Y - v8;
        else
            v23 = false;
        end;

        if v23 and not overlaps(v21, v22, PVP) then
            v20 = v22;
            v19 = v21;
            break;
        end;
    end;

    if not v19 then
        local v24 = v18[1][1];
        local math_max_ret = math.max(v8, AbsoluteSize.X - v8 - AbsoluteSize3.X);
        v19 = math.clamp(v24, v8, math_max_ret);
        local v25 = v18[1][2];
        local math_max_ret2 = math.max(v8, AbsoluteSize.Y - v8 - AbsoluteSize3.Y);
        v20 = math.clamp(v25, v8, math_max_ret2);
    end;

    Achivmentes.AnchorPoint = Vector2.zero;
    Achivmentes.Position = UDim2.fromOffset(math.floor(v19 + 0.5), (math.floor(v20 + 0.5)));
end;

local function updateResponsiveLayout() -- Line: 117
    -- upvalues: UserInputService (copy), script_Parent (copy), MakeParty (copy), Achivmentes (copy), alignAchievementsButton (copy), PartyResponsiveScale (copy), PartyResponsiveScale2 (copy), PartyResponsiveScale3 (copy), PARTYPLAYERS (copy), PVP (copy), BASE (copy), PARTYADD (copy), PARTYINVITED (copy)
    local workspace_CurrentCamera = workspace.CurrentCamera;
    local v26 = workspace_CurrentCamera and workspace_CurrentCamera.ViewportSize or Vector2.new(1280, 720);

    if v26.X < 320 or v26.Y < 240 then
        v26 = Vector2.new(1280, 720);
    end;

    local v27 = UserInputService.TouchEnabled or v26.X < 700;
    local u28 = v27 and 10 or 18;
    local v29;

    if v27 then
        local math_min_ret = math.min(v26.X / 520, v26.Y / 760);
        v29 = math.clamp(math_min_ret, 0.58, 0.75) or 1;
    else
        v29 = 1;
    end;

    script_Parent.DisplayOrder = 20;

    if MakeParty:GetAttribute("CustomPosition") ~= true then
        if v27 then
            MakeParty.AnchorPoint = Vector2.new(1, 0.5);
            MakeParty.Position = UDim2.new(1, -u28, 0.64, 0);
        else
            MakeParty.AnchorPoint = Vector2.new(1, 0.5);
            MakeParty.Position = UDim2.new(1, -u28, 0.44, 0);
        end;
    end;

    local u30 = v27 and 38 or 52;
    MakeParty.Size = UDim2.fromOffset(u30, u30);

    if Achivmentes then
        Achivmentes.Size = UDim2.fromOffset(u30, u30);
        task.defer(alignAchievementsButton);
    end;

    PartyResponsiveScale.Scale = v29;
    PartyResponsiveScale2.Scale = v29;
    PartyResponsiveScale3.Scale = v29;
    PARTYPLAYERS.AnchorPoint = Vector2.new(1, 0.5);
    PARTYPLAYERS.Position = UDim2.new(1, -u28, 0.48, 0);

    if PVP then
        PVP.Size = UDim2.fromOffset(u30, u30);
        PVP.AnchorPoint = Vector2.new(1, 0.5);
        local u31 = v27 and 8 or 12;
        task.defer(function() -- Line: 161
            -- upvalues: PVP (ref), MakeParty (ref), BASE (ref), PARTYPLAYERS (ref), u31 (copy), u28 (copy), Achivmentes (ref), u30 (copy), alignAchievementsButton (ref)
            if not (PVP.Parent and MakeParty.Parent) then
                return;
            end;

            local AbsolutePosition = BASE.AbsolutePosition;
            local AbsoluteSize = BASE.AbsoluteSize;
            local AbsoluteSize2 = PVP.AbsoluteSize;

            if AbsoluteSize.X <= 0 or (AbsoluteSize.Y <= 0 or (AbsoluteSize2.X <= 0 or AbsoluteSize2.Y <= 0)) then
                return;
            end;

            local v32 = PARTYPLAYERS.AbsolutePosition.X - AbsolutePosition.X;
            local v33 = PARTYPLAYERS.AbsolutePosition.Y - AbsolutePosition.Y;
            local AbsoluteSize3 = PARTYPLAYERS.AbsoluteSize;
            local v34 = v32 + AbsoluteSize3.X - AbsoluteSize2.X;
            local v35 = v33 - u31 - AbsoluteSize2.Y;

            if v35 < u28 then
                v34 = v32 + AbsoluteSize3.X + u31;
            else
                v33 = v35;
            end;

            local v36 = Achivmentes and u28 + u30 + u31 or u28;
            local math_max_ret = math.max(v36, AbsoluteSize.X - u28 - AbsoluteSize2.X);
            local math_clamp_ret = math.clamp(v34, v36, math_max_ret);
            local math_max_ret2 = math.max(u28, AbsoluteSize.Y - u28 - AbsoluteSize2.Y);
            local math_clamp_ret2 = math.clamp(v33, u28, math_max_ret2);
            PVP.AnchorPoint = Vector2.zero;
            PVP.Position = UDim2.fromOffset(math.floor(math_clamp_ret + 0.5), (math.floor(math_clamp_ret2 + 0.5)));
            task.defer(alignAchievementsButton);
        end);
    end;

    if v27 then
        PARTYADD.AnchorPoint = Vector2.new(1, 0);
        PARTYADD.Position = UDim2.new(1, -u28, 0.48, (math.floor(249 * v29 * 0.5 + 10)));
    else
        PARTYADD.AnchorPoint = Vector2.new(1, 0.5);
        PARTYADD.Position = UDim2.new(1, -(u28 + 166), 0.48, -94);
    end;

    PARTYINVITED.AnchorPoint = Vector2.new(0.5, 0.5);
    PARTYINVITED.Position = UDim2.fromScale(0.5, 0.5);
end;

local function bindViewport() -- Line: 205
    -- upvalues: u5 (ref), updateResponsiveLayout (copy)
    if u5 then
        u5:Disconnect();
        u5 = nil;
    end;

    local workspace_CurrentCamera = workspace.CurrentCamera;
    updateResponsiveLayout();

    if workspace_CurrentCamera then
        u5 = workspace_CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateResponsiveLayout);
    end;
end;

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindViewport);
BASE:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateResponsiveLayout);

if Achivmentes then
    MakeParty:GetPropertyChangedSignal("AbsolutePosition"):Connect(alignAchievementsButton);
    MakeParty:GetPropertyChangedSignal("AbsoluteSize"):Connect(alignAchievementsButton);
end;

if u5 then
    u5:Disconnect();
    u5 = nil;
end;

local workspace_CurrentCamera = workspace.CurrentCamera;
updateResponsiveLayout();

if workspace_CurrentCamera then
    u5 = workspace_CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateResponsiveLayout);
end;

LocalPlayer:GetAttributeChangedSignal("MobileHudResetRevision"):Connect(function() -- Line: 225
    -- upvalues: MakeParty (copy), updateResponsiveLayout (copy)
    MakeParty:SetAttribute("CustomPosition", false);
    updateResponsiveLayout();
end);

local function saveMakePartyPosition() -- Line: 230
    -- upvalues: MakeParty (copy), MobileHudLayoutRemote (copy)
    local workspace_CurrentCamera2 = workspace.CurrentCamera;

    if workspace_CurrentCamera2 then
        workspace_CurrentCamera2 = workspace_CurrentCamera2.ViewportSize;
    end;

    if not (workspace_CurrentCamera2 and (workspace_CurrentCamera2.X > 0 and workspace_CurrentCamera2.Y > 0)) then
        return;
    end;

    local u37 = MakeParty.AbsolutePosition + MakeParty.AbsoluteSize * 0.5;
    task.spawn(function() -- Line: 237
        -- upvalues: MobileHudLayoutRemote (ref), u37 (copy), workspace_CurrentCamera2 (copy)
        pcall(function() -- Line: 238
            -- upvalues: MobileHudLayoutRemote (ref), u37 (ref), workspace_CurrentCamera2 (ref)
            MobileHudLayoutRemote:InvokeServer("Merge", {
                PartyMakeParty = {
                    X = math.clamp(u37.X / workspace_CurrentCamera2.X, 0.02, 0.98),
                    Y = math.clamp(u37.Y / workspace_CurrentCamera2.Y, 0.02, 0.98)
                }
            });
        end);
    end);
end;

local u38 = false;
local u39 = false;
local u40 = nil;
local u41 = 0;
local Vector2_zero = Vector2.zero;
local Vector2_zero2 = Vector2.zero;
MakeParty.InputBegan:Connect(function(u42) -- Line: 280
    -- upvalues: LocalPlayer (copy), u38 (ref), u39 (ref), u40 (ref), u41 (ref), Vector2_zero (ref), Vector2_zero2 (ref), MakeParty (copy), u6 (ref), saveMakePartyPosition (copy)
    if LocalPlayer:GetAttribute("MobileHudEditMode") ~= true then
        return;
    end;

    if u42.UserInputType ~= Enum.UserInputType.Touch then
        return;
    end;

    u38 = true;
    u39 = false;
    u40 = u42;
    u41 = os.clock();
    Vector2_zero = Vector2.new(u42.Position.X, u42.Position.Y);
    Vector2_zero2 = MakeParty.AbsolutePosition + MakeParty.AbsoluteSize * 0.5;
    task.delay(0.65, function() -- Line: 294
        -- upvalues: u38 (ref), u40 (ref), u42 (copy), u39 (ref)
        if u38 and u40 == u42 then
            u39 = true;
        end;
    end);
    u42.Changed:Connect(function() -- Line: 300
        -- upvalues: u42 (copy), u38 (ref), u39 (ref), u6 (ref), saveMakePartyPosition (ref), u40 (ref)
        if u42.UserInputState == Enum.UserInputState.End then
            u38 = false;

            if u39 then
                u6 = os.clock() + 0.3;
                saveMakePartyPosition();
            end;

            u39 = false;

            if u40 == u42 then
                u40 = nil;
            end;
        end;
    end);
end);
UserInputService.InputChanged:Connect(function(p43) -- Line: 315
    -- upvalues: u38 (ref), u40 (ref), Vector2_zero (ref), u39 (ref), u41 (ref), MakeParty (copy), Vector2_zero2 (ref), BASE (copy), updateResponsiveLayout (copy)
    if not u38 or p43 ~= u40 then
        return;
    end;

    local v44 = Vector2.new(p43.Position.X, p43.Position.Y) - Vector2_zero;

    if not u39 then
        if v44.Magnitude > 12 and os.clock() - u41 < 0.65 then
            u38 = false;
            u40 = nil;
        end;

        return;
    end;

    local workspace_CurrentCamera2 = workspace.CurrentCamera;

    if workspace_CurrentCamera2 then
        workspace_CurrentCamera2 = workspace_CurrentCamera2.ViewportSize;
    end;

    if not workspace_CurrentCamera2 then
        return;
    end;

    local v45 = MakeParty.AbsoluteSize * 0.5;
    local v46 = Vector2_zero2 + v44;
    local Vector2_new_ret = Vector2.new(math.clamp(v46.X, v45.X + 6, workspace_CurrentCamera2.X - v45.X - 6), (math.clamp(v46.Y, v45.Y + 6, workspace_CurrentCamera2.Y - v45.Y - 6)));
    MakeParty:SetAttribute("CustomPosition", true);
    MakeParty.AnchorPoint = Vector2.new(0.5, 0.5);
    MakeParty.Position = UDim2.fromOffset(Vector2_new_ret.X - BASE.AbsolutePosition.X, Vector2_new_ret.Y - BASE.AbsolutePosition.Y);
    updateResponsiveLayout();
end);
LocalPlayer:GetAttributeChangedSignal("MobileHudEditMode"):Connect(function() -- Line: 349
    -- upvalues: u38 (ref), u39 (ref), u40 (ref)
    u38 = false;
    u39 = false;
    u40 = nil;
end);
task.spawn(function() -- Line: 249, Name: restoreMakePartyPosition
    -- upvalues: LocalPlayer (copy), MobileHudLayoutRemote (copy), MakeParty (copy), updateResponsiveLayout (copy)
    while LocalPlayer:GetAttribute("DataLoaded") ~= true and LocalPlayer.Parent do
        LocalPlayer:GetAttributeChangedSignal("DataLoaded"):Wait();
    end;

    local success, result = pcall(function() -- Line: 253
        -- upvalues: MobileHudLayoutRemote (ref)
        return MobileHudLayoutRemote:InvokeServer("Load");
    end);
    local v47 = success and (type(result) == "table" and result.PartyMakeParty) or nil;
    local v48;

    if type(v47) == "table" then
        v48 = tonumber(v47.X) or nil;
    else
        v48 = nil;
    end;

    local v49;

    if type(v47) == "table" then
        v49 = tonumber(v47.Y) or nil;
    else
        v49 = nil;
    end;

    if v48 and v49 then
        MakeParty:SetAttribute("CustomPosition", true);
        MakeParty.AnchorPoint = Vector2.new(0.5, 0.5);
        MakeParty.Position = UDim2.fromScale(math.clamp(v48, 0.02, 0.98), (math.clamp(v49, 0.02, 0.98)));
    end;

    task.defer(updateResponsiveLayout);
end);
local u50 = nil;
local u51 = false;
local u52 = 0;
local u53 = false;
local u54 = 0;
local u55 = {};
local u56 = {};
local u57 = {};

local function removeAllyIcon(p58) -- Line: 368
    -- upvalues: u55 (copy)
    local v59 = u55[p58];

    if v59 then
        v59:Destroy();
    end;

    u55[p58] = nil;
end;

local function attachAllyIcon(p60) -- Line: 376
    -- upvalues: u57 (copy), LocalPlayer (copy), u55 (copy)
    if not u57[p60] or p60 == LocalPlayer then
        return;
    end;

    local Character = p60.Character;

    if Character then
        Character = Character:FindFirstChild("Head");
    end;

    if not Character then
        return;
    end;

    local v61 = u55[p60];

    if v61 and (v61.Parent == Character and v61.Adornee == Character) then
        return;
    end;

    local v62 = u55[p60];

    if v62 then
        v62:Destroy();
    end;

    u55[p60] = nil;
    local PartyAllyIcon = Character:FindFirstChild("PartyAllyIcon");

    if PartyAllyIcon and PartyAllyIcon:IsA("BillboardGui") then
        PartyAllyIcon:Destroy();
    end;

    local BillboardGui = Instance.new("BillboardGui");
    BillboardGui.Name = "PartyAllyIcon";
    BillboardGui.Adornee = Character;
    BillboardGui.AlwaysOnTop = true;
    BillboardGui.LightInfluence = 0;
    BillboardGui.MaxDistance = 0;
    BillboardGui.Size = UDim2.fromOffset(18, 18);
    BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, 2.35, 0);
    local Frame = Instance.new("Frame");
    Frame.Name = "Icon";
    Frame.BackgroundTransparency = 1;
    Frame.BorderSizePixel = 0;
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.ZIndex = 10;
    Frame.Parent = BillboardGui;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(1, 0);
    UICorner.Parent = Frame;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Name = "WhiteOutline";
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke.Color = Color3.new(1, 1, 1);
    UIStroke.Thickness = 1.5;
    UIStroke.Transparency = 0;
    UIStroke.Parent = Frame;
    BillboardGui.Parent = Character;
    u55[p60] = BillboardGui;
end;

local function stopWatchingAlly(p63) -- Line: 430
    -- upvalues: u55 (copy), u56 (copy), u57 (copy)
    local v64 = u55[p63];

    if v64 then
        v64:Destroy();
    end;

    u55[p63] = nil;
    local v65 = u56[p63];

    if v65 then
        v65:Disconnect();
    end;

    u56[p63] = nil;
    u57[p63] = nil;
end;

local function watchAlly(u66) -- Line: 440
    -- upvalues: u56 (copy), attachAllyIcon (copy)
    if u56[u66] then
        attachAllyIcon(u66);

        return;
    end;

    u56[u66] = u66.CharacterAdded:Connect(function(u67) -- Line: 445
        -- upvalues: attachAllyIcon (ref), u66 (copy)
        task.spawn(function() -- Line: 446
            -- upvalues: u67 (copy), attachAllyIcon (ref), u66 (ref)
            u67:WaitForChild("Head", 10);
            attachAllyIcon(u66);
        end);
    end);
    attachAllyIcon(u66);
end;

local function refreshPartyIcons() -- Line: 454
    -- upvalues: u50 (ref), LocalPlayer (copy), Players (copy), u57 (copy), u55 (copy), u56 (copy), attachAllyIcon (copy)
    local v68 = {};

    if u50 and type(u50.members) == "table" then
        for _, v in ipairs(u50.members) do
            local v69 = tonumber(v.UserId);

            if v69 and v69 ~= LocalPlayer.UserId then
                local PlayerByUserId = Players:GetPlayerByUserId(v69);

                if PlayerByUserId then
                    v68[PlayerByUserId] = true;
                end;
            end;
        end;
    end;

    for i in pairs(u57) do
        if not v68[i] then
            local v70 = u55[i];

            if v70 then
                v70:Destroy();
            end;

            u55[i] = nil;
            local v71 = u56[i];

            if v71 then
                v71:Disconnect();
            end;

            u56[i] = nil;
            u57[i] = nil;
        end;
    end;

    for i in pairs(v68) do
        u57[i] = true;

        if u56[i] then
            attachAllyIcon(i);
        else
            u56[i] = i.CharacterAdded:Connect(function(u72) -- Line: 445
                -- upvalues: attachAllyIcon (ref), i (copy)
                task.spawn(function() -- Line: 446
                    -- upvalues: u72 (copy), attachAllyIcon (ref), i (ref)
                    u72:WaitForChild("Head", 10);
                    attachAllyIcon(i);
                end);
            end);
            attachAllyIcon(i);
        end;
    end;
end;

Players.PlayerRemoving:Connect(function(p73) -- Line: 479
    -- upvalues: u55 (copy), u56 (copy), u57 (copy)
    local v74 = u55[p73];

    if v74 then
        v74:Destroy();
    end;

    u55[p73] = nil;
    local v75 = u56[p73];

    if v75 then
        v75:Disconnect();
    end;

    u56[p73] = nil;
    u57[p73] = nil;
end);
script.Destroying:Connect(function() -- Line: 483
    -- upvalues: u57 (copy), u55 (copy), u56 (copy)
    local v76 = {};

    for i in pairs(u57) do
        table.insert(v76, i);
    end;

    for _, v in ipairs(v76) do
        local v77 = u55[v];

        if v77 then
            v77:Destroy();
        end;

        u55[v] = nil;
        local v78 = u56[v];

        if v78 then
            v78:Disconnect();
        end;

        u56[v] = nil;
        u57[v] = nil;
    end;
end);

local function setButtonEnabled(p79, p80) -- Line: 493
    p79.Visible = p80;
    p79.Active = p80;
    p79.Interactable = p80;
end;

local function showMessage(p81) -- Line: 499
    -- upvalues: u54 (ref), u53 (ref), TextBox (copy), PARTYADD (copy), u50 (ref), LocalPlayer (copy), u51 (ref)
    u54 = u54 + 1;
    local u82 = u54;
    u53 = false;
    TextBox.Text = "";
    TextBox.PlaceholderText = tostring(p81 or "");
    local v83;

    if u50 == nil or u50.leaderUserId ~= LocalPlayer.UserId then
        v83 = false;
    else
        v83 = not u51;
    end;

    PARTYADD.Visible = v83;
    task.delay(3, function() -- Line: 508
        -- upvalues: u54 (ref), u82 (copy), TextBox (ref)
        if u54 == u82 and TextBox.Parent then
            TextBox.PlaceholderText = "Player name";
        end;
    end);
end;

local function clearSlot(p84) -- Line: 515
    -- upvalues: u1 (copy), u2 (copy)
    local v85 = u1[p84];
    v85.Visible = false;
    v85.Image = u2[p84];
    v85:SetAttribute("PartyUserId", nil);
    v85:WaitForChild("NAME").Text = "";
    local DELETPLAYER = v85:WaitForChild("DELETPLAYER");
    DELETPLAYER.Visible = false;
    DELETPLAYER.Active = false;
    DELETPLAYER.Interactable = false;
end;

local function setThumbnail(u86, u87, u88) -- Line: 524
    -- upvalues: Players (copy), u1 (copy), u52 (ref)
    task.spawn(function() -- Line: 525
        -- upvalues: Players (ref), u87 (copy), u1 (ref), u86 (copy), u52 (ref), u88 (copy)
        local success, result = pcall(function() -- Line: 526
            -- upvalues: Players (ref), u87 (ref)
            return Players:GetUserThumbnailAsync(u87, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150);
        end);
        local v89 = u1[u86];

        if success and (u52 == u88 and v89:GetAttribute("PartyUserId") == u87) then
            v89.Image = result;
        end;
    end);
end;

local function renderParty(p90) -- Line: 542
    -- upvalues: u52 (ref), u50 (ref), u53 (ref), PARTYADD (copy), refreshPartyIcons (copy), u51 (ref), MakeParty (copy), PARTYPLAYERS (copy), u1 (copy), u2 (copy), updateResponsiveLayout (copy), MINIMIZEPARTY (copy), LocalPlayer (copy), ADDPLAYER (copy), DELETPARTY (copy), Players (copy)
    u52 = u52 + 1;
    local u91 = u52;
    u50 = type(p90) == "table" and p90 and p90 or nil;
    u53 = false;
    PARTYADD.Visible = false;
    refreshPartyIcons();

    if u50 then
        MakeParty.Visible = u51;
        MakeParty.Active = u51;
        MakeParty.Interactable = u51;
        PARTYPLAYERS.Visible = not u51;
        local v92 = MINIMIZEPARTY;
        v92.Visible = true;
        v92.Active = true;
        v92.Interactable = true;
        local v93 = type(u50.members) == "table" and (u50.members or {}) or {};
        local v94 = u50.leaderUserId == LocalPlayer.UserId;
        local v95 = ADDPLAYER;
        local v96;

        if v94 then
            v96 = #v93 < 5;
        else
            v96 = v94;
        end;

        v95.Visible = v96;
        v95.Active = v96;
        v95.Interactable = v96;
        local v97 = DELETPARTY;
        v97.Visible = v94;
        v97.Active = v94;
        v97.Interactable = v94;

        for i = 1, 5 do
            local v98 = u1[i];
            local v99 = v93[i];
            local v100;

            if type(v99) == "table" and tonumber(v99.UserId) then
                local u101 = tonumber(v99.UserId);
                v98.Visible = true;
                v98:SetAttribute("PartyUserId", u101);
                local NAME = v98:WaitForChild("NAME");
                local string_format = string.format;
                local v102 = tostring(v99.Name or (v99.DisplayName or "Player"));
                local v103 = tonumber(v99.Years) or 0;
                local math_floor_ret = math.floor(v103);
                NAME.Text = string_format("%s | Lv %d", v102, (math.max(0, math_floor_ret)));
                local DELETPLAYER = v98:WaitForChild("DELETPLAYER");
                local v104;

                if v94 then
                    v104 = u101 ~= LocalPlayer.UserId;
                else
                    v104 = v94;
                end;

                DELETPLAYER.Visible = v104;
                DELETPLAYER.Active = v104;
                DELETPLAYER.Interactable = v104;
                task.spawn(function() -- Line: 525
                    -- upvalues: Players (ref), u101 (copy), u1 (ref), i (copy), u52 (ref), u91 (copy)
                    local success, result = pcall(function() -- Line: 526
                        -- upvalues: Players (ref), u101 (ref)
                        return Players:GetUserThumbnailAsync(u101, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150);
                    end);
                    local v105 = u1[i];

                    if success and (u52 == u91 and v105:GetAttribute("PartyUserId") == u101) then
                        v105.Image = result;
                    end;
                end);
                v100 = i;
            else
                local v106 = u1[i];
                v106.Visible = false;
                v106.Image = u2[i];
                v106:SetAttribute("PartyUserId", nil);
                v106:WaitForChild("NAME").Text = "";
                local DELETPLAYER = v106:WaitForChild("DELETPLAYER");
                DELETPLAYER.Visible = false;
                DELETPLAYER.Active = false;
                DELETPLAYER.Interactable = false;
                v100 = i;
            end;
        end;

        updateResponsiveLayout();

        return;
    end;

    u51 = false;
    MakeParty.Visible = true;
    MakeParty.Active = true;
    MakeParty.Interactable = true;
    PARTYPLAYERS.Visible = false;
    local v107 = u1[1];
    v107.Visible = false;
    v107.Image = u2[1];
    v107:SetAttribute("PartyUserId", nil);
    v107:WaitForChild("NAME").Text = "";
    local DELETPLAYER = v107:WaitForChild("DELETPLAYER");
    DELETPLAYER.Visible = false;
    DELETPLAYER.Active = false;
    DELETPLAYER.Interactable = false;
    local v108 = u1[2];
    v108.Visible = false;
    v108.Image = u2[2];
    v108:SetAttribute("PartyUserId", nil);
    v108:WaitForChild("NAME").Text = "";
    local DELETPLAYER2 = v108:WaitForChild("DELETPLAYER");
    DELETPLAYER2.Visible = false;
    DELETPLAYER2.Active = false;
    DELETPLAYER2.Interactable = false;
    local v109 = u1[3];
    v109.Visible = false;
    v109.Image = u2[3];
    v109:SetAttribute("PartyUserId", nil);
    v109:WaitForChild("NAME").Text = "";
    local DELETPLAYER3 = v109:WaitForChild("DELETPLAYER");
    DELETPLAYER3.Visible = false;
    DELETPLAYER3.Active = false;
    DELETPLAYER3.Interactable = false;
    local v110 = u1[4];
    v110.Visible = false;
    v110.Image = u2[4];
    v110:SetAttribute("PartyUserId", nil);
    v110:WaitForChild("NAME").Text = "";
    local DELETPLAYER4 = v110:WaitForChild("DELETPLAYER");
    DELETPLAYER4.Visible = false;
    DELETPLAYER4.Active = false;
    DELETPLAYER4.Interactable = false;
    local v111 = u1[5];
    v111.Visible = false;
    v111.Image = u2[5];
    v111:SetAttribute("PartyUserId", nil);
    v111:WaitForChild("NAME").Text = "";
    local DELETPLAYER5 = v111:WaitForChild("DELETPLAYER");
    DELETPLAYER5.Visible = false;
    DELETPLAYER5.Active = false;
    DELETPLAYER5.Interactable = false;
    updateResponsiveLayout();
end;

local function submitInvite() -- Line: 595
    -- upvalues: u53 (ref), u50 (ref), LocalPlayer (copy), TextBox (copy), showMessage (copy), PartyRemote (copy)
    if u53 or (not u50 or u50.leaderUserId ~= LocalPlayer.UserId) then
        return;
    end;

    local v112 = TextBox.Text:gsub("^%s+", ""):gsub("%s+$", "");

    if v112 == "" then
        showMessage("Enter a player name");

        return;
    end;

    u53 = true;
    TextBox.PlaceholderText = "Sending...";
    PartyRemote:FireServer("Invite", v112);
end;

for _, v in ipairs(u1) do
    v:WaitForChild("DELETPLAYER").Activated:Connect(function() -- Line: 610
        -- upvalues: u50 (ref), LocalPlayer (copy), v (copy), PartyRemote (copy)
        if not u50 or u50.leaderUserId ~= LocalPlayer.UserId then
            return;
        end;

        local Attribute = v:GetAttribute("PartyUserId");

        if Attribute and Attribute ~= LocalPlayer.UserId then
            PartyRemote:FireServer("Remove", Attribute);
        end;
    end);
end;

MakeParty.Activated:Connect(function() -- Line: 621
    -- upvalues: LocalPlayer (copy), u6 (ref), u50 (ref), u51 (ref), MakeParty (copy), PARTYPLAYERS (copy), updateResponsiveLayout (copy), PartyRemote (copy)
    if LocalPlayer:GetAttribute("MobileHudEditMode") == true then
        return;
    end;

    if os.clock() < u6 then
        return;
    end;

    if not u50 then
        MakeParty.Active = false;
        MakeParty.Interactable = false;
        PartyRemote:FireServer("Create");
        task.delay(2, function() -- Line: 641
            -- upvalues: u50 (ref), MakeParty (ref)
            if not u50 and MakeParty.Parent then
                MakeParty.Active = true;
                MakeParty.Interactable = true;
            end;
        end);

        return;
    end;

    u51 = false;
    MakeParty.Visible = false;
    MakeParty.Active = false;
    MakeParty.Interactable = false;
    PARTYPLAYERS.Visible = true;
    updateResponsiveLayout();
end);
MINIMIZEPARTY.Activated:Connect(function() -- Line: 649
    -- upvalues: u50 (ref), u51 (ref), PARTYADD (copy), PARTYPLAYERS (copy), MakeParty (copy), updateResponsiveLayout (copy)
    if u50 then
        u51 = true;
        PARTYADD.Visible = false;
        PARTYPLAYERS.Visible = false;
        MakeParty.Visible = true;
        MakeParty.Active = true;
        MakeParty.Interactable = true;
        updateResponsiveLayout();
    end;
end);
ADDPLAYER.Activated:Connect(function() -- Line: 661
    -- upvalues: u50 (ref), LocalPlayer (copy), u54 (ref), u53 (ref), TextBox (copy), PARTYADD (copy)
    if u50 and u50.leaderUserId == LocalPlayer.UserId then
        u54 = u54 + 1;
        u53 = false;
        TextBox.Text = "";
        TextBox.PlaceholderText = "Player name";
        PARTYADD.Visible = true;
        TextBox:CaptureFocus();
    end;
end);
ADDPLAYER2.Activated:Connect(submitInvite);
TextBox.FocusLost:Connect(function(p113) -- Line: 673
    -- upvalues: submitInvite (copy)
    if p113 then
        submitInvite();
    end;
end);
DELETPARTY.Activated:Connect(function() -- Line: 679
    -- upvalues: u50 (ref), LocalPlayer (copy), PARTYADD (copy), PartyRemote (copy)
    if u50 and u50.leaderUserId == LocalPlayer.UserId then
        PARTYADD.Visible = false;
        PartyRemote:FireServer("Delete");
    end;
end);
YES.Activated:Connect(function() -- Line: 686
    -- upvalues: PARTYINVITED (copy), PartyRemote (copy)
    PARTYINVITED.Visible = false;
    PartyRemote:FireServer("RespondInvite", true);
end);
NO.Activated:Connect(function() -- Line: 691
    -- upvalues: PARTYINVITED (copy), PartyRemote (copy)
    PARTYINVITED.Visible = false;
    PartyRemote:FireServer("RespondInvite", false);
end);
PartyRemote.OnClientEvent:Connect(function(p114, p115) -- Line: 696
    -- upvalues: renderParty (copy), NOMEJOGADOR (copy), PARTYINVITED (copy), u53 (ref), TextBox (copy), PARTYADD (copy), showMessage (copy)
    if p114 == "PartyState" then
        renderParty(p115);

        return;
    end;

    if p114 == "Invite" and type(p115) == "table" then
        NOMEJOGADOR.Text = tostring(p115.Name or (p115.DisplayName or "Player"));
        PARTYINVITED.Visible = true;

        return;
    end;

    if p114 == "InviteClosed" then
        PARTYINVITED.Visible = false;

        return;
    end;

    if p114 ~= "InviteSent" then
        if p114 == "Error" then
            showMessage(p115);
        end;

        return;
    end;

    u53 = false;
    TextBox.Text = "";
    PARTYADD.Visible = false;
end);
PARTYINVITED.Visible = false;
PARTYADD.Visible = false;

if PVP then
    local u116 = LocalPlayer:GetAttribute("PVPDisabled") == true;
    local ImageColor3 = PVP.ImageColor3;

    local function updatePVPVisual() -- Line: 720
        -- upvalues: u116 (ref), LocalPlayer (copy), PVP (copy), ImageColor3 (copy)
        u116 = LocalPlayer:GetAttribute("PVPDisabled") == true;
        PVP.ImageColor3 = u116 and Color3.fromRGB(255, 100, 100) or ImageColor3;
    end;

    PVP.Activated:Connect(function() -- Line: 727
        -- upvalues: PartyRemote (copy), u116 (ref)
        PartyRemote:FireServer("TogglePVP", not u116);
    end);
    LocalPlayer:GetAttributeChangedSignal("PVPDisabled"):Connect(updatePVPVisual);

    if LocalPlayer:GetAttribute("PVPDisabled") == true then
        u116 = true;
    else
        u116 = false;
    end;

    if u116 then
        ImageColor3 = Color3.fromRGB(255, 100, 100) or ImageColor3;
    end;

    PVP.ImageColor3 = ImageColor3;
end;

renderParty(nil);
PartyRemote:FireServer("GetState");
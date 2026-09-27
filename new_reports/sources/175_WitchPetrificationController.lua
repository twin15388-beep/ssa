-- Decompiled with Potassium's decompiler.

local TeamGuiLayout = require(game:GetService("ReplicatedStorage"):WaitForChild("TeamGuiLayout"));
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService");
local StarterGui = game:GetService("StarterGui");
local LocalPlayer = Players.LocalPlayer;
local NetworkRegistry = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("NetworkRegistry"));
local Event = NetworkRegistry.GetEvent("Combat", "WitchPetrificationRequest");
local WitchPetrificationRemote = NetworkRegistry.Legacy.Events:WaitForChild("WitchPetrificationRemote");
local Petrification = require(ReplicatedStorage:WaitForChild("Funções"):WaitForChild("WitchSpellsConfig")).Petrification;
local u1 = nil;
local u2 = nil;
local u3 = false;
local u4 = 0;
local u5 = 0;
local u6 = tonumber(LocalPlayer:GetAttribute("WitchPetrificationCooldownEnd")) or 0;
local u7 = 0;
local u8 = 0;
local u9 = nil;
local Highlight = Instance.new("Highlight");
Highlight.Name = "WitchPetrificationTargetHighlight";
Highlight.FillTransparency = 1;
Highlight.OutlineColor = Color3.fromRGB(255, 0, 0);
Highlight.OutlineTransparency = 0;
Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
Highlight.Enabled = false;
Highlight.Parent = workspace;

local function clearHighlight() -- Line: 33
    -- upvalues: Highlight (copy), u9 (ref)
    Highlight.Adornee = nil;
    Highlight.Enabled = false;
    u9 = nil;
end;

script.Destroying:Connect(function() -- Line: 39
    -- upvalues: Highlight (copy)
    if Highlight.Parent then
        Highlight:Destroy();
    end;
end);

local function isWitch() -- Line: 45
    -- upvalues: LocalPlayer (copy)
    local v10;

    if LocalPlayer.Team == nil then
        v10 = false;
    else
        v10 = LocalPlayer.Team.Name == "Witches";
    end;

    return v10;
end;

local function getYears() -- Line: 49
    -- upvalues: LocalPlayer (copy)
    local v11 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
    local math_floor_ret = math.floor(v11);

    return math.max(0, math_floor_ret);
end;

local function isAvailable() -- Line: 53
    -- upvalues: LocalPlayer (copy), Petrification (copy)
    local Character = LocalPlayer.Character;
    local v12;

    if Character then
        v12 = Character:FindFirstChildOfClass("Humanoid");
    else
        v12 = Character;
    end;

    local v13;

    if LocalPlayer.Team == nil then
        v13 = false;
    else
        v13 = LocalPlayer.Team.Name == "Witches";
    end;

    if v13 then
        local v14 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
        local math_floor_ret = math.floor(v14);

        if math.max(0, math_floor_ret) >= Petrification.UnlockYears and (v12 ~= nil and (v12.Health > 0 and (Character:GetAttribute("ActionLocked") ~= true and (Character:GetAttribute("Hibernating") ~= true and (Character:GetAttribute("Ragdolled") ~= true and Character:GetAttribute("SoulDrainActive") ~= true))))) then
            v13 = Character:GetAttribute("FlyingBroom") ~= true;
        else
            v13 = false;
        end;
    end;

    return v13;
end;

local function getPetrificationButton(p15) -- Line: 66
    -- upvalues: TeamGuiLayout (copy)
    local v16 = "Witches" .. TeamGuiLayout.GetMode();

    if p15 then
        p15 = TeamGuiLayout.FindPanel(p15, v16);
    end;

    if p15 then
        p15 = TeamGuiLayout.GetMenu(p15);
    end;

    if p15 then
        p15 = p15:FindFirstChild("Powers1") or p15:FindFirstChild("Powers");
    end;

    if p15 then
        p15 = p15:FindFirstChild("Petrification");
    end;

    if not (p15 and (p15:IsA("GuiObject") and p15)) then
        p15 = nil;
    end;

    return p15;
end;

local function findButton() -- Line: 75
    -- upvalues: getPetrificationButton (copy), LocalPlayer (copy)
    return getPetrificationButton(LocalPlayer:FindFirstChildOfClass("PlayerGui"));
end;

local function findTemplateButton() -- Line: 79
    -- upvalues: getPetrificationButton (copy), StarterGui (copy)
    return getPetrificationButton(StarterGui);
end;

local function getCooldownLabel() -- Line: 83
    -- upvalues: u1 (ref)
    if not u1 then
        return nil;
    end;

    local v17 = u1:FindFirstChild("COLDOWN") or u1:FindFirstChild("Coldown");

    if v17 and v17:IsA("TextLabel") then
        return v17;
    end;

    if not u1:IsA("GuiButton") then
        return nil;
    end;

    local CooldownText = u1:FindFirstChild("CooldownText");

    if not CooldownText then
        CooldownText = Instance.new("TextLabel");
        CooldownText.Name = "CooldownText";
        CooldownText.BackgroundTransparency = 1;
        CooldownText.AnchorPoint = Vector2.new(0.5, 0.5);
        CooldownText.Position = UDim2.fromScale(0.5, 0.5);
        CooldownText.Size = UDim2.fromScale(0.5, 0.5);
        CooldownText.Font = Enum.Font.JosefinSans;
        CooldownText.TextColor3 = Color3.new(1, 1, 1);
        CooldownText.TextScaled = true;
        CooldownText.TextStrokeTransparency = 0.2;
        CooldownText.ZIndex = u1.ZIndex + 4;
        CooldownText.Parent = u1;
    end;

    return CooldownText;
end;

local function cancelTargeting() -- Line: 108
    -- upvalues: u3 (ref), u4 (ref), u5 (ref), Highlight (copy), u9 (ref)
    u3 = false;
    u4 = 0;
    u5 = 0;
    Highlight.Adornee = nil;
    Highlight.Enabled = false;
    u9 = nil;
end;

local function refreshButton() -- Line: 115
    -- upvalues: LocalPlayer (copy), Petrification (copy), TeamGuiLayout (copy), u1 (ref), u2 (ref), u6 (ref), u3 (ref), u5 (ref), u4 (ref), Highlight (copy), u9 (ref), isAvailable (copy), getCooldownLabel (copy)
    local v18;

    if LocalPlayer.Team == nil then
        v18 = false;
    else
        v18 = LocalPlayer.Team.Name == "Witches";
    end;

    local v19 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
    local math_floor_ret = math.floor(v19);
    local v20 = math.max(0, math_floor_ret) >= Petrification.UnlockYears;
    local v21 = LocalPlayer:FindFirstChildOfClass("PlayerGui");

    if v21 then
        for _, v in ipairs({ "WitchesPC", "WitchesMOBILE", "WitchesCONSOLE" }) do
            local v22 = TeamGuiLayout.FindPanel(v21, v);

            if v22 then
                v22 = TeamGuiLayout.GetMenu(v22);
            end;

            if v22 then
                v22 = v22:FindFirstChild("Powers1") or v22:FindFirstChild("Powers");
            end;

            if v22 then
                v22 = v22:FindFirstChild("Petrification");
            end;

            if v == "WitchesPC" then
                if v22 then
                    v22 = v22:FindFirstChild("UNLOCKLV");
                end;
            elseif v22 then
                v22 = v22:FindFirstChild("UNLOCKLV") or (v22:FindFirstChild("UnlockRequirement") or v22:FindFirstChild("UnlockRequirement1"));
            end;

            if v22 and v22:IsA("TextLabel") then
                local v23;

                if v18 then
                    v23 = not v20;
                else
                    v23 = v18;
                end;

                v22.Visible = v23;
                v22.Text = "LV " .. tostring(Petrification.UnlockYears);
            end;
        end;
    end;

    if not (u1 and (u1.Parent and u2)) then
        return;
    end;

    local v24 = u6 - workspace:GetServerTimeNow();
    local math_max_ret = math.max(0, v24);

    if u3 and u5 <= workspace:GetServerTimeNow() then
        u3 = false;
        u4 = 0;
        u5 = 0;
        Highlight.Adornee = nil;
        Highlight.Enabled = false;
        u9 = nil;
    end;

    local u25;

    if v18 then
        if v20 then
            if math_max_ret <= 0 then
                u25 = not u3 and isAvailable();
            else
                u25 = false;
            end;
        else
            u25 = v20;
        end;
    else
        u25 = v18;
    end;

    u1.Visible = v18;
    u1.Active = u25;

    if u1:IsA("GuiButton") then
        local v26;

        if u25 then
            v26 = u2.autoButtonColor;
        else
            v26 = u25;
        end;

        u1.AutoButtonColor = v26;
    end;

    pcall(function() -- Line: 152
        -- upvalues: u1 (ref), u25 (copy)
        u1.Interactable = u25;
    end);
    local v27 = getCooldownLabel();

    if v27 then
        if v18 then
            v18 = math_max_ret > 0;
        end;

        v27.Visible = v18;
        local v28;

        if math_max_ret > 0 then
            local math_ceil_ret = math.ceil(math_max_ret);
            v28 = tostring(math_ceil_ret) or "";
        else
            v28 = "";
        end;

        v27.Text = v28;
    end;

    if v20 and (math_max_ret <= 0 and not u3) then
        if u1:IsA("TextLabel") then
            u1.TextColor3 = u2.textColor;
            u1.TextTransparency = u2.textTransparency;
        elseif u1:IsA("ImageButton") then
            u1.ImageColor3 = u2.imageColor;
            u1.ImageTransparency = u2.imageTransparency;
        end;

        u1.BackgroundColor3 = u2.backgroundColor;
        u1.BackgroundTransparency = u2.backgroundTransparency;
    else
        if u1:IsA("TextLabel") then
            u1.TextColor3 = u2.textColor:Lerp(Color3.new(0, 0, 0), 0.62);
            u1.TextTransparency = math.min(0.82, u2.textTransparency + 0.25);
        elseif u1:IsA("ImageButton") then
            u1.ImageColor3 = u2.imageColor:Lerp(Color3.new(0, 0, 0), 0.58);
            u1.ImageTransparency = math.min(0.85, u2.imageTransparency + 0.08);
        end;

        u1.BackgroundColor3 = u2.backgroundColor:Lerp(Color3.new(0, 0, 0), 0.58);
        u1.BackgroundTransparency = u2.backgroundTransparency;
    end;

    u1:SetAttribute("Targeting", u3);
    u1:SetAttribute("PowerCooldown", (math.ceil(math_max_ret)));
end;

local function armSpell() -- Line: 185
    -- upvalues: isAvailable (copy), u6 (ref), refreshButton (copy), u3 (ref), u4 (ref), u5 (ref), Highlight (copy), u9 (ref), Event (copy)
    if not isAvailable() or workspace:GetServerTimeNow() < u6 then
        refreshButton();

        return;
    end;

    u3 = false;
    u4 = 0;
    u5 = 0;
    Highlight.Adornee = nil;
    Highlight.Enabled = false;
    u9 = nil;
    refreshButton();
    Event:FireServer();
end;

local function findModelFromInstance(p29) -- Line: 198
    while p29 and p29 ~= workspace do
        if p29:IsA("Model") and p29:FindFirstChildOfClass("Humanoid") then
            return p29;
        end;

        p29 = p29.Parent;
    end;

    return nil;
end;

local function isTargetEligible(p30) -- Line: 209
    -- upvalues: LocalPlayer (copy), Petrification (copy)
    if not p30 or p30 == LocalPlayer.Character then
        return false;
    end;

    if p30:GetAttribute("QuestNPC") == true or (p30:GetAttribute("Immortal") == true or (p30:GetAttribute("Invulnerable") == true or (p30:GetAttribute("NoWitchPetrification") == true or (p30:GetAttribute("ActionLocked") == true or (p30:GetAttribute("Hibernating") == true or (p30:GetAttribute("Ragdolled") == true or (p30:GetAttribute("BeingCarried") == true or (p30:GetAttribute("SoulDrainActive") == true or (p30:GetAttribute("WitchBreakNeckActive") == true or (p30:GetAttribute("Petrified") == true or p30:GetAttribute("FlyingBroom") == true)))))))))) then
        return false;
    end;

    local v31 = p30:FindFirstChildOfClass("Humanoid");
    local HumanoidRootPart = p30:FindFirstChild("HumanoidRootPart");
    local v32 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart");

    if v31 and (v31.Health > 0 and (HumanoidRootPart and v32)) then
        return (HumanoidRootPart.Position - v32.Position).Magnitude <= Petrification.MaximumDistance;
    end;

    return false;
end;

local function updateTargetHighlight() -- Line: 236
    -- upvalues: Highlight (copy), u9 (ref)
    Highlight.Adornee = nil;
    Highlight.Enabled = false;
    u9 = nil;
end;

local function castAt(p33) -- Line: 240
end;

local function raycastScreen(p34) -- Line: 244
    return nil;
end;

local function shakeCamera() -- Line: 248
    -- upvalues: u8 (ref), RunService (copy)
    u8 = u8 + 1;
    local u35 = u8;
    local os_clock_ret = os.clock();
    RunService:UnbindFromRenderStep("WitchPetrificationShake");
    RunService:BindToRenderStep("WitchPetrificationShake", Enum.RenderPriority.Camera.Value + 1, function() -- Line: 254
        -- upvalues: u35 (copy), u8 (ref), os_clock_ret (copy), RunService (ref)
        if u35 ~= u8 or os.clock() - os_clock_ret >= 0.55 then
            RunService:UnbindFromRenderStep("WitchPetrificationShake");

            return;
        end;

        local workspace_CurrentCamera = workspace.CurrentCamera;

        if workspace_CurrentCamera then
            local v36 = 1 - (os.clock() - os_clock_ret) / 0.55;
            local v37 = (math.random() - 0.5) * 0.3 * v36;
            local v38 = (math.random() - 0.5) * 0.3 * v36;
            local v39 = (math.random() - 0.5) * 1.4 * v36;
            local math_rad_ret = math.rad(v39);
            workspace_CurrentCamera.CFrame = workspace_CurrentCamera.CFrame * (CFrame.new(v37, v38, 0) * CFrame.Angles(0, 0, math_rad_ret));
        end;
    end);
end;

local function bindButton() -- Line: 270
    -- upvalues: getPetrificationButton (copy), LocalPlayer (copy), u1 (ref), StarterGui (copy), u2 (ref), u7 (ref), isAvailable (copy), u6 (ref), refreshButton (copy), u3 (ref), u4 (ref), u5 (ref), Highlight (copy), u9 (ref), Event (copy)
    local v40 = getPetrificationButton(LocalPlayer:FindFirstChildOfClass("PlayerGui"));

    if not v40 or v40 == u1 then
        return;
    end;

    u1 = v40;
    local v41 = getPetrificationButton(StarterGui);
    u1.Active = true;
    u2 = {
        textColor = v41 and v41:IsA("TextLabel") and v41.TextColor3 or (u1:IsA("TextLabel") and u1.TextColor3 or Color3.new(1, 1, 1)),
        textTransparency = v41 and v41:IsA("TextLabel") and v41.TextTransparency or (u1:IsA("TextLabel") and u1.TextTransparency or 0),
        imageColor = v41 and v41:IsA("ImageButton") and v41.ImageColor3 or (u1:IsA("ImageButton") and u1.ImageColor3 or Color3.new(1, 1, 1)),
        imageTransparency = v41 and v41:IsA("ImageButton") and v41.ImageTransparency or (u1:IsA("ImageButton") and u1.ImageTransparency or 0),
        backgroundColor = v41 and v41.BackgroundColor3 or u1.BackgroundColor3,
        backgroundTransparency = v41 and v41.BackgroundTransparency or u1.BackgroundTransparency,
        autoButtonColor = v41 and (v41:IsA("GuiButton") and v41.AutoButtonColor) or (u1:IsA("GuiButton") and u1.AutoButtonColor or false)
    };
    u7 = u7 + 1;
    local u42 = u7;

    local function activateFromUi() -- Line: 294
        -- upvalues: u42 (copy), u7 (ref), u1 (ref), isAvailable (ref), u6 (ref), refreshButton (ref), u3 (ref), u4 (ref), u5 (ref), Highlight (ref), u9 (ref), Event (ref)
        if u42 ~= u7 then
            return;
        end;

        local v43 = u1:FindFirstAncestorOfClass("ScreenGui");
        local Parent = u1.Parent;

        if v43 and (v43.Enabled and (not Parent or Parent:GetAttribute("IsDragging") ~= true)) then
            if not isAvailable() or workspace:GetServerTimeNow() < u6 then
                refreshButton();

                return;
            end;

            u3 = false;
            u4 = 0;
            u5 = 0;
            Highlight.Adornee = nil;
            Highlight.Enabled = false;
            u9 = nil;
            refreshButton();
            Event:FireServer();
        end;
    end;

    if u1:IsA("GuiButton") then
        u1.Activated:Connect(activateFromUi);
    else
        u1.InputBegan:Connect(function(p44) -- Line: 305
            -- upvalues: u42 (copy), u7 (ref), u1 (ref), isAvailable (ref), u6 (ref), refreshButton (ref), u3 (ref), u4 (ref), u5 (ref), Highlight (ref), u9 (ref), Event (ref)
            if p44.UserInputType == Enum.UserInputType.MouseButton1 or p44.UserInputType == Enum.UserInputType.Touch then
                if u42 ~= u7 then
                    return;
                end;

                local v45 = u1:FindFirstAncestorOfClass("ScreenGui");
                local Parent = u1.Parent;

                if v45 and (v45.Enabled and (not Parent or Parent:GetAttribute("IsDragging") ~= true)) then
                    if not isAvailable() or workspace:GetServerTimeNow() < u6 then
                        refreshButton();

                        return;
                    end;

                    u3 = false;
                    u4 = 0;
                    u5 = 0;
                    Highlight.Adornee = nil;
                    Highlight.Enabled = false;
                    u9 = nil;
                    refreshButton();
                    Event:FireServer();
                end;
            end;
        end);
    end;

    refreshButton();
end;

UserInputService.InputBegan:Connect(function(p46, p47) -- Line: 316
    -- upvalues: UserInputService (copy), isAvailable (copy), u6 (ref), refreshButton (copy), u3 (ref), u4 (ref), u5 (ref), Highlight (copy), u9 (ref), Event (copy)
    if not (p46.KeyCode ~= Enum.KeyCode.F and p46.KeyCode ~= Enum.KeyCode.ButtonY or (p47 or UserInputService:GetFocusedTextBox())) then
        if not isAvailable() or workspace:GetServerTimeNow() < u6 then
            refreshButton();

            return;
        end;

        u3 = false;
        u4 = 0;
        u5 = 0;
        Highlight.Adornee = nil;
        Highlight.Enabled = false;
        u9 = nil;
        refreshButton();
        Event:FireServer();
    end;
end);
WitchPetrificationRemote.OnClientEvent:Connect(function(p48, p49, p50) -- Line: 322
    -- upvalues: u6 (ref), Petrification (copy), u3 (ref), u4 (ref), u5 (ref), Highlight (copy), u9 (ref), shakeCamera (copy), refreshButton (copy)
    if p48 == "CastSuccess" then
        u6 = tonumber(p49) or workspace:GetServerTimeNow() + Petrification.Cooldown;
        u3 = false;
        u4 = 0;
        u5 = 0;
        Highlight.Adornee = nil;
        Highlight.Enabled = false;
        u9 = nil;
        shakeCamera();
    elseif p48 == "Rejected" then
        if p49 == "Cooldown" then
            u6 = tonumber(p50) or u6;
        end;

        u3 = false;
        u4 = 0;
        u5 = 0;
        Highlight.Adornee = nil;
        Highlight.Enabled = false;
        u9 = nil;
    end;

    refreshButton();
end);
LocalPlayer:GetAttributeChangedSignal("WitchPetrificationCooldownEnd"):Connect(function() -- Line: 336
    -- upvalues: u6 (ref), LocalPlayer (copy), refreshButton (copy)
    u6 = tonumber(LocalPlayer:GetAttribute("WitchPetrificationCooldownEnd")) or 0;
    refreshButton();
end);
LocalPlayer:GetAttributeChangedSignal("Years"):Connect(refreshButton);
LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function() -- Line: 343
    -- upvalues: u3 (ref), u4 (ref), u5 (ref), Highlight (copy), u9 (ref), u1 (ref), u2 (ref), bindButton (copy)
    u3 = false;
    u4 = 0;
    u5 = 0;
    Highlight.Adornee = nil;
    Highlight.Enabled = false;
    u9 = nil;
    u1 = nil;
    u2 = nil;
    task.defer(bindButton);
end);
LocalPlayer.CharacterAdded:Connect(function() -- Line: 349
    -- upvalues: u3 (ref), u4 (ref), u5 (ref), Highlight (copy), u9 (ref), refreshButton (copy)
    u3 = false;
    u4 = 0;
    u5 = 0;
    Highlight.Adornee = nil;
    Highlight.Enabled = false;
    u9 = nil;
    refreshButton();
end);
LocalPlayer:WaitForChild("PlayerGui").DescendantAdded:Connect(function(p51) -- Line: 355
    -- upvalues: u1 (ref), u2 (ref), bindButton (copy)
    if p51.Name == "Petrification" and p51:IsA("GuiObject") then
        u1 = nil;
        u2 = nil;
        task.defer(bindButton);
    end;
end);
bindButton();
RunService.RenderStepped:Connect(function() -- Line: 366
    -- upvalues: refreshButton (copy), Highlight (copy), u9 (ref)
    refreshButton();
    Highlight.Adornee = nil;
    Highlight.Enabled = false;
    u9 = nil;
end);
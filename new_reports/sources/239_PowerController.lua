-- Decompiled with Potassium's decompiler.

local TeamGuiLayout = require(game:GetService("ReplicatedStorage"):WaitForChild("TeamGuiLayout"));
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ContextActionService = game:GetService("ContextActionService");
local GuiService = game:GetService("GuiService");
local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService");
local LocalPlayer = Players.LocalPlayer;
local script_Parent = script.Parent;
local Parent = script_Parent.Parent;
local v1 = ReplicatedStorage:WaitForChild("Funções");
local Eventos = v1:WaitForChild("Eventos");
local NetworkRegistry = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("NetworkRegistry"));

local function isDesktopInterface() -- Line: 18
    -- upvalues: TeamGuiLayout (copy)
    return TeamGuiLayout.GetMode() == "CONSOLE";
end;

local function findButton(p2) -- Line: 22
    -- upvalues: script_Parent (copy)
    local v3 = script_Parent:FindFirstChild(p2);

    if v3 and v3:IsA("GuiObject") then
        return v3;
    end;

    for _, child in script_Parent:GetChildren() do
        if child:IsA("GuiObject") and string.lower(child.Name) == string.lower(p2) then
            return child;
        end;
    end;

    return nil;
end;

local u4 = {
    BreakNeck = {
        action = "Break",
        targetMode = true,
        button = findButton("BreakNeck"),
        key = Enum.KeyCode.Q,
        gamepadKey = Enum.KeyCode.ButtonB,
        remote = Eventos:WaitForChild("BreakNeckRemote"),
        requestRemote = NetworkRegistry.GetEvent("Combat", "BreakNeckRequest"),
        config = require(v1:WaitForChild("BreakNeckConfig"))
    },
    BloodDrink = {
        action = "Bite",
        targetMode = true,
        button = findButton("DrinkBlood"),
        key = Enum.KeyCode.E,
        gamepadKey = Enum.KeyCode.ButtonY,
        remote = Eventos:WaitForChild("BloodDrinkRemote"),
        requestRemote = NetworkRegistry.GetEvent("Combat", "BloodDrinkRequest"),
        config = require(v1:WaitForChild("BloodDrinkConfig"))
    },
    HeartRipping = {
        action = "Attack",
        targetMode = true,
        button = findButton("Heart-Ripping"),
        key = Enum.KeyCode.X,
        gamepadKey = Enum.KeyCode.DPadDown,
        remote = Eventos:WaitForChild("HeartRippingRemote"),
        requestRemote = NetworkRegistry.GetEvent("Combat", "HeartRippingRequest"),
        config = require(v1:WaitForChild("HeartRippingConfig"))
    },
    Infect = {
        action = "Infect",
        targetMode = true,
        button = findButton("Infect"),
        key = Enum.KeyCode.R,
        gamepadKey = Enum.KeyCode.DPadRight,
        remote = Eventos:WaitForChild("InfectRemote"),
        requestRemote = NetworkRegistry.GetEvent("Combat", "InfectRequest"),
        config = require(v1:WaitForChild("InfectConfig"))
    },
    Track = {
        targetMode = false,
        button = findButton("Track"),
        key = Enum.KeyCode.F,
        gamepadKey = Enum.KeyCode.DPadLeft,
        remote = Eventos:WaitForChild("VampiricTrackerRemote"),
        config = require(v1:WaitForChild("VampiricTrackerConfig"))
    },
    Hypnosis = {
        action = "Select",
        targetMode = true,
        commandMode = true,
        button = findButton("Hipnose"),
        key = Enum.KeyCode.C,
        gamepadKey = Enum.KeyCode.ButtonR1,
        remote = Eventos:WaitForChild("HypnosisRemote"),
        requestRemote = NetworkRegistry.GetEvent("Combat", "HypnosisRequest"),
        config = require(v1:WaitForChild("HypnosisConfig"))
    },
    BatForm = {
        targetMode = false,
        button = findButton("BatForm"),
        key = Enum.KeyCode.Z,
        remote = Eventos:WaitForChild("BatFormRemote"),
        config = require(v1:WaitForChild("BatFormConfig"))
    }
};
local u5 = {};

local function getEquippedEmptyBloodContainer() -- Line: 104
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;

    if not Character then
        return nil;
    end;

    for _, child in ipairs(Character:GetChildren()) do
        if child:IsA("Tool") and (child.Name == "Cup" or (child.Name == "CUP" or child.Name == "Dish")) then
            return child;
        end;
    end;

    return nil;
end;

for _, v in pairs(u4) do
    if v.button then
        local button = v.button;
        button.Active = true;
        local v6 = {};
        local v7;

        if button:IsA("TextLabel") then
            v7 = button.TextColor3 or nil;
        else
            v7 = nil;
        end;

        v6.textColor = v7;
        local v8;

        if button:IsA("TextLabel") then
            v8 = button.TextTransparency or nil;
        else
            v8 = nil;
        end;

        v6.textTransparency = v8;
        local v9;

        if button:IsA("ImageButton") then
            v9 = button.ImageColor3 or nil;
        else
            v9 = nil;
        end;

        v6.imageColor = v9;
        local v10;

        if button:IsA("ImageButton") then
            v10 = button.ImageTransparency or nil;
        else
            v10 = nil;
        end;

        v6.imageTransparency = v10;
        v6.backgroundColor = button.BackgroundColor3;
        v6.backgroundTransparency = button.BackgroundTransparency;
        local v11;

        if button:IsA("GuiButton") then
            v11 = button.AutoButtonColor or nil;
        else
            v11 = nil;
        end;

        v6.autoButtonColor = v11;
        u5[button] = v6;
        local Coldown = button:FindFirstChild("Coldown");

        if Coldown and Coldown:IsA("TextLabel") then
            Coldown.Active = false;
            Coldown.Visible = false;
            Coldown.Text = "";
        end;
    end;
end;

local Name = Parent.Name;
local u12 = nil;
local u13 = nil;
local u14 = 0;

for _, child in ipairs(workspace:GetChildren()) do
    if child:IsA("Highlight") and (child.Name == "PowerTargetHighlight" and child:GetAttribute("PowerTargetOwner") == Name) then
        child:Destroy();
    end;
end;

local Highlight = Instance.new("Highlight");
Highlight.Name = "PowerTargetHighlight";
Highlight:SetAttribute("PowerTargetOwner", Name);
Highlight.FillColor = Color3.fromRGB(155, 0, 0);
Highlight.FillTransparency = 0.72;
Highlight.OutlineColor = Color3.fromRGB(255, 70, 70);
Highlight.OutlineTransparency = 0;
Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
Highlight.Enabled = false;
Highlight.Parent = workspace;
script.Destroying:Connect(function() -- Line: 160
    -- upvalues: Highlight (copy)
    if Highlight.Parent then
        Highlight:Destroy();
    end;
end);

local function isVampire() -- Line: 166
    -- upvalues: LocalPlayer (copy)
    local v15;

    if LocalPlayer.Team == nil then
        v15 = false;
    else
        v15 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
    end;

    return v15;
end;

local function isInfected() -- Line: 170
    -- upvalues: LocalPlayer (copy)
    local v16;

    if LocalPlayer.Character == nil or LocalPlayer.Character:GetAttribute("VampireInfected") ~= true then
        v16 = false;
    else
        local v17;

        if LocalPlayer.Team == nil then
            v17 = false;
        else
            v17 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
        end;

        v16 = not v17;
    end;

    return v16;
end;

local function isAbilityUnlocked(p18) -- Line: 176
    -- upvalues: LocalPlayer (copy)
    if p18 and (p18.config and p18.config.Enabled == false) then
        return false;
    end;

    local v19 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
    local math_max_ret = math.max(0, v19);
    local v20 = tonumber(p18 and p18.config and p18.config.UnlockYears);

    return v20 == nil and true or v20 <= math_max_ret;
end;

local function now() -- Line: 185
    return workspace:GetServerTimeNow();
end;

local function isUsableCharacter() -- Line: 189
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character;
    local v21;

    if Character then
        v21 = Character:FindFirstChildOfClass("Humanoid");
    else
        v21 = Character;
    end;

    local v22;

    if LocalPlayer.Team == nil then
        v22 = false;
    else
        v22 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
    end;

    local v23, v24;

    if v22 then
        if Character == nil or (v21 == nil or (v21.Health <= 0 or (Character:GetAttribute("Hibernating") == true or (Character:GetAttribute("ActionLocked") == true or (Character:GetAttribute("BatFormActive") == true or Character:GetAttribute("BatFormTransforming") == true))))) then
            v23 = false;
        elseif LocalPlayer:GetAttribute("BloodThirst") == nil or LocalPlayer:GetAttribute("BloodThirst") > 0 then
            v23 = true;
        elseif LocalPlayer.Character == nil or LocalPlayer.Character:GetAttribute("VampireInfected") ~= true then
            v23 = false;
        else
            if LocalPlayer.Team == nil then
                v24 = false;
            else
                v24 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
            end;

            v23 = not v24;
        end;
    else
        if LocalPlayer.Character == nil or LocalPlayer.Character:GetAttribute("VampireInfected") ~= true then
            v23 = false;
        else
            local v25;

            if LocalPlayer.Team == nil then
                v25 = false;
            else
                v25 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
            end;

            v23 = not v25;
        end;

        if v23 then
            if Character == nil or (v21 == nil or (v21.Health <= 0 or (Character:GetAttribute("Hibernating") == true or (Character:GetAttribute("ActionLocked") == true or (Character:GetAttribute("BatFormActive") == true or Character:GetAttribute("BatFormTransforming") == true))))) then
                v23 = false;
            elseif LocalPlayer:GetAttribute("BloodThirst") == nil or LocalPlayer:GetAttribute("BloodThirst") > 0 then
                v23 = true;
            elseif LocalPlayer.Character == nil or LocalPlayer.Character:GetAttribute("VampireInfected") ~= true then
                v23 = false;
            else
                if LocalPlayer.Team == nil then
                    v24 = false;
                else
                    v24 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
                end;

                v23 = not v24;
            end;
        end;
    end;

    return v23;
end;

local function restoreButton(p26) -- Line: 205
    -- upvalues: u5 (copy)
    local button = p26.button;
    local v27;

    if button then
        v27 = u5[button];
    else
        v27 = button;
    end;

    if not (button and v27) then
        return;
    end;

    button.Active = true;

    if button:IsA("GuiButton") then
        button.AutoButtonColor = v27.autoButtonColor == true;
    end;

    if button:IsA("TextLabel") and v27.textColor then
        button.TextColor3 = v27.textColor;
        button.TextTransparency = v27.textTransparency or 0;
    elseif button:IsA("ImageButton") and v27.imageColor then
        button.ImageColor3 = v27.imageColor;
        button.ImageTransparency = v27.imageTransparency or 0;
    end;

    button.BackgroundColor3 = v27.backgroundColor;
    button.BackgroundTransparency = v27.backgroundTransparency;
    button:SetAttribute("PowerCooldown", 0);
end;

local function darkenButton(p28, p29) -- Line: 227
    -- upvalues: u5 (copy)
    local button = p28.button;
    local v30;

    if button then
        v30 = u5[button];
    else
        v30 = button;
    end;

    if not (button and v30) then
        return;
    end;

    button.Active = false;

    if button:IsA("GuiButton") then
        button.AutoButtonColor = false;
    end;

    if button:IsA("TextLabel") and v30.textColor then
        button.TextColor3 = v30.textColor:Lerp(Color3.new(0, 0, 0), 0.62);
        button.TextTransparency = math.min(0.82, (v30.textTransparency or 0) + 0.25);
    elseif button:IsA("ImageButton") and v30.imageColor then
        button.ImageColor3 = v30.imageColor:Lerp(Color3.new(0, 0, 0), 0.58);
        button.ImageTransparency = math.min(0.85, (v30.imageTransparency or 0) + 0.08);
    end;

    button.BackgroundColor3 = v30.backgroundColor:Lerp(Color3.new(0, 0, 0), 0.58);
    button.BackgroundTransparency = v30.backgroundTransparency;
    local v31 = p29 - workspace:GetServerTimeNow();
    button:SetAttribute("PowerCooldown", (math.max(0, v31)));
end;

local function clearHighlight() -- Line: 336
    -- upvalues: Highlight (copy), u12 (ref)
    Highlight.Adornee = nil;
    Highlight.Enabled = false;
    u12 = nil;
end;

local function findCharacterModel(p32) -- Line: 342
    while p32 and p32 ~= workspace do
        if p32:IsA("Model") and p32:FindFirstChildOfClass("Humanoid") then
            return p32;
        end;

        p32 = p32.Parent;
    end;

    return nil;
end;

local function isTargetEligible(p33, p34) -- Line: 353
    -- upvalues: LocalPlayer (copy), Players (copy), u4 (copy)
    if not p34 or p34 == LocalPlayer.Character then
        return false;
    end;

    if p34:GetAttribute("Invulnerable") == true or p34:GetAttribute("QuestNPC") == true then
        return false;
    end;

    local v35 = p34:FindFirstChildOfClass("Humanoid");
    local HumanoidRootPart = p34:FindFirstChild("HumanoidRootPart");
    local v36 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart");

    if not (v35 and (v35.Health > 0 and (HumanoidRootPart and v36))) then
        return false;
    end;

    if p34:GetAttribute("ActionLocked") or (p34:GetAttribute("Hibernating") or p34:GetAttribute("BreakNeckRecovering")) then
        return false;
    end;

    if (HumanoidRootPart.Position - v36.Position).Magnitude > p33.config.MaximumDistance + 2 then
        return false;
    end;

    local PlayerFromCharacter = Players:GetPlayerFromCharacter(p34);
    local v37 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
    local math_max_ret = math.max(0, v37);

    if PlayerFromCharacter then
        local v38 = PlayerFromCharacter.Team and PlayerFromCharacter.Team.Name;
        local v39 = tonumber(PlayerFromCharacter:GetAttribute("Years")) or 0;
        local math_max_ret2 = math.max(0, v39);
        local v40 = v38 == "Humans" and true or v38 == "Witches";

        if p33 == u4.HeartRipping then
            return (v40 or ((v38 == "VampireHunter" or v38 == "Vampires") and true or v38 == "Cannibal Raised")) and math_max_ret2 < math_max_ret;
        end;

        if p33 == u4.BloodDrink then
            if v40 then
                return true;
            end;

            local v41;

            if (v38 == "Vampires" or v38 == "Cannibal Raised") and p33.config.VampireTargetMinimumYears <= math_max_ret then
                v41 = math_max_ret2 < math_max_ret;
            else
                v41 = false;
            end;

            return v41;
        end;

        if p33 == u4.Infect or p33 == u4.Hypnosis then
            return v40;
        end;

        if p33 == u4.BreakNeck and (v38 == "Vampires" or v38 == "Cannibal Raised") then
            return math_max_ret2 <= math_max_ret;
        end;

        return v40 or ((v38 == "Vampires" or v38 == "Cannibal Raised") and true or v38 == "Werewolfs");
    end;

    local v42 = (p34:GetAttribute("IsVampire") == true or p34:GetAttribute("Team") == "Vampires") and true or p34:GetAttribute("Team") == "Cannibal Raised";
    local v43 = tonumber(p34:GetAttribute("Years")) or 0;
    local math_max_ret2 = math.max(0, v43);

    if p33 == u4.HeartRipping then
        local v44;

        if p34:GetAttribute("Team") == "Werewolfs" then
            v44 = false;
        else
            v44 = math_max_ret2 < math_max_ret;
        end;

        return v44;
    end;

    if p33 == u4.BloodDrink then
        if not v42 then
            return p34:GetAttribute("Team") ~= "Werewolfs";
        end;

        local v45;

        if p33.config.VampireTargetMinimumYears <= math_max_ret then
            v45 = math_max_ret2 < math_max_ret;
        else
            v45 = false;
        end;

        return v45;
    end;

    if p33 == u4.BreakNeck and v42 then
        return math_max_ret2 <= math_max_ret;
    end;

    if p33 == u4.Hypnosis then
        local v46;

        if p34:GetAttribute("IsVampire") == true or (p34:GetAttribute("Team") == "Vampires" or p34:GetAttribute("Team") == "Cannibal Raised") then
            v46 = false;
        else
            v46 = p34:GetAttribute("Team") ~= "Werewolfs";
        end;

        return v46;
    end;

    if p33 == u4.Infect then
        local v47;

        if p34:GetAttribute("VampireInfected") == true or (p34:GetAttribute("IsVampire") == true or p34:GetAttribute("Team") == "Vampires") then
            v47 = false;
        else
            v47 = p34:GetAttribute("Team") ~= "Cannibal Raised";
        end;

        return v47;
    end;

    if p33 ~= u4.BloodDrink then
        return true;
    end;

    local v48;

    if p34:GetAttribute("IsVampire") == true or p34:GetAttribute("Team") == "Vampires" then
        v48 = false;
    else
        v48 = p34:GetAttribute("Team") ~= "Cannibal Raised";
    end;

    return v48;
end;

local function findClosestTargetInFront(p49) -- Line: 439
    -- upvalues: LocalPlayer (copy), isTargetEligible (copy)
    local Character = LocalPlayer.Character;
    local v50;

    if Character then
        v50 = Character:FindFirstChild("HumanoidRootPart");
    else
        v50 = Character;
    end;

    if not v50 then
        return nil;
    end;

    local v51 = tonumber(p49.config.MaximumDistance) or 10;
    local RaycastParams_new_ret = RaycastParams.new();
    RaycastParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
    RaycastParams_new_ret.FilterDescendantsInstances = { Character };
    RaycastParams_new_ret.IgnoreWater = true;
    local v52 = (1 / 0);
    local v53 = nil;

    for _, descendant in workspace:GetDescendants() do
        if descendant:IsA("Humanoid") then
            local Parent2 = descendant.Parent;
            local v54;

            if Parent2 then
                v54 = Parent2:FindFirstChild("HumanoidRootPart");
            else
                v54 = Parent2;
            end;

            if Parent2 and (v54 and isTargetEligible(p49, Parent2)) then
                local v55 = v54.Position - v50.Position;
                local Vector3_new_ret = Vector3.new(v55.X, 0, v55.Z);
                local Magnitude = v55.Magnitude;

                if Magnitude > 0.05 and (Magnitude <= v51 + 2 and (Vector3_new_ret.Magnitude > 0.05 and (v50.CFrame.LookVector:Dot(Vector3_new_ret.Unit) >= 0 and Magnitude < v52))) then
                    local v56 = v50.Position + Vector3.new(0, 1.25, 0);
                    local v57 = workspace:Raycast(v56, v54.Position + Vector3.new(0, 1, 0) - v56, RaycastParams_new_ret);

                    if not v57 or v57.Instance:IsDescendantOf(Parent2) then
                        v53 = Parent2;
                        v52 = Magnitude;
                    end;
                end;
            end;
        end;
    end;

    return v53;
end;

local function updateHighlight() -- Line: 481
    -- upvalues: u13 (ref), Highlight (copy), u12 (ref), findCharacterModel (copy), LocalPlayer (copy), isTargetEligible (copy)
    if not (u13 and u13.ability) then
        Highlight.Adornee = nil;
        Highlight.Enabled = false;
        u12 = nil;

        return;
    end;

    if workspace:GetServerTimeNow() >= u13.endTime then
        u13 = nil;
        Highlight.Adornee = nil;
        Highlight.Enabled = false;
        u12 = nil;

        return;
    end;

    local v58 = findCharacterModel(LocalPlayer:GetMouse().Target);

    if isTargetEligible(u13.ability, v58) then
        u12 = v58;
        Highlight.Adornee = v58;
        Highlight.Enabled = true;

        return;
    end;

    Highlight.Adornee = nil;
    Highlight.Enabled = false;
    u12 = nil;
end;

local function resetSelection() -- Line: 502
    -- upvalues: u14 (ref), u13 (ref), Highlight (copy), u12 (ref), u4 (copy), restoreButton (copy)
    u14 = u14 + 1;
    u13 = nil;
    Highlight.Adornee = nil;
    Highlight.Enabled = false;
    u12 = nil;

    for _, v in pairs(u4) do
        if v.button then
            restoreButton(v);
        end;

        v.cooldownEnd = 0;
        v.awaitingSelection = false;
        v.awaitingActivation = false;
        v.pendingAutoTarget = nil;
    end;
end;

local function activateTrack(u59) -- Line: 517
    -- upvalues: isUsableCharacter (copy), darkenButton (copy), restoreButton (copy)
    if not isUsableCharacter() or workspace:GetServerTimeNow() < (u59.cooldownEnd or 0) then
        return;
    end;

    local u60 = workspace:GetServerTimeNow() + u59.config.HighlightDuration + u59.config.Cooldown;
    u59.cooldownEnd = u60;
    darkenButton(u59, u60);
    u59.awaitingActivation = true;
    u59.remote:FireServer("UI");
    task.delay(1.5, function() -- Line: 526
        -- upvalues: u59 (copy), u60 (copy), restoreButton (ref)
        if u59.awaitingActivation and workspace:GetServerTimeNow() < u60 then
            u59.awaitingActivation = false;
            u59.cooldownEnd = 0;
            restoreButton(u59);
        end;
    end);
end;

local function beginTargetAbility(u61) -- Line: 535
    -- upvalues: isUsableCharacter (copy), u13 (ref), u4 (copy), getEquippedEmptyBloodContainer (copy), findClosestTargetInFront (copy), darkenButton (copy)
    if not isUsableCharacter() or workspace:GetServerTimeNow() < (u61.cooldownEnd or 0) then
        return;
    end;

    if u13 then
        return;
    end;

    local v62 = u61 == u4.BloodDrink and getEquippedEmptyBloodContainer();

    if v62 then
        (u61.requestRemote or u61.remote):FireServer("FillContainer", v62);

        return;
    end;

    local v63 = findClosestTargetInFront(u61);

    if not v63 then
        if u61.action == "Attack" then
            print("[HeartRipping Client] Nenhum alvo automático encontrado na frente.");
        end;

        return;
    end;

    if u61.action == "Attack" then
        print("[HeartRipping Client] Alvo encontrado:", v63.Name);
    end;

    local Cooldown = u61.config.Cooldown;

    if u61.commandMode then
        Cooldown = Cooldown + u61.config.CommandTime;
    end;

    u61.cooldownEnd = workspace:GetServerTimeNow() + Cooldown;
    u61.awaitingSelection = false;
    u61.pendingAutoTarget = nil;
    u61.directActivation = true;
    darkenButton(u61, u61.cooldownEnd);
    local v64 = u61.requestRemote or u61.remote;
    v64:FireServer("Begin", "UI");
    v64:FireServer(u61.action, v63, "UI");
    task.delay(2, function() -- Line: 582
        -- upvalues: u61 (copy)
        u61.directActivation = false;
    end);
end;

local function activate(p65) -- Line: 587
    -- upvalues: TeamGuiLayout (copy), Parent (copy), LocalPlayer (copy), u4 (copy), beginTargetAbility (copy), activateTrack (copy)
    if TeamGuiLayout.GetMode() ~= "CONSOLE" or not (p65 and (p65.button and Parent.Visible)) then
        return;
    end;

    local v66;

    if LocalPlayer.Character == nil or LocalPlayer.Character:GetAttribute("VampireInfected") ~= true then
        v66 = false;
    else
        local v67;

        if LocalPlayer.Team == nil then
            v67 = false;
        else
            v67 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
        end;

        v66 = not v67;
    end;

    if v66 then
        if p65 ~= u4.BloodDrink then
            return;
        end;
    else
        local v68;

        if LocalPlayer.Team == nil then
            v68 = false;
        else
            v68 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
        end;

        if not v68 then
            return;
        end;

        local v69;

        if p65 and (p65.config and p65.config.Enabled == false) then
            v69 = false;
        else
            local v70 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
            local math_max_ret = math.max(0, v70);
            local v71 = tonumber(p65 and p65.config and p65.config.UnlockYears);
            v69 = v71 == nil and true or v71 <= math_max_ret;
        end;

        if not v69 then
            return;
        end;
    end;

    if p65.targetMode then
        beginTargetAbility(p65);

        return;
    end;

    activateTrack(p65);
end;

ContextActionService:BindActionAtPriority("VampireBreakNeckGamepad", function(p72, p73) -- Line: 613
    -- upvalues: TeamGuiLayout (copy), Parent (copy), LocalPlayer (copy), UserInputService (copy), GuiService (copy), activate (copy), u4 (copy)
    if TeamGuiLayout.GetMode() == "CONSOLE" and Parent.Visible then
        local v74;

        if LocalPlayer.Team == nil then
            v74 = false;
        else
            v74 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
        end;

        if v74 and not (UserInputService:GetFocusedTextBox() or GuiService.SelectedObject) then
            if p73 == Enum.UserInputState.Begin then
                activate(u4.BreakNeck);
            end;

            return Enum.ContextActionResult.Sink;
        end;
    end;

    return Enum.ContextActionResult.Pass;
end, false, 4500, Enum.KeyCode.ButtonB);

local function updateBatFormLockDisplay(p75) -- Line: 317
    -- upvalues: u4 (copy), LocalPlayer (copy), darkenButton (copy), now (copy)
    local button = u4.BatForm.button;

    if not button then
        return;
    end;

    local v76;

    if u4.BatForm.config.Enabled == false then
        v76 = false;
    else
        if LocalPlayer.Team == nil then
            v76 = false;
        else
            v76 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
        end;

        if v76 then
            local v77;

            if LocalPlayer.Character == nil or LocalPlayer.Character:GetAttribute("VampireInfected") ~= true then
                v77 = false;
            else
                local v78;

                if LocalPlayer.Team == nil then
                    v78 = false;
                else
                    v78 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
                end;

                v77 = not v78;
            end;

            v76 = not v77;
        end;
    end;

    button.Visible = v76;
    local UnlockRequirement = button:FindFirstChild("UnlockRequirement");

    if UnlockRequirement and UnlockRequirement:IsA("TextLabel") then
        UnlockRequirement.Text = "+" .. tostring(u4.BatForm.config and u4.BatForm.config.UnlockYears or 300);
        UnlockRequirement.Visible = not p75;
    end;

    if not p75 then
        darkenButton(u4.BatForm, now());
    end;
end;

local function updateBreakNeckLockDisplay(p79) -- Line: 249
    -- upvalues: u4 (copy), darkenButton (copy), now (copy)
    local button = u4.BreakNeck.button;

    if not button then
        return;
    end;

    button.Visible = true;
    local UnlockRequirement = button:FindFirstChild("UnlockRequirement");

    if UnlockRequirement and UnlockRequirement:IsA("TextLabel") then
        UnlockRequirement.Text = "+" .. tostring(u4.BreakNeck.config and u4.BreakNeck.config.UnlockYears or 2);
        UnlockRequirement.Visible = not p79;
    end;

    if not p79 then
        darkenButton(u4.BreakNeck, now());
    end;
end;

local function updateInfectLockDisplay(p80) -- Line: 266
    -- upvalues: u4 (copy), darkenButton (copy), now (copy)
    local button = u4.Infect.button;

    if not button then
        return;
    end;

    button.Visible = true;
    local UnlockRequirement = button:FindFirstChild("UnlockRequirement");

    if UnlockRequirement and UnlockRequirement:IsA("TextLabel") then
        UnlockRequirement.Text = "+" .. tostring(u4.Infect.config and u4.Infect.config.UnlockYears or 150);
        UnlockRequirement.Visible = not p80;
    end;

    if not p80 then
        darkenButton(u4.Infect, now());
    end;
end;

local function updateHypnosisLockDisplay(p81) -- Line: 300
    -- upvalues: u4 (copy), darkenButton (copy), now (copy)
    local button = u4.Hypnosis.button;

    if not button then
        return;
    end;

    button.Visible = true;
    local UnlockRequirement = button:FindFirstChild("UnlockRequirement");

    if UnlockRequirement and UnlockRequirement:IsA("TextLabel") then
        UnlockRequirement.Text = "+" .. tostring(u4.Hypnosis.config and u4.Hypnosis.config.UnlockYears or 15);
        UnlockRequirement.Visible = not p81;
    end;

    if not p81 then
        darkenButton(u4.Hypnosis, now());
    end;
end;

local function updateHeartRippingLockDisplay(p82) -- Line: 283
    -- upvalues: u4 (copy), darkenButton (copy), now (copy)
    local button = u4.HeartRipping.button;

    if not button then
        return;
    end;

    button.Visible = true;
    local UnlockRequirement = button:FindFirstChild("UnlockRequirement");

    if UnlockRequirement and UnlockRequirement:IsA("TextLabel") then
        UnlockRequirement.Text = "+" .. tostring(u4.HeartRipping.config and u4.HeartRipping.config.UnlockYears or 100);
        UnlockRequirement.Visible = not p82;
    end;

    if not p82 then
        darkenButton(u4.HeartRipping, now());
    end;
end;

for _, v in pairs(u4) do
    if v.button then
        local button = v.button;
        button.Active = true;

        if button:IsA("GuiButton") then
            button.Activated:Connect(function() -- Line: 629
                -- upvalues: activate (copy), v (copy)
                activate(v);
            end);
        else
            button.InputBegan:Connect(function(p83) -- Line: 633
                -- upvalues: activate (copy), v (copy)
                if p83.UserInputType == Enum.UserInputType.MouseButton1 or p83.UserInputType == Enum.UserInputType.Touch then
                    activate(v);
                end;
            end);
        end;
    end;

    if v.targetMode then
        v.remote.OnClientEvent:Connect(function(p84, p85) -- Line: 644
            -- upvalues: TeamGuiLayout (copy), u13 (ref), Highlight (copy), u12 (ref), v (copy), darkenButton (copy), restoreButton (copy), u14 (ref), isTargetEligible (copy), findClosestTargetInFront (copy), updateHighlight (copy)
            if TeamGuiLayout.GetMode() ~= "CONSOLE" then
                return;
            end;

            if p84 == "ContainerStarted" then
                u13 = nil;
                Highlight.Adornee = nil;
                Highlight.Enabled = false;
                u12 = nil;
                v.cooldownEnd = tonumber(p85) or workspace:GetServerTimeNow() + 6;
                darkenButton(v, v.cooldownEnd);

                return;
            end;

            if p84 == "ContainerEnded" then
                u13 = nil;
                Highlight.Adornee = nil;
                Highlight.Enabled = false;
                u12 = nil;
                v.cooldownEnd = 0;
                restoreButton(v);

                return;
            end;

            if p84 ~= "SelectionStarted" then
                if p84 == "SelectionEnded" then
                    if v.commandMode and tonumber(p85) then
                        v.cooldownEnd = tonumber(p85);
                        darkenButton(v, v.cooldownEnd);
                    end;

                    if u13 and u13.ability == v then
                        u13 = nil;
                        Highlight.Adornee = nil;
                        Highlight.Enabled = false;
                        u12 = nil;
                    end;

                    if workspace:GetServerTimeNow() >= (v.cooldownEnd or 0) then
                        restoreButton(v);

                        return;
                    end;
                else
                    if p84 == "InvalidTarget" then
                        if u13 and u13.ability == v then
                            updateHighlight();
                        end;

                        v.cooldownEnd = 0;
                        restoreButton(v);

                        return;
                    end;

                    if p84 == "CooldownUpdated" and tonumber(p85) then
                        v.cooldownEnd = tonumber(p85);
                        darkenButton(v, v.cooldownEnd);
                    end;
                end;

                return;
            end;

            if v.directActivation then
                v.directActivation = false;

                return;
            end;

            v.awaitingSelection = false;
            u13 = {
                ability = v,
                endTime = tonumber(p85) or workspace:GetServerTimeNow() + v.config.SelectionTime,
                token = u14
            };
            local pendingAutoTarget = v.pendingAutoTarget;
            v.pendingAutoTarget = nil;

            if not isTargetEligible(v, pendingAutoTarget) then
                pendingAutoTarget = findClosestTargetInFront(v);
            end;

            if not pendingAutoTarget then
                u13 = nil;
                Highlight.Adornee = nil;
                Highlight.Enabled = false;
                u12 = nil;
                restoreButton(v);

                return;
            end;

            u13 = nil;
            Highlight.Adornee = nil;
            Highlight.Enabled = false;
            u12 = nil;
            local Cooldown = v.config.Cooldown;

            if v.commandMode then
                Cooldown = Cooldown + v.config.CommandTime;
            end;

            v.cooldownEnd = workspace:GetServerTimeNow() + Cooldown;
            darkenButton(v, v.cooldownEnd);
            (v.requestRemote or v.remote):FireServer(v.action, pendingAutoTarget, "UI");
        end);
    else
        v.remote.OnClientEvent:Connect(function(p86, p87, p88) -- Line: 714
            -- upvalues: TeamGuiLayout (copy), v (copy), darkenButton (copy)
            if TeamGuiLayout.GetMode() ~= "CONSOLE" then
                return;
            end;

            if p86 == "Activated" then
                v.awaitingActivation = false;
                local v89 = tonumber(p88) or tonumber(p87);

                if v89 then
                    v.cooldownEnd = v89;
                end;

                darkenButton(v, v.cooldownEnd);
            end;
        end);
    end;
end;

UserInputService.InputBegan:Connect(function(p90, p91) -- Line: 728
    -- upvalues: TeamGuiLayout (copy), UserInputService (copy), u4 (copy), activate (copy)
    if TeamGuiLayout.GetMode() ~= "CONSOLE" or (p91 or UserInputService:GetFocusedTextBox()) then
        return;
    end;

    if p90.KeyCode == Enum.KeyCode.ButtonB then
        return;
    end;

    for _, v in pairs(u4) do
        if p90.KeyCode == v.key or p90.KeyCode == v.gamepadKey then
            activate(v);

            return;
        end;
    end;
end);
UserInputService.InputBegan:Connect(function(p92, p93) -- Line: 742
    -- upvalues: u13 (ref), u12 (ref), isTargetEligible (copy), Highlight (copy), darkenButton (copy)
    if p93 or p92.UserInputType ~= Enum.UserInputType.MouseButton1 then
        return;
    end;

    if not (u13 and (u13.ability and workspace:GetServerTimeNow() <= u13.endTime)) then
        return;
    end;

    local ability = u13.ability;
    local v94 = u12;

    if not (v94 and isTargetEligible(ability, v94)) then
        return;
    end;

    u13 = nil;
    Highlight.Adornee = nil;
    Highlight.Enabled = false;
    u12 = nil;
    ability.awaitingSelection = false;
    local Cooldown = ability.config.Cooldown;

    if ability.commandMode then
        Cooldown = Cooldown + ability.config.CommandTime;
    end;

    ability.cooldownEnd = workspace:GetServerTimeNow() + Cooldown;
    darkenButton(ability, ability.cooldownEnd);
    (ability.requestRemote or ability.remote):FireServer(ability.action, v94, "UI");
end);
local u95 = 0;
RunService.RenderStepped:Connect(function(p96) -- Line: 768
    -- upvalues: u95 (ref), TeamGuiLayout (copy), LocalPlayer (copy), resetSelection (copy), u4 (copy), u13 (ref), Highlight (copy), u12 (ref), restoreButton (copy), updateHighlight (copy), darkenButton (copy), updateBreakNeckLockDisplay (copy), updateInfectLockDisplay (copy), updateHypnosisLockDisplay (copy), updateHeartRippingLockDisplay (copy), updateBatFormLockDisplay (copy)
    u95 = u95 + p96;

    if u95 < 0.05 then
        return;
    end;

    u95 = 0;
    local v97 = TeamGuiLayout.GetMode() == "CONSOLE";

    if v97 then
        if LocalPlayer.Team == nil then
            v97 = false;
        else
            v97 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
        end;

        if not v97 then
            if LocalPlayer.Character == nil or LocalPlayer.Character:GetAttribute("VampireInfected") ~= true then
                v97 = false;
            else
                local v98;

                if LocalPlayer.Team == nil then
                    v98 = false;
                else
                    v98 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
                end;

                v97 = not v98;
            end;
        end;
    end;

    if not v97 then
        resetSelection();

        return;
    end;

    local BreakNeck = u4.BreakNeck;
    local v99;

    if BreakNeck and (BreakNeck.config and BreakNeck.config.Enabled == false) then
        v99 = false;
    else
        local v100 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
        local math_max_ret = math.max(0, v100);
        local v101 = tonumber(BreakNeck and BreakNeck.config and BreakNeck.config.UnlockYears);
        v99 = v101 == nil and true or v101 <= math_max_ret;
    end;

    if u4.BreakNeck.button then
        u4.BreakNeck.button.Visible = true;
    end;

    if not (v99 or (not u13 or u13.ability ~= u4.BreakNeck)) then
        u13 = nil;
        Highlight.Adornee = nil;
        Highlight.Enabled = false;
        u12 = nil;
        u4.BreakNeck.awaitingSelection = false;
        restoreButton(u4.BreakNeck);
    end;

    local Infect = u4.Infect;
    local v102;

    if Infect and (Infect.config and Infect.config.Enabled == false) then
        v102 = false;
    else
        local v103 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
        local math_max_ret = math.max(0, v103);
        local v104 = tonumber(Infect and Infect.config and Infect.config.UnlockYears);
        v102 = v104 == nil and true or v104 <= math_max_ret;
    end;

    if u4.Infect.button then
        u4.Infect.button.Visible = true;
    end;

    if not (v102 or (not u13 or u13.ability ~= u4.Infect)) then
        u13 = nil;
        Highlight.Adornee = nil;
        Highlight.Enabled = false;
        u12 = nil;
        u4.Infect.awaitingSelection = false;
        restoreButton(u4.Infect);
    end;

    local Hypnosis = u4.Hypnosis;
    local v105;

    if Hypnosis and (Hypnosis.config and Hypnosis.config.Enabled == false) then
        v105 = false;
    else
        local v106 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
        local math_max_ret = math.max(0, v106);
        local v107 = tonumber(Hypnosis and Hypnosis.config and Hypnosis.config.UnlockYears);
        v105 = v107 == nil and true or v107 <= math_max_ret;
    end;

    if u4.Hypnosis.button then
        u4.Hypnosis.button.Visible = true;
    end;

    if not (v105 or (not u13 or u13.ability ~= u4.Hypnosis)) then
        u13 = nil;
        Highlight.Adornee = nil;
        Highlight.Enabled = false;
        u12 = nil;
        u4.Hypnosis.awaitingSelection = false;
        restoreButton(u4.Hypnosis);
    end;

    local BatForm = u4.BatForm;
    local v108;

    if BatForm and (BatForm.config and BatForm.config.Enabled == false) then
        v108 = false;
    else
        local v109 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
        local math_max_ret = math.max(0, v109);
        local v110 = tonumber(BatForm and BatForm.config and BatForm.config.UnlockYears);
        v108 = v110 == nil and true or v110 <= math_max_ret;
    end;

    if u4.BatForm.button then
        local button = u4.BatForm.button;
        local v111;

        if LocalPlayer.Team == nil then
            v111 = false;
        else
            v111 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
        end;

        if v111 then
            local v112;

            if LocalPlayer.Character == nil or LocalPlayer.Character:GetAttribute("VampireInfected") ~= true then
                v112 = false;
            else
                local v113;

                if LocalPlayer.Team == nil then
                    v113 = false;
                else
                    v113 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
                end;

                v112 = not v113;
            end;

            v111 = not v112;
        end;

        button.Visible = v111;
    end;

    local HeartRipping = u4.HeartRipping;
    local v114;

    if HeartRipping and (HeartRipping.config and HeartRipping.config.Enabled == false) then
        v114 = false;
    else
        local v115 = tonumber(LocalPlayer:GetAttribute("Years")) or 0;
        local math_max_ret = math.max(0, v115);
        local v116 = tonumber(HeartRipping and HeartRipping.config and HeartRipping.config.UnlockYears);
        v114 = v116 == nil and true or v116 <= math_max_ret;
    end;

    if u4.HeartRipping.button then
        u4.HeartRipping.button.Visible = true;
    end;

    if not (v114 or (not u13 or u13.ability ~= u4.HeartRipping)) then
        u13 = nil;
        Highlight.Adornee = nil;
        Highlight.Enabled = false;
        u12 = nil;
        u4.HeartRipping.awaitingSelection = false;
        restoreButton(u4.HeartRipping);
    end;

    updateHighlight();
    local ServerTimeNow = workspace:GetServerTimeNow();

    for _, v in pairs(u4) do
        if v.button then
            local Coldown = v.button:FindFirstChild("Coldown");

            if v.cooldownEnd and (v.cooldownEnd > 0 and ServerTimeNow < v.cooldownEnd) then
                local math_ceil_ret = math.ceil(v.cooldownEnd - ServerTimeNow);
                v.button:SetAttribute("PowerCooldown", math_ceil_ret);

                if Coldown and Coldown:IsA("TextLabel") then
                    Coldown.Text = tostring(math_ceil_ret);
                    Coldown.Visible = true;
                end;

                darkenButton(v, v.cooldownEnd);
            else
                if Coldown and Coldown:IsA("TextLabel") then
                    Coldown.Text = "";
                    Coldown.Visible = false;
                end;

                if not (v.awaitingSelection or (v.awaitingActivation or u13 and u13.ability == v)) then
                    v.cooldownEnd = 0;
                    restoreButton(v);
                end;
            end;
        end;
    end;

    updateBreakNeckLockDisplay(v99);
    updateInfectLockDisplay(v102);
    updateHypnosisLockDisplay(v105);
    updateHeartRippingLockDisplay(v114);
    updateBatFormLockDisplay(v108);
    local v117;

    if LocalPlayer.Character == nil or LocalPlayer.Character:GetAttribute("VampireInfected") ~= true then
        v117 = false;
    else
        local v118;

        if LocalPlayer.Team == nil then
            v118 = false;
        else
            v118 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
        end;

        v117 = not v118;
    end;

    for _, v in pairs(u4) do
        if v.button then
            v.button.Visible = not v117 or v == u4.BloodDrink;
        end;
    end;
end);
LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function() -- Line: 872
    -- upvalues: LocalPlayer (copy), resetSelection (copy)
    local v119;

    if LocalPlayer.Team == nil then
        v119 = false;
    else
        v119 = LocalPlayer.Team.Name == "Vampires" and true or LocalPlayer.Team.Name == "Cannibal Raised";
    end;

    if not v119 then
        resetSelection();
    end;
end);
LocalPlayer.CharacterAdded:Connect(function() -- Line: 879
    -- upvalues: resetSelection (copy)
    resetSelection();
    task.defer(function() -- Line: 881
    end);
end);